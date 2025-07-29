@AbapCatalog.viewEnhancementCategory: [#NONE]
@EndUserText.label: 'Conusmption view for ZI_MM_VEHICLE'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_MM_VEHICLE
  provider contract transactional_query
  as projection on ZI_MM_VEHICLE
{
      @EndUserText.label: 'ID'
  key Vid,

      @EndUserText.label: 'Vehicle No'
      @Search.defaultSearchElement: true
      VehicleNo,

      @EndUserText.label: 'Effective Date'
      @Search.defaultSearchElement: true
      Effdate,

      @EndUserText.label: 'Vendor No.'
      @Search.defaultSearchElement: true
      //@Consumption.filter:{ mandatory:true }
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier', element: 'Supplier' } }]
      Vendor,

      @EndUserText.label: 'Vendor Name'
      VendorName,


      @EndUserText.label: 'Vehicle Type'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: {name: 'ZI_READ_VEHITYPE_DOMAIN' , element: 'value_low' },
                                           distinctValues: true }]

      VehicleType,

      @EndUserText.label: 'Capacity'
      @Semantics.quantity.unitOfMeasure : 'CapacityUnit'
      Capacity,

      @EndUserText.label: 'Unit'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' } }]
      //    @Search.defaultSearchElement: true
      CapacityUnit,

      @EndUserText.label: 'Currency'
      //     @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]
      Currency,

      @EndUserText.label: 'Rate(Rs/Km)'
      @Semantics.amount.currencyCode: 'Currency'
      Rate,

      @EndUserText.label: 'Drive Name'
      Driver,

      @EndUserText.label: 'Driver Phone'
      DriverPhone,

      @EndUserText.label: 'Vendor'
      @Semantics.user.createdBy: true
      CreatedBy,

      @EndUserText.label: 'Vendor'
      @Semantics.systemDateTime.createdAt: true
      CreatedOn

}
