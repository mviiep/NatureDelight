@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Vehicle Master'
define root view entity ZI_MM_VEHICLE
  as select from ztmm_vehicle
{
  key vid as Vid,
  vehicle_no    as VehicleNo,
  effdate       as Effdate,
      lifnr        as Vendor,
      name1        as VendorName,
      vehi_type    as VehicleType,
      cap          as Capacity,
      capuom       as CapacityUnit,
      currency     as Currency,
      @Semantics.amount.currencyCode: 'Currency'
      rate         as Rate,
      driver_name  as Driver,
      driver_telno as DriverPhone,
      @Semantics.user.createdBy: true
      created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      created_on as CreatedOn
}
