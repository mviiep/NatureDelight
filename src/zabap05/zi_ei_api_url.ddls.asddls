@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for API URL'

define root view entity ZI_EI_API_URL
  as select from zei_api_url
{
  key id         as Id,
  key bukrs      as Bukrs,
  key type       as Type,
  key method     as Method,
  key parameter3 as Parameter3,
      url        as Url,
      parameter1 as Parameter1,
      parameter2 as Parameter2,
      parameter4 as Parameter4,
      parameter5 as Parameter5
}
