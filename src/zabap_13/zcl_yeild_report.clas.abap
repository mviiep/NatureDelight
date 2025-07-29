CLASS zcl_yeild_report DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    TYPES : BEGIN OF ty_goods_mvt_data,
              postingdate        TYPE datum,
              plant              TYPE werks_d,
              material           TYPE matnr,
              goodsmovementtype  TYPE bwart,
              quantityinbaseunit TYPE menge_d,
              snf_perc           TYPE p LENGTH 15 DECIMALS 3,
              fat_perc           TYPE p LENGTH 15 DECIMALS 3,
              counter            TYPE i,
              avg_fat            TYPE p LENGTH 15 DECIMALS 3,
              total_fat          TYPE p LENGTH 15 DECIMALS 3,
              avg_snf            TYPE p LENGTH 15 DECIMALS 3,
              total_snf          TYPE p LENGTH 15 DECIMALS 3,
            END OF ty_goods_mvt_data.
    TYPES : BEGIN OF  ty_fat_snf_avg,
              postingdate TYPE datum,
              plant       TYPE werks_d,
              material    TYPE matnr,
              avg_fat     TYPE p LENGTH 15 DECIMALS 3,
              total_fat   TYPE p LENGTH 15 DECIMALS 3,
              avg_snf     TYPE p LENGTH 15 DECIMALS 3,
              total_snf   TYPE p LENGTH 15 DECIMALS 3,
            END OF  ty_fat_snf_avg.
    TYPES : BEGIN OF ty_mat_order_id,
              postingdate TYPE datum,
              plant       TYPE werks_d,
              material    TYPE matnr,
              orderid     TYPE c LENGTH 10,
            END OF ty_mat_order_id.


    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_YEILD_REPORT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    DATA: lt_response    TYPE TABLE OF zce_yeild_report_header,
          ls_response    TYPE zce_yeild_report_header,
          lt_response_i  TYPE TABLE OF zce_yeild_report_item,
          ls_response_i  TYPE zce_yeild_report_item,
          lt_101_data    TYPE TABLE OF ty_goods_mvt_data,
          lt_102_data    TYPE TABLE OF ty_goods_mvt_data,
          lw_101_data    TYPE ty_goods_mvt_data,
          lw_102_data    TYPE ty_goods_mvt_data,
          lr_order_id    TYPE RANGE OF aufnr,
          lw_order_id    LIKE LINE OF lr_order_id,
          lt_fat_snf_avg TYPE TABLE OF ty_fat_snf_avg,
          lw_fat_snf_avg TYPE ty_fat_snf_avg,
          lv_avg_fat     TYPE p LENGTH 15 DECIMALS 3,
          lv_total_fat   TYPE p LENGTH 15 DECIMALS 3,
          lv_avg_snf     TYPE p LENGTH 15 DECIMALS 3,
          lv_total_snf   TYPE p LENGTH 15 DECIMALS 3.
    DATA :lr_fat_material TYPE  RANGE OF matnr,
          lr_snf_material TYPE RANGE OF matnr,
          lt_mat_orderid  TYPE TABLE OF ty_mat_order_id,
          lw_mat_orderid  TYPE   ty_mat_order_id.



    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).
    IF  io_request->is_data_requested( ).
      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

      DATA(lr_material)  =  VALUE  #( lt_filter_cond[ name   = 'MATERIAL' ]-range OPTIONAL ).
      DATA(lr_plant)  =  VALUE  #( lt_filter_cond[ name   = 'PLANT' ]-range OPTIONAL ).
      DATA(lr_posting_date)  =  VALUE  #( lt_filter_cond[ name   = 'POSTING_DATE' ]-range OPTIONAL ).
      DATA(lr_mrp_controller) = VALUE  #( lt_filter_cond[ name   = 'MRP_CONTROLLER' ]-range OPTIONAL ).
      DATA : lv_fat      TYPE p DECIMALS 3,
             lv_snf      TYPE p DECIMALS 3,
             lv_moisture TYPE p DECIMALS 3,
             r_fat type RANGE OF matnr,
             s_fat like LINE OF r_fat,
             r_snf type RANGE OF matnr,
             s_snf like LINE OF r_fat.

      IF lv_top < 0.
        lv_top = 1.
      ENDIF.
