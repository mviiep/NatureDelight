@EndUserText.label: 'Vendor debit form'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_VEBNDOR_DEBIT_FORM_DISPLAY
  provider contract transactional_query
  as projection on ZI_VENDOR_DEBIT_FORM_DISPLAY
{
      @EndUserText.label: 'Accounting Document'
  key AccountingDocument,
      @EndUserText.label: 'Fiscal Year'
  key FiscalYear,
      accountingdoctable,
      fiscalyeartable,
      pdf
}
