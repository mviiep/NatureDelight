@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Value help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_KEY_HVH 
  as select from zrap_generator
{
  key uuid_key           as id,
      description        as Description,
      @Semantics.amount.currencyCode: 'Currency'
      price              as Price,
      currency           as Currency,
      local_last_changed as LocalLastChanged,
      last_changed       as LastChanged
}
