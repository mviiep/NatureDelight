@AbapCatalog.sqlViewName: 'ZCMMILKDEDAMNTSF'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
@Analytics.settings.maxProcessingEffort: #HIGH

@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Milk Amount Deduction SF'
define view ZCDSIV_MILKDEDUCTION 
with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from ZCDSIV_GLAccountItem(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate)
  
{
  @ObjectModel.foreignKey.association: '_StorLoc'
  StorageLocation,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @DefaultAggregation: #SUM
  AmountInCompanyCodeCurrency,
  @Semantics.currencyCode: true
  CompanyCodeCurrency,
  PostingDate,
  _CompanyCodeCurrency,
  Plant,
  _Plant1,
  _StorLoc,
  GLAccount

}
