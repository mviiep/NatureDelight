@EndUserText.label: 'Abstract Entity trucksheet'
@Metadata.allowExtensions: true
//@Search.searchable: true
define abstract entity ZAE_TRUCKSHEET
  //with parameters parameter_name : parameter_type
{
  trucksheet_date : datum;
//    cratedays      : abap.numc( 2 );
//  @Search.defaultSearchElement: true
  
   @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_MM_VEHICLE',
                                               element: 'VehicleNo' } }] 
  vehicleno       : abap.char(10);
  driver_name     : abap.char(30);
  driver_telno    : abap.char(10);
  distace         : abap.char(10);
  //  trans_doc_no    : abap.char(10);
  //  route           : abap.char(6);
}