*
      DATA(lv_to) = lv_skip + lv_top.
      lv_skip = lv_skip + 1.

      lr_fat_material = VALUE #(  sign = 'I' option = 'EQ'
      ( low = '000000000030000002' )
      ( low = '000000000030000004' )
      ( low = '000000000030000006' )
      ( low = '000000000030000008' )
      ( low = '000000000030000012' )
      ( low = '000000000030000013' )
       ( low = '000000000030000002' )
       ).

      lr_snf_material = VALUE #(  sign = 'I' option = 'EQ'
    ( low = '000000000030000003' )
    ( low = '000000000030000005' )
    ( low = '000000000030000007' )
    ( low = '000000000030000009' )
    ( low = '000000000030000010' )
    ( low = '000000000030000011' )
    ( low = '000000000030000001' )
     ).
      CASE io_request->get_entity_id( ).

        WHEN 'ZCE_YEILD_REPORT_HEADER'.

*         SELECT * FROM I_MRPController
*         INTO TABLE @data(lt_mrp).

          SELECT FROM i_materialdocumentheader_2 WITH PRIVILEGED ACCESS AS a
          INNER JOIN i_materialdocumentitem_2 WITH PRIVILEGED ACCESS  AS b

          ON a~materialdocumentyear = b~materialdocumentyear
          AND a~materialdocument = b~materialdocument
          LEFT OUTER JOIN i_producttext  AS c
          ON b~material = c~product
          AND c~language = @sy-langu
          LEFT OUTER JOIN i_product AS d
          ON b~material = d~product
          INNER JOIN i_productplantbasic AS e ON
           e~product   = d~product


          FIELDS a~postingdate,
                 b~plant,
                 b~material,
                 b~materialbaseunit,
                 b~goodsmovementtype,
                 b~quantityinbaseunit,
                 b~batch,
                 b~orderid,
                 c~productname,
                 mrpresponsible
          WHERE b~orderid <> ''
          AND ( b~goodsmovementtype = '101' OR b~goodsmovementtype = '102'

           ) AND b~plant IN @lr_plant AND b~material IN @lr_material
           AND a~postingdate IN @lr_posting_date
           AND d~producttype = 'ZFGD'
           AND e~mrpresponsible IN @lr_mrp_controller
          INTO TABLE @DATA(lt_mat_doc).



          CLEAR : lt_101_data,lt_101_data,lt_fat_snf_avg.

          LOOP AT lt_mat_doc INTO DATA(lw_mat_doc).
            CLEAR : lv_fat ,lv_snf,lv_avg_fat,lv_avg_snf,lv_total_fat,lv_total_snf,
            lv_moisture.


            READ ENTITIES OF i_batchtp_2
             ENTITY batch BY \_batchcharacteristictp
              ALL FIELDS WITH VALUE #( ( %key = VALUE #( material = lw_mat_doc-material
                                                 batch = lw_mat_doc-batch ) ) )
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
                    lv_snf  = l_result-charcfromdecimalvalue .
                  WHEN 4.
                    lv_fat = l_result-charcfromdecimalvalue .
                  WHEN 10.
                    lv_moisture = l_result-charcfromdecimalvalue .
                ENDCASE.
              ENDIF.



              CLEAR :v_index,result,failed,reported.

            ENDLOOP.
            IF lv_snf IS INITIAL.
              lv_snf = 100 - lv_fat - lv_moisture.
            ENDIF.

            IF lw_mat_doc-goodsmovementtype = '101'.
              lw_101_data = CORRESPONDING #( lw_mat_doc ).
              lw_fat_snf_avg = CORRESPONDING #( lw_mat_doc ).
              lw_101_data-avg_fat = lw_mat_doc-quantityinbaseunit * lv_fat.
              lw_101_data-total_fat = lw_mat_doc-quantityinbaseunit.
              lw_101_data-avg_snf = lw_mat_doc-quantityinbaseunit * lv_snf.
              lw_101_data-total_snf = lw_mat_doc-quantityinbaseunit.
