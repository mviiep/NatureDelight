CLASS zcl_mm_wb_data_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES: tt_data    TYPE TABLE OF zce_cds_wb,
           tt_data_gp TYPE TABLE OF zce_cds_gp_sh.
    METHODS: me_get_data
      IMPORTING iv_gp_no TYPE zchar10
      EXPORTING et_data  TYPE tt_data,
      me_get_data_gp
        EXPORTING et_data TYPE tt_data_gp.
  PROTECTED SECTION.

  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_WB_DATA_CLASS IMPLEMENTATION.


  METHOD me_get_data.
    DATA: ls_data LIKE LINE OF et_data.
    SELECT SINGLE FROM zdt_gate_entry
    FIELDS gate_entry_no, entry_type, vehicle_no, driver_name,
           driver_mobile, comodity, material, inbound_type, sto_no,
           batch, purpose, in_date, in_time, out_date, out_time, vehicle_out
    WHERE gate_entry_no EQ @iv_gp_no
    INTO @DATA(ls_gate).
    IF sy-subrc EQ 0.
      SELECT FROM zmmt_weigh_bridg
           FIELDS *
            WHERE gp_no EQ @ls_gate-gate_entry_no
              AND ebeln EQ @ls_gate-sto_no
       INTO TABLE @DATA(lt_wb).
    ENDIF.

    IF ls_gate-entry_type EQ 'IN'.  "Inbound

      IF ls_gate-inbound_type EQ 'BULK'.        " Bulk collection
        IF lt_wb IS NOT INITIAL.
          LOOP AT lt_wb INTO DATA(ls_wb).
            CLEAR: ls_data.
            ls_data-gp_no = ls_gate-gate_entry_no.
            ls_data-ebeln = ls_wb-ebeln.
            ls_data-ebelp = ls_wb-ebelp.
            "ls_data-OrderQuantity = ls_wb-quantity.
            "ls_data-PurchaseOrderQuantityUnit = ls_wb-qtyuom.
            ls_data-charg = ls_gate-batch.
            ls_data-total_wt = ls_wb-total_wt.
            ls_data-item_wt = ls_wb-item_wt.
            "ls_data-tare_wt = ls_wb-tare_wt.
            "ls_data-diff_wt = ls_wb-diff_wt.
            ls_data-weight_unit = ls_wb-weight_unit.
            "ls_data-ChillingCenter = ls_wb-yy1_chillingcenter_pdi.
            "ls_data-Compartment = ls_wb-yy1_compartment_pdi.
            ls_data-entry_type = ls_gate-entry_type.
*         ls_data-trucksheet_no = ls_gate-vehicle_no.
            ls_data-fulltruckunload = ls_wb-fulltruckunload.
            ls_data-from_db = abap_true.
            APPEND ls_data TO et_data.
          ENDLOOP.
        ELSE.
          CLEAR: ls_data, ls_wb.
          ls_data-gp_no = ls_gate-gate_entry_no.
          "ls_data-ebeln = ls_wb-ebeln.
          "ls_data-ebelp = ls_wb-ebelp.
          "ls_data-OrderQuantity = ls_wb-quantity.
          "ls_data-PurchaseOrderQuantityUnit = ls_wb-qtyuom.
          ls_data-charg = ls_gate-batch.
          "ls_data-total_wt = ls_wb-total_wt.
          "ls_data-item_wt = ls_wb-item_wt.
          "ls_data-tare_wt = ls_wb-tare_wt.
          "ls_data-diff_wt = ls_wb-diff_wt.
          "ls_data-weight_unit = ls_wb-weight_unit.
          "ls_data-ChillingCenter = ls_wb-yy1_chillingcenter_pdi.
          "ls_data-Compartment = ls_wb-yy1_compartment_pdi.
          ls_data-entry_type = ls_gate-entry_type.
*         ls_data-trucksheet_no = ls_gate-vehicle_no.
          "ls_data-fulltruckunload = ls_wb-fulltruckunload.
          "ls_data-from_DB = true.
          APPEND ls_data TO et_data.
        ENDIF.
      ELSE.     " Chilling Center Collection

        SELECT FROM i_purchaseorderitemapi01
        FIELDS purchaseorder AS ebeln,
               purchaseorderitem AS ebelp,
               storagelocation AS lgort,
               plant,
               material,
               orderquantity,
               purchaseorderquantityunit,
