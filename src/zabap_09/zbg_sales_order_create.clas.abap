CLASS zbg_sales_order_create DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_apj_dt_exec_object .
    INTERFACES if_apj_rt_exec_object .
    INTERFACES : if_oo_adt_classrun .

    METHODS create_so.
     TYPES : BEGIN OF ty_msg,
             so_id TYPE c LENGTH 10,
              msgty(1)  TYPE c,
              msg(200)  TYPE c,
            END OF ty_msg.
    DATA : it_msg    TYPE STANDARD TABLE OF ty_msg,
           wa_msg    TYPE ty_msg.
    DATA : lt_sales_header TYPE TABLE OF zsd_sales_header,
           lt_sales_item   TYPE TABLE OF zsd_sales_item,
           lv_msg          TYPE c LENGTH 200,
           lv_date         TYPE d,
           lv_user         TYPE syuname,
           lv_result TYPE string.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZBG_SALES_ORDER_CREATE IMPLEMENTATION.


  METHOD create_so.


    DATA: lt_so_h        TYPE TABLE FOR CREATE i_salesordertp,
          lt_so_i        TYPE TABLE FOR CREATE i_salesordertp\_item,
          ls_so_i        LIKE LINE OF lt_so_i,
          lt_so_p        TYPE TABLE FOR CREATE i_salesordertp\_partner,
          ls_so_p        LIKE LINE OF lt_so_p,
          lv_soid(10)    TYPE c,
          lv_total_crate TYPE menge_d.

    TRY.
        DATA(l_log) = cl_bali_log=>create_with_header( cl_bali_header_setter=>create( object =
                           'ZSALES_ORDER' subobject = 'ZSUB_SALES_ORDER' ) ).

        CONCATENATE 'Job Started'  lv_date 'for user' lv_user INTO  lv_msg SEPARATED BY ''.

        DATA(l_free_text) = cl_bali_free_text_setter=>create( severity =
                            if_bali_constants=>c_severity_status
                            text = lv_msg ).

        l_log->add_item( item = l_free_text ).

        "Save the log into the database
        cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
        COMMIT WORK.

        SORT lt_sales_header BY id  soid.


        LOOP AT lt_sales_header INTO DATA(lw_header).
             SELECT * FROM zsd_sales_item
            WHERE header_id = @lw_header-id
            INTO TABLE @lt_sales_item.
             SORT lt_sales_item BY  itemid header_id  soid item.
          LOOP AT lt_sales_item ASSIGNING FIELD-SYMBOL(<fs_sales_item>).




            lv_total_crate = lv_total_crate + <fs_sales_item>-quatity.
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
            lw_header-division ='00'.
           lw_header-shipcondition = '01'.

            lt_so_h = VALUE #( ( %cid = 'H001'
                                    %data = VALUE #( salesordertype =  lw_header-ordertype
                                                    salesorganization = lw_header-salesorg
                                                    distributionchannel = lw_header-dischannel
                                                    organizationdivision = lw_header-division
                                                    soldtoparty = lw_header-soldtoparty
                                                    purchaseorderbycustomer = lw_header-customer_ref
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

            APPEND VALUE #(  %cid = <fs_sales_item>-item
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
              <fs_sales_item>-item = <fs_sales_item>-item + 10.
              APPEND VALUE #(  %cid = <fs_sales_item>-item

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

*A111
*000000000080000001
          ENDLOOP.
          IF lt_so_h IS NOT INITIAL.
            lt_so_i =  VALUE #( ( %cid_ref = 'H001'
                                   salesorder = space
                                   %target =  ls_so_i-%target ) ).

*    -------Create sales order----
            DATA : ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp.
            MODIFY ENTITIES OF i_salesordertp
            ENTITY salesorder
            CREATE
            FROM lt_so_h
            CREATE BY \_item FROM lt_so_i
            CREATE BY \_partner FROM lt_so_p
            MAPPED DATA(ls_mapped)
            FAILED DATA(ls_failed)
            REPORTED DATA(ls_reported).
            COMMIT ENTITIES BEGIN
                      RESPONSE OF i_salesordertp
                      FAILED DATA(lt_commit_failed)
                      REPORTED DATA(lt_commit_reported).
            IF  lt_commit_reported IS NOT INITIAL.

              CONVERT KEY OF i_salesordertp FROM ls_so_temp_key-salesorder TO DATA(ls_so_final_key).
