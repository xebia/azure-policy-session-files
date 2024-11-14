
```bash
az group create --name rg-dns-policy-demo --location westeurope

az deployment group create --resource-group rg-dns-policy-demo --template-file main.bicep
```