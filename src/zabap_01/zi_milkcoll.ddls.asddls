@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For ZMM_MILKCOLL'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED }
@ObjectModel: {    
    supportedCapabilities: [#ANALYTICAL_DIMENSION, #CDS_MODELING_ASSOCIATION_TARGET, #SQL_DATA_SOURCE, #CDS_MODELING_DATA_SOURCE]    
}    

define view entity ZI_MILKCOLL as select from zmm_milkcoll
{
    key id as Id,
    plant as Plant,
    sloc as Sloc,
    counter as Counter,
    coll_date as CollDate,
    coll_time as CollTime,
    shift as Shift,
    matnr as Matnr,
    lifnr as Lifnr,
    fatuom as Fatuom,
    @Semantics.quantity.unitOfMeasure : 'fatuom'  
    fat as Fat,
    @Semantics.quantity.unitOfMeasure : 'fatuom'  
    snf as Snf,
    @Semantics.quantity.unitOfMeasure : 'fatuom'      
    protain as Protain,
    milkuom as Milkuom,
  @Semantics.quantity.unitOfMeasure : 'milkuom'      
    milk_qty as MilkQty,
    currency as Currency,
    @Semantics.amount.currencyCode: 'Currency'    
    rate as Rate,
    ebeln as Ebeln,
    mblnr as Mblnr,
    mjahr as Mjahr,
    name1 as Name1,
    created_by as CreatedBy,
    created_on as CreatedOn
}
