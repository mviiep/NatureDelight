@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Entity View for Weigh Bridge'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_WEIGH_BRIDGE
  as select from zmmt_weighbridge
{
  key gp_no                  as gatepass_no,
  key ebeln                  as PurchaseOrder,
  key ebelp                  as PurchaseOrderItem,
      lgort                  as StorageLocation,
      @Semantics.quantity.unitOfMeasure : 'QuantityUOM'
      quantity               as Quantity,
      qtyuom                 as QuantityUOM,
      yy1_chillingcenter_pdi as ChilCenter,
      yy1_compartment_pdi    as Compartment,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      total_wt               as TotalWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      item_wt                as ItemWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      diff_wt                as DiffereceWt,
      weight_unit            as WeightUnit,
      created_by             as CreatedBy,
      created_on             as CreatedOn
}
