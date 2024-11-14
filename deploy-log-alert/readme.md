```bash
az deployment sub create --name deploylogalert-demo-deployment  --template-file main.bicep -l westeurope

az deployment group create --resource-group rg-deploylogalert-demo --template-file keyvault.bicep
```
