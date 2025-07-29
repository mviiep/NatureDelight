CLASS zcl_milkratecard_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MILKRATECARD_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF ZCE_MILKRATECARD.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

      DATA(lr_Plant)  =  VALUE #( lt_filter_cond[ name   = 'PLANT' ]-range OPTIONAL ).
      DATA(lr_Sloc)   =  VALUE #( lt_filter_cond[ name   = 'SLOC' ]-range OPTIONAL ).
      DATA(lr_effdate) =  VALUE #( lt_filter_cond[ name   = 'EFFDATE' ]-range OPTIONAL ).

****Data retrival and business logics goes here*****

      select effdate, plant, Sloc, lgobe from zmm_milkratecard
      WHERE plant in @lr_plant
      AND   Sloc  in @lr_sloc
      and   effdate in @lr_effdate
      into TABLE @data(lt_data).

      IF lv_top < 0.
        lv_top = 1.
      ENDIF.

      if lt_data[] is NOT INITIAL.
      sort lt_data by effdate plant Sloc.
      delete ADJACENT DUPLICATES FROM lt_data COMPARING effdate plant Sloc.

      data(lv_to) = lv_skip + lv_top.
      lv_skip = lv_skip + 1.

      loop at lt_data into data(ls_data)  FROM lv_skip to lv_to.
       append ls_data to lt_response.
       clear ls_data.
      endloop.

*      if lv_skip gt 0.
*       lv_skip = lv_skip + 1.
*       delete lt_response FROM lv_skip to lv_top.
*      endif.

      endif.


      io_response->set_total_number_of_records( lines( lt_data ) ).
      io_response->set_data( lt_response ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
