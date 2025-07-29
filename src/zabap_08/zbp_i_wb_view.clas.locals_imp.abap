CLASS lsc_zi_wb_view DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_wb_view IMPLEMENTATION.

  METHOD save_modified.

    DATA : lv_timestamp TYPE timestamp,
           lv_diff1     TYPE menge_d.

    GET TIME STAMP FIELD lv_timestamp.

    IF update IS NOT INITIAL.
      IF zbp_i_wb_view=>mapped_material_document IS NOT INITIAL.
        LOOP AT zbp_i_wb_view=>mapped_material_document-materialdocument ASSIGNING FIELD-SYMBOL(<fs_md_mapped>).
          CONVERT KEY OF i_materialdocumenttp FROM <fs_md_mapped>-%pid TO DATA(ls_md_key).
          <fs_md_mapped>-materialdocument = ls_md_key-materialdocument.
          <fs_md_mapped>-materialdocumentyear = ls_md_key-materialdocumentyear.
        ENDLOOP.
      ENDIF.

      SELECT *
      FROM zmmt_weigh_bridg
      FOR ALL ENTRIES IN @update-bd_zi_wb
      WHERE gp_no EQ @update-bd_zi_wb-gatepass_no
        AND ebeln EQ @update-bd_zi_wb-purchaseorder
      INTO TABLE @DATA(lt_tdata).

      SORT lt_tdata BY item_wt DESCENDING.
      DATA(lv_gweight) = VALUE #( lt_tdata[ 1 ]-total_wt OPTIONAL ).

      LOOP AT lt_tdata ASSIGNING FIELD-SYMBOL(<lfs_data>).
        IF <lfs_data>-ebeln IS NOT INITIAL.
          CLEAR lv_diff1.
          <lfs_data>-fulltruckunload = abap_true.

          <lfs_data>-diff_wt = lv_gweight - <lfs_data>-item_wt.
          lv_gweight = <lfs_data>-item_wt.

          lv_diff1 = ( <lfs_data>-diff_wt / 103 ) * 100. " kg TO ltr.

          <lfs_data>-diff_wt = lv_diff1 - <lfs_data>-quantity.

          <lfs_data>-mblnr = ls_md_key-materialdocument.

          <lfs_data>-mjahr = ls_md_key-materialdocumentyear.
        ELSE.
          <lfs_data>-fulltruckunload = abap_true.
        ENDIF.

        <lfs_data>-changed_by = cl_abap_context_info=>get_user_alias( ).

        <lfs_data>-changed_on = lv_timestamp.
      ENDLOOP.

      LOOP AT update-bd_zi_wb INTO DATA(ls_zi_wb). " WHERE %control-OverallStatus = if_abap_behv=>mk-on.
        " Creates internal table with instance data
*      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
*      UPDATE zmmt_weigh_bridg SET fulltruckunload = @abap_true,
*                                  mblnr = @ls_md_key-MaterialDocument,
*                                  mjahr = @ls_md_key-MaterialDocumentYear
*       WHERE gp_no = @ls_zi_wb-gatepass_no.
        UPDATE zmmt_weigh_bridg FROM TABLE @lt_tdata.
      ENDLOOP.

    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_bd_zi_wb DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR bd_zi_wb RESULT result.
    METHODS savedata FOR MODIFY
      IMPORTING keys FOR ACTION bd_zi_wb~savedata RESULT result.
    METHODS fulltruckunload FOR MODIFY
      IMPORTING keys FOR ACTION bd_zi_wb~fulltruckunload RESULT result.
    METHODS outboundprocess FOR MODIFY
      IMPORTING keys FOR ACTION bd_zi_wb~outboundprocess RESULT result.

ENDCLASS.

CLASS lhc_bd_zi_wb IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD savedata.
    DATA(lt_keys) = keys.
    DATA: lt_cdata     TYPE TABLE FOR CREATE zi_wb_tview, "zmmt_weigh_bridg
          ls_cdata     LIKE LINE OF lt_cdata,
          lt_udata     TYPE TABLE FOR UPDATE zi_wb_tview, "zmmt_weigh_bridg
          ls_udata     LIKE LINE OF lt_udata,
          lt_ddata     TYPE TABLE FOR DELETE zi_wb_tview, "zmmt_weigh_bridg
          ls_ddata     LIKE LINE OF lt_udata,
          obj_data     TYPE REF TO zcl_mm_wb_data_class,
          ls_rdata     TYPE STRUCTURE FOR READ RESULT zi_wb_view,
          lv_timestamp TYPE timestamp.

