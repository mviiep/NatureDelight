@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Consumption view for truck sheet'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_TRUCKSHEET_VIEW
  provider contract transactional_query
  as projection on ZI_TRUCKSHEET_VIEW
{
      @EndUserText.label: 'Billing Invoice'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'BillingDocument' } }]
  key invid,

      @EndUserText.label: 'Billing Invoice'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'BillingDocument' } }]
  key vbeln,

      @EndUserText.label: 'Trucksheet No'
      @Search.defaultSearchElement: true
      itemTrucksheetNo,


      @EndUserText.label: 'Distribution Channel'
      @Search.defaultSearchElement: true
      //@Consumption.filter:{ mandatory:true }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'DistributionChannel' },
                                                     distinctValues: true }]
      vtweg,
      
//      @EndUserText.label: 'Sold To Party'
//      @Search.defaultSearchElement: true
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
//                                                     element: 'SoldToParty' },
//                                                     distinctValues: true }]
//      kunag,
      
      @EndUserText.label: 'Sold To Party'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'SoldToParty' },
                                                     distinctValues: true }]
      name,

      @EndUserText.label: 'Billing Date'
      @Search.defaultSearchElement: true
      //      @Consumption.filter:{ mandatory:true }
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
//                                                          element: 'BillingDocumentDate' },
//                                                          distinctValues: true }]
    @Consumption.filter.selectionType: #INTERVAL                 
      fkdat,
      
      Curr,
        
      @EndUserText.label: 'Billing Amount'
      @Search.defaultSearchElement: true
      @Semantics.amount.currencyCode: 'Curr'
      netwr,
      
//      unit,
//      
//      @EndUserText.label: 'Qty'
//      @Search.defaultSearchElement: true
//      @Semantics.quantity.unitOfMeasure: 'unit'
//      FKIMG,

      @EndUserText.label: 'Route'
      @Search.defaultSearchElement: true
      //    @Consumption.filter:{ mandatory:true }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DeliveryDocument',
                                                     element: 'ActualDeliveryRoute' },
                                                     distinctValues: true }]
      route
}
