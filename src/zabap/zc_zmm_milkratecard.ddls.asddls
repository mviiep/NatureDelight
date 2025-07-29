@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for ZMM_MILKRATECARD'
@Metadata.ignorePropagatedAnnotations: true
//@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{ 
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED    
}
define root view entity ZC_ZMM_MILKRATECARD
  provider contract transactional_query 
as projection on ZI_ZMM_MILKRATECARD as RateCard

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
    
    @EndUserText.label: 'St.Location Name'    
    Lgobe,     
    
    @EndUserText.label: 'Supplier'
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Supplier', element: 'Supplier' } }]                              
    Vendor,
    
    @EndUserText.label: 'Supplier Name'    
    Name1,    
    
    @EndUserText.label: 'Effective Date'
    @Search.defaultSearchElement: true
    @Consumption.filter.selectionType: #INTERVAL
    Effdate,

    @EndUserText.label: 'Milk Type'
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: {name: 'ZCDS_MILK_TYPE' , element: 'value_low' },distinctValues: true }]    
    Milktype,
    
    @EndUserText.label: 'Material'
    @Search.defaultSearchElement: true
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH', element: 'Product' } }]                          
//    @Consumption.valueHelpDefinition: [{ entity: {name: 'ZCDS_MILK_TYPE' , element: 'value_low' },distinctValues: true }]
    Matnr,
    @EndUserText.label: 'UoM'
    Fatuom,    
    @EndUserText.label: 'Fat %'
    @Semantics.quantity.unitOfMeasure : 'fatuom'
    Fat,
    @EndUserText.label: 'SNF %'
    @Semantics.quantity.unitOfMeasure : 'fatuom'   
    Snf,
    @EndUserText.label: 'Protein %'
    @Semantics.quantity.unitOfMeasure : 'fatuom'    
    Protain,    
    @EndUserText.label: 'Parameter 1'
    @Semantics.quantity.unitOfMeasure : 'fatuom'    
    Param1,
    @EndUserText.label: 'Parameter 2'
    @Semantics.quantity.unitOfMeasure : 'fatuom'    
    Param2,
    @EndUserText.label: 'Parameter 3'
    Param3,
    @EndUserText.label: 'Parameter 4'
    Param4,
    @EndUserText.label: 'Parameter 5'
    Param5,
    @EndUserText.label: 'Currency'
    @Consumption.valueHelpDefinition: [{ entity: { name: 'I_CurrencyStdVH', element: 'Currency' } }] 
//    @Consumption.defaultValue: 'INR'   
//   @Consumption.derivation.binding: [{value: 'INR'}]    
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
    
//    Attachment,
//    MimeType,
//    Filename,
    
    @EndUserText.label: 'Created By'
    CreatedBy,
    CreatedOn,
    ChangedBy,
    ChangedOn
}