*   Read Keys
    DATA(ls_key) = VALUE #( lt_keys[ 1 ] ).

    GET TIME STAMP FIELD lv_timestamp.

    DATA(lv_tid) = |C_{ lv_timestamp }|.
    DATA(lv_did) = |D_{ lv_timestamp }|.

    SELECT SINGLE *
    FROM zmmt_weigh_bridg
    WHERE gp_no EQ @ls_key-gatepass_no
      AND ebeln EQ @ls_key-purchaseorder
      AND ebelp EQ @ls_key-purchaseorderitem
    INTO @DATA(ls_tdata).
*    IF ls_tdata IS NOT INITIAL.
**     Delete the existing entry
*      MODIFY ENTITIES OF zi_wb_tview "IN LOCAL MODE
*      ENTITY bd_tview
*      DELETE FROM VALUE #(  ( gatepass_no = ls_key-gatepass_no
*                             PurchaseOrder = ls_key-purchaseorder
*                             PurchaseOrderItem = ls_key-purchaseorderitem
**                             TotalWeight = ls_tdata-total_wt
**                             ItemWeight = ls_tdata-item_wt
**                             DiffWeight = ls_tdata-diff_wt
*                             ) )
*      MAPPED DATA(it_dmapped)
*      FAILED DATA(it_dfailed)
*      REPORTED DATA(it_dreported).
*      if  it_dfailed is initial.
*       clear ls_tdata.
*      endif.
*    ENDIF.
    IF ls_tdata IS INITIAL. "CREATE
*   IF the entry read is not in Custom table
*   Make internal table for create
      CLEAR: ls_cdata.
      IF  obj_data IS NOT BOUND.
        CREATE OBJECT obj_data.
      ENDIF.
      obj_data->me_get_data(
            EXPORTING
              iv_gp_no = ls_key-gatepass_no
            IMPORTING
              et_data  = DATA(lt_sdata)
          ).
      DATA(ls_sdata) = VALUE #( lt_sdata[ gp_no = ls_key-gatepass_no ebeln = ls_key-purchaseorder ebelp = ls_key-purchaseorderitem ] OPTIONAL ).

      ls_cdata = VALUE #( %cid = lv_tid " 'C1'
      gatepass_no = ls_key-gatepass_no
      %control-gatepass_no = if_abap_behv=>mk-on
      purchaseorder = ls_key-purchaseorder
      %control-purchaseorder = if_abap_behv=>mk-on
      purchaseorderitem = ls_key-purchaseorderitem
      %control-purchaseorderitem = if_abap_behv=>mk-on
      entrytype = ls_sdata-entry_type
      %control-entrytype = if_abap_behv=>mk-on
      storagelocation = ls_sdata-lgort
      %control-storagelocation = if_abap_behv=>mk-on
      quantity    = ls_sdata-orderquantity
      %control-quantity = if_abap_behv=>mk-on
      quantityuom = ls_sdata-purchaseorderquantityunit
      %control-quantityuom = if_abap_behv=>mk-on
      batch = ls_sdata-charg
      %control-batch = if_abap_behv=>mk-on
      chilcenter = ls_sdata-chillingcenter
      %control-chilcenter = if_abap_behv=>mk-on
      compartment = ls_sdata-compartment
      %control-compartment = if_abap_behv=>mk-on
      totalweight = ls_sdata-total_wt
      %control-totalweight = if_abap_behv=>mk-on
      itemweight = ls_sdata-item_wt
      %control-itemweight = if_abap_behv=>mk-on
      diffweight = ls_sdata-diff_wt
      %control-diffweight = if_abap_behv=>mk-on
      tareweight = ls_sdata-tare_wt
      %control-tareweight = if_abap_behv=>mk-on
      weightunit = ls_sdata-weight_unit
      %control-weightunit = if_abap_behv=>mk-on
      trucksheetno = ls_sdata-trucksheet_no
      %control-trucksheetno = if_abap_behv=>mk-on
      createdby = cl_abap_context_info=>get_user_alias( )
      %control-createdby = if_abap_behv=>mk-on
      createdon = lv_timestamp
      %control-createdon = if_abap_behv=>mk-on
                                             ) .
      APPEND ls_cdata TO lt_cdata.
    ELSE.   "UPDATE
