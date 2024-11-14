param policyAssignmentName string
param policyDefinitionID string

resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: policyAssignmentName
    location: 'westeurope'
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionID
    }
}

output assignmentId string = assignment.id
output identityPrincipalId string = assignment.identity.principalId
