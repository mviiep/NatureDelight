@AbapCatalog.sqlViewName: 'ZMATOPNCLOST'

@ObjectModel: {
                usageType: {
                              sizeCategory: #XXL,
                              serviceQuality: #D,
                              dataClass:#TRANSACTIONAL
                            },
                 modelingPattern: #ANALYTICAL_CUBE,
                 supportedCapabilities: [#ANALYTICAL_PROVIDER, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]
               }
@Analytics: {
              dataCategory:#CUBE
             }
@EndUserText.label: 'View for Opening Closing'
define view ZCDSIV_OpenCloseStock 
with parameters
    P_StartDate :vdm_v_key_date,
    P_EndDate : vdm_v_key_date 
    

as select from ZCDSIV_CLOSINGSTOCK1( P_EndDate : $parameters.P_StartDate)
{
//View For opening stock
  Product,
  Plant,
  StorageLocation,
  Batch,
  Supplier,
  SDDocument,
  SDDocumentItem,
  WBSElementInternalID,
  Customer,
  SpecialStockIdfgStockOwner,
  InventoryStockType,
  InventorySpecialStockType,
// Quantity in BUoM
  MaterialBaseUnit,
  AlternativeUnit,
  CompanyCode,
  FiscalYearVariant,
  cast('' as abap.char( 3 )) as GoodsMovementType,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  cast(0 as abap.quan( 31, 14 )) as MatlWrhsStkQtyInMatlBaseUnit,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  cast(0 as abap.quan( 31, 14 )) as ClosingStock,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  MatlWrhsStkQtyInMatlBaseUnit as OpeningStock,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlStkDecrQtyInMatlBaseUnit
}
union all

select from ZCDSIV_CLOSINGSTOCK1( P_EndDate : $parameters.P_EndDate)
{

//View For closing Stock

  Product,
  Plant,
  StorageLocation,
  Batch,
  Supplier,
  SDDocument,
  SDDocumentItem,
  WBSElementInternalID,
  Customer,
  SpecialStockIdfgStockOwner,
  InventoryStockType,
  InventorySpecialStockType,
// Quantity in BUoM
  MaterialBaseUnit,
  AlternativeUnit,
  CompanyCode,
  FiscalYearVariant,
  
  cast('' as abap.char( 3 )) as GoodsMovementType,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  cast(0 as abap.quan( 31, 14 )) as MatlWrhsStkQtyInMatlBaseUnit,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  MatlWrhsStkQtyInMatlBaseUnit as ClosingStock,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  cast(0 as abap.quan( 31, 14 )) as OpeningStock,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  cast(0 as abap.quan( 31, 14 )) as MatlStkDecrQtyInMatlBaseUnit
  
}
union all
 select from  I_MaterialDocumentItem_2
{
  Material as Product,
  Plant,
  StorageLocation,
  Batch,
  Supplier,
  SalesOrder as SDDocument,
  SalesOrderItem as SDDocumentItem ,
           
  WBSElementInternalID,
  Customer,
  StockOwner as SpecialStockIdfgStockOwner,
  InventoryStockType,
  InventorySpecialStockType,
// Quantity in BUoM
  MaterialBaseUnit,
  MaterialBaseUnit as AlternativeUnit,
  CompanyCode,
  FiscalYearVariant,
  
  GoodsMovementType,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  QuantityInBaseUnit as MatlWrhsStkQtyInMatlBaseUnit,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  cast(0 as abap.quan( 31, 14 )) as ClosingStock,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  cast(0 as abap.quan( 31, 14 )) as OpeningStock,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
   cast(0 as abap.quan( 31, 14 )) as MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
   cast(0 as abap.quan( 31, 14 )) as MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
   cast(0 as abap.quan( 31, 14 )) as MatlStkDecrQtyInMatlBaseUnit
  
}
where PostingDate>= :P_StartDate and PostingDate<= :P_EndDate

