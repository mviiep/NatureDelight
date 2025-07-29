CLASS lhc_salesorderheader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
*      IMPORTING keys REQUEST requested_authorizations FOR salesorderheader RESULT result.

    METHODS createsalesorder FOR MODIFY
      IMPORTING keys FOR ACTION salesorderheader~createsalesorder RESULT result.
    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR salesorderheader RESULT result.
    METHODS validate_data FOR VALIDATE ON SAVE
      IMPORTING keys FOR salesorderheader~validate_data.
*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      IMPORTING REQUEST requested_authorizations FOR salesorderheader RESULT result.

ENDCLASS.

CLASS lhc_salesorderheader IMPLEMENTATION.

*  METHOD get_instance_authorizations.
*  ENDMETHOD.

  METHOD createsalesorder.
    DATA: lt_so_h        TYPE TABLE FOR CREATE i_salesordertp,
          lt_so_i        TYPE TABLE FOR CREATE i_salesordertp\_item,
          ls_so_i        LIKE LINE OF lt_so_i,
          lt_so_p        TYPE TABLE FOR CREATE i_salesordertp\_partner,
          ls_so_p        LIKE LINE OF lt_so_p,
          lv_soid(10)    TYPE c,
          lv_posnr(6)    TYPE n,
          lv_total_crate TYPE menge_d.

    READ ENTITIES OF zi_sales_order_header IN LOCAL MODE
    ENTITY salesorderheader
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(members).



    DATA(lt_keys) = keys.

    IF members[] IS NOT INITIAL.
      SELECT * FROM zsd_sales_item
      FOR ALL ENTRIES IN @members
      WHERE header_id  = @members-id
      INTO TABLE @DATA(lt_sales_item).
    ENDIF.

    SORT  lt_sales_item BY item.

    READ TABLE members INTO DATA(lw_header) INDEX 1.
    IF lw_header-vbeln IS INITIAL.
      CLEAR lv_posnr.
      LOOP AT lt_sales_item ASSIGNING FIELD-SYMBOL(<fs_sales_item>).

        lv_posnr = lv_posnr + 10.

        IF <fs_sales_item>-product = '000000000040000054' OR
           <fs_sales_item>-product = '000000000040000038' OR
            <fs_sales_item>-product =  '000000000040000035' OR
            <fs_sales_item>-product = '000000000040000053'.
         ELSE.

          lv_total_crate = lv_total_crate + <fs_sales_item>-quatity.
        ENDIF.
        IF <fs_sales_item>-item_category IS INITIAL.
          <fs_sales_item>-item_category = 'TAN'.
        ENDIF.
        IF <fs_sales_item>-baseunit IS INITIAL.
          <fs_sales_item>-item_category = 'KI'.
        ENDIF.

        SELECT SINGLE baseunit FROM i_product
        WITH PRIVILEGED ACCESS
        WHERE product = @<fs_sales_item>-product
        INTO @DATA(lv_base_unit).

        SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = @lv_base_unit
          AND product = @<fs_sales_item>-product
          AND baseunit = @lv_base_unit
          INTO @DATA(lw_base_unit).

        SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
        FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
        WHERE alternativeunit = @<fs_sales_item>-baseunit
        AND product = @<fs_sales_item>-product
        AND baseunit = @lv_base_unit
        INTO @DATA(lw_source_unit).

