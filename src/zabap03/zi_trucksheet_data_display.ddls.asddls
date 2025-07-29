@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for truck sheet'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_TRUCKSHEET_DATA_DISPLAY
  as select from zsdt_truckshet_h as _header
  //  association to parent  ZI_TRUCKSHET_H as _header on $projection.itemTrucksheetNo = _header.TrucksheetNo

  //as select from ZI_TRUCKSHET_H as _header
{
@UI.lineItem: [{ position: 10}]  
  key _header.trucksheet_no   as TrucksheetNo,
      _header.vehicle_no      as VehicleNo,
      _header.driver_name     as DriverName,
      _header.driver_telno    as DriverTelno,
      _header.trucksheet_date as TrucksheetDate,
      _header.trans_doc_no    as TransDocNo,
      _header.pdf_data        as PDF,
      _header.created_by      as CreatedBy,
      _header.created_on      as CreatedOn
      
}
