@AccessControl.authorizationCheck: #CHECK
@Metadata.allowExtensions: true
@EndUserText.label: 'Projection View for ZR_RAP_GENERATOR'
@ObjectModel.semanticKey: [ 'UuidKey' ]
define root view entity ZC_RAP_GENERATOR
  provider contract transactional_query
  as projection on ZR_RAP_GENERATOR
{
  key UuidKey,
  Description,
  Price,
  Currency,
  LocalLastChanged
  
}
