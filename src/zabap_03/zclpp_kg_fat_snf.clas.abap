CLASS zclpp_kg_fat_snf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES if_oo_adt_classrun.

    DATA : p_plant TYPE c LENGTH 4,
           p_sloc  TYPE c LENGTH 4,
           p_rawm  TYPE c LENGTH 40,
           p_ordm  TYPE c LENGTH 40,
           p_simul TYPE abap_boolean.

    TYPES : BEGIN OF ty_msg,
              batch    TYPE charg_d,
              msg(200) TYPE c,
            END OF ty_msg.
    DATA : it_msg TYPE STANDARD TABLE OF ty_msg,
           wa_msg TYPE ty_msg,
           wa_log TYPE zpp_kg_fat_snf.

    DATA lv_msg TYPE c LENGTH 200.

    METHODS: post.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLPP_KG_FAT_SNF IMPLEMENTATION.


  METHOD if_apj_dt_exec_object~get_parameters.

    " Return the supported selection parameters here
    et_parameter_def = VALUE #(
      ( selname = 'P_PLANT' kind = if_apj_dt_exec_object=>parameter
        datatype = 'C' length = 4
        param_text  = 'Plant' changeable_ind = abap_true )
      ( selname = 'P_SLOC' kind = if_apj_dt_exec_object=>parameter
        datatype = 'C' length = 4
        param_text  = 'St. Location' changeable_ind = abap_true )
      ( selname = 'P_RAWM' kind = if_apj_dt_exec_object=>parameter
        datatype = 'C' length = 40
        param_text  = 'Raw Milk Material Code' changeable_ind = abap_true )
      ( selname = 'P_ORDM' kind = if_apj_dt_exec_object=>parameter
        datatype = 'C' length = 40
        param_text  = 'Order Header Material Code' changeable_ind = abap_true )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter
        datatype = 'C' length = 1
        param_text = 'Simulate Only' checkbox_ind = abap_false changeable_ind = abap_true )
      ).


    " Return the default parameters values here
    et_parameter_val = VALUE #(
      ( selname = 'P_PLANT' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '1102' )
      ( selname = 'P_SLOC' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = 'S004' )
      ( selname = 'P_RAWM' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '000000000000000033' )
      ( selname = 'P_ORDM' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low = '000000000000000034' )
      ( selname = 'P_SIMUL' kind = if_apj_dt_exec_object=>parameter sign = 'I' option = 'EQ' low =  abap_true )
      ).
  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.

    " Getting the actual parameter values(Just for show. Not needed for the logic below)
    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_PLANT'.
          p_plant = ls_parameter-low.
        WHEN 'P_SLOC'.
          p_sloc = ls_parameter-low.
        WHEN 'P_RAWM'.
          p_rawm = ls_parameter-low.
        WHEN 'P_ORDM'.
          p_ordm = ls_parameter-low.
        WHEN 'P_SIMUL'.
          p_simul = ls_parameter-low.
      ENDCASE.
    ENDLOOP.

    CALL METHOD post( ).

  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.

    p_plant = '1101'.
    p_sloc  = 'S001'.

    CALL METHOD post( ).

  ENDMETHOD.


  METHOD post .
    TRY.

        "Get Current Stock at St Location

        SELECT product AS material, plant, storagelocation, batch, materialbaseunit,
               matlwrhsstkqtyinmatlbaseunit AS stock
        FROM i_stockquantitycurrentvalue_2(  p_displaycurrency = 'E' )
        WHERE  plant = @p_plant
        AND   storagelocation = @p_sloc
        AND   product = @p_rawm
        AND   inventoryspecialstocktype = ''
        and   inventorystocktype = '01'
*        AND   batch = '8122C24A04'
        INTO TABLE @DATA(lt_stock).

*select Material, plant, StorageLocation, batch,
*       MaterialBaseUnit, sum( MatlWrhsStkQtyInMatlBaseUnit ) as stock
* from I_MaterialStock_2
*WHERE  Plant = @p_plant
*AND   StorageLocation = @p_sloc
*and   Material = @P_RAWM "'000000000000000033'
**AND   batch = 'CH02161223'
*group by Material, plant, StorageLocation, batch, MaterialBaseUnit
*into TABLE @data(lt_stock).

        DELETE lt_stock WHERE stock IS INITIAL.

        "Fetch current active process order
