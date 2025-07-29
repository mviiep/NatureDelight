CLASS zbg_milk_miro_posting DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBG_MILK_MIRO_POSTING IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'R_DATE' kind = if_apj_dt_exec_object=>select_option
*    component_type = 'DATUM'
        datatype = 'D'
        mandatory_ind = abap_true
        param_text  = 'Selection Date Range' changeable_ind = abap_true )
      ( selname = 'P_DATE' kind = if_apj_dt_exec_object=>parameter
        datatype = 'D' "length = 4
        mandatory_ind = abap_true
        param_text  = 'Posting Date' changeable_ind = abap_true )
      ( selname = 'R_SLOC' kind = if_apj_dt_exec_object=>select_option
        datatype = 'C' length = 4
        mandatory_ind = abap_FALSE
        param_text  = 'Storage Location' changeable_ind = abap_true )
*  ( selname = 'P_RAWM' kind = if_apj_dt_exec_object=>parameter
*    datatype = 'C' length = 40
*    param_text  = 'Raw Milk Material Code' changeable_ind = abap_true )
*  ( selname = 'P_ORDM' kind = if_apj_dt_exec_object=>parameter
*    datatype = 'C' length = 40
*    param_text  = 'Order Header Material Code' changeable_ind = abap_true )
*  ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter
*    datatype = 'C' length = 1
*    param_text = 'Simulate Only' checkbox_ind = abap_FALSE changeable_ind = abap_true )
      ).


    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'R_DATE' kind = if_apj_dt_exec_object=>select_option sign = 'I' option = 'BT'
                                  low  = cl_abap_context_info=>get_system_date(  )
                                  high = cl_abap_context_info=>get_system_date(  ) )
*  ( selname = 'P_SLOC' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = 'S004' )
*  ( selname = 'P_RAWM' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '000000000000000033' )
*  ( selname = 'P_ORDM' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '000000000000000034' )
*  ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low =  abap_true )
      ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA : r_date TYPE RANGE OF datum,
           s_date LIKE LINE OF r_date,
           p_date TYPE datum,
           LV_SLOC(4) TYPE C,
           R_SLOC LIKE RANGE OF LV_SLOC,
           S_SLOC LIKE LINE OF R_SLOC.


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
        WHEN 'R_SLOC'.
          s_SLOC-sign   = ls_parameter-sign.
          s_SLOC-option = ls_parameter-option.
          s_SLOC-low    = ls_parameter-low.
          s_SLOC-high   = ls_parameter-high.
          APPEND s_SLOC TO r_SLOC.
*         clear s_date.
        WHEN 'P_DATE'.
          p_date = ls_parameter-low.
      ENDCASE.
    ENDLOOP.


    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA lt_invoice TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA : ls_data LIKE LINE OF ls_invoice-%param-_itemswithporeference.

    TYPES : BEGIN OF ty_msg,
              ebeln    TYPE ebeln,
              msgty(1) TYPE c,
              msg(200) TYPE c,
            END OF ty_msg.
    DATA : it_msg     TYPE STANDARD TABLE OF ty_msg,
           wa_msg     TYPE ty_msg,
           lv_result2 TYPE string,
           lv_msg     TYPE c LENGTH 200.
    DATA : lv_line   TYPE rblgp,
           lv_amount  TYPE wrbtr_cs,
           lv_amount2 TYPE wrbtr_cs,
           lv_amount1(40) type c,
           wa_zmm_milk_miro type zmm_milk_miro.

    SELECT * FROM zmm_milkcoll
    WHERE mirodoc = ''
    AND   mblnr NE ''
    AND   coll_date IN @r_date
    AND   SLOC IN @R_SLOC
    INTO TABLE @DATA(lt_milkcoll).

    IF lt_milkcoll[] IS NOT INITIAL.
      SORT lt_milkcoll BY lifnr coll_date.
      DATA(lt_milkcoll_1) = lt_milkcoll[].
      SORT lt_milkcoll_1 BY lifnr sloc.
      DELETE ADJACENT DUPLICATES FROM lt_milkcoll_1 COMPARING lifnr sloc.
    ENDIF.

    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
               'ZMILK_MIRO' subobject = 'ZMILK_MIRO_SUB' ) ).

