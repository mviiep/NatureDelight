CLASS lhc_billdoc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR billdoc RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR billdoc RESULT result.

    METHODS print FOR MODIFY
      IMPORTING keys FOR ACTION billdoc~print RESULT result.

ENDCLASS.

CLASS lhc_billdoc IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD print.

    READ ENTITIES OF ZI_BILLINGDOCUMENT  IN LOCAL MODE
           ENTITY BillDoc
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).

      DATA : update_lines TYPE TABLE FOR UPDATE ZI_BILLINGDOCUMENT,
             update_line  TYPE STRUCTURE FOR UPDATE ZI_BILLINGDOCUMENT.

      update_line-%tky                   = lw_result-%tky.
      update_line-pdf_data               = 'A'.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF ZI_BILLINGDOCUMENT IN LOCAL MODE
       ENTITY BillDoc
         UPDATE
         FIELDS ( pdf_data )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

      READ ENTITIES OF ZI_BILLINGDOCUMENT IN LOCAL MODE  ENTITY BillDoc
  ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).

    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-success
                    text = 'PDF Generated!' )
                     ) to reported-BillDoc.

    ENDLOOP.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_billingdocument DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_billingdocument IMPLEMENTATION.

  METHOD save_modified.

  if update-billdoc is not initial.

      LOOP AT update-billdoc INTO DATA(LS_data).


        DATA(new) = NEW zcl_bg_process_bill_print( iv_bill = LS_data-BillingDocument ).

        DATA background_process TYPE REF TO if_bgmc_process_single_op.

        TRY.

        background_process = cl_bgmc_process_factory=>get_default( )->create( ).

*         background_process->set_operation( new ).

        background_process->set_operation_tx_uncontrolled( new ).

        background_process->save_for_execution( ).

        CATCH cx_bgmc INTO DATA(exception).

        "handle exception

        ENDTRY.
      endloop.

  endif.


  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
