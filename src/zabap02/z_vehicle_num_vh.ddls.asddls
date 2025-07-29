@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vehicle Number'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@Search.searchable: true
@ObjectModel.supportedCapabilities: [ #VALUE_HELP_PROVIDER , #SEARCHABLE_ENTITY, #CDS_MODELING_DATA_SOURCE
, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE]
//@ObjectModel.representativeKey: 'VehicleNo'

/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view entity Z_VEHICLE_NUM_VH as select from 
 ztmm_vehicle 
{
     
 @Search.defaultSearchElement: true
 key vehicle_no as VehicleNo,
  lifnr as Lifnr,
  name1 as Name1,
  vehi_type as VehiType,
  driver_name as DriverName


}