*   ELSE then make internal table for update
      CLEAR ls_udata.
      ls_udata = VALUE #( "%cid_ref = lv_tid
      gatepass_no = ls_key-gatepass_no
     " %control-gatepass_no = if_abap_behv=>mk-on
      purchaseorder = ls_key-purchaseorder
      "%control-purchaseorder = if_abap_behv=>mk-on
      purchaseorderitem = ls_key-purchaseorderitem
      "%control-purchaseorderitem = if_abap_behv=>mk-on
      entrytype = ls_tdata-entry_type
      %control-entrytype = if_abap_behv=>mk-on
      storagelocation = ls_tdata-lgort
      %control-storagelocation = if_abap_behv=>mk-on
      quantity    = ls_tdata-quantity
      %control-quantity = if_abap_behv=>mk-on
      quantityuom = ls_tdata-qtyuom
      %control-quantityuom = if_abap_behv=>mk-on
      batch = ls_tdata-charg
      %control-batch = if_abap_behv=>mk-on
      chilcenter = ls_tdata-yy1_chillingcenter_pdi
      %control-chilcenter = if_abap_behv=>mk-on
      compartment = ls_tdata-yy1_compartment_pdi
      %control-compartment = if_abap_behv=>mk-on
      totalweight = ls_tdata-total_wt
      %control-totalweight = if_abap_behv=>mk-on
      itemweight = ls_tdata-item_wt
      %control-itemweight = if_abap_behv=>mk-on
      diffweight = ls_tdata-diff_wt
      %control-diffweight = if_abap_behv=>mk-on
      tareweight = ls_tdata-tare_wt
      %control-tareweight = if_abap_behv=>mk-on
      weightunit = ls_tdata-weight_unit
      %control-weightunit = if_abap_behv=>mk-on
      trucksheetno = ls_tdata-trucksheet_no
      %control-trucksheetno = if_abap_behv=>mk-on
      createdby = ls_tdata-created_by
      %control-createdby = if_abap_behv=>mk-off
      createdon = ls_tdata-created_on
      %control-createdon = if_abap_behv=>mk-off
      changedby = cl_abap_context_info=>get_user_alias( )
      %control-changedby = if_abap_behv=>mk-on
      changedon = lv_timestamp
      %control-changedon = if_abap_behv=>mk-on
                                             ) .
      APPEND ls_udata TO lt_udata.
    ENDIF.
*   prepare result failed response
    IF lt_cdata IS NOT INITIAL.

      MODIFY ENTITIES OF zi_wb_tview "IN LOCAL MODE
      ENTITY bd_tview
      CREATE FROM lt_cdata
      MAPPED DATA(it_mapped)
      FAILED DATA(it_failed)
      REPORTED DATA(it_reported).

      IF it_failed IS INITIAL.
*        COMMIT ENTITIES
*        RESPONSE OF zi_wb_view
*        FAILED DATA(lt_cmtfailed)
*        REPORTED DATA(lt_cmtreported).

        "Read the changed data for action result
        READ ENTITIES OF zi_wb_tview "IN LOCAL MODE
          ENTITY bd_tview
            ALL FIELDS WITH
            CORRESPONDING #( keys )
          RESULT DATA(result_read).

        "Return result entitis
        LOOP AT result_read INTO DATA(ls_res).
          CLEAR: ls_rdata.
          ls_rdata-gatepass_no = ls_key-gatepass_no.
          ls_rdata-purchaseorder = ls_key-purchaseorder.
          ls_rdata-purchaseorderitem = ls_key-purchaseorderitem.
*          ls_rdata-totalweight = ls_key-totalweight.
*          ls_rdata-itemweight = ls_key-itemweight.
*          ls_rdata-diffweight = ls_key-diffweight.

          result = VALUE #( ( %cid_ref = lv_tid
                            gatepass_no = ls_key-gatepass_no
                            purchaseorder = ls_key-purchaseorder
                            purchaseorderitem = ls_key-purchaseorderitem
*                            totalweight = ls_key-totalweight
*                            itemweight = ls_key-itemweight
*                            diffweight = ls_key-diffweight
                            %param = ls_rdata ) ).
        ENDLOOP.
      ENDIF.
    ELSEIF lt_udata IS NOT INITIAL.

      MODIFY ENTITIES OF zi_wb_tview "IN LOCAL MODE
      ENTITY bd_tview
      UPDATE FROM lt_udata
      MAPPED it_mapped
      FAILED it_failed
      REPORTED it_reported.

      IF it_failed IS INITIAL.
