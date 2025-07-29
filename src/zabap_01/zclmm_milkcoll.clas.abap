CLASS zclmm_milkcoll DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
   METHODS: CREATE_PO.
   INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_MILKCOLL IMPLEMENTATION.


  METHOD create_po.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

*      TYPES: tt_purorder_items_create TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
*             ty_purorder_items_create TYPE LINE OF tt_purorder_items_create,
*             tt_Purchase_Ord_Schedule_Line TYPE TABLE FOR CREATE I_PurchaseOrderItemTP_2\_PurchaseOrderScheduleLineTP,
*             "tt_PurchaseOrdScheduleLine type TABLE of I_PurchaseOrdScheduleLineTP_2,
*             ty_Purchase_Ord_Schedule_Line TYPE LINE OF tt_Purchase_Ord_Schedule_Line.
*
*  DATA(lt_item) = VALUE tt_purorder_items_create( ( %cid_ref = 'PO'
*                               %target  = VALUE #( ( %cid               = 'POI'
*                                                   purchaseorderitem    = '00010'
*                                                   Material             = '0000000000000000000000000000000000000002'
*                                                   Plant                = '1101'
*                                                   StorageLocation      = 'E001'
*                                                   OrderQuantity        = '111'
*                                                   PurchaseOrderQuantityUnit = 'L'
*
*                               %control = VALUE #(
*                                                   purchaseorderitem    = cl_abap_behv=>flag_changed
*                                                   Material             = cl_abap_behv=>flag_changed
*                                                   Plant                = cl_abap_behv=>flag_changed
*                                                   StorageLocation      = cl_abap_behv=>flag_changed
*                                                   OrderQuantity        = cl_abap_behv=>flag_changed
*                                                   PurchaseOrderQuantityUnit = cl_abap_behv=>flag_changed
*                                                   ) ) ) ) ).
*
*  DATA(lt_itemSch) = VALUE tt_Purchase_Ord_Schedule_Line( ( %cid_ref = 'POI'
*                               %target  = VALUE #( ( %cid               = 'POIS'
*                                                   purchaseorderitem    = '00010'
*                                                   ScheduleLine         = '00010'
*                                                   ScheduleLineDeliveryDate = '20231205'
*                                                   ScheduleLineOrderQuantity = '111'
*                                                   PurchaseOrderQuantityUnit = 'L'
*
*                               %control = VALUE #(
*                                                   purchaseorderitem    = cl_abap_behv=>flag_changed
*                                                   ScheduleLine         = cl_abap_behv=>flag_changed
*                                                   ScheduleLineDeliveryDate = cl_abap_behv=>flag_changed
*                                                   ScheduleLineOrderQuantity = cl_abap_behv=>flag_changed
*                                                   PurchaseOrderQuantityUnit = cl_abap_behv=>flag_changed
*                                                   ) ) ) ) ).
*
*
*    " Call the modify function
*    MODIFY ENTITIES OF I_PurchaseOrderTP_2
*      ENTITY purchaseorder
*       CREATE FIELDS ( purchaseordertype
*                       companycode
*                       purchasingorganization
*                       purchasinggroup
*                       supplier
*                     )
*       WITH VALUE #( ( %cid                   = 'PO'
*                       purchaseordertype      = 'ZRAW'
*                       companycode            = '1000'
*                       purchasingorganization = '1000'
*                       purchasinggroup        = '101'
*                       supplier               = '0001000000'
*                   ) )
*      CREATE BY \_purchaseorderitem
*      FROM lt_item
*
*      REPORTED DATA(ls_po_reported)
*      FAILED   DATA(ls_po_failed)
*      MAPPED   DATA(ls_po_mapped).
*
*    " Check if process is not failed
*    cl_abap_unit_assert=>assert_initial( ls_po_failed-purchaseorder ).
*    cl_abap_unit_assert=>assert_initial( ls_po_reported-purchaseorder ).
*
***    ls_mapped_root_late-%pre = VALUE #( %tmp = ls_mapped-purchaseorder[ 1 ]-%key ).
*    COMMIT ENTITIES BEGIN RESPONSE OF I_PurchaseOrderTP_2 FAILED DATA(lt_po_res_failed) REPORTED DATA(lt_po_res_reported).
*    "Special processing for Late numbering to determine the generated document number.
*    LOOP AT ls_po_mapped-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_po_mapped>).
*      CONVERT KEY OF I_PurchaseOrderTP_2 FROM <fs_po_mapped>-%key TO DATA(ls_po_key).
*      <fs_po_mapped>-PurchaseOrder = ls_po_key-PurchaseOrder.
*    ENDLOOP.
*    COMMIT ENTITIES END.

