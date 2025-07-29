CLASS zbg_journal_posting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES : if_oo_adt_classrun .

    DATA: lt_zfit_accdoc TYPE TABLE OF zfit_accdoc,
          it_doc         TYPE TABLE OF zfit_accdoc.

    DATA: lt_doc_h        TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid          TYPE abp_behv_cid,
          ls_doc_h        LIKE LINE OF lt_doc_h,
          ls_glitem       LIKE LINE OF ls_doc_h-%param-_glitems,
          ls_glcurrency   LIKE LINE OF ls_glitem-_currencyamount,
          ls_aritem       LIKE LINE OF ls_doc_h-%param-_aritems, "customer
          ls_taxitems     LIKE LINE OF ls_doc_h-%param-_taxitems,
          ls_custcurrency LIKE LINE OF ls_aritem-_currencyamount,
          ls_apitem       LIKE LINE OF ls_doc_h-%param-_apitems, "vendor
          ls_vencurrency  LIKE LINE OF ls_apitem-_currencyamount,
          lv_docid(10)    TYPE c,
          lv_buzei        TYPE i,
          lv_lifnr1       TYPE I_JournalEntryItem-Supplier,
          lv_lifnr2       TYPE I_JournalEntryItem-Supplier,
          lv_item type i.

    TYPES : BEGIN OF ty_msg,
              docid(10) TYPE c,
              belnr     TYPE belnr_d,
              msgty(1)  TYPE c,
              msg(200)  TYPE c,
            END OF ty_msg.
    DATA : it_msg    TYPE STANDARD TABLE OF ty_msg,
           wa_msg    TYPE ty_msg,
           lv_result TYPE string,
           lv_msg    TYPE c LENGTH 200.
    DATA : r_date TYPE RANGE OF datum,
           s_date LIKE LINE OF r_date.


    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA: lt_invoice         TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create,
          " lv_cid             TYPE abp_behv_cid,
          ls_glitem1         LIKE LINE OF ls_invoice-%param-_glitems,
          ls_withholidingtax LIKE LINE OF ls_invoice-%param-_withholdingtaxes.

    METHODS: post.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBG_JOURNAL_POSTING IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

    et_parameter_def = VALUE #(
      ( selname = 'R_DATE' kind = if_apj_dt_exec_object=>select_option
*    component_type = 'DATUM'
        datatype = 'D'
        mandatory_ind = abap_true
        param_text  = 'Select Posting date' changeable_ind = abap_true ) ).


    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'R_DATE' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'BT'
                                  low  = cl_abap_context_info=>get_system_date(  )
                                  high = cl_abap_context_info=>get_system_date(  ) )
                                    ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.


    " Getting the actual parameter values(Just for show. Not needed for the logic below)
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'R_DATE'.
          s_date-sign   = ls_parameter-sign.
          s_date-option = ls_parameter-option.
          s_date-low    = ls_parameter-low.
          s_date-high   = ls_parameter-high.
          APPEND s_date TO r_date.
*         clear s_date.
      ENDCASE.
    ENDLOOP.


    SELECT * FROM zfit_accdoc
     WHERE budat IN @r_date
     AND belnr IS INITIAL
     AND uname = @sy-uname
     INTO TABLE @it_doc.


    lt_zfit_accdoc[] = it_doc[].
    CALL METHOD post( ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main .


*    s_date-sign   = 'I'.
*    s_date-option = 'BT'.
**          s_date-low    = '09.02.2028'.
**          s_date-high   = ls_parameter-high.
*    APPEND s_date TO r_date.


    SELECT * FROM zfit_accdoc
 "  WHERE "belnr IS INITIAL and
   "docid = '1'
   INTO TABLE @it_doc.


    lt_zfit_accdoc[] = it_doc[].
    CALL METHOD post( ).

  ENDMETHOD.


  METHOD post .
    TRY.

        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                     'ZLOG_JOURNAL' subobject = 'ZSUB_LOG_JOURNAL' ) ).

