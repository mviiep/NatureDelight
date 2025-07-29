@EndUserText.label: 'Vendor debit item'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_VENDOR_DEBIT_FORM'
    }
}
define custom entity ZCE_VENDOR_DEBIT_FORM_ITEM

{
  key accountingdocument : zde_belnr;
  key fiscalyear         : abap.char(4);
  key Item               : abap.char(6);
      description        : abap.char(40);
      @Semantics.quantity.unitOfMeasure: 'unit'
      Quantity           : menge_d;
      unit               : meins;
      HSN                : abap.char(16);
      @Semantics.amount.currencyCode : 'currency'
      rate               : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      value              : abap.curr(15,2);

      currency           : waers;
      remarks            : abap.char(50);


}
