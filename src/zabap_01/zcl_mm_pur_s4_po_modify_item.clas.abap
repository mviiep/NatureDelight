CLASS zcl_mm_pur_s4_po_modify_item DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_mm_pur_s4_po_modify_item .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_PUR_S4_PO_MODIFY_ITEM IMPLEMENTATION.


  METHOD if_mm_pur_s4_po_modify_item~modify_item.

*  IF PURCHASEORDER-purchaseordertype = 'ZSTO'.
*
*    IF purchaseorderitem_old IS INITIAL
*      OR purchaseorderitem-material <> purchaseorderitem_old-material
*      OR purchaseorderitem-plant    <> purchaseorderitem_old-plant.
*      purchaseorderitemchange-purchasinginforecordupdatecode = 'B'.
*    ENDIF.
*
*    IF purchaseorderitem-storagelocation IS NOT INITIAL.
*
*     CONCATENATE purchaseorderitem-storagelocation
*                 SY-DATUM+6(2) SY-DATUM+4(2) SY-DATUM+2(2)
*                 INTO DATA(LV_BATCH).
*
*    ENDIF.

*  ENDIF.


  ENDMETHOD.
ENDCLASS.
