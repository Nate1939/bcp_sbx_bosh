# Deletion

This page goes through the steps to delete the BCP. That is, delete the bosh director(s) deployed by the management bosh, delete the core-services vms and the MySQL cluster. Go back to the main page and read the pre-requisites if you have not already done that.

## Process

### Delete the directors deployed by the management BOSH

1. Start by deleting the deployments controlled by the directors. If not, the deployments will continue to live after deletion of the director, but you will not have any contoll of them through BOSH.  
This is done by authentication to the director you are about to delete, then list out the deployments with `bosh ds` and delete the deployments with `bosh -d <deployment_name> delete` and then clean up the oprhaned disks with `bosh disks --orphaned | grep disk- | awk '{print $1}' | xargs -L1 bosh delete-disk -n`

2. ./deployments/<env>-bosh/delete

3. Step 1 and are performed for all the non-management bosh directors

4. ./bcp/select-director (select the management director when prompted)

5. ./deployments/bcp-sbx-core-services/delete

6. ./deployments/bcp-sbx-core-database/delete

7. bosh disks --orphaned | grep disk- | awk '{print $1}' | xargs -L1 bosh delete-disk -n

8. Delete the management bosh director:  
./delete

9. Log into vcenter through gui and delete what’s within bcp-sbx-bosh-templates (not automatically deleted).
