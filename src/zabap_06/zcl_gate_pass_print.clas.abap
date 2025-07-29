CLASS zcl_gate_pass_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_GATE_PASS_PRINT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA : lt_gate_entry_table TYPE TABLE OF  zdt_gate_entry.
    DATA lt_gate_entry TYPE TABLE FOR UPDATE zi_gate_entry.


    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF zce_gate_entry,
            ls_response TYPE zce_gate_entry.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.




      DATA(lr_gate_entry)  =  VALUE  #( lt_filter_cond[ name   = 'GATEENTRYNO' ]-range OPTIONAL ).
      DATA(lr_transporter)   =  VALUE #( lt_filter_cond[ name   = 'ATTACHMENT' ]-range OPTIONAL ).
      READ  TABLE lr_gate_entry into data(lw_gate_entry) index 1.

      try.
      "Initialize Template Store Client
      data(lo_store) = new ZCL_FP_TMPL_STORE_CLIENT(
        "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
        iv_name = 'AdobeFormService'
        "name of communication arrangement with scenario SAP_COM_0276
        iv_service_instance_name = 'ZADSRTEMPLATE'
      ).
*      out->write( 'Template Store Client initialized' ).
      "Initialize class with service definition
      data(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_GATE_ENTRY_PRINT' ).
*      out->write( 'Dataservice initialized' ).

      "Get initial select keys for service
      data(lt_keys)     = lo_fdp_util->get_keys( ).
      lt_keys[ name = 'GATEENTRYNO' ]-value = lw_gate_entry-low.
      data(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).

      data(ls_template) = lo_store->get_template_by_name(
        iv_get_binary     = abap_true
        iv_form_name      = 'ZGATE_ENTRY' "<= form object in template store
        iv_template_name  = 'GATE_ENTRY' "<= template (in form object) that should be used
      ).

*      out->write( 'Form Template retrieved' ).

      cl_fp_ads_util=>render_4_pq(
        EXPORTING
          iv_locale       = 'en_US'
          iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
          iv_xml_data     = lv_xml
          iv_xdp_layout   = ls_template-xdp_template
          is_options      = value #(
            trace_level = 4 "Use 0 in production environment
          )
        IMPORTING
          ev_trace_string = data(lv_trace)
          ev_pdl          = data(lv_pdf)
     ).

 TRY.

ENDTRY.

*      out->write( 'Output was generated' ).

*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Gate Entry'
*      ).



*      out->write( 'Output was sent to print queue' ).
    catch cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util.
*      out->write( 'Exception occurred.' ).
    endtry.


      IF sy-subrc = 0.
        ls_response-gateentryno = lw_gate_entry-low.
        ls_response-attachment  =  lv_pdf.
        APPEND ls_response TO lt_response.
        io_response->set_total_number_of_records( lines( lt_response ) ).
        io_response->set_data( lt_response ).
      ENDIF.

    ENDIF.


  ENDMETHOD.
ENDCLASS.
