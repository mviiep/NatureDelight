@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for ZPPT_RMRD_BATCH'
@Metadata.ignorePropagatedAnnotations: true
//@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED    
    
}
define root view entity ZC_ZPP_RMRD_BATCH
  provider contract transactional_query 
as projection on ZI_ZPP_RMRD_BATCH as RmrdBatch
    
    
{

 @EndUserText.label: 'ID'  
 
 @UI.facet: [{   id : 'ID',
                  purpose: #STANDARD,
                  type: #IDENTIFICATION_REFERENCE,
                  label: 'RMRD',
                  position: 10
              } ]
 
 
      @UI: {
                identification: [{ position: 10, label : 'ID' } ],
                lineItem: [{ position: 10 ,
                              type: #FOR_ACTION,
                              label: 'ID',
                              dataAction: 'RmrdUpdate',
                              invocationGrouping: #CHANGE_SET }] }
 
    key Id,
    
  @EndUserText.label: 'Material'
  @Search.defaultSearchElement: true
//  @Consumption.filter:{ mandatory:true }        
    Matnr,
    
  @EndUserText.label: 'Batch'
  @Search.defaultSearchElement: true    
    Batch,

  @EndUserText.label: 'UoM'  
  Uom,

  @EndUserText.label: 'Dest. Fat%'
  @Semantics.quantity.unitOfMeasure : 'uom'      
    DestinationFat,

  @EndUserText.label: 'Dest. SNF%'
  @Semantics.quantity.unitOfMeasure : 'uom'          
    DestinationSnf,
    

  @EndUserText.label: 'Dest. Protein%'
  @Semantics.quantity.unitOfMeasure : 'uom'          
    DestinationProtein,
    
  @EndUserText.label: 'Batch Update'
  BatchUpd,    
  CreatedBy,
  CreatedOn    
}
