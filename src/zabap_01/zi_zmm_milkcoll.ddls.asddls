//@AbapCatalog.sqlViewName: 'ZI_MILKCOLL'
//@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For ZMM_MILKCOLL'
define root view entity ZI_ZMM_MILKCOLL 
   as select from zmm_milkcoll
{
    
    key id as Id,
    plant as Plant,
    sloc as Sloc,
    counter as Counter,
    coll_date as CollDate,
    coll_time as CollTime,
    shift as Shift,
    milk_type as Milktype,
    matnr as Matnr,
    lifnr as Lifnr,
    fatuom as Fatuom,
    fat as Fat,
    snf as Snf,
    protain as Protain,
    milkuom as Milkuom,
    milk_qty as MilkQty,
    batch as Batch,
    ebeln as Ebeln,
    mblnr as Mblnr,
    mjahr as Mjahr,
    mirodoc   as Mirodoc,
    miro_year  as Miroyear,  
    name1 as Name1,
    currency as Currency,
    @Semantics.amount.currencyCode: 'Currency'
    rate as Rate,
    @Semantics.amount.currencyCode: 'Currency'
    base_rate as BaseRate,
    @Semantics.amount.currencyCode: 'Currency'
    incentive as Incentive,
    @Semantics.amount.currencyCode: 'Currency'
    commision as Commision,
    @Semantics.amount.currencyCode: 'Currency'
    transport as Transport,   
   
    pdf_attach as PDF,
   @Semantics.user.createdBy: true
   created_by as CreatedBy,
   @Semantics.systemDateTime.createdAt: true
   created_on as CreatedOn
    
}
