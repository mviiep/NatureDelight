CLASS zcl_crate_bal_rep DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CRATE_BAL_REP IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF ZCE_CRATE_BAL_REP,
            ls_response TYPE ZCE_CRATE_BAL_REP.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      IF lv_top < 0.
        lv_top = 1.
      ENDIF.

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

*      DATA(lr_werks)   =  VALUE #( lt_filter_cond[ name   = 'P_WERKS' ]-range OPTIONAL ).
*      DATA(lr_matnr)   =  VALUE #( lt_filter_cond[ name   = 'P_MATNR' ]-range OPTIONAL ).
*      DATA(lr_date)    =  VALUE #( lt_filter_cond[ name   = 'P_DATE' ]-range OPTIONAL ).
      DATA(lr_werks)   =  VALUE #( lt_filter_cond[ name   = 'PLANT' ]-range OPTIONAL ).
      DATA(lr_matnr)   =  VALUE #( lt_filter_cond[ name   = 'PRODUCT' ]-range OPTIONAL ).
      DATA(lr_date)    =  VALUE #( lt_filter_cond[ name   = 'P_DATE' ]-range OPTIONAL ).
      DATA(lr_cust)    =  VALUE #( lt_filter_cond[ name   = 'CUSTOMER' ]-range OPTIONAL ).

      data: lt_cust1 type RANGE OF i_customer-customer.

        lt_cust1 = VALUE #( FOR ls_cust
                           IN lr_cust
                           ( sign = ls_cust-sign
                             option = ls_cust-option
                             low = |{ ls_cust-low ALPHA = IN }|
                             high = |{ ls_cust-high ALPHA = IN }| )
                         ).

****Data retrival and business logics goes here*****

     if lr_date[] is NOT INITIAL.
      READ TABLE lr_date into data(ls_date) INDEX 1.
     endif.

     data : lv_date type datum.
      if ls_date-high is NOT INITIAL.
        lv_date = ls_date-high.
      else.
        lv_date = ls_date-low.
      endif.

      select single * from ZI_DateAddIncrement( p_IncrementDate = @lv_date,
                                                p_IncrementAmt = '-1',
                                                p_IncrementType = 'D' )
      into @data(lv_datecal).

       lv_date = lv_datecal-IncrementedDate.

      select * from ZCDS_CRATE_BALANCE( FROM_DATE = @ls_date-low )
*                                        TO_DATE = @ls_date-high )
      WHERE Plant in @lr_werks
      AND   Material in @lr_matnr
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
*      AND MatlWrhsStkQtyInMatlBaseUnit is NOT INITIAL
      into TABLE @data(lt_coll).

      select * from I_MaterialStock_2
      WHERE Plant in @lr_werks
      AND   Material in @lr_matnr
      AND   MatlDocLatestPostgDate in @lr_date
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_data).

      select * from I_MaterialStock_2
      WHERE Plant in @lr_werks
      AND   Material in @lr_matnr
      AND   MatlDocLatestPostgDate = @lv_date
      AND   Customer is NOT initial
      AND   customer in @lt_cust1
      into TABLE @data(lt_data1).

     loop at lt_data INTO data(ls_data).
      READ TABLE lt_coll INTO data(ls_coll) WITH KEY plant    = ls_data-Plant
                                                     material = ls_data-material
                                                     customer = ls_data-customer.
     if sy-subrc ne 0.

      clear ls_coll.
      ls_coll-plant = ls_data-plant.
      ls_coll-material = ls_data-material.
      ls_coll-customer = ls_data-customer.
      ls_coll-MaterialBaseUnit = ls_data-MaterialBaseUnit.

      select SINGLE ProductName from i_producttext
      where product = @ls_data-material
      INTO @ls_coll-ProductName.

      select SINGLE CustomerName from i_customer
      where customer = @ls_data-customer
      INTO @ls_coll-BPCustomerName.

      append ls_coll to lt_coll.
      clear ls_coll.
     endif.

     ENDLOOP.

