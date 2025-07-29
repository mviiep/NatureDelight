FUNCTION z_create_milk_po.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_PLANT) TYPE  WERKS_D
*"     REFERENCE(IV_SLOC) TYPE  ZMM_MILKRATECARD-SLOC
*"     REFERENCE(IV_LIFNR) TYPE  LIFNR
*"     REFERENCE(IV_MATNR) TYPE  MATNR
*"     REFERENCE(IV_DATE) TYPE  DATUM
*"     REFERENCE(IV_FAT) TYPE  MENGE_D
*"     REFERENCE(IV_SNF) TYPE  MENGE_D
*"     REFERENCE(IV_MILK_QTY) TYPE  MENGE_D
*"     REFERENCE(IV_RATE) TYPE  ZMM_MILKRATECARD-RATE
*"  EXPORTING
*"     REFERENCE(EV_EBELN) TYPE  EBELN
*"----------------------------------------------------------------------
      TYPES: tt_purorder_items_create TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
             ty_purorder_items_create TYPE LINE OF tt_purorder_items_create.

  DATA(lt_item) = VALUE tt_purorder_items_create( ( %cid_ref = 'PO'
                               %target  = VALUE #( ( %cid               = 'POI'
                                                   purchaseorderitem    = '00010'
                                                   Material             = iv_Matnr
                                                   Plant                = iv_Plant
                                                   StorageLocation      = iv_Sloc
                                                   OrderQuantity        = iv_Milk_Qty
                                                   PurchaseOrderQuantityUnit = 'L'

                               %control = VALUE #(
                                                   purchaseorderitem    = cl_abap_behv=>flag_changed
                                                   Material             = cl_abap_behv=>flag_changed
                                                   Plant                = cl_abap_behv=>flag_changed
                                                   StorageLocation      = cl_abap_behv=>flag_changed
                                                   OrderQuantity        = cl_abap_behv=>flag_changed
                                                   PurchaseOrderQuantityUnit = cl_abap_behv=>flag_changed
                                                   ) ) ) ) ).

    " Call the modify function
    MODIFY ENTITIES OF I_PurchaseOrderTP_2
      ENTITY purchaseorder
       CREATE FIELDS ( purchaseordertype
                       companycode
                       purchasingorganization
                       purchasinggroup
                       supplier
                     )
       WITH VALUE #( ( %cid                   = 'PO'
                       purchaseordertype      = 'ZRAW'
                       companycode            = '1000'
                       purchasingorganization = '1000'
                       purchasinggroup        = '101'
                       supplier               = iv_Lifnr
                   ) )
      CREATE BY \_purchaseorderitem
      FROM lt_item

      REPORTED DATA(ls_po_reported)
      FAILED   DATA(ls_po_failed)
      MAPPED   DATA(ls_po_mapped).

    " Check if process is not failed
    cl_abap_unit_assert=>assert_initial( ls_po_failed-purchaseorder ).
    cl_abap_unit_assert=>assert_initial( ls_po_reported-purchaseorder ).

**    ls_mapped_root_late-%pre = VALUE #( %tmp = ls_mapped-purchaseorder[ 1 ]-%key ).
*    COMMIT ENTITIES BEGIN RESPONSE OF I_PurchaseOrderTP_2 FAILED DATA(lt_po_res_failed) REPORTED DATA(lt_po_res_reported).
*    "Special processing for Late numbering to determine the generated document number.
*    LOOP AT ls_po_mapped-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_po_mapped>).
*      CONVERT KEY OF I_PurchaseOrderTP_2 FROM <fs_po_mapped>-%key TO DATA(ls_po_key).
*      <fs_po_mapped>-PurchaseOrder = ls_po_key-PurchaseOrder.
*    ENDLOOP.
*    COMMIT ENTITIES END.

    " Check if process is not failed    cl_abap_unit_assert=>assert_initial( ls_po_failed-purchaseorder ).
*    cl_abap_unit_assert=>assert_initial( ls_po_reported-purchaseorder ).


*    eV_EBELN = ls_po_key-PurchaseOrder .

ENDFUNCTION.
