@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for truck sheet Header'
define root view entity ZI_TRUCKSHET_H
  as select from zsdt_truckshet_h
  composition [0..*] of ZI_TRUCKSHET_HI_VIEW as _item
{
  key trucksheet_no   as TrucksheetNo,
      vehicle_no      as VehicleNo,
      driver_name     as DriverName,
      driver_telno    as DriverTelno,
      trucksheet_date as TrucksheetDate,
      trans_doc_no    as TransDocNo,
      crate_days      as CrateDays,
      created_by      as CreatedBy,
      created_on      as CreatedOn,
      creation_date   as CreationDate,
      _item
}