*        COMMIT ENTITIES
*        RESPONSE OF zi_wb_view
*        FAILED lt_cmtfailed
*        REPORTED lt_cmtreported.
        "Read the changed data for action result
        CLEAR: result_read.
        READ ENTITIES OF zi_wb_tview " IN LOCAL MODE
          ENTITY bd_tview
          ALL FIELDS WITH
            CORRESPONDING #( keys )
          RESULT result_read.

        "Return result entitis
        LOOP AT result_read INTO ls_res.
          CLEAR: ls_rdata.
          ls_rdata-gatepass_no = ls_key-gatepass_no.
          ls_rdata-purchaseorder = ls_key-purchaseorder.
          ls_rdata-purchaseorderitem = ls_key-purchaseorderitem.
*          ls_rdata-totalweight = ls_key-totalweight.
*          ls_rdata-itemweight = ls_key-itemweight.
*          ls_rdata-diffweight = ls_key-diffweight.

          result = VALUE #( ( %cid_ref = lv_tid
                            gatepass_no = ls_key-gatepass_no
                            purchaseorder = ls_key-purchaseorder
                            purchaseorderitem = ls_key-purchaseorderitem
*                            totalweight = ls_key-totalweight
*                            itemweight = ls_key-itemweight
*                            diffweight = ls_key-diffweight
                            %param = ls_rdata )  ).
        ENDLOOP.
      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD fulltruckunload.
    DATA(lt_keys) = keys.
    DATA: lt_cdata     TYPE TABLE FOR CREATE zi_wb_tview, "zmmt_weigh_bridg
          ls_cdata     LIKE LINE OF lt_cdata,
          lt_udata     TYPE TABLE FOR UPDATE zi_wb_view, "zmmt_weigh_bridg
          ls_udata     LIKE LINE OF lt_udata,
          obj_data     TYPE REF TO zcl_mm_wb_data_class,
          ls_rdata     TYPE STRUCTURE FOR READ RESULT zi_wb_view,
          lv_timestamp TYPE timestamp,
          lo_obj       TYPE REF TO zcl_wb_data.


*   Read Keys
    DATA(ls_key) = VALUE #( lt_keys[ 1 ] ).

    GET TIME STAMP FIELD lv_timestamp.
    DATA(lv_tid) = |C_{ lv_timestamp }|.

    SELECT *
    FROM zmmt_weigh_bridg
    WHERE gp_no EQ @ls_key-gatepass_no
      AND ebeln EQ @ls_key-purchaseorder
    INTO TABLE @DATA(lt_tdata).

    IF ls_key-purchaseorder IS NOT INITIAL
    AND lt_tdata IS NOT INITIAL.
      IF lo_obj IS NOT BOUND.
        CREATE OBJECT lo_obj.
      ENDIF.
      lo_obj->me_mat_doc(
        EXPORTING
          im_data = lt_tdata
        IMPORTING
          ex_data = DATA(lt_edata)
      ).
    ELSEIF ls_key-purchaseorder IS INITIAL
    AND lt_tdata IS NOT INITIAL.
      lt_edata = lt_tdata.
    ENDIF.
    "set a flag to check in the save sequence that purchase requisition has been created
    "the correct value for PurchaseRequisition has to be calculated in the save sequence using convert key
*    DATA: update_line like line of update_lines.
*    LOOP AT keys INTO DATA(key).
*      IF line_exists( members[ id = key-ID ] ).
**        update_line-DirtyFlag              = abap_true.
*        update_line-%tky    = key-%tky.
*        update_line-Mblnr   = 'X'.
*        APPEND update_line TO update_lines.
*      ENDIF.
*    ENDLOOP.
    SORT lt_edata BY ebeln ebelp ASCENDING.


    LOOP AT lt_edata INTO DATA(ls_tdata).
      CLEAR: ls_udata.
      ls_udata = VALUE #( "%cid_ref = lv_tid

      gatepass_no = ls_key-gatepass_no
     " %control-gatepass_no = if_abap_behv=>mk-on

      purchaseorder = ls_key-purchaseorder
      "%control-purchaseorder = if_abap_behv=>mk-on

      purchaseorderitem = ls_tdata-ebelp
      "%control-purchaseorderitem = if_abap_behv=>mk-on

      fulltruckunload = abap_true
      %control-fulltruckunload = if_abap_behv=>mk-on

      diffweight = ls_tdata-diff_wt
      %control-diffweight = if_abap_behv=>mk-on

      materialdocument = abap_true "ls_tdata-mblnr
      %control-materialdocument = if_abap_behv=>mk-on

      materialdocumentyear = ls_tdata-mjahr
      %control-materialdocumentyear = if_abap_behv=>mk-on

      materialdocumentitem = ls_tdata-zeile
      %control-materialdocumentitem = if_abap_behv=>mk-off

      changedby = cl_abap_context_info=>get_user_alias( )
      %control-changedby = if_abap_behv=>mk-on
      changedon = lv_timestamp
      %control-changedon = if_abap_behv=>mk-on
                                             ) .
      APPEND ls_udata TO lt_udata.
    ENDLOOP.

    IF lt_udata IS NOT INITIAL.

      MODIFY ENTITIES OF zi_wb_view IN LOCAL MODE
      ENTITY bd_zi_wb
      UPDATE FROM lt_udata
      MAPPED DATA(it_mapped)
      FAILED DATA(it_failed)
      REPORTED DATA(it_reported).

      IF it_failed IS INITIAL.
