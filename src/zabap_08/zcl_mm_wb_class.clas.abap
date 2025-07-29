CLASS zcl_mm_wb_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_WB_CLASS IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA(lv_entiry) = io_request->get_entity_id( ).
    IF io_request->is_data_requested( ).
      DATA(lv_top)  = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip) = io_request->get_paging( )->get_offset( ).
      DATA obj_data TYPE REF TO zcl_mm_wb_data_class.
      IF  obj_data IS NOT BOUND.
        CREATE OBJECT obj_data.
      ENDIF.
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.


      TRY.
          DATA(lt_input) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range.
          "handle exception
      ENDTRY.
      IF lv_entiry EQ 'ZCE_CDS_WB'.
        IF lt_input IS NOT INITIAL.
          DATA(lr_gpno) = lt_input[ name = 'GP_NO' ]-range.
          DATA(lv_gpno)  = VALUE Zchar10( lr_gpno[ 1 ]-low OPTIONAL ).

          obj_data->me_get_data(
            EXPORTING
              iv_gp_no = lv_gpno
            IMPORTING
              et_data  = DATA(lt_data)
          ).

          io_response->set_data( lt_data ).
          IF io_request->is_total_numb_of_rec_requested(  ).
            io_response->set_total_number_of_records( lines( lt_data ) ).
          ENDIF.
        ENDIF.


      ELSEIF lv_entiry EQ 'ZCE_CDS_GP_SH'.
        obj_data->me_get_data_gp(
           IMPORTING
             et_data  = DATA(lt_gpdata)
         ).

      data : it_data type STANDARD TABLE OF ZCE_CDS_GP_SH.

      data(lv_to) = lv_skip + lv_top.
      lv_skip = lv_skip + 1.

        loop at lt_gpdata INTO data(ls_gpdata) FROM lv_skip to lv_to.
          append ls_gpdata to it_data.
          clear ls_gpdata.
        endloop.

        io_response->set_data( it_data ).
        IF io_request->is_total_numb_of_rec_requested(  ).
          io_response->set_total_number_of_records( lines( lt_gpdata ) ).
        ENDIF.



      ELSEIF lv_entiry EQ 'ZCE_WEIGHT'.

        TRY.
*            ------------Start: Call API ------------
            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                     comm_scenario  = 'ZCSCEN_WEIGHT'
                                     service_id     = 'ZOS_WEIGHT_REST'
                                   ).

            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
            DATA(lo_request) = lo_http_client->get_http_request( ).


            DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>get ).
            DATA(lv_xml_results) = lo_response->get_text( ).
*            ------------End: Call API ------------



            TYPES: BEGIN OF ty_data,
                     weight TYPE string,
                   END OF ty_data.
            DATA: it_weight TYPE TABLE OF ty_data.
            it_weight = VALUE #( ( weight = lv_xml_results ) ) .

            io_response->set_data( it_weight ).
          CATCH cx_root INTO DATA(lx_exception).
        ENDTRY.

      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
