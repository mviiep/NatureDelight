@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'zsdt_truckshet_i'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRUCKSHEET_ITEM_PRINT_1 as select from zsdt_truckshet_i
{
    key trucksheet_no as TrucksheetNo,
    key trucksheet_item as TrucksheetItem,
    vbeln as Vbeln,
    kunag as Kunag,
    name1 as Name1,
    route as Route,
    matkl as Matkl,
    meins as Meins,
    @Semantics.quantity.unitOfMeasure: 'meins'    
    qty as Qty,
    noofcrate as Noofcrate,
    noofcan as Noofcan,
    currency as Currency,
    @Semantics.amount.currencyCode: 'currency'    
    amount as Amount
}
