targetScope = 'subscription'

var customPolicyDefinitiodJSONContent = loadJsonContent('policy_definition_privatedns_vaultcore.json')

resource policy 'Microsoft.Authorization/policyDefinitions@2023-04-01' = {
  name: customPolicyDefinitiodJSONContent.name
  properties: {
    displayName: customPolicyDefinitiodJSONContent.properties.displayName
    mode: customPolicyDefinitiodJSONContent.properties.mode
    parameters: customPolicyDefinitiodJSONContent.properties.parameters
    policyRule: loadJsonContent('policy_definition_privatedns_vaultcore.json','properties.policyRule')
  }
}

output id string = policy.id
output name string = policy.name
