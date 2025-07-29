@AbapCatalog.sqlViewName: 'ZCNMLKAMNTDEDCTN'
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.compiler.compareFilter: true
@ObjectModel.usageType.dataClass: #MIXED
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.sizeCategory: #XXL
@Analytics.query: true
@ObjectModel.modelingPattern:#ANALYTICAL_QUERY
@EndUserText.label: 'Milk Amount Deduction Report'
define view ZCDSCV_MILKDEDUCTIONAMNT
  with parameters
    @EndUserText.label: 'Milk Collection Start Date'
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @EndUserText.label: 'Milk Collection End Date'
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from ZCDSIV_MILKDEDUCTION(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate)

{
  @EndUserText.label: 'StorageLocation'
  StorageLocation,
  @EndUserText.label: 'Deduction amount'
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @DefaultAggregation: #SUM
  AmountInCompanyCodeCurrency,
  @EndUserText.label: 'Currency'
  @Semantics.currencyCode: true
  CompanyCodeCurrency,
  @EndUserText.label: 'Posting Date'
  PostingDate,
  Plant,
  @EndUserText.label: 'GL Account'
  GLAccount
}
