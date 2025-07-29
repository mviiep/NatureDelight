@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View SO header'
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_SO
 provider contract transactional_query
  as projection on  ZI_SO
{
      @EndUserText.label: 'Serial No'

      @UI.facet: [{   id : 'D1',
                  purpose: #STANDARD,
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'SO Data',
                  position: 10
              } ]


      @UI: {
                identification: [{ position: 10, label : 'Serial No' } ],
                lineItem: [{ position: 10 ,
                              type: #FOR_ACTION,
                              label: 'Create So',
                              dataAction: 'CreateSO',
                              invocationGrouping: #CHANGE_SET }] }
  key Id,

      @EndUserText.label: 'SO Id'
      @UI: { lineItem: [{position: 20 }], identification: [{position: 20 }] }
    Soid,
    
      @EndUserText.label: 'Order Type'
      @Search.defaultSearchElement: true
      @UI: { lineItem: [{position: 30 }], identification: [{position: 30 }] }
      Auart,
      
      @EndUserText.label: 'Sales Org'
      @UI: { lineItem: [{position: 40 }], identification: [{position: 40 }] }
      Vkorg,
      
      @EndUserText.label: 'DistributionChannel'
      @UI: { lineItem: [{position: 50 }], identification: [{position: 50 }] }
      Vtweg,

      @EndUserText.label: 'Division'
      @UI: { lineItem: [{position: 60 }], identification: [{position: 60 }] }
      Spart,

      @EndUserText.label: 'SoldToParty'
      @UI: { lineItem: [{position: 70 }], identification: [{position: 70 }] }
      Kunnr,

      @EndUserText.label: 'Customer Reference'
      @UI: { lineItem: [{position: 80 }], identification: [{position: 80 }] }
      BstkdE,

      @EndUserText.label: 'Ship-to Party'
      @UI: { lineItem: [{position: 90 }], identification: [{position: 90 }] }
      Bstkd,

      @EndUserText.label: 'Shipping Conditions'
      @UI: { lineItem: [{position: 100 }], identification: [{position: 100 }] }
      Knumv,

      @EndUserText.label: 'Delivery Date'
      @UI: { lineItem: [{position: 110 }], identification: [{position: 110 }] }
      Audat,
      
      
      @EndUserText.label: 'Pricing Date'
      @UI: { lineItem: [{position: 120 }], identification: [{position: 120 }] }
      PrcDate,
      
      @EndUserText.label: 'Item'
      @UI: { lineItem: [{position: 130 }], identification: [{position: 130 }] }
      Posnr,
      
      
      @EndUserText.label: 'Product'
      @UI: { lineItem: [{position: 140 }], identification: [{position: 140 }] }
      Matnr,
      
      
      @EndUserText.label: 'Customer Material'
      @UI: { lineItem: [{position: 150 }], identification: [{position: 150 }] }
      Kdmat,
      
      
      @EndUserText.label: 'GTIN (EAN/UPC)'
      @UI: { lineItem: [{position: 160 }], identification: [{position: 160 }] }
      Gstin,
      
      @EndUserText.label: 'Qty'
      @UI: { lineItem: [{position: 170 }], identification: [{position: 170 }] }
      Kwmeng,
      
      @EndUserText.label: 'Unit'
      @UI: { lineItem: [{position: 180 }], identification: [{position: 180 }] }
      Vrkme,
      
      @EndUserText.label: 'Item Category'
      @UI: { lineItem: [{position: 190 }], identification: [{position: 190 }] }
      Pstyv,
      
      
      @EndUserText.label: 'Plant'
      @UI: { lineItem: [{position: 200 }], identification: [{position: 200 }] }
      Werks,
      
      @EndUserText.label: 'Vbeln'
      @UI: { lineItem: [{position: 210 }], identification: [{position: 210 }] }
      Vbeln
}
