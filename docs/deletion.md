# Deletion

This page goes through the steps to delete the BCP. That is, delete the bosh director(s) deployed by the management bosh, delete the core-services vms, the MySQL cluster an the management director itself.. Go back to the main page and read the pre-requisites if you have not already done that.

## Process

1. **Before deleting the directors deployed by the management BOSH**  
Start by deleting the deployments controlled by the directors. If not, the deployments will continue to live after deletion of the director, but you will not have any contoll of them through BOSH.  
This is done by authentication to the director you are about to delete, then list out the deployments with  
`bosh ds`  
and delete the deployments with  
`bosh -d <deployment_name> delete-deployment`  
and then clean up the oprhaned disks with  
`bosh disks --orphaned | grep disk- | awk '{print $1}' | xargs -L1 bosh delete-disk -n`  
This is repeted for all the non-management directors you are about to delete.

2. **Target the management bosh director**  
`./bcp/select-director (select the management director when prompted)`

3. **Delete director**  
`./deployments/<env>-bosh/delete`  
This step is done for all non-management directors you want to delete

4. **Delete core-services vms**  
`./deployments/bcp-sbx-core-services/delete`

5. **Delete MySQL cluster**  
`./deployments/bcp-sbx-core-database/delete`

6. **Delete orphaned disks**  
`bosh disks --orphaned | grep disk- | awk '{print $1}' | xargs -L1 bosh delete-disk -n`

7. **Delete the management bosh director**  
`./delete`

8. **Log into vcenter through gui and delete what’s within bcp-sbx-bosh-templates (not automatically deleted).**
