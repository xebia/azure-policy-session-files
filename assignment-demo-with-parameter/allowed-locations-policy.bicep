targetScope = 'subscription'

var allowedLocations = ['northeurope']

resource policy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'demo-allowed-locations-with-parameters'
  properties: {
    policyType: 'Custom'
    mode: 'All'
    parameters: {
      effect: {
        type: 'String'
        allowedValues: [
          'Audit'
          'Deny'
          'Disabled'
        ]
        defaultValue: 'Deny'
      }
    }
    policyRule: {
      if: {
        allOf: [
          {
            field: 'location'
            notIn: allowedLocations
          }
        ]
      }
      then: {
        effect: '[parameters(\'effect\')]'
      }
    }
  }
}

output id string = policy.id
output name string = policy.name