*     LV_MSG = 'Job Started'.
        CONCATENATE 'Job Started' s_date-low s_date-high INTO lv_msg SEPARATED BY ''.

        DATA(l_free_text) = cl_bali_free_text_setter=>create( severity =
                            if_bali_constants=>c_severity_status
                            text = lv_msg ).

        l_log->add_item( item = l_free_text ).

        "Save the log into the database
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
        COMMIT WORK.

 "       DELETE lt_zfit_accdoc WHERE hkont is INITIAL.
       DELETE lt_zfit_accdoc WHERE hkont is INITIAL and umskz is INITIAL.
        SORT lt_zfit_accdoc BY docid.
      "  DELETE ADJACENT DUPLICATES FROM lt_zfit_accdoc  COMPARING docid.
        LOOP AT lt_zfit_accdoc ASSIGNING FIELD-SYMBOL(<fs_doc>).

          lv_docid = <fs_doc>-docid.

          """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

          """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""


          "Addition of withholging logic
          IF NOT ( <fs_doc>-hkont = '401003' AND <fs_doc>-shkzg = 'DR' ).
         "   IF lv_docid <> <fs_doc>-docid.
          "    lv_docid = <fs_doc>-docid.




              LOOP AT it_doc ASSIGNING FIELD-SYMBOL(<fs_member>) WHERE docid = lv_docid.

                lv_cid = <fs_member>-id.

                IF <fs_member>-hkont IS NOT INITIAL.
                  lv_buzei = lv_buzei + 1.
                  ls_glitem-glaccountlineitem = lv_buzei.         ls_glitem-%control-glaccountlineitem = if_abap_behv=>mk-on.
                  ls_glitem-glaccount         = <fs_member>-hkont.ls_glitem-%control-glaccount = if_abap_behv=>mk-on.
                  ls_glitem-costcenter        = <fs_member>-kostl.ls_glitem-%control-costcenter = if_abap_behv=>mk-on.
                  ls_glitem-profitcenter      = <fs_member>-prctr.ls_glitem-%control-profitcenter = if_abap_behv=>mk-on.
                  ls_glitem-housebank = <fs_member>-bank.       ls_glitem-%control-housebank = if_abap_behv=>mk-on.
                  ls_glitem-housebankaccount = <fs_member>-hbkid.   ls_glitem-%control-housebankaccount = if_abap_behv=>mk-on.
                  ls_glitem-businessplace = <fs_member>-bupla.ls_glitem-%control-businessplace = if_abap_behv=>mk-on.
                  ls_glitem-assignmentreference = <fs_member>-zuonr.ls_glitem-%control-assignmentreference = if_abap_behv=>mk-on.
                  ls_glitem-documentitemtext = <fs_member>-sgtxt.ls_glitem-%control-documentitemtext = if_abap_behv=>mk-on.