*               yy1_chillingcenter_pdi AS chillingcenter,
               yy1_chillingcentechill_pdi AS chillingcenter,
               yy1_compartment_pdi AS compartment
        WHERE purchaseorder EQ @ls_gate-sto_no
        AND ( PurchasingDocumentDeletionCode is INITIAL )
         INTO TABLE @DATA(lt_ekpo).

        IF sy-subrc EQ 0.
          SELECT FROM i_materialdocumentitem_2
          FIELDS materialdocument,
                 materialdocumentitem,
                 materialdocumentyear,
                 batch,
                 purchaseorder AS ebeln,
                 purchaseorderitem AS ebelp,
                 goodsmovementtype
          FOR ALL ENTRIES IN @lt_ekpo
         WHERE purchaseorder EQ @lt_ekpo-ebeln AND
               purchaseorderitem EQ @lt_ekpo-ebelp AND
               goodsmovementtype EQ '101' AND
               reversedmaterialdocument IS INITIAL
           INTO TABLE @DATA(lt_matdoc).

          SELECT FROM i_storagelocation
          FIELDS plant,
                 storagelocation,
                 storagelocationname
             FOR ALL ENTRIES IN @lt_ekpo
        WHERE storagelocation EQ @lt_ekpo-chillingcenter
          INTO TABLE @DATA(lt_sloc).

        ENDIF.
        LOOP AT lt_ekpo INTO DATA(ls_ekpo).
          CLEAR: ls_data, ls_wb.
          ls_wb = VALUE #( lt_wb[ gp_no = ls_gate-gate_entry_no ebeln = ls_ekpo-ebeln ebelp = ls_ekpo-ebelp ] OPTIONAL ).
          IF ls_wb IS NOT INITIAL.
            ls_data-gp_no = ls_gate-gate_entry_no.
            ls_data-ebeln = ls_wb-ebeln.
            ls_data-ebelp = ls_wb-ebelp.
            ls_data-lgort = ls_wb-lgort.

            ls_data-orderquantity = ls_wb-quantity.
            ls_data-purchaseorderquantityunit = ls_wb-qtyuom.
            ls_data-charg = ls_wb-charg.
            ls_data-werks = ls_wb-werks.
            ls_data-matnr = ls_wb-matnr.
            ls_data-mblnr = ls_wb-mblnr.
            ls_data-total_wt = ls_wb-total_wt.
            ls_data-item_wt = ls_wb-item_wt.
            ls_data-tare_wt = ls_wb-tare_wt.
            ls_data-diff_wt = ls_wb-diff_wt.
            ls_data-fulltruckunload = ls_wb-fulltruckunload.
            ls_data-weight_unit = ls_wb-weight_unit.
            ls_data-chillingcenter = ls_wb-yy1_chillingcenter_pdi.
            ls_data-lgort_name = VALUE #( lt_sloc[ storagelocation = ls_wb-yy1_chillingcenter_pdi ]-storagelocationname OPTIONAL ).
            ls_data-compartment = ls_wb-yy1_compartment_pdi.
            ls_data-entry_type = ls_wb-entry_type.
            ls_data-trucksheet_no = ls_wb-trucksheet_no.
            ls_data-from_db = abap_true.

          ELSE.

            ls_data-gp_no = ls_gate-gate_entry_no.
            ls_data-ebeln = ls_ekpo-ebeln.
            ls_data-ebelp = ls_ekpo-ebelp.
            ls_data-orderquantity = ls_ekpo-orderquantity.
            ls_data-purchaseorderquantityunit = ls_ekpo-purchaseorderquantityunit.
            ls_data-werks = ls_ekpo-plant.
            ls_data-matnr = ls_ekpo-material.
            ls_data-lgort = ls_ekpo-lgort.

            ls_data-charg = VALUE #( lt_matdoc[ ebeln = ls_ekpo-ebeln ebelp = ls_ekpo-ebelp ]-batch OPTIONAL ).
            "ls_data-total_wt = ls_wb-total_wt.
            "ls_data-item_wt = ls_wb-item_wt.
            "ls_data-tare_wt = ls_wb-tare_wt.
            "ls_data-diff_wt = ls_wb-diff_wt.
            "ls_data-weight_unit = ls_wb-weight_unit.
            ls_data-chillingcenter = ls_ekpo-chillingcenter.
            ls_data-lgort_name = VALUE #( lt_sloc[ storagelocation = ls_ekpo-chillingcenter ]-storagelocationname OPTIONAL ).
            ls_data-compartment = ls_ekpo-compartment.
            ls_data-entry_type = ls_gate-entry_type.
            "ls_data-trucksheet_no = ls_wb-trucksheet_no.
          ENDIF.
          APPEND ls_data TO et_data.
          CLEAR: ls_wb.
        ENDLOOP.
      ENDIF.

    ELSE.   "Outbound
      IF lt_wb IS NOT INITIAL.
        ls_wb = VALUE #( lt_wb[ 1 ] OPTIONAL ).
        CLEAR: ls_data.
        ls_data-gp_no = ls_gate-gate_entry_no.
        "ls_data-ebeln = ls_wb-ebeln.
        "ls_data-ebelp = ls_wb-ebelp.
        "ls_data-OrderQuantity = ls_wb-quantity.
        "ls_data-PurchaseOrderQuantityUnit = ls_wb-qtyuom.
        ls_data-charg = ls_wb-charg.
        ls_data-total_wt = ls_wb-total_wt.
        ls_data-item_wt = ls_wb-item_wt.
        ls_data-tare_wt = ls_wb-tare_wt.
        ls_data-diff_wt = ls_wb-diff_wt.
        ls_data-tsheet_wt = ls_wb-tsheet_wt.
        ls_data-weight_unit = ls_wb-weight_unit.
        "ls_data-ChillingCenter = ls_wb-yy1_chillingcenter_pdi.
        "ls_data-Compartment = ls_wb-yy1_compartment_pdi.
        ls_data-entry_type = ls_wb-entry_type.
        ls_data-trucksheet_no = ls_wb-trucksheet_no.
        ls_data-fulltruckunload = ls_wb-fulltruckunload.
        ls_data-from_db = abap_true.
        APPEND ls_data TO et_data.
      ELSE.
        CLEAR: ls_data.
        ls_data-gp_no = ls_gate-gate_entry_no.
        "ls_data-ebeln = ls_wb-ebeln.
        "ls_data-ebelp = ls_wb-ebelp.
        "ls_data-OrderQuantity = ls_wb-quantity.
        "ls_data-PurchaseOrderQuantityUnit = ls_wb-qtyuom.
        ls_data-charg = ls_gate-batch.
        "ls_data-total_wt = ls_wb-total_wt.
        "ls_data-item_wt = ls_wb-item_wt.
        "ls_data-tare_wt = ls_wb-tare_wt.
        "ls_data-diff_wt = ls_wb-diff_wt.
        ls_data-weight_unit = ls_wb-weight_unit.
        "ls_data-ChillingCenter = ls_wb-yy1_chillingcenter_pdi.
        "ls_data-Compartment = ls_wb-yy1_compartment_pdi.
        ls_data-entry_type = ls_gate-entry_type.
        SELECT FROM zsdt_truckshet_h
        FIELDS trucksheet_no, vehicle_no, created_on
        WHERE vehicle_no EQ @ls_gate-vehicle_no
        INTO TABLE @DATA(lt_tsheet). "@ls_data-trucksheet_no.
        SORT lt_tsheet BY created_on.

        ls_data-trucksheet_no = VALUE #( lt_tsheet[ 1 ]-trucksheet_no OPTIONAL ).
        APPEND ls_data TO et_data.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD me_get_data_gp.
    DATA: ls_data LIKE LINE OF et_data.
    SELECT FROM zdt_gate_entry

    FIELDS gate_entry_no, zdt_gate_entry~entry_type, vehicle_no, driver_name,
           driver_mobile, comodity, material, inbound_type, sto_no,
           batch, purpose, in_date, in_time, out_date, out_time, vehicle_out
    WHERE vehicle_out IS INITIAL

     INTO TABLE @DATA(lt_gate).
     if lt_gate is NOT INITIAL.
     DATA: lr_gate_no TYPE RANGE OF zde_trucksheet_no.
     SELECT FROM zmmt_weigh_bridg
     FIELDS  gp_no
     FOR ALL ENTRIES IN @lt_gate
     WHERE gp_no = @lt_gate-gate_entry_no AND
     fulltruckunload = 'X'
     INTO TABLE @DATA(lt_gate_no).

     lr_gate_no = VALUE #( for lw_gate_entry in lt_gate_no ( sign = 'I' option
     = 'EQ' low = lw_gate_entry-gp_no ) ).

     DELETE lt_gate WHERE gate_entry_no in lr_gate_no.
     ENDif.
    LOOP AT lt_gate INTO DATA(ls_gate).
      CLEAR ls_data.
      ls_data-gp_no         = ls_gate-gate_entry_no     .
      ls_data-entry_type    = ls_gate-entry_type   .
      ls_data-vehicle_no    = ls_gate-vehicle_no   .
      ls_data-driver_name   = ls_gate-driver_name  .
      ls_data-driver_mobile = ls_gate-driver_mobile.
      ls_data-inbound_type  = ls_gate-inbound_type .
      ls_data-sto_no        = ls_gate-sto_no       .
      ls_data-batch         = ls_gate-batch        .
      APPEND ls_data TO et_data.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
