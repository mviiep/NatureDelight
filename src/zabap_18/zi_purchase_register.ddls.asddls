@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Purchase Register'
define root view entity ZI_PURCHASE_REGISTER
  as select from I_JournalEntryItem
  association [0..*] to I_MaterialDocumentItem_2 as _Matdoc
  on $projection.PurchasingDocument =  _Matdoc.PurchaseOrder
  and $projection.PurchasingDocumentItem = _Matdoc.PurchaseOrderItem

  


{

  key  FiscalYear,
  key  AccountingDocument,
  key  AccountingDocumentItem,
       AccountingDocumentType,
       PostingDate,
       DocumentDate,
       ReferenceDocument,
       PurchasingDocument,
       PurchasingDocumentItem,
       GLAccount,
       _Matdoc.MaterialDocument,
       concat(_Matdoc.MaterialDocument ,FiscalYear ) as g,
        _Matdoc

}
where
      AccountingDocumentType       = 'RE'
  and TransactionTypeDetermination = 'WRX'
  and IsReversal                   is initial
  and IsReversed                   is initial;