*select ManufacturingOrder, ManufacturingOrderItem, ManufacturingOrderType,
*       creationdate, mfgorderactualreleasedate, Product, ProductionPlant,
*       Storagelocation, ObjectInternalID, BillOfMaterialinternalid,
*       reservation
*from i_manufacturingorder
*where ManufacturingOrderType = 'YBM2'
*AND   ProductionPlant = @p_plant
*and   Product = @P_ORDM "'000000000000000034'
*into TABLE @data(lt_order).

        SELECT a~manufacturingorder, a~manufacturingorderitem, a~manufacturingordertype,
               a~creationdate, a~mfgorderactualreleasedate, a~product, a~productionplant,
               a~storagelocation, a~objectinternalid, a~billofmaterialinternalid,
               a~reservation
        FROM i_manufacturingorder AS a
        JOIN i_mfgorderwithstatus AS b
        ON a~manufacturingorder = b~manufacturingorder
        WHERE a~manufacturingordertype = 'YBM2'
        AND   a~productionplant = @p_plant
        AND   a~product = @p_ordm "'000000000000000034'
        AND   b~orderisreleased = 'X'
        INTO TABLE @DATA(lt_order).

        IF lt_order[] IS NOT INITIAL.
          SORT lt_order BY creationdate DESCENDING manufacturingorder DESCENDING.
          READ TABLE lt_order INTO DATA(ls_order) INDEX 1.
        ENDIF.

        IF ls_order-reservation IS NOT INITIAL.
          SELECT reservation, reservationitem, plant, storagelocation, product,
                 goodsmovementtype
                 FROM i_reservationdocumentitem
                 WHERE reservation = @ls_order-reservation
                 INTO TABLE @DATA(lt_res).
        ENDIF.

        IF lt_stock[] IS NOT INITIAL.
          SELECT product, producttype FROM i_product
          FOR ALL ENTRIES IN @lt_stock
          WHERE product = @lt_stock-material
          AND   producttype = 'ZRAW'
          AND   productgroup = '2001'
          INTO TABLE @DATA(lt_product).

          SELECT matnr, charg, fulltruckunload FROM zmmt_weigh_bridg
          FOR ALL ENTRIES IN @lt_stock
*          WHERE matnr = @lt_stock-material
*          AND   charg = @lt_stock-batch
           WHERE charg = @lt_stock-batch
          INTO TABLE @DATA(lt_truckunload).

        ENDIF.

*---------------------------------------------------------
        DATA : lv_fat TYPE p DECIMALS 2,
               lv_snf TYPE p DECIMALS 2.

        DATA: t_header TYPE TABLE FOR CREATE i_materialdocumenttp,
              w_header LIKE LINE OF t_header,
              t_items  TYPE TABLE FOR CREATE i_materialdocumenttp\_materialdocumentitem,
              w_items  LIKE LINE OF t_items,
              lv_qty   TYPE menge_d,
              lv_item  LIKE ls_order-manufacturingorderitem,
              creation_date type datum.


*        DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).

        DATA(n1) = 0.
        DATA(n2) = 0.

        TRY.
            DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                   'ZPP_KG_FAT_SNF' subobject = 'ZPP_SUB_KG_FAT_SNF' ) ).

            lv_msg = 'Job Started'.

            DATA(l_free_text) = cl_bali_free_text_setter=>create( severity =
                                if_bali_constants=>c_severity_status
                                text = lv_msg ).

            l_log->add_item( item = l_free_text ).

            "Save the log into the database
            cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
            COMMIT WORK.
            CLEAR wa_msg.

            LOOP AT lt_stock INTO DATA(ls_stock).

*                SELECT SINGLE LastGoodsReceiptDate from i_batch
*                where material = @ls_stock-material
*                AND   batch = @ls_stock-batch
*                INTO @data(lv_gr_date).
*                if lv_gr_date is NOT INITIAL.
*                 creation_date = lv_gr_date.
*                else.
                 creation_date = cl_abap_context_info=>get_system_date(  ).
*                endif.

              READ TABLE lt_product INTO DATA(ls_product)
                WITH KEY product = ls_stock-material.
              IF sy-subrc = 0.
                READ TABLE lt_truckunload INTO DATA(ls_truckunload)
