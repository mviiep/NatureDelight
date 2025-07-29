CLASS lhc_zi_milk_coll_form_display DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_milk_coll_form_display RESULT result.
    METHODS print_form FOR MODIFY
      IMPORTING keys FOR ACTION zi_milk_coll_form_display~print_form RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_milk_coll_form_display RESULT result.
*    METHODS get_global_features FOR GLOBAL FEATURES
*      IMPORTING REQUEST requested_features FOR zi_milk_coll_form_display RESULT result.

ENDCLASS.

CLASS lhc_zi_milk_coll_form_display IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print_form.
    READ ENTITIES OF zi_milk_coll_form_display  IN LOCAL MODE
          ENTITY zi_milk_coll_form_display
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result).

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
*          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_MILK_COLLECTION_FORM' ).
**      out->write( 'Dataservice initialized' ).
*
*          "Get initial select keys for service
*          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
*          LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*            IF  <fs_keys>-name = 'MIRODOC'.
*              <fs_keys>-value = lw_result-mirodoc.
*            ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
*              <fs_keys>-value = lw_result-miroyear.
*            ENDIF.
*
*          ENDLOOP.
*
*          DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
**      out->write( 'Service data retrieved' ).
*
*          DATA(ls_template) = lo_store->get_template_by_name(
*            iv_get_binary     = abap_true
*            iv_form_name      = 'MILK_COLLECTION' "<= form object in template store
*            iv_template_name  = 'MILK_COLLECTION' "<= template (in form object) that should be used
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

*    DATA lt_milk_coll TYPE TABLE FOR UPDATE zi_milk_coll_form_display.
*     LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
*
*        APPEND VALUE #( %tky  = <fs_result>-%tky
*                       PDF = lv_pdf
*
*                       ) TO lt_milk_coll.
*
*    ENDLOOP.


*     MODIFY ENTITIES OF zi_milk_coll_form_display  IN LOCAL MODE
*    ENTITY zi_milk_coll_form_display UPDATE FIELDS ( PDF )
*    with lt_milk_coll.

*      MODIFY ENTITIES OF zi_milk_coll_form_display IN LOCAL MODE
*                      ENTITY zi_milk_coll_form_display
*                        UPDATE
*                         FIELDS ( pdf )
*                          WITH VALUE #(
*                                        ( %tky = lw_result-%tky
*                                          pdf = lv_pdf
*
*                                          ) ).

      DATA : update_lines TYPE TABLE FOR UPDATE zi_milk_coll_form_display,
             update_line  TYPE STRUCTURE FOR UPDATE zi_milk_coll_form_display.

      update_line-%tky                   = lw_result-%tky.
      update_line-pdf                 = 'A'. "lv_pdf.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF zi_milk_coll_form_display IN LOCAL MODE
       ENTITY zi_milk_coll_form_display
         UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
         FIELDS ( pdf )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

        READ ENTITIES OF  zi_milk_coll_form_display  IN LOCAL MODE  ENTITY zi_milk_coll_form_display
    ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

    result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
     %param = lw_final  )  ).


    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-success
                    text = 'PDF Generated!' )
                     ) to reported-zi_milk_coll_form_display.

    ENDLOOP.



  ENDMETHOD.

*  METHOD get_globa_features.
*
**  %features-%action-PRINT_PDF  = if_abap_behv=>fc-o-disabled.
*
*  ENDMETHOD.

  METHOD get_instance_features.
*  READ ENTITIES OF zi_milk_coll_form_display IN LOCAL MODE
*        ENTITY zi_milk_coll_form_display
*          ALL FIELDS WITH  CORRESPONDING #( keys )
*        RESULT DATA(members)
*        FAILED failed.
*
*    result = VALUE #(
*     FOR member IN members ( %key  = member-%key
*
*      %features-%action-print_form  =  if_abap_behv=>image-transactional )
*
*     ) .
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_milk_coll_form_display DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_milk_coll_form_display IMPLEMENTATION.

  METHOD save_modified.
  data : lt_milk_coll TYPE TABLE of zmm_milkcoll.
  if update-zi_milk_coll_form_display is not initial.
*   lt_milk_coll = CORRESPONDING #( update-zi_milk_coll_form_display MAPPING
*   mirodoc   = Mirodoc
*   miro_year = Miroyear
*   pdf_attach =  pdf
*    ).
*
*     LOOP AT lt_milk_coll INTO data(lw_milk_coll).
**      update zmm_milkcoll   set pdf_attach = @lw_milk_coll-pdf_attach WHERE
**       mirodoc = @lw_milk_coll-mirodoc AND miro_year = @lw_milk_coll-miro_year .
*
*      update zmm_milk_miro  set pdf_attach = @lw_milk_coll-pdf_attach WHERE
*       mirodoc = @lw_milk_coll-mirodoc AND miroyear = @lw_milk_coll-miro_year .
*     ENDLOOP.

      LOOP AT update-zi_milk_coll_form_display INTO DATA(LS_MIRO).


        DATA(new) = NEW zcl_a5_background_process( iv_mirodoc = LS_MIRO-Mirodoc
                                                   iv_miroyear = LS_MIRO-Miroyear ).

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
