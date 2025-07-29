CLASS zcl_loading_sheet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES : BEGIN OF ty_goods,
              product                    TYPE matnr,
              billingquantity            TYPE menge_d,
              billingquantityunit        TYPE meins,
              salesdocumentitemcategory  TYPE c LENGTH 4,
              productname                TYPE c LENGTH 40,
              mainitempricingrefmaterial TYPE c LENGTH 40,
              accountdetnproductgroup    TYPE i_productsalesdelivery-accountdetnproductgroup,
            END OF ty_goods.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_LOADING_SHEET IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      DATA: lt_response   TYPE TABLE OF zce_loading_sheet_header,
            ls_response   TYPE zce_loading_sheet_header,
            lt_response_i TYPE TABLE OF zce_loading_sheet_item,
            ls_response_i TYPE zce_loading_sheet_item.
*
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).
      DATA : lt_goods      TYPE TABLE OF ty_goods,
             lt_free_goods TYPE TABLE  OF ty_goods,
             lw_goods      TYPE ty_goods.
      DATA: lv_noofcrate TYPE i.

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.
      IF io_request->is_data_requested( ).
        DATA(lr_truck_sheet_no)  =  VALUE  #( lt_filter_cond[ name   = 'TRUCKSHEET_NO' ]-range OPTIONAL ).
        DATA(lv_truck_sheet_no)  = VALUE ebeln( lr_truck_sheet_no[ 1 ]-low OPTIONAL ).

        SELECT SINGLE * FROM zsdt_truckshet_h
        WHERE trucksheet_no = @lv_truck_sheet_no
        INTO @DATA(lw_header).
        IF sy-subrc = 0.
          ls_response = CORRESPONDING #( lw_header ).
          ls_response-current_dates = sy-datlo.
          ls_response-current_times = sy-timlo .

          SELECT SINGLE route FROM zsdt_truckshet_i
          WHERE trucksheet_no = @lv_truck_sheet_no
          INTO @DATA(lv_route).
          IF sy-subrc = 0.
            SELECT SINGLE description FROM ztroute_distance
            WHERE route = @lv_route
            INTO @ls_response-route_name.
          ENDIF.

        ENDIF.

        SELECT FROM zsdt_truckshet_i
        FIELDS vbeln
        WHERE trucksheet_no = @lv_truck_sheet_no
        INTO TABLE @DATA(lt_vbeln).

        IF sy-subrc = 0.
          SELECT FROM i_billingdocumentitem  WITH PRIVILEGED ACCESS AS a "#EC CI_NO_TRANSFORM
          LEFT OUTER JOIN i_producttext  WITH PRIVILEGED ACCESS AS b
          ON a~product = b~product
          FIELDS a~billingdocument,
                 a~billingdocumentitem,
                 a~product,
                 a~billingquantity,
                 a~billingquantityunit,
                 a~salesdocumentitemcategory,
                 a~mainitempricingrefmaterial,
                 b~productname

         FOR ALL ENTRIES IN @lt_vbeln
         WHERE a~billingdocument = @lt_vbeln-vbeln
         AND b~language = @sy-langu
         INTO TABLE @DATA(lt_billing_item).

          SELECT FROM i_billingdocument WITH PRIVILEGED ACCESS "#EC CI_NO_TRANSFORM
          FIELDS billingdocument,
                 salesorganization,
                 distributionchannel
          FOR ALL ENTRIES IN @lt_vbeln
          WHERE billingdocument = @lt_vbeln-vbeln
          INTO TABLE @DATA(lt_billing_header).


        ENDIF.

        LOOP AT lt_billing_item INTO DATA(lw_billing_item).
          lw_goods = CORRESPONDING #( lw_billing_item ).
          IF lw_goods-salesdocumentitemcategory = 'TAN'.
            READ TABLE lt_billing_header INTO DATA(lw_billing_header)
            WITH KEY billingdocument = lw_billing_item-billingdocument.
            SELECT SINGLE accountdetnproductgroup FROM i_productsalesdelivery
              WHERE product = @lw_billing_item-product
              AND   productsalesorg = @lw_billing_header-salesorganization
              AND   productdistributionchnl = @lw_billing_header-distributionchannel
              INTO @lw_goods-accountdetnproductgroup.
            COLLECT lw_goods INTO lt_goods.

          ELSEIF lw_goods-salesdocumentitemcategory = 'TANN'.
            COLLECT lw_goods INTO lt_free_goods. .

          ENDIF.
          CLEAR :lw_goods,lw_billing_item.
        ENDLOOP.
        SORT lt_goods BY product accountdetnproductgroup.
        LOOP AT lt_goods INTO lw_goods.
          ls_response_i-material_no = lw_goods-product.
          ls_response_i-material_descr =  lw_goods-productname.
          ls_response_i-quantity = lw_goods-billingquantity.

          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
            FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
            WHERE alternativeunit = @lw_goods-billingquantityunit
            AND product = @lw_goods-product
            AND baseunit = @lw_goods-billingquantityunit
            INTO @DATA(lw_base_unit).

          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = 'KI'
          AND product = @lw_goods-product
          AND baseunit = @lw_goods-billingquantityunit
          INTO @DATA(lw_source_unit).
          IF lw_base_unit-quantitynumerator IS NOT INITIAL
          AND lw_source_unit-quantitynumerator IS NOT INITIAL.

            lv_noofcrate = (  lw_goods-billingquantity *
            ( lw_base_unit-quantitynumerator / lw_base_unit-quantitydenominator ) *
            ( lw_source_unit-quantitydenominator / lw_source_unit-quantitynumerator ) )
            .


          ENDIF.
          IF lw_goods-product = '000000000040000054' OR
            lw_goods-product = '000000000040000038' OR
            lw_goods-product =  '000000000040000035' OR
            lw_goods-product  = '000000000040000053'.
          ELSE.
            ls_response_i-crates =  lv_noofcrate.
            READ TABLE  lt_free_goods INTO DATA(lw_free_goods)
            WITH KEY mainitempricingrefmaterial = lw_goods-product.
            IF   sy-subrc = 0.
              ls_response_i-free = lw_free_goods-billingquantity.

            ENDIF.
          ENDIF.


          ls_response_i-total = ls_response_i-free + ls_response_i-quantity.

          ls_response-sum_quantity = ls_response-sum_quantity + ls_response_i-quantity.
          ls_response-sum_free_quantity =  ls_response-sum_free_quantity + ls_response_i-free.
          ls_response-total_quantity =  ls_response-total_quantity + ls_response_i-total.
          ls_response-total_crates =  ls_response-total_crates + ls_response_i-crates.
          ls_response_i-trucksheet_no = lv_truck_sheet_no.
          APPEND ls_response_i TO lt_response_i.
          CLEAR :lv_noofcrate,ls_response_i.
        ENDLOOP.

        APPEND ls_response TO lt_response.
      ENDIF.

      CASE io_request->get_entity_id( ).
        WHEN 'ZCE_LOADING_SHEET_HEADER'.
          io_response->set_data( lt_response ).
          io_response->set_total_number_of_records( lines( lt_response ) ).

        WHEN 'ZCE_LOADING_SHEET_ITEM'.
          io_response->set_data( lt_response_i ).
          io_response->set_total_number_of_records( lines( lt_response_i ) ).

      ENDCASE.

*      io_response->set_data( lt_response_i ).
*      io_response->set_total_number_of_records( lines( lt_response_i ) ).


    ENDIF.
  ENDMETHOD.
ENDCLASS.
