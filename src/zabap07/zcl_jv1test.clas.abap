CLASS zcl_jv1test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .  "jhh

*
*    DATA: lt_zfit_accdoc TYPE TABLE OF zfit_accdoc,
*          it_doc         TYPE TABLE OF zfit_accdoc.
*
*    DATA: lt_doc_h        TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
*    DATA: lt_je_deep      TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          lv_cid          TYPE abp_behv_cid,
*          ls_doc_h        LIKE LINE OF lt_doc_h,
*          ls_glitem       LIKE LINE OF ls_doc_h-%param-_glitems,
*          ls_glcurrency   LIKE LINE OF ls_glitem-_currencyamount,
*          ls_aritem       LIKE LINE OF ls_doc_h-%param-_aritems, "customer
*          ls_taxitems     LIKE LINE OF ls_doc_h-%param-_taxitems,
*          ls_custcurrency LIKE LINE OF ls_aritem-_currencyamount,
*          ls_apitem       LIKE LINE OF ls_doc_h-%param-_apitems, "vendor
*          ls_vencurrency  LIKE LINE OF ls_apitem-_currencyamount,
*          lv_docid(10)    TYPE c,
*          lv_buzei        TYPE i.
*
*    TYPES : BEGIN OF ty_msg,
*              docid(10) TYPE c,
*              belnr     TYPE belnr_d,
*              msgty(1)  TYPE c,
*              msg(200)  TYPE c,
*            END OF ty_msg.
*    DATA : it_msg    TYPE STANDARD TABLE OF ty_msg,
*           wa_msg    TYPE ty_msg,
*           lv_result TYPE string,
*           lv_msg    TYPE c LENGTH 200.
*    DATA : r_date TYPE RANGE OF datum,
*           s_date LIKE LINE OF r_date.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_JV1TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*    DATA: lt_je_deep    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          lv_cid        TYPE abp_behv_cid,
*          ls_doc_h      LIKE LINE OF lt_je_deep,
*          ls_glitem     LIKE LINE OF ls_doc_h-%param-_glitems,
*          ls_glcurrency LIKE LINE OF ls_glitem-_currencyamount,
*
*
*          ls_apitem     LIKE LINE OF ls_doc_h-%param-_apitems,
*          ls_arcurrency LIKE LINE OF ls_apitem-_currencyamount,
*
*          ls_withholding like line of ls_doc_h-%param-_withholdingtaxitems,
*          ls_currencywithholding like line of ls_withholding-_currencyamount.
*
*          .
*    .
*
*
*
*    TRY.
*        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
*      CATCH cx_uuid_error.
*        ASSERT 1 = 0.
*    ENDTRY.
*
*
*    ls_doc_h  = VALUE #(  %cid = lv_cid
*                            %param = VALUE #(  businesstransactiontype = 'RFBU'
*                                               accountingdocumenttype = 'KM'
*                                               documentreferenceid = 'BKPFF'
*                                               companycode = '1000' " Success
*                                               createdbyuser = 'CB9980000062'
*                                               documentdate  = '20250520' "'20210204'
*                                               postingdate =   '20250520'
*                                               accountingdocumentheadertext = 'Test'
*                                               "TaxReportingDate = '20250520'
*                                               %control = VALUE #(
*                                                                      businesstransactiontype = if_abap_behv=>mk-on
*                                                                      accountingdocumenttype = if_abap_behv=>mk-on
*                                                                      documentreferenceid = if_abap_behv=>mk-on
*                                                                      companycode = if_abap_behv=>mk-on" Success
*                                                                        accountingdocumentheadertext = if_abap_behv=>mk-on
*                                                                      documentdate  = if_abap_behv=>mk-on
*                                                                      postingdate =   if_abap_behv=>mk-on
*                                                                       createdbyuser = if_abap_behv=>mk-on
*                                                                  "     taxreportingdate = if_abap_behv=>mk-on
*
*                                                ) )
*                                                ) .
*
*
*   " ls_doc_h-%param-%control
*    "GL items
*
*    ls_glitem  = VALUE #(    glaccountlineitem = |001|
*                             companycode = '1000'
*                             glaccount = '0000401003'
*                           "  profitcenter = '0000100000'
*                             CostCenter = 'NDDCC002'
*                             documentitemtext = 'Rate diff ADD 2 11 20.05.2025'
*                            " housebank = 'HDFC1'
*                             %control = VALUE #(  glaccountlineitem = if_abap_behv=>mk-on
*                                                  companycode = if_abap_behv=>mk-on
*                                                  glaccount = if_abap_behv=>mk-on
*                                                  CostCenter = if_abap_behv=>mk-on
*                                                 " profitcenter = if_abap_behv=>mk-on
*                                                  documentitemtext = if_abap_behv=>mk-on
*                                               "   housebank = if_abap_behv=>mk-on
*                                                  _currencyamount = if_abap_behv=>mk-on
*                                                         )
*
*                                                          ).
*
*     ls_glcurrency = VALUE #( Currency = 'INR'
*                             "CurrencyRole = '00'
*                             "TaxAmount = '100'
*                             JournalEntryItemAmount = '100'
*                             %control = VALUE #( Currency = if_abap_behv=>mk-on
*                                                "  CurrencyRole = if_abap_behv=>mk-on
*                                                 " taxamount = if_abap_behv=>mk-on
*                                                  JournalEntryItemAmount = if_abap_behv=>mk-on
*                                                   )  ).
*    APPEND ls_glcurrency TO ls_glitem-_currencyamount.
*    APPEND   ls_glitem TO ls_doc_h-%param-_glitems.
*
*
*
*    "APR ITEMS
*
*
*
*    ls_apitem  = VALUE #(   glaccountlineitem = |002|
*                           " customer = '1000'
*                           Supplier = '0001000011'
*                         "   specialglcode = '0021401003'
*                            businessplace  = '1000'
*
*                            assignmentreference = 'Rate diff ADD 2 11 20.05.2025'
*                            documentitemtext = 'Rate diff ADD 2 11 20.05.2025'
*                            %control = VALUE #(  glaccountlineitem = if_abap_behv=>mk-on
*                                                " customer = if_abap_behv=>mk-on
*                                                 Supplier = if_abap_behv=>mk-on
*                                              "   specialglcode = if_abap_behv=>mk-on
*                                                 businessplace  = if_abap_behv=>mk-on
*                                                 assignmentreference = if_abap_behv=>mk-on
*                                                 documentitemtext = if_abap_behv=>mk-on
*                                                 _currencyamount = if_abap_behv=>mk-on
*                                                        )
*
*                                                         ).
*
*    ls_arcurrency = VALUE #( Currency = 'INR'
*                          "  CurrencyRole = '00'
*                             JournalEntryItemAmount = '-100'
*                            %control = VALUE #( Currency = if_abap_behv=>mk-on
*                                              "  CurrencyRole = if_abap_behv=>mk-on
*                                               "  TaxAmount = if_abap_behv=>mk-on
*                                                 JournalEntryItemAmount = if_abap_behv=>mk-on
*
*                                                   )  ).
*    APPEND ls_arcurrency TO ls_apitem-_currencyamount.
*    APPEND ls_apitem TO ls_doc_h-%param-_apitems.
*
*
*
*     ls_withholding  = VALUE #(   glaccountlineitem = |002|
*                                  WithholdingTaxType = 'IC'
*                                  WithholdingTaxCode = 'C2'
*                                  %control = VALUE #(  glaccountlineitem = if_abap_behv=>mk-on
*                                                        WithholdingTaxType = if_abap_behv=>mk-on
*                                                        WithholdingTaxCode = if_abap_behv=>mk-on
*                                                        )
*
*                                                         ).
*
*    ls_currencywithholding = VALUE #( Currency = 'INR'
*                            CurrencyRole = '00'
*                            %control = VALUE #( Currency = if_abap_behv=>mk-on
*                                                 CurrencyRole = if_abap_behv=>mk-on  )  ).
*
*
*
*    APPEND ls_currencywithholding TO ls_withholding-_currencyamount.
*    APPEND ls_withholding TO ls_doc_h-%param-_withholdingtaxitems.
*
*    APPEND ls_doc_h TO lt_je_deep.
*
*    MODIFY ENTITIES OF i_journalentrytp
*                  ENTITY journalentry
*                  EXECUTE post FROM lt_je_deep
*                  FAILED FINAL(ls_failed_deep)
*                  REPORTED FINAL(ls_reported_deep)
*                  MAPPED FINAL(ls_mapped_deep).
*
*
*    IF ls_failed_deep IS NOT INITIAL.
*      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
*        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
*        "                  CLEAR : wa_msg.
**                  wa_msg-docid    = <fs_member>-docid.
**                  wa_msg-msgty    = 'E'.
**                  wa_msg-msg      = lv_result.
**                  APPEND wa_msg TO it_msg.
**                  CLEAR wa_msg.
*      ENDLOOP.
*    ELSE.
*      COMMIT ENTITIES BEGIN
*      RESPONSE OF i_journalentrytp
*      FAILED DATA(lt_commit_failed)
*      REPORTED DATA(lt_commit_reported).
*      COMMIT ENTITIES END.
*    ENDIF.





