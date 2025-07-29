CLASS zcl_process_ord_gr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_PROCESS_ORD_GR IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DATA: T_HEADER      TYPE TABLE FOR CREATE i_materialdocumenttp,
        W_HEADER      LIKE LINE OF T_HEADER,
        T_items       TYPE TABLE FOR CREATE i_materialdocumenttp\_MaterialDocumentItem,
        W_itemS       LIKE LINE OF T_items.

      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
      DATA(n1) = 0.
      DATA(n2) = 0.

  W_HEADER =  VALUE #( %cid = 'CID_001'
                       goodsmovementcode = '02'
                       postingdate = creation_date
                       documentdate = creation_date

                  %control = VALUE #(
                             goodsmovementcode      = cl_abap_behv=>flag_changed
                             postingdate            = cl_abap_behv=>flag_changed
                             documentdate           = cl_abap_behv=>flag_changed
                                                      ) ).
      APPEND W_HEADER TO T_HEADER.

n2 += 1.
W_itemS = VALUE #(  %cid_ref = 'CID_001'
                    %target = VALUE #( ( %cid = |CID_ITEM_{ n2 }|
                     plant = '1101'
                     material = '000000000000000034'
                     GoodsMovementType = '101'
                     storagelocation = 'S004'
                     QuantityInEntryUnit = '3.5'
                     entryunit = 'KG'
                     GoodsMovementRefDocType = 'F'
                     Batch = |1101{ creation_date+6(2) }{ creation_date+4(2) }{ creation_date+2(2) }|
                     ManufacturingOrder = '000001000003'
                     ManufacturingOrderItem = '0001'
                     ManufactureDate = creation_date

                  %control = VALUE #(
                     plant                   = cl_abap_behv=>flag_changed
                     material                = cl_abap_behv=>flag_changed
                     GoodsMovementType       = cl_abap_behv=>flag_changed
                     storagelocation         = cl_abap_behv=>flag_changed
                     QuantityInEntryUnit     = cl_abap_behv=>flag_changed
                     entryunit               = cl_abap_behv=>flag_changed
                     GoodsMovementRefDocType = cl_abap_behv=>flag_changed
                     Batch                   = cl_abap_behv=>flag_changed
                     ManufacturingOrder      = cl_abap_behv=>flag_changed
                     ManufacturingOrderItem  = cl_abap_behv=>flag_changed
                     ManufactureDate         = cl_abap_behv=>flag_changed
                                                      ) ) )  ).
      APPEND W_itemS TO T_items.

n2 += 1.
W_itemS = VALUE #(  %cid_ref = 'CID_001'
                    %target = VALUE #( ( %cid = |CID_ITEM_{ n2 }|
                     plant = '1101'
                     material = '000000000000000035'
                     GoodsMovementType = '101'
                     storagelocation = 'S004'
                     QuantityInEntryUnit = '5.5'
                     entryunit = 'KG'
                     GoodsMovementRefDocType = 'F'
                     Batch = |1101{ creation_date+6(2) }{ creation_date+4(2) }{ creation_date+2(2) }|
                     ManufacturingOrder = '000001000003'
                     ManufacturingOrderItem = '0002'
                     ManufactureDate = creation_date

                  %control = VALUE #(
                     plant                   = cl_abap_behv=>flag_changed
                     material                = cl_abap_behv=>flag_changed
                     GoodsMovementType       = cl_abap_behv=>flag_changed
                     storagelocation         = cl_abap_behv=>flag_changed
                     QuantityInEntryUnit     = cl_abap_behv=>flag_changed
                     entryunit               = cl_abap_behv=>flag_changed
                     GoodsMovementRefDocType = cl_abap_behv=>flag_changed
                     Batch                   = cl_abap_behv=>flag_changed
                     ManufacturingOrder      = cl_abap_behv=>flag_changed
                     ManufacturingOrderItem  = cl_abap_behv=>flag_changed
                     ManufactureDate         = cl_abap_behv=>flag_changed
                                                      ) ) )  ).
      APPEND W_itemS TO T_items.

