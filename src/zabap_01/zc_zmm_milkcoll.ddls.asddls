@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for ZMM_MILKCOLL'
@Metadata.ignorePropagatedAnnotations: true    
//@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED    
    
}
define root view entity ZC_ZMM_MILKCOLL
  provider contract transactional_query 
as projection on ZI_ZMM_MILKCOLL as MilkColl

{
  @EndUserText.label: 'ID'  
  key Id,
  
  @EndUserText.label: 'Plant'
  @Search.defaultSearchElement: true
  @Consumption.filter:{ mandatory:true }    
  @Consumption.valueHelpDefinition: [{ entity: { name: 'i_plant', element: 'Plant' } }]          
  Plant,
  
  @EndUserText.label: 'Storage Location'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_StorageLocation', element: 'StorageLocation' } }]                 
  Sloc,
  
  @EndUserText.label: 'Count'  
  Counter,
  
  @EndUserText.label: 'Collection Date'
  @Search.defaultSearchElement: true
  @Consumption.filter.selectionType: #INTERVAL  
  CollDate,
  
  @EndUserText.label: 'Collection Time'  
  CollTime,
  
  @EndUserText.label: 'Shift'  
  Shift,
  
  @EndUserText.label: 'Milk Type'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZCDS_MILK_TYPE' , element: 'value_low' },distinctValues: true }]  
  Milktype,
  
  @EndUserText.label: 'Material'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' } }]                            
//  @Consumption.valueHelpDefinition: [{ entity: {name: 'ZCDS_MILK_TYPE' , element: 'value_low' },distinctValues: true }]
  Matnr,
  
  @EndUserText.label: 'Supplier'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier', element: 'Supplier' } }]                                
  Lifnr,
  
  @EndUserText.label: 'Parameter UoM'  
  Fatuom,

  @EndUserText.label: 'Fat %'
  @Semantics.quantity.unitOfMeasure : 'fatuom'  
  Fat,
  
  @EndUserText.label: 'Snf %'
  @Semantics.quantity.unitOfMeasure : 'fatuom'  
  Snf,
  
  @EndUserText.label: 'Protein %'
  @Semantics.quantity.unitOfMeasure : 'fatuom'  
  Protain,
  
  @EndUserText.label: 'Milk UoM'
//  @Consumption.defaultValue: 'L'
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_UnitOfMeasureStdVH', element: 'UnitOfMeasure' } }]
  Milkuom,

  @EndUserText.label: 'Milk Qty'
  @Semantics.quantity.unitOfMeasure : 'milkuom'
  MilkQty,

  @EndUserText.label: 'Batch'
  Batch,
  
    @EndUserText.label: 'Currency'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }]   
    Currency,
    @EndUserText.label: 'Rate'
    @Semantics.amount.currencyCode : 'currency'    
    Rate,  
  
    @EndUserText.label: 'Basic Rate'
    @Semantics.amount.currencyCode : 'currency'    
    BaseRate,
    @EndUserText.label: 'Rate Difference A'
    @Semantics.amount.currencyCode : 'currency'    
    Incentive,
    @EndUserText.label: 'Rate Difference B'
    @Semantics.amount.currencyCode : 'currency'    
    Commision,
    @EndUserText.label: 'Rate Difference C'
    @Semantics.amount.currencyCode : 'currency'    
    Transport,  
  
  
  @EndUserText.label: 'PO Number'
  Ebeln,  
  
  @EndUserText.label: 'GRN Number'
  Mblnr,  
  
  @EndUserText.label: 'GRN Year'
  Mjahr,  
  
  @EndUserText.label: 'MIRO Doc'
  Mirodoc,
  @EndUserText.label: 'MIRO Year'
  Miroyear,  
  
  @EndUserText.label: 'Supplier Name'
//  @Consumption.defaultValue: 'TEST'
  Name1,  
 
  @EndUserText.label: 'Created By'  
  CreatedBy,
  CreatedOn
      
}
