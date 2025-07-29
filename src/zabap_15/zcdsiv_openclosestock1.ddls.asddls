@AbapCatalog.sqlViewName: 'ZMATOPNCLOST1'

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
define view ZCDSIV_OpenCloseStock1 
with parameters
    P_StartDate :vdm_v_key_date,
    P_EndDate : vdm_v_key_date
    

as select from ZCDSIV_OpenCloseStock( P_StartDate : $parameters.P_StartDate , P_EndDate : $parameters.P_EndDate)
 association [0..1] to I_Product                   as _Product                    on  $projection.Product                    = _Product.Product
  association [0..1] to I_Plant                     as _Plant                      on  $projection.Plant                      = _Plant.Plant
  association [0..1] to I_StorageLocation           as _StorageLocation            on  $projection.Plant                      = _StorageLocation.Plant
                                                                                   and $projection.StorageLocation            = _StorageLocation.StorageLocation
  association [0..1] to I_Supplier                  as _Supplier                   on  $projection.Supplier                   = _Supplier.Supplier
  association [0..1] to I_Customer                  as _Customer                   on  $projection.Customer                   = _Customer.Customer
  association [0..1] to I_Supplier                  as _SpecialStockIdfgStockOwner on  $projection.SpecialStockIdfgStockOwner = _SpecialStockIdfgStockOwner.Supplier
  association [0..1] to I_InventorySpecialStockType as _InventorySpecialStockType  on  $projection.InventorySpecialStockType  = _InventorySpecialStockType.InventorySpecialStockType
  association [0..1] to I_InventoryStockType        as _InventoryStockType         on  $projection.InventoryStockType         = _InventoryStockType.InventoryStockType
  association [1..1] to I_UnitOfMeasure             as _UnitOfMeasure              on  $projection.MaterialBaseUnit           = _UnitOfMeasure.UnitOfMeasure
  association [1..1] to I_CompanyCode               as _CompanyCode                on  $projection.CompanyCode                = _CompanyCode.CompanyCode


{
     
         @ObjectModel.foreignKey.association: '_Product'
//View For Closing Date
  
  
  Product,
  
  @ObjectModel.foreignKey.association: '_Plant'
  Plant,
   @ObjectModel.foreignKey.association: '_StorageLocation'
  StorageLocation,
  
  
  left(StorageLocation,4) as Batch1, 
  
  Batch,
  @ObjectModel.foreignKey.association: '_Supplier'
  Supplier,
  SDDocument,
  SDDocumentItem,
  WBSElementInternalID,
    @ObjectModel.foreignKey.association: '_Customer'
  Customer,
  SpecialStockIdfgStockOwner,
  InventoryStockType,
  InventorySpecialStockType,
// Quantity in BUoM
  MaterialBaseUnit,
  AlternativeUnit,
  @ObjectModel.foreignKey.association: '_CompanyCode'
  CompanyCode,
  FiscalYearVariant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  MatlWrhsStkQtyInMatlBaseUnit,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  ClosingStock,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  OpeningStock,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlStkDecrQtyInMatlBaseUnit,
  @EndUserText.label: 'ReceiptatKalas'
  
  @DefaultAggregation: #SUM
   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  case when Plant='1101' and (GoodsMovementType='351' or GoodsMovementType='352') and Product='000000000010000001'then MatlWrhsStkQtyInMatlBaseUnit end as ReceiptatKalas,
  @EndUserText.label: 'Purchaseondock'
  @DefaultAggregation: #SUM
   @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  case when Plant='1102' and (GoodsMovementType='101' or GoodsMovementType='102') and Product='000000000010000001'then MatlWrhsStkQtyInMatlBaseUnit end as Purchaseondock,
  
  GoodsMovementType,
      // Associations for names and descriptions
      _UnitOfMeasure,
      _Product,
      _Plant,
      _StorageLocation,
      _Supplier,
      _Customer,
      _SpecialStockIdfgStockOwner,
      _InventoryStockType,
      _InventorySpecialStockType,
      _CompanyCode
}