*        zbp_i_sales_order_header=>mapped_sales_order = ls_so_final_key-salesorder.
              DATA(lv_so) = ls_so_final_key-salesorder.
              wa_msg-so_id = lw_header-soid.
              wa_msg-msg = |'Sales Order' { lv_so } Created  |.
              wa_msg-msgty  = 'S'.
              APPEND wa_msg to it_msg.
              lw_header-vbeln = lv_so.
              MODIFY zsd_sales_header FROM  @lw_header.
              commit WORK.
            ELSEIF lt_commit_failed is NOT INITIAL.

            LOOP AT lt_commit_failed-salesorder ASSIGNING FIELD-SYMBOL(<ls_commit>).

            CLEAR lv_result.
                    lv_result = |Sales Order Creation  failed|.

                    CLEAR : wa_msg.
                    wa_msg-so_id = lw_header-soid .
                    wa_msg-msgty    = 'E'.
                    wa_msg-msg      = lv_result.
                    APPEND wa_msg TO it_msg.
                    CLEAR wa_msg.


            ENDLOOP.

            ENDIF.

            COMMIT ENTITIES END.
          ENDIF.
          CLEAR :lt_so_h,lt_so_i,lt_so_p,lv_total_crate,ls_mapped,ls_failed,ls_reported,
          ls_so_i-%target,ls_so_i,ls_so_temp_key,lt_commit_failed,lt_commit_reported,wa_msg,
          lt_sales_item.
        ENDLOOP.

         LOOP AT it_msg INTO wa_msg.

          CONCATENATE  wa_msg-so_id wa_msg-msg INTO lv_msg SEPARATED BY ' : '.


          l_free_text = cl_bali_free_text_setter=>create( severity = wa_msg-msgty
*                            if_bali_constants=>c_severity_ status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDLOOP.

        IF it_msg[] IS NOT INITIAL.

          lv_msg = 'Job Completed'.

          l_free_text = cl_bali_free_text_setter=>create( severity =
                              if_bali_constants=>c_severity_status
                              text = lv_msg ).

          l_log->add_item( item = l_free_text ).

          "Save the log into the database
          cl_bali_log_db=>get_instance( )->save_log( log = l_log assign_to_current_appl_job = abap_true ).
          COMMIT WORK.
          CLEAR wa_msg.

        ENDIF.

*000000000000000029
*                                     product = '000000000080000001'
*                                     requestedquantityunit = 'EA'
      CATCH cx_bali_runtime INTO DATA(l_runtime_exception).
    ENDTRY.

  ENDMETHOD.


  METHOD if_apj_dt_exec_object~get_parameters.

    et_parameter_def = VALUE #(
*       ( selname = 'P_CREATED_BY' kind = if_apj_dt_exec_object=>parameter
*         datatype = 'C' length = 14
*         mandatory_ind = abap_true
*         param_text  = 'Created By' changeable_ind = abap_true )
       ( selname = 'P_DATE' kind = if_apj_dt_exec_object=>parameter
         datatype = 'D' "length = 4
         mandatory_ind = abap_true
         param_text  = 'Created On' changeable_ind = abap_true ) ).

  ENDMETHOD.


  METHOD if_apj_rt_exec_object~execute.
    DATA : p_date       TYPE datum,
           p_created_by TYPE  c LENGTH 12.

    LOOP AT it_parameters INTO DATA(ls_parameter).
      CASE ls_parameter-selname.
        WHEN 'P_CREATED_BY'.
          p_created_by = ls_parameter-low.
          lv_user = p_created_by.
        WHEN 'P_DATE'.
          p_date = ls_parameter-low.
          lv_date =  p_date.
      ENDCASE.
    ENDLOOP.

    SELECT * FROM zsd_sales_header
   WHERE  vbeln is INITIAL
   AND    created_date = @p_date

   INTO TABLE @lt_sales_header.
    IF sy-subrc = 0.


   CALL METHOD create_so( ).

    ENDIF.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main.



    SELECT * FROM zsd_sales_header
    WHERE vbeln is INITIAL
    AND created_date = @sy-datum
     INTO TABLE @lt_sales_header.
    IF sy-subrc = 0.




    ENDIF.

    CALL METHOD create_so( ).

  ENDMETHOD.
ENDCLASS.