*      SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
*      FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
*      WHERE ( alternativeunit = 'L' or alternativeunit = 'KG' )
*      AND product = @<fs_sales_item>-product
*      AND baseunit = @lv_base_unit
*      INTO @DATA(lw_KG_LIT_unit).


        IF lw_base_unit-quantitynumerator IS NOT INITIAL
         AND lw_source_unit-quantitynumerator IS NOT INITIAL.

          <fs_sales_item>-quatity = <fs_sales_item>-quatity *
          ( lw_base_unit-quantitynumerator / lw_base_unit-quantitydenominator ) *
          ( lw_source_unit-quantitynumerator / lw_source_unit-quantitydenominator ) .

        ENDIF.
        <fs_sales_item>-baseunit = lv_base_unit.
        lw_header-ordertype = 'TA'.
        IF   lw_header-deliverydate IS INITIAL.
          lw_header-deliverydate  = sy-datum.
        ENDIF.
        IF lw_header-pricedate IS INITIAL.
          lw_header-pricedate = sy-datum.
        ENDIF.
        lw_header-shipcondition = '01'.
        lw_header-division = '00'.

        lt_so_h = VALUE #( ( %cid = 'H001'
                                %data = VALUE #( salesordertype =  lw_header-ordertype
                                                salesorganization = lw_header-salesorg
                                                distributionchannel = lw_header-dischannel
                                                organizationdivision = lw_header-division
                                                soldtoparty = lw_header-soldtoparty
                                                purchaseorderbycustomer = lw_header-customerref
                                                pricingdate = lw_header-pricedate
                                                requesteddeliverydate = lw_header-deliverydate
                                                shippingcondition = lw_header-shipcondition
                                                )

                                %control = VALUE #(
                                                salesordertype = if_abap_behv=>mk-on
                                                salesorganization = if_abap_behv=>mk-on
                                                distributionchannel = if_abap_behv=>mk-on
                                                organizationdivision = if_abap_behv=>mk-on
                                                soldtoparty = if_abap_behv=>mk-on
                                                purchaseorderbycustomer = if_abap_behv=>mk-on
                                                pricingdate = if_abap_behv=>mk-on
                                                requesteddeliverydate = if_abap_behv=>mk-on
                                                shippingcondition = if_abap_behv=>mk-on
                                                ) ) ).

        lt_so_p =  VALUE #( ( %cid_ref = 'H001'
                                 salesorder = space
                                 %target = VALUE #( ( %cid = 'P001'
                                                     customer = lw_header-shiptoparty
                                                     %control-customer = if_abap_behv=>mk-on
                                                     partnerfunctionforedit = 'WE'
                                                     %control-partnerfunctionforedit = if_abap_behv=>mk-on
                                                      ) ) ) ).

        APPEND VALUE #(  %cid = lv_posnr "<fs_sales_item>-item
                                product = <fs_sales_item>-product
                                %control-product = if_abap_behv=>mk-on
                                materialbycustomer = <fs_sales_item>-product
                                %control-materialbycustomer = if_abap_behv=>mk-on
                                requestedquantity = <fs_sales_item>-quatity
                                %control-requestedquantity = if_abap_behv=>mk-on
                                requestedquantityunit = <fs_sales_item>-baseunit
                                %control-requestedquantityunit = if_abap_behv=>mk-on
                                plant = <fs_sales_item>-plant
                                %control-plant = if_abap_behv=>mk-on
                                route = <fs_sales_item>-route
                                 %control-route = if_abap_behv=>mk-on
                                )  TO ls_so_i-%target.


        AT LAST.
*          <fs_sales_item>-item = <fs_sales_item>-item + 10.
          lv_posnr = lv_posnr + 10.
          APPEND VALUE #(  %cid = lv_posnr "<fs_sales_item>-item

                                        product = '000000000080000001'
                                       %control-product = if_abap_behv=>mk-on
                                       requestedquantity = lv_total_crate
                                       %control-requestedquantity = if_abap_behv=>mk-on

                                       requestedquantityunit = 'EA'
                                       %control-requestedquantityunit = if_abap_behv=>mk-on
                                       plant = '1101'
                                       %control-plant = if_abap_behv=>mk-on
                                        route = <fs_sales_item>-route
                                        %control-route = if_abap_behv=>mk-on
                                       )  TO ls_so_i-%target.

        ENDAT.


      ENDLOOP.
*000000000000000029
*000000000080000001
*                                     product = '000000000080000001'
*                                     requestedquantityunit = 'EA'
      IF lt_so_h IS NOT INITIAL.
        lt_so_i =  VALUE #( ( %cid_ref = 'H001'
                               salesorder = space
                               %target =  ls_so_i-%target ) ).

