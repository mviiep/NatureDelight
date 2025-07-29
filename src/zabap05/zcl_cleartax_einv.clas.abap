CLASS zcl_cleartax_einv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CLEARTAX_EINV IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entiry) = io_request->get_entity_id( ).
    IF io_request->is_data_requested( ).
      DATA: lt_response   TYPE TABLE OF zce_cleartax_einv,
            lS_response   TYPE zce_cleartax_einv,
            lt_response_1 TYPE TABLE OF zce_cleartax_eway,
            lS_response_1 TYPE zce_cleartax_eway,
            r_vbeln       TYPE RANGE OF i_billingdocumentbasic-BillingDocument,
            s_vbeln       LIKE LINE OF r_vbeln.

      DATA : obj_data     TYPE REF TO zcl_cleartax_einvvoice,
             obj_data_1   TYPE REF TO zcl_cleartax_eWAYBILL,
             ls_res       TYPE string,
             lv_status(1) TYPE c.

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option). "#EC NO_HANDLER
      ENDTRY.

      DATA(lr_vbeln)  =  VALUE #( lt_filter_cond[ name   = 'BILLINGDOCUMENT' ]-range OPTIONAL ).

*      DATA(lr_fkdat)  =  VALUE #( lt_filter_cond[ name   = 'BILLINGDOCUMENTDATE' ]-range OPTIONAL ).
*      DATA(lr_kunag)  =  VALUE #( lt_filter_cond[ name   = 'KUNAG' ]-range OPTIONAL ).
*      DATA(lr_FKART)  =  VALUE #( lt_filter_cond[ name   = 'FKART' ]-range OPTIONAL ).
*      DATA(lr_VTWEG)  =  VALUE #( lt_filter_cond[ name   = 'VTWEG' ]-range OPTIONAL ).

      CLEAR r_vbeln[].
      IF lr_vbeln[] IS NOT INITIAL.
        LOOP AT lr_vbeln INTO DATA(ls_vbeln).
          s_vbeln-sign = lS_VBELN-sign.
          s_vbeln-option = lS_VBELN-option.
          s_vbeln-low = |{ ls_vbeln-low ALPHA = IN }|.
          s_vbeln-high = |{ ls_vbeln-high ALPHA = IN }|.
          APPEND s_vbeln TO r_vbeln.
          CLEAR s_vbeln.
        ENDLOOP.
      ENDIF.

      CASE lv_entiry.

        WHEN 'ZCE_CLEARTAX_EINV'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT BillingDocument, BillingDocumentType, SDDocumentCategory,
                   BillingDocumentCategory, DistributionChannel, BillingDocumentDate,
                   SoldToParty
                    FROM I_BillingDocument
                WHERE BillingDocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @DATA(lt_bill) UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO DATA(ls_bill).

              CREATE OBJECT obj_data.
              obj_data->generate_irn(
                    EXPORTING im_vbeln     = ls_bill-BillingDocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              AND   method = 'GENERATE_IRN'
              INTO TABLE @DATA(lt_log).
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.


          ENDIF.


          IF lt_bill[] IS NOT INITIAL.
            SELECT * FROM zsdt_invrefnum FOR ALL ENTRIES IN @lt_bill
            WHERE docno = @lt_bill-BillingDocument
            INTO TABLE @DATA(lt_irn).
            IF lt_irn[] IS NOT INITIAL.
              SORT lt_irn BY docno ASCENDING version DESCENDING.
            ENDIF.

            LOOP AT lt_bill INTO ls_bill.
              ls_response-BillingDocument      = ls_bill-BillingDocument.
              ls_response-BillingDocumentDate  = ls_bill-BillingDocumentDate.
              ls_response-BillingDocumentType  = ls_bill-BillingDocumentType.
              ls_response-vtweg    = ls_bill-DistributionChannel.
              ls_response-kunag    = ls_bill-SoldToParty.

              READ TABLE lt_irn INTO DATA(Ls_irn) WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
              IF sy-subrc = 0.
                ls_response-version   = ls_irn-version.
                ls_response-irn       = ls_irn-irn.
                ls_response-irnstatus = ls_irn-irnstatus.
              ENDIF.

              READ TABLE lt_log INTO DATA(ls_log) WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
              IF sy-subrc = 0.
                ls_response-message   = ls_log-message.
              ENDIF.


              APPEND ls_response TO lt_response.
              CLEAR ls_response.
            ENDLOOP.
          ENDIF.

          io_response->set_total_number_of_records( lines( lt_response ) ).
          io_response->set_data( lt_response ).


        WHEN 'ZCE_CLEARTAX_EINV_CANC'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT BillingDocument, BillingDocumentType, SDDocumentCategory,
                   BillingDocumentCategory, DistributionChannel, BillingDocumentDate,
                   SoldToParty
                    FROM I_BillingDocument
                WHERE BillingDocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         AND   BillingDocumentIsCancelled = 'X'
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data.
              obj_data->CANCEL_irn(
                    EXPORTING im_vbeln     = ls_bill-BillingDocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              AND   method = 'CANCEL_IRN'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zsdt_invrefnum FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              INTO TABLE @lt_irn.
              IF lt_irn[] IS NOT INITIAL.
                SORT lt_irn BY docno ASCENDING version DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response-BillingDocument      = ls_bill-BillingDocument.
                ls_response-BillingDocumentDate  = ls_bill-BillingDocumentDate.
                ls_response-BillingDocumentType  = ls_bill-BillingDocumentType.
                ls_response-vtweg    = ls_bill-DistributionChannel.
                ls_response-kunag    = ls_bill-SoldToParty.

                READ TABLE lt_irn INTO Ls_irn WITH KEY docno = ls_bill-BillingDocument ."BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response-version   = ls_irn-version.
                  ls_response-irn       = ls_irn-irn.
                  ls_response-irnstatus = ls_irn-irnstatus.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-BillingDocument ."BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response-message   = ls_log-message.
                ENDIF.


                APPEND ls_response TO lt_response.
                CLEAR ls_response.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response ) ).
            io_response->set_data( lt_response ).


          ENDIF.

        WHEN 'ZCE_CLEARTAX_EWAY'.

          DATA(lr_gstin)  =  VALUE #( lt_filter_cond[ name   = 'TRANS_GSTIN' ]-range OPTIONAL ).
          DATA(lr_name)  =  VALUE #( lt_filter_cond[ name   = 'TRANS_NAME' ]-range OPTIONAL ).
          DATA(lr_Distance)  =  VALUE #( lt_filter_cond[ name   = 'DISTANCE' ]-range OPTIONAL ).

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT BillingDocument, BillingDocumentType, SDDocumentCategory,
                   BillingDocumentCategory, DistributionChannel, BillingDocumentDate,
                   SoldToParty
                    FROM I_BillingDocument
                WHERE BillingDocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            DATA : lv_gstin(18) TYPE c,
                   lv_name      TYPE zchar200,
                   lv_dist      TYPE znumc10.

            IF lr_gstin[] IS NOT INITIAL.
              READ TABLE lr_gstin INTO DATA(lS_gstin) INDEX 1.
              lv_gstin = lS_gstin-low.
            ENDIF.

            IF lr_name[] IS NOT INITIAL.
              READ TABLE lr_name INTO DATA(lS_name) INDEX 1.
              LV_name = lS_name-low.
            ENDIF.

            IF lr_Distance[] IS NOT INITIAL.
              READ TABLE lr_Distance INTO DATA(lS_Distance) INDEX 1.
              lv_dist = lS_Distance-low.
            ENDIF.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data_1.
              obj_data_1->generate_EWAY(
                    EXPORTING im_vbeln     = ls_bill-BillingDocument
                              im_gstin     = lv_gstin
                              im_name      = lv_name
                              im_dist      = lv_dist
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.


            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              AND   method = 'GENERATE_EWAY'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zsdt_ewaybill FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              INTO TABLE @DATA(lt_eway).
              IF lt_irn[] IS NOT INITIAL.
                SORT lt_eway BY docno ASCENDING createdon DESCENDING createdat DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response_1-BillingDocument      = ls_bill-BillingDocument.
                ls_response_1-BillingDocumentDate  = ls_bill-BillingDocumentDate.
                ls_response_1-BillingDocumentType  = ls_bill-BillingDocumentType.
                ls_response_1-vtweg    = ls_bill-DistributionChannel.
                ls_response_1-kunag    = ls_bill-SoldToParty.

                READ TABLE lt_eway INTO DATA(Ls_eway) WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-ebillno   = Ls_eway-ebillno.
                  ls_response_1-status    = Ls_eway-status.
                  ls_response_1-egen_dat  = Ls_eway-egen_dat.
                  ls_response_1-vdfmdate  = Ls_eway-vdfmdate.
                  ls_response_1-vdfmtime  = Ls_eway-vdfmtime.
                  ls_response_1-vdtodate  = Ls_eway-vdtodate.
                  ls_response_1-vdtotime  = Ls_eway-vdtotime.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-message   = ls_log-message.
                ENDIF.


                APPEND ls_response_1 TO lt_response_1.
                CLEAR ls_response_1.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response_1 ) ).
            io_response->set_data( lt_response_1 ).

          ENDIF.

        WHEN 'ZCE_CLEARTAX_EWAY_CANC'.

          IF r_vbeln[] IS NOT INITIAL.
