@AbapCatalog.sqlViewName: 'ZCNSALESREPORTQ'
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.compiler.compareFilter: true
@ObjectModel.usageType.dataClass: #MIXED
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.sizeCategory: #XXL
@VDM.viewType: #CONSUMPTION
@Analytics.query: true
//@OData.publish: true

//@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
//@AccessControl.personalData.blocking: #NOT_REQUIRED
//@ObjectModel.supportedCapabilities: #ANALYTICAL_QUERY
@ObjectModel.modelingPattern:#ANALYTICAL_QUERY
@EndUserText.label: 'Sales Route Details'
define view ZCDSCV_SALESREPORT

  with parameters
    @EndUserText.label: 'Billing Start Date'
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @EndUserText.label: 'Billing End Date'
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from ZCDSIV_SalesReport(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate)
{
  @EndUserText.label: 'Invoice'
  BillingDocument,
  @EndUserText.label: 'InvoiceItem'
  BillingDocumentItem,
  @EndUserText.label: 'Sales Document'
  SalesDocument,
  @EndUserText.label: 'Sales Document Item'
  SalesDocumentItem,
  @EndUserText.label: 'Delivery Document'
  DeliveryDocument,
  @EndUserText.label: 'Delivery Document Item'
  DeliveryDocumentItem,

  SalesDocumentItemType,
  SDDocumentCategory,
  ReturnsDeliveryItemCode,
  @EndUserText.label: 'Proposed Route'
  ProposedDeliveryRoute,

  @EndUserText.label: 'SalesNetAmount'
  @Semantics.amount.currencyCode: 'SalesTransactionCurrency'
  @AnalyticsDetails.query.decimals: 3
  @AnalyticsDetails.query.formula: 'SalesNetAmount * 1'
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #SUM,
          exceptionAggregationElements: ['BillingDocument', 'BillingDocumentItem', 'DeliveryDocument',
       'DeliveryDocumentItem']  }
    ]
  }
  cast(1 as abap.curr( 25,3 )) as SalesNetAmount,
  @Semantics.currencyCode: true
  SalesTransactionCurrency,
  @EndUserText.label: 'SalesNetPriceAmount'
  @Semantics.amount.currencyCode: 'SalesTransactionCurrency'
  @AnalyticsDetails.query.decimals: 3
  @AnalyticsDetails.query.formula: 'SalesNetPriceAmount * 1'
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #AVG,
          exceptionAggregationElements: ['BillingDocument', 'BillingDocumentItem', 'DeliveryDocument',
       'DeliveryDocumentItem']  }
    ]
  }
  cast(1 as abap.curr( 25,3 )) as SalesNetPriceAmount,
  @EndUserText.label: 'SalesOrderQuantity'
  @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
  @AnalyticsDetails.query.formula: 'SalesOrderQuantity * 1'
  @AnalyticsDetails.query.decimals: 3
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #AVG,
          exceptionAggregationElements: ['DeliveryDocument','DeliveryDocumentItem']  }
    ]
  }
  cast(1 as abap.quan( 25,3 )) as SalesOrderQuantity,
  @Semantics.unitOfMeasure: true
  OrderQuantityUnit,
  SoldToParty,
  ShipToParty,

  Region,
  @EndUserText.label: 'ActualDeliveryQuantity'
  @AnalyticsDetails.query.formula: 'OriginalDeliveryQuantity * 1'
  @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
  @AnalyticsDetails.query.decimals: 3
  @AnalyticsDetails: {
    exceptionAggregationSteps: [

    { exceptionAggregationBehavior: #SUM,
          exceptionAggregationElements: ['DeliveryDocument','DeliveryDocumentItem', 'BillingDocument', 'BillingDocumentItem']}

    ]
  }
  cast(1 as abap.quan( 25,3 )) as OriginalDeliveryQuantity,
  @Semantics.unitOfMeasure: true

  DeliveryQuantityUnit,



  Division,


  Product,
  ProductGroup,
  Plant,

  @EndUserText.label: 'BillingNetAmount'
  @AnalyticsDetails.query.formula: 'NetAmount * 1 '
  @AnalyticsDetails: {
    exceptionAggregationSteps: [
        { exceptionAggregationBehavior: #SUM,
          exceptionAggregationElements: ['BillingDocument', 'BillingDocumentItem', 'DeliveryDocument',
       'DeliveryDocumentItem']  }
    ]
  }
  @Semantics.amount.currencyCode: 'TransactionCurrency'
  //      @DefaultAggregation: #SUM

  cast(1 as abap.curr( 23,2 )) as BillingNetAmount,

  @Semantics.currencyCode: true
  TransactionCurrency,
  Material,
  Country,

  DistributionChannel,
  @EndUserText.label: 'Customer Account Group'
  CustomerGroup,
  BillingDocumentDate,
  CancelledBillingDocument
}
