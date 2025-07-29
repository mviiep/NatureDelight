@EndUserText.label: 'Loading Sheet Header'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_LOADING_SHEET'
define custom entity ZCE_LOADING_SHEET_HEADER

{
  key trucksheet_no     : abap.char(10);
      vehicle_no        : abap.char(10);
      driver_name       : abap.char(30);
      driver_telno      : abap.char(10);
      trucksheet_date   : timestamp;
      crate_days        : abap.numc(2);
      created_by        : syuname;
      created_on        : timestamp;
      Creation_date     : abap.dats;
      route_name        : abap.char(40);
      route             : abap.char(10);
      Current_times     : abap.tims;
      current_dates     : abap.dats;
      sum_Quantity      : abap.dec(15,2 );
      sum_free_quantity : abap.dec(15,2 );
      Total_Quantity    : abap.dec(15,2 );
      total_crates      : abap.char(5);
      additional_text1  : abap.char(40);
      additional_text2  : abap.char(40);

      @ObjectModel.filter.enabled: false
      _item             : association [0..*] to ZCE_LOADING_SHEET_ITEM on _item.trucksheet_no = $projection.trucksheet_no;


}
