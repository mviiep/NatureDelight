@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For Billing Document'
define root view entity ZI_BILLINGDOCUMENT as select from I_BillingDocument as A
left outer join zsdt_billprint as B 
on A.BillingDocument = B.billingdocument
inner join ZI_BILLING_DOC_TOTAL_AMOUNT as C
on A.BillingDocument =  C.BillingDocument
{
 key A.BillingDocument,
 A.BillingDocumentType,
 A.SoldToParty,
 A._SoldToParty.CustomerFullName, 
 A.SalesOrganization,
 A.DistributionChannel,
 A.Division,
 A.BillingDocumentDate,
 A.TotalNetAmount,
 A.TransactionCurrency,
 @Semantics.amount.currencyCode: 'TransactionCurrency' 
 A.TotalTaxAmount,
 C.TotalAmount,
// PayerParty,
// _PayerParty.CustomerFullName,
 A.CompanyCode,
 A.FiscalYear,
 A.AccountingDocument,
 A.CreatedByUser,
 A.CreationDate, 
/* Associations */
 A._SoldToParty,
 B.pdf_data 
}
where  A.BillingDocumentIsCancelled is initial
  and  A.CancelledBillingDocument is initial
