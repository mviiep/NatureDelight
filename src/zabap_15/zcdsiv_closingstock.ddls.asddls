@AbapCatalog.sqlViewName: 'ZMATSTOCK1'
@ObjectModel: {
                usageType: {
                              sizeCategory: #XXL,
                              serviceQuality: #D,
                              dataClass:#TRANSACTIONAL
                            }
               }



@EndUserText.label: 'Material Closing Stock View As on Date'
define view ZCDSIV_ClosingStock    
with parameters
    P_EndDate : vdm_v_key_date    
as select from I_MatlStkAtKeyDateInAltUoM(P_KeyDate: :P_EndDate) as Stock

{
       // Stock Identifier
  key Stock.Product as Product,
  key Stock.Plant,
  key Stock.StorageLocation,
  key Stock.Batch,
  key Stock.Supplier,
  key Stock.SDDocument,
  key Stock.SDDocumentItem,
  key Stock.WBSElementInternalID,
  key Stock.Customer,
  key Stock.SpecialStockIdfgStockOwner,
  key Stock.InventoryStockType,
  key Stock.InventorySpecialStockType,
      // Units
  key Stock.MaterialBaseUnit,
  //key UoM.AlternativeUnit,
      Stock.CompanyCode,
      Stock.FiscalYearVariant,

           // Quantities in Base Unit of Measure
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      MatlWrhsStkQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      MatlCnsmpnQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      MatlStkIncrQtyInMatlBaseUnit,
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      MatlStkDecrQtyInMatlBaseUnit

    }
