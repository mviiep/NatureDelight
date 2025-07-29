CLASS lhc_zi_wb_update DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_wb_update RESULT result.

*    METHODS update FOR MODIFY
*      IMPORTING entities FOR UPDATE zi_wb_update.

    METHODS read FOR READ
      IMPORTING keys FOR READ zi_wb_update RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK zi_wb_update.

    METHODS update_truck FOR MODIFY
      IMPORTING keys FOR ACTION zi_wb_update~update_truck RESULT result.

ENDCLASS.

CLASS lhc_zi_wb_update IMPLEMENTATION.
*
  METHOD get_instance_authorizations.
  ENDMETHOD.


METHOD update_truck.

*data:wa_veh type zdt_gate_entry.
  rEAD ENTITIES OF zi_wb_update IN LOCAL MODE
    ENTITY zi_wb_update
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(result_data)
    FAILED DATA(failed_data)
    REPORTED DATA(reported_data).
    READ TABLE keys INTO DATA(wa_key) INDEX 1.

 READ TABLE keys INTO DATA(wa_key1) INDEX 1.
    SELECT SINGLE *             "#EC CI_ALL_FIELDS_NEEDED
        FROM  zi_wb_update       "#EC CI_ALL_FIELDS_NEEDED
        WHERE  gp_no = @wa_key1-gp_no AND
         ebeln = @WA_KEY1-ebeln AND ebelp = @WA_KEY1-ebelp
        INTO  @DATA(wa_main).

IF sy-subrc = 0.
  " Fetch from Z tables
  SELECT SINGLE * FROM zmmt_weigh_bridg    "#EC CI_ALL_FIELDS_NEEDED
    WHERE gp_no = @wa_key-gp_no AND
         ebeln = @WA_KEY1-ebeln AND ebelp = @WA_KEY1-ebelp

    INTO @DATA(wa_zmm).

  SELECT SINGLE * FROM zdt_gate_entry
    WHERE gate_entry_no = @wa_key-gp_no
    INTO @DATA(wa_veh).

   IF sy-subrc = 0.

 wa_zmm-fulltruckunload = abap_true.
       wa_veh-vehicle_out = abap_true.
    wa_zmm-changed_on      = sy-datum.
       MODIFY zmmt_weigh_bridg FROM @wa_zmm.
       MODIFY zdt_gate_entry from  @wa_veh.

ENDIF.
endif.


  ENDMETHOD.

*  METHOD update.
*
*
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.


ENDCLASS.

CLASS lsc_ZI_WB_UPDATE DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZI_WB_UPDATE IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
