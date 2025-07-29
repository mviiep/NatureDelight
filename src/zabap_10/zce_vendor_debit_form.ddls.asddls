@EndUserText.label: 'Vendor debit form'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_VENDOR_DEBIT_FORM'
    }
}
define custom entity ZCE_VENDOR_DEBIT_FORM

{

  key accountingdocument : zde_belnr;
  key fiscalyear         : abap.char(4);
      ship_to_name       : abap.char(40);
      ship_to_street1    : abap.char(60);
      ship_to_street2    : abap.char(60);
      ship_to_city       : abap.char(40);
      ship_to_state      : abap.char(40);
      ship_to_state_code : abap.char(2);
      ship_to_country    : abap.char(40);
      ship_to_pin        : abap.char(6);
      ship_to_gstin      : abap.char(25);
      bill_to_name       : abap.char(40);
      bill_to_street1    : abap.char(60);
      bill_to_street2    : abap.char(60);
      bill_to_city       : abap.char(40);
      bill_to_state      : abap.char(40);
      bill_to_state_code : abap.char(2);
      bill_to_country    : abap.char(40);
      bill_to_pin        : abap.char(6);
      bill_to_gstin      : abap.char(25);
      debit_note_date    : abap.dats;
      invoice_num        : abap.char(10);
      invoice_date       : abap.dats;
      @Semantics.amount.currencyCode : 'currency'
      net_amount         : abap.curr(15,2);
      currency           : waers;
      @Semantics.amount.currencyCode : 'currency'
      total_tax          : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      cgst               : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      sgst               : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      igst               : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      tcs                : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      total_debit_note   : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      tds_amount         : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      gross_amount       : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      net_value          : abap.curr(15,2);
      amount_in_words    : abap.char(125);
      @Semantics.amount.currencyCode : 'currency'
      additional_amount1 : abap.curr(15,2);
      @Semantics.amount.currencyCode : 'currency'
      additional_amount2 : abap.curr(15,2);
      reamrks            : abap.char(60);
      additional_text1   : abap.char(60);
      additional_text2   : abap.char(60);
      created_by         : abap.char(60);
      @ObjectModel.filter.enabled: false
      _item              : association [0..*] to ZCE_VENDOR_DEBIT_FORM_ITEM on  _item.accountingdocument = $projection.accountingdocument
                                                                            and _item.fiscalyear         = $projection.fiscalyear;

}