*        COMMIT ENTITIES
*        RESPONSE OF zi_wb_view
*        FAILED lt_cmtfailed
*        REPORTED lt_cmtreported.
        "Read the changed data for action result

        READ ENTITIES OF zi_wb_view IN LOCAL MODE
          ENTITY bd_zi_wb
            ALL FIELDS WITH
            CORRESPONDING #( keys )
          RESULT DATA(result_read).
*
*        "Return result entitis
        result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                                  %param = result_order ) ).
*        LOOP AT result_read INTO DATA(ls_res).
*        clear: ls_rdata.
*        ls_rdata-gatepass_no = ls_key-gatepass_no.
*        ls_rdata-purchaseorder = ls_key-purchaseorder.
*        ls_rdata-purchaseorderitem = ls_key-purchaseorderitem.
**        ls_rdata-totalweight = ls_key-totalweight.
**        ls_rdata-itemweight = ls_key-itemweight.
**        ls_rdata-diffweight = ls_key-diffweight.
*
*        result = VALUE #( ( %cid_ref = lv_tid
*                          gatepass_no = ls_key-gatepass_no
*                          purchaseorder = ls_key-purchaseorder
*                          purchaseorderitem = ls_key-purchaseorderitem
**                          totalweight = ls_key-totalweight
**                          itemweight = ls_key-itemweight
**                          diffweight = ls_key-diffweight
*                          %param = ls_rdata )  ).
*        ENDLOOP.
      ENDIF.

    ENDIF.


  ENDMETHOD.

  METHOD outboundprocess.
    DATA(lt_keys) = keys.
    DATA: lt_cdata     TYPE TABLE FOR CREATE zi_wb_tview, "zmmt_weigh_bridg
          ls_cdata     LIKE LINE OF lt_cdata,
          lt_udata     TYPE TABLE FOR UPDATE zi_wb_tview, "zmmt_weigh_bridg
          ls_udata     LIKE LINE OF lt_udata,
          obj_data     TYPE REF TO zcl_mm_wb_data_class,
          ls_rdata     TYPE STRUCTURE FOR READ RESULT zi_wb_view,
          lv_timestamp TYPE timestamp,
          lo_obj       TYPE REF TO zcl_wb_data.


*   Read Keys
    DATA(ls_key) = VALUE #( lt_keys[ 1 ] ).

    GET TIME STAMP FIELD lv_timestamp.
    DATA(lv_tid) = |C_{ lv_timestamp }|.

    SELECT SINGLE *
    FROM zmmt_weigh_bridg
    WHERE gp_no EQ @ls_key-gatepass_no
    INTO @DATA(ls_tdata).