*                ls_glitem-TaxCode = <fs_member>-mwskz.

                  IF <fs_member>-shkzg = 'CR'. "CR = H
                    ls_glcurrency-journalentryitemamount = <fs_member>-dmbtr * -1.
                  ELSE.
                    ls_glcurrency-journalentryitemamount = <fs_member>-dmbtr.
                  ENDIF.
                  ls_glcurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
                  ls_glcurrency-currency = <fs_member>-waers.             ls_glcurrency-%control-currency = if_abap_behv=>mk-on.
                  ls_glcurrency-currencyrole = '00'.                      ls_glcurrency-%control-currencyrole = if_abap_behv=>mk-on.


                  ls_glitem-%control-_currencyamount = if_abap_behv=>mk-on.
                  ls_doc_h-%param-%control-_glitems = if_abap_behv=>mk-on.

                  APPEND ls_glcurrency TO ls_glitem-_currencyamount.
                  APPEND ls_glitem TO ls_doc_h-%param-_glitems.
                ENDIF.


                IF <fs_member>-kunnr IS NOT INITIAL.
                  lv_buzei = lv_buzei + 1.
                  ls_aritem-glaccountlineitem = lv_buzei. ls_aritem-%control-glaccountlineitem = if_abap_behv=>mk-on.
                  ls_aritem-customer = <fs_member>-kunnr. ls_aritem-%control-customer = if_abap_behv=>mk-on.
                  ls_aritem-specialglcode     = <fs_member>-umskz.ls_aritem-%control-specialglcode = if_abap_behv=>mk-on.
                  ls_aritem-businessplace = <fs_member>-bupla.ls_aritem-%control-businessplace = if_abap_behv=>mk-on.
                  ls_aritem-assignmentreference = <fs_member>-zuonr.ls_aritem-%control-assignmentreference = if_abap_behv=>mk-on.
                  ls_aritem-documentitemtext = <fs_member>-sgtxt.ls_aritem-%control-documentitemtext = if_abap_behv=>mk-on.

                  IF <fs_member>-shkzg = 'CR'. "CR = H
                    ls_custcurrency-journalentryitemamount = <fs_member>-dmbtr * -1.
                  ELSE.
                    ls_custcurrency-journalentryitemamount = <fs_member>-dmbtr.
                  ENDIF.

                  ls_custcurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
                  ls_custcurrency-currency = <fs_member>-waers.ls_custcurrency-%control-currency = if_abap_behv=>mk-on.
                  ls_custcurrency-currencyrole = '00'.         ls_custcurrency-%control-currencyrole = if_abap_behv=>mk-on.

                  ls_aritem-%control-_currencyamount = if_abap_behv=>mk-on.
                  ls_doc_h-%param-%control-_aritems = if_abap_behv=>mk-on.

                  APPEND ls_custcurrency TO ls_aritem-_currencyamount.
                  APPEND ls_aritem TO ls_doc_h-%param-_aritems.
                ENDIF.


                IF <fs_member>-lifnr IS NOT INITIAL.
                  lv_buzei = lv_buzei + 1.
                  ls_apitem-glaccountlineitem = lv_buzei. ls_apitem-%control-glaccountlineitem = if_abap_behv=>mk-on.
                  ls_apitem-supplier = <fs_member>-lifnr. ls_apitem-%control-supplier = if_abap_behv=>mk-on.
                  ls_apitem-specialglcode = <fs_member>-umskz. ls_apitem-%control-specialglcode = if_abap_behv=>mk-on.
                  ls_apitem-businessplace = <fs_member>-bupla.ls_apitem-%control-businessplace = if_abap_behv=>mk-on.
                  ls_apitem-assignmentreference = <fs_member>-zuonr.ls_apitem-%control-assignmentreference = if_abap_behv=>mk-on.
                  ls_apitem-documentitemtext = <fs_member>-sgtxt.ls_apitem-%control-documentitemtext = if_abap_behv=>mk-on.
                  ls_apitem-paymentmethod = <fs_member>-zlsch.ls_apitem-%control-paymentmethod = if_abap_behv=>mk-on.

                  IF <fs_member>-shkzg = 'CR'. "CR = H
                    ls_vencurrency-journalentryitemamount = <fs_member>-dmbtr * -1.
                  ELSE.
                    ls_vencurrency-journalentryitemamount = <fs_member>-dmbtr.
                  ENDIF.
                  ls_vencurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
                  ls_vencurrency-currency = <fs_member>-waers.  ls_vencurrency-%control-currency = if_abap_behv=>mk-on.


                  ls_apitem-%control-_currencyamount = if_abap_behv=>mk-on.
                  ls_doc_h-%param-%control-_apitems = if_abap_behv=>mk-on.

                  APPEND ls_vencurrency TO ls_apitem-_currencyamount.
                  APPEND ls_apitem TO ls_doc_h-%param-_apitems.

                ENDIF.

                CLEAR: ls_aritem, ls_apitem, ls_glitem, ls_glcurrency, ls_custcurrency, ls_vencurrency.
              ENDLOOP.

              ls_doc_h-%cid = lv_cid.
              ls_doc_h-%param-companycode = <fs_member>-bukrs.
              ls_doc_h-%param-documentreferenceid = 'BKPFF'.
              ls_doc_h-%param-createdbyuser = sy-uname.
              ls_doc_h-%param-businesstransactiontype = 'RFBU'.
              ls_doc_h-%param-accountingdocumenttype = <fs_member>-blart.
              ls_doc_h-%param-documentdate = <fs_member>-bldat.
              ls_doc_h-%param-postingdate = <fs_member>-budat.
              ls_doc_h-%param-accountingdocumentheadertext = <fs_member>-bktxt.
