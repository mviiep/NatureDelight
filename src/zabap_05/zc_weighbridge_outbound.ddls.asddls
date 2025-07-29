@EndUserText.label: 'Wieghbridge Outbound'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_WEIGHBRIDGE_OUTBOUND
  provider contract transactional_query
  as projection on ZI_WEIGHBRIDGE_OUTBOUND

{
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Truck Sheet No'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TRUCKSHET_I', element: 'TrucksheetNo' } } ]
  key TrucksheetNo,
      @EndUserText.label: 'Vehicle No'
      VehicleNo,
      @EndUserText.label: 'Total  Trucksheet Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalTrucksheetWeight,
      @EndUserText.label: 'Tare Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TareWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      @EndUserText.label: 'Weighbridge Weight'
      WeighbridgeWeight,
      @EndUserText.label: 'Diffence in Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      DifferenceWeight,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created On'
      CreatedOn
}
