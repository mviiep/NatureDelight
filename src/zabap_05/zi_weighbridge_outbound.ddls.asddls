@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Wieghbridge Outbound'
define root view entity ZI_WEIGHBRIDGE_OUTBOUND
  as select from ztout_weighbrid

{
  key trucksheet_no           as TrucksheetNo,
      vehicle_no              as VehicleNo,
      total_trucksheet_weight as TotalTrucksheetWeight,
      tare_weight             as TareWeight,
      weighbridge_weight      as WeighbridgeWeight,
      difference_weight       as DifferenceWeight,
      weight_unit             as WeightUnit,
      @Semantics.user.createdBy: true
      created_by              as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_on              as CreatedOn

}
