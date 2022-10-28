# Deploymnt

This page goes through the steps to deploy the BCP from scratch. Go back to the main page and read the pre-requisites if you have not already done that.

## Process

1. **Create the management BOSH director**  
Start by deleting the deployments controlled by the directors. If not, the deployments will continue to live after deletion of the director, but you will not have any contoll of them through BOSH.  
This is done by authentication to the director you are about to delete, then list out the deployments with  
`./deploy`  

2. **Target the management director**  
`./bcp/select-director`

3. **Deploy the MySQL cluster**
`./deployments/bcp-sbx-core-database/deploy `

4. **Deploy the core-services vms**  
`./bcp/select-director (select the management director when prompted)`

5. **Delete core-services vms**  
`/deployments/bcp-sbx-core-services/deploy`

6. **Manual step: Create bucket(s) through MinIO gui**  
Log in to the MinIO gui, using root user credentials. Then, create buckets for the directors to be deployed, using the deployment name of the director. For instance, call the bucket for a director named <env>-bosh for <env>-bosh. 

7. **Deploy a director**  
`./deployments/<env>-bosh/deploy`

8. **Repete step 7 to create more directors (repete step 6 also, if you didn't already create the bucket).**