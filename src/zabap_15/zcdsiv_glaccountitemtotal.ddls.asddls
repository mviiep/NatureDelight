@AbapCatalog.sqlViewName: 'ZCMGLACCLINITMT'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
@Analytics.settings.maxProcessingEffort: #HIGH

@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Base view for I_GLAccountLineItem'
define view ZCDSIV_GLACCOUNTITEMTotal
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from I_GLAccountLineItem
  association [0..1] to I_StorageLocation as _StorLoc on  $projection.StorageLocation = _StorLoc.StorageLocation
                                                      and $projection.Plant           = _StorLoc.Plant
  association [0..1] to I_Plant           as _Plant1  on  $projection.Plant = _Plant1.Plant
{
  //  @ObjectModel.foreignKey.association: '_StorLoc'
  cast(AssignmentReference as abap.char( 4)) as StorageLocation,
  @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
  @DefaultAggregation: #SUM
  AmountInCompanyCodeCurrency,
  @Semantics.currencyCode: true
  CompanyCodeCurrency,
  PostingDate,
  _CompanyCodeCurrency,
  @ObjectModel.foreignKey.association: '_Plant1'
  Plant,
  _Plant1,
  _StorLoc,
  GLAccount

}
where
    AccountingDocumentType = 'KM'
  and(
    PostingDate            between $parameters.P_StartDate and $parameters.P_EndDate
  )
