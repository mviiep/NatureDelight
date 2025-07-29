@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory:  #XS
define view entity ZVH_GATE_ENTRY_TYPE as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T
( p_domain_name: 'ZD_GATE_ENTRY_TYPE' )
{
//   key domain_name,
  key value_position,
//   key language,
   value_low,

    text
}
