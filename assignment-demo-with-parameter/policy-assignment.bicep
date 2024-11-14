
param policyAssignmentName string
param policyDefinitionID string 

resource assignment 'Microsoft.Authorization/policyAssignments@2022-06-01' = {
    name: policyAssignmentName

    properties: {
        policyDefinitionId: policyDefinitionID
    }
}

output assignmentId string = assignment.id
