@AccessControl.authorizationCheck: #CHECK
@EndUserText.label: '##GENERATED ZRAP_GENERATOR'
define root view entity ZR_RAP_GENERATOR
  as select from zrap_generator as RAP_GENERATOR
{
@UI.selectionField : [ { position: 10 } ]
  key uuid_key as UuidKey,
   @UI.selectionField : [ { position: 20 } ]
  description as Description,
  @Semantics.amount.currencyCode: 'Currency'
  price as Price,
  currency as Currency,
  @Semantics.systemDateTime.localInstanceLastChangedAt: true
  local_last_changed as LocalLastChanged,
  @Semantics.systemDateTime.lastChangedAt: true
  last_changed as LastChanged
}
