@EndUserText.label: 'MIRO Print'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@AbapCatalog.viewEnhancementCategory: [#NONE]
@Metadata.ignorePropagatedAnnotations: true    
//@Search.searchable: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED }   

define root view entity ZC_ZMM_MIRO_PRINT 
  provider contract transactional_query 
  as projection on ZI_ZMM_MIRO_PRINT as MiroPrint
{
  @EndUserText.label: 'Miro Doc'
  @Search.defaultSearchElement: true
  @Consumption.filter:{ mandatory:true }    
//  @Consumption.valueHelpDefinition: [{ entity: { name: 'i_plant', element: 'Plant' } }]          
    key Mirodoc,

  @EndUserText.label: 'Miro Year'
  @Search.defaultSearchElement: true
  @Consumption.filter:{ mandatory:true }    
    key Miroyear,
    
  @EndUserText.label: 'Supplier'    
    Lifnr,
    
  @EndUserText.label: 'Supplier Name'    
    Name1,
    
  @EndUserText.label: 'Plant'    
    Plant,

  @EndUserText.label: 'St. location'    
    Sloc,
    
  @EndUserText.label: 'PDF'    
    PdfAttach
}
