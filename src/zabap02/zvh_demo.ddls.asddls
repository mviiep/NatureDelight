@EndUserText.label: 'Vehicle Number'
@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_VEHICLE_NO'
    }
}
define custom entity ZVH_DEMO 

{
 key vehicle_no : abap.char( 10 );
  
}
