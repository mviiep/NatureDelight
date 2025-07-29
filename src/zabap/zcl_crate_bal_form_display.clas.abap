CLASS zcl_crate_bal_form_display DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CRATE_BAL_FORM_DISPLAY IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF ZCE_CRATE_BALANCE_FORM_DISPLAY,
            ls_response TYPE ZCE_CRATE_BALANCE_FORM_DISPLAY.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

      DATA(lr_customer)  =  VALUE  #( lt_filter_cond[ name   = 'CUSTOMER' ]-range OPTIONAL ).
  DATA(lv_customer)  = VALUE #( lr_customer[ 1 ]-low OPTIONAL ).

  DATA(lr_fr_date)  =  VALUE  #( lt_filter_cond[ name   = 'FR_DATE' ]-range OPTIONAL ).
  DATA(lv_fr_date)  = VALUE #( lr_customer[ 1 ]-low OPTIONAL ).

  DATA(lr_to_date)  =  VALUE  #( lt_filter_cond[ name   = 'TO_DATE' ]-range OPTIONAL ).
  DATA(lv_to_date)  = VALUE #( lr_customer[ 1 ]-low OPTIONAL ).

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
      data(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_CRATE_BALANCE_FORM' ).
*      out->write( 'Dataservice initialized' ).

      "Get initial select keys for service
      data(lt_keys)     = lo_fdp_util->get_keys( ).
        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      IF  <fs_keys>-name = 'CUSTOMER'.
        <fs_keys>-value = lv_customer.
      ELSEIF <fs_keys>-name = 'FR_DATE'.
        <fs_keys>-value = lv_fr_date.
      ELSEIF <fs_keys>-name = 'TO_DATE'.
        <fs_keys>-value = lv_to_date.
      ENDIF.

    ENDLOOP.
      data(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).

      data(ls_template) = lo_store->get_template_by_name(
        iv_get_binary     = abap_true
        iv_form_name      = 'CRATE_BALANCE' "<= form object in template store
        iv_template_name  = 'CRATE_BALANCE' "<= template (in form object) that should be used
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
        ls_response-Customer = lv_customer.
        ls_response-pdf_data  =  lv_pdf.
        ls_response-fr_date  =  lv_fr_date.
        ls_response-to_date  =  lv_to_date.
        APPEND ls_response TO lt_response.
        io_response->set_total_number_of_records( lines( lt_response ) ).
        io_response->set_data( lt_response ).
      ENDIF.

      ENDIF.
  ENDMETHOD.
ENDCLASS.
