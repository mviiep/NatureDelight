CLASS zcl_gate_entry_print DEFINITION
  PUBLIC
FINAL
CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATE_ENTRY_PRINT IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    try.
      "Initialize Template Store Client
      data(lo_store) = new ZCL_FP_TMPL_STORE_CLIENT(
        "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
        iv_name = 'AdobeFormService'
        "name of communication arrangement with scenario SAP_COM_0276
        iv_service_instance_name = 'ZADSRTEMPLATE'
      ).
      out->write( 'Template Store Client initialized' ).
      "Initialize class with service definition
      data(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_TRUCKSHEET_PRINT' ).
      out->write( 'Dataservice initialized' ).

      "Get initial select keys for service
      data(lt_keys)     = lo_fdp_util->get_keys( ).
*        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*            IF  <fs_keys>-name = 'CUSTOMER'.
*              <fs_keys>-value = '0001000011'.
*            ELSEIF <fs_keys>-name = 'FR_DATE'.
*              <fs_keys>-value = '20240201'.
*               ELSEIF <fs_keys>-name = 'TO_DATE'.
*              <fs_keys>-value = '20240222'.
*            ENDIF.
*
*          ENDLOOP.
      lt_keys[ name = 'TRUCKSHEET_NO' ]-value = '1000000137'.
      data(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
      out->write( 'Service data retrieved' ).

      data(ls_template) = lo_store->get_template_by_name(
        iv_get_binary     = abap_true
        iv_form_name      = 'TRUCK_SHEET' "<= form object in template store
        iv_template_name  = 'TRUCK_SHEET' "<= template (in form object) that should be used
      ).

      out->write( 'Form Template retrieved' ).

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
        cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data      = lv_xml
                                          iv_xdp_layout    = ls_template-xdp_template
                                          iv_locale        = 'en_US'
*                                          is_options       = ls_options
                                IMPORTING ev_pdf           = data(ev_pdf)
                                          ev_pages         = data(ev_pages)
                                          ev_trace_string  = data(ev_trace_string)
                                          ).
      out->write( 'Output was generated' ).

*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Gate Entry'
*      ).

      out->write( 'Output was sent to print queue' ).
    catch cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util .
      out->write( 'Exception occurred.' ).
    endtry.
    out->write( 'Finished processing.' ).
  ENDMETHOD.
ENDCLASS.