*      or lr_fkdat[] is NOT INITIAL.

            SELECT BillingDocument, BillingDocumentType, SDDocumentCategory,
                   BillingDocumentCategory, DistributionChannel, BillingDocumentDate,
                   SoldToParty
                    FROM I_BillingDocument
                WHERE BillingDocument     IN @r_vbeln "lr_vbeln
*         AND   BillingDocumentDate in @lr_fkdat
*         and   SoldToParty         in @lr_kunag
*         and   BillingDocumentType eq 'F2' "in @lr_fkart
*         AND   BillingDocumentIsCancelled = 'X'
*         and   DistributionChannel in @lr_vtweg
                INTO TABLE @lt_bill UP TO @lv_top ROWS.

            LOOP AT lt_bill INTO ls_bill.

              CREATE OBJECT obj_data_1.
              obj_data_1->cancel_eway(
                    EXPORTING im_vbeln     = ls_bill-BillingDocument
                    IMPORTING ex_response  = ls_res
                              ex_status    = lv_status ).
            ENDLOOP.


            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM ztsd_ei_log FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              AND   method = 'CANCEL_EWAY'
              INTO TABLE @lt_log.
              IF lt_log[] IS NOT INITIAL.
                SORT lt_log BY docno ASCENDING erdat DESCENDING uzeit DESCENDING.
              ENDIF.
            ENDIF.

            IF lt_bill[] IS NOT INITIAL.
              SELECT * FROM zsdt_ewaybill FOR ALL ENTRIES IN @lt_bill
              WHERE docno = @lt_bill-BillingDocument
              INTO TABLE @lt_eway.
              IF lt_irn[] IS NOT INITIAL.
                SORT lt_eway BY docno ASCENDING createdon DESCENDING createdat DESCENDING.
              ENDIF.

              LOOP AT lt_bill INTO ls_bill.
                ls_response_1-BillingDocument      = ls_bill-BillingDocument.
                ls_response_1-BillingDocumentDate  = ls_bill-BillingDocumentDate.
                ls_response_1-BillingDocumentType  = ls_bill-BillingDocumentType.
                ls_response_1-vtweg    = ls_bill-DistributionChannel.
                ls_response_1-kunag    = ls_bill-SoldToParty.

                READ TABLE lt_eway INTO Ls_eway WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-ebillno   = Ls_eway-ebillno.
                  ls_response_1-status    = Ls_eway-status.
                  ls_response_1-egen_dat  = Ls_eway-egen_dat.
                  ls_response_1-vdfmdate  = Ls_eway-vdfmdate.
                  ls_response_1-vdfmtime  = Ls_eway-vdfmtime.
                  ls_response_1-vdtodate  = Ls_eway-vdtodate.
                  ls_response_1-vdtotime  = Ls_eway-vdtotime.
                ENDIF.

                READ TABLE lt_log INTO ls_log WITH KEY docno = ls_bill-BillingDocument." BINARY SEARCH.
                IF sy-subrc = 0.
                  ls_response_1-message   = ls_log-message.
                ENDIF.


                APPEND ls_response_1 TO lt_response_1.
                CLEAR ls_response_1.
              ENDLOOP.
            ENDIF.

            io_response->set_total_number_of_records( lines( lt_response_1 ) ).
            io_response->set_data( lt_response_1 ).



          ENDIF.

      ENDCASE.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
