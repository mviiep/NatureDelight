@EndUserText.label: 'Milk collection form'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MILK_COLLECTION_FORM'
    }
}
define custom entity ZCE_MILK_COLL_FORM_ITEM

{
  key id           : sysuuid_x16;
      Mirodoc      : re_belnr;
      Miroyear     : gjahr;
      CollDate     : datum;
      Shift        : abap.char(1);
      Plant        : werks_d;
      Sloc         : abap.char(4);
      Counter      : abap.numc(2);
      CollTime     : timn;
      Milktype     : abap.char(1);
      Matnr        : matnr;
      Lifnr        : lifnr;
      Fatuom       : meins;
      @Semantics.quantity.unitOfMeasure : 'Fatuom'
      Fat          : menge_d;
      @Semantics.quantity.unitOfMeasure : 'Fatuom'
      Snf          : menge_d;
      @Semantics.quantity.unitOfMeasure : 'Fatuom'
      Protain      : menge_d;
      Milkuom      : meins;
      @Semantics.quantity.unitOfMeasure : 'Fatuom'
      MilkQty      : menge_d;
      Batch        : charg_d;
      Name1        : abap.char(255);
      Currency     : waers;
      @Semantics.amount.currencyCode : 'Currency'
      Rate         : abap.curr(10,2);
      @Semantics.amount.currencyCode : 'Currency'
      BaseRate     : abap.curr(10,2);
      @Semantics.amount.currencyCode : 'Currency'
      Incentive    : abap.curr(10,2);
      @Semantics.amount.currencyCode : 'Currency'
      Commision    : abap.curr(10,2);
      @Semantics.amount.currencyCode : 'Currency'
      Transport    : abap.curr(10,2);
      @Semantics.amount.currencyCode : 'Currency'
      total_amount : abap.curr(10,2);
         @Semantics.amount.currencyCode : 'Currency'
         rate_difference : abap.curr(10,2);
  
      CreatedBy    : syuname;

      CreatedOn    : timestamp;
      
   
     
   

}
