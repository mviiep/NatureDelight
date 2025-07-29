@EndUserText.label: 'Loading Sheet Item'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_LOADING_SHEET'
define custom entity ZCE_LOADING_SHEET_ITEM

{
  key trucksheet_no : abap.char(10) ;
  key  material_no   : matnr;
  material_descr     : abap.char(40);
   quantity         : abap.dec(15,2 );
   free             : abap.dec(15,2 );
   total            : abap.dec(15,2 );
   crates           : abap.char(5);
   cans             : abap.char(5);
   remarks          : abap.char(40);
  
}
