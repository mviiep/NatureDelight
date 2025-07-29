@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
@EndUserText.label: 'Interface view for delivery & Invoice'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_DELV_INVOICE
  as select from    zsdt_truckshet_i      as _item

    left outer join I_DeliveryDocument    as _delv    on _item.route = _delv.ActualDeliveryRoute
    left outer join I_BillingDocumentItem as _invoice on _delv.DeliveryDocument = _invoice.ReferenceSDDocument
{
  _item.trucksheet_no       as TrucksheetNo,
  _item.trucksheet_item     as TrucksheetItem,
  _item.vbeln               as Vbeln,
  _item.kunag               as Kunag,
  _item.name1               as Name1,
  _item.route               as Route,
  _item.matkl               as Matkl,
  _item.meins               as Meins,
  @Semantics.quantity.unitOfMeasure : 'Meins'
  _item.qty                 as Qty,
  _item.noofcrate           as Noofcrate,
  _item.noofcan             as Noofcan,
  _item.currency            as Currency,
  @Semantics.amount.currencyCode : 'Currency'
  _item.amount              as Amount,
  _delv.ActualDeliveryRoute as ActualDeliveryRoute,
  _delv.DeliveryDocument    as DeliveryDocument,
  _invoice.BillingDocument  as BillingDocument
}
