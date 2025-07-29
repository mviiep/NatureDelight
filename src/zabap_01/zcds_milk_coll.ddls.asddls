@AbapCatalog.sqlViewName: 'ZMILKCOLL'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
@EndUserText.label: 'CDS View For Milk Collection Data'

define view ZCDS_MILK_COLL as select from zmm_milkcoll
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
    fat as Fat,
    snf as Snf,
    protain as Protain,
    milkuom as Milkuom,
    milk_qty as MilkQty,
    currency as Currency,
    rate as Rate,
    ebeln as Ebeln,
    mblnr as Mblnr,
    mjahr as Mjahr,
    name1 as Name1,
    created_by as CreatedBy,
    created_on as CreatedOn
}
