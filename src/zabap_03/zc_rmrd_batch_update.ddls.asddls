@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for RMRD Batch upadte'
@Search.searchable: true
@Metadata.allowExtensions: true


define root view entity ZC_RMRD_BATCH_UPDATE
  provider contract transactional_query
  as projection on ZI_RMRD_BATCH_UPDATE

{     
      @EndUserText.label: 'Material No'
      @Search.defaultSearchElement: true
  key Matnr,
      @EndUserText.label: 'Batch'
      @Search.defaultSearchElement: true
  key Batch,
      @EndUserText.label: 'Destination Fat%'
      DestinationFat,
      @EndUserText.label: 'Destination SNF%'
      DestinationSnf,
      @EndUserText.label: 'Destination Protein%'
      DestinationProtein,
      Uom

}
