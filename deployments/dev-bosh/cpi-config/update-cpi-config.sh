#!/bin/bash

set -euo pipefail

read -rsp "Enter the subscription_id for the Azure cpi: " AZURE_EUW_DEV_SUBSCRIPTION_ID
printf "\n"
read -rsp "Enter the tenant_id for the Azure cpi: " AZURE_EUW_DEV_TENANT_ID
printf "\n"
read -rsp "Enter client_id of service principal for the Azure cpi: " AZURE_EUW_DEV_CLIENT_ID
printf "\n"
read -rsp "Enter client_secret of service principal for the Azure cpi: " AZURE_EUW_DEV_CLIENT_SECRET
printf "\n"

bosh -e $BCP_SELECTED_DIRECTOR update-cpi-config --no-redact deployments/$BCP_SELECTED_DIRECTOR/cpi-config/puzzel-cpis.yml \
    -v az_euw_dev_environment="AzureCloud" \
    -v az_euw_dev_subscription_id="$AZURE_EUW_DEV_SUBSCRIPTION_ID" \
    -v az_euw_dev_tenant_id="$AZURE_EUW_DEV_TENANT_ID" \
    -v az_euw_dev_client_id="$AZURE_EUW_DEV_CLIENT_ID" \
    -v az_euw_dev_client_secret="$AZURE_EUW_DEV_CLIENT_SECRET" \
    -v az_euw_dev_resource_group_name="bcp-bosh-dev-euw-rg" \
    -v az_euw_dev_use_managed_disks="true" \
    -v az_euw_dev_ssh_public_key="$1"