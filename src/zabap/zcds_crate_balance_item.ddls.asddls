@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Crate Balalce Item CDS'
define view entity ZCDS_CRATE_BALANCE_ITEM 
 as select from I_MaterialStock_2

association to parent ZCDS_CRATE_BALANCE as _HEADER
    on  $projection.Material = _HEADER.Material
    and $projection.Plant    = _HEADER.Plant 
    and $projection.Customer = _HEADER.Customer    
    and $projection.MaterialBaseUnit = _HEADER.MaterialBaseUnit
//    and $projection.MatlDocLatestPostgDate <= _HEADER.frdate

  association [1..1] to I_ProductText as _Material                      
     on  $projection.Material = _Material.Product

  association [0..1] to I_Customer as _Customer 
     on  $projection.Customer = _Customer.Customer     
     
{ 
     
  key Material,
  key Plant,
  key Customer, 
  key MaterialBaseUnit,
   MatlDocLatestPostgDate,
  
 
  // Quantities
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  @Aggregation.default: #SUM
  MatlWrhsStkQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  @Aggregation.default: #SUM
  MatlCnsmpnQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  @Aggregation.default: #SUM
  MatlStkIncrQtyInMatlBaseUnit,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
  @Aggregation.default: #SUM
  MatlStkDecrQtyInMatlBaseUnit, 
  
  _Material.ProductName,   
  _Customer.BPCustomerName,  
    
    _Material,
    _HEADER // Make association public
}
where  Customer is not initial
and   InventorySpecialStockType = 'V'
and   Plant = '1101'
//$projection.matldoclatestpostgdate >= $parameters.FROM_DATE
//  and $projection.matldoclatestpostgdate <= $parameters.To_DATE
