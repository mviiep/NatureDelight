@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for RMRD Batch Update'
define root view entity ZI_RMRD_BATCH_UPDATE as select from ztrmrd_batch

{
  key matnr as Matnr,
  key batch as Batch,
  destination_fat as DestinationFat,
  destination_snf as DestinationSnf,
  destination_protein as DestinationProtein,
  uom as Uom
   
}
