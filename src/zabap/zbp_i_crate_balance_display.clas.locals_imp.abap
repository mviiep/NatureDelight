CLASS lhc_zi_crate_balance_display DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_crate_balance_display RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_crate_balance_display RESULT result.

    METHODS print_form FOR MODIFY
      IMPORTING keys FOR ACTION zi_crate_balance_display~print_form RESULT result.

ENDCLASS.

CLASS lhc_zi_crate_balance_display IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print_form.

    READ ENTITIES OF zi_crate_balance_display  IN LOCAL MODE
           ENTITY zi_crate_balance_display
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).
    DATA(lt_keys1) = keys.
    READ  TABLE lt_keys1 INTO DATA(lw_keys) INDEX 1.

    DATA(lv_fr_date)  = lw_keys-%param-from_date .
    DATA(lv_to_date)  = lw_keys-%param-to_date.


    LOOP AT lt_result INTO DATA(lw_result).

*      TRY.
*          "Initialize Template Store Client
*          DATA(lo_store) = NEW zcl_fp_tmpl_store_client(
*            "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
*            iv_name = 'AdobeFormService'
*            "name of communication arrangement with scenario SAP_COM_0276
*            iv_service_instance_name = 'ZADSRTEMPLATE'
*          ).
**      out->write( 'Template Store Client initialized' ).
*          "Initialize class with service definition
*          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_CRATE_BALANCE_FORM' ).
**      out->write( 'Dataservice initialized' ).
*
*          "Get initial select keys for service
*          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*          LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*            IF  <fs_keys>-name = 'CUSTOMER'.
*              <fs_keys>-value = lw_result-customer.
*            ELSEIF <fs_keys>-name = 'FR_DATE'.
*              <fs_keys>-value = lv_fr_date.
*            ELSEIF <fs_keys>-name = 'TO_DATE'.
*              <fs_keys>-value = lv_to_date.
*            ENDIF.
*
*          ENDLOOP.
*
*          DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
**      out->write( 'Service data retrieved' ).
*
*          DATA(ls_template) = lo_store->get_template_by_name(
*            iv_get_binary     = abap_true
*            iv_form_name      = 'CRATE_BALANCE' "<= form object in template store
*            iv_template_name  = 'CRATE_BALANCE' "<= template (in form object) that should be used
*          ).
*
**      out->write( 'Form Template retrieved' ).
*
*          cl_fp_ads_util=>render_4_pq(
*            EXPORTING
*              iv_locale       = 'en_US'
*              iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
*              iv_xml_data     = lv_xml
*              iv_xdp_layout   = ls_template-xdp_template
*              is_options      = VALUE #(
*                trace_level = 4 "Use 0 in production environment
*              )
*            IMPORTING
*              ev_trace_string = DATA(lv_trace)
*              ev_pdl          = DATA(lv_pdf)
*         ).
*
*          TRY.
*
*          ENDTRY.
*
*
*
**      out->write( 'Output was generated' ).
*
**      cl_print_queue_utils=>create_queue_item_by_data(
**          "Name of the print queue where result should be stored
**          iv_qname = 'DEFAULT'
**          iv_print_data = lv_pdf
**          iv_name_of_main_doc = 'Gate Entry'
**      ).
*
*
*
**      out->write( 'Output was sent to print queue' ).
*        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util.
**      out->write( 'Exception occurred.' ).
*      ENDTRY.

      DATA : update_lines TYPE TABLE FOR UPDATE zi_crate_balance_display,
             update_line  TYPE STRUCTURE FOR UPDATE zi_crate_balance_display.

      update_line-%tky                   = lw_result-%tky.
      update_line-pdf_data               = 'A'. "lv_pdf.
      update_line-fr_date                = lv_fr_date.
      update_line-to_date                = lv_to_date.
      update_line-customer1              = lw_result-customer.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF zi_crate_balance_display IN LOCAL MODE
       ENTITY zi_crate_balance_display
         UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
         FIELDS ( pdf_data fr_date to_date  customer1 )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

      READ ENTITIES OF  zi_crate_balance_display  IN LOCAL MODE  ENTITY zi_crate_balance_display
  ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).

    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-success
                    text = 'PDF Generated!' )
                     ) to reported-zi_crate_balance_display.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_crate_balance_display DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_crate_balance_display IMPLEMENTATION.

  METHOD save_modified.
  data : lt_crate_bal type TABLE of ztcrate_balalce.

*         if update-zi_crate_balance_display is NOT INITIAL.
*         lt_crate_bal = CORRESPONDING #( update-zi_crate_balance_display MAPPING
*         pdf_data = pdf_data
*         customer = customer1
*         ).
*
*         MODIFY ztcrate_balalce FROM TABLE @lt_crate_bal.
*         ENDIF.


  if update-zi_crate_balance_display is not initial.

      LOOP AT update-zi_crate_balance_display INTO DATA(LS_data).


        DATA(new) = NEW zcl_a5_bg_process_crate_bal( iv_customer = LS_data-Customer
                                                     iv_fr_date  = LS_data-fr_date
                                                     iv_to_date  = LS_data-to_date ).

        DATA background_process TYPE REF TO if_bgmc_process_single_op.

        TRY.

        background_process = cl_bgmc_process_factory=>get_default( )->create( ).

*         background_process->set_operation( new ).

        background_process->set_operation_tx_uncontrolled( new ).

        background_process->save_for_execution( ).

        CATCH cx_bgmc INTO DATA(exception).

        "handle exception

        ENDTRY.
      endloop.

  endif.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
