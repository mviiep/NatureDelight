@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View SO header'
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_SO_HEADER
  provider contract transactional_query
  as projection on ZI_SO_HEADER as SOHeader

{

      @UI.facet: [{
                 id: 'SOHeader',
                 purpose: #STANDARD,
                 label: 'Header Data',
                 type: #IDENTIFICATION_REFERENCE,
                 position: 10},
                 
                 {
                 id: 'Item',
                 purpose: #STANDARD,
                 label: 'Item Data',
                 type: #LINEITEM_REFERENCE,
                 position: 20,
                 targetElement: '_item'
                 }]
      
      @EndUserText.label: 'SO Id'  
      @UI: {
          selectionField: [{ position: 10 }],
          lineItem: [{ position: 10}],
          identification: [{ position: 10 }]
      }
      
  key Soid,

      @EndUserText.label: 'Order Date'
      
      @UI: {
        lineItem: [{position: 20 }],
        identification: [{position: 20 }]
        }
      Erdat,

      @EndUserText.label: 'Order Type'
      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentStdVH',
      //                                                     element: 'SalesDocumentType' } }]
      Auart,

      @EndUserText.label: 'Sales org'
      @UI: {
      lineItem: [{position: 30 }],
      identification: [{position: 30 }]
      }
      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentStdVH',
      //                                                     element: 'SalesOrganization' } }]
      
      Vkorg,

      @EndUserText.label: 'Division'
      @UI: {
          lineItem: [{position: 40 }],
          identification: [{position: 40 }]
      }
      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentStdVH',
      //                                                     element: 'OrganizationDivision' } }]
      Spart,

      @EndUserText.label: 'DistributionChannel'
      @UI: {
          lineItem: [{position: 50 }],
          identification: [{position: 50 }]
      }
      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentStdVH',
      //                                                     element: 'DistributionChannel' } }]
      Vtweg,

      @EndUserText.label: 'SoldToParty'
      @UI: {
          lineItem: [{position: 60 }],
          identification: [{position: 60 }]
      }
      //      @Search.defaultSearchElement: true
      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_SalesDocumentStdVH',
      //                                                     element: 'SoldToParty' } }]
      Kunnr,

      /* Association */
     _item : redirected to composition child ZC_SO_ITEM
}
