# Deploymnt

This page goes through the steps to deploy the BCP from scratch. Go back to the main page and read the pre-requisites if you have not already done that.

## Process

1. **Create the management BOSH director**   
`./deploy`  

2. **Target the management director**  
`./bcp/select-director` (select the management director when prompted)

3. **Deploy the MySQL cluster**
`./deployments/bcp-sbx-core-database/deploy `

4. **Deploy the core-services vms**  
`./deployments/bcp-sbx-core-services/deploy`

5. **Manual step: Create bucket(s) through MinIO gui**  
Log in to the MinIO gui (https://bosh-core-services.<domain>:9001), using root user credentials. Credentials can be found in credhub under `/<management-director-name>/<core-services-deployment-name>/minio_accesskey` and `/<management-director-name>/<core-services-deployment-name>/minio_secretkey` Then, create buckets for the directors to be deployed, using the deployment name of the director. For instance, call the bucket for a director named <env>-bosh for <env>-bosh. 

6. **Deploy a director**  
`./deployments/<env>-bosh/deploy`

7. **Repete step 2 and 6 to create more directors (repete step 5 also, if you didn't already create the bucket).**