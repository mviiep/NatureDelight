@AbapCatalog.sqlViewName: 'ZTESTCDSVHD'
@AbapCatalog.compiler.compareFilter: true
@ObjectModel.representativeKey: 'Vid'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory : #XXL
@ObjectModel.usageType.dataClass: #MASTER
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vevicle Master'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations:true
@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER , #SEARCHABLE_ENTITY, #CDS_MODELING_DATA_SOURCE
, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE]
@ClientHandling.algorithm: #SESSION_VARIABLE
@Consumption.ranked: true
@AbapCatalog.dataMaintenance: #DISPLAY_ONLY
define view ZTESTCDSVH
  as select from ztmm_vehicle
{

      @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH
  key vid as Vid

}
