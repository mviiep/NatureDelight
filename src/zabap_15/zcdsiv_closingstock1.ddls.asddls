@AbapCatalog.sqlViewName: 'ZMATSTOCK2'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED

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

@EndUserText.label: 'Material Closing Stock View As on Date'
define view ZCDSIV_CLOSINGSTOCK1 
with parameters
    P_EndDate : vdm_v_key_date    
     


as select from ZCDSIV_ClosingStock( P_EndDate : :P_EndDate)
//left outer join I_ProductUnitsOfMeasure as UoM on ZCDSIV_ClosingStock.Product = UoM.Product
{
  
  ZCDSIV_ClosingStock.Product as Product,
  :P_EndDate as  MatlDocLatestPostgDate,
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
  MaterialBaseUnit as AlternativeUnit,
  CompanyCode,
  FiscalYearVariant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  MatlWrhsStkQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  MatlStkDecrQtyInMatlBaseUnit,
  dats_add_days($parameters.P_EndDate,-1,'INITIAL') as PreviousDate
}

