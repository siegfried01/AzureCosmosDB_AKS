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
2. Copy the contents below to backend-deploy.yaml.
```bash
apiVersion: apps/v1
kind: Deployment
metadata:
  name: ship-manager-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: ship-manager-backend
  template:
    metadata:
      labels:
        app: ship-manager-backend
    spec:
      containers:
        - image: mcr.microsoft.com/mslearn/samples/contoso-ship-manager:backend
          name: ship-manager-backend
          resources:
            requests:
              cpu: 100m
              memory: 128Mi
            limits:
              cpu: 250m
              memory: 256Mi
          ports:
            - containerPort: 3000
              name: http
          env:
            - name: DATABASE_MONGODB_URI
              value: "<Your Database Connection String>"
            - name: DATABASE_MONGODB_DBNAME
              value: ship_manager
```
3. Replace the <your database connection string> tag with the actual connection string from Azure Cosmos DB. You can get this connection string through command.
```bash
az cosmosdb keys list --type connection-strings -g $RESOURCE_GROUP -n $COSMOSDB_ACCOUNT_NAME --query "connectionStrings[0].connectionString" -o tsv
```
4. Apply the file.
```bash
kubectl apply -f backend-deploy.yaml
```
5. To make this application available to everyone, you'll need to create a service and an ingress.
```bash
nano backend-network.yaml
```
6. Copy the contents below to backend-network.yaml.
```bash
apiVersion: v1
kind: Service
metadata:
  name: ship-manager-backend
spec:
  selector:
    app: ship-manager-backend
  ports:
    - name: http
      port: 80
      targetPort: 3000
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ship-manager-backend
  annotations:
    kubernetes.io/ingress.class: addon-http-application-routing
spec:
  rules:
    - host: ship-manager-backend.DNS_ZONE
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: ship-manager-backend
                port:
                  number: 80
```

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




