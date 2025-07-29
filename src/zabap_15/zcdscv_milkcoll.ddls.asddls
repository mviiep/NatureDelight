@AbapCatalog.sqlViewName: 'ZCNMILKCOLLN'
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.compiler.compareFilter: true
@ObjectModel.usageType.dataClass: #MIXED
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.sizeCategory: #L
@Analytics.query: true
@ObjectModel.modelingPattern:#ANALYTICAL_QUERY
@EndUserText.label: 'Milk Collection report'
define view ZCDSCV_MILKCOLL
  with parameters
    @EndUserText.label: 'Milk Collection Start Date'
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @EndUserText.label: 'Milk Collection End Date'
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from ZCDSIV_MilkColl(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate)
{

      @EndUserText.label: 'Plant'
  key plant,
      @EndUserText.label: 'StorageLocation'
  key Sloc,
      @EndUserText.label: 'Collection Date'
  key CollDate,
      @EndUserText.label: 'Material'
      matnr,
      @EndUserText.label: 'Supplier'
      Lifnr,
      //      @EndUserText.label: 'PostingDate'
      //      PostingDate,
      @Semantics.unitOfMeasure: true
      @EndUserText.label: 'MilkUnit'
      Milkuom,
      @EndUserText.label: 'Milk Qty'

      @Semantics.quantity.unitOfMeasure: 'MILKUOM'
      @AnalyticsDetails.query.decimals: 3
      @AnalyticsDetails.query.formula: 'MilkQty * 1'
      //  @AnalyticsDetails: {
      //    exceptionAggregationSteps: [
      //        { exceptionAggregationBehavior: #SUM,
      //          exceptionAggregationElements: ['BillingDocument', 'BillingDocumentItem', 'DeliveryDocument',
      //       'DeliveryDocumentItem']  }
      //    ]
      //  }
      @DefaultAggregation: #FORMULA
      cast(1 as abap.quan( 25,3 )) as MilkQty,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Fat'
      @DefaultAggregation: #AVG
      @Semantics.quantity.unitOfMeasure : 'fatuom'
      fat,
      @EndUserText.label: 'SNF'
      @DefaultAggregation: #AVG
      @Semantics.quantity.unitOfMeasure : 'fatuom'
      snf,
      @EndUserText.label: 'FAT/SNF Unit'
      @Semantics.unitOfMeasure: true
      fatuom
      //      @EndUserText.label: 'GLAccount'
      //      GLAccount,
      //      @EndUserText.label: 'Amount'
      //      @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
      //      @AnalyticsDetails.query.decimals: 3
      //      @AnalyticsDetails.query.formula: 'AmountInCompanyCodeCurrency * 1 '
      //      //  @AnalyticsDetails: {
      //      //    exceptionAggregationSteps: [
      //      //        { exceptionAggregationBehavior: #SUM,
      //      //          exceptionAggregationElements: ['BillingDocument', 'BillingDocumentItem', 'DeliveryDocument',
      //      //       'DeliveryDocumentItem']  }
      //      //    ]
      //      //  }
      //      @DefaultAggregation: #FORMULA
      //      cast(1 as abap.curr( 25,3 )) as AmountInCompanyCodeCurrency,
      //      @EndUserText.label: 'Currency'
      //      @Semantics.currencyCode: true
      //      CompanyCodeCurrency
}
