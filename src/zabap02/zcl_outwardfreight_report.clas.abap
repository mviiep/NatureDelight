CLASS zcl_outwardfreight_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_OUTWARDFREIGHT_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    TYPES: BEGIN OF ty_vehicle,
            veh_mast(10) type c,
            veh_bill(20) type c,
            veh_bills(20) type c,
           END OF ty_vehicle.
    data : lt_veh type STANDARD TABLE OF ty_vehicle,
           ls_veh type ty_vehicle.

      DATA: lt_response TYPE TABLE OF ZCE_OUTWARD_FREIGHT_REP,
            lS_response TYPE ZCE_OUTWARD_FREIGHT_REP,
            lt_response_i TYPE TABLE OF ZCE_OUTWARD_FREIGHT_REP_ITEM,
            lS_response_i TYPE ZCE_OUTWARD_FREIGHT_REP_ITEM.


    IF io_request->is_data_requested( ).

      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

      DATA(lr_erdat)  =  VALUE #( lt_filter_cond[ name   = 'ERDAT' ]-range OPTIONAL ).
      DATA(lr_transporter)   =  VALUE #( lt_filter_cond[ name   = 'TRANSPORTER' ]-range OPTIONAL ).
      DATA(lr_vehicle) =  VALUE #( lt_filter_cond[ name   = 'VEHICLE' ]-range OPTIONAL ).

****Data retrival and business logics goes here*****

      IF lv_top < 0.
        lv_top = 1.
      ENDIF.

     select * from ztmm_vehicle
     WHERE Vehicle_No in @lr_vehicle
     AND   LIFNR  in @lr_transporter
     into TABLE @data(lt_vehicle).

    if lt_vehicle[] is NOT INITIAL.
    clear: lt_veh[], ls_veh.
    loop at lt_vehicle ASSIGNING FIELD-SYMBOL(<lfs_vehicle>).
     ls_veh-veh_bills = <lfs_vehicle>-vehicle_no.
     TRANSLATE <lfs_vehicle>-vehicle_no to UPPER CASE.
     ls_veh-veh_mast = <lfs_vehicle>-vehicle_no.
     ls_veh-veh_bill = <lfs_vehicle>-vehicle_no.
     append ls_veh to lt_veh.
     clear ls_veh.
    endloop.

*     select a~BillingDocument, a~BillingDocumentDate,
*            a~PayerParty, a~yy1_vehicle_no_bdh,
*            c~ActualDeliveryRoute
*     from I_BILLINGDOCUMENT as a
*    left outer join I_BillingDocumentItem as b on a~BillingDocument = b~BillingDocument
*    left outer join I_DeliveryDocument    as c on c~DeliveryDocument = b~ReferenceSDDocument
*      FOR ALL ENTRIES IN @lt_veh
*      where a~BillingDocumentDate in @lr_erdat
*      AND   a~yy1_vehicle_no_bdh eq @lt_veh-veh_bill
*      into TABLE @data(lt_bill).

     select a~BillingDocument, a~BillingDocumentDate,
           a~PayerParty,
*           a~yy1_vehicle_no_bdh,
            c~ActualDeliveryRoute,
            e~vehicle_no as yy1_vehicle_no_bdh
     from I_BILLINGDOCUMENT as a
    join zsdt_truckshet_i as d on a~BillingDocument = d~vbeln
    join zsdt_truckshet_h as e on d~trucksheet_no = e~trucksheet_no
    left outer join I_BillingDocumentItem as b on a~BillingDocument = b~BillingDocument
    left outer join I_DeliveryDocument    as c on c~DeliveryDocument = b~ReferenceSDDocument
      FOR ALL ENTRIES IN @lt_veh
      where a~BillingDocumentDate in @lr_erdat
