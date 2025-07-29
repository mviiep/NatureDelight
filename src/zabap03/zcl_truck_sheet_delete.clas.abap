CLASS zcl_truck_sheet_delete DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TRUCK_SHEET_DELETE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
  IF io_request->is_data_requested( ).

    DATA: lt_response TYPE TABLE OF ZCE_TRUCK_SHEET_DELETE,
            ls_response TYPE ZCE_TRUCK_SHEET_DELETE.
*
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.
  DATA(lr_truck_sheet_no)  =  VALUE  #( lt_filter_cond[ name   = 'TRUCKSHEET_NO' ]-range OPTIONAL ).
  DATA(lv_truck_sheet_no)  = VALUE ebeln( lr_truck_sheet_no[ 1 ]-low OPTIONAL ).


*        update ZSDT_TRUCK_PRINT set pdf_attach = ''
*        WHERE trucksheet_no = @lv_truck_sheet_no.
*        commit WORK.

   ls_response-trucksheet_no = lv_truck_sheet_no.
   APPEND ls_response TO lt_response.
*
  io_response->set_data( lt_response ).
  io_response->set_total_number_of_records( lines( lt_response ) ).


  ENDIF.
  ENDMETHOD.
ENDCLASS.
