@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View for Weigh Bridge Data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZV_Weigh_Bridge
  as select from    I_PurchaseOrderItemAPI01 as _ekpo
  inner join zdt_gate_entry as _gate on _ekpo.PurchaseOrder = _gate.sto_no
    left outer join zmmt_weighbridge         as _cust on  _ekpo.PurchaseOrder     = _cust.ebeln
                                                      and _ekpo.PurchaseOrderItem = _cust.ebelp
{
  key _gate.gate_entry_no             as gatepass_no,
  key _ekpo.PurchaseOrder             as Purchase_Order,
  key _ekpo.PurchaseOrderItem         as Purchase_Order_Item,
      _ekpo.StorageLocation           as Storage_Location,
      @Semantics.quantity.unitOfMeasure : 'Quantity_UOM'
      _ekpo.OrderQuantity             as Quantity,
      _ekpo.PurchaseOrderQuantityUnit as Quantity_UOM,
      _ekpo.YY1_ChillingCenteChill_PDI    as Chilling_Center,
      _ekpo.YY1_Compartment_PDI       as Compartment,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      _cust.total_wt                  as TotalWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      _cust.item_wt                   as ItemWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      _cust.diff_wt                   as DiffereceWt,
      _cust.weight_unit               as WeightUnit,
      _cust.created_by                as CreatedBy,
      _cust.created_on                as CreatedOn
}
