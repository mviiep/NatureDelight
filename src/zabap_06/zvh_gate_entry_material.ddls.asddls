@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material For Gate entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZVH_GATE_ENTRY_MATERIAL as select from I_Product

{
   key Product  as MaterialNo,
   _Text.ProductName as MaterialDescr
   
  
}where ProductGroup = '2001' and ProductType = 'ZRAW';
