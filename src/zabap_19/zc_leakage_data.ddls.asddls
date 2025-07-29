@EndUserText.label: 'Leakage Data'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_LEAKAGE_DATA
  provider contract transactional_query

  as projection on ZI_LEAKAGE_DATA

{
      @EndUserText.label: 'Customer Return'
  key CustomerReturn,
      @EndUserText.label: 'Customer Return Item'
  key CustomerReturnItem,
      @EndUserText.label: 'Billing Document Date'
      BillingDocumentDate,
      @EndUserText.label: 'Customer'
      soldtoparty,
      @EndUserText.label: 'Customer Name'
      CustomerName,
      @EndUserText.label: 'Product'
      Product,
      @EndUserText.label: 'Product Descr'
      CustomerReturnItemText,
      @EndUserText.label: 'Net Weight'
      ItemNetWeight,
      @EndUserText.label: 'Weight Unit'
      ItemWeightUnit,
      @EndUserText.label: 'Net Amount'
      NetAmount,
      @EndUserText.label: 'Tax Amount'
      TaxAmount,
      @EndUserText.label: 'Gross Amount'
      GrossAmount,
      @EndUserText.label: 'Currency'
      TransactionCurrency,
      @EndUserText.label: 'Reference Document'
      ReferenceSDDocument,
      @EndUserText.label: 'Return Reason'
      ReturnReason,
      @EndUserText.label: 'Return Reason Descr'
      ReturnReasonName,
      @EndUserText.label: 'Order'
      SDDocumentReason,
      @EndUserText.label: 'Order Reason Descr'
      SDDocumentReasonText,
      @EndUserText.label: 'Order Quantity'
      OrderQuantity,
      @EndUserText.label: 'Order Quantity Unit'
      RequestedQuantityUnit,
      @EndUserText.label: 'Rate'
      NetPriceAmount
      //      @EndUserText.label: 'Actual Billing Quantity'
      //      BillingQuantity,
      //      BillingQuantityUnit,
      //       @EndUserText.label: 'Rate'
      //      rate


      /* Associations */



}
