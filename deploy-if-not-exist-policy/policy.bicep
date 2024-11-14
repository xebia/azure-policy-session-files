targetScope = 'subscription'

param workspaceId string

resource policy 'Microsoft.Authorization/policyDefinitions@2020-09-01' = {
  name: 'keyvault-central-diagnostics-policy'
  properties: {
    displayName: 'Keyvault central diagnostics policy'
    description: 'DeployIfNotExists a when diagnostic is not available for the keyvault'
    policyType: 'Custom'
    mode: 'All'
    metadata: {
      category: 'Custom'
      source: 'Bicep'
      version: '0.1.0'
    }
    parameters: {}
    policyRule: {
      if: {
        allOf: [
          {
            field: 'type'
            equals: 'microsoft.keyvault/vaults'
          }
        ]
      }
      then: {
        effect: 'deployIfNotExists'
        details: {
          roleDefinitionIds: [
            '/providers/microsoft.authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c'
          ]
          type: 'Microsoft.Insights/diagnosticSettings'
          existenceCondition: {
            allOf: [
              {
                field: 'Microsoft.Insights/diagnosticSettings/logs[*].categoryGroup'
                equals: 'audit'
              }
            ]
          }
          deployment: {
            properties: {
              mode: 'incremental'
              template: {
                '$schema': 'https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#'
                contentVersion: '1.0.0.0'
                parameters: {
                  resourceName: {
                    type: 'String'
                    metadata: {
                      displayName: 'resourceName'
                      description: 'Name of the resource'
                    }
                  }
                }
                variables: {}
                resources: [
                  {
                    type: 'microsoft.keyvault/vaults/providers/diagnosticSettings'
                    apiVersion: '2021-05-01-preview'
                    name: '[concat(parameters(\'resourceName\'), \'/\', \'Microsoft.Insights/\', \'kv-local-diag\')]'
                    properties: {
                      workspaceId: workspaceId
                      logs: [
                        {
                          category: null
                          categoryGroup: 'audit'
                          enabled: true
                        }
                      ]
                      metrics: [
                        {
                          category: 'AllMetrics'
                          enabled: true
                          timeGrain: null
                        }
                      ]
                    }
                  }
                ]
              }
              parameters: {
                resourceName: {
                  value: '[field(\'name\')]'
                }

              }
            }
          }
        }
      }
    }
  }
}

output id string = policy.id
output name string = policy.name
