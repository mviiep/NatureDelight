CLASS zcl_crate_bal_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CRATE_BAL_FORM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

      DATA: lt_response TYPE TABLE OF ZCE_CRATE_BAL_FORM_HEADER,
            ls_response TYPE ZCE_CRATE_BAL_FORM_HEADER,
            lt_response_i TYPE TABLE OF ZCE_CRATE_BAL_FORM_item,
            ls_response_i TYPE ZCE_CRATE_BAL_FORM_item.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

*      DATA(lr_date)    =  VALUE #( lt_filter_cond[ name   = 'P_DATE' ]-range OPTIONAL ).
      DATA(lr_cust)    =  VALUE #( lt_filter_cond[ name   = 'CUSTOMER' ]-range OPTIONAL ).
      DATA(fr_date)    =  VALUE #( lt_filter_cond[ name   = 'FR_DATE' ]-range OPTIONAL ).
      DATA(to_date)    =  VALUE #( lt_filter_cond[ name   = 'TO_DATE' ]-range OPTIONAL ).

      data: lt_cust1 type RANGE OF i_customer-customer,
            lr_date  TYPE RANGE OF datum,
            lrs_Date  like LINE OF lr_Date.

       lrs_Date-sign = 'I'.
       lrs_Date-option = 'BT'.
       if fr_date[] is NOT INITIAL.
        READ TABLE fr_date into data(frs_date) INDEX 1.
        lrs_Date-low = frs_date-low.
       endif.
       if to_date[] is NOT INITIAL.
        READ TABLE to_date into data(tos_date) INDEX 1.
        lrs_Date-high = tos_date-low.
       else.
        lrs_Date-high = frs_date-low.
       endif.
       append lrs_Date to lr_Date.
       clear lrs_Date.


        lt_cust1 = VALUE #( FOR ls_cust
                           IN lr_cust
                           ( sign = ls_cust-sign
                             option = ls_cust-option
                             low = |{ ls_cust-low ALPHA = IN }|
                             high = |{ ls_cust-high ALPHA = IN }| )
                         ).


     if lr_date[] is NOT INITIAL.
      READ TABLE lr_date into data(ls_date) INDEX 1.
     endif.

     data : lv_date type datum.
      if ls_date-high is NOT INITIAL.
        lv_date = ls_date-high.
      else.
        lv_date = ls_date-low.
      endif.

    CASE io_request->get_entity_id( ).
      WHEN 'ZCE_CRATE_BAL_FORM_HEADER'.

    IF io_request->is_data_requested( ).

      select single * from ZI_DateAddIncrement( p_IncrementDate = @lv_date,
                                                p_IncrementAmt = '1',
                                                p_IncrementType = 'D' )
      into @data(lv_datecal).

       lv_date = lv_datecal-IncrementedDate.

      select customer from i_customer
      WHERE customer in @lt_cust1
      into TABLE @data(lt_cus).

      select * from ZCDS_CRATE_BALANCE( FROM_DATE = @ls_date-low )
      WHERE Plant eq '1101'
      AND   Material eq '000000000080000001' "'000000000000000029' "
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_coll).

      loop at lt_cus INTO data(ls_cus).
      READ TABLE lt_coll INTO data(ls_coll) WITH KEY customer = ls_cus-customer.
     if sy-subrc ne 0.

      clear ls_coll.
      ls_coll-plant = '1101'.
      ls_coll-material = '000000000080000001'. "'000000000080000001'.
      ls_coll-customer = ls_cus-customer.

      select SINGLE CustomerName from i_customer
      where customer = @ls_cus-customer
      INTO @ls_coll-BPCustomerName.

      append ls_coll to lt_coll.
      clear ls_coll.
     endif.
      endloop.

      select customer, MatlWrhsStkQtyInMatlBaseUnit
       from ZCDS_CRATE_BALANCE( FROM_DATE = @lv_date )
      WHERE Plant eq '1101'
      AND   Material eq '000000000080000001' "'000000000000000029' "
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_coll1).

      loop at lt_coll INTO ls_coll.

       ls_response-Customer         = ls_coll-Customer.
       ls_response-MaterialBaseUnit = ls_coll-MaterialBaseUnit.
       ls_response-name1            = ls_coll-BPCustomerName.
       ls_response-fr_date          = ls_date-low.
          if ls_date-high is NOT INITIAL.
            ls_response-to_date     = ls_date-high.
           else.
            ls_response-to_date     = ls_date-low.
          endif.

       ls_response-OpenQty = ls_coll-MatlWrhsStkQtyInMatlBaseUnit.

       READ TABLE lt_coll1 INTO data(ls_coll1) WITH KEY customer = ls_coll-Customer.
       if sy-subrc = 0.
        ls_response-closeQty = ls_coll1-MatlWrhsStkQtyInMatlBaseUnit.
       endif.

       append ls_response to lt_response.
       clear ls_response.
     endloop.

      io_response->set_total_number_of_records( lines( lt_response ) ).
      io_response->set_data( lt_response ).
    ENDIF.

      WHEN 'ZCE_CRATE_BAL_FORM_ITEM'.

      Data : lv_opbal type menge_d.

    IF io_request->is_data_requested( ).

      select * from I_MaterialStock_2
      WHERE Plant eq '1101'
      AND   Material eq '000000000080000001' "'000000000000000029' "
      AND   MatlDocLatestPostgDate in @lr_date
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_data).

      select * from ZCDS_CRATE_BALANCE( FROM_DATE = @ls_date-low )
      WHERE Plant eq '1101'
      AND   Material eq '000000000080000001' "'000000000000000029' "
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_bal).

      if lt_data[] is NOT INITIAL.
       sort lt_data by MatlDocLatestPostgDate.
       clear lv_opbal.
       if lt_bal[] is NOT INITIAL.
       READ TABLE lt_bal INTO data(ls_bal) INDEX 1.
       if sy-subrc = 0.
        lv_opbal = ls_bal-MatlWrhsStkQtyInMatlBaseUnit.
       endif.
       endif.

       loop at lt_data INTO data(ls_data).

        ls_response_i-Customer                = ls_data-Customer.
        ls_response_i-MatlDocLatestPostgDate  = ls_data-MatlDocLatestPostgDate.
        ls_response_i-MaterialBaseUnit        = ls_data-MaterialBaseUnit.

        ls_response_i-OpenQty = lv_opbal.

        ls_response_i-ConsQty                 = ls_data-MatlCnsmpnQtyInMatlBaseUnit.
        ls_response_i-InsrQty                 = ls_data-MatlStkIncrQtyInMatlBaseUnit.
        lv_opbal = lv_opbal +  ls_data-MatlStkIncrQtyInMatlBaseUnit.
        ls_response_i-DesrQty                 = ls_data-MatlStkDecrQtyInMatlBaseUnit.
        lv_opbal = lv_opbal -  ls_data-MatlStkDecrQtyInMatlBaseUnit.

        ls_response_i-CloseQty = lv_opbal.


         ls_response_i-fr_date          = ls_date-low.
          if ls_date-high is NOT INITIAL.
            ls_response_i-to_date     = ls_date-high.
           else.
            ls_response_i-to_date     = ls_date-low.
          endif.
        append ls_response_i to lt_response_i.
        clear ls_response_i.

       endloop.
      endif.

      io_response->set_total_number_of_records( lines( lt_response_i ) ).
      io_response->set_data( lt_response_i ).

    endif.

    WHEN 'ZCE_CRATE_BAL_FORM_DELETE'.

      DATA: lt_res TYPE TABLE OF ZCE_CRATE_BAL_FORM_DELETE,
            ls_res TYPE ZCE_CRATE_BAL_FORM_DELETE.

      select customer, pdf_data
      FROM ztcrate_balalce
       where customer in @lt_cust1
       INTO TABLE @data(lt_cust).

      loop at lt_cust INTO data(lscust) WHERE pdf_data is NOT INITIAL.

*        update ztcrate_balalce set pdf_data = ''
*        WHERE customer = @lscust-customer.
*        commit WORK.

       ls_res-Customer = lscust-customer.
       APPEND ls_res TO lT_res.
       CLEAR ls_res.
      endloop.

      io_response->set_total_number_of_records( lines( lt_res ) ).
      io_response->set_data( lt_res ).

     endcase.


  ENDMETHOD.
ENDCLASS.
