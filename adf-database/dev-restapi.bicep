param storageAccountName string = 'mystorageaccountdev123'
param blobContainerName string = 'adfcontainer'
param dataFactoryDataSetInName string = 'devvvdataset'
param dataFactoryLinkedServiceName string = 'restapilinkefhdgf'
param dataFactoryDataSetOutName string = 'deevvvataout'
var pipelineName = 'deveepipele'
var dataFactoryName = 'datafactory26fztylakupe6'

resource storageAccount 'Microsoft.Storage/storageAccounts@2021-08-01' existing = {
  name: storageAccountName
}

resource dataFactory 'Microsoft.DataFactory/factories@2018-06-01' existing = {
  name: dataFactoryName
}

resource dataFactoryLinkedService 'Microsoft.DataFactory/factories/linkedservices@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryLinkedServiceName
  properties: {
    type: 'RestService'
    typeProperties: {
      url: 'https://dummy.restapiexample.com/api/v1/employees'   // Replace with the actual URL of your REST API
      authenticationType: 'Anonymous' // Update with the authentication type (e.g., 'Basic', 'OAuth', 'Anonymous')
      // Add other authentication properties as needed
    }
  }
  dependsOn: [
    storageAccount
  ]
}

resource dataFactoryDataSetIn 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryDataSetInName
  properties: {
    linkedServiceName: {
      referenceName: dataFactoryLinkedService.name
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: blobContainerName
        folderPath: 'input'
        fileName: 'emp.txt'
      }
    }
  }
}

resource dataFactoryDataSetOut 'Microsoft.DataFactory/factories/datasets@2018-06-01' = {
  parent: dataFactory
  name: dataFactoryDataSetOutName
  properties: {
    linkedServiceName: {
      referenceName: dataFactoryLinkedService.name
      type: 'LinkedServiceReference'
    }
    type: 'Binary'
    typeProperties: {
      location: {
        type: 'AzureBlobStorageLocation'
        container: blobContainerName
        folderPath: 'output'
      }
    }
  }
}

resource dataFactoryPipeline 'Microsoft.DataFactory/factories/pipelines@2018-06-01' = {
  parent: dataFactory
  name: pipelineName
  properties: {
    activities: [
      {
        name: 'MyCopyActivity'
        type: 'Copy'
        typeProperties: {
          source: {
            type: 'BinarySource'
            storeSettings: {
              type: 'AzureBlobStorageReadSettings'
              recursive: true
            }
          }
          sink: {
            type: 'BinarySink'
            storeSettings: {
              type: 'AzureBlobStorageWriteSettings'
            }
          }
          enableStaging: false
        }
        inputs: [
          {
            referenceName: dataFactoryDataSetIn.name
            type: 'DatasetReference'
          }
        ]
        outputs: [
          {
            referenceName: dataFactoryDataSetOut.name
            type: 'DatasetReference'
          }
        ]
      }
    ]
  }
}