*       DATA: lt_je_deep    TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          lv_cid        TYPE abp_behv_cid,
*          ls_doc_h      LIKE LINE OF lt_je_deep,
*          ls_glitem     LIKE LINE OF ls_doc_h-%param-_glitems,
*          ls_glcurrency LIKE LINE OF ls_glitem-_currencyamount,
*
*
*          ls_apitem     LIKE LINE OF ls_doc_h-%param-_apitems,
*          ls_arcurrency LIKE LINE OF ls_apitem-_currencyamount,
*
*          ls_withholding like line of ls_doc_h-%param-_withholdingtaxitems,
*          ls_currencywithholding like line of ls_withholding-_currencyamount.



    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA: lt_invoice         TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create,
          lv_cid             TYPE abp_behv_cid,
          ls_glitem          LIKE LINE OF ls_invoice-%param-_glitems,
          ls_withholidingtax LIKE LINE OF ls_invoice-%param-_withholdingtaxes.


    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.


    ls_invoice  = VALUE #(  %cid = lv_cid
                            %param = VALUE #(
                                               accountingdocumenttype = 'KM'
                                               companycode = '1000' " Success
                                               documentdate  = '20250520' "'20210204'
                                               postingdate =   '20250520'
                                               InvoicingParty = '0001000011'
                                               DocumentCurrency = 'INR'
                                               InvoiceGrossAmount = '4000000'
                                               "TaxReportingDate = '20250520'
                                               AssignmentReference = 'A047'
                                               BusinessPlace = '1000'
                                               BusinessSectionCode = '1000'
                                               TaxDeterminationDate = '20250520' "check
                                               SupplierInvoiceIDByInvcgParty = 'INV/25-26/004'

                                               )
                                                ) .



    ls_glitem  = VALUE #(    SupplierInvoiceItem = '001'
                             companycode = '1000'
                             glaccount = '0000401003'
                            DocumentCurrency = 'INR'
                             CostCenter = 'NDDCC002'
                             SupplierInvoiceItemAmount = '4000000'
                             DebitCreditCode = 'S'
                             AssignmentReference = 'A047'



                                                          ).

