CLASS zcl_milk_collection_pdf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
    INTERFACES if_oo_adt_classrun.

    METHODS ZCL_MESSAGES.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MILK_COLLECTION_PDF IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.
    OUT->write( 'ERROR' ).
  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF zce_milk_collection_pdf,
            ls_response TYPE zce_milk_collection_pdf,
            exc TYPE REF TO cx_static_check.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).


          TRY.
              data(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
            CATCH cx_rap_query_filter_no_range.   "#EC CATCH_UNUSED
              "handle exception
          "ZCL_MESSAGES

          ENDTRY.

      DATA(lr_miro_no)  =  VALUE  #( lt_filter_cond[ name   = 'MIRODOC' ]-range OPTIONAL ).
      DATA(lr_miro_year)  =  VALUE  #( lt_filter_cond[ name   = 'MIRO_YEAR' ]-range OPTIONAL ).
      DATA(lv_miro_year)  = VALUE gjahr( lr_miro_year[ 1 ]-low OPTIONAL ).
      DATA(lv_miro_no)  = VALUE re_belnr( lr_miro_no[ 1 ]-low OPTIONAL ).




      TRY.
          "Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client(
            "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
            iv_name = 'AdobeFormService'
            "name of communication arrangement with scenario SAP_COM_0276
            iv_service_instance_name = 'ZADSRTEMPLATE'
          ).
*      out->write( 'Template Store Client initialized' ).
          "Initialize class with service definition
          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_MILK_COLLECTION_FORM' ).
*      out->write( 'Dataservice initialized' ).

          "Get initial select keys for service
          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
          LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
            IF  <fs_keys>-name = 'MIRODOC'.
              <fs_keys>-value = lv_miro_no.
            ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
              <fs_keys>-value = lv_miro_year.
            ENDIF.

          ENDLOOP.

          DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).

          DATA(ls_template) = lo_store->get_template_by_name(
            iv_get_binary     = abap_true
            iv_form_name      = 'MILK_COLLECTION' "<= form object in template store
            iv_template_name  = 'MILK_COLLECTION' "<= template (in form object) that should be used
          ).

*      out->write( 'Form Template retrieved' ).

          cl_fp_ads_util=>render_4_pq(
            EXPORTING
              iv_locale       = 'en_US'
              iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
              iv_xml_data     = lv_xml
              iv_xdp_layout   = ls_template-xdp_template
              is_options      = VALUE #(
                trace_level = 4 "Use 0 in production environment
              )
            IMPORTING
              ev_trace_string = DATA(lv_trace)
              ev_pdl          = DATA(lv_pdf)
         ).

*          TRY.
*
*          ENDTRY.

*      out->write( 'Output was generated' ).

*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Gate Entry'
*      ).



*      out->write( 'Output was sent to print queue' ).
      CATCH cx_fp_fdp_error INTO exc.
*      out->write( 'Exception occurred.' ).
       CATCH zcx_fp_tmpl_store_error INTO exc.
*      out->write( 'Exception occurred.' ).
       CATCH cx_fp_ads_util INTO exc.
*      out->write( 'Exception occurred.' ).
 ENDTRY.


      IF sy-subrc = 0.
        ls_response-mirodoc = lv_miro_no.
        ls_response-miro_year = lv_miro_year.
        ls_response-attachments  =  lv_pdf.
        APPEND ls_response TO lt_response.
        io_response->set_total_number_of_records( lines( lt_response ) ).
        io_response->set_data( lt_response ).
      ENDIF.

    ENDIF.
  ENDMETHOD.


  METHOD ZCL_MESSAGES.
   " MESSAGE 'No ranges provided in the filter' TYPE 'I'.
  ENDMETHOD.
ENDCLASS.
