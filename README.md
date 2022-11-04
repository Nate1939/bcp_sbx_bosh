Open source BOSH controlled environment based on the design detailed in
[Control Plane Home](https://puzzel.atlassian.net/wiki/spaces/AF/pages/3617161235/Decision+Record+HA+Architecture+for+BOSH+director).

## Getting Started

See deployment for notes on how to deploy the platform.

## Access

1. Open VPN connection
2. Connect to the `jumpbox` VM

## Prerequisites

1. `git clone https://puzzel@dev.azure.com/puzzel/automation/_git/bosh-control-plane`
1. `git clone https://puzzel@dev.azure.com/puzzel/automation/_git/bcp-sbx-bosh`
1. Ensure that all scripts are executable by running: `find . -type f -name "*.sh" -exec chmod +x \{\} \;`
1. All commands **MUST** be executed from the bcp-sbx-bosh repository root!
1. Sufficient access policy to **bosh-prod-uks-kv**. Must be able to get,list,set,delete,recover,backup and restore secrets.
1. Sufficient access to container within the storage account **boshprodukssa**. Storage Blob Data Contributor is needed on the "bcp-sbx-bosh-credentials" container.

## Deployment

Please see our [Deployment](docs/deployment.md) page on how to deploy the BOSH Control Plane (BCP) from scratch.

## Deletion

Please see our [Deletion](docs/deletion.md) page on how to delete the BCP.

## Target an existing director

To get started working with a director in this platform, see our [Setup](docs/setup.md) page.

## Backup & Recovery

Please see our [BBR](docs/bbr.md) page.

## Built With

Visual Studio Code has a [Bosh Editor extension](https://marketplace.visualstudio.com/items?itemName=Pivotal.vscode-bosh) available that greatly simplifies working with deployments and cloud configurations.

## Troubleshooting

Please see our [Troubleshooting](docs/troubleshooting.md) page.

## Contributing

Please see our [Contribution](docs/contributing.md) page.


