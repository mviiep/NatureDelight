CLASS lsc_zi_weighbridge_outbound DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_weighbridge_outbound IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_weighbridge_out TYPE TABLE OF ztout_weighbrid,
           lw_weighbridge_out TYPE ztout_weighbrid.
    IF create-weighbridgeoutbound IS NOT INITIAL.
      lt_weighbridge_out = CORRESPONDING #( create-weighbridgeoutbound MAPPING
      trucksheet_no = trucksheetno
      vehicle_no = vehicleno
      total_trucksheet_weight = totaltrucksheetweight
      tare_weight  = tareweight
      weighbridge_weight = weighbridgeweight
      difference_weight = differenceweight
     ).
      INSERT  ztout_weighbrid FROM TABLE @lt_weighbridge_out.

    ENDIF.

    IF update IS NOT INITIAL.
      lt_weighbridge_out = CORRESPONDING #( create-weighbridgeoutbound MAPPING
      trucksheet_no = trucksheetno
      vehicle_no = vehicleno
      total_trucksheet_weight = totaltrucksheetweight
      tare_weight  = tareweight
      weighbridge_weight = weighbridgeweight
      difference_weight = differenceweight
     ).
     MODIFY ztout_weighbrid FROM TABLE @lt_weighbridge_out.
    ENDIF.

    IF delete IS NOT INITIAL.
      LOOP AT delete-weighbridgeoutbound INTO DATA(lw_delete).
        DELETE FROM ztout_weighbrid WHERE trucksheet_no = @lw_delete-TrucksheetNo.

      ENDLOOP.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_weighbridgeoutbound DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR weighbridgeoutbound RESULT result.
    METHODS getweight FOR MODIFY
      IMPORTING keys FOR ACTION weighbridgeoutbound~getweight RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR weighbridgeoutbound RESULT result.
    METHODS fetch_trucksheet_data FOR DETERMINE ON SAVE
      IMPORTING keys FOR weighbridgeoutbound~fetch_trucksheet_data.

ENDCLASS.

CLASS lhc_weighbridgeoutbound IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD getweight.



  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD fetch_trucksheet_data.
    READ ENTITIES OF zi_weighbridge_outbound IN LOCAL MODE
     ENTITY weighbridgeoutbound FIELDS ( trucksheetno )
     WITH CORRESPONDING #( keys )
     RESULT DATA(members).
    READ TABLE members INTO DATA(lw_members) INDEX 1.
    SELECT  SINGLE  FROM zi_truckshet_hi_view
    FIELDS zi_truckshet_hi_view~itemtrucksheetno , zi_truckshet_hi_view~vbeln,
    \_header-VehicleNo

    WHERE itemtrucksheetno = @lw_members-trucksheetno
    INTO @DATA(lw_trucksheet).
    if sy-subrc = 0.

    SELECT  sum( ItemGrossWeight ) FROM I_BillingDocumentitem
    WITH PRIVILEGED ACCESS
    WHERE BillingDocument = @lw_trucksheet-Vbeln
    INTO @DATA(lv_gross_weight).


    MODIFY ENTITIES OF  zi_weighbridge_outbound IN LOCAL MODE
    ENTITY WeighBridgeOutbound UPDATE FIELDS ( VehicleNo  TotalTrucksheetWeight )
    WITH VALUE #( ( %tky = lw_members-%tky
     VehicleNo = lw_trucksheet-vehicleno
     TotalTrucksheetWeight =  lv_gross_weight ) ) .

    ENDIF.

  ENDMETHOD.

ENDCLASS.