*n2 += 1.
*W_itemS = VALUE #(  %cid_ref = 'CID_001'
*                    %target = VALUE #( ( %cid = |CID_ITEM_{ n2 }|
*                     plant = '1101'
*                     material = '000000000000000035'
*                     GoodsMovementType = '101'
*                     storagelocation = 'S004'
*                     QuantityInEntryUnit = '5.5'
*                     entryunit = 'KG'
*                     GoodsMovementRefDocType = 'F'
*                     Batch = |1101{ creation_date+6(2) }{ creation_date+4(2) }{ creation_date+2(2) }|
*                     ManufacturingOrder = '000001000003'
*                     ManufacturingOrderItem = '0001'
*                     ManufactureDate = creation_date
*
*                  %control = VALUE #(
*                     plant                   = cl_abap_behv=>flag_changed
*                     material                = cl_abap_behv=>flag_changed
*                     GoodsMovementType       = cl_abap_behv=>flag_changed
*                     storagelocation         = cl_abap_behv=>flag_changed
*                     QuantityInEntryUnit     = cl_abap_behv=>flag_changed
*                     entryunit               = cl_abap_behv=>flag_changed
*                     GoodsMovementRefDocType = cl_abap_behv=>flag_changed
*                     Batch                   = cl_abap_behv=>flag_changed
*                     ManufacturingOrder      = cl_abap_behv=>flag_changed
*                     ManufacturingOrderItem  = cl_abap_behv=>flag_changed
*                     ManufactureDate         = cl_abap_behv=>flag_changed
*                                                      ) ) )  ).
*      APPEND W_itemS TO T_items.

    MODIFY ENTITIES OF i_materialdocumenttp
    ENTITY MaterialDocument
    CREATE FROM T_HEADER
    CREATE BY \_MaterialDocumentItem
    FROM T_items
         MAPPED DATA(lm_mapped)
         FAILED DATA(lm_failed)
         REPORTED DATA(lm_reported).

*        MODIFY ENTITIES OF i_materialdocumenttp
*         ENTITY MaterialDocument
*         CREATE FROM VALUE #( ( %cid = 'CID_001'
*         goodsmovementcode = '02'
*         postingdate = creation_date
*         documentdate = creation_date
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
*         material = '000000000000000034'
*         GoodsMovementType = '101'
*         storagelocation = 'S004'
*         QuantityInEntryUnit = '3.5'
*         entryunit = 'KG'
*         GoodsMovementRefDocType = 'F'
*         Batch = 'TEST000001'
*         ManufacturingOrder = '000001000003'
*         ManufacturingOrderItem = '0001'
*         ManufactureDate = creation_date
*
*         %control-plant = cl_abap_behv=>flag_changed
*         %control-material = cl_abap_behv=>flag_changed
*         %control-GoodsMovementType = cl_abap_behv=>flag_changed
*         %control-storagelocation = cl_abap_behv=>flag_changed
*         %control-QuantityInEntryUnit = cl_abap_behv=>flag_changed
*         %control-entryunit = cl_abap_behv=>flag_changed
*         %control-Batch = cl_abap_behv=>flag_changed
*         %control-ManufacturingOrder = cl_abap_behv=>flag_changed
*         %control-ManufacturingOrderItem = cl_abap_behv=>flag_changed
*         %control-GoodsMovementRefDocType = cl_abap_behv=>flag_changed
*         %control-ManufactureDate = cl_abap_behv=>flag_changed
*         ) )
*
*
*         ) )
*         MAPPED DATA(lm_mapped)
*         FAILED DATA(lm_failed)
*         REPORTED DATA(lm_reported).



    LOOP AT lm_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
      DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
           out->write( 'Item' ).
           out->write( lv_result1 ).
    ENDLOOP.
    LOOP AT lm_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
      DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
           out->write( 'Order' ).
           out->write( lv_result2 ).
    ENDLOOP.
*    COMMIT ENTITIES BEGIN
*      RESPONSE OF I_MATERIALDOCUMENTTP
*      FAILED DATA(lt_commit_failed)
*      REPORTED DATA(lt_commit_reported).
*    LOOP AT im_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<fs_so_mapped>).
**      CONVERT KEY OF I_MATERIALDOCUMENTTP FROM <fs_so_mapped>-%pid TO DATA(ls_so_key).
**          out->write( 'Purchase Order:'  && ls_so_key-MaterialDocument ).
*    ENDLOOP.
*    COMMIT ENTITIES END.

 COMMIT ENTITIES BEGIN
RESPONSE OF i_materialdocumenttp
 FAILED DATA(commit_failed)
 REPORTED DATA(commit_reported).

LOOP AT lm_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).

      CONVERT KEY OF I_MATERIALDOCUMENTTP FROM <keys_header>-%pid TO DATA(ls_md_key).
*      <fs_md_mapped>-MaterialDocument = ls_md_key-MaterialDocument.
*      <fs_md_mapped>-MaterialDocumentYear = ls_md_key-MaterialDocumentYear.

* CONVERT KEY OF i_materialdocumentTp
* FROM <keys_header>-%pid to DATA(ls_md_key).
* TO <keys_header>-%key.
ENDLOOP.


LOOP AT lm_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).

* CONVERT KEY OF i_materialdocumentitemtp
* FROM <keys_item>-%pid
* TO <keys_item>-%key.
ENDLOOP.

COMMIT ENTITIES END.


  ENDMETHOD.
ENDCLASS.
