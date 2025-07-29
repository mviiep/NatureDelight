@EndUserText.label: 'DSAG Billing Order'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_TRUCK_SHEET_DELETE'
define custom entity ZCE_TRUCK_SHEET_DELETE
{
//@UI.selectionField  : [{position: 10 }]
key trucksheet_no : abap.char(10) ;
}