*                WITH KEY matnr = ls_stock-material
                 WITH KEY  charg = ls_stock-batch.
                IF ls_truckunload-fulltruckunload = ''. "sy-subrc = 0 AND
                  CONTINUE.
                ENDIF.
              ENDIF.


              CLEAR: lv_fat, lv_snf, lv_item, wa_log.

              SELECT SINGLE * FROM zpp_kg_fat_snf
              WHERE batch = @ls_stock-batch
              INTO @wa_log.
              IF sy-subrc NE 0.
                wa_log-batch = ls_stock-batch.
              ENDIF.

              READ ENTITIES OF i_batchtp_2
              ENTITY batch BY \_batchcharacteristictp
              ALL FIELDS WITH VALUE #( ( %key = VALUE #( material = ls_stock-material
                                                         batch = ls_stock-batch ) ) )
              RESULT DATA(lt_result)
              FAILED DATA(lt_failed)
              REPORTED DATA(lt_reported).

              LOOP AT lt_result INTO DATA(lw_result).
                DATA(v_index) = sy-tabix.

                READ ENTITIES OF i_batchtp_2
                 ENTITY batchcharacteristic BY \_batchcharacteristicvaluetp
                 ALL FIELDS WITH VALUE #( (
                     %key = VALUE #( material = lw_result-material
                                     batch = lw_result-batch
                                     charcinternalid = lw_result-charcinternalid ) ) )
                 RESULT DATA(result)
                 FAILED DATA(failed)
                 REPORTED DATA(reported).

                IF result[] IS NOT INITIAL.

                  READ TABLE result INTO DATA(l_result) INDEX 1.

                  CASE v_index.
                    WHEN 5.
                      lv_snf = l_result-charcfromdecimalvalue.
                    WHEN 4.
                      lv_fat = l_result-charcfromdecimalvalue.
                  ENDCASE.
                ENDIF.

              ENDLOOP.

              IF lv_snf IS NOT INITIAL AND
                 lv_fat IS NOT INITIAL.

                CLEAR : n1, n2, t_items[], t_header[].

                IF wa_log-gr_doc IS INITIAL.

                  w_header =  VALUE #( %cid = 'CID_001'
                                       goodsmovementcode = '02'
                                       postingdate = creation_date
                                       documentdate = creation_date

                                  %control = VALUE #(
                                             goodsmovementcode      = cl_abap_behv=>flag_changed
                                             postingdate            = cl_abap_behv=>flag_changed
                                             documentdate           = cl_abap_behv=>flag_changed
                                                                      ) ).
                  APPEND w_header TO t_header.

                  DATA : lv_cnt TYPE n.
                  CLEAR lv_cnt.
                  LOOP AT lt_res INTO DATA(ls_res) WHERE goodsmovementtype = 101.
                    lv_cnt = lv_cnt + 1.

                    SELECT SINGLE FROM i_product FIELDS materialvolume, sizeordimensiontext
                    WHERE product = @ls_stock-material
                    INTO @DATA(lv_volume).

                    IF lv_cnt = 1.
* lv_qty = ( ls_stock-stock * '1.030' ) * lv_fat / 100.
                      lv_qty = ( ls_stock-stock * lv_volume-sizeordimensiontext ) * lv_fat / 100.
                    ELSE.
* lv_qty = ( ls_stock-stock * '1.030' ) * lv_snf / 100.
                      lv_qty = ( ls_stock-stock * lv_volume-sizeordimensiontext ) * lv_snf / 100.
                    ENDIF.

                    lv_item += 1.
                    n2 += 1.
                    w_items = VALUE #(  %cid_ref = 'CID_001'
                                        %target = VALUE #( ( %cid = |CID_ITEM_{ n2 }|
                                         plant = ls_res-plant
                                         material = ls_res-product
                                         goodsmovementtype = '101'
                                         storagelocation = ls_res-storagelocation
                                         quantityinentryunit = lv_qty
                                         entryunit = 'KG'
                                         goodsmovementrefdoctype = 'F'
                                         batch = |{ ls_res-plant }{ creation_date+6(2) }{ creation_date+4(2) }{ creation_date+2(2) }|
                                         manufacturingorder = ls_order-manufacturingorder
                                         manufacturingorderitem = lv_item
                                         manufacturedate = creation_date

                                      %control = VALUE #(
                                         plant                   = cl_abap_behv=>flag_changed
                                         material                = cl_abap_behv=>flag_changed
                                         goodsmovementtype       = cl_abap_behv=>flag_changed
                                         storagelocation         = cl_abap_behv=>flag_changed
                                         quantityinentryunit     = cl_abap_behv=>flag_changed
                                         entryunit               = cl_abap_behv=>flag_changed
                                         goodsmovementrefdoctype = cl_abap_behv=>flag_changed
                                         batch                   = cl_abap_behv=>flag_changed
                                         manufacturingorder      = cl_abap_behv=>flag_changed
                                         manufacturingorderitem  = cl_abap_behv=>flag_changed
                                         manufacturedate         = cl_abap_behv=>flag_changed
                                                                          ) ) )  ).
                    APPEND w_items TO t_items.


                  ENDLOOP.

                  MODIFY ENTITIES OF i_materialdocumenttp
                  ENTITY materialdocument
                  CREATE FROM t_header
                  CREATE BY \_materialdocumentitem
                  FROM t_items
                       MAPPED DATA(lm_mapped)
                       FAILED DATA(lm_failed)
                       REPORTED DATA(lm_reported).

                  LOOP AT lm_reported-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
                    DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).
