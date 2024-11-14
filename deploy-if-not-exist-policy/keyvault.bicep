
resource keyvault 'Microsoft.KeyVault/vaults@2022-07-01' = {
  name: 'kv-policy-demo-erwin2'
  location: 'westeurope'
  properties: {
    sku: {
      family: 'A'
      name: 'standard'
    }
    tenantId: subscription().tenantId
    accessPolicies: [
      
    ]
  }
}