*            ls_doc_h-%param-TaxDeterminationDate = <fs_member>-budat.

              ls_doc_h-%param-%control-companycode = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-documentreferenceid = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-createdbyuser = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-businesstransactiontype = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-accountingdocumenttype = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-documentdate = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-postingdate = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-accountingdocumentheadertext = if_abap_behv=>mk-on.
              ls_doc_h-%param-%control-documentreferenceid = if_abap_behv=>mk-on.

              APPEND ls_doc_h TO lt_doc_h.

              IF lt_doc_h IS NOT INITIAL.

                MODIFY ENTITIES OF i_journalentrytp
                    ENTITY journalentry
                    EXECUTE post FROM lt_doc_h
                    FAILED FINAL(ls_failed_deep)
                    REPORTED FINAL(ls_reported_deep)
                    MAPPED FINAL(ls_mapped_deep).


                IF ls_failed_deep IS NOT INITIAL.
                  LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
                    lv_result = <ls_reported_deep>-%msg->if_message~get_text( ).
                    CLEAR : wa_msg.
                    wa_msg-docid    = <fs_member>-docid.
                    wa_msg-msgty    = 'E'.
                    wa_msg-msg      = lv_result.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
                  ENDLOOP.
                ELSE.
                  COMMIT ENTITIES BEGIN
                  RESPONSE OF i_journalentrytp
                  FAILED DATA(lt_commit_failed)
                  REPORTED DATA(lt_commit_reported).


                  IF lt_commit_reported IS NOT INITIAL.
                    LOOP AT lt_commit_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_invoice>).
                      IF <ls_invoice>-accountingdocument IS NOT INITIAL.
                        "Success case
                        CLEAR : wa_msg.
                        wa_msg-belnr    = <ls_invoice>-accountingdocument.
                        wa_msg-msgty    = 'S'.
                        CONCATENATE  'Journal Posted Doc No. ' <ls_invoice>-accountingdocument INTO wa_msg-msg SEPARATED BY ''.
                        APPEND wa_msg TO it_msg.
                        CLEAR wa_msg.

                        UPDATE zfit_accdoc SET belnr = @<ls_invoice>-accountingdocument,
                                                gjahr = @<ls_invoice>-fiscalyear,
                                                bukrs = @<ls_invoice>-companycode
                                          WHERE docid = @<fs_member>-docid.
                        COMMIT WORK.
                      ELSE.

                        "Error handling

                        CLEAR : wa_msg.
                        wa_msg-docid    = <fs_member>-docid.
                        wa_msg-msgty    = 'E'.
                        CONCATENATE 'Error hile Journal Entry' <fs_member>-docid
                        INTO wa_msg-msg SEPARATED BY ''.
                        APPEND wa_msg TO it_msg.
                        CLEAR wa_msg.
                      ENDIF.



                    ENDLOOP.
                  ENDIF.

                  IF lt_commit_failed IS NOT INITIAL.
                    LOOP AT lt_commit_reported-journalentry ASSIGNING FIELD-SYMBOL(<ls_commit>).
                      "Error handling

                      CLEAR lv_result.
                      lv_result = lv_result = <ls_commit>-%msg->if_message~get_text( ).

                      CLEAR : wa_msg.
                      wa_msg-docid    = <fs_member>-docid.
                      wa_msg-msgty    = 'E'.
                      wa_msg-msg      = lv_result.
                      APPEND wa_msg TO it_msg.
                      CLEAR wa_msg.

                    ENDLOOP.
                  ENDIF.

                  COMMIT ENTITIES END.
                ENDIF.


                CLEAR: lt_doc_h[], ls_doc_h.


              ENDIF.
         "   ENDIF.

          ELSE.   "Withholdingtax

            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""
            """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""



*            lv_cid = <fs_doc>-id.
*            lv_lifnr1 = |{ <fs_doc>-hkont  ALPHA = IN } |.
*            ls_invoice  = VALUE #(  %cid = lv_cid
*                        %param = VALUE #(
*                                           accountingdocumenttype =  <fs_doc>-blart   "'KM'
*                                           companycode = <fs_doc>-bukrs   "'1000' " Success
*                                           documentdate  = <fs_doc>-bldat "'20250520' "'20210204'
*                                           postingdate =  <fs_doc>-budat  " '20250520'
*                                           InvoicingParty = <fs_doc>-lifnr  " '0001000011'
*                                           DocumentCurrency = <fs_doc>-waers   "'INR'
*                                           InvoiceGrossAmount =  <fs_doc>-dmbtr " '4000000'
*                                           TaxReportingDate = '20250520'
*                                           AssignmentReference = <fs_doc>-zuonr    "'A047'
*                                           BusinessPlace = <fs_doc>-bupla  "'1000'
*                                           BusinessSectionCode =   <fs_doc>-secco  "'1000'
*                                           TaxDeterminationDate = <fs_doc>-budat     " '20250520' "check
*                                           SupplierInvoiceIDByInvcgParty = <fs_doc>-xblnr "'INV/25-26/004'
*                                          PaymentMethod =  <fs_doc>-zlsch
*
*                                           )
*                                            ) .

*            ls_glitem1  = VALUE #(    SupplierInvoiceItem =  lv_buzei + 1
*                         companycode = <fs_doc>-bukrs
*                         glaccount = lv_lifnr1
*                         DocumentCurrency =  <fs_doc>-waers
*                        CostCenter = <fs_doc>-kostl
*                        SupplierInvoiceItemAmount = <fs_doc>-dmbtr
*                        DebitCreditCode = 'S'
*                        AssignmentReference = <fs_doc>-zuonr
*
*                        "Additonal fields
*                     "   ProfitCenter = <ls_doc>-
*                     SupplierInvoiceItemText = <fs_doc>-sgtxt ).

*            LOOP AT it_doc ASSIGNING FIELD-SYMBOL(<ls_doc>) WHERE docid = lv_docid.
*            ls_invoice  = VALUE #(  %cid = lv_cid
*                          %param = VALUE #(
*                                             InvoicingParty = <ls_doc>-lifnr  " '0001000011'
*
*
*                                             )
*                                              ) .
*
*            ENDLOOP.



            LOOP AT it_doc ASSIGNING FIELD-SYMBOL(<ls_doc>) WHERE docid = lv_docid.
            lv_item = lv_item + 1.
            lv_cid = <ls_doc>-id.
            lv_lifnr1 = |{ <ls_doc>-hkont  ALPHA = IN } |.
            lv_lifnr2 = |{ <ls_doc>-lifnr  ALPHA = IN } |.
*            ls_invoice  = VALUE #(  %cid = lv_cid
*                        %param = VALUE #(
*                                           accountingdocumenttype =  <fs_doc>-blart   "'KM'
*                                           companycode = <fs_doc>-bukrs   "'1000' " Success
*                                           documentdate  = <fs_doc>-bldat "'20250520' "'20210204'
*                                           postingdate =  <fs_doc>-budat  " '20250520'
*                                           InvoicingParty = <fs_doc>-lifnr  " '0001000011'   dal
*                                           DocumentCurrency = <fs_doc>-waers   "'INR'
*                                           InvoiceGrossAmount =  <fs_doc>-dmbtr " '4000000'
*                                           TaxReportingDate = '20250520'
*                                           AssignmentReference = <fs_doc>-zuonr    "'A047'
*                                           BusinessPlace = <fs_doc>-bupla  "'1000'
*                                           BusinessSectionCode =   <fs_doc>-secco  "'1000'
*                                           TaxDeterminationDate = <fs_doc>-budat     " '20250520' "check
*                                           SupplierInvoiceIDByInvcgParty = <fs_doc>-xblnr "'INV/25-26/004'
*                                          PaymentMethod =  <fs_doc>-zlsch
*
*                                           )
*                                            ) .


            if <ls_doc>-lifnr is initial.
            ls_invoice-%cid = lv_cid.
            ls_invoice-%param-AccountingDocumentType = <ls_doc>-blart.
            ls_invoice-%param-companycode = <ls_doc>-bukrs.
            ls_invoice-%param-documentdate = <ls_doc>-bldat.
            ls_invoice-%param-postingdate = <ls_doc>-budat.
            ls_invoice-%param-DocumentCurrency = <ls_doc>-waers.
            ls_invoice-%param-InvoiceGrossAmount = <ls_doc>-dmbtr.
          "  ls_invoice-%param-TaxReportingDate = <ls_doc>-budat.
            ls_invoice-%param-AssignmentReference = <ls_doc>-zuonr.
            ls_invoice-%param-BusinessPlace = <ls_doc>-bupla.
            ls_invoice-%param-BusinessSectionCode = <ls_doc>-secco.
            ls_invoice-%param-TaxDeterminationDate = <ls_doc>-budat.
            ls_invoice-%param-SupplierInvoiceIDByInvcgParty = <ls_doc>-xblnr.
            ls_invoice-%param-PaymentMethod = <ls_doc>-zlsch.

            endif.

            if <ls_doc>-lifnr is not initial.
            ls_invoice-%param-InvoicingParty =   lv_lifnr2 ."<ls_doc>-lifnr.

            endif.


*              ls_glitem1  = VALUE #(    SupplierInvoiceItem =  lv_buzei + 1
*                         companycode = <fs_doc>-bukrs
*                         glaccount = lv_lifnr1
*                         DocumentCurrency =  <fs_doc>-waers
*                        CostCenter = <fs_doc>-kostl
*                        SupplierInvoiceItemAmount = <fs_doc>-dmbtr
*                        DebitCreditCode = 'S'
*                        AssignmentReference = <fs_doc>-zuonr
*
*                        "Additonal fields
*                     "   ProfitCenter = <ls_doc>-
*                     SupplierInvoiceItemText = <fs_doc>-sgtxt ).

               if <ls_doc>-lifnr is initial.
               ls_glitem1-SupplierInvoiceItem =  lv_item + 1.    "lv_buzei + 1.
               ls_glitem1-companycode = <ls_doc>-bukrs.
               ls_glitem1-glaccount = lv_lifnr1.
               ls_glitem1-DocumentCurrency = <ls_doc>-waers.
               ls_glitem1-CostCenter = <ls_doc>-kostl.
               ls_glitem1-SupplierInvoiceItemAmount = <ls_doc>-dmbtr.
               ls_glitem1-DebitCreditCode = 'S'.
               ls_glitem1-AssignmentReference = <ls_doc>-zuonr.
               ls_glitem1-SupplierInvoiceItemText = <ls_doc>-sgtxt.

            endif.
            ENDLOOP.



            APPEND ls_glitem1 TO ls_invoice-%param-_glitems.
            APPEND ls_invoice TO lt_invoice.

            MODIFY ENTITIES OF i_supplierinvoicetp
                          ENTITY SupplierInvoice
                          EXECUTE Create FROM lt_invoice
                          FAILED FINAL(ls_failed_deep1)
                          REPORTED FINAL(ls_reported_deep1)
                          MAPPED FINAL(ls_mapped_deep1).

            "          ).




            """""""""""""""""""""""""""""""""""""""""""""""""""""""


            IF ls_failed_deep1 IS NOT INITIAL.
              LOOP AT ls_reported_deep1-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_reported_deep1>).
                lv_result = <ls_reported_deep1>-%msg->if_message~get_text( ).
                DATA(lv_result) = <ls_reported_deep1>-%msg->if_message~get_text( ).
                CLEAR : wa_msg.
                wa_msg-docid    = <ls_doc>-docid.
                wa_msg-msgty    = 'E'.
                wa_msg-msg      = lv_result.
                APPEND wa_msg TO it_msg.
                CLEAR wa_msg.
              ENDLOOP.
            ELSE.
              COMMIT ENTITIES BEGIN
              RESPONSE OF i_supplierinvoicetp
              FAILED DATA(lt_commit_failed1)
              REPORTED DATA(lt_commit_reported1).

*
              IF lt_commit_reported1 IS NOT INITIAL.
                LOOP AT lt_commit_reported1-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_invoice1>).
                  IF <ls_invoice1>-SupplierInvoice IS NOT INITIAL.
                    "Success case
                    CLEAR : wa_msg.
                    wa_msg-belnr    = <ls_invoice1>-SupplierInvoice.
                    wa_msg-msgty    = 'S'.
                    CONCATENATE  'Journal Posted Doc No. ' <ls_invoice1>-SupplierInvoice INTO wa_msg-msg SEPARATED BY ''.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.

                    UPDATE zfit_accdoc SET belnr = @<ls_invoice1>-SupplierInvoice,
                                            gjahr = @<ls_invoice1>-SupplierInvoiceFiscalYear
                                          "  bukrs = @<ls_invoice1>-companycode
                                      WHERE docid = @<ls_doc>-docid.
                    COMMIT WORK.
                  ELSE.

                    "Error handling

                    CLEAR : wa_msg.
                    wa_msg-docid    = <ls_doc>-docid.
                    wa_msg-msgty    = 'E'.
                    CONCATENATE 'Error hile Journal Entry' <ls_doc>-docid
                    INTO wa_msg-msg SEPARATED BY ''.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
                  ENDIF.



                ENDLOOP.
              ENDIF.
*
              IF lt_commit_failed1 IS NOT INITIAL.
                LOOP AT lt_commit_reported1-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_commit1>).
                  "Error handling

                  CLEAR lv_result.
                  lv_result = lv_result = <ls_commit1>-%msg->if_message~get_text( ).

                  CLEAR : wa_msg.
                  wa_msg-docid    = <ls_doc>-docid.
                  wa_msg-msgty    = 'E'.
                  wa_msg-msg      = lv_result.
                  APPEND wa_msg TO it_msg.
                  CLEAR wa_msg.

                ENDLOOP.
              ENDIF.

              COMMIT ENTITIES END.
            ENDIF.


*  APPEND ls_glitem1 TO ls_invoice-%param-_glitems.
*            APPEND ls_invoice TO lt_invoice.

               CLEAR: lt_doc_h[], ls_doc_h, lt_invoice,ls_glitem1, ls_invoice.



            """""""""""""""""""""""""""""""""""""""""""""""""""""""

          ENDIF.
        ENDLOOP.


        LOOP AT it_msg INTO wa_msg.

          CONCATENATE wa_msg-docid wa_msg-msg INTO lv_msg SEPARATED BY space.


          l_free_text = cl_bali_free_text_setter=>create( severity = wa_msg-msgty
*                            if_bali_constants=>c_severity_ status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDLOOP.

        IF it_msg[] IS NOT INITIAL.

          lv_msg = 'Job Completed'.

          l_free_text = cl_bali_free_text_setter=>create( severity =
                              if_bali_constants=>c_severity_status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDIF.

      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
      data(lv_error) = l_runtime_exception->get_text(  ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