*           out->write( 'Item' ).
*           out->write( lv_result1 ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_result1.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.

                    CONCATENATE ls_stock-batch lv_result1
                    INTO lv_msg SEPARATED BY ' : '.

                    l_free_text = cl_bali_free_text_setter=>create( severity =
                                        if_bali_constants=>c_severity_status
                                        text = lv_msg ).

                    l_log->add_item( item = l_free_text ).

                    "Save the log into the database
                    cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                    COMMIT WORK.

                  ENDLOOP.
                  LOOP AT lm_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
                    DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
*           out->write( 'Order' ).
*           out->write( lv_result2 ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_result2.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.

                    CONCATENATE ls_stock-batch lv_result2
                    INTO lv_msg SEPARATED BY ' : '.

                    l_free_text = cl_bali_free_text_setter=>create( severity =
                                        if_bali_constants=>c_severity_status
                                        text = lv_msg ).

                    l_log->add_item( item = l_free_text ).

                    "Save the log into the database
                    cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                    COMMIT WORK.

                  ENDLOOP.

                if lm_failed is INITIAL.
                  COMMIT ENTITIES BEGIN
                 RESPONSE OF i_materialdocumenttp
                  FAILED DATA(commit_failed)
                  REPORTED DATA(commit_reported).

                  LOOP AT commit_reported-materialdocument ASSIGNING FIELD-SYMBOL(<lfs_commit_rep_h>).
                    DATA(lv_res_h) = <lfs_commit_rep_h>-%msg->if_message~get_text( ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_res_h.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
*           out->write( 'Item' ).
*           out->write( lv_res ).
                  ENDLOOP.

                  LOOP AT commit_reported-materialdocumentitem ASSIGNING FIELD-SYMBOL(<lfs_commit_rep>).
                    DATA(lv_res1) = <lfs_commit_rep>-%msg->if_message~get_text( ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_res1.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
*           out->write( 'Item' ).
*           out->write( lv_res ).
                  ENDLOOP.

                  if commit_failed is INITIAL.
                  LOOP AT lm_mapped-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header>).
                    CONVERT KEY OF i_materialdocumenttp FROM <keys_header>-%pid TO DATA(ls_md_key).
                  ENDLOOP.
                  endif.


*LOOP AT lm_mapped-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item>).
* CONVERT KEY OF i_materialdocumentitemtp
* FROM <keys_item>-%pid
* TO <keys_item>-%key.
*ENDLOOP.

                  COMMIT ENTITIES END.
                 endif.

                  IF ls_md_key-materialdocument IS NOT INITIAL.

                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    CONCATENATE 'GR Document posted' ls_md_key-materialdocument
                    INTO wa_msg-msg SEPARATED BY ''.
                    APPEND wa_msg TO it_msg.

*   update Log
                    wa_log-batch     = ls_stock-batch.
                    wa_log-gr_doc    = ls_md_key-materialdocument.
                    wa_log-gr_doc_yr = ls_md_key-materialdocumentyear.
                    MODIFY zpp_kg_fat_snf FROM @wa_log.
                    COMMIT WORK.

                    CONCATENATE ls_stock-batch wa_msg-msg
                    INTO lv_msg SEPARATED BY ' : '.

                    l_free_text = cl_bali_free_text_setter=>create( severity =
                                        if_bali_constants=>c_severity_status
                                        text = lv_msg ).

                    l_log->add_item( item = l_free_text ).

                    "Save the log into the database
                    cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                    COMMIT WORK.
                    CLEAR wa_msg.
                  ENDIF.


                ENDIF.


                IF wa_log-gr_doc IS NOT INITIAL AND
                   wa_log-gi_doc IS INITIAL.

                  ls_md_key-materialdocument =  wa_log-gi_doc.
                  WAIT UP TO 2 SECONDS.
                  CLEAR: t_header[], t_items[].

                  w_header =  VALUE #( %cid = 'CID_001'
                                       goodsmovementcode = '03'
                                       postingdate = creation_date
                                       documentdate = creation_date

                                  %control = VALUE #(
                                             goodsmovementcode      = cl_abap_behv=>flag_changed
                                             postingdate            = cl_abap_behv=>flag_changed
                                             documentdate           = cl_abap_behv=>flag_changed
                                                                      ) ).
                  APPEND w_header TO t_header.

                  LOOP AT lt_res INTO ls_res WHERE goodsmovementtype = 261
                                             AND   product = ls_stock-material.
                    n2 += 1.
                    w_items = VALUE #(  %cid_ref = 'CID_001'
                                        %target = VALUE #( ( %cid = |CID_ITEM_{ n2 }|
                                         plant = ls_res-plant
                                         material = ls_res-product
                                         goodsmovementtype = '261'
                                         storagelocation = ls_res-storagelocation
                                         quantityinentryunit = ls_stock-stock
                                         entryunit = ls_stock-materialbaseunit " 'L'
                                         goodsmovementrefdoctype = ''
                                         batch = ls_stock-batch
                                         manufacturingorder = ls_order-manufacturingorder
