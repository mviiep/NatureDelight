@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for truck sheet Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}

define root view entity ZI_TRUCKSHET_I
  as select from zsdt_truckshet_i
  //composition of target_data_source_name as _association_name
{
      @UI.lineItem: [{ position: 10, label: 'TrucksheetNo'}]

  key trucksheet_no   as TrucksheetNo,


      @UI.lineItem: [{ position: 20 , label: 'Item' }]
  key trucksheet_item as TrucksheetItem,

      @UI.lineItem: [{ position: 30 , label: 'Invoice' }]
      vbeln           as Vbeln,
      @UI.lineItem: [{ position: 40 , label: 'Customer' }]
      kunag           as Kunag,
      @UI.lineItem: [{ position: 50 , label: 'Name' }]
      name1           as Name1,
      @UI.lineItem: [{ position: 60 , label: 'Route' }]
      route           as Route,
      @UI.lineItem: [{ position: 70 , label: 'Mat group' }]
      matkl           as Matkl,

      meins           as Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      @UI.lineItem: [{ position: 100 , label: 'Qty' }]
      qty             as Qty,


      @UI.lineItem: [{ position: 110 , label: 'No of Crates' }]
      noofcrate       as Noofcrate,

      @UI.lineItem: [{ position: 120 , label: 'No of Cann' }]
      noofcan         as Noofcan,


      currency        as Currency,
      @UI.lineItem: [{ position: 130 , label: 'Amount' }]
      @Semantics.amount.currencyCode : 'Currency'
      amount          as Amount
}
