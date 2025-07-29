CLASS lhc_zi_billinginv DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_billinginv RESULT result.

    METHODS CreateIRN FOR MODIFY
      IMPORTING keys FOR ACTION zi_billinginv~CreateIRN RESULT result.

ENDCLASS.

CLASS lhc_zi_billinginv IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD CreateIRN.

  data: lt_data TYPE TABLE FOR update zi_billinginv.

  TYPES: BEGIN OF ty_msg,
          typ(1)   type c,
          vbeln type zchar10,
          msg(100)   type c,
         END OF ty_msg.
  data : lt_msg type STANDARD TABLE OF ty_msg,
         ls_msg type ty_msg.

    READ ENTITIES OF zi_billinginv IN LOCAL MODE
          ENTITY zi_billinginv
            ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(members).

    DATA(lt_keys) = keys.
   DATA : obj_data TYPE REF TO zcl_cleartax_einvvoice,
          LS_RES TYPE string,
          LV_STATUS TYPE C.

    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs>).
     CREATE OBJECT obj_data.
     obj_data->generate_irn(
           EXPORTING im_vbeln     = <fs>-BillingDocument
           IMPORTING ex_response  = LS_RES
                     EX_STATUS    = LV_STATUS ).

      if LV_STATUS = 'E'.
        ls_msg-typ   = 'E'.
        ls_msg-vbeln = <fs>-BillingDocument.
        ls_msg-msg = 'Error while generating IRN'.
        append ls_msg to lt_msg.
        clear ls_msg.
*        reported-zi_billinginv = VALUE #(
*           ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-error
*                                           text = 'Error while generating IRN' ) ) ).
      else.

      lt_data = VALUE #( (  "%cid = 'C1'
                            BillingDocument = <fs>-BillingDocument
                            irn = 'X'
                            %control = VALUE #(
                                               BillingDocument = if_abap_behv=>mk-on
                                               irn = if_abap_behv=>mk-on
                                                ) ) ).

      MODIFY ENTITIES OF zi_billinginv
        ENTITY zi_billinginv UPDATE FROM lt_data
        MAPPED DATA(it_mapped)
        FAILED DATA(it_failed)
        REPORTED DATA(it_reported).

        ls_msg-typ   = 'S'.
        ls_msg-vbeln = <fs>-BillingDocument.
        ls_msg-msg = 'IRN Generated Succesfully'.
        append ls_msg to lt_msg.
        clear ls_msg.
*        reported-zi_billinginv = VALUE #(
*           ( %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
*                                           text = 'IRN Generated Succesfully' ) ) ).
      endif.

    ENDLOOP.

    loop at lt_msg into ls_msg.
     if ls_msg-typ = 'S'.
      APPEND VALUE #(   %cid = ls_msg-vbeln
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                           text = 'IRN Generated Succesfully' )
                              %element = VALUE #(  IRN  = if_abap_behv=>mk-on  ) )
                              TO reported-zi_billinginv.
     elseif ls_msg-typ = 'E'.
      APPEND VALUE #(   %cid = ls_msg-vbeln
                        %msg = new_message_with_text( severity = if_abap_behv_message=>severity-success
                                           text = 'Error while generating IRN' )
                              %element = VALUE #(  IRN  = if_abap_behv=>mk-off  ) )
                              TO reported-zi_billinginv.
     endif.

*      reported-zi_billinginv
    endloop.


  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_billinginv DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_billinginv IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
