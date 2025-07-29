CLASS lhc_zi_vendor_debit_form_displ DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_vendor_debit_form_display RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_vendor_debit_form_display RESULT result.

    METHODS print_form FOR MODIFY
      IMPORTING keys FOR ACTION zi_vendor_debit_form_display~print_form RESULT result.

ENDCLASS.

CLASS lhc_zi_vendor_debit_form_displ IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print_form.

    READ ENTITIES OF zi_vendor_debit_form_display  IN LOCAL MODE
            ENTITY zi_vendor_debit_form_display
           ALL FIELDS WITH CORRESPONDING #( keys )
           RESULT DATA(lt_result).
    .


    LOOP AT lt_result INTO DATA(lw_result).

      DATA : update_lines TYPE TABLE FOR UPDATE zi_vendor_debit_form_display,
             update_line  TYPE STRUCTURE FOR UPDATE zi_vendor_debit_form_display.

      update_line-%tky                   = lw_result-%tky.
      update_line-pdf               = 'A'. "lv_pdf.
      update_line-accountingdocument               = lw_result-accountingdocument.
      update_line-accountingdoctable          = lw_result-accountingdocument.
      update_line-fiscalyear               = lw_result-fiscalyear.
      update_line-fiscalyeartable              = lw_result-fiscalyear.
*      update_line-pdf              = lw_result-pdf.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF zi_vendor_debit_form_display IN LOCAL MODE
       ENTITY zi_vendor_debit_form_display
         UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
         FIELDS ( pdf accountingdoctable fiscalyeartable )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

      READ ENTITIES OF  zi_vendor_debit_form_display IN LOCAL MODE  ENTITY zi_vendor_debit_form_display
      ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).

      APPEND VALUE #( %tky = keys[ 1 ]-%tky
                      %msg = new_message_with_text(
                      severity = if_abap_behv_message=>severity-success
                      text = 'PDF Generated!' )
                       ) TO reported-zi_vendor_debit_form_display.


    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_vendor_debit_form_displ DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_vendor_debit_form_displ IMPLEMENTATION.

  METHOD save_modified.

    IF update-zi_vendor_debit_form_display IS NOT INITIAL.

      LOOP AT update-zi_vendor_debit_form_display INTO DATA(ls_data).


        DATA(new) = NEW zbg_vendor_debit( iv_accdoc = ls_data-accountingdocument
                                                     iv_fiscal_year  = ls_data-fiscalyear
                                                     ).

        DATA background_process TYPE REF TO if_bgmc_process_single_op.

        TRY.

            background_process = cl_bgmc_process_factory=>get_default( )->create( ).

*         background_process->set_operation( new ).

            background_process->set_operation_tx_uncontrolled( new ).

            background_process->save_for_execution( ).

          CATCH cx_bgmc INTO DATA(exception).

            "handle exception

        ENDTRY.
      ENDLOOP.

    ENDIF.

  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