*      AND   a~yy1_vehicle_no_bdh eq @lt_veh-veh_bill
      AND   e~vehicle_no eq @lt_veh-veh_mast
      INTO TABLE @data(lt_bill).

      if  lt_bill[] is NOT INITIAL.

       SORT lt_bill BY BillingDocumentDate ActualDeliveryRoute yy1_vehicle_no_bdh.
       delete ADJACENT DUPLICATES FROM lt_bill COMPARING BillingDocumentDate ActualDeliveryRoute yy1_vehicle_no_bdh.

      select customer, CustomerName from i_customer
      FOR ALL ENTRIES IN @lt_bill
      WHERE customer = @lt_bill-PayerParty
      into TABLE @data(lt_customer).

      SELECT route, description, distance from ztroute_distance
      FOR ALL ENTRIES IN @lt_bill
      WHERE route = @lt_bill-ActualDeliveryRoute
      into TABLE @data(lt_route).

      endif.

    endif.

      data(lv_to) = lv_skip + lv_top.
      lv_skip = lv_skip + 1.

    CASE io_request->get_entity_id( ).
      WHEN 'ZCE_OUTWARD_FREIGHT_REP'.
      CLEAR lS_response.
      LOOP AT lt_bill INTO DATA(ls_bill) from lv_skip to lv_to.

      TRANSLATE  ls_bill-yy1_vehicle_no_bdh to UPPER CASE.

       lS_response-erdat       = ls_bill-BillingDocumentDate.
       lS_response-vehicle     = ls_bill-yy1_vehicle_no_bdh.
*       lS_response-       = ls_bill-BillingDocument.


       READ TABLE lt_vehicle INTO DATA(lS_vehicle)
       WITH KEY vehicle_no = ls_bill-yy1_vehicle_no_bdh.
       IF SY-SUBRC = 0.
         lS_response-transporter = lS_vehicle-lifnr.
         lS_response-name1       = lS_vehicle-name1.
         lS_response-rate        = lS_vehicle-Rate. "Rate_V.
         lS_response-currency    = lS_vehicle-CURRENCY. "Rate_C.
       ENDIF.

        lS_response-route  = ls_bill-ActualDeliveryRoute.

       READ TABLE lt_route INTO data(ls_route) WITH KEY route = ls_bill-ActualDeliveryRoute.
       if sy-subrc = 0.
        lS_response-route_nm = ls_route-description.
        lS_response-distance = ls_route-distance.
       endif.

       lS_response-amount = lS_response-rate * lS_response-distance.

        APPEND lS_response TO lT_response.
        CLEAR lS_response.
      ENDLOOP.


      io_response->set_total_number_of_records( lines( lt_bill ) ).
      io_response->set_data( lt_response ).


  WHEN 'ZCE_OUTWARD_FREIGHT_REP_ITEM'.

      CLEAR lS_response_i.
      LOOP AT lt_bill INTO ls_bill from lv_skip to lv_to.

      TRANSLATE  ls_bill-yy1_vehicle_no_bdh to UPPER CASE.

       lS_response_i-erdat       = ls_bill-BillingDocumentDate.
       lS_response_i-vehicle     = ls_bill-yy1_vehicle_no_bdh.
       lS_response_i-billingdocument  = ls_bill-BillingDocument.


       READ TABLE lt_vehicle INTO lS_vehicle
       WITH KEY vehicle_no = ls_bill-yy1_vehicle_no_bdh.
       IF SY-SUBRC = 0.
         lS_response_i-transporter = lS_vehicle-lifnr.
         lS_response_i-name1       = lS_vehicle-name1.
       ENDIF.

       READ TABLE lt_customer INTO data(ls_customer)
       WITH KEY customer = ls_bill-PayerParty.
       if sy-subrc = 0.
        lS_response_i-customer  = ls_customer-Customer.
        lS_response_i-cust_name = ls_customer-CustomerName.
       endif.

        lS_response-route  = ls_bill-ActualDeliveryRoute.

       READ TABLE lt_route INTO ls_route WITH KEY route = ls_bill-ActualDeliveryRoute.
       if sy-subrc = 0.
        lS_response_i-route_nm = ls_route-description.
       endif.

        APPEND lS_response_i TO lT_response_i.
        CLEAR lS_response_i.
      ENDLOOP.


      io_response->set_total_number_of_records( lines( lt_bill ) ).
      io_response->set_data( lt_response_i ).

   ENDCASE.

  ENDIF.

  ENDMETHOD.
ENDCLASS.
