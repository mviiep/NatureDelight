@EndUserText.label: 'Milk collection form'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MILK_COLLECTION_FORM'
    }
}

@UI.headerInfo: { typeName: 'Milk Collection' ,
                  typeNamePlural: 'Milk Collection' }
define custom entity ZCE_MILK_COLLECTION_FORM

{
      @UI.facet           : [{ id : 'mirodoc',
                   purpose: #STANDARD,
                   type   : #IDENTIFICATION_REFERENCE,
                   label  : 'Milk Collection',
                   position: 10 }]


  key mirodoc             : re_belnr;
  key miro_year           : gjahr;

      from_date           : abap.dats;
      to_date             : abap.dats;
      lifnr               : lifnr;
      supplier_name       : abap.char( 50 );
      account_no          : abap.char( 18 );
      IFSC                : abap.char( 15 );
      PAN                 : abap.char( 12 );
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      TOTAL_QTY           : menge_d;
      @UI.identification  : [{ position: 80 }]
      milkuom             : meins;
      @Semantics.amount.currencyCode: 'currency'
      Milk_amount         : abap.curr( 10, 2 );
      currency            : waers;
      @Semantics.amount.currencyCode: 'currency'
      RATE_DIFF_A         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      RATE_DIFF_B         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      RATE_DIFF_C         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      TOTAL_GROSS         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      Milk_amount1        : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      TOTAL_ADDITIONS     : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      SUB_TOTAL           : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      TOTAL_DEDUCTIONS    : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      NET_AMOUNT          : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_advance         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_c_feed          : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_c_feed1         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_c_feed2         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_protine         : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_can             : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_petrol          : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_deposite        : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_janata          : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_patasanth       : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_store           : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_other           : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_bank_comm       : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      ded_SMP             : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      TDS                 : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      Rate_difference_add : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      transport_add       : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      Rate_difference_ded : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      transport_ded       : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      other               : abap.curr( 10, 2 );
      MILK_TYPE           : abap.char( 2 );
      LGORT               : abap.char(4);
      lgort_name          : abap.char(40);
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      cm_qty              : menge_d;
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      bm_qty              : menge_d;
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      cm_fat              : menge_d;
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      cm_snf              : menge_d;
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      bm_fat              : menge_d;
      @Semantics.quantity.unitOfMeasure: 'milkuom'
      bm_snf              : menge_d;
      @Semantics.amount.currencyCode: 'currency'
      cm_total            : abap.curr( 10, 2 );
      @Semantics.amount.currencyCode: 'currency'
      bm_total            : abap.curr( 10, 2 );


      @ObjectModel.filter.enabled: false
      //      _item            : association [0..*] to ZI_ZMM_MILKCOLL_FORM on  _item.Mirodoc  = $projection.mirodoc
      //                                                               and _item.Miroyear = $projection.miro_year;
      _item               : association [0..*] to ZCE_MILK_COLL_FORM_ITEM on  _item.Mirodoc  = $projection.mirodoc
                                                                          and _item.Miroyear = $projection.miro_year;
      //                                                               and _item.MaterialDocument  =  '';
}
