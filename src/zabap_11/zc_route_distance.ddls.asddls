@EndUserText.label: 'Route Distance'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_ROUTE_DISTANCE
  provider contract transactional_query
  as projection on ZI_ROUTE_DISTANCE
{
      @EndUserText.label: 'Route'
       @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Route', element: 'Route' } }]
  key Route,
      @EndUserText.label: 'Route Name'
      
      Description,
      @EndUserText.label: 'Disatnce'
      Distance,
      @EndUserText.label: 'Unit'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' } }]
      Unit,
      @EndUserText.label: 'Created On'
      CreatedOn,
      @EndUserText.label: 'Created By'
      CreatedBy
      
      
      
}
