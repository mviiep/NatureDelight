@EndUserText.label: 'Custom Entity Weight'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MM_WB_CLASS'
    } 
}
define custom entity ZCE_WEIGHT
 //with parameters parameter_name : parameter_type
{
  key weight : abap.string( 256 ); 
}
