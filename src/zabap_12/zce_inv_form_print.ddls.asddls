@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_INV_FORM_PRINT'
    }
}
 
@UI.headerInfo: { typeName: 'Invoice Form Print' ,
                  typeNamePlural: 'Invoice Form Print' }

@EndUserText.label: 'Invoice Form Print'
define custom entity ZCE_INV_FORM_PRINT

{

 @UI.facet   : [{ id : 'BILLINGDOCUMENT',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Invoice Form',
                position: 10 }]

  key BILLINGDOCUMENT : abap.char(10);
  BILLINGDOCUMENTDATE : datum;
  PO_NO               : abap.char(35);
  PO_DATE             : datum;
  LR_NO               : abap.char(20); 
  LR_DATE             : datum;
  VEHICLE_NO          : abap.char(10);
  TRANSPORTER         : abap.char(60);
  
  REFDOC              : abap.char(20);
  REFDOCDATE          : datum;

  IRN                 : abap.char(100);
  ackno               : abap.char(20);
  ackdate             : abap.char(21);
  signedqrcode        : abap.string(0);
  ebillno             : abap.numc(12);
  vdfmdate            : datum;
  vdtodate            : datum;  
  
  billto_party         : abap.char(10);
  billto_name          : abap.char(40);
  billto_addr1         : abap.string(0);
  billto_addr2         : abap.string(0);
  billto_addr3         : abap.string(0);
  billto_addr4         : abap.string(0);
  billto_addr5         : abap.string(0);
  billto_addr6         : abap.string(0);
  billto_GSTIN         : abap.char(20);
  billto_mob           :abap.char(20);
  billto_state         : abap.char(80);
  

  shipto_party         : abap.char(10);
  shipto_name          : abap.char(40);
  shipto_addr1         : abap.string(0);
  shipto_addr2         : abap.string(0);
  shipto_addr3         : abap.string(0);
  shipto_addr4         : abap.string(0);
  shipto_addr5         : abap.string(0);
  shipto_addr6         : abap.string(0);
  shipto_mob           :abap.char(20);   
  shipto_GSTIN         : abap.char(20);
  shipto_state         : abap.char(80);  
  
  currency             : waers;
  @Semantics.amount.currencyCode: 'currency'
  BaseAmount           : abap.curr( 15, 2 );
  @Semantics.amount.currencyCode: 'currency'
  DiscAmount           : abap.curr( 15, 2 );  
  @Semantics.amount.currencyCode: 'currency'
  IGSTAmount           : abap.curr( 15, 2 );  
  @Semantics.amount.currencyCode: 'currency'
  CGSTAmount           : abap.curr( 15, 2 );    
  @Semantics.amount.currencyCode: 'currency'
  SGSTAmount           : abap.curr( 15, 2 );      
  @Semantics.amount.currencyCode: 'currency'
  FreightAmount        : abap.curr( 15, 2 );           
  @Semantics.amount.currencyCode: 'currency'
  TCSper               : abap.curr( 15, 2 );         
  @Semantics.amount.currencyCode: 'currency'
  TCSAmount            : abap.curr( 15, 2 );      
  @Semantics.amount.currencyCode: 'currency'
  TOT_TAX              : abap.curr( 15, 2 );      
  @Semantics.amount.currencyCode: 'currency'
  NetAmount            : abap.curr( 15, 2 );    
  
  Amountinwords        : abap.string(0);
  B2B_B2C              : abap.char(1);  
  
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
  
  @ObjectModel.filter.enabled: false       
 _Item : association[0..*] to ZCE_INV_FORM_PRINT_ITEM
 on _Item.BILLINGDOCUMENT  =  $projection.BILLINGDOCUMENT;
 
}
