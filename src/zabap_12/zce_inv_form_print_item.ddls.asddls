@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_INV_FORM_PRINT'
    }
}
 
@UI.headerInfo: { typeName: 'Invoice Form Print Item' ,
                  typeNamePlural: 'Invoice Form Item' }

@EndUserText.label: 'Invoice Form Print Item'
define custom entity ZCE_INV_FORM_PRINT_ITEM

{
  key BILLINGDOCUMENT : abap.char(10);
  key ITEM                : abap.char(6);
  MATNR               : matnr;
  MAKTX               : abap.char(40);
  HSN                 : abap.char(40);

  UOM                 : meins;
  @Semantics.quantity.unitOfMeasure: 'UOM'
  QUANTITY            : menge_d;  

  RATE_C               : abap.char(25);

  currency             : waers;
  @Semantics.amount.currencyCode: 'currency'
  RATE                 : abap.curr( 15, 2 );
  @Semantics.amount.currencyCode: 'currency'
  AMOUNT               : abap.curr( 15, 2 );  
  @Semantics.amount.currencyCode: 'currency'
  GST_PER              : abap.curr( 15, 2 );
  @Semantics.amount.currencyCode: 'currency'
  GST_AMT              : abap.curr( 15, 2 );  

  
  ADD_CHAR1            : abap.char(40);
  ADD_CHAR2            : abap.char(40);
  ADD_CHAR3            : abap.char(40);
  ADD_CHAR4            : abap.char(40);
  
      
  @Semantics.amount.currencyCode: 'currency'
  ADDAmount1           : abap.curr( 15, 2 ); 
  @Semantics.amount.currencyCode: 'currency'
  ADDAmount2           : abap.curr( 15, 2 ); 
  @Semantics.amount.currencyCode: 'currency'
  ADDAmount3           : abap.curr( 15, 2 ); 
   @Semantics.amount.currencyCode: 'currency'
  ADDAmount4           : abap.curr( 15, 2 );           
}