*    -------Create sales order----

        MODIFY ENTITIES OF i_salesordertp
        ENTITY salesorder
        CREATE
        FROM lt_so_h
        CREATE BY \_item FROM lt_so_i
        CREATE BY \_partner FROM lt_so_p
        MAPPED DATA(ls_mapped)
        FAILED DATA(ls_failed)
        REPORTED DATA(ls_reported).


        "retrieve the generated SO
        zbp_i_sales_order_header=>mapped_sales_order-salesorder = ls_mapped-salesorder.


        CLEAR:  lt_so_i[], lt_so_h[].
        DATA : lt_header_temp TYPE TABLE FOR UPDATE zi_sales_order_header.

        lt_header_temp = CORRESPONDING #(  members ).
        MODIFY ENTITIES OF zi_sales_order_header IN LOCAL MODE
       ENTITY salesorderheader
       UPDATE
       FIELDS (  vbeln )
       WITH lt_header_temp
       REPORTED reported
       FAILED failed
       MAPPED mapped.
*
        READ ENTITIES OF  zi_sales_order_header  IN LOCAL MODE  ENTITY salesorderheader
      ALL FIELDS WITH CORRESPONDING #( lt_header_temp ) RESULT DATA(lt_final).

        result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
         %param = lw_final  )  ).
      ENDIF.
    ENDIF.

  ENDMETHOD.



  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD validate_data.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_sales_order_header IN LOCAL MODE
      ENTITY salesorderheader
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

      IF member-soid IS NOT INITIAL.

        SELECT SINGLE soid FROM zsd_sales_header
        WHERE soid = @member-soid
        INTO @DATA(lv_soid).
        IF sy-subrc = 0.

          CONCATENATE 'SO ID' member-soid 'already uploaded' INTO DATA(lv_str) SEPARATED BY ''.

          APPEND VALUE #( %tky = member-%tky ) TO failed-salesorderheader.
          APPEND VALUE #( %tky = keys[ 1 ]-%tky
                          %msg = new_message_with_text(
                          severity = if_abap_behv_message=>severity-error
                          text = lv_str )
                           ) TO reported-salesorderheader.

        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_sales_order_header DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_sales_order_header IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_so_header   TYPE TABLE OF zsd_sales_header,
           lw_so_header   TYPE zsd_sales_header,
           ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp,
           lt_item        TYPE TABLE OF zsd_sales_item.
    IF create-salesorderheader IS NOT INITIAL.

      lt_so_header = CORRESPONDING #( create-salesorderheader
      MAPPING soid = soid
      customer_ref = customerref
      deliverydate = deliverydate
      dischannel   = dischannel
      division     = division
      id            = id
      lastchangedat  = lastchangedat
      ordertype      = ordertype
      pricedate      = pricedate
      salesorg      = salesorg
      shipcondition   = shipcondition
      shiptoparty      = shiptoparty
      vbeln            = vbeln

       )  .

      LOOP AT lt_so_header ASSIGNING FIELD-SYMBOL(<fs_header1>).
        <fs_header1>-created_date = sy-datlo.
        <fs_header1>-created_by = sy-uname.

      ENDLOOP.

      INSERT zsd_sales_header FROM TABLE @lt_so_header.

    ENDIF.


    IF create-salesorderitem IS NOT INITIAL.

      lt_item = CORRESPONDING #( create-salesorderitem
      MAPPING soid = soid  itemid = itemid item_category = itemcategory
      baseunit = baseunit
      gtin     = gtin
      item     = item
      plant    = plant
      product   = product
      quatity   = quatity
      header_id = headerid


       )  .

      INSERT  zsd_sales_item FROM TABLE @lt_item.

    ENDIF.

    IF  update-salesorderheader IS NOT INITIAL AND zbp_i_sales_order_header=>mapped_sales_order IS INITIAL.

      lt_so_header = CORRESPONDING #( update-salesorderheader
       MAPPING soid = soid
       customer_ref = customerref
       deliverydate = deliverydate
       dischannel   = dischannel
       division     = division
       id            = id
       lastchangedat  = lastchangedat
       ordertype      = ordertype
       pricedate      = pricedate
       salesorg      = salesorg
       shipcondition   = shipcondition
       shiptoparty      = shiptoparty
       vbeln            = vbeln
       created_by       = createdby
       created_on       = createdon
       created_date     = createddate

        )  .

      MODIFY zsd_sales_header FROM TABLE @lt_so_header.


    ENDIF.
    IF  update-salesorderheader IS NOT INITIAL AND   zbp_i_sales_order_header=>mapped_sales_order IS NOT INITIAL.
