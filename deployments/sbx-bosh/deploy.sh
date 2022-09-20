#!/bin/bash
#
# script: deployments/sbx-bosh/deploy.sh
#
# BOSH script that creates the Sandbox BOSH
#

set -euo pipefail

# Mandatory working directory check.
# See README for more information.
RED='\e[31m'; RESET='\e[0m';
if [ ! -d "./scripts" ]; then
    >&2 printf "\n${RED}You must be in the repository root to execute bcp scripts!\n\n${RESET}"
    exit 1
fi

# Includes
. ./scripts/.functions/common.sh

# Check if a BOSH Director is targeted
if [[ -z $TARGET_DIRECTOR ]]; then
    printf "\n${YELLOW}${BOLD}You must select a Director before proceeding...\n${RESET}"
    printf "${YELLOW}${BOLD}Run the following command to select a Director:\n\n${RESET}"
    printf "./script/select-director.sh"
    exit 1
fi

set +e # 'dialog' uses the stderr stream to pass info
dialog --output-fd 1 \
    --backtitle "BOSH Control Plane" \
    --colors \
    --defaultno \
    --yesno "You are currently targeting: \Zb\Z1$TARGET_DIRECTOR\Zn\n\nIs this correct?" 10 60

if [[ $? -ne 0 ]]; then
    clear
    printf "${BOLD}Then please run the following command to select the desired Director:\n\n${RESET}"
    printf "./script/select-director.sh\n\n"
    exit 1
else
    clear
fi
set -e

printf "\nTarget Director name: ${BOLD}${TARGET_DIRECTOR}${RESET}\n\n\n"

# Check if the user environment is initialized
. ./scripts/.functions/user-env-init.sh "$TARGET_DIRECTOR" "true"
if [ ! $? -eq 0 ]; then
    >&2 printf "${RED}User environment could not be initialized.\n${RESET}"
    >&2 printf "${RED}Please see README.md for the prerequisites.\n\n${RESET}"
    exit 1
fi

if [[ ! -d clones/bosh-deployment ]]; then
    git clone https://github.com/cloudfoundry/bosh-deployment.git clones/bosh-deployment
fi

bosh -e $TARGET_DIRECTOR -d sbx-bosh deploy clones/bosh-deployment/bosh.yml \
    -v director_name="sbx-bosh" \
    -v internal_ip="10.64.152.134" \
    -v internal_gw="10.64.152.129" \
    -v internal_cidr="10.64.152.128/27" \
    -o clones/bosh-deployment/vsphere/cpi.yml \
        -v network_name="nnn-sbx-infra.nnn1.osl.zzz.net" \
        -v vcenter_dc="CAP-ppp" \
        -v vcenter_cluster="nnn-Hybrid-OSL-MGMT-C01" \
        -v vcenter_ds="^(nnn\\-mgmt\\-std\\-dual\\-osl3\\-3par05\\-L00|nnn\\-san\\-std\\-dual\\-osl3\\-3par05\\-L00|nnn\\-san\\-std\\-single\\-osl3\\-3par05\\-L00|nnn\\-san\\-std\\-single\\-osl5\\-3par06\\-L00)$" \
        -v vcenter_ip="10.76.38.4" \
        -v vcenter_user="$(vault kv get -field=iaas-vcenter-user platform/credentials)" \
        -v vcenter_password="$(vault kv get -field=iaas-vcenter-password platform/credentials)" \
        -v vcenter_templates="sbx-bosh-templates" \
        -v vcenter_vms="sbx-bosh-vms" \
        -v vcenter_disks="sbx-bosh-disks" \
    -o clones/bosh-deployment/uaa.yml \
    -o clones/bosh-deployment/credhub.yml \
    -o clones/bosh-deployment/jumpbox-user.yml \
    -o clones/bosh-deployment/misc/trusted-certs.yml \
        --var-file trusted_ca_cert=blobs/.pem \
    -o clones/bosh-deployment/misc/ntp.yml \
        -v internal_ntp='["", ""]' \
    -o ops/add-trusted-ca-certs-to-director-vm.yml \
        --var-file director_vm_trusted_ca_certs=blobs/.pem \
    -o ops/use-zzz-dns.yml \
    -o ops/change-deployment-name.yml \
        -v deployment_name="sbx-bosh" \
    -o ops/.yml \
        -v ldap_bind_dn="$(vault kv get -field=ldap-sbx-bosh-bind-dn platform/credentials)" \
        -v ldap_bind_password="$(vault kv get -field=ldap-sbx-bosh-bind-password platform/credentials)" \
    -o ops/sbx-bosh/uaa-external-group-mappings.yml \
    -o ops/sbx-bosh/uaa-use-external-linked-db.yml \
    -o ops/sbx-bosh/modify-for-deployment-by-bosh.yml

if [ $? -eq 0 ]; then

    # Create a dummy 'state.json' for use by the select-director.sh script
    printf "{\n"                                >  deployments/sbx-bosh/state.json
    printf "  \"deployed\": \"true\",\n"        >> deployments/sbx-bosh/state.json
    printf "  \"director\": \"$TARGET_BOSH\"\n" >> deployments/sbx-bosh/state.json
    printf "}"                                  >> deployments/sbx-bosh/state.json

    # Sync any changes to 'state.json' back to Bitbucket
    bitbucketName=$(vault kv get -field=bitbucket-name platform/credentials)
    bitbucketEmail=$(vault kv get -field=bitbucket-email platform/credentials)
    bitbucketUser=$(vault kv get -field=bitbucket-user platform/credentials)
    bitbucketPassword=$(vault kv get -field=bitbucket-password platform/credentials)

    # Check if we're on master
    currentBranch="$(git branch --show-current)"
    if [[ $currentBranch != "master" ]]; then
        mv deployments/$TARGET_DIRECTOR/state.json /tmp
        git stash
        git checkout master
        git pull "https://${bitbucketUser}:${bitbucketPassword}@bitbucket.org//.git"
        mv /tmp/state.json deployments/$TARGET_DIRECTOR/state.json
    fi

    git add deployments/$TARGET_DIRECTOR/state.json
    git commit --author="${bitbucketName} <${bitbucketEmail}>" \
        --message "${TARGET_DIRECTOR}/state.json updated by ${USER:-an unknown user}"
    git push "https://${bitbucketUser}:${bitbucketPassword}@bitbucket.org/.git"

    if [[ $currentBranch != "master" ]]; then
        git checkout $currentBranch
        git stash apply
    fi

    # Instruct the user to finish the 'sbx-bosh' setup by following these stems
    printf "\n"
    printf "${GREEN}${BOLD}The Sandbox (Sbx) BOSH Director is now ready!\n${RESET}"
    printf "\n"
    printf "${BOLD}Please perform the following stems to finish the setup:\n${RESET}"
    printf "\n"
    printf "1) Select the new Sandbox (Sbx) BOSH Director\n"
    printf "${BOLD}./scripts/select-director.sh sbx-bosh\n${RESET}"
    printf "\n"
    printf "2) Upload the Cloud Config\n"
    printf "${BOLD}bosh update-cloud-config cloud-config/sbx-bosh/cloud-config.yml\n${RESET}"
    printf "\n"
    printf "3) Update the runtime config to enable BOSH DNS\n"
    printf "${BOLD}bosh update-runtime-config clones/bosh-deployment/runtime-configs/dns.yml --name bosh-dns\n${RESET}"
    printf "\n\n"
fi