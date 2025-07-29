@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Entity View for Weigh Bridge'
define root view entity ZI_V_WEIGH_BRIDGE
  as select from ZV_Weigh_Bridge  //CDS View Name
  //composition of target_data_source_name as _association_name
{

  key gatepass_no         as gatepass_no,
  key Purchase_Order      as EBELN,
  key Purchase_Order_Item as EBELP,
  key Purchase_Order      as saveButton,
      Storage_Location    as LGORT,
      @Semantics.quantity.unitOfMeasure : 'QuantityUOM'
      Quantity            as Quantity,
      Quantity_UOM        as QuantityUOM,
      Chilling_Center     as ChilCenter,
      Compartment         as Compartment,
      @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
      TotalWeight         as Total_wt,
      @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
      ItemWeight          as Item_Wt,
      @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
      DiffereceWt         as Diff_Wt,
      WeightUnit          as Weight_Unit,
      CreatedBy           as CreatedBy,
      CreatedOn           as CreatedOn
}