*      select * from I_MaterialStock_2
*      WHERE Plant in @lr_werks
*      AND   Material in @lr_matnr
*      AND   MatlDocLatestPostgDate le @ls_date-low
*      AND   Customer is NOT initial
*      into TABLE @data(lt_data).
  sort lt_coll  by plant material customer.
      if lt_data[] is NOT INITIAL.
       sort lt_data  by plant material customer.

       sort lt_data1 by plant material customer MatlDocLatestPostgDate.


       select Customer, CustomerGroup from I_CustomerSalesArea
       FOR ALL ENTRIES IN @lt_data
       WHERE Customer = @lt_data-Customer
       INTO TABLE @data(lt_Customer_sale).
       sort lt_Customer_sale by customer.

     if lt_coll[] is not INITIAL.
       select Customer, CustomerGroup from I_CustomerSalesArea
       FOR ALL ENTRIES IN @lt_coll
       WHERE Customer = @lt_coll-Customer
       APPENDING TABLE @lt_Customer_sale.
       sort lt_Customer_sale by customer.
       delete ADJACENT DUPLICATES FROM lt_Customer_sale COMPARING customer.
       SELECT customer,addressid FROM i_customer
      FOR ALL ENTRIES IN @lt_coll
      WHERE customer = @lt_coll-Customer
      INTO TABLE @data(lt_customer).


      if sy-subrc = 0.

*      SELECT FROM I_AddrOrgNamePostalAddress WITH PRIVILEGED ACCESS
*      FIELDS AddressID ,TransportZone
*      FOR ALL ENTRIES IN @lt_customer
*      WHERE AddressID = @lt_customer-AddressID
*      INTO TABLE @DATA(lt_address1).

      SELECT FROM i_address_2 WITH PRIVILEGED ACCESS
      FIELDS AddressID ,TransportZone
      FOR ALL ENTRIES IN @lt_customer
      WHERE AddressID = @lt_customer-AddressID
      INTO TABLE @DATA(lt_address).
      if    sy-subrc = 0.
       SELECT FROM ztroute_distance
       FIELDS route,
       description
       FOR ALL ENTRIES IN @lt_address
       WHERE route = @lt_address-TransportZone+0(6)
       INTO TABLE @data(lt_route).
      ENDIF.

      ENDIF.
      endif.
      endif.

      data(lv_to) = lv_skip + lv_top.
      lv_skip = lv_skip + 1.



      loop at lt_coll INTO ls_coll FROM lv_skip to lv_to.

       ls_response-Plant     = ls_coll-Plant.
       ls_response-PRODUCT   = ls_coll-Material.
       ls_response-Customer  = ls_coll-Customer.
       ls_response-MaterialBaseUnit = ls_coll-MaterialBaseUnit.
       ls_response-maktx     = ls_coll-ProductName.
       ls_response-name1     = ls_coll-BPCustomerName.

       ls_response-OpenQty = ls_response-OpenQty + ls_coll-MatlWrhsStkQtyInMatlBaseUnit.

       loop at lt_data INTO ls_data WHERE plant    = ls_coll-plant
                                    AND   material = ls_coll-material
                                    and   customer = ls_coll-customer.

         ls_response-ConsQty = ls_response-ConsQty + ls_data-MatlCnsmpnQtyInMatlBaseUnit.
         ls_response-InsrQty = ls_response-InsrQty + ls_data-MatlStkIncrQtyInMatlBaseUnit.
         ls_response-DesrQty = ls_response-DesrQty + ls_data-MatlStkDecrQtyInMatlBaseUnit.

       endloop.


        ls_response-CloseQty = ls_response-OpenQty - ls_response-ConsQty +
                               ls_response-InsrQty - ls_response-DesrQty.


         READ table lt_Customer_sale INTO data(ls_Customer_sale)
         WITH KEY customer = ls_coll-customer BINARY SEARCH.
         if sy-subrc = 0.
          CASE ls_Customer_sale-CustomerGroup.
          when '01'.
          ls_response-CustomerGroup = 'Daily'.

          when '02'.
          ls_response-CustomerGroup = 'One Day'.

           read table lt_data1 INTO data(ls_data1) with key  material = ls_coll-material
                                                             customer = ls_coll-customer
                                                             MatlDocLatestPostgDate = lv_date BINARY SEARCH.
           if sy-subrc = 0.
             ls_response-transitqty = ls_data1-MatlStkIncrQtyInMatlBaseUnit .
           endif.

          ENDCASE.
         endif.

         READ TABLE lt_customer INTO DATA(lw_customer) with key
         Customer = ls_response-Customer.
         if sy-subrc = 0 .
         READ TABLE lt_address INTO data(lw_adress) WITH KEY
         AddressID = lw_customer-AddressID.
         if sy-subrc = 0.
         ls_response-route = lw_adress-TransportZone.
         READ TABLE lt_route INTO DATA(lw_route)
         WITH KEY route = ls_response-route.
         if sy-subrc = 0.
         ls_response-route_name = lw_route-description.
         ENDIF.
         ENDIF.
         ENDIF.
