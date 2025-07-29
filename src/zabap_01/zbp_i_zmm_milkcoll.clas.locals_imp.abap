CLASS lsc_zi_zmm_milkcoll DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_zmm_milkcoll IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_zmm_milkcoll        TYPE STANDARD TABLE OF zmm_milkcoll,
           ls_zmm_milkcoll        TYPE                   zmm_milkcoll,
           lt_zmm_milkcoll_x_control TYPE STANDARD TABLE OF zmm_milkcoll.

   IF create-milkcoll IS NOT INITIAL.
      lt_zmm_milkcoll = CORRESPONDING #( create-milkcoll MAPPING FROM ENTITY ).
      INSERT zmm_milkcoll FROM TABLE @lt_zmm_milkcoll.
    ENDIF.

    IF update IS NOT INITIAL.
      CLEAR lt_zmm_milkcoll.
      lt_zmm_milkcoll = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
      lt_zmm_milkcoll_x_control = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
      MODIFY zmm_milkcoll FROM TABLE @lt_zmm_milkcoll.


*      LOOP AT lt_zmm_milkcoll INTO DATA(lS_zmm_milkcoll_1).
*       IF lS_zmm_milkcoll_1-RATE IS NOT INITIAL.
*          UPDATE zmm_milkcoll SET RATE = @lS_zmm_milkcoll_1-RATE,
*                                  currency = 'INR'
*           WHERE id = @lS_zmm_milkcoll_1-ID.
*       ELSE.
*         MODIFY zmm_milkcoll FROM @lS_zmm_milkcoll_1.
*       ENDIF.
*      ENDLOOP.
    ENDIF.
    IF delete IS NOT INITIAL.
      LOOP AT delete-milkcoll INTO DATA(milkcoll_delete).
       select SINGLE ebeln from zmm_milkcoll
       WHERE id = @milkcoll_delete-ID
       into @data(lv_ebeln).
       if sy-subrc = 0 and lv_ebeln is INITIAL.
        DELETE FROM zmm_milkcoll WHERE id = @milkcoll_delete-ID.
       endif.
      ENDLOOP.
    ENDIF.

 IF zbp_i_zmm_milkcoll=>mapped_purchase_order IS NOT INITIAL
  AND update IS NOT INITIAL.
    LOOP AT zbp_i_zmm_milkcoll=>mapped_purchase_order-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
      CONVERT KEY OF i_purchaseordertp_2 FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
      <fs_pr_mapped>-purchaseorder = ls_pr_key-purchaseorder.
    ENDLOOP.
    LOOP AT update-milkcoll INTO  DATA(ls_milkcoll). " WHERE %control-OverallStatus = if_abap_behv=>mk-on.
      " Creates internal table with instance data
*      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
      UPDATE zmm_milkcoll SET ebeln = @ls_pr_key-purchaseorder
       WHERE id = @ls_milkcoll-ID.

    ENDLOOP.

  ENDIF.


 IF zbp_i_zmm_milkcoll=>mapped_material_document IS NOT INITIAL
  AND update IS NOT INITIAL.
    LOOP AT zbp_i_zmm_milkcoll=>mapped_material_document-materialdocument ASSIGNING FIELD-SYMBOL(<fs_md_mapped>).
      CONVERT KEY OF I_MATERIALDOCUMENTTP FROM <fs_md_mapped>-%pid TO DATA(ls_md_key).
      <fs_md_mapped>-MaterialDocument = ls_md_key-MaterialDocument.
      <fs_md_mapped>-MaterialDocumentYear = ls_md_key-MaterialDocumentYear.
    ENDLOOP.
    LOOP AT update-milkcoll INTO  ls_milkcoll. " WHERE %control-OverallStatus = if_abap_behv=>mk-on.
      " Creates internal table with instance data
