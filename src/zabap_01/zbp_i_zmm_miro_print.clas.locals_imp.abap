CLASS lsc_zi_zmm_miro_print DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_zmm_miro_print IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_zmm_milkcoll        TYPE STANDARD TABLE OF zmm_milk_MIRO,
           ls_zmm_milkcoll        TYPE                   zmm_milk_MIRO,
           lt_zmm_milkcoll_x_control TYPE STANDARD TABLE OF zmm_milk_MIRO.

    IF update IS NOT INITIAL.
      CLEAR lt_zmm_milkcoll.
      LOOP AT update-miroprint INTO DATA(LS_MIRO).


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
*              <fs_keys>-value = LS_MIRO-mirodoc.
*            ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
*              <fs_keys>-value = LS_MIRO-miroyear.
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
*
**          lt_zmm_milkcoll = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
**          lt_zmm_milkcoll_x_control = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
**          MODIFY zmm_milkcoll FROM TABLE @lt_zmm_milkcoll.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_zmm_miro_print DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MiroPrint RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR MiroPrint RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION MiroPrint~print RESULT result.

ENDCLASS.

CLASS lhc_zi_zmm_miro_print IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD Print.

data :  update_lines   TYPE TABLE FOR UPDATE ZI_ZMM_MIRO_PRINT\\MiroPrint,
        update_line    TYPE STRUCTURE FOR UPDATE ZI_ZMM_MIRO_PRINT\\MiroPrint.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_miRO_PRINT IN LOCAL MODE
      ENTITY MiroPrint
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

    LOOP AT keys INTO DATA(key).
      IF line_exists( members[ MIRODOC = key-MIRODOC ] ).
        update_line-%tky                   = key-%tky.
        update_line-PdfAttach              = 'A'.
        APPEND update_line TO update_lines.
      ENDIF.
    ENDLOOP.

MODIFY ENTITIES OF zi_zmm_MIRO_PRINT IN LOCAL MODE
      ENTITY MiroPrint
        UPDATE
        FIELDS ( PdfAttach )
        WITH update_lines
      REPORTED reported
      FAILED failed
      MAPPED mapped.



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
*              <fs_keys>-value = member-mirodoc.
*            ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
*              <fs_keys>-value = member-miroyear.
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
*
*
*
*    MODIFY ENTITIES OF zi_zmm_miRO_PRINT IN LOCAL MODE
*            ENTITY MiroPrint
*              UPDATE
*                FIELDS ( PdfAttach )
*                WITH VALUE #(
*                              ( %tky = member-%tky
*                                PdfAttach = lv_PDF
*                                ) ).
*
*    READ ENTITIES OF  zi_zmm_miRO_PRINT IN LOCAL MODE  ENTITY MiroPrint
*    ALL FIELDS WITH CORRESPONDING #( MEMBERS ) RESULT DATA(lt_final).
*
*    result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
*     %param = lw_final  )  ).

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
