@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Truck Sheet header Print'
define root view entity ZI_TRUCKSHEET_HEADER_PRINT
  as select from zsdt_truckshet_h
  composition[0..*] of  ZI_TRUCKSHEET_ITEM_PRINT as _item
  
{
 key trucksheet_no as TrucksheetNo,
 vehicle_no as VehicleNo,
 driver_name as DriverName,
 driver_telno as DriverTelno,
 trucksheet_date as TrucksheetDate,
 trans_doc_no as TransDocNo,
 crate_days as CrateDays,
 created_by as CreatedBy,
 created_on as CreatedOn,
 _item
      //    _association_name // Make association public
      
}
