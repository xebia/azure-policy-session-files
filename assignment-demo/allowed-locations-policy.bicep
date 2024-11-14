targetScope = 'subscription'

var allowedLocations = ['northeurope']

resource policy 'Microsoft.Authorization/policyDefinitions@2021-06-01' = {
  name: 'demo-allowed-locations-without-parameters-audit'
  properties: {
    policyType: 'Custom'
    mode: 'All'
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
        effect: 'audit'
      }
    }
  }
}

output id string = policy.id
output name string = policy.name
