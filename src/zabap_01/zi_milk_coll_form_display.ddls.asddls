@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Milk collection form Display'
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZI_MILK_COLL_FORM_DISPLAY as select 
 from ZI_zmm_milk_miro //ZI_ZMM_MILKCOLL

association[0..1] to I_SupplierInvoiceAPI01 as _SupplierInvoice
on _SupplierInvoice.SupplierInvoice = $projection.Mirodoc
and _SupplierInvoice.FiscalYear      = $projection.Miroyear
association[0..1] to  I_JournalEntry as _JournalEntry
on _JournalEntry.OriginalReferenceDocument = $projection.supplierinvoicewthnfiscalyear

{
    key Mirodoc,
    key Miroyear,
    Lifnr,
    Name1,
    Plant,
    Sloc,
    Pdf,
    
    _SupplierInvoice.PostingDate,
    _SupplierInvoice.SupplierInvoiceWthnFiscalYear,
    _JournalEntry,
    _SupplierInvoice
    
    
}
where Mirodoc is not initial
