@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Truck sheet print'

define root view entity ZI_TRUCKSHEET_FORM_DISPLAY
  as select from zsdt_truckshet_h
 association [0..1] to ZI_TRUCKSHEET_ROUTE as _route
 on $projection.TrucksheetNo = _route.trucksheet_no
 

{
  key trucksheet_no as TrucksheetNo,
      vehicle_no    as VehicleNo,
      driver_name   as DriverName,
      driver_telno  as DriverTelno,

      trans_doc_no  as TransDocNo,
      crate_days    as CrateDays,
      pdf_data      as PdfData,
      creation_date as CreationDate,
//      mimetype      as Mimetype,
//      filename      as Filename,
      created_by    as CreatedBy,
      _route.route as route,
      _route.description as routename
      
   
      //      created_on      as CreatedOn
      // Make association public
}