*    SELECT FROM zsdt_truckshet_i
*    FIELDS trucksheet_no,
*           trucksheet_item,
*           vbeln
*     WHERE trucksheet_no EQ @ls_tdata-trucksheet_no
*       and vbeln is not initial
*     INTO TABLE @DATA(lt_invoice).
*
*    IF lt_invoice[] IS NOT INITIAL.
*      SELECT BillingDocument, BillingDocumentItem, ItemGrossWeight
*        FROM i_billingdocumentitembasic
*        FOR ALL ENTRIES IN @lt_invoice
*      where BillingDocument EQ @lt_invoice-vbeln
*      into TABLE @data(lt_billing).

    SELECT a~trucksheet_no, a~trucksheet_item, a~vbeln,
           b~BillingDocument, b~BillingDocumentItem, b~ItemGrossWeight
           FROM zsdt_truckshet_i as a
           join i_billingdocumentitembasic as b
           on ( a~vbeln = b~BillingDocument )
     WHERE a~trucksheet_no EQ @ls_tdata-trucksheet_no
       and a~vbeln is not initial
     INTO TABLE @DATA(lt_billing).


      DATA(lv_twt) = VALUE #( lt_billing[ 1 ]-ItemGrossWeight OPTIONAL ).
      clear lv_twt.
      LOOP AT lt_billing INTO DATA(ls_billing).
        lv_twt = lv_twt + ls_billing-ItemGrossWeight.
      ENDLOOP.

*    ENDIF.

    ls_tdata-tsheet_wt = lv_twt.
    ls_tdata-diff_wt = ls_tdata-total_wt - ls_tdata-tare_wt - ls_tdata-tsheet_wt.
    ls_tdata-diff_wt = ( ls_tdata-diff_wt / 103 ) * 100.
    CLEAR: ls_udata.
      ls_udata = VALUE #( "%cid_ref = lv_tid

      gatepass_no = ls_key-gatepass_no
     " %control-gatepass_no = if_abap_behv=>mk-on

      purchaseorder = ls_key-purchaseorder
      "%control-purchaseorder = if_abap_behv=>mk-on

      purchaseorderitem = ls_tdata-ebelp
      "%control-purchaseorderitem = if_abap_behv=>mk-on

      fulltruckunload = abap_true
      %control-fulltruckunload = if_abap_behv=>mk-on


      diffweight = ls_tdata-diff_wt
      %control-diffweight = if_abap_behv=>mk-on

      TrucksheetWeight = ls_tdata-tsheet_wt
      %control-TrucksheetWeight = if_abap_behv=>mk-on

*      materialdocument = abap_true "ls_tdata-mblnr
*      %control-materialdocument = if_abap_behv=>mk-on

*      materialdocumentyear = ls_tdata-mjahr
*      %control-materialdocumentyear = if_abap_behv=>mk-on

*      materialdocumentitem = ls_tdata-zeile
*      %control-materialdocumentitem = if_abap_behv=>mk-off

      changedby = cl_abap_context_info=>get_user_alias( )
      %control-changedby = if_abap_behv=>mk-on
      changedon = lv_timestamp
      %control-changedon = if_abap_behv=>mk-on
                                             ) .
      APPEND ls_udata TO lt_udata.

       IF lt_udata IS NOT INITIAL.

      MODIFY ENTITIES OF zi_wb_tview "IN LOCAL MODE
      ENTITY bd_tview
      UPDATE FROM lt_udata
      MAPPED DATA(it_mapped)
      FAILED DATA(it_failed)
      REPORTED DATA(it_reported).

      IF it_failed IS INITIAL.
*        COMMIT ENTITIES
*        RESPONSE OF zi_wb_view
*        FAILED lt_cmtfailed
*        REPORTED lt_cmtreported.
        "Read the changed data for action result

        READ ENTITIES OF zi_wb_view IN LOCAL MODE
          ENTITY bd_zi_wb
            ALL FIELDS WITH
            CORRESPONDING #( keys )
          RESULT DATA(result_read).
*
*        "Return result entitis
        result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                                  %param = result_order ) ).
*        LOOP AT result_read INTO DATA(ls_res).
*        clear: ls_rdata.
*        ls_rdata-gatepass_no = ls_key-gatepass_no.
*        ls_rdata-purchaseorder = ls_key-purchaseorder.
*        ls_rdata-purchaseorderitem = ls_key-purchaseorderitem.
**        ls_rdata-totalweight = ls_key-totalweight.
**        ls_rdata-itemweight = ls_key-itemweight.
**        ls_rdata-diffweight = ls_key-diffweight.
*
*        result = VALUE #( ( %cid_ref = lv_tid
*                          gatepass_no = ls_key-gatepass_no
*                          purchaseorder = ls_key-purchaseorder
*                          purchaseorderitem = ls_key-purchaseorderitem
**                          totalweight = ls_key-totalweight
**                          itemweight = ls_key-itemweight
**                          diffweight = ls_key-diffweight
*                          %param = ls_rdata )  ).
*        ENDLOOP.
      ENDIF.

    ENDIF.




  ENDMETHOD.

ENDCLASS.
