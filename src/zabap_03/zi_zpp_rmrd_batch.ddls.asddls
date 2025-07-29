@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For RMRD Batch'
define root view entity ZI_ZPP_RMRD_BATCH 
as select from zppt_rmrd_batch
{
    key id as Id,
    matnr as Matnr,
    batch as Batch,
    destination_fat as DestinationFat,
    destination_snf as DestinationSnf,
    destination_protein as DestinationProtein,
    uom as Uom,
    batch_upd as BatchUpd,
   @Semantics.user.createdBy: true
   created_by as CreatedBy,
   @Semantics.systemDateTime.createdAt: true
   created_on as CreatedOn    
}
