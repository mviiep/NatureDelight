CLASS zcl_inwardfreight_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INWARDFREIGHT_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA: lt_response TYPE TABLE OF ZCE_INWARD_FREIGHT_REP,
            lS_response TYPE ZCE_INWARD_FREIGHT_REP.
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

      DATA(lr_erdat)  =  VALUE #( lt_filter_cond[ name   = 'ERDAT' ]-range OPTIONAL ).
      DATA(lr_transporter)   =  VALUE #( lt_filter_cond[ name   = 'TRANSPORTER' ]-range OPTIONAL ).
      DATA(lr_vehicle) =  VALUE #( lt_filter_cond[ name   = 'VEHICLE' ]-range OPTIONAL ).

****Data retrival and business logics goes here*****

*     select * from YY1_VEHICLEMASTER "ztmm_vehicle
*     WITH PRIVILEGED ACCESS
*     WHERE VehicleNo in @lr_vehicle
*     AND   Supplier  in @lr_transporter
*     into TABLE @data(lt_vehicle).

     select * from ztmm_vehicle
     WHERE Vehicle_No in @lr_vehicle
     AND   LIFNR  in @lr_transporter
     into TABLE @data(lt_vehicle).

    if lt_vehicle[] is NOT INITIAL.
*     select from I_PURCHASEORDERAPI01 as a
*     join I_PurchaseOrderItemAPI01 as b
*     on ( a~PurchaseOrder = b~PurchaseOrder )
*     fields a~PurchaseOrder, a~PurchaseOrderDate, a~PurchaseOrderType,
*            a~YY1_Distance_PDHU, A~YY1_Distance_PDH, A~YY1_VEHICLENO1_PDH,
*            a~PricingDocument,
*            b~PurchaseOrderItem, b~Material, b~plant, b~StorageLocation,
*            b~PurchaseOrderQuantityUnit, b~OrderQuantity,
**            B~YY1_ChillingCenter_PDI,
*            B~YY1_ChillingCenteChill_PDI, B~YY1_Compartment_PDI
*      FOR ALL ENTRIES IN @lt_vehicle
*      where PurchaseOrderDate in @lr_erdat
**      AND   yy1_vehicle_number_pdh eq @lt_vehicle-vehicle_no
**      AND  YY1_VehicleNo_PDH eq @lt_vehicle-vehicleno
*      AND  YY1_VEHICLENO1_PDH eq @lt_vehicle-vehicle_no
*      AND ( PurchaseOrderType = 'ZSTO' OR PurchaseOrderType = 'UB' )
*      into TABLE @data(lt_sto1).

      data: lt_veh type RANGE OF ztmm_vehicle-vehicle_no.

        lt_veh = VALUE #( FOR ls_veh
                           IN lt_vehicle
                           ( sign = 'I'
                             option = 'EQ'
                             low = |{ ls_veh-vehicle_no }| )
                         ).

     select from I_PURCHASEORDERAPI01 as a
     fields a~PurchaseOrder
      where a~PurchaseOrderDate in @lr_erdat
      AND   a~YY1_VEHICLENO1_PDH in @lt_veh
      AND ( a~PurchaseOrderType = 'ZSTO' OR a~PurchaseOrderType = 'UB' )
      into TABLE @data(lt_data).

     select from I_PURCHASEORDERAPI01 as a
     fields a~PurchaseOrder, a~PurchaseOrderDate, a~PurchaseOrderType,
            a~YY1_Distance_PDHU, A~YY1_Distance_PDH, A~YY1_VEHICLENO1_PDH,
            a~PricingDocument
*          FOR ALL ENTRIES IN @lt_vehicle
      where a~PurchaseOrderDate in @lr_erdat
      AND   a~YY1_VEHICLENO1_PDH in @lt_veh "eq @lt_vehicle-vehicle_no
      AND ( a~PurchaseOrderType = 'ZSTO' OR a~PurchaseOrderType = 'UB' )
      order by purchaseorder
      into TABLE @data(lt_sto)
      UP TO @lv_top ROWS OFFSET @lv_skip.


    if lt_sto[] is NOT INITIAL.
     select from I_PurchaseOrderItemAPI01 as b
     fields b~PurchaseOrder, b~PurchaseOrderItem, b~Material, b~plant, b~StorageLocation,
            b~PurchaseOrderQuantityUnit, b~OrderQuantity,
            B~YY1_ChillingCenteChill_PDI, B~YY1_Compartment_PDI
      FOR ALL ENTRIES IN @lt_sto
      where b~purchaseorder eq @lt_sto-PurchaseOrder
      into TABLE @data(lt_sto_i).
     if lt_sto_i[] is NOT INITIAL.
      select FROM I_StorageLocation FIELDS StorageLocation, StorageLocationname
      FOR ALL ENTRIES IN @lt_sto_i
      WHERE StorageLocation = @lt_sto_i-YY1_ChillingCenteChill_PDI
      into TABLE @data(lt_chill).
     endif.
     endif.

      if  lt_sto[] is NOT INITIAL.

       SORT lt_sto BY PurchaseOrderDate PURCHASEORDER.

       select conditionrecord, conditiontype, ConditionRateValue
        from I_PURGPRCGCONDITIONRECORD
       FOR ALL ENTRIES IN @lt_sto
       WHERE conditionrecord = @lt_sto-PricingDocument
       AND   conditiontype = 'ZFR1'
       into TABLE @data(lt_price).
      endif.

    endif.

      CLEAR lS_response.
