CLASS zclbg_delete_ratecard DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLBG_DELETE_RATECARD IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

" Return the supported selection parameters here
et_parameter_def = VALUE #(
  ( selname = 'P_PLANT' kind = if_apj_dt_exec_object=>parameter
    datatype = 'C' length = 4
    mandatory_ind = ABAP_TRUE
    param_text  = 'Plant' changeable_ind = abap_true )

  ( selname = 'S_SLOC' kind = if_apj_dt_exec_object=>select_option
    datatype = 'C' length = 4
    mandatory_ind = ABAP_FALSE
    param_text  = 'Storage Loc' changeable_ind = abap_true )

  ( selname = 'S_DATE' kind = if_apj_dt_exec_object=>select_option
    datatype = 'D'
    mandatory_ind = ABAP_TRUE
    param_text  = 'Effective Date' changeable_ind = abap_true )
  ).


" Return the default parameters values here
*et_parameter_val = VALUE #(
*  ( selname = 'P_PLANT' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '1102' )
*  ( selname = 'P_SLOC' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '' )
*  ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    DATA : r_date TYPE RANGE OF datum,
           s_date LIKE LINE OF r_date,
           p_date TYPE datum.
  DATA : P_PLANT TYPE C LENGTH 4,
         P_SLOC TYPE C LENGTH 4,
         R_SLOC  LIKE RANGE OF P_SLOC,
         S_SLOC  LIKE LINE OF R_SLOC.

TYPES : BEGIN OF ty_msg,
         MSGTYPE(1)  TYPE C,
         msg(200)    type c,
        END OF ty_msg.

data : it_msg type STANDARD TABLE OF ty_msg,
       wa_msg type ty_msg.

     DATA LV_MSG TYPE C LENGTH 200.

" Getting the actual parameter values(Just for show. Not needed for the logic below)
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_PLANT'.
         p_PLANT = ls_parameter-low.
        WHEN 'S_SLOC'.
         S_SLOC-SIGN   = ls_parameter-SIGN.
         S_SLOC-OPTION = ls_parameter-OPTION.
         S_SLOC-LOW    = ls_parameter-low.
         S_SLOC-HIGH   = ls_parameter-HIGH.
         APPEND S_SLOC TO R_SLOC.
         CLEAR S_SLOC.
        WHEN 'S_DATE'.
          s_date-sign   = ls_parameter-sign.
          s_date-option = ls_parameter-option.
          s_date-low    = ls_parameter-low.
          s_date-high   = ls_parameter-high.
          APPEND s_date TO r_date.
*          CLEAR s_date.
      ENDCASE.
    ENDLOOP.

  IF P_PLANT IS NOT INITIAL AND
     R_DATE[] IS NOT INITIAL.

    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
               'ZMILK_MIRO' subobject = 'ZMILK_MIRO_SUB' ) ).

*     LV_MSG = 'Job Started'.
        CONCATENATE 'Job Started' s_date-low s_date-high INTO lv_msg SEPARATED BY ''.

        DATA(l_free_text) = cl_bali_free_text_setter=>create( severity =
                            if_bali_constants=>c_severity_status
                            text = lv_msg ).
        l_log->add_item( item = l_free_text ).
        "Save the log into the database
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
        COMMIT WORK.


        SELECT FROM zmm_milkratecard
        FIELDS id, plant, sloc, lgobe, vendor, name1, effdate, milk_type
        WHERE PLANT = @P_PLANT
        AND   SLOC IN @R_SLOC
        AND   EFFDATE IN @R_DATE
        INTO TABLE @DATA(LT_DATA).


        LOOP AT LT_DATA INTO DATA(LS_DATA).
         DELETE FROM zmm_milkratecard WHERE ID = @LS_DATA-ID.
         IF SY-SUBRC = 0.
           COMMIT WORK.
           wa_msg-msgtype = 'S'.
           CONCATENATE 'Deleted: ' LS_DATA-plant LS_DATA-SLOC LS_DATA-lgobe
           LS_DATA-vendor LS_DATA-name1
           LS_DATA-milk_type LS_DATA-milk_type LS_DATA-effdate
           INTO WA_MSG-msg SEPARATED BY ' | '.
           append wa_msg to it_msg.
           clear wa_msg.
         ELSE.
           ROLLBACK WORK.
           wa_msg-msgtype = 'E'.
           CONCATENATE 'Error: ' LS_DATA-plant LS_DATA-SLOC LS_DATA-lgobe
           LS_DATA-vendor LS_DATA-name1
           LS_DATA-milk_type LS_DATA-milk_type LS_DATA-effdate
           INTO WA_MSG-msg SEPARATED BY ' | '.
           append wa_msg to it_msg.
           clear wa_msg.
         ENDIF.
        ENDLOOP.

        LOOP AT it_msg INTO wa_msg.

          lv_msg = wa_msg-msg.

          l_free_text = cl_bali_free_text_setter=>create( severity = wa_msg-msgtype
*                            if_bali_constants=>c_severity_ status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDLOOP.

        IF it_msg[] IS NOT INITIAL.

          lv_msg = 'Job Completed'.
          l_free_text = cl_bali_free_text_setter=>create( severity =
                              if_bali_constants=>c_severity_status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDIF.


        IF LT_DATA[] IS INITIAL.
          lv_msg = 'No Data Found'.
          l_free_text = cl_bali_free_text_setter=>create( severity =
                              if_bali_constants=>c_severity_warning
                              text = lv_msg ).
          l_log->add_item( item = l_free_text ).
          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDIF.



      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
    ENDTRY.

  ENDIF.


  ENDMETHOD.
ENDCLASS.
