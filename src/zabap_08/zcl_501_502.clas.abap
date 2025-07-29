CLASS zcl_501_502 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_501_502 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

*        DELETE FROM ZMMT_WEIGH_BRIDG WHERE gp_no = '1000000021'.
*        commit WORK.
*        out->write( 'Table Deleted' ).

data : address_number type i_customer-AddressID.
cl_address_format=>get_instance( )->printform_postal_addr(
      EXPORTING
*        iv_address_type              = '1'
        iv_address_number            = address_number
*        iv_person_number             =
        iv_language_of_country_field = sy-langu
*        iv_number_of_lines           = 99
*        iv_sender_country            = space
      IMPORTING
        ev_formatted_to_one_line     = DATA(one_line)
        et_formatted_all_lines       = DATA(all_lines)
    ).


*        DELETE FROM ZMM_MILK_MIRO WHERE mirodoc = '5105600111'.
*        commit WORK.
*        out->write( 'Table Deleted' ).

*       DATA : WA_MIRO TYPE ZMM_MILK_MIRO.
*
*        WA_MIRO-mirodoc = '5105600111'.
*        WA_MIRO-miroyear = '2023'.
*        WA_MIRO-LIFNR = '0001000001'.
*        WA_MIRO-NAME1 = 'GOVIND MILK & MILK PRODUCTS PVT LTD.'.
*        WA_MIRO-PLANT = '1101'.
*        WA_MIRO-SLOC = 'E001'.
*        MODIFY ZMM_MILK_MIRO FROM @WA_MIRO.
*        COMMIT WORK.
*        out->write( 'Table Inserted' ).

*        MODIFY ENTITIES OF i_materialdocumenttp
*         ENTITY MaterialDocument
*         CREATE FROM VALUE #( ( %cid = 'CID_001'
*         goodsmovementcode = '01'
*         postingdate = cl_abap_context_info=>get_system_date(  )
*         documentdate = cl_abap_context_info=>get_system_date(  )
*         %control-goodsmovementcode = cl_abap_behv=>flag_changed
*         %control-postingdate = cl_abap_behv=>flag_changed
*         %control-documentdate = cl_abap_behv=>flag_changed
*         ) )
*         ENTITY MaterialDocument
*         CREATE BY \_MaterialDocumentItem
*         FROM VALUE #( (
*         %cid_ref = 'CID_001'
*         %target = VALUE #( ( %cid = 'CID_ITM_001'
*         plant = '1101'
*         material = '000000000000000002'
*         GoodsMovementType = '501'
*         storagelocation = 'E001'
*         QuantityInEntryUnit = '10'
*         entryunit = 'L'
**         GoodsMovementRefDocType = 'B'
*         Batch = '0000000001'
*         %control-plant = cl_abap_behv=>flag_changed
*         %control-material = cl_abap_behv=>flag_changed
*         %control-GoodsMovementType = cl_abap_behv=>flag_changed
*         %control-storagelocation = cl_abap_behv=>flag_changed
*         %control-QuantityInEntryUnit = cl_abap_behv=>flag_changed
*         %control-entryunit = cl_abap_behv=>flag_changed
*         %control-Batch = cl_abap_behv=>flag_changed
**         %control-GoodsMovementRefDocType = cl_abap_behv=>flag_changed
*         ) )
*
*
*         ) )
*         MAPPED DATA(ls_create_mapped)
*         FAILED DATA(ls_create_failed)
*         REPORTED DATA(ls_create_reported).
*
*    LOOP AT ls_create_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
*      DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
*           out->write( 'Header' ).
*           out->write( lv_result1 ).
*    ENDLOOP.
*    LOOP AT ls_create_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
*      DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
*           out->write( 'Item' ).
*           out->write( lv_result2 ).
*    ENDLOOP.
*
*           IF lv_result1 IS INITIAL AND lv_result2 IS INITIAL.
*            COMMIT ENTITIES BEGIN
*            RESPONSE OF i_materialdocumenttp
*             FAILED DATA(commit_failed)
*             REPORTED DATA(commit_reported).
*
*            LOOP AT commit_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported>).
*             IF <ls_so_reported>-%msg->m_severity = <ls_so_reported>-%msg->severity-error.
*              DATA(lv_result) = <ls_so_reported>-%msg->if_message~get_text( ).
*                   out->write( 'Header' ).
*                   out->write( lv_result ).
*             ENDIF.
*            ENDLOOP.
*            LOOP AT commit_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_I>).
*             IF <ls_so_reported_I>-%msg->m_severity = <ls_so_reported_I>-%msg->severity-error.
*              DATA(lv_result_I) = <ls_so_reported_I>-%msg->if_message~get_text( ).
*                   out->write( 'Item' ).
*                   out->write( lv_result_I ).
*             ENDIF.
*            ENDLOOP.
*
*           IF lv_result IS INITIAL AND lv_result_I IS INITIAL.
*            LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
*
*             CONVERT KEY OF i_materialdocumentTp
*             FROM <keys_header>-%pid
*             TO <keys_header>-%key.
*
*               out->write( 'Material Doc Header:' ).
*               out->write( <keys_header>-%key ).
*
*            ENDLOOP.
*
*            LOOP AT ls_create_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
*
*             CONVERT KEY OF i_materialdocumentitemtp
*             FROM <keys_item>-%pid
*             TO <keys_item>-%key.
*
*               out->write( 'Material Doc Item:' ).
*               out->write( <keys_item>-%key ).
*
*            ENDLOOP.
*            ENDIF.
*
*            COMMIT ENTITIES END.
*            ENDIF.

  ENDMETHOD.
ENDCLASS.