*      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
      UPDATE zmm_milkcoll SET mblnr = @ls_md_key-MaterialDocument,
                              mjahr = @ls_md_key-MaterialDocumentYear
       WHERE id = @ls_milkcoll-ID.
    ENDLOOP.

  ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_MilkColl DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MilkColl RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR milkcoll RESULT result.

    METHODS createpo FOR MODIFY
      IMPORTING keys FOR ACTION milkcoll~createpo RESULT result.
    METHODS fetchrate FOR DETERMINE ON SAVE
      IMPORTING keys FOR milkcoll~fetchrate.
    METHODS creategrn FOR MODIFY
      IMPORTING keys FOR ACTION milkcoll~creategrn RESULT result.
    METHODS fetchname FOR DETERMINE ON MODIFY
      IMPORTING keys FOR milkcoll~fetchname.
    METHODS validate_date FOR VALIDATE ON SAVE
      IMPORTING keys FOR milkcoll~validate_date.
    METHODS fetchprice FOR MODIFY
      IMPORTING keys FOR ACTION milkcoll~fetchprice RESULT result.
    METHODS mandatory_data FOR VALIDATE ON SAVE
      IMPORTING keys FOR milkcoll~mandatory_data.

ENDCLASS.

CLASS lhc_MilkColl IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.

    " Read the active flag of the existing members
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
        ENTITY MilkColl
          FIELDS ( Ebeln Mblnr ) WITH CORRESPONDING #( keys )
        RESULT DATA(members)
        FAILED failed.

    result = VALUE #(
     FOR member IN members ( %key  = member-%key

*      %features-%action-delete  = COND #( WHEN member-Ebeln is not initial
*                             THEN if_abap_behv=>fc-o-disabled
*                             ELSE if_abap_behv=>fc-o-enabled )

      %features-%action-CreatePO  = COND #( WHEN member-Ebeln is not initial
                             THEN if_abap_behv=>fc-o-disabled
                             ELSE if_abap_behv=>fc-o-enabled )

      %features-%action-FetchPrice  = COND #( WHEN member-Ebeln is not initial
                             THEN if_abap_behv=>fc-o-disabled
                             ELSE if_abap_behv=>fc-o-enabled )

      %features-%action-CreateGrn  = COND #( WHEN member-Ebeln is initial
                             THEN if_abap_behv=>fc-o-disabled
                             ELSE
                             COND #( WHEN member-Mblnr is not initial
                             THEN if_abap_behv=>fc-o-disabled
                             ELSE if_abap_behv=>fc-o-enabled ) )

     ) ).


  ENDMETHOD.

  METHOD CreatePO.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( Plant Sloc CollDate CollTime Lifnr Matnr Snf Fat MilkQty Batch Rate ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member) WHERE ebeln is initial.
       DATA: LV_EBELN TYPE EBELN.

      "Create PO

*    Data: r_pocreate type REF TO zclmm_milkcoll,
*          LR_out  type ref to if_oo_adt_classrun_out.
*
*        CREATE OBJECT r_pocreate.
*        CALL METHOD r_pocreate->if_oo_adt_classrun~main( LR_out ).

DATA: purchase_orders      TYPE TABLE FOR CREATE i_purchaseordertp_2,
      purchase_order       LIKE LINE OF purchase_orders,
      purchase_order_items TYPE TABLE FOR CREATE i_purchaseordertp_2\_purchaseorderitem,
      purchase_order_item  LIKE LINE OF purchase_order_items,
      lv_matnr             type matnr.

data :  update_lines               TYPE TABLE FOR UPDATE ZI_ZMM_MILKCOLL\\MilkCOll,
        update_line                TYPE STRUCTURE FOR UPDATE ZI_ZMM_MILKCOLL\\MilkCOll,
        purchase_order_description TYPE c LENGTH 40.

    DATA(n1) = 0.
    DATA(n2) = 0.
*    DO 2 TIMES.
n1 += 1.
purchase_order =  VALUE #( %cid = |My%CID_{ n1 }|
purchaseordertype      = 'ZRAW' "'NB' "
companycode            = '1000'
purchasingorganization = '1000'
purchasinggroup        = '101' "'001' "
supplier               = member-Lifnr "'0001000000'
PurchaseOrderDate      = member-CollDate
                  %control = VALUE #(
                             purchaseordertype      = cl_abap_behv=>flag_changed
                             companycode            = cl_abap_behv=>flag_changed
                             purchasingorganization = cl_abap_behv=>flag_changed
                             purchasinggroup        = cl_abap_behv=>flag_changed
                             supplier               = cl_abap_behv=>flag_changed
                             PurchaseOrderDate      = cl_abap_behv=>flag_changed
                                                      ) ).
      APPEND purchase_order TO purchase_orders.
