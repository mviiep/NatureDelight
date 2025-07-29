@AbapCatalog.viewEnhancementCategory: [#PROJECTION_LIST] //[#NONE]
//@AccessControl.authorizationCheck: #NOT_REQUIRED
//
//@EndUserText.label: 'Vehicle Number'
//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #A,
//    sizeCategory: #S,
//    dataClass: #CUSTOMIZING
//}
//@ObjectModel.dataCategory: #VALUE_HELP
//@ObjectModel.representativeKey: 'VehicleNo'
//
//@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER , #SEARCHABLE_ENTITY, #CDS_MODELING_DATA_SOURCE
//, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE ]
//@Search.searchable: true

//@AbapCatalog.sqlViewName: 'ZVH_VEHNO'
//@VDM.viewType: #CONSUMPTION
//@AbapCatalog.compiler.compareFilter: true
@ObjectModel.representativeKey: 'VehicleNo'
@ObjectModel.dataCategory: #VALUE_HELP
@ObjectModel.usageType.serviceQuality: #C
@ObjectModel.usageType.sizeCategory : #XXL
@ObjectModel.usageType.dataClass: #MASTER
@ObjectModel.modelingPattern: #NONE
@AccessControl.authorizationCheck: #CHECK
//@EndUserText.label: 'Value help view for BOM application'
@EndUserText.label: 'Material'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations:true
//@ClientHandling.algorithm: #SESSION_VARIABLE
@Consumption.ranked: true
@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER , #SEARCHABLE_ENTITY, #CDS_MODELING_DATA_SOURCE
, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE ]


/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define root view entity ZVH_VEHICLE_NUMBER as select from ztmm_vehicle 
{
     
 @Search.defaultSearchElement: true
      @Search.fuzzinessThreshold: 0.8
      @Search.ranking: #HIGH 
 key vehicle_no as VehicleNo,
  lifnr as Lifnr,
     @Search.defaultSearchElement: true
     @Search.fuzzinessThreshold: 0.8
     @Search.ranking: #LOW  
  name1 as Name1,
  vehi_type as VehiType,
  driver_name as DriverName


}
