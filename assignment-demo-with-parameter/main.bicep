targetScope = 'subscription'

@description('Specifies the location for resources.')
param location string = 'westeurope'

param deployPolicy bool = true

resource rgwesteuropenotallowed 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-westeurope-not-allowed'
  location: location
}

module policy 'allowed-locations-policy.bicep' = if(deployPolicy) {
  scope: subscription()
  name: 'policy-demo'
}

module policyAssignment 'policy-assignment.bicep' = if(deployPolicy) {
  scope: rgwesteuropenotallowed
  name: 'policyAssignment-demo'
  params: {
    policyDefinitionID: policy.outputs.id
    policyAssignmentName: policy.outputs.name
  }
}

module storagewesteurope './storageaccount.bicep' = {
  scope: rgwesteuropenotallowed
  name: 'storage-westeurope-not-allowed'
  params: {
    name: 'stgwesteuropenota'
    location: 'westeurope'
  }

  dependsOn: [
    policyAssignment
  ]
}
