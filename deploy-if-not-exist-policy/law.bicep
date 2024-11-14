resource workspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: 'law-policy-demo'
  location: 'westeurope'
}

output workspaceId string = workspace.id
