@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LEAKAGE_BILLINGDOC as select  distinct from  I_CustomerReturnItem
association[0..1]  to I_BillingDocumentItem as _billdocitem on
  $projection.ReferenceSDDocument = _billdocitem.BillingDocument and $projection.ReferenceSDDocumentItem
  = _billdocitem.BillingDocumentItem
{
   key    CustomerReturn,
   key CustomerReturnItem,
   ReferenceSDDocument,
   ReferenceSDDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
    _billdocitem.BillingQuantity,
     _billdocitem.BillingQuantityUnit
     
        
}
