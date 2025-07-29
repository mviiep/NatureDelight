@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Milk collection form'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_ZMM_MILK_COLL_FORM_1
  as select from ZI_ZMM_MILKCOLL  as a
 association [1..*] to I_MaterialDocumentItem_2  as b on b.ReversedMaterialDocument = a.Mblnr
 and b.ReversedMaterialDocumentYear = a.Mjahr  
 
{
 key a.Id,
 a.Plant,
 a.Sloc,
 a.Counter,
 a.CollDate,
 a.CollTime,
 a.Shift,
 a.Milktype,
 a.Matnr,
 a.Lifnr,
 a.Fatuom,
 @Semantics.quantity.unitOfMeasure: 'Fatuom'
 a.Fat,
 @Semantics.quantity.unitOfMeasure: 'Fatuom'
 a.Snf,
 @Semantics.quantity.unitOfMeasure: 'Fatuom'
 a.Protain,

 a.Milkuom,
 @Semantics.quantity.unitOfMeasure: 'Milkuom'
 a.MilkQty,
 a.Ebeln,
 a.Mblnr,
 a.Mjahr,
 a.Mirodoc,
 a.Miroyear,
 a.Name1,
 a.Currency,
  @Semantics.amount.currencyCode: 'Currency'
 a.Rate,
  @Semantics.amount.currencyCode: 'Currency'
 a.BaseRate,
  @Semantics.amount.currencyCode: 'Currency'
 a.Incentive,
  @Semantics.amount.currencyCode: 'Currency'
 a.Commision,
  @Semantics.amount.currencyCode: 'Currency'
 a.Transport,
 
 
  cast( ( cast( a.Rate as abap.fltp ) *  cast( a.MilkQty as abap.fltp )) as abap.int4 ) as total_amount,

a.CreatedBy,
 a.CreatedOn,
 b.MaterialDocument  

};



