@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Milk collection form'
define root view entity ZI_ZMM_MILK_COLL_FORM_2 as select from ZI_ZMM_MILK_COLL_FORM_1

{
    key Id,
    Plant,
    Sloc,
    Counter,
    CollDate,
    CollTime,
    Shift,
    Milktype,
    Matnr,
    Lifnr,
    Fatuom,
    Fat,
    Snf,
    Protain,
    Milkuom,
    MilkQty,
    Ebeln,
    Mblnr,
    Mjahr,
    Mirodoc,
    Miroyear,
    Name1,
    Currency,
    Rate,
    BaseRate,
    Incentive,
    Commision,
    Transport,
    total_amount,
    CreatedBy,
    CreatedOn,
    MaterialDocument
    }
    where  MaterialDocument  = '';


