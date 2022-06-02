# Azure Cosmod DB and AKS
Host a new database by using Azure Cosmos DB, https://docs.microsoft.com/en-us/learn/modules/aks-manage-application-state/3-exercise-create-resources<br>

## Create the state
1. Create Bash variables to store important information.
```bash
export RESOURCE_GROUP=testResourceGroup
export COSMOSDB_ACCOUNT_NAME=contoso-ship-manager-$RANDOM
az group create -n testResourceGroup -l eastasia
```
2. Create a new Azure Cosmos DB account.
```bash
az cosmosdb create --name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --kind MongoDB
```
3. Check ad list database.
```bash
az cosmosdb mongodb database create --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP --name contoso-ship-manager
az cosmosdb mongodb database list --account-name $COSMOSDB_ACCOUNT_NAME --resource-group $RESOURCE_GROUP -o table
```

## Create the AKS cluster
1. Create Bash variables to store important information and create a AKS cluster.
```bash
export AKS_CLUSTER_NAME=ship-manager-cluster

az aks create --resource-group $RESOURCE_GROUP \
    --name $AKS_CLUSTER_NAME  \
    --node-count 3 \
    --generate-ssh-keys \
    --node-vm-size Standard_B2s \
    --enable-managed-identity \
    --location eastasia \
    --enable-addons http_application_routing
```
2. Get kubectl configuration and check the nodes.
```bash	
az aks get-credentials --name $AKS_CLUSTER_NAME --resource-group $RESOURCE_GROUP	
kubectl get nodes
```

## Deploy the application

### Deploy the back-end API
1. Create a new file called backend-deploy.yaml
```bash
nano backend-deploy.yaml
```
2. Copy the content to backend-deploy.yaml.
```bash
```
3.
az cosmosdb keys list --type connection-strings -g $RESOURCE_GROUP -n $COSMOSDB_ACCOUNT_NAME --query "connectionStrings[0].connectionString" -o tsv

mongodb://contoso-ship-manager-32489:zw2L8wYjLIhcolfZvza1B78EURjIwEwfAiZtnApvpDkxFtYlrw4U5y4LscoHAY9QSSviILDJvaXpFqrClsO5BQ==@contoso-ship-manager-32489.mongo.cosmos.azure.com:10255/?ssl=true&replicaSet=globaldb&retrywrites=false&maxIdleTimeMS=120000&appName=@contoso-ship-manager-32489@

kubectl apply -f backend-deploy.yaml

nano backend-network.yaml

az aks show -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName

d1fc0e0bded44fcb84ce.eastasia.aksapp.io

kubectl apply -f backend-network.yaml

kubectl get ingress

## Deploy the front-end interface

nano frontend-deploy.yaml

http://ship-manager-backend.d1fc0e0bded44fcb84ce.eastasia.aksapp.io

kubectl apply -f frontend-deploy.yaml

nano frontend-network.yaml

az aks show -g $RESOURCE_GROUP -n $AKS_CLUSTER_NAME -o tsv --query addonProfiles.httpApplicationRouting.config.HTTPApplicationRoutingZoneName

d1fc0e0bded44fcb84ce.eastasia.aksapp.io

kubectl apply -f frontend-network.yaml

kubectl get ingress