*                                         manufacturingorderitem = '0001'
                                         reservation = ls_res-reservation
                                         reservationitem = ls_res-reservationitem
*                     ManufactureDate = creation_date

                                      %control = VALUE #(
                                         plant                   = cl_abap_behv=>flag_changed
                                         material                = cl_abap_behv=>flag_changed
                                         goodsmovementtype       = cl_abap_behv=>flag_changed
                                         storagelocation         = cl_abap_behv=>flag_changed
                                         quantityinentryunit     = cl_abap_behv=>flag_changed
                                         entryunit               = cl_abap_behv=>flag_changed
                                         goodsmovementrefdoctype = cl_abap_behv=>flag_changed
                                         batch                   = cl_abap_behv=>flag_changed
                                         manufacturingorder      = cl_abap_behv=>flag_changed
                                         manufacturingorderitem  = cl_abap_behv=>flag_changed
*                     ManufactureDate         = cl_abap_behv=>flag_changed
                                         reservation             = cl_abap_behv=>flag_changed
                                         reservationitem         = cl_abap_behv=>flag_changed
                                                                          ) ) )  ).
                    APPEND w_items TO t_items.

                  ENDLOOP.

                  MODIFY ENTITIES OF i_materialdocumenttp
                  ENTITY materialdocument
                  CREATE FROM t_header
                  CREATE BY \_materialdocumentitem
                  FROM t_items
                       MAPPED DATA(lm_mapped_1)
                       FAILED DATA(lm_failed_1)
                       REPORTED DATA(lm_reported_1).

                  LOOP AT lm_reported_1-materialdocument ASSIGNING FIELD-SYMBOL(<ls_so_reported_3>).
                    DATA(lv_result3) = <ls_so_reported_3>-%msg->if_message~get_text( ).
