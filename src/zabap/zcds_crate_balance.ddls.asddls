@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Crate Balalce CDS'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
/*+[hideWarning] { "IDS" : [ "CARDINALITY_CHECK" ]  } */
define root view entity ZCDS_CRATE_BALANCE 
with parameters 
  @EndUserText.label: 'From Date'
  FROM_DATE : abap.dats
//
//  @EndUserText.label: 'To Date'
//  To_DATE : abap.dats   

as select from I_MaterialStock_2

  association [1..1] to I_ProductText as _Material                      
     on  $projection.Material = _Material.Product

  association [1..1] to I_Plant as _Plant                         
     on  $projection.Plant = _Plant.Plant
     
  association [0..1] to I_StorageLocation as _StorageLocation               
     on  $projection.Plant = _StorageLocation.Plant     

  association [0..1] to I_Customer as _Customer 
     on  $projection.Customer = _Customer.Customer     
      
  composition [1..*] of ZCDS_CRATE_BALANCE_ITEM as _item

{
      @ObjectModel.foreignKey.association: '_Material'
  key Material,
      @ObjectModel.foreignKey.association: '_Plant'
  key Plant,
      @ObjectModel.foreignKey.association: '_Customer'
  key Customer,
  key MaterialBaseUnit,
  
//     $parameters.FROM_DATE as frdate,
//     $parameters.To_DATE as todate,  

      // Quantities
      
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      cast(sum(MatlWrhsStkQtyInMatlBaseUnit) as zde_nsdm_stock_qty preserving type)                                                                         
               as MatlWrhsStkQtyInMatlBaseUnit,      

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      cast(sum(MatlCnsmpnQtyInMatlBaseUnit) as zde_nsdm_stock_qty preserving type)                                                                  
      as MatlCnsmpnQtyInMatlBaseUnit,
      
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      cast(sum(case when  MatlStkIncrQtyInMatlBaseUnit > 0 then MatlStkIncrQtyInMatlBaseUnit else 0 end) as abap.quan( 31, 14 ) )      
      as MatlStkIncrQtyInMatlBaseUnit,      

      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @DefaultAggregation : #SUM
      cast(sum(case when  MatlStkDecrQtyInMatlBaseUnit < 0 then abs(MatlStkDecrQtyInMatlBaseUnit) else 0 end) as abap.quan( 31, 14 ) ) 
      as MatlStkDecrQtyInMatlBaseUnit,      
      
      _Material.ProductName, 
      _Customer.BPCustomerName,  
      
      // Associations for names and descriptions
      _Material,
      _Plant,
      _StorageLocation,      
      _Customer,
      _item
//      _InventoryStockType,
//      _InventorySpecialStockType
    
}
where Customer is not initial
and   InventorySpecialStockType = 'V'
and   Plant = '1101'
and   MatlDocLatestPostgDate < $parameters.FROM_DATE
//and   MatlDocLatestPostgDate < $parameters.To_DATE

group by Material, Plant, Customer, MaterialBaseUnit, _Material.ProductName, _Customer.BPCustomerName
