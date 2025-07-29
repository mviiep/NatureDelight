@AbapCatalog.sqlViewName: 'ZCMLOSSGAINB'
@ObjectModel: {
usageType: {
dataClass: #MIXED,
serviceQuality: #D,
sizeCategory: #XXL
}
}
@Analytics.settings.maxProcessingEffort: #HIGH
//@VDM.viewType: #COMPOSITE
@Analytics.dataCategory: #CUBE
@EndUserText.label: 'Loss Gain Report base'
define view ZCDSIV_LossGainBase
with parameters
 P_EndDate : sydate
 
as select from I_MaterialStock_2
{
   key Material,
   key Plant,
   key StorageLocation,
   key Batch,
   key Supplier,
   key SDDocument,
   key SDDocumentItem,
   key WBSElementInternalID,
   key Customer,
   key SpecialStockIdfgStockOwner,
   key InventoryStockType,
   key InventorySpecialStockType,
   key FiscalYearVariant,
   key MatlDocLatestPostgDate,
   key MaterialBaseUnit,
   key CostEstimate,
   key ResourceID,
   CompanyCode,
   MatlWrhsStkQtyInMatlBaseUnit,
   MatlCnsmpnQtyInMatlBaseUnit,
   MatlStkIncrQtyInMatlBaseUnit,
   MatlStkDecrQtyInMatlBaseUnit,
   /* Associations */
   _CompanyCode,
   _CurrentInvtryPrice,
   _Customer,
   _InventoryPriceByPeriodEndDate,
   _InventorySpecialStockType,
   _InventoryStockType,
   _InvtryPrcBasicByPeriodEndDate,
   _Material,
   _Plant,
   _ResourceBasic,
   _SpecialStockIdfgStockOwner,
   _StorageLocation,
   _Supplier,
   _UnitOfMeasure 
}

where MatlDocLatestPostgDate < $parameters.P_EndDate