*     LV_MSG = 'Job Started'.
        CONCATENATE 'Job Started' s_date-low s_date-high INTO lv_msg SEPARATED BY ''.

        DATA(l_free_text) = cl_bali_free_text_setter=>create( severity =
                            if_bali_constants=>c_severity_status
                            text = lv_msg ).

        l_log->add_item( item = l_free_text ).

        "Save the log into the database
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
        COMMIT WORK.

        LOOP AT lt_milkcoll_1 INTO DATA(ls_milkcoll_1).

          CLEAR : ls_invoice, lt_invoice[], lv_line, lv_amount.

*  post Miro

          TRY.
              DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
            CATCH cx_uuid_error.
              "Error handling
          ENDTRY.

          LOOP AT lt_milkcoll INTO DATA(ls_milkcoll) WHERE lifnr = ls_milkcoll_1-lifnr
                                                     AND   sloc = ls_milkcoll_1-sloc.

           select SINGLE materialdocument from I_MATERIALDOCUMENTITEM_2
           WHERE reversedmaterialdocument = @ls_milkcoll-mblnr
           AND   reversedmaterialdocumentyear = @ls_milkcoll-mjahr
           into @data(lv_revdoc).
           if sy-subrc = 0 AND lv_revdoc is NOT INITIAL.
            CONTINUE.
           endif.

            lv_line = lv_line + 1.
            lv_amount = lv_amount + ( ls_milkcoll-milk_qty * ls_milkcoll-rate ).
            lv_amount1 = lv_amount.
            split lv_amount1 at '.' INTO data(str1) data(str2).
            lv_amount = str1.
            lv_amount2 = lv_amount2 + lv_amount.

*    ls_invoice-%param-_itemswithporeference = VALUE #(
            ls_data = VALUE #(
             supplierinvoiceitem = lv_line                  "'000001'
             purchaseorder = ls_milkcoll-ebeln
             purchaseorderitem = '00010'
             referencedocument = ls_milkcoll-mblnr
             referencedocumentfiscalyear = ls_milkcoll-mjahr
             referencedocumentitem = '0001'
             documentcurrency = 'INR'
             supplierinvoiceitemamount = ls_milkcoll-milk_qty * ls_milkcoll-rate "lv_amount "
             purchaseorderquantityunit = 'L'
             quantityinpurchaseorderunit = ls_milkcoll-milk_qty
             taxcode = 'V0'
             ).

            APPEND ls_data TO ls_invoice-%param-_itemswithporeference.
*     INSERT ls_invoice INTO TABLE lt_invoice.
          ENDLOOP.

