@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order Item'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_SALES_ORDER_ITEM
  as select from zsd_sales_item
  association to parent ZI_SALES_ORDER_HEADER as _SalesHeader on $projection.HeaderId = _SalesHeader.Id



{
  key zsd_sales_item.itemid        as ItemId,
      zsd_sales_item.header_id     as HeaderId,
      zsd_sales_item.soid          as SoId,
      zsd_sales_item.item          as Item,
      zsd_sales_item.product       as Product,
      zsd_sales_item.gtin          as Gtin,
      @Semantics.quantity.unitOfMeasure: 'baseunit'
      zsd_sales_item.quatity       as Quatity,
      zsd_sales_item.baseunit      as Baseunit,
      zsd_sales_item.item_category as ItemCategory,
      zsd_sales_item.plant         as Plant,
      zsd_sales_item.route         as Route,
      _SalesHeader.lastchangedat   as Lastchangedat,
      _SalesHeader

}