*      LOOP AT lt_sto INTO DATA(lS_sto).
*       lS_response-erdat       = lS_sto-PurchaseOrderDate.
*       lS_response-vehicle     = lS_sto-YY1_VehicleNo1_PDH.
*       lS_response-ebeln       = lS_sto-PurchaseOrder.
*       lS_response-uomkms      = lS_sto-YY1_Distance_PDHU.
*       lS_response-distance    = lS_sto-YY1_Distance_PDH.
*
*       READ TABLE lt_vehicle INTO DATA(lS_vehicle)
**       WITH KEY vehicleno = lS_sto-YY1_VehicleNo_PDH.
*       WITH KEY vehicle_no = lS_sto-YY1_VEHICLENO1_PDH.
*       IF SY-SUBRC = 0.
*         lS_response-transporter = lS_vehicle-name1.
*         lS_response-rate        = lS_vehicle-Rate. "Rate_V.
*         lS_response-currency    = lS_vehicle-CURRENCY. "Rate_C.
*         lS_response-capacity    = lS_vehicle-CAP. "Cap_V.
*       ENDIF.
*
*       IF lS_response-route IS INITIAL.
*        lS_response-route  = lS_sto-YY1_ChillingCenteChill_PDI.
*       ELSE.
*        lS_response-route  = |{ lS_response-route } - { lS_sto-YY1_ChillingCenteChill_PDI }|.
*       ENDIF.
*
*       lS_response-uom     = lS_sto-PurchaseOrderQuantityUnit.
*       lS_response-milkqty = lS_response-milkqty + lS_sto-OrderQuantity.
*
*       CLEAR lS_response-amount.
*       LOOP AT lt_price INTO DATA(lS_price)
*       WHERE conditionrecord = lS_sto-PricingDocument.
*        lS_response-amount = lS_response-amount + lS_price-ConditionRateValue.
*       ENDLOOP.
*
*       lS_response-amount_cal = lS_response-rate * lS_response-distance.
*
*       AT END OF PurchaseOrder.
*        lS_response-caputil = ( lS_response-MILKQTY / lS_response-capacity ) * 100.
*        lS_response-capuom = '%'.
*        APPEND lS_response TO lT_response.
*        CLEAR lS_response.
*       ENDAT.
*      ENDLOOP.


      LOOP AT lt_sto INTO DATA(lS_sto).
       lS_response-erdat       = lS_sto-PurchaseOrderDate.
       lS_response-vehicle     = lS_sto-YY1_VehicleNo1_PDH.
       lS_response-ebeln       = lS_sto-PurchaseOrder.
       lS_response-uomkms      = lS_sto-YY1_Distance_PDHU.
       lS_response-distance    = lS_sto-YY1_Distance_PDH.

       READ TABLE lt_vehicle INTO DATA(lS_vehicle)
*       WITH KEY vehicleno = lS_sto-YY1_VehicleNo_PDH.
       WITH KEY vehicle_no = lS_sto-YY1_VEHICLENO1_PDH.
       IF SY-SUBRC = 0.
         lS_response-transporter = lS_vehicle-name1.
         lS_response-rate        = lS_vehicle-Rate. "Rate_V.
         lS_response-currency    = lS_vehicle-CURRENCY. "Rate_C.
         lS_response-capacity    = lS_vehicle-CAP. "Cap_V.
       ENDIF.

      LOOP AT lt_sto_i INTO DATA(lS_sto1) WHERE PurchaseOrder = lS_sto-PurchaseOrder.
      READ TABLE lt_chill INTO data(ls_chill)
       WITH KEY StorageLocation = lS_sto1-YY1_ChillingCenteChill_PDI.
       IF lS_response-route IS INITIAL.
        lS_response-route  = ls_chill-StorageLocationName.
       ELSE.
        lS_response-route  = |{ lS_response-route } - { ls_chill-StorageLocationName }|.
       ENDIF.

       lS_response-uom     = lS_sto1-PurchaseOrderQuantityUnit.
       lS_response-milkqty = lS_response-milkqty + lS_sto1-OrderQuantity.

       CLEAR lS_response-amount.
       LOOP AT lt_price INTO DATA(lS_price)
       WHERE conditionrecord = lS_sto-PricingDocument.
        lS_response-amount = lS_response-amount + lS_price-ConditionRateValue.
       ENDLOOP.
      endloop.


       lS_response-amount_cal = lS_response-rate * lS_response-distance.

*       AT END OF PurchaseOrder.
        lS_response-caputil = ( lS_response-MILKQTY / lS_response-capacity ) * 100.
        lS_response-capuom = '%'.
        APPEND lS_response TO lT_response.
        CLEAR lS_response.
*       ENDAT.
      ENDLOOP.



      io_response->set_total_number_of_records( lines( lt_data ) ).
      io_response->set_data( lt_response ).

    ENDIF.

  ENDMETHOD.
ENDCLASS.