*            lv_amount1 = lv_amount.
*            split lv_amount1 at '.' INTO data(str1) data(str2).
*            lv_amount = str1.
*            lv_amount2 = lv_amount2 + lv_amount.


          ls_invoice-%cid = lv_cid.
          ls_invoice-%param-supplierinvoiceiscreditmemo = abap_false.
          ls_invoice-%param-companycode = '1000'.
          ls_invoice-%param-invoicingparty = ls_milkcoll_1-lifnr.
          ls_invoice-%param-postingdate = p_date. "cl_abap_context_info=>get_system_date(  ).
          ls_invoice-%param-documentdate = p_date. " sy-datlo. "cl_abap_context_info=>get_system_date(  ).
          ls_invoice-%param-documentcurrency = 'INR'.
          ls_invoice-%param-invoicegrossamount = lv_amount.
          ls_invoice-%param-taxiscalculatedautomatically = abap_true.
          ls_invoice-%param-supplierinvoiceidbyinvcgparty = ls_milkcoll_1-lifnr.
          ls_invoice-%param-businessplace = '1000'.
          ls_invoice-%param-businesssectioncode = '1000'.
          ls_invoice-%param-paymentmethod = 'T'.
          ls_invoice-%param-taxdeterminationdate = sy-datlo. "cl_abap_context_info=>get_system_date(  ).
          ls_invoice-%param-documentheadertext = 'AUTO_MIRO'.
          ls_invoice-%param-assignmentreference = ls_milkcoll_1-sloc.
          INSERT ls_invoice INTO TABLE lt_invoice.

          "Register the action
          MODIFY ENTITIES OF i_supplierinvoicetp
          ENTITY supplierinvoice
          EXECUTE create FROM lt_invoice
          FAILED DATA(ls_failed)
          REPORTED DATA(ls_reported)
          MAPPED DATA(ls_mapped).

          CLEAR lv_result2.
          IF ls_failed IS NOT INITIAL.
            DATA lo_message TYPE REF TO if_message.
            LOOP AT ls_reported-supplierinvoice INTO DATA(ls_supplierinvoice).
              lo_message = ls_supplierinvoice-%msg.
              CLEAR lv_result2.
              lv_result2 = lo_message->get_text( ).
              "Error handling
              CLEAR : wa_msg.
              wa_msg-ebeln    = ls_milkcoll_1-lifnr.
              wa_msg-msgty    = 'E'.
              wa_msg-msg      = lv_result2.
              APPEND wa_msg TO it_msg.
              CLEAR wa_msg.
            ENDLOOP.

          ENDIF.

          "Execution the action
          IF lv_result2 IS INITIAL.
            COMMIT ENTITIES
             RESPONSE OF i_supplierinvoicetp
             FAILED DATA(ls_commit_failed)
             REPORTED DATA(ls_commit_reported).

            IF ls_commit_reported IS NOT INITIAL.
              LOOP AT ls_commit_reported-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_invoice>).
                IF <ls_invoice>-supplierinvoice IS NOT INITIAL AND
                <ls_invoice>-supplierinvoicefiscalyear IS NOT INITIAL.
                  "Success case

                  CLEAR : wa_msg.
                  wa_msg-ebeln    = ls_milkcoll_1-lifnr.
                  wa_msg-msgty    = 'S'.
                  CONCATENATE 'MIRO Doc'
                  <ls_invoice>-supplierinvoice <ls_invoice>-supplierinvoicefiscalyear
                  'Posted for Supplier' ls_milkcoll_1-lifnr '/' ls_milkcoll_1-sloc INTO wa_msg-msg SEPARATED BY ''.
                  APPEND wa_msg TO it_msg.
                  CLEAR wa_msg.

                  LOOP AT lt_milkcoll INTO ls_milkcoll WHERE lifnr = ls_milkcoll_1-lifnr
                                                       AND   sloc = ls_milkcoll_1-sloc.
                    UPDATE zmm_milkcoll SET mirodoc = @<ls_invoice>-supplierinvoice,
                                            miro_year = @<ls_invoice>-supplierinvoicefiscalyear
                     WHERE id = @ls_milkcoll-id.

                    clear wa_zmm_milk_miro.
                    MOVE-CORRESPONDING ls_milkcoll to wa_zmm_milk_miro.
                    wa_zmm_milk_miro-mirodoc  = <ls_invoice>-supplierinvoice.
                    wa_zmm_milk_miro-miroyear = <ls_invoice>-supplierinvoicefiscalyear.

                    modify zmm_milk_miro from @wa_zmm_milk_miro.

                    COMMIT WORK.
                  ENDLOOP.

                ELSE.
                  "Error handling

                  CLEAR : wa_msg.
                  wa_msg-ebeln    = ls_milkcoll_1-lifnr.
                  wa_msg-msgty    = 'S'.
                  CONCATENATE 'Error while posting MIRO for Supplier' ls_milkcoll_1-lifnr
                  '/' ls_milkcoll_1-sloc
                  INTO wa_msg-msg SEPARATED BY ''.
                  APPEND wa_msg TO it_msg.
                  CLEAR wa_msg.

                ENDIF.
              ENDLOOP.
            ENDIF.

            IF ls_commit_failed IS NOT INITIAL.
              LOOP AT ls_commit_reported-supplierinvoice ASSIGNING <ls_invoice>.
                "Error handling

                lo_message = <ls_invoice>-%msg.
                CLEAR lv_result2.
                lv_result2 = lo_message->get_text( ).
                "Error handling
                CLEAR : wa_msg.
                wa_msg-ebeln    = ls_milkcoll_1-lifnr.
                wa_msg-msgty    = 'E'.
                wa_msg-msg      = lv_result2.
                APPEND wa_msg TO it_msg.
                CLEAR wa_msg.

              ENDLOOP.
            ENDIF.
          ENDIF.

        ENDLOOP.

        LOOP AT it_msg INTO wa_msg.

          CONCATENATE wa_msg-ebeln wa_msg-msg
          INTO lv_msg SEPARATED BY ' : '.



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

        IF lt_milkcoll[] IS INITIAL.

          lv_msg = 'No Data Found'.

          l_free_text = cl_bali_free_text_setter=>create( severity =
                              if_bali_constants=>c_severity_warning
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDIF.

      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
    ENDTRY.



  ENDMETHOD.
ENDCLASS.
