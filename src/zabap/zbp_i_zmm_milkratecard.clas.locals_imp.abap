CLASS lhc_ratecard DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS validate_effdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR RateCard~validate_effdate.
    METHODS fetchname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR RateCard~fetchname.
    METHODS mandatory_data FOR VALIDATE ON SAVE
      IMPORTING keys FOR RateCard~mandatory_data.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR RateCard RESULT result.
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR RateCard RESULT result.

*    METHODS UploadExcel FOR MODIFY
*      IMPORTING keys FOR ACTION RateCard~UploadExcel RESULT result.

ENDCLASS.

CLASS lhc_ratecard IMPLEMENTATION.

 METHOD validate_effdate.

  READ ENTITIES OF zi_zmm_milkratecard IN LOCAL MODE
  ENTITY RateCard
  FIELDS ( Effdate ) WITH CORRESPONDING #( keys )
   RESULT DATA(ratedetails).

   loop at ratedetails INTO data(ls_ratedetails).

  get TIME STAMP FIELD data(ts).
  if ls_ratedetails-Effdate < ts.
*     APPEND VALUE #( %tky = ls_ratedetails-%tky ) to failed-ratecard.
  endif.

   endloop.

 ENDMETHOD.

*  METHOD get_instance_features.
*  ENDMETHOD.

*  METHOD UploadExcel.
*
*
*
*  ENDMETHOD.

  METHOD fetchname.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkratecard IN LOCAL MODE
      ENTITY RateCard
        FIELDS ( Plant Sloc Vendor ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

         select SINGLE BPSupplierFullName from i_supplier
         WHERE Supplier = @member-vendor
         into @data(lv_name1).

         select SINGLE StorageLocationName from I_StorageLocation
         WHERE plant = @member-plant
         AND   storagelocation = @member-Sloc
         into @data(lv_sloc).

            MODIFY ENTITIES OF zi_zmm_milkratecard IN LOCAL MODE
                    ENTITY RateCard
                      UPDATE
                        FIELDS ( Name1 Lgobe )
                        WITH VALUE #(
                                      ( %tky = member-%tky
                                        Name1 = lv_name1
                                        Lgobe = lv_sloc
                                        ) ).

    ENDLOOP.


  ENDMETHOD.

  METHOD mandatory_data.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkratecard IN LOCAL MODE
      ENTITY RateCard
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

  LOOP AT members INTO DATA(member).

   if member-plant is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Plant is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-sloc is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Storage Location is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-effdate is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Effective Date is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-matnr is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Material is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-rate is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Rate is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-currency is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Currency is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-FAT is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Fat % is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-snf is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'SNF % is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   if member-milktype is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-RateCard.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Milk Type is Mandatory Entry.' )
                     ) to reported-RateCard.
   endif.

   endloop.

  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