*          if ls_response-OpenQty is NOT INITIAL.
         APPEND ls_response to lt_response.
*         ENDIF.
         clear ls_response.

      endloop.


*      loop at lt_data INTO data(ls_data).
*
*       ls_response-Plant     = ls_data-Plant.
*       ls_response-PRODUCT  = ls_data-Material.
*       ls_response-Customer  = ls_data-Customer.
*       ls_response-MaterialBaseUnit = ls_data-MaterialBaseUnit.
*
*       if ls_data-MatlDocLatestPostgDate lt ls_date-low.
*        ls_response-OpenQty = ls_response-OpenQty + ls_data-MatlWrhsStkQtyInMatlBaseUnit.
*       else.
*         ls_response-ConsQty = ls_response-ConsQty + ls_data-MatlCnsmpnQtyInMatlBaseUnit.
*         ls_response-InsrQty = ls_response-InsrQty + ls_data-MatlStkIncrQtyInMatlBaseUnit.
*         ls_response-DesrQty = ls_response-DesrQty + ls_data-MatlStkDecrQtyInMatlBaseUnit.
*       endif.
*
*        ls_response-CloseQty = ls_response-CloseQty + ls_data-MatlWrhsStkQtyInMatlBaseUnit.
*
*       at END OF customer.
*
*         READ table lt_product INTO data(ls_product)
*         WITH KEY product = ls_Data-material BINARY SEARCH.
*         if sy-subrc = 0.
*          ls_response-maktx = ls_product-ProductName.
*         endif.
*
*         READ table lt_customer INTO data(ls_customer)
*         WITH KEY customer = ls_Data-customer BINARY SEARCH.
*         if sy-subrc = 0.
*          ls_response-name1 = ls_customer-CustomerName.
*         endif.
*
*         READ table lt_Customer_sale INTO data(ls_Customer_sale)
*         WITH KEY customer = ls_Data-customer BINARY SEARCH.
*         if sy-subrc = 0.
*          CASE ls_Customer_sale-CustomerGroup.
*          when '01'.
*          ls_response-CustomerGroup = 'Daily'.
*
**           read table lt_data1 INTO data(ls_data1) with key  material = ls_data-material
**                                                customer = ls_data-customer
**                                                MatlDocLatestPostgDate = ls_date-low BINARY SEARCH.
**           if sy-subrc = 0.
**             ls_response-transitqty = ls_data1-MatlStkIncrQtyInMatlBaseUnit.
**           endif.
*
*          when '02'.
*          ls_response-CustomerGroup = 'One Day'.
*
*           read table lt_data1 INTO data(ls_data1) with key  material = ls_data-material
*                                                customer = ls_data-customer
*                                                MatlDocLatestPostgDate = lv_date BINARY SEARCH.
*           if sy-subrc = 0.
*             ls_response-transitqty = ls_data1-MatlStkIncrQtyInMatlBaseUnit.
*           endif.
*
*          ENDCASE.
*         endif.
*
*         APPEND ls_response to lt_response.
*         clear ls_response.
*       endat.
*      endloop.
*    delete lt_response WHERE OpenQty is INITIAL .
*AND CloseQty is INITIAL and InsrQty is INITIAL
*     AND DesrQty is INITIAL.
      io_response->set_total_number_of_records( lines( lt_coll ) ).
      io_response->set_data( lt_response ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
