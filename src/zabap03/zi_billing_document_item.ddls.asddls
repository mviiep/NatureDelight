@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}
define view entity ZI_BILLING_DOCUMENT_ITEM as select from I_BillingDocumentItem
{
    key BillingDocument,
//    @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
//    sum( BillingQuantity ) as quantity,
//    BillingQuantityUnit,
      
      TransactionCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'      
     sum( NetAmount ) as amt,
     ReferenceSDDocument
}
where SalesDocumentItemCategory = 'TAN'
group by BillingDocument ,
//BillingQuantityUnit,
TransactionCurrency,
ReferenceSDDocument
;
