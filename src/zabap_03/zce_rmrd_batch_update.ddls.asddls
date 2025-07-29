@EndUserText.label: 'Batch Update'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_QM_RMRD_BATCH_UPD'
    }
}
define custom entity ZCE_RMRD_BATCH_UPDATE
  with parameters
    p_batch   : charg_d,
    p_fat     : zd_milk_qty_value,
    p_snf     : zd_milk_qty_value,
    p_protein : zd_milk_qty_value
{
  key batch               : charg_d;
      destination_fat     : zd_milk_qty_value;
      destination_snf     : zd_milk_qty_value;
      destination_protein : zd_milk_qty_value;

}
