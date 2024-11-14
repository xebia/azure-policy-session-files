targetScope = 'subscription'

resource deployIfNotExistsDemo 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-deploylogalert-demo'
  location: 'westeurope'
}

module policy 'policy.bicep' = {
  scope: subscription()
  name: 'policy-demo'
}

module policyAssignment 'policy-assignment.bicep' = {
  scope: deployIfNotExistsDemo
  name: 'policy-deploylogalert-demo'
  params: {
    policyDefinitionID: policy.outputs.id
    policyAssignmentName: policy.outputs.name
  }
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2022-04-01' = {
  name: guid(policyAssignment.name, 'b24988ac-6180-42a0-ab88-20f7382dd24c')
  properties: {
    principalId: policyAssignment.outputs.identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c' // contributor role for deployIfNotExists/modify effects NOTE: this may be different depending on the policy
  }
}
