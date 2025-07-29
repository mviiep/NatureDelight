@EndUserText.label: 'Milk collection form Display'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define  root view entity ZC_MILK_COLL_FORM_DISPLAY 
provider contract transactional_query
as projection on ZI_MILK_COLL_FORM_DISPLAY
{  @Search.defaultSearchElement: true
   @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_ZMM_MILKCOLL', element: 'Mirodoc' } }]
   @EndUserText.label: 'MIRO Doc' 
    key Mirodoc,
    @EndUserText.label: 'MIRO Doc Year'
    key Miroyear,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Vendor'
    Lifnr,
    @EndUserText.label:'Vendor Name'
    @Search.defaultSearchElement: true
    Name1,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Plant'
    Plant,
    @EndUserText.label: 'Storage Location'
    Sloc,
    @Search.defaultSearchElement: true
    @EndUserText.label: 'Posting Date'
    PostingDate,
    @UI.hidden: true
    SupplierInvoiceWthnFiscalYear,
    @UI.hidden: true
    PDF,

    /* Associations */
    @EndUserText.label: 'Accounting Doc No'
    _JournalEntry.AccountingDocument,
    @EndUserText.label: 'Accounting Doc Year'
    _JournalEntry.FiscalYear

}