*           out->write( 'Item' ).
*           out->write( lv_result3 ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_result3.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.

                    CONCATENATE ls_stock-batch lv_result3
                    INTO lv_msg SEPARATED BY ' : '.

                    l_free_text = cl_bali_free_text_setter=>create( severity =
                                        if_bali_constants=>c_severity_status
                                        text = lv_msg ).

                    l_log->add_item( item = l_free_text ).

                    "Save the log into the database
                    cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                    COMMIT WORK.

                  ENDLOOP.
                  LOOP AT lm_reported_1-materialdocumentitem ASSIGNING FIELD-SYMBOL(<ls_so_reported_4>).
                    DATA(lv_result4) = <ls_so_reported_4>-%msg->if_message~get_text( ).
*           out->write( 'Order' ).
*           out->write( lv_result4 ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_result4.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.

                    CONCATENATE ls_stock-batch lv_result4
                    INTO lv_msg SEPARATED BY ' : '.

                    l_free_text = cl_bali_free_text_setter=>create( severity =
                                        if_bali_constants=>c_severity_status
                                        text = lv_msg ).

                    l_log->add_item( item = l_free_text ).

                    "Save the log into the database
                    cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                    COMMIT WORK.

                  ENDLOOP.

                 if lm_failed_1 is INITIAL.
                  COMMIT ENTITIES BEGIN
                 RESPONSE OF i_materialdocumenttp
                  FAILED DATA(commit_failed_1)
                  REPORTED DATA(commit_reported_1).

                  LOOP AT commit_reported_1-materialdocument ASSIGNING FIELD-SYMBOL(<lfs_commit_failed_h>).
                    DATA(lv_res_h1) = <lfs_commit_failed_h>-%msg->if_message~get_text( ).
*           out->write( 'Item' ).
*           out->write( lv_res ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_res_h1.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
                  ENDLOOP.


                  LOOP AT commit_reported_1-materialdocumentitem ASSIGNING FIELD-SYMBOL(<lfs_commit_failed>).
                    DATA(lv_res) = <lfs_commit_failed>-%msg->if_message~get_text( ).
*           out->write( 'Item' ).
*           out->write( lv_res ).
                    CLEAR wa_msg.
                    wa_msg-batch = ls_stock-batch.
                    wa_msg-msg = lv_res.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.
                  ENDLOOP.

                 if commit_failed_1 is INITIAL.
                  LOOP AT lm_mapped_1-materialdocument ASSIGNING FIELD-SYMBOL(<keys_header_1>).

                    CONVERT KEY OF i_materialdocumenttp FROM <keys_header_1>-%pid TO DATA(ls_md_key_1).
*      <fs_md_mapped>-MaterialDocument = ls_md_key-MaterialDocument.
*      <fs_md_mapped>-MaterialDocumentYear = ls_md_key-MaterialDocumentYear.
                  ENDLOOP.
                  endif.


                  LOOP AT lm_mapped_1-materialdocumentitem ASSIGNING FIELD-SYMBOL(<keys_item_1>).

* CONVERT KEY OF i_materialdocumentitemtp
* FROM <keys_item>-%pid
* TO <keys_item>-%key.
                  ENDLOOP.

                  COMMIT ENTITIES END.
                  endif.

                  CLEAR wa_msg.
                  wa_msg-batch = ls_stock-batch.
                  CONCATENATE 'GI Document posted' ls_md_key_1-materialdocument
                  INTO wa_msg-msg SEPARATED BY ''.
                  APPEND wa_msg TO it_msg.


* Update Log
                  SELECT SINGLE * FROM zpp_kg_fat_snf
                  WHERE batch = @ls_stock-batch
                  INTO @wa_log.
                  wa_log-batch     = ls_stock-batch.
                  wa_log-gi_doc    = ls_md_key_1-materialdocument.
                  wa_log-gi_doc_yr = ls_md_key_1-materialdocumentyear.
                  MODIFY zpp_kg_fat_snf FROM @wa_log.
                  COMMIT WORK.

                  CONCATENATE ls_stock-batch wa_msg-msg
                  INTO lv_msg SEPARATED BY ' : '.

                  l_free_text = cl_bali_free_text_setter=>create( severity =
                                      if_bali_constants=>c_severity_status
                                      text = lv_msg ).

                  l_log->add_item( item = l_free_text ).

                  "Save the log into the database
                  cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
                  COMMIT WORK.
                  CLEAR wa_msg.
                ENDIF.

              ENDIF.

            ENDLOOP.

            IF lt_stock[] IS INITIAL.

              lv_msg = 'No Stock Found'.

              l_free_text = cl_bali_free_text_setter=>create( severity =
                                  if_bali_constants=>c_severity_warning
                                  text = lv_msg ).

              l_log->add_item( item = l_free_text ).

              "Save the log into the database
              cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
              COMMIT WORK.
              CLEAR wa_msg.

            ENDIF.

            IF lt_order[] IS INITIAL.

              lv_msg = 'No Process Order Found'.

              l_free_text = cl_bali_free_text_setter=>create( severity =
                                  if_bali_constants=>c_severity_warning
                                  text = lv_msg ).

              l_log->add_item( item = l_free_text ).

              "Save the log into the database
              cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
              COMMIT WORK.
              CLEAR wa_msg.

            ENDIF.

          CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
        ENDTRY.


    ENDTRY.

  ENDMETHOD.
ENDCLASS.
