CLASS lhc__vwb DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _vwb RESULT result.
    METHODS savedata FOR MODIFY
      IMPORTING keys FOR ACTION _vwb~savedata RESULT result.

ENDCLASS.

CLASS lhc__vwb IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD savedata.
    DATA: lt_data  TYPE TABLE FOR CREATE zi_weigh_bridge, "zmmt_weighbridge
          ls_data  LIKE LINE OF lt_data,
          lt_tdata TYPE TABLE OF zmmt_weighbridge,
          ls_tdata TYPE zmmt_weighbridge,
          lv_timestamp TYPE timestamp.

    READ ENTITIES OF zi_v_weigh_bridge IN LOCAL MODE
              ENTITY _vwb
          ALL FIELDS WITH CORRESPONDING #( keys )
              RESULT DATA(members).
    get TIME STAMP FIELD lv_timestamp.
    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs_member>).

      ls_data = VALUE #(   "%cid =  'C1'
                           purchaseorder = <fs_member>-ebeln
                           %control-purchaseorder = if_abap_behv=>mk-on
                           purchaseorderitem = <fs_member>-ebelp
                           %control-purchaseorderitem = if_abap_behv=>mk-on
                           storagelocation = <fs_member>-lgort
                           %control-storagelocation = if_abap_behv=>mk-on
                           quantity    = <fs_member>-quantity
                           %control-quantity = if_abap_behv=>mk-on
                           quantityuom = <fs_member>-quantityuom
                           %control-quantityuom = if_abap_behv=>mk-on
                           chilcenter = <fs_member>-chilcenter
                           %control-chilcenter = if_abap_behv=>mk-on
                           compartment = <fs_member>-compartment
                           %control-compartment = if_abap_behv=>mk-on
                           totalweight = <fs_member>-total_wt
                           %control-totalweight = if_abap_behv=>mk-on
                           itemweight = <fs_member>-item_wt
                           %control-itemweight = if_abap_behv=>mk-on
                           differecewt = <fs_member>-diff_wt
                           %control-differecewt = if_abap_behv=>mk-on
                           weightunit = <fs_member>-weight_unit
                           %control-weightunit = if_abap_behv=>mk-on
                           createdby = cl_abap_context_info=>get_user_alias( )
                           %control-createdby = if_abap_behv=>mk-on
                          " createdon = cl_abap_context_info=>get_system_date( )
                           createdon = lv_timestamp
                           %control-createdon = if_abap_behv=>mk-on
                                               ) .
      APPEND ls_data TO lt_data.

      CLEAR: ls_tdata.

      ls_tdata-ebeln = <fs_member>-ebeln.
      ls_tdata-ebelp = <fs_member>-ebelp .
      ls_tdata-lgort       = <fs_member>-lgort.
      ls_tdata-quantity    = <fs_member>-quantity.
      ls_tdata-qtyuom      = <fs_member>-quantityuom.
      ls_tdata-total_wt    = <fs_member>-total_wt.
      ls_tdata-item_wt     = <fs_member>-item_wt.
      ls_tdata-diff_wt     = <fs_member>-diff_wt.
      ls_tdata-weight_unit = <fs_member>-weight_unit.
      ls_tdata-created_by  = cl_abap_context_info=>get_user_alias( ).
      ls_tdata-created_on  = lv_timestamp.
      ls_tdata-yy1_chillingcenter_pdi = <fs_member>-chilcenter.
      ls_tdata-yy1_compartment_pdi    = <fs_member>-compartment.
      APPEND ls_tdata to lt_tdata.

    ENDLOOP.

    if lt_data is not initial.
      MODIFY ENTITIES OF zi_weigh_bridge
      ENTITY zi_weigh_bridge
      CREATE FROM lt_data
*      CREATE BY \_item    FROM lt_trucksheet_i
      MAPPED DATA(it_mapped)
      FAILED DATA(it_failed)
      REPORTED DATA(it_reported).

      if it_failed is initial.

      endif.
     endif.

*    IF lt_tdata IS NOT INITIAL.
*      MODIFY zmmt_weighbridge FROM TABLE @lt_tdata.
*    ENDIF.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_v_weigh_bridge DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_v_weigh_bridge IMPLEMENTATION.

  METHOD save_modified.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