*              COLLECT lw_fat_snf_avg INTO lt_fat_snf_avg.
              COLLECT lw_101_data INTO lt_101_data.
            ELSE.
              lw_102_data = CORRESPONDING #( lw_mat_doc ).
              lw_102_data-counter = 1.
              lw_102_data-avg_fat = lw_mat_doc-quantityinbaseunit * lv_fat.
              lw_102_data-total_fat = lw_mat_doc-quantityinbaseunit.
              lw_102_data-avg_snf = lw_mat_doc-quantityinbaseunit * lv_snf.
              lw_102_data-total_snf = lw_mat_doc-quantityinbaseunit.
              COLLECT lw_102_data INTO lt_102_data.

            ENDIF.

            CLEAR :lw_101_data,lw_102_data,lt_result,lt_failed,lt_reported,lw_fat_snf_avg.
          ENDLOOP.


          lt_mat_orderid = CORRESPONDING #( lt_mat_doc ) .

          SORT lt_mat_doc BY plant  postingdate material.
          DELETE ADJACENT DUPLICATES FROM lt_mat_doc COMPARING plant  postingdate material.
          CLEAR : lw_mat_doc.

          LOOP AT lt_mat_doc INTO lw_mat_doc  FROM lv_skip TO lv_to.
            CLEAR: lr_order_id,lw_101_data ,lw_102_data.

            LOOP AT lt_mat_orderid INTO lw_mat_orderid WHERE postingdate = lw_mat_doc-postingdate
            AND material = lw_mat_doc-material .
              lw_order_id-low = lw_mat_doc-orderid.
              lw_order_id-option = 'EQ'.
              lw_order_id-sign = 'I'.
              APPEND lw_order_id TO lr_order_id.
              CLEAR :lw_order_id.
            ENDLOOP.

            SELECT FROM i_materialdocumentitem_2
            WITH PRIVILEGED ACCESS
            FIELDS
            material,
            postingdate,
            goodsmovementtype,
            SUM( quantityinbaseunit ) AS quantity
            WHERE material IN @lr_snf_material
            AND postingdate IN @lr_posting_date
            AND plant    IN @lr_plant
            AND  orderid IN @lr_order_id
            AND (  goodsmovementtype = '261'  OR goodsmovementtype = '262' )
            GROUP BY material, postingdate,goodsmovementtype
            INTO  TABLE @DATA(lt_materail_data_1) .


            SELECT FROM i_materialdocumentitem_2
            WITH PRIVILEGED ACCESS
            FIELDS
            material,
            postingdate,
            goodsmovementtype,
            SUM( quantityinbaseunit ) AS quantity
            WHERE material IN @lr_fat_material
            AND postingdate IN @lr_posting_date
            AND plant    IN @lr_plant
            AND  orderid IN @lr_order_id
            AND (  goodsmovementtype = '261'  OR goodsmovementtype = '262' )
            GROUP BY material, postingdate,goodsmovementtype
            INTO  TABLE @DATA(lt_materail_data_2) .


            SELECT product, productname FROM i_producttext
              WITH PRIVILEGED ACCESS WHERE product IN @lr_snf_material
              INTO  TABLE @DATA(lt_mat1_descr).
            SELECT product ,productname FROM i_producttext
            WITH PRIVILEGED ACCESS WHERE product IN @lr_fat_material
            INTO  TABLE @DATA(lt_mat2_descr).


            ls_response-material = lw_mat_doc-material.
            ls_response-plant = lw_mat_doc-plant.
            ls_response-posting_date = lw_mat_doc-postingdate.
            ls_response-out_mat_descr = lw_mat_doc-productname.
            ls_response-unit   = lw_mat_doc-materialbaseunit.
            ls_response-mrp_controller = lw_mat_doc-mrpresponsible.
            READ TABLE lt_101_data INTO lw_101_data WITH KEY
            material = lw_mat_doc-material plant = lw_mat_doc-plant
            postingdate = lw_mat_doc-postingdate.
            IF sy-subrc = 0.
              ls_response-out_qty = lw_101_data-quantityinbaseunit.
              lv_avg_fat   = lw_101_data-avg_fat.
              lv_avg_snf = lw_101_data-avg_snf.
              lv_total_fat = lw_101_data-total_fat.
              lv_total_snf =  lw_101_data-total_snf..

            ENDIF.
            READ TABLE lt_102_data INTO lw_102_data WITH KEY
          material = lw_mat_doc-material plant = lw_mat_doc-plant
          postingdate = lw_mat_doc-postingdate.
            IF sy-subrc = 0.
              ls_response-out_qty =  ls_response-out_qty - lw_102_data-quantityinbaseunit.
              lv_avg_fat = lv_avg_fat - lw_102_data-avg_fat.
              lv_avg_snf = lv_avg_snf - lw_102_data-avg_snf.
              lv_total_fat =   lv_total_fat - lw_102_data-total_fat.
              lv_total_snf = lv_total_snf - lw_102_data-total_snf .




            ENDIF.

            IF  lv_total_fat IS NOT INITIAL.
              ls_response-out_fat_percent = lv_avg_fat /  lv_total_fat.
              ls_response-out_fat_qty  = ( ls_response-out_qty *  ls_response-out_fat_percent ) / 100.
            ENDIF.
            ls_response-out_fat_unit = 'KG'.

            IF lv_total_snf IS NOT INITIAL.
              ls_response-out_snf_percent = lv_avg_snf /  lv_total_snf.
              ls_response-out_snf_qty  = ( ls_response-out_qty *  ls_response-out_snf_percent ) / 100.
            ENDIF.
            ls_response-out_snf_unit = 'KG'.

            clear : s_fat, s_snf, r_fat, r_snf.

            CASE lw_mat_doc-material.
              WHEN '000000000040000064'.
                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000011'.
                append s_snf to r_snf.
                clear s_snf.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000003'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000013'.
                append s_fat to r_fat.
                clear s_fat.

