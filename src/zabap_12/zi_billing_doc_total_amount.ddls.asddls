@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Document Total Amount'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_BILLING_DOC_TOTAL_AMOUNT as select from I_BillingDocument 

{
key  BillingDocument, 
TransactionCurrency,
 @Semantics.amount.currencyCode: 'TransactionCurrency' 
sum( TotalNetAmount + TotalTaxAmount ) as TotalAmount 
}
group by BillingDocument,
TransactionCurrency
