@EndUserText.label: 'Projection View for RMRD Batch Update API'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define  root view entity ZP_API_RMRD_BATCH_UPDATE 
provider contract transactional_query
as projection on I_BatchTP_2
{
key Material,
key BatchIdentifyingPlant,
key Batch,
BatchIsMarkedForDeletion,
MatlBatchIsInRstrcdUseStock,
Supplier,
BatchBySupplier,
CountryOfOrigin,
RegionOfOrigin,
MatlBatchAvailabilityDate,
ShelfLifeExpirationDate,
ManufactureDate,
FreeDefinedDate1,
FreeDefinedDate2,
FreeDefinedDate3,
FreeDefinedDate4,
FreeDefinedDate5,
FreeDefinedDate6,
CreationDateTime,
LastChangeDateTime,
BatchExtWhseMgmtInternalId
/* Associations */
//_BatchCharacteristicTP,
//_BatchClassTP,
//_BatchPlantTP,
//_BatchTextTP,
//_Product
}
