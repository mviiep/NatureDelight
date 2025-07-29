@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Route Distance'
define root view entity ZI_ROUTE_DISTANCE
  as select from ztroute_distance

{
  key route       as Route,
      description as Description,
      distance    as Distance,
      unit        as Unit,
      created_on  as CreatedOn,
      created_by  as CreatedBy
      
}