*--------------------------------------------------------------------------------
*--------------------------------------------------------------------------------

**DATA: purchase_orders      TYPE TABLE FOR CREATE i_purchaseordertp_2,
**      purchase_order       LIKE LINE OF purchase_orders,
**      purchase_order_items TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
**      purchase_order_item  LIKE LINE OF purchase_order_items.
**    DATA(n1) = 0.
**    DATA(n2) = 0.
***    DO 2 TIMES.
**n1 += 1.
**purchase_order =  VALUE #( %cid = |My%CID_{ n1 }|
**purchaseordertype      = 'NB'
**companycode            = '1000'
**purchasingorganization = '1000'
**purchasinggroup        = '001'
**supplier               = '0001000000'
**                  %control = VALUE #(
**                             purchaseordertype      = cl_abap_behv=>flag_changed
**                             companycode            = cl_abap_behv=>flag_changed
**                             purchasingorganization = cl_abap_behv=>flag_changed
**                             purchasinggroup        = cl_abap_behv=>flag_changed
**                             supplier               = cl_abap_behv=>flag_changed
**                                                      ) ).
**      APPEND purchase_order TO purchase_orders.
**n2 += 1.
**"Purchase Order Item Data 1
**purchase_order_item = VALUE #(  %cid_ref = |My%CID_{ n1 }|
**%target = VALUE #( ( %cid = |My%CID_ITEM{ n2 }|
**material          = '000000000000000002' "0000000000000000000000000000000000000002
**plant             = '1101'
**orderquantity     = '5'
**purchaseorderitem = '00010'
**netpriceamount    = '5'
**                  %control = VALUE #( material          = cl_abap_behv=>flag_changed
**                                      plant             = cl_abap_behv=>flag_changed
**                                      orderquantity     = cl_abap_behv=>flag_changed
**                                      purchaseorderitem = cl_abap_behv=>flag_changed
**                                      netpriceamount    = cl_abap_behv=>flag_changed
**                                                      ) ) )  ).
**      APPEND purchase_order_item TO purchase_order_items.
***    ENDDO.
**"Purchase Order Header Data
**    MODIFY ENTITIES OF i_purchaseordertp_2
**    ENTITY purchaseorder
**    CREATE FROM purchase_orders
**    CREATE BY \_purchaseorderitem
**    FROM purchase_order_items
**    MAPPED DATA(mapped_po_headers)
**    REPORTED DATA(reported_po_headers)
**    FAILED DATA(failed_po_headers).
**    LOOP AT reported_po_headers-purchaseorderitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
**      DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
**           out->write( 'Item' ).
**           out->write( lv_result1 ).
**    ENDLOOP.
**    LOOP AT reported_po_headers-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
**      DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
**           out->write( 'Order' ).
**           out->write( lv_result2 ).
**    ENDLOOP.
**    COMMIT ENTITIES BEGIN
**      RESPONSE OF i_purchaseordertp_2
**      FAILED DATA(lt_commit_failed)
**      REPORTED DATA(lt_commit_reported).
**    LOOP AT mapped_po_headers-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_so_mapped>).
**      CONVERT KEY OF I_PurchaseOrderTP_2 FROM <fs_so_mapped>-%pid TO DATA(ls_so_key).
**          out->write( 'Purchase Order:'  && ls_so_key-PurchaseOrder ).
**    ENDLOOP.
**    COMMIT ENTITIES END.

    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA lt_invoice TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA : LS_DATA LIKE LINE OF ls_invoice-%param-_itemswithporeference.

