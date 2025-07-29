@EndUserText.label: 'Truck  sheet jeader print'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define  root view  entity ZC_TRCUCKSHEET_HEADER_PRINT 
as projection on ZI_TRUCKSHEET_HEADER_PRINT
{
    key TrucksheetNo,
    VehicleNo,
    DriverName,
    DriverTelno,
    TrucksheetDate,
    TransDocNo,
    CrateDays,
    CreatedBy,
    CreatedOn,
    /* Associations */
    _item : redirected to composition child ZC_TRCUCKSHEET_ITEM_PRINT
}
