@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Milk Type : Read domain values'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
//@ObjectModel.resultSet.sizeCategory:#XS    
define view entity ZCDS_MILK_TYPE
       as select from DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZDO_MILKTYPE')
{
//    key domain_name,
    key value_position,
//    @Semantics.language: true
//    key language,
    value_low,
    @Semantics.text: true
    text
}
