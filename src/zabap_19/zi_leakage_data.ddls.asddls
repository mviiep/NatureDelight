@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leakage Data'

define root view entity ZI_LEAKAGE_DATA
  as select distinct from I_CustomerReturnItem


  association [0..*] to I_CustomerReturn       as _head   on $projection.CustomerReturn = _head.CustomerReturn
  association [0..*] to ZI_LEAKAGE_CUSTOMER    as _cust   on $projection.CustomerReturn = _cust.CustomerReturn
  association [0..*] to ZI_LEAKAGE_RETURN_CODE as _reason on $projection.CustomerReturn = _reason.CustomerReturn
  //  association [0..1] to ZI_LEAKAGE_BILLINGDOC as _billdocitem on
  //  $projection.CustomerReturn = _billdocitem.CustomerReturn and $projection.CustomerReturnItem
  //  = _billdocitem.CustomerReturnItem



{

  key CustomerReturn,
  key CustomerReturnItem,
      BillingDocumentDate,
      _cust.Customer                 as soldtoparty,
      _cust.CustomerName,
      Product,
      CustomerReturnItemText,
      @Semantics.quantity.unitOfMeasure: 'ItemWeightUnit'
      ItemNetWeight,
      ItemWeightUnit,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      NetAmount,
      cast( NetAmount as abap.fltp ) as netamount1,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,
      @Semantics.amount.currencyCode: 'TransactionCurrency'

      NetAmount + TaxAmount          as GrossAmount,
      TransactionCurrency,
      ReturnReason,
      _reason.ReturnReasonName,
      _head.SDDocumentReason,
      _head._SDDocumentReason._Text.SDDocumentReasonText,
      _reason,


      ReferenceSDDocument,
      ReferenceSDDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'RequestedQuantityUnit'
      OrderQuantity,
      RequestedQuantityUnit,
      NetPriceAmount,
      //      @Semantics.quantity.unitOfMeasure: 'BillingQuantityUnit'
      //       _billdocitem.BillingQuantity,
      //       _billdocitem.BillingQuantityUnit,
      //
      //       case  when _billdocitem.BillingQuantity is initial
      //       then 0
      //
      //       else  cast( cast( NetAmount as abap.dec( 10, 2 )  )  / cast( _billdocitem.BillingQuantity as abap.dec( 10, 2 ) ) as abap.dec( 10, 2 ) )   end  as
      //
      //       rate,



      _cust
      //      _billdocitem
}