*    TRY.
*     DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*     CATCH cx_uuid_error.
*     "Error handling
*    ENDTRY.

  DATA : R_date TYPE RANGE OF datum,
         s_date like LINE OF r_date,
         P_DATE TYPE DATUM.

         s_date-sign   = 'I'.
         s_date-option = 'BT'.
         s_date-low    = '20240127'.
         s_date-high   = '20240131'.
         append s_date to r_date.
         clear s_date.

         P_DATE = '20240131'.

  SELECT * FROM zmm_milkcoll
  WHERE MIRODOC = ''
  AND   MBLNR NE ''
  AND   COLL_DATE IN @r_date
  INTO TABLE @DATA(LT_MILKCOLL).

  IF LT_MILKCOLL[] is not INITIAL.
   sort LT_MILKCOLL by lifnr coll_date.
   data(LT_MILKCOLL_1) = LT_MILKCOLL[].
   sort LT_MILKCOLL_1 by lifnr sloc.
   delete ADJACENT DUPLICATES FROM LT_MILKCOLL_1 COMPARING lifnr sloc.
  endif.

***
***
***    ls_invoice-%cid = lv_cid.
***    ls_invoice-%param-supplierinvoiceiscreditmemo = abap_false.
***    ls_invoice-%param-companycode = '1000'.
***    ls_invoice-%param-invoicingparty = '0001000001'.
***    ls_invoice-%param-postingdate = cl_abap_context_info=>get_system_date(  ).
***    ls_invoice-%param-documentdate = cl_abap_context_info=>get_system_date(  ).
***    ls_invoice-%param-documentcurrency = 'INR'.
***    ls_invoice-%param-invoicegrossamount = 100.
***    ls_invoice-%param-taxiscalculatedautomatically = abap_true.
***    ls_invoice-%param-supplierinvoiceidbyinvcgparty = '0001000001'.
***    ls_invoice-%param-BusinessPlace = '1000'.
***    ls_invoice-%param-BusinessSectionCode = '1000'.
***    ls_invoice-%param-PaymentMethod = 'T'.
***
***    ls_invoice-%param-TaxDeterminationDate = cl_abap_context_info=>get_system_date(  ).
***
***ls_invoice-%param-_itemswithporeference = VALUE #(
*** ( supplierinvoiceitem = '000001'
*** purchaseorder = '4500000053'
*** purchaseorderitem = '00010'
*** ReferenceDocument = '5000000113'
*** ReferenceDocumentFiscalYear = '2024'
*** ReferenceDocumentItem = '0001'
*** documentcurrency = 'INR'
*** supplierinvoiceitemamount = 100
*** purchaseorderquantityunit = 'L'
*** quantityinpurchaseorderunit = 10
*** taxcode = 'G0'
*** )
*** ).
***
*** INSERT ls_invoice INTO TABLE lt_invoice.
***
***"Register the action
***MODIFY ENTITIES OF i_supplierinvoicetp
***ENTITY supplierinvoice
***EXECUTE Create from lt_invoice
***FAILED DATA(ls_failed)
***REPORTED DATA(ls_reported)
***MAPPED DATA(ls_mapped).

DATA : LV_LINE TYPE rblgp,
       LV_AMOUNT TYPE wrbtr_cs.
loop at LT_MILKCOLL_1 INTO data(Ls_MILKCOLL_1).

   CLEAR : ls_invoice, lT_invoice[], LV_LINE, LV_AMOUNT.

*  post Miro

    TRY.
     DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
     CATCH cx_uuid_error.
     "Error handling
    ENDTRY.

  LOOP AT LT_MILKCOLL INTO DATA(LS_MILKCOLL) WHERE lifnr = Ls_MILKCOLL_1-lifnr
                                             AND   sloc = Ls_MILKCOLL_1-sloc.

  LV_LINE = LV_LINE + 1.
  LV_AMOUNT = LV_AMOUNT + ( LS_MILKCOLL-Milk_Qty * LS_MILKCOLL-rate ).

