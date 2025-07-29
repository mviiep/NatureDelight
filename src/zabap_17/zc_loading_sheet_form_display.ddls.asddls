@EndUserText.label: 'loading sheet Disaply'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define  root view entity ZC_LOADING_SHEET_FORM_DISPLAY 
provider contract transactional_query
as projection on ZI_LOADING_SHEET_FORM_DISPLAY
{   @EndUserText.label: 'TruckSheet No'
    key TruckSheetNo,
    @EndUserText.label: 'Vehicle No'
    VehicleNo,
    @EndUserText.label: 'Driver Name'
    DriverName,
    LoadTruckseet,
    LOADPDF
}
