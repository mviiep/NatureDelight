@AbapCatalog.sqlViewName: 'ZCMMILKCOLLSF1'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
@Analytics.settings.maxProcessingEffort: #HIGH

@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Milk collection Base View'
define view ZCDSIV_MilkColl
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from zmm_milkcoll
  //  association [0..1] to ZCDSIV_GLAccountItem as _JournalEntry on  $projection.Sloc     = _JournalEntry.StorageLocation
  //                                                              and $projection.CollDate = _JournalEntry.PostingDate
  association [0..1] to I_Product         as _Product  on  $projection.matnr = _Product.Product
  association [0..1] to I_Supplier        as _Supplier on  $projection.Lifnr = _Supplier.Supplier
  association [0..1] to I_Plant           as _Plant    on  $projection.plant = _Plant.Plant
  association [0..1] to I_StorageLocation as _StorLoc  on  $projection.Sloc  = _StorLoc.StorageLocation
                                                       and $projection.plant = _StorLoc.Plant
  association [0..1] to I_Batch           as _Batch    on  $projection.Batch = _Batch.Batch
                                                       and $projection.plant = _Batch.Plant
                                                       and $projection.matnr = _Batch.Material
{
  key   id,
        @ObjectModel.foreignKey.association: '_Plant'
  key   plant,
        @ObjectModel.foreignKey.association: '_StorLoc'
  key   sloc      as Sloc,
  key   coll_date as CollDate,
        'A'       as info,
        //        _JournalEntry(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate).PostingDate,
        @ObjectModel.foreignKey.association: '_Product'
        matnr, //
        @ObjectModel.foreignKey.association: '_Supplier'
        lifnr     as Lifnr, //

        //      fatuom     as Fatuom,
        //      fat        as Fat,
        //      snf        as Snf,
        //      protain    as Protain,
        @Semantics.unitOfMeasure: true
        milkuom   as Milkuom, //
        @DefaultAggregation: #SUM
        @Semantics.quantity.unitOfMeasure: 'MILKUOM'
        milk_qty  as MilkQty, //

        @ObjectModel.foreignKey.association: '_Batch'
        batch     as Batch,
        @DefaultAggregation: #SUM
        @Semantics.quantity.unitOfMeasure : 'fatuom'
        fat,
        @DefaultAggregation: #SUM
        @Semantics.quantity.unitOfMeasure : 'fatuom'
        snf,
        @Semantics.unitOfMeasure: true
        fatuom,
        //        _JournalEntry(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate).GLAccount,
        //        @Semantics.amount.currencyCode: 'CompanyCodeCurrency'
        //        @DefaultAggregation: #SUM
        //        _JournalEntry(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate).AmountInCompanyCodeCurrency,
        //        @Semantics.currencyCode: true
        //        _JournalEntry(P_StartDate : :P_StartDate, P_EndDate : :P_EndDate).CompanyCodeCurrency,
        //        _JournalEntry,
        _Batch,
        _Product,
        _Supplier,
        _Plant,
        _StorLoc

}
where
  coll_date between $parameters.P_StartDate and $parameters.P_EndDate