*    ls_invoice-%param-_itemswithporeference = VALUE #(
    LS_DATA = VALUE #(
     supplierinvoiceitem = LV_LINE "'000001'
     purchaseorder = LS_MILKCOLL-ebeln
     purchaseorderitem = '00010'
     ReferenceDocument = LS_MILKCOLL-mblnr
     ReferenceDocumentFiscalYear = LS_MILKCOLL-mjahr
     ReferenceDocumentItem = '0001'
     documentcurrency = 'INR'
     supplierinvoiceitemamount = LS_MILKCOLL-Milk_Qty * LS_MILKCOLL-rate
     purchaseorderquantityunit = 'L'
     quantityinpurchaseorderunit = LS_MILKCOLL-Milk_Qty
     taxcode = 'V0'
     ).

     APPEND LS_DATA TO ls_invoice-%param-_itemswithporeference.
*     INSERT ls_invoice INTO TABLE lt_invoice.
   ENDLOOP.

    ls_invoice-%cid = lv_cid.
    ls_invoice-%param-supplierinvoiceiscreditmemo = abap_false.
    ls_invoice-%param-companycode = '1000'.
    ls_invoice-%param-invoicingparty = Ls_MILKCOLL_1-Lifnr.
    ls_invoice-%param-postingdate = P_DATE. "cl_abap_context_info=>get_system_date(  ).
    ls_invoice-%param-documentdate = cl_abap_context_info=>get_system_date(  ).
    ls_invoice-%param-documentcurrency = 'INR'.
    ls_invoice-%param-invoicegrossamount = LV_AMOUNT.
    ls_invoice-%param-taxiscalculatedautomatically = abap_true.
    ls_invoice-%param-supplierinvoiceidbyinvcgparty = Ls_MILKCOLL_1-Lifnr.
    ls_invoice-%param-BusinessPlace = '1000'.
    ls_invoice-%param-BusinessSectionCode = '1000'.
    ls_invoice-%param-PaymentMethod = 'T'.
    ls_invoice-%param-TaxDeterminationDate = cl_abap_context_info=>get_system_date(  ).
    ls_invoice-%param-DocumentHeaderText = 'AUTO_MIRO'.
    ls_invoice-%param-InvoiceReference = Ls_MILKCOLL_1-sloc.

  INSERT ls_invoice INTO TABLE lt_invoice.

    "Register the action
    MODIFY ENTITIES OF i_supplierinvoicetp
    ENTITY supplierinvoice
    EXECUTE Create from lt_invoice
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported)
    MAPPED DATA(ls_mapped).

IF ls_failed IS NOT INITIAL.
 DATA lo_message TYPE REF TO if_message.
* lo_message = ls_reported-supplierinvoice[ 1 ]-%msg.
  loop at ls_reported-supplierinvoice INTO data(ls_sup).
      lo_message = ls_sup-%msg.
      DATA(lv_result2) = lo_message->get_text( ).
           out->write( 'Order' ).
           out->write( lv_result2 ).
   endloop.
 "Error handling
ENDIF.

"Execution the action
COMMIT ENTITIES
 RESPONSE OF i_supplierinvoicetp
 FAILED DATA(ls_commit_failed)
 REPORTED DATA(ls_commit_reported).

IF ls_commit_reported IS NOT INITIAL.
 LOOP AT ls_commit_reported-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_invoice>).
 IF <ls_invoice>-supplierinvoice IS NOT INITIAL AND
 <ls_invoice>-supplierinvoicefiscalyear IS NOT INITIAL.
 "Success case
 ELSE.
 "Error handling
 ENDIF.
 ENDLOOP.
ENDIF.

IF ls_commit_failed IS NOT INITIAL.
 LOOP AT ls_commit_reported-supplierinvoice ASSIGNING <ls_invoice>.
 "Error handling
 ENDLOOP.
ENDIF.
endloop.


****** data : lv_key_date type datum.
******
******        lv_key_date =  cl_abap_context_info=>get_system_date(  ).
******
******    SELECT *
******      FROM ZMM_STOCKASONDATE( P_Language = @sy-langu, P_KeyDate = @lv_key_date )
******      WITH PRIVILEGED ACCESS
******      WHERE Plant eq '1101'
*******        AND StorageLocation IN @is_sel_criteria-lgort_rng
******        AND Material eq '000000000080000001'
******        INTO TABLE @data(lt_stock_on_date).

  ENDMETHOD.
ENDCLASS.