*                DATA(lv_snf_mat) = '000000000030000011'.
*                DATA(lv_fat_mat) = '000000000030000013'.

              WHEN '000000000040000062'.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000013'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000012'.
                append s_fat to r_fat.
                clear s_fat.

*                lv_snf_mat  = '000000000030000010'.
*                lv_fat_mat = '000000000030000012'.

              WHEN '000000000040000065' OR '000000000040000066'.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000009'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000008'.
                append s_fat to r_fat.
                clear s_fat.

*                lv_snf_mat  = '000000000030000009'.
*                lv_fat_mat = '000000000030000008'.

              WHEN '000000000040000071' OR '000000000040000072'.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000007'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000006'.
                append s_fat to r_fat.
                clear s_fat.

*                lv_snf_mat  = '000000000030000007'.
*                lv_fat_mat = '000000000030000006'.
              WHEN '000000000040000063'.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000003'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000002'.
                append s_fat to r_fat.
                clear s_fat.

*                lv_snf_mat  = '000000000030000003'.
*                lv_fat_mat =  '000000000030000002'.
              WHEN OTHERS.

                s_snf-sign = 'I'.
                s_snf-option = 'EQ'.
                s_snf-low = '000000000030000005'.
                append s_snf to r_snf.
                clear s_snf.

                s_fat-sign = 'I'.
                s_fat-option = 'EQ'.
                s_fat-low = '000000000030000004'.
                append s_fat to r_fat.
                clear s_fat.

*                lv_snf_mat  = '000000000030000005'. "change before moving to prod
*                lv_fat_mat =  '000000000030000004'.
            ENDCASE.


*            READ TABLE lt_materail_data_1 INTO DATA(lw_material_1_261)
*            WITH KEY goodsmovementtype = '261' postingdate = lw_mat_doc-postingdate
*            material = lv_snf_mat.
*            IF sy-subrc = 0.

            loop at lt_materail_data_1 INTO DATA(lw_material_1_261)
            where goodsmovementtype = '261' and postingdate = lw_mat_doc-postingdate
            and   material in r_snf.
              ls_response-in_material_1 = lw_material_1_261-material.
              ls_response-in_snf_qty  = ls_response-in_snf_qty + lw_material_1_261-quantity.

              READ  TABLE lt_mat1_descr  INTO DATA(lw_mat1_descr) WITH KEY
              product =  lw_material_1_261-material.
              IF  sy-subrc = 0.
                ls_response-in_material_descr_1 = lw_mat1_descr-productname.
              ENDIF.
