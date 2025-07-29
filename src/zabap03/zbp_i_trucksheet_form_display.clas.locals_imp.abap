CLASS lhc_zi_trucksheet_form_display DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_trucksheet_form_display RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_trucksheet_form_display RESULT result.

    METHODS print_form FOR MODIFY
      IMPORTING keys FOR ACTION zi_trucksheet_form_display~print_form RESULT result.

ENDCLASS.

CLASS lhc_zi_trucksheet_form_display IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print_form.

   READ ENTITIES OF zi_trucksheet_form_display  IN LOCAL MODE
           ENTITY zi_trucksheet_form_display
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).
    LOOP AT lt_result INTO DATA(lw_result).


*      try.
*      "Initialize Template Store Client
*      data(lo_store) = new ZCL_FP_TMPL_STORE_CLIENT(
*        "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
*        iv_name = 'AdobeFormService'
*        "name of communication arrangement with scenario SAP_COM_0276
*        iv_service_instance_name = 'ZADSRTEMPLATE'
*      ).
*
*      "Initialize class with service definition
*      data(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_TRUCKSHEET_PRINT' ).
*
*
*      "Get initial select keys for service
*      data(lt_keys)     = lo_fdp_util->get_keys( ).
*        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*            IF  <fs_keys>-name = 'TRUCKSHEET_NO'.
*              <fs_keys>-value = lw_result-TrucksheetNo.
*
*            ENDIF.
*
*          ENDLOOP.
**      lt_keys[ name = 'TRUCKSHEET_NO' ]-value = '1000000014'.
*      data(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*
*
*      data(ls_template) = lo_store->get_template_by_name(
*        iv_get_binary     = abap_true
*        iv_form_name      = 'TRUCK_SHEET' "<= form object in template store
*        iv_template_name  = 'TRUCK_SHEET' "<= template (in form object) that should be used
*      ).
*
*
*
*      cl_fp_ads_util=>render_4_pq(
*        EXPORTING
*          iv_locale       = 'en_US'
*          iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
*          iv_xml_data     = lv_xml
*          iv_xdp_layout   = ls_template-xdp_template
*          is_options      = value #(
*            trace_level = 4 "Use 0 in production environment
*          )
*        IMPORTING
*          ev_trace_string = data(lv_trace)
*          ev_pdl          = data(lv_pdf)
*      ).
*   cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'TruckSheet'
*      ).
*
*
*    catch cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util .
*
*    endtry.




      DATA : update_lines TYPE TABLE FOR UPDATE zi_trucksheet_form_display,
             update_line  TYPE STRUCTURE FOR UPDATE zi_trucksheet_form_display.

      update_line-%tky                   = lw_result-%tky.
      update_line-PdfData                 = 'A'.
*      UPDATE_line-Mimetype                = 'APPLICATION/PDF'.
*      UPDATE_line-Filename                = 'Trucksheet.pdf'.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF zi_trucksheet_form_display IN LOCAL MODE
       ENTITY zi_trucksheet_form_display
         UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
         FIELDS ( PdfData )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

      READ ENTITIES OF  zi_trucksheet_form_display  IN LOCAL MODE  ENTITY zi_trucksheet_form_display
  ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).

        append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-success
                    text = 'PDF Generated!' )
                     ) to reported-zi_trucksheet_form_display.
    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_trucksheet_form_display DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.





    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_trucksheet_form_display IMPLEMENTATION.

  METHOD save_modified.
    data : lt_trucksheet TYPE TABLE of zsdt_truckshet_h.
*  if update-zi_trucksheet_form_display is NOT initial.
*   lt_trucksheet = CORRESPONDING #( update-zi_trucksheet_form_display MAPPING
*  trucksheet_no = TrucksheetNo
*   pdf_data     = PdfData
*   mimetype     = Mimetype
*   filename     = Filename
*    ).
*
*     LOOP AT lt_trucksheet INTO data(lw_trucksheet).
*
*      update zsdt_truckshet_h   set pdf_data = @lw_trucksheet-pdf_data,
*      filename =  @lw_trucksheet-filename, mimetype = @lw_trucksheet-mimetype  WHERE
*       trucksheet_no = @lw_trucksheet-trucksheet_no  .
*     ENDLOOP.
*      endif.

LOOP AT update-zi_trucksheet_form_display INTO DATA(lw_trucksheet).


        DATA(new) = NEW zcl_bg_trucksheet_form( iv_trucksheet_no =
        lw_trucksheet-TrucksheetNo ).

        DATA background_process TYPE REF TO if_bgmc_process_single_op.

        TRY.

        background_process = cl_bgmc_process_factory=>get_default( )->create( ).

*         background_process->set_operation( new ).

        background_process->set_operation_tx_uncontrolled( new ).

        background_process->save_for_execution( ).

        CATCH cx_bgmc INTO DATA(exception).

        "handle exception

        ENDTRY.

ENDLOOP.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
