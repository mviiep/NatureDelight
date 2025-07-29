@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption view Display for truck sheet'
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_TRUCKSHEET_DATA_DISPLAY
provider contract transactional_query
  as projection on ZI_TRUCKSHEET_DATA_DISPLAY as _header
  association[0..*] to ZI_TRUCKSHET_I as _Item on $projection.TrucksheetNo = _Item.TrucksheetNo
{

@EndUserText.label: 'Trucksheet'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TRUCKSHET_I',
                                                     element: 'TrucksheetNo' } }]
                                                     
@UI.facet: [{   id : 'Header',
                  purpose: #STANDARD,
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'Trucksheetno',
                  position: 10 },
                  
                { id : 'Item',
                  purpose: #STANDARD,
                  type: #LINEITEM_REFERENCE,
                  label: 'Item',
                  position: 20,
                  targetElement: '_Item'
                  }]   
                  
@UI.lineItem: [{ position: 10, label: 'TrucksheetNo' }]
@UI.identification: [{ position: 10 }]                                                                                                                   
key _header.TrucksheetNo,
_header.VehicleNo,
_header.DriverName,
_header.DriverTelno,
//TrucksheetDate,
_header.TransDocNo,
PDF,
//CreatedBy,
//CreatedOn
_Item
}
