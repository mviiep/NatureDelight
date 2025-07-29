@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vendor debit form'
define root view entity ZI_VENDOR_DEBIT_FORM_DISPLAY
  as select from I_JournalEntry
  association [0..*] to ztvendor_debit as _VendorDebit on  _VendorDebit.accountingdocument = $projection.AccountingDocument
                                                       and _VendorDebit.fiscalyear         = $projection.FiscalYear

{
  key AccountingDocument,
  key FiscalYear,
      _VendorDebit.accountingdocument as accountingdoctable,
      _VendorDebit.fiscalyear         as fiscalyeartable,
      _VendorDebit.pdf_data           as pdf


      // Make association public
}
where AccountingDocumentType = 'KG'
