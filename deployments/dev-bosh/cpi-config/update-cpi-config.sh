#!/bin/bash

set -euo pipefail

AZURE_REGION_ENV="azure-euw-dev"

bosh -e $BCP_SELECTED_DIRECTOR update-cpi-config --no-redact deployments/$BCP_SELECTED_DIRECTOR/cpi-config/puzzel-cpis.yml \
    -v az_euw_dev_environment="AzureCloud" \
    -v az_euw_dev_subscription_id="$(az keyvault secret show --vault-name "bosh-prod-uks-kv" --name "$AZURE_REGION_ENV-subsription-id" --query "value" -o tsv)" \
    -v az_euw_dev_tenant_id="$(az keyvault secret show --vault-name "bosh-prod-uks-kv" --name "$AZURE_REGION_ENV-tenant-id" --query "value" -o tsv)" \
    -v az_euw_dev_client_id="$(az keyvault secret show --vault-name "bosh-prod-uks-kv" --name "$AZURE_REGION_ENV-client-id" --query "value" -o tsv)" \
    -v az_euw_dev_client_secret="$(az keyvault secret show --vault-name "bosh-prod-uks-kv" --name "$AZURE_REGION_ENV-client-secret" --query "value" -o tsv)" \
    -v az_euw_dev_resource_group_name="bcp-bosh-dev-euw-rg" \
    -v az_euw_dev_use_managed_disks="true" \
    -v az_euw_dev_ssh_public_key="$1"

# more manual way
    # read -rsp "Enter the subscription_id for the Azure cpi: " AZURE_EUW_DEV_SUBSCRIPTION_ID
    # printf "\n"
    # read -rsp "Enter the tenant_id for the Azure cpi: " AZURE_EUW_DEV_TENANT_ID
    # printf "\n"
    # read -rsp "Enter client_id of service principal for the Azure cpi: " AZURE_EUW_DEV_CLIENT_ID
    # printf "\n"
    # read -rsp "Enter client_secret of service principal for the Azure cpi: " AZURE_EUW_DEV_CLIENT_SECRET
    # printf "\n"

    # bosh -e $BCP_SELECTED_DIRECTOR update-cpi-config --no-redact deployments/$BCP_SELECTED_DIRECTOR/cpi-config/puzzel-cpis.yml \
    #     -v az_euw_dev_environment="AzureCloud" \
    #     -v az_euw_dev_subscription_id="$AZURE_EUW_DEV_SUBSCRIPTION_ID" \
    #     -v az_euw_dev_tenant_id="$AZURE_EUW_DEV_TENANT_ID" \
    #     -v az_euw_dev_client_id="$AZURE_EUW_DEV_CLIENT_ID" \
    #     -v az_euw_dev_client_secret="$AZURE_EUW_DEV_CLIENT_SECRET" \
    #     -v az_euw_dev_resource_group_name="bcp-bosh-dev-euw-rg" \
    #     -v az_euw_dev_use_managed_disks="true" \
    #     -v az_euw_dev_ssh_public_key="$1"