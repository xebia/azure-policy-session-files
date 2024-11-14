
```bash
az deployment sub create --name deployifnotexists-demo-deployment  --template-file main.bicep -l westeurope

az deployment group create --resource-group rg-deployIfNotExists-demo --template-file keyvault.bicep
```