@EndUserText.label: 'Purchase register'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_PURRCHASE_REGISTER 
provider contract transactional_query
as projection on ZI_PURCHASE_REGISTER_BASE
{  @EndUserText.label: 'Fiscal Year'
    key FiscalYear,
    @EndUserText.label: 'Accounting Document'
    key AccountingDocument,
    @EndUserText.label: 'Accounting Document Item'
    key AccountingDocumentItem,
   @EndUserText.label: 'Document Type'
    AccountingDocumentType,
    @EndUserText.label: 'Posting Date'
    PostingDate,
    @EndUserText.label: 'Document Date'
    DocumentDate,
    @EndUserText.label: 'Referecne Document'
    ReferenceDocument,
    @EndUserText.label: 'PO Number'
    PurchasingDocument,
    @EndUserText.label: 'PO Item'
    PurchasingDocumentItem,
    @EndUserText.label: 'GL Account'
    GLAccount,
    @EndUserText.label: 'Material Document'
    MaterialDocument,
    g,
     @EndUserText.label: 'GRN FI Document'
    GRNFIDOC,
    /* Associations */
    _Matdoc
}
