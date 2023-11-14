@description('Specifies the location for resources.')
param location string = 'East US' // Update with your desired location

param dataFactoryName string = 'mydata123g'
param restApiUrl string = 'https://reqres.in/api/users'
param restApiMethod string = 'GET' // Update with the desired HTTP method
param gen2LinkedServiceName string = 'gen2LinkedService'
param restApiDatasetInName string = 'restapidatasetin'
param restApiDatasetOutName string = 'restapidatasetout'

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' = {
  name: dataFactoryName
  location: location
  identity: {
    type: 'SystemAssigned'
  }
}

resource linkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  name: gen2LinkedServiceName
  properties: {
    type: 'AzureBlobStorage', // Update with the appropriate linked service type for Gen2
    typeProperties: {
      connectionString: '<your_connection_string>' // Update with your Gen2 connection string
    }
  }
}

resource datasetIn 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: restApiDatasetInName
  properties: {
    type: 'Rest', // Update with the appropriate dataset type for REST API
    linkedServiceName: gen2LinkedServiceName
    typeProperties: {
      relativeUrl: restApiUrl
      requestMethod: restApiMethod
    }
  }
}

resource datasetOut 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  name: restApiDatasetOutName
  properties: {
    type: 'Rest', // Update with the appropriate dataset type for REST API
    linkedServiceName: gen2LinkedServiceName
    typeProperties: {
      relativeUrl: restApiUrl
      requestMethod: restApiMethod
    }
  }
}

// Additional resources or configurations can be added as needed
