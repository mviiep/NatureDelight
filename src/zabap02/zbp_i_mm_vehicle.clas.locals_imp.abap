CLASS lhc_ZI_MM_VEHICLE DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mm_vehicle RESULT result.
    METHODS fetchname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_mm_vehicle~fetchname.
    METHODS vehicleuppercase FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_mm_vehicle~vehicleuppercase.
    METHODS check_vehicle_no FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_mm_vehicle~check_vehicle_no.
ENDCLASS.

CLASS lhc_ZI_MM_VEHICLE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD fetchname.

   " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_mm_vehicle IN LOCAL MODE
      ENTITY zi_mm_vehicle
       all FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).


    LOOP AT members INTO DATA(member).

         select SINGLE BPSupplierFullName from i_supplier
         WHERE Supplier = @member-Vendor
         into @data(lv_name1).
    data(lv_vehicle_no) = member-VehicleNo.
TRANSLATE  lv_vehicle_no to UPPER CASE.
            MODIFY ENTITIES OF zi_mm_vehicle IN LOCAL MODE
                    ENTITY zi_mm_vehicle
                      UPDATE
                        FIELDS ( VendorName VehicleNo )
                        WITH VALUE #(
                                      ( %tky = member-%tky
                                        VendorName = lv_name1
                                        VehicleNo = lv_vehicle_no
                                        ) ).

    ENDLOOP.

  ENDMETHOD.

  METHOD vehicleuppercase.

*   READ ENTITIES OF zi_mm_vehicle IN LOCAL MODE
*      ENTITY zi_mm_vehicle
*        FIELDS ( VehicleNo ) WITH CORRESPONDING #( keys )
*      RESULT DATA(members).
*      LOOP AT members INTO DATA(member).
*      data(lv_vehicle_no) = member-VehicleNo.
*       TRANSLATE  lv_vehicle_no to UPPER CASE.
*
*            MODIFY ENTITIES OF zi_mm_vehicle IN LOCAL MODE
*                    ENTITY zi_mm_vehicle
*                      UPDATE
*                        FIELDS ( VehicleNo )
*                        WITH VALUE #(
*                                      ( %tky = member-%tky
*                                        VehicleNo =  lv_vehicle_no
*                                        ) ).
*
*
*      ENDLOOP.
  ENDMETHOD.

  METHOD check_vehicle_no.

   READ ENTITIES OF zi_mm_vehicle IN LOCAL MODE
      ENTITY zi_mm_vehicle
       all FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

      LOOP AT  members INTO DATA(lw_members).

      SELECT SINGLE vehicle_no FROM ztmm_vehicle
      WHERE vehicle_no = @lw_members-VehicleNo
      INTO @data(lv_vehicel_no).
      if lv_vehicel_no is NOT INITIAL.

       APPEND VALUE #( %tky =  lw_members-%tky ) TO failed-zi_mm_vehicle.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                         %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                          text = 'Vehicle is already exist'
                          )

        ) TO  reported-zi_mm_vehicle.

      ENDIF.

      ENDLOOP.

  ENDMETHOD.

ENDCLASS.