*              ls_response-in_material_descr_1 = VALUE #( lt_mat1_descr[ 1 ]-ProductName OPTIONAL ).
             endloop.
*            ENDIF.

            ls_response-in_snf_unit = 'KG'.

*            READ TABLE lt_materail_data_1 INTO DATA(lw_material_1_262)
*            WITH KEY goodsmovementtype = '262' postingdate = lw_mat_doc-postingdate
*            material = lv_snf_mat.
*            IF sy-subrc = 0.

             loop at lt_materail_data_1 INTO DATA(lw_material_1_262)
            where goodsmovementtype = '262' and postingdate = lw_mat_doc-postingdate
            and material in r_snf.

              ls_response-in_snf_qty  =  ls_response-in_snf_qty  - lw_material_1_262-quantity.

            endloop.

*            ENDIF.


*            READ TABLE lt_materail_data_2 INTO DATA(lw_material_2_261)
*            WITH KEY goodsmovementtype = '261' postingdate = lw_mat_doc-postingdate
*            material = lv_fat_mat.
*            IF sy-subrc = 0.

            loop at lt_materail_data_2 INTO DATA(lw_material_2_261)
            where goodsmovementtype = '261' and postingdate = lw_mat_doc-postingdate
            and material in r_fat.

              ls_response-in_material_2 = lw_material_2_261-material.

              ls_response-in_fat_qty  = ls_response-in_fat_qty + lw_material_2_261-quantity.
              READ  TABLE lt_mat2_descr  INTO DATA(lw_mat2_descr) WITH KEY
             product =  lw_material_2_261-material.
              IF  sy-subrc = 0.
                ls_response-in_material_descr_2  = lw_mat2_descr-productname.
              ENDIF.
*              ls_response-in_material_descr_2 = VALUE #( lt_mat2_descr[ 1 ]-ProductName OPTIONAL ).
            endloop.
*            ENDIF.
            ls_response-in_fat_unit = 'KG'.

*            READ TABLE lt_materail_data_2 INTO DATA(lw_material_2_262)
*            WITH KEY goodsmovementtype = '262' postingdate = lw_mat_doc-postingdate
*            material = lv_fat_mat.
*            IF sy-subrc = 0.

            loop at lt_materail_data_2 INTO DATA(lw_material_2_262)
            where goodsmovementtype = '262' and postingdate = lw_mat_doc-postingdate
            and material in r_fat.

              ls_response-in_fat_qty  =  ls_response-in_fat_qty  - lw_material_2_262-quantity.

            endloop.
*            ENDIF.

            IF ls_response-in_fat_qty IS NOT INITIAL.
              DATA lv_fat_yield TYPE p LENGTH 15 DECIMALS 10.
              CLEAR :lv_fat_yield.
              lv_fat_yield  = ( ls_response-out_fat_qty / ls_response-in_fat_qty ) .
*              lv_fat_yield = round( val =  lv_fat_yield dec = 3 ).
              lv_fat_yield = lv_fat_yield * 100.
              ls_response-fat_yeild_percent =   lv_fat_yield.
*              ls_response-fat_yeild_percent =   ls_response-fat_yeild_percent *     100..
            ENDIF.

            IF ls_response-in_snf_qty IS NOT INITIAL.
              DATA lv_snf_yield TYPE p LENGTH 15 DECIMALS 10.
              CLEAR :lv_snf_yield.
              lv_snf_yield = (   ls_response-out_snf_qty / ls_response-in_snf_qty ).
*              lv_snf_yield = round( val =  lv_snf_yield dec = 3 ).
              lv_snf_yield = lv_snf_yield * 100.
              ls_response-snf_yeild_percent =   lv_snf_yield.
