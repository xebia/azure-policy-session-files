targetScope = 'subscription'

resource deployIfNotExistsDemo 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'rg-deployIfNotExists-demo'
  location: 'westeurope'
}

module law 'law.bicep' = {
  name: 'law'
  scope: deployIfNotExistsDemo
}

module policy 'policy.bicep' = {
  scope: subscription()
  name: 'policy-demo'
  params: {
    workspaceId: law.outputs.workspaceId
  }
}

module policyAssignment 'policy-assignment.bicep' = {
  scope: deployIfNotExistsDemo
  name: 'policyAssignment-demo'
  params: {
    policyDefinitionID: policy.outputs.id
    policyAssignmentName: policy.outputs.name
  }
}

@description('This is the built-in Contributor role. See https://docs.microsoft.com/azure/role-based-access-control/built-in-roles#contributor')
resource contributorRoleDefinition 'Microsoft.Authorization/roleDefinitions@2022-04-01' existing = {
  scope: subscription()
  name: 'b24988ac-6180-42a0-ab88-20f7382dd24c'
}

resource roleassignment 'Microsoft.Authorization/roleAssignments@2020-04-01-preview' = {
  name: guid(policyAssignment.name, uniqueString(policyAssignment.name))
  properties: {
    principalId: policyAssignment.outputs.identityPrincipalId
    principalType: 'ServicePrincipal'
    roleDefinitionId: contributorRoleDefinition.id
  }
}
