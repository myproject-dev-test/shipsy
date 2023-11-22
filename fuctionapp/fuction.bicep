param functionName string = 'MyHttpFunction'
param functionStorageAccountName string = 'functionstorage121'
param functionAppName string = 'dev-functionapp'

resource httpFunction 'Microsoft.Web/sites/functions@2021-02-01' = {
  name: '${functionAppName}/${functionName}'
  properties: {
    scriptHref: 'https://raw.githubusercontent.com/your-username/your-repo/main/HttpTrigger1.cs'
    config: {
      bindings: [
        {
          authLevel: 'function'
          type: 'httpTrigger'
          direction: 'in'
          name: 'req'
          methods: ['get', 'post']
        },
        {
          type: 'http'
          direction: 'out'
          name: 'res'
        }
      ]
    }
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: functionStorageAccountName
  location: 'East US'
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource functionApp 'Microsoft.Web/sites@2021-02-01' = {
  name: functionAppName
  location: 'East US'
  properties: {
    siteConfig: {
      cors: {
        allowedOrigins: ['*']
      }
    }
    storageAccount: storageAccount.id
  }
}