*
      lt_so_header = CORRESPONDING #( update-salesorderheader
       MAPPING soid = soid
       customer_ref = customerref
       deliverydate = deliverydate
       dischannel   = dischannel
       division     = division
       id            = id
       lastchangedat  = lastchangedat
       ordertype      = ordertype
       pricedate      = pricedate
       salesorg      = salesorg
       shipcondition   = shipcondition
       shiptoparty      = shiptoparty
       vbeln            = vbeln
       created_by       = createdby
       created_on       = createdon
       created_date    = createddate

        )  .

      CONVERT KEY OF i_salesordertp FROM ls_so_temp_key-salesorder TO DATA(ls_so_final_key).
*        zbp_i_sales_order_header=>mapped_sales_order = ls_so_final_key-salesorder.
      lw_so_header-vbeln = ls_so_final_key-salesorder.

      LOOP AT lt_so_header ASSIGNING FIELD-SYMBOL(<fs_header>).
        <fs_header>-vbeln = lw_so_header-vbeln.
      ENDLOOP.

      MODIFY zsd_sales_header FROM TABLE @lt_so_header.


    ENDIF.


    IF update-salesorderitem IS NOT INITIAL.

      lt_item = CORRESPONDING #( update-salesorderitem
      MAPPING soid = soid  itemid = itemid item_category = itemcategory
      baseunit = baseunit
      gtin     = gtin
      item     = item
      plant    = plant
      product   = product
      quatity   = quatity
      header_id = headerid


       )  .

      MODIFY  zsd_sales_item FROM TABLE @lt_item.

    ENDIF.

    IF delete-salesorderheader IS NOT INITIAL.
      lt_so_header = CORRESPONDING #( delete-salesorderheader ).

      SELECT id, soid, vbeln FROM zsd_sales_header
      FOR ALL ENTRIES IN @lt_so_header
      WHERE id = @lt_so_header-id
      AND   vbeln IS INITIAL
      INTO TABLE @DATA(lt_h_delete).

      IF lt_h_delete[] IS NOT INITIAL.
        SELECT itemid, header_id, soid FROM
        zsd_sales_item
        FOR ALL ENTRIES IN @lt_h_delete
        WHERE header_id = @lt_h_delete-id
        INTO TABLE @DATA(lt_i_delete).
        LOOP AT lt_i_delete INTO DATA(ls_i_delete).
          DELETE FROM zsd_sales_item WHERE header_id = @ls_i_delete-header_id.
        ENDLOOP.
      ENDIF.

      LOOP AT lt_h_delete INTO DATA(ls_h_delete).
        DELETE FROM zsd_sales_header WHERE id = @ls_h_delete-id.
      ENDLOOP.

*    if lt_h_delete[] is NOT INITIAL.
*        SELECT * FROM
*        zsd_sales_item
*        FOR ALL ENTRIES IN @lt_h_delete
*        WHERE header_id = @lt_h_delete-id
*        INTO TABLE @data(lt_i_delete).
*    endif.
**    SELECT * FROM
**    zsd_sales_item
**    FOR ALL ENTRIES IN @lt_so_header
**    WHERE header_id = @lt_so_header-id
**    INTO TABLE @data(lt_i_delete).
*    DELETE zsd_sales_item FROM TABLE @lt_i_delete.
    ENDIF.





  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
