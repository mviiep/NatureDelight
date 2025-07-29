@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View SO Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZC_SO_ITEM 
as projection on ZI_SO_ITEM as _SOItem
{
    
     @UI.facet: [{
             id: 'SOHeader',
             purpose: #STANDARD,
             label: 'Item Information',
             type: #IDENTIFICATION_REFERENCE,
             position: 10
         }]

      @UI: {
            lineItem: [{ position: 10 }],
            identification: [{ position: 10 }]
        }
        @EndUserText.label: 'SO Id'
    key Soid,
    
    @UI: {
        lineItem: [{ position: 20 }],
        identification: [{ position: 20 }]
      }
   key Posnr,
   
   @UI: {
        lineItem: [{ position: 30 }],
        identification: [{ position: 30 }]
      }
      @EndUserText.label: 'Product'
    Matnr,
    
    @UI: {
        lineItem: [{ position: 40 }],
        identification: [{ position: 40 }] }
    Kdmat,
    Meins,
    Vrkme,
    Pstyv,
    Werks,
    Waerk,
    /* Associations */
   _header : redirected to parent ZC_SO_HEADER
}