append ls_glitem to ls_invoice-%param-_glitems.



*    ls_withholidingtax  = VALUE #(
*                                 WithholdingTaxType = 'IC'
*                                 WithholdingTaxCode = 'C2'
*                                 DocumentCurrency = 'INR'
*                                 WhldgTxBaseAmtInDocCry = '10000'
*                                 MnllyEnteredWhldgTxAmtInDocCry = ''
*
*
*                                                        ).

"append ls_withholidingtax to ls_invoice-%param-_withholdingtaxes.



   append ls_invoice to lt_invoice.

    MODIFY ENTITIES OF I_SUPPLIERINVOICETP
                  ENTITY SupplierInvoice
                  EXECUTE Create FROM lt_invoice
                  FAILED FINAL(ls_failed_deep)
                  REPORTED FINAL(ls_reported_deep)
                  MAPPED FINAL(ls_mapped_deep).



  "  DELETE ls_reported_deep-supplierinvoice WHERE msgty = 'W'.
    "data(ls_data) = ls_reported_deep.
    "DELETE ls_data-supplierinvoice WHERE msgty = 'W'.
    IF ls_failed_deep IS NOT INITIAL.
      LOOP AT ls_reported_deep-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
        DATA(lv_result1) = <ls_reported_deep>-%msg->severity.
      "  lv_result = lv_result && lv_result1.
        "                  CLEAR : wa_msg.
*                  wa_msg-docid    = <fs_member>-docid.
*                  wa_msg-msgty    = 'E'.
*                  wa_msg-msg      = lv_result.
*                  APPEND wa_msg TO it_msg.
*                  CLEAR wa_msg.
      ENDLOOP.
    ELSE.
      COMMIT ENTITIES BEGIN
      RESPONSE OF i_journalentrytp
      FAILED DATA(lt_commit_failed)
      REPORTED DATA(lt_commit_reported).
      COMMIT ENTITIES END.
    ENDIF.






  ENDMETHOD.
ENDCLASS.
