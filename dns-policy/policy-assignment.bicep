param policyAssignmentName string
param policyDefinitionID string
param policyDNSZoneID string

resource assignment 'Microsoft.Authorization/policyAssignments@2024-04-01' = {
    name: policyAssignmentName
    location: 'westeurope'
    identity: {
        type: 'SystemAssigned'
    }
    properties: {
        policyDefinitionId: policyDefinitionID
        parameters: {
            privateDnsZoneId: {
                value: policyDNSZoneID
            }
        }
    }
}

output assignmentId string = assignment.id
output identityPrincipalId string = assignment.identity.principalId