*              ls_response-snf_yeild_percent =  ls_response-snf_yeild_percent * 100.
            ENDIF.
            APPEND ls_response TO lt_response.
            CLEAR ls_response.
            CLEAR : lw_mat_doc,lt_mat1_descr,lt_mat2_descr,lt_materail_data_1,
            lt_materail_data_2.
          ENDLOOP.

          io_response->set_data( lt_response ).
          io_response->set_total_number_of_records( lines( lt_mat_doc ) ).


        WHEN 'ZCE_YEILD_REPORT_ITEM'.





          SELECT FROM i_materialdocumentheader_2 WITH PRIVILEGED ACCESS AS a
                  INNER JOIN i_materialdocumentitem_2 WITH PRIVILEGED ACCESS  AS b

                  ON a~materialdocumentyear = b~materialdocumentyear
                  AND a~materialdocument = b~materialdocument
                  LEFT OUTER JOIN i_producttext  AS c
                  ON b~material = c~product
                  AND c~language = @sy-langu
                  LEFT OUTER JOIN i_product AS d
                  ON b~material = d~product


                  FIELDS a~postingdate,
                         b~plant,
                         b~material,
                         b~materialbaseunit,
                         b~goodsmovementtype,
                         b~quantityinbaseunit,
                         b~batch,
                         b~orderid,

                         c~productname
                  WHERE b~orderid <> ''
                  AND ( b~goodsmovementtype = '101' OR b~goodsmovementtype = '102'

                   ) AND b~plant IN @lr_plant AND b~material IN @lr_material
                   AND a~postingdate IN @lr_posting_date
                   AND d~producttype = 'ZFGD'
                  INTO TABLE @DATA(lt_mat_doc_item).

          SORT lt_mat_doc_item  BY plant  postingdate material goodsmovementtype.

          LOOP AT lt_mat_doc_item ASSIGNING FIELD-SYMBOL(<fs_doc_item>)  FROM lv_skip TO lv_to.
            CLEAR : ls_response_i,lv_snf,lv_fat.
            ls_response_i-plant = <fs_doc_item>-plant.
            ls_response_i-posting_date = <fs_doc_item>-postingdate.
            ls_response_i-material = <fs_doc_item>-material.
            ls_response_i-out_mat_descr = <fs_doc_item>-productname.
            ls_response_i-out_qty = <fs_doc_item>-quantityinbaseunit.
            ls_response_i-unit = <fs_doc_item>-materialbaseunit.
            ls_response_i-movement_type = <fs_doc_item>-goodsmovementtype.
            ls_response_i-process_order = <fs_doc_item>-orderid.



            READ ENTITIES OF i_batchtp_2
            ENTITY batch BY \_batchcharacteristictp
             ALL FIELDS WITH VALUE #( ( %key = VALUE #( material = <fs_doc_item>-material
                                                batch = <fs_doc_item>-batch ) ) )
               RESULT DATA(lt_result_i)
               FAILED DATA(lt_failed_i)
               REPORTED DATA(lt_reported_i).

            LOOP AT lt_result_i INTO DATA(lw_result_i).
              DATA(lv_index) = sy-tabix.

              READ ENTITIES OF i_batchtp_2
               ENTITY batchcharacteristic BY \_batchcharacteristicvaluetp
               ALL FIELDS WITH VALUE #( (
                   %key = VALUE #( material = <fs_doc_item>-material
                                   batch = <fs_doc_item>-batch
                                   charcinternalid = lw_result_i-charcinternalid ) ) )
               RESULT DATA(result_i)
               FAILED DATA(failed_i)
               REPORTED DATA(reported_i).

              IF result_i[] IS NOT INITIAL.

                READ TABLE result_i INTO DATA(l_result_i) INDEX 1.

                CASE lv_index.
                  WHEN 5.
                    lv_snf  = l_result-charcfromdecimalvalue .
                  WHEN 4.
                    lv_fat = l_result-charcfromdecimalvalue .
                ENDCASE.
              ENDIF.
              CLEAR :v_index,result,failed,reported.
            ENDLOOP.

            ls_response_i-snf_percent = lv_snf.
            ls_response_i-fat_percent = lv_fat.
            ls_response_i-fat_qty = lv_fat  * ls_response_i-out_qty .
            ls_response_i-snf_qty = lv_snf  * ls_response_i-out_qty .

            APPEND ls_response_i TO lt_response_i.
          ENDLOOP.


          io_response->set_data( lt_response_i ).
          io_response->set_total_number_of_records( lines( lt_mat_doc_item  ) ).


      ENDCASE.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
