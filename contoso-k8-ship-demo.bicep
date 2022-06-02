param managedClusters_ship_manager_cluster_name string = 'ship-manager-cluster'
param databaseAccounts_contoso_ship_manager_31925_name string = 'contoso-ship-manager-31925'
param publicIPAddresses_fa4d6d35_9af0_4f8a_abc7_8bbae3cca6cd_externalid string = '/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/MC_rg_contoso-k8-demo_ship-manager-cluster_westus2/providers/Microsoft.Network/publicIPAddresses/fa4d6d35-9af0-4f8a-abc7-8bbae3cca6cd'
param userAssignedIdentities_ship_manager_cluster_agentpool_externalid string = '/subscriptions/acc26051-92a5-4ed1-a226-64a187bc27db/resourceGroups/MC_rg_contoso-k8-demo_ship-manager-cluster_westus2/providers/Microsoft.ManagedIdentity/userAssignedIdentities/ship-manager-cluster-agentpool'
param location string = resourceGroup().location
resource managedClusters_ship_manager_cluster_name_resource 'Microsoft.ContainerService/managedClusters@2022-03-02-preview' = {
  name: managedClusters_ship_manager_cluster_name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Free'
  }
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    kubernetesVersion: '1.22.6'
    dnsPrefix: 'ship-manag-rgcontoso-k8-dem-acc260'
    agentPoolProfiles: [
      {
        name: 'nodepool1'
        count: 3
        vmSize: 'Standard_B2s'
        osDiskSizeGB: 128
        osDiskType: 'Managed'
        kubeletDiskType: 'OS'
        maxPods: 110
        type: 'VirtualMachineScaleSets'
        enableAutoScaling: false
        powerState: {
          code: 'Running'
        }
        currentOrchestratorVersion: '1.22.6'
        enableNodePublicIP: false
        mode: 'System'
        enableEncryptionAtHost: false
        enableUltraSSD: false
        osType: 'Linux'
        osSKU: 'Ubuntu'
        enableFIPS: false
      }
    ]
    linuxProfile: {
      adminUsername: 'azureuser'
      ssh: {
        publicKeys: [
          {
            keyData: 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDM6N76+18qY39S5B478Ji2Cz36qc6boP8S9pdiuwlZP/aUG6X7uyDVsQl8lQefMuoWJ0xyWNRt764cFRkS9V7GT2tUnn0nT2Htwaxvja2/vS9QXADcNSbnBAPMoFsruyOaqBOSX+OeJwOXLho5fs8G06n5LpOCdMpGTV/QjoxoZGuE8EywxtGLUyM0+wofz+89ZhFzuxfHeeCU7zxG3ZEi0XECNKxCk6ZsMvO4IJuQW1JUCNyyifUh343gmfEJ2q+vm7Pcb1Rob17FS3hAu2YACgd93MMR5ZYuDq0mtUZ513Y91ao5lxkKKK+/7vRnAPPbhIYH9OWHLcFD06QEdp3d'
          }
        ]
      }
    }
    servicePrincipalProfile: {
      clientId: 'msi'
    }
    addonProfiles: {
      httpApplicationRouting: {
        enabled: true
        config: {
          HTTPApplicationRoutingZoneName: '21fb11f3547b4322b0a6.westus2.aksapp.io'
        }
      }
    }
    nodeResourceGroup: 'MC_rg_contoso-k8-demo_${managedClusters_ship_manager_cluster_name}_westus2'
    enableRBAC: true
    networkProfile: {
      networkPlugin: 'kubenet'
      loadBalancerSku: 'standard'
      loadBalancerProfile: {
        managedOutboundIPs: {
          count: 1
        }
        effectiveOutboundIPs: [
          {
            id: publicIPAddresses_fa4d6d35_9af0_4f8a_abc7_8bbae3cca6cd_externalid
          }
        ]
      }
      podCidr: '10.244.0.0/16'
      serviceCidr: '10.0.0.0/16'
      dnsServiceIP: '10.0.0.10'
      dockerBridgeCidr: '172.17.0.1/16'
      outboundType: 'loadBalancer'
    }
    identityProfile: {
      kubeletidentity: {
        resourceId: userAssignedIdentities_ship_manager_cluster_agentpool_externalid
        clientId: 'd918e256-cb70-4986-be91-d51ca42fd3cf'
        objectId: 'f9924f0a-c926-4767-b4cd-773df848e973'
      }
    }
    disableLocalAccounts: false
    securityProfile: {}
    oidcIssuerProfile: {
      enabled: false
    }
  }
}

resource databaseAccounts_contoso_ship_manager_31925_name_resource 'Microsoft.DocumentDB/databaseAccounts@2022-02-15-preview' = {
  name: databaseAccounts_contoso_ship_manager_31925_name
  location: location
  kind: 'MongoDB'
  identity: {
    type: 'None'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    enableAutomaticFailover: false
    enableMultipleWriteLocations: false
    isVirtualNetworkFilterEnabled: false
    virtualNetworkRules: []
    disableKeyBasedMetadataWriteAccess: false
    enableFreeTier: false
    enableAnalyticalStorage: false
    analyticalStorageConfiguration: {
      schemaType: 'FullFidelity'
    }
    databaseAccountOfferType: 'Standard'
    defaultIdentity: 'FirstPartyIdentity'
    networkAclBypass: 'None'
    disableLocalAuth: false
    consistencyPolicy: {
      defaultConsistencyLevel: 'Eventual'
      maxIntervalInSeconds: 5
      maxStalenessPrefix: 100
    }
    apiProperties: {
      serverVersion: '4.0'
    }
    locations: [
      {
        location: location
        failoverPriority: 0
        isZoneRedundant: false
      }
    ]
    cors: []
    capabilities: [
      {
        name: 'EnableServerless'
      }
      {
        name: 'EnableMongo'
      }
    ]
    ipRules: []
    backupPolicy: {
      type: 'Periodic'
      periodicModeProperties: {
        backupIntervalInMinutes: 240
        backupRetentionIntervalInHours: 8
        backupStorageRedundancy: 'Geo'
      }
    }
    networkAclBypassResourceIds: []
    diagnosticLogSettings: {
      enableFullTextQuery: 'None'
    }
  }
}

resource managedClusters_ship_manager_cluster_name_nodepool1 'Microsoft.ContainerService/managedClusters/agentPools@2022-03-02-preview' = {
  parent: managedClusters_ship_manager_cluster_name_resource
  name: 'nodepool1'
  properties: {
    count: 3
    vmSize: 'Standard_B2s'
    osDiskSizeGB: 128
    osDiskType: 'Managed'
    kubeletDiskType: 'OS'
    maxPods: 110
    type: 'VirtualMachineScaleSets'
    enableAutoScaling: false
    powerState: {
      code: 'Running'
    }
    currentOrchestratorVersion: '1.22.6'
    enableNodePublicIP: false
    mode: 'System'
    enableEncryptionAtHost: false
    enableUltraSSD: false
    osType: 'Linux'
    osSKU: 'Ubuntu'
    enableFIPS: false
  }
}

resource databaseAccounts_contoso_ship_manager_31925_name_contoso_ship_manager 'Microsoft.DocumentDB/databaseAccounts/mongodbDatabases@2022-02-15-preview' = {
  parent: databaseAccounts_contoso_ship_manager_31925_name_resource
  name: 'contoso-ship-manager'
  properties: {
    resource: {
      id: 'contoso-ship-manager'
    }
  }
}
