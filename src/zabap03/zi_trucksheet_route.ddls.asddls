@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Truck sheet  Route'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRUCKSHEET_ROUTE as select  distinct from zsdt_truckshet_i
association [0..*] to ztroute_distance as _route 
on $projection.route = _route.route
{
   key  trucksheet_no,
   zsdt_truckshet_i.route as route,
   _route.description
   
 
}
