@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Comodity type'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
@ObjectModel.resultSet.sizeCategory:  #XS
define view entity ZVH_COMODITY_TYPE as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T
( p_domain_name: 'ZD_COMMODITY_TYPE'  )
{
//   key domain_name,
  key value_position,
//   key language,
   value_low,

    text  
}
