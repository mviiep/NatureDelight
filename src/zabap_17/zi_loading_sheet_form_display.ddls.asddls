@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'loading sheet Disaply'
define root view entity ZI_LOADING_SHEET_FORM_DISPLAY as select from ZI_TRUCKSHEET_FORM_DISPLAY
association  [0..*] to zsdt_load_sheet as _LoadSheet on
_LoadSheet.trucksheet_no = $projection.TruckSheetNo
{
    key ZI_TRUCKSHEET_FORM_DISPLAY.TrucksheetNo as TruckSheetNo,
    ZI_TRUCKSHEET_FORM_DISPLAY.VehicleNo as VehicleNo,
    ZI_TRUCKSHEET_FORM_DISPLAY.DriverName as DriverName,
    _LoadSheet.trucksheet_no as LoadTruckseet,
    _LoadSheet.pdf_data  as LOADPDF
    
  
  
}
