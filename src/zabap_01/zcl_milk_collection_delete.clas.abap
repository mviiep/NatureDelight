CLASS zcl_milk_collection_delete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MILK_COLLECTION_DELETE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF ZCE_MILK_COLLECTION_DELETE,
            ls_response TYPE ZCE_MILK_COLLECTION_DELETE.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.
      DATA(lr_miro_no)  =  VALUE  #( lt_filter_cond[ name   = 'MIRODOC' ]-range OPTIONAL ).
      DATA(lr_miro_year)  =  VALUE  #( lt_filter_cond[ name   = 'MIRO_YEAR' ]-range OPTIONAL ).
      DATA(lv_miro_year)  = VALUE gjahr( lr_miro_year[ 1 ]-low OPTIONAL ).
      DATA(lv_miro_no)  = VALUE re_belnr( lr_miro_no[ 1 ]-low OPTIONAL ).


*        update ZMM_MILK_MIRO set pdf_attach = ''
*        WHERE mirodoc = @lv_miro_no
*        AND   miroyear = @lv_miro_year.
*        commit WORK.

        ls_response-mirodoc = lv_miro_no.
        ls_response-miro_year = lv_miro_year.
        APPEND ls_response TO lt_response.
        io_response->set_total_number_of_records( lines( lt_response ) ).
        io_response->set_data( lt_response ).

      ENDIF.

  ENDMETHOD.
ENDCLASS.
