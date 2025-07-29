CLASS zcl_wb_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tt_data TYPE TABLE OF zmmt_weigh_bridg.
    METHODS: me_mat_doc
      IMPORTING im_data TYPE tt_data
      EXPORTING ex_data TYPE tt_data.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_WB_DATA IMPLEMENTATION.


  METHOD me_mat_doc.

    DATA:lt_header    TYPE TABLE FOR CREATE i_materialdocumenttp,
         ls_header    LIKE LINE OF lt_header,
         lt_items     TYPE TABLE FOR CREATE i_materialdocumenttp\_materialdocumentitem,
         ls_items     LIKE LINE OF lt_items,
         lv_bwart(3)  TYPE c,
         lv_timestamp TYPE timestamp.

    GET TIME STAMP FIELD lv_timestamp.
    DATA(lv_hid) = |C_{ lv_timestamp }|.


    DATA(lt_tdata) = im_data.

*Prepare the Header for Goods movement
    DATA(ls_tdata) = VALUE #( lt_tdata[ 1 ] OPTIONAL )  .

    DATA(lv_gweight) = ls_tdata-total_wt.
    SORT lt_tdata BY item_wt DESCENDING.
    LOOP AT lt_tdata ASSIGNING FIELD-SYMBOL(<lfs_tdata>).
      <lfs_tdata>-diff_wt = lv_gweight - <lfs_tdata>-item_wt.
      lv_gweight = <lfs_tdata>-item_wt.
    ENDLOOP.

    CLEAR: ls_header.
    ls_header = VALUE #( %cid = lv_hid    "'CID_001'
         goodsmovementcode = '01'
         postingdate = sy-datlo "cl_abap_context_info=>get_system_date(  )
         documentdate = sy-datlo "cl_abap_context_info=>get_system_date(  )
         MaterialDocumentHeaderText = ls_tdata-ebeln

         %control-goodsmovementcode = cl_abap_behv=>flag_changed
         %control-postingdate = cl_abap_behv=>flag_changed
         %control-documentdate = cl_abap_behv=>flag_changed
         %control-MaterialDocumentHeaderText = cl_abap_behv=>flag_changed ).

    APPEND ls_header TO lt_header.
*Prepare the Items for Goods movement
DATA: lv_diff1 TYPE menge_d,
      lv_diff2 TYPE menge_d.

    LOOP AT lt_tdata INTO ls_tdata.
      CLEAR: ls_items.
      DATA(lv_iid) = |CI_{ lv_timestamp }{ sy-tabix }|.
      "Formula to convert Weight from KG to L = Weight in kg / 1.030
      lv_diff1 = ( ls_tdata-diff_wt / 103 ) * 100. " kg TO ltr.

      lv_diff2 = lv_diff1 - ls_tdata-quantity.

*      IF ls_tdata-quantity LT 0.
      IF lv_diff2 EQ 0.
        CONTINUE.
      ENDIF.

      IF lv_diff2 LT 0.
        lv_bwart = '502'.
      ELSE.
        lv_bwart = '501'.
      ENDIF.

      if lv_diff2 lt 0.
        lv_diff2 = -1 * lv_diff2.
      endif.

*      if ls_tdata-charg IS initial.
*       ls_tdata-charg = 'E001131223'.
*      endif.
      ls_items = VALUE #(
         %cid_ref = lv_hid  "'CID_001'
         %target = VALUE #( ( %cid = lv_iid      "'CID_ITM_001'
         plant = ls_tdata-werks                  "'1101'
         material = ls_tdata-matnr               "'000000000000000002'
         goodsmovementtype = lv_bwart            "'501'
         storagelocation = ls_tdata-lgort        "'E001'
         quantityinentryunit = lv_diff2          "ls_tdata-quantity "'10'
         entryunit = ls_tdata-qtyuom             " 'L'
*         GoodsMovementRefDocType = 'B'
         batch = ls_tdata-charg                  "'0000000001'
         %control-plant = cl_abap_behv=>flag_changed
         %control-material = cl_abap_behv=>flag_changed
         %control-goodsmovementtype = cl_abap_behv=>flag_changed
         %control-storagelocation = cl_abap_behv=>flag_changed
         %control-quantityinentryunit = cl_abap_behv=>flag_changed
         %control-entryunit = cl_abap_behv=>flag_changed
         %control-batch = cl_abap_behv=>flag_changed
*         %control-GoodsMovementRefDocType = cl_abap_behv=>flag_changed
         ) )
         ).
      APPEND ls_items TO lt_items.
      clear: lv_diff1, lv_diff2.
    ENDLOOP.


    IF lt_header IS NOT INITIAL
   AND lt_items IS NOT INITIAL.

      MODIFY ENTITIES OF i_materialdocumenttp
         ENTITY materialdocument
         CREATE FROM lt_header
         ENTITY materialdocument
         CREATE BY \_materialdocumentitem
         FROM lt_items
         MAPPED DATA(ls_create_mapped)
         FAILED DATA(ls_create_failed)
         REPORTED DATA(ls_create_reported).

      LOOP AT ls_create_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
        DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
      ENDLOOP.
      LOOP AT ls_create_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
        DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
      ENDLOOP.

      IF lv_result1 IS INITIAL AND lv_result2 IS INITIAL.
      "retrieve the generated
      zbp_i_wb_view=>mapped_material_document-materialdocument = ls_create_mapped-materialdocument.


*        COMMIT ENTITIES BEGIN
*        RESPONSE OF i_materialdocumenttp
*         FAILED DATA(commit_failed)
*         REPORTED DATA(commit_reported).
*
*        LOOP AT commit_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported>).
*          IF <ls_so_reported>-%msg->m_severity = <ls_so_reported>-%msg->severity-error.
*            DATA(lv_result) = <ls_so_reported>-%msg->if_message~get_text( ).
*          ENDIF.
*        ENDLOOP.
*        LOOP AT commit_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_i>).
*          IF <ls_so_reported_i>-%msg->m_severity = <ls_so_reported_i>-%msg->severity-error.
*            DATA(lv_result_i) = <ls_so_reported_i>-%msg->if_message~get_text( ).
*          ENDIF.
*        ENDLOOP.
*
*        IF lv_result IS INITIAL
*       AND lv_result_i IS INITIAL.
*          LOOP AT ls_create_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
*
*            CONVERT KEY OF i_materialdocumenttp
*            FROM <keys_header>-%pid
*            TO <keys_header>-%key.
*
*            LOOP AT LT_TDATA ASSIGNING <lfs_tdata>.
*             <lfs_tdata>-mblnr = <keys_header>-%key-MaterialDocument.
*             <lfs_tdata>-mjahr = <keys_header>-%key-MaterialDocumentYear.
*            ENDLOOP.
*
*          ENDLOOP.
*
**          LOOP AT ls_create_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
**
**            CONVERT KEY OF i_materialdocumentitemtp
**            FROM <keys_item>-%pid
**            TO <keys_item>-%key.
**
***            LOOP AT LT_TDATA ASSIGNING <lfs_tdata>.
***             <lfs_tdata>-mblnr = <keys_item>-%key-MaterialDocument.
***             <lfs_tdata>-mjahr = <keys_item>-%key-MaterialDocumentYear.
****             <lfs_tdata>-zeile = <keys_item>-%key-MaterialDocumentItem.
***            ENDLOOP.
***            out->write( 'Material Doc Item:' ).
***            out->write( <keys_item>-%key ).
**
**          ENDLOOP.
*        ENDIF.
*
*        COMMIT ENTITIES END.
        ex_data = lt_tdata.
      ENDIF.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