n2 += 1.
"Purchase Order Item Data 1
* lv_matnr = '000000000000000002'.

purchase_order_item = VALUE #(  %cid_ref = |My%CID_{ n1 }|
%target = VALUE #( ( %cid = |My%CID_ITEM{ n2 }|
material          = member-matnr "'000000000000000002'
plant             = member-plant "'1101'
orderquantity     = member-MilkQty "'5'
purchaseorderitem = '00010'
netpriceamount    = member-rate "'5'
Batch             = member-Batch "'TEST999111'
                  %control = VALUE #( material          = cl_abap_behv=>flag_changed
                                      plant             = cl_abap_behv=>flag_changed
                                      orderquantity     = cl_abap_behv=>flag_changed
                                      purchaseorderitem = cl_abap_behv=>flag_changed
                                      netpriceamount    = cl_abap_behv=>flag_changed
                                      Batch    = cl_abap_behv=>flag_changed
                                                      ) ) )  ).
      APPEND purchase_order_item TO purchase_order_items.
*    ENDDO.
"Purchase Order Header Data
    MODIFY ENTITIES OF i_purchaseordertp_2
    ENTITY purchaseorder
    CREATE FROM purchase_orders
    CREATE BY \_purchaseorderitem
    FROM purchase_order_items
    MAPPED DATA(mapped_po_headers)
    REPORTED DATA(reported_po_headers)
    FAILED DATA(failed_po_headers).

    " Check if process is not failed
*    cl_abap_unit_assert=>assert_initial( failed_po_headers-purchaseorder ).
*    cl_abap_unit_assert=>assert_initial( reported_po_headers-purchaseorder ).

*    LOOP AT reported_po_headers-purchaseorderitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
*      DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
**           out->write( 'Item' ).
**           out->write( lv_result1 ).
*    ENDLOOP.
*    LOOP AT reported_po_headers-purchaseorder ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
*      DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
**           out->write( 'Order' ).
**           out->write( lv_result2 ).
*    ENDLOOP.
*
*    LOOP AT mapped_po_headers-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_so_mapped>).
*      CONVERT KEY OF I_PurchaseOrderTP_2 FROM <fs_so_mapped>-%pid TO DATA(ls_so_key).
**          out->write( 'Purchase Order:'  && ls_so_key-PurchaseOrder ).
*    ENDLOOP.
*

 "retrieve the generated
    zbp_i_zmm_milkcoll=>mapped_purchase_order-purchaseorder = mapped_po_headers-purchaseorder.

    "set a flag to check in the save sequence that purchase requisition has been created
    "the correct value for PurchaseRequisition has to be calculated in the save sequence using convert key
    LOOP AT keys INTO DATA(key).
      IF line_exists( members[ id = key-ID ] ).
*        update_line-DirtyFlag              = abap_true.
        update_line-%tky                   = key-%tky.
        update_line-Ebeln                  = 'X'.
        APPEND update_line TO update_lines.
      ENDIF.
    ENDLOOP.

MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
        FIELDS ( Ebeln )
        WITH update_lines
      REPORTED reported
      FAILED failed
      MAPPED mapped.

    IF failed IS INITIAL.
      "Read the changed data for action result
      READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
        ENTITY MilkCOll
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(result_read).
      "return result entities
      result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                          %param = result_order ) ).
    ENDIF.

*         IF LV_EBELN IS NOT INITIAL.
*            MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
*                    ENTITY MilkColl
*                      UPDATE
*                        FIELDS ( Rate Currency )
*                        WITH VALUE #(
*                                      ( %tky = member-%tky
*                                        Ebeln = lv_EBELN
*                                        ) )
*
*       FAILED failed
*       REPORTED reported.
*
*         ENDIF.

    ENDLOOP.


