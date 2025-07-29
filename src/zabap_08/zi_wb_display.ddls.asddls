@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Display'
define root view entity ZI_WB_DISPLAY as select from zmmt_weigh_bridg

{
    key gp_no as GpNo,
    key ebeln as Ebeln,
    key ebelp as Ebelp,
    entry_type as EntryType,
    lgort as Lgort,
    @Semantics.quantity.unitOfMeasure: 'Qtyuom'
    quantity as Quantity,
    qtyuom as Qtyuom,
    charg as Charg,
    matnr as Matnr,
    yy1_chillingcenter_pdi as Yy1ChillingcenterPdi,
    yy1_compartment_pdi as Yy1CompartmentPdi,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    total_wt as TotalWt,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    item_wt as ItemWt,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    tare_wt as TareWt,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    diff_wt as DiffWt,
    @Semantics.quantity.unitOfMeasure: 'WeightUnit'
    tsheet_wt as TsheetWt,
    weight_unit as WeightUnit,
    trucksheet_no as TrucksheetNo,
    mblnr as Mblnr,
    zeile as Zeile,
    mjahr as Mjahr,
    werks as Werks,
    fulltruckunload as Fulltruckunload,
    created_by as CreatedBy,
    created_on as CreatedOn,
    changed_by as ChangedBy,
    changed_on as ChangedOn
   // Make association public
}
