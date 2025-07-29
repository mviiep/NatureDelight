@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for truck sheet'
define root view entity zI_truckshet
  as select from zsdt_truckshet_h as _header

  association [1] to ZI_DELV_INVOICE as _delv on $projection.TrucksheetNo = _delv.TrucksheetNo

{
  key _header.trucksheet_no   as TrucksheetNo,
      _header.vehicle_no      as VehicleNo,
      _header.driver_name     as DriverName,
      _header.driver_telno    as DriverTelno,
      _header.trucksheet_date as TrucksheetDate,
      _header.trans_doc_no    as TransDocNo,
      _header.created_by      as CreatedBy,
      _header.created_on      as CreatedOn,
      _delv.TrucksheetItem,
      _delv.Vbeln,
      _delv.Kunag,
      _delv.Name1,
      _delv.Route,
      _delv.Matkl,
      _delv.Meins,
      _delv.Qty,
      _delv.Noofcrate,
      _delv.Noofcan,
      _delv.Currency,
      _delv.Amount,
      _delv.ActualDeliveryRoute,
      _delv.DeliveryDocument,
      _delv.BillingDocument,
      _delv
}
