
resource vnet 'Microsoft.Network/virtualNetworks@2020-11-01' = {
  name: 'vnet-dns-policy-demo'
  location: 'westeurope'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/24'
      ]
    }
    subnets: [
      {
        name: 'privateendpoints'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
    ]
  }
}

resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-dns-policy-demo'
  location: 'westeurope'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [

    ]
  }
}

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: 'privatelink.vaultcore.azure.net'
  location: 'global'
}

resource privateDnsZoneLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: '${vnet.name}-link'
  location: 'global'
  properties: {
    registrationEnabled: false
    virtualNetwork: {
      id: vnet.id
    }
  }
}

module policy 'policy.bicep' = {
  scope: subscription()
  name: 'policy-deploypdnskv-demo'
}

module policyAssignment 'policy-assignment.bicep' = {
  name: 'policy-deploypdnskv-demo'
  params: {
    policyDefinitionID: policy.outputs.id
    policyAssignmentName: policy.outputs.name
    policyDNSZoneID: privateDnsZone.id
  }
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment.name, '4d97b98b-1d4f-4787-a291-c67834d212e7')
  properties: {
    principalId: policyAssignment.outputs.identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7'
  }
}

// resource keyVaultPrivateEndpoint 'Microsoft.Network/privateEndpoints@2024-03-01' = {
//   name: 'pe-${keyvault.name}'
//   location: 'westeurope'
//   properties: {
//     customNetworkInterfaceName: 'nic-pe-${keyvault.name}'
//     privateLinkServiceConnections: [
//       {
//         name: 'pe-${keyvault.name}'
//         properties: {
//           groupIds: [
//             'vault'
//           ]
//           privateLinkServiceId: keyvault.id
//         }
//       }
//     ]
//     subnet: {
//       id: vnet.properties.subnets[0].id
//     }
//   }
// }
