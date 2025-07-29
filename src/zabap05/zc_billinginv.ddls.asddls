@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View ZI_BILLINGINV'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_BILLINGINV
  provider contract transactional_query
  as projection on ZI_BILLINGINV
{

      @EndUserText.label: 'Billing Document'
      
      @UI.facet: [{   id : 'BillingDocument',
                  purpose: #STANDARD,
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'Billing invoice',
                  position: 10
              } ]


//      @UI: {
//                identification: [{ position: 10, label : 'Billing Document' } ],
//                lineItem: [{ position: 10 ,
//                              type: #FOR_ACTION,
//                              label: 'Create IRN',
//                              dataAction: 'CreateIRN',
//                              invocationGrouping: #CHANGE_SET }] }
                              
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'BillingDocument' } }]
                                                     
  @UI: {  lineItem:       [ { position: 10 }, { type: #FOR_ACTION, dataAction: 'CreateIRN', 
                                                label: 'Create IRN', invocationGrouping: #CHANGE_SET } ],
        identification: [ { position: 10 }, { type: #FOR_ACTION, dataAction: 'CreateIRN', 
                                              label: 'Create IRN', invocationGrouping: #CHANGE_SET } ] }                                                     
//      @UI: { lineItem: [{position: 20 }], identification: [{position: 20 }] }
  key BillingDocument,

      @EndUserText.label: 'Sold To Party'
      @UI: { lineItem: [{position: 30 }], identification: [{position: 30 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'SoldToParty' } }]
      SoldToParty,

      @EndUserText.label: 'Billing Date'
      @UI: { lineItem: [{position: 40 }], identification: [{position: 40 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'BillingDocumentDate' } }]
      BillingDocumentDate,

      @EndUserText.label: 'Billing Type'
      @UI: { lineItem: [{position: 50 }], identification: [{position: 50 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'BillingDocumentType' } }]
      BillingDocumentType,

      @EndUserText.label: 'Company Code'
      @UI: { lineItem: [{position: 60 }], identification: [{position: 60 }] }
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
                                                     element: 'CompanyCode' } }]
      CompanyCode,

      @EndUserText.label: 'Distribution Channel'
      @UI: { lineItem: [{position: 70 }], identification: [{position: 70 }] }
      @Search.defaultSearchElement: true
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
//                                                     element: 'CompanyCode' } }]      
      DistributionChannel,

      @EndUserText.label: 'IRN'
      @UI: { lineItem: [{position: 80 }], identification: [{position: 80 }] }
      @Search.defaultSearchElement: true      
      Irn,

      @EndUserText.label: 'IRN Status'
      @UI: { lineItem: [{position: 90 }], identification: [{position: 90 }] }
      @Search.defaultSearchElement: true      
      IrnStatus
}
