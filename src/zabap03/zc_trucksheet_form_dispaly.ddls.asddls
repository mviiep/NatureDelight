@EndUserText.label: 'Truck sheet print'
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED   }
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Search.searchable: true
define root view entity ZC_TRUCKSHEET_FORM_DISPALY
  provider contract transactional_query
  as projection on ZI_TRUCKSHEET_FORM_DISPLAY
{
      @EndUserText.label: 'Truck Sheet No'
      @Search.defaultSearchElement: true
  key TrucksheetNo,
      @EndUserText.label: 'Vehicel No'
      VehicleNo,
      @EndUserText.label: 'Driver Name'
      DriverName,
      @EndUserText.label: 'Driver Mobile No'
      DriverTelno,
      @EndUserText.label: 'Tran Doc No'

      TransDocNo,
      @EndUserText.label: 'Created days'
      CrateDays,
      @EndUserText.label: 'PDF'
//      @Semantics.largeObject:{
//         mimeType: 'Mimetype',
//         fileName: 'Filename',
//         contentDispositionPreference: #ATTACHMENT
//     }
      PdfData,
//      @Semantics.mimeType: true
//      Mimetype,
//      Filename,
//      @EndUserText.label: 'Created By'
@EndUserText.label: 'Truck Sheet Date'
CreationDate,
      CreatedBy,
      @EndUserText.label: 'Route'
      route,
    @EndUserText.label: 'Route Name'
      routename
      
      //    @EndUserText.label: 'Created On'
      //    CreatedOn
}