*    " Fill the response table
*    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
*      ENTITY MilkColl
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT members.
*
*    result = VALUE #( FOR member1 IN members
*                        ( %tky   = member1-%tky
*                          %param = member1 ) ).

  ENDMETHOD.

  METHOD FetchRate.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( Plant Sloc CollDate CollTime Lifnr Matnr Snf Fat ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

*         select SINGLE BPSupplierFullName from i_supplier
*         WHERE Supplier = @member-lifnr
*         into @data(lv_name1).

       DATA: LV_RATE      TYPE ZMM_MILKRATECARD-RATE,
             LV_BaseRate  TYPE ZMM_MILKRATECARD-base_rate,
             LV_Incentive TYPE ZMM_MILKRATECARD-incentive,
             LV_Commision TYPE ZMM_MILKRATECARD-commision,
             LV_Transport TYPE ZMM_MILKRATECARD-transport.

       CALL FUNCTION 'Z_FETCH_MILK_RATE'
         EXPORTING
           iv_plant = member-Plant
           iv_sloc  = member-Sloc
           iv_lifnr = member-Lifnr
           IV_MILKTYPE = member-Milktype
           iv_matnr = member-Matnr
           iv_date  = member-CollDate
           iv_fat   = member-Fat
           iv_snf   = member-Snf
         IMPORTING
           ev_rate  = LV_RATE
           EV_BASERATE  = LV_BASERATE
           EV_INCENTIVE = LV_INCENTIVE
           EV_COMMISION = LV_COMMISION
           EV_TRANSPORT = LV_TRANSPORT.

         IF LV_RATE IS NOT INITIAL.
            MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
                    ENTITY MilkColl
                      UPDATE
*                        FIELDS ( Rate Currency Name1 )
                        FIELDS ( Rate Currency baserate Incentive Commision Transport )
                        WITH VALUE #(
                                      ( %tky = member-%tky
                                        Rate = lv_rate
                                        baserate = lv_baserate
                                        Incentive = lv_Incentive
                                        Commision = lv_Commision
                                        Transport = lv_Transport
                                        Currency = 'INR'
*                                        Name1 = lv_name1
                                        ) ).
         ENDIF.

    ENDLOOP.

  ENDMETHOD.

METHOD fetchname.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( Plant Sloc CollDate CollTime Lifnr Matnr Snf Fat ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

         select SINGLE BPSupplierFullName from i_supplier
         WHERE Supplier = @member-lifnr
         into @data(lv_name1).

            MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
                    ENTITY MilkColl
                      UPDATE
                        FIELDS ( Name1 )
                        WITH VALUE #(
                                      ( %tky = member-%tky
                                        Name1 = lv_name1
                                        ) ).

    ENDLOOP.


  ENDMETHOD.

  METHOD validate_date.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( CollDate ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

  LOOP AT members INTO DATA(member).

   if member-colldate > sy-datlo.
*   cl_abap_context_info=>get_system_date(  ).

    append VALUE #( %tky = member-%tky ) to failed-milkcoll.

    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Future date not allowed!' )
                     ) to reported-milkcoll.
   endif.

  Endloop.

  ENDMETHOD.


  METHOD CreateGrn.

data :  update_lines   TYPE TABLE FOR UPDATE ZI_ZMM_MILKCOLL\\MilkCOll,
        update_line    TYPE STRUCTURE FOR UPDATE ZI_ZMM_MILKCOLL\\MilkCOll.

      " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( Plant Sloc colldate Matnr shift MilkQty Batch Ebeln Mblnr Mjahr ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).
    DATA ST_DATE TYPE d.

    DATA : DAY TYPE INT4,
           LV_MATNR TYPE MATNR,
           lv_batch type charg_d.
  DATA: DAYS(3) TYPE N.
*    DAY =  ED_DATE - ST_DATE.

*    DATA(creation_date) = sy-datlo. "cl_abap_context_info=>get_system_date(  ).
*    ST_DATE = | { creation_date+0(4) } '0101' |.
*    DATA(ED_DATE) = creation_date + 1.
*
*   CALL FUNCTION'Z_GET_DATE_DIFF'
*     EXPORTING
*       IV_DATE = creation_date
*     IMPORTING
*       EV_DAYS = DAY.
*
*      DAYS = DAY.

*   CALL METHOD CL_ABAP_TSTMP=>td_subtract(  EXPORTING date1 = ST_DATE
*                                                      time1 = cl_abap_context_info=>get_system_time(  )
*                                                      date2 = creation_date
*                                                      time2 = cl_abap_context_info=>get_system_time(  )
*                                            IMPORTING res_secs = DATA(lv_day)
*
*                                           ).

