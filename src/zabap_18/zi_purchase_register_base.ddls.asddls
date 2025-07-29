@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase register'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_PURCHASE_REGISTER_BASE as select from ZI_PURCHASE_REGISTER
association[0..*] to I_JournalEntryItem as _ref on 
$projection.MaterialDocument = _ref.ReferenceDocument
{
    key FiscalYear,
    key AccountingDocument,
    key AccountingDocumentItem,
    AccountingDocumentType,
    PostingDate,
    DocumentDate,
    ReferenceDocument,
    PurchasingDocument,
    PurchasingDocumentItem,
    GLAccount,
    MaterialDocument,
    g,
    _ref.AccountingDocument as GRNFIDOC,
    /* Associations */
    _Matdoc
   
}
