@EndUserText.label: 'DSAG Billing Order'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_TRUCK_SHEET'
define custom entity ZCE_TRUCK_SHEET_PRINT
{
//@UI.selectionField  : [{position: 10 }]
key trucksheet_no : abap.char(10) ;
  vehicle_no        : abap.char(10) ;
  driver_name       : abap.char(30);
  driver_telno      : abap.char(10);
  trucksheet_date   : timestamp;
  trans_doc_no      : abap.char(10);
  crate_days        : abap.numc(2);
  created_by        : syuname;
  created_on        : timestamp;
  Creation_date     :  abap.dats;
  route             : abap.char(40);
  Current_times      : abap.tims;
  current_dates       : abap.dats;
  TOTAL_CRATE        : abap.numc(5);
  TOTAL_AMOUNT       : abap.dec(15,2 );

 @ObjectModel.filter.enabled: false
  _item: association[0..*] to  ZI_TRUCKSHEET_ITEM_PRINT
  on _item.TrucksheetNo = $projection.trucksheet_no;
}