* lv_matnr = '000000000000000002'.

    LOOP AT members INTO DATA(member) WHERE ebeln is NOT initial
                                        AND MBLNR IS INITIAL.

      clear lv_batch.

      if member-batch is not INITIAL.
       lv_batch = member-batch.
      else.


        DATA(creation_date) = member-CollDate.
        ST_DATE = | { creation_date+0(4) } '0101' |.
        DATA(ED_DATE) = creation_date + 1.

       CALL FUNCTION'Z_GET_DATE_DIFF'
         EXPORTING
           IV_DATE = creation_date
         IMPORTING
           EV_DAYS = DAY.

          DAYS = DAY.


       lv_batch = |{ member-Sloc }{ dayS }{ creation_date+2(2) }{ member-Shift }|.
      endif.

        MODIFY ENTITIES OF i_materialdocumenttp
         ENTITY MaterialDocument
         CREATE FROM VALUE #( ( %cid = 'CID_001'
         goodsmovementcode = '01'
         postingdate = member-colldate "creation_date
         documentdate = creation_date
         %control-goodsmovementcode = cl_abap_behv=>flag_changed
         %control-postingdate = cl_abap_behv=>flag_changed
         %control-documentdate = cl_abap_behv=>flag_changed
         ) )
         ENTITY MaterialDocument
         CREATE BY \_MaterialDocumentItem
         FROM VALUE #( (
         %cid_ref = 'CID_001'
         %target = VALUE #( ( %cid = 'CID_ITM_001'
         plant = member-plant
         material = member-matnr
         GoodsMovementType = '101'
         storagelocation = member-Sloc
         QuantityInEntryUnit = member-MilkQty
         entryunit = 'L'
         GoodsMovementRefDocType = 'B'
         Batch = lv_batch
         PurchaseOrder = member-ebeln
         PurchaseOrderItem = '00010'
         %control-plant = cl_abap_behv=>flag_changed
         %control-material = cl_abap_behv=>flag_changed
         %control-GoodsMovementType = cl_abap_behv=>flag_changed
         %control-storagelocation = cl_abap_behv=>flag_changed
         %control-QuantityInEntryUnit = cl_abap_behv=>flag_changed
         %control-entryunit = cl_abap_behv=>flag_changed
         %control-Batch = cl_abap_behv=>flag_changed
         %control-PurchaseOrder = cl_abap_behv=>flag_changed
         %control-PurchaseOrderItem = cl_abap_behv=>flag_changed
         %control-GoodsMovementRefDocType = cl_abap_behv=>flag_changed
         ) )


         ) )
         MAPPED DATA(ls_create_mapped)
         FAILED DATA(ls_create_failed)
         REPORTED DATA(ls_create_reported).


 "retrieve the generated
    zbp_i_zmm_milkcoll=>mapped_material_document-materialdocument = ls_create_mapped-materialdocument.

    "set a flag to check in the save sequence that purchase requisition has been created
    "the correct value for PurchaseRequisition has to be calculated in the save sequence using convert key
    LOOP AT keys INTO DATA(key).
      IF line_exists( members[ id = key-ID ] ).
*        update_line-DirtyFlag              = abap_true.
        update_line-%tky                   = key-%tky.
        update_line-Mblnr                  = 'X'.
        APPEND update_line TO update_lines.
      ENDIF.
    ENDLOOP.

MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
        FIELDS ( Mblnr )
        WITH update_lines
      REPORTED reported
      FAILED failed
      MAPPED mapped.

    IF failed IS INITIAL.
      "Read the changed data for action result
      READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
        ENTITY MilkCOll
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(result_read).
      "return result entities
      result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                          %param = result_order ) ).
    ENDIF.

     endloop.
  ENDMETHOD.

  METHOD FetchPrice.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        FIELDS ( Plant Sloc Counter CollDate CollTime
                              Shift Milktype Matnr Lifnr Fatuom Fat Snf
                              Protain Milkuom MilkQty Currency Rate Ebeln
                              Mblnr Mjahr Mirodoc Miroyear Name1 CreatedBy CreatedOn )
                              WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member) WHERE RATE IS INITIAL.


       DATA: LV_RATE      TYPE ZMM_MILKRATECARD-RATE,
             LV_BaseRate  TYPE ZMM_MILKRATECARD-base_rate,
             LV_Incentive TYPE ZMM_MILKRATECARD-incentive,
             LV_Commision TYPE ZMM_MILKRATECARD-commision,
             LV_Transport TYPE ZMM_MILKRATECARD-transport.

       CALL FUNCTION 'Z_FETCH_MILK_RATE'
         EXPORTING
           iv_plant = member-Plant
           iv_sloc  = member-Sloc
           iv_lifnr = member-Lifnr
           IV_MILKTYPE = member-Milktype
           iv_matnr = member-Matnr
           iv_date  = member-CollDate
           iv_fat   = member-Fat
           iv_snf   = member-Snf
         IMPORTING
           ev_rate  = LV_RATE
           EV_BASERATE  = LV_BASERATE
           EV_INCENTIVE = LV_INCENTIVE
           EV_COMMISION = LV_COMMISION
           EV_TRANSPORT = LV_TRANSPORT.


         IF LV_RATE IS NOT INITIAL.


            MODIFY ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
                    ENTITY MilkColl
                      UPDATE
*                        FIELDS ( Rate Currency )
*                        WITH VALUE #(
*                                      ( %tky = member-%tky
*                                        Rate = lv_rate
*                                        Currency = 'INR'
**                                        Name1 = lv_name1
*                                        ) ).
                 FIELDS (     Plant Sloc Counter CollDate CollTime
                              Shift Milktype Matnr Lifnr Fatuom Fat Snf
                              Protain Milkuom MilkQty Currency Rate baserate Incentive Commision Transport
                              Ebeln Mblnr Mjahr Mirodoc Miroyear Name1 CreatedBy CreatedOn  )
                           WITH VALUE #(
                                      ( %tky = member-%tky
                                        Rate = lv_rate
                                        baserate = lv_baserate
                                        Incentive = lv_Incentive
                                        Commision = lv_Commision
                                        Transport = lv_Transport
                                        Currency = 'INR'
                                        Plant = MEMBER-plant
                                        Sloc = MEMBER-sloc
                                        Counter = MEMBER-counter
                                        CollDate = MEMBER-colldate
                                        CollTime = MEMBER-colltime
                                        Shift = MEMBER-shift
                                        Milktype = MEMBER-milktype
                                        Matnr = MEMBER-matnr
                                        Lifnr = MEMBER-lifnr
                                        Fatuom = MEMBER-fatuom
                                        Fat = MEMBER-fat
                                        Snf = MEMBER-snf
                                        Protain = MEMBER-protain
                                        Milkuom = MEMBER-milkuom
                                        MilkQty = MEMBER-milkqty
                                        Ebeln = MEMBER-ebeln
                                        Mblnr = MEMBER-mblnr
                                        Mjahr = MEMBER-mjahr
                                        Mirodoc = MEMBER-mirodoc
                                        Miroyear = MEMBER-miroyear
                                        Name1 = MEMBER-name1
                                        CreatedBy = MEMBER-createdby
                                        CreatedOn = MEMBER-createdon
                                        ) ).


         ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD mandatory_data.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll IN LOCAL MODE
      ENTITY MilkColl
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

  LOOP AT members INTO DATA(member).

   if member-plant is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Plant is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

   if member-Sloc is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Storage Location is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

   if member-shift is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'shift is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

   if member-milktype is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Milk type is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

   if member-matnr is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Material is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.
   if member-lifnr is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Supplier is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

   if member-Fat is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'FAT % is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.
   if member-snf is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'SNF % is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.
   if member-milkqty is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Milk Qty is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.
   if member-milkuom is INITIAL.
    append VALUE #( %tky = member-%tky ) to failed-milkcoll.
    append VALUE #( %tky = keys[ 1 ]-%tky
                    %msg = new_message_With_text(
                    severity = if_abap_behv_message=>severity-error
                    text = 'Milk UOM is Mandatory Entry.' )
                     ) to reported-milkcoll.
   endif.

  Endloop.

  ENDMETHOD.

ENDCLASS.
