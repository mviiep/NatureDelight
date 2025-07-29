@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Truck Sheet Item Print'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
// serviceQuality: #X,
// sizeCategory: #S,
// dataClass: #MIXED
//}
define view entity ZI_TRUCKSHEET_ITEM_PRINT as select from zsdt_truckshet_i
association to parent ZI_TRUCKSHEET_HEADER_PRINT as _header

on $projection.TrucksheetNo = _header.TrucksheetNo
association[0..*] to ZCDS_CURRENT_STOCK as _Stock
on $projection.kunag = _Stock.Customer
association[0..*] to I_CustomerSalesArea as _CustArea
on $projection.kunag = _CustArea.Customer
//soc by naga on 30-04-2025
association[1..1] to ZCDS_PARTNER1 as _partner
 on $projection.Vbeln = _partner.vbeln  

//eoc by naga on 30-04-2025

{
key trucksheet_no as TrucksheetNo,
key trucksheet_item as TrucksheetItem,
vbeln as Vbeln,
kunag as kunag,
//name1 as Name1, // commented by naga on 30-04-2025
route as Route,
matkl as Matkl,
meins as Meins,
@Semantics.quantity.unitOfMeasure: 'meins'
qty as Qty,
noofcrate as Noofcrate,
noofcan as Noofcan,
currency as Currency,

_partner.name1 as Name1, //added by naga on 30-04-2024
_partner.Cust as Cust,
@Semantics.amount.currencyCode: 'currency'
amount as Amount,
@Semantics.quantity.unitOfMeasure: 'meins'
_Stock.MatlWrhsStkQtyInMatlBaseUnit as StockQty,
case _CustArea.CustomerGroup
when '01'
then 'Daily'
when '02'
then 'One Day'
end as CrateDays,
_header
}
//group by TrucksheetNo ,TrucksheetItem;
