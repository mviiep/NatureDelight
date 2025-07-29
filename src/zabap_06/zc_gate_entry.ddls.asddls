@EndUserText.label: 'Gate Entry'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
//@ObjectModel.resultSet.sizeCategory:  #XS
define root view entity ZC_GATE_ENTRY
  provider contract transactional_query
  as projection on ZI_GATE_ENTRY

{     @Search.defaultSearchElement: true
      @EndUserText.label: 'Gate Entry No'
  key GateEntryNo,
      @EndUserText.label: 'Gate Entry Type'
      @Search.defaultSearchElement: true
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZVH_GATE_ENTRY_TYPE', element: 'value_low' } } ]
      EntryType,
     
      @EndUserText.label: 'Vehicle No'
      @Search.defaultSearchElement: true
      VehicleNo,
      @EndUserText.label: 'Driver Name'
      DriverName,
      @EndUserText.label: 'Driver Mobile No'
      DriverMobile,
      @EndUserText.label: 'Commodity'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZVH_COMODITY_TYPE', element: 'value_low' } } ]
      Comodity,
      @EndUserText.label: 'Material No'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZVH_GATE_ENTRY_MATERIAL', element: 'MaterialNo' } } ]
      Material,
  
      @EndUserText.label: 'Inbound Type'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZVH_INBOUND_TYPE', element: 'value_low' } } ]
      InboundType,
      @EndUserText.label: 'STO No'
      @Search.defaultSearchElement: true
      StoNo,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Purpose'
      Purpose,
      @EndUserText.label: 'Vehicle In Date'
      InDate,
      @EndUserText.label: 'Vehicle In Time'
      InTime,
      @EndUserText.label: 'Vehicle Out Date'
      OutDate,
      @EndUserText.label: 'Vehicle Out Time'
      OutTime,
      @EndUserText.label: 'Vehicle Out Confirmation'
      VehicleOut,
      
       @EndUserText.label: 'Attachments'
    @Semantics.largeObject:{
        mimeType: 'Mimetype',
        fileName: 'Filename',
        contentDispositionPreference: #ATTACHMENT
    }
      Pdfattach,
      @Semantics.mimeType: true 
       @EndUserText.label: 'File Type'
      Mimetype,
      @EndUserText.label: 'File Name'
      Filename
      
      
}
