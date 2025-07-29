CLASS lhc_zi_trucksheet_view DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PUBLIC SECTION.


  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_trucksheet_view RESULT result.
    METHODS forward FOR MODIFY
      IMPORTING keys FOR ACTION zi_trucksheet_view~forward RESULT result.
    METHODS get_global_features FOR GLOBAL FEATURES
      IMPORTING REQUEST requested_features FOR zi_trucksheet_view RESULT result.
    METHODS vehicle_number FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_trucksheet_view~vehicle_number.


ENDCLASS.

CLASS lhc_zi_trucksheet_view IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.


  METHOD forward.

    DATA : nr_number       TYPE cl_numberrange_runtime=>nr_number,
           lv_retcode      TYPE cl_numberrange_runtime=>nr_returncode,
           lt_trucksheet_h TYPE TABLE FOR CREATE zi_truckshet_h,
           lt_data         TYPE TABLE FOR CREATE zi_truckshet_h\_item,
           lt_trucksheet_i TYPE TABLE FOR CREATE zi_truckshet_h\_item,
           lv_item         TYPE i_billingdocumentitembasic-billingdocumentitem.

    DATA: lv_noofcrate TYPE i,
          lv_noofcan   TYPE i,
          lv_msg TYPE c LENGTH 100,
          lv_matkl     TYPE i_product-productgroup,
          lv_total_amount TYPE i_billingdocument-TotalNetAmount.

    READ ENTITIES OF zi_trucksheet_view IN LOCAL MODE
      ENTITY zi_trucksheet_view
        ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(members).


    DATA(lt_keys) = keys.

    READ TABLE lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
    IF sy-subrc = 0.
      IF <fs_key>-%param-trucksheet_date IS INITIAL.
        GET TIME STAMP FIELD DATA(lv_ts_end).
        <fs_key>-%param-trucksheet_date = sy-datum.
      ENDIF.
      DATA(trucksheet_date) = <fs_key>-%param-trucksheet_date.
*      DATA(crate_days)      = <fs_key>-%param-crate_days.
      DATA(driver_name)     = <fs_key>-%param-driver_name.
      DATA(driver_telno)    = <fs_key>-%param-driver_telno.
      DATA(distace)         = <fs_key>-%param-distace.
*      DATA(trans_doc_no)    = <fs_key>-%param-trans_doc_no.
*      DATA(route)           = <fs_key>-%param-route.
      DATA(vehicleno) = <fs_key>-%param-vehicleno.
    ENDIF.
    TRANSLATE  vehicleno TO UPPER CASE.
    TRY.
        CALL METHOD cl_numberrange_runtime=>number_get
          EXPORTING
            nr_range_nr = '01'
            object      = 'ZNROTRUCK'
          IMPORTING
            number      = nr_number
            returncode  = lv_retcode.

      CATCH cx_nr_object_not_found INTO data(lo_1).

      DATA(lv_te1) = lo_1->get_longtext(  ).

      CATCH cx_number_ranges INTO data(lo_2).
      DATA(lv_te2) = lo_2->get_longtext(  ).
    ENDTRY.
    DATA(lv_jo) =  |{ nr_number ALPHA = OUT }|.

    IF members[] IS NOT INITIAL.
      SELECT * FROM zi_so_invoice
      FOR ALL ENTRIES IN @members
      WHERE billingdocument = @members-vbeln
      INTO TABLE @DATA(lt_zi_so_invoice).
    ENDIF.
    READ  TABLE lt_zi_so_invoice INTO DATA(lw_so_invoice) INDEX 1.

    SELECT SINGLE distributionchannel FROM i_billingdocument
    WITH PRIVILEGED ACCESS
    WHERE billingdocument = @lw_so_invoice-billingdocument
    INTO @DATA(lv_dis_channel).
    IF lv_dis_channel = 20.

      SELECT SINGLE vehicle_no FROM ztmm_vehicle
      WHERE vehicle_no = @vehicleno
      INTO @DATA(lw_vehicle_master).
*      IF sy-subrc <> 0 and lw_vehicle_master is INITIAL.
*
*      lv_msg = 'Please Enter Vehicle Number from Vehicel Master '.
*
*      APPEND VALUE #(   %cid = lv_jo
*                        %msg = new_message(
*                              id       = '00'
*                              number   = 208
*                              v1       = lv_msg
*                              severity = if_abap_behv_message=>severity-error  )
*                              %element = VALUE #(  itemtrucksheetno  = if_abap_behv=>mk-on
*                                                   trucksheetitem = if_abap_behv=>mk-on ) )
*                              TO reported-zi_trucksheet_view.
*      return.
*      ENDIF.

    ENDIF.
    DATA(members2) = members[].
    DATA(var1) = lines( members ).
    DELETE ADJACENT DUPLICATES FROM members2 COMPARING route.
    DATA(var2) = lines( members2 ).

    IF  var2 <> '1'.
CLEAr : lv_msg.
      lv_msg = 'Different Route !!, Choose invoice with same route'.

      APPEND VALUE #(   %cid = lv_jo
                        %msg = new_message(
                              id       = '00'
                              number   = 208
                              v1       = lv_msg
                              severity = if_abap_behv_message=>severity-error  )
                              %element = VALUE #(  itemtrucksheetno  = if_abap_behv=>mk-on
                                                   trucksheetitem = if_abap_behv=>mk-on ) )
                              TO reported-zi_trucksheet_view.

    ELSE.
      LOOP AT members ASSIGNING FIELD-SYMBOL(<fs_member>).

        lv_item = lv_item + 10.

        LOOP AT  lt_zi_so_invoice INTO DATA(ls_mat) WHERE billingdocument = <fs_member>-vbeln.
          IF ls_mat-material = '000000000040000054' OR
          ls_mat-material = '000000000040000038' OR
            ls_mat-material =  '000000000040000035' OR
           ls_mat-material = '000000000040000053'.
           else.
          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = @ls_mat-baseunit
          AND product = @ls_mat-material
          AND baseunit = @ls_mat-baseunit
          INTO @DATA(lw_base_unit).

          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = 'KI'
          AND product = @ls_mat-material
          AND baseunit = @ls_mat-baseunit
          INTO @DATA(lw_source_unit).
          IF lw_base_unit-quantitynumerator IS NOT INITIAL
          AND lw_source_unit-quantitynumerator IS NOT INITIAL.
          if ls_mat-ItemCategory = 'TAN'.
            lv_noofcrate = (  ls_mat-qty *
            ( lw_base_unit-quantitynumerator / lw_base_unit-quantitydenominator ) *
            ( lw_source_unit-quantitydenominator / lw_source_unit-quantitynumerator ) )
            +  lv_noofcrate .
          ENDIF.

          ENDIF.
          endif.


*          IF ls_mat-unit = 'CRT' OR ls_mat-unit = 'KI'.
*            lv_noofcrate = lv_noofcrate + ls_mat-qty.
*          ELSE.
*            lv_noofcan = lv_noofcan + ls_mat-qty.
*          ENDIF.
          DATA(trans_doc_no)    = ls_mat-yy1_lrnumber_bdh.
        ENDLOOP.
         clear : lv_total_amount.
         lv_total_amount = <fs_member>-netwr + <fs_member>-taxamount.
        lt_data = VALUE #( ( %cid_ref = 'C1'
                             trucksheetno = lv_jo
                             %target = VALUE #( ( %cid = lv_item
                                                  itemtrucksheetno = lv_jo
                                                  %control-itemtrucksheetno = if_abap_behv=>mk-on
                                                  trucksheetitem = lv_item
                                                  %control-trucksheetitem = if_abap_behv=>mk-on
                                                  vbeln = <fs_member>-vbeln
                                                  %control-vbeln = if_abap_behv=>mk-on
                                                  kunag = <fs_member>-kunag
                                                  %control-kunag = if_abap_behv=>mk-on
                                                  matkl = lv_matkl
                                                  %control-matkl = if_abap_behv=>mk-on
                                                  noofcan = lv_noofcan
                                                  %control-noofcan = if_abap_behv=>mk-on
                                                  noofcrate = lv_noofcrate
                                                  %control-noofcrate = if_abap_behv=>mk-on
                                                  name1 = <fs_member>-name1
                                                  %control-name1 = if_abap_behv=>mk-on
                                                  route = <fs_member>-route
                                                  %control-route = if_abap_behv=>mk-on
*                                                  meins = <fs_member>-unit
*                                                  %control-meins = if_abap_behv=>mk-on
*                                                  qty = <fs_member>-fkimg
*                                                  %contro<l-qty = if_abap_behv=>mk-on
                                                  amount =   lv_total_amount
                                                  %control-amount = if_abap_behv=>mk-on
                                                  currency = <fs_member>-curr
                                                  %control-currency = if_abap_behv=>mk-on
                                                 ) ) ) ).


        <fs_member>-itemtrucksheetno = lv_jo.
        APPEND LINES OF lt_data TO lt_trucksheet_i.
        CLEAR: lv_noofcan, lv_noofcrate.

      ENDLOOP.
      lt_trucksheet_h = VALUE #( (  %cid = 'C1'
                                    trucksheetno = lv_jo
                                    vehicleno = vehicleno "'MH12345678'
                                    drivername = driver_name
                                    drivertelno = driver_telno
                                    trucksheetdate = trucksheet_date
*                                  CrateDays = crate_days
                                    transdocno = trans_doc_no
                                    createdby = cl_abap_context_info=>get_user_alias( )
                                    createdon = cl_abap_context_info=>get_system_date( )
                                    creationdate = sy-datum
                                    %control = VALUE #(
                                               trucksheetno = if_abap_behv=>mk-on
                                               vehicleno = if_abap_behv=>mk-on
                                               drivername = if_abap_behv=>mk-on
                                               drivertelno = if_abap_behv=>mk-on
                                               trucksheetdate = if_abap_behv=>mk-on
                                               cratedays = if_abap_behv=>mk-on
                                               transdocno = if_abap_behv=>mk-on
                                               createdon = if_abap_behv=>mk-on
                                               createdby = if_abap_behv=>mk-on
                                               creationdate = if_abap_behv=>mk-on
                                                ) ) ).


*      DELETE FROM zsdt_truckshet_h.
*      DELETE FROM zsdt_truckshet_i.

      MODIFY ENTITIES OF zi_truckshet_h
        ENTITY _truckheader CREATE FROM lt_trucksheet_h
        CREATE BY \_item    FROM lt_trucksheet_i
        MAPPED DATA(it_mapped)
        FAILED DATA(it_failed)
        REPORTED DATA(it_reported).





*    IF it_failed IS INITIAL.

      result = VALUE #( FOR new IN result ( %cid_ref = lv_jo
                                            %param = VALUE #( itemtrucksheetno = lv_jo ) ) ).

      lv_msg = 'Truckshet No ' && lv_jo && ' is generated'.

      APPEND VALUE #(   %cid = lv_jo
                        %msg = new_message(
                              id       = '00'
                              number   = 208
                              v1       = lv_msg
                              severity = if_abap_behv_message=>severity-success  )
                              %element = VALUE #(  itemtrucksheetno  = if_abap_behv=>mk-on
                                                   trucksheetitem = if_abap_behv=>mk-on ) )
                              TO reported-zi_trucksheet_view.

    ENDIF.


  ENDMETHOD.


  METHOD get_global_features.
  ENDMETHOD.

  METHOD Vehicle_number.
*   READ ENTITIES OF zi_trucksheet_view IN LOCAL MODE
*      ENTITY zi_trucksheet_view
*        ALL FIELDS WITH CORRESPONDING #( keys )
*      RESULT DATA(members).
*
*       DATA(lt_keys) = keys.
*
*    READ TABLE lt_keys ASSIGNING FIELD-SYMBOL(<fs_key>) INDEX 1.
*    IF sy-subrc = 0.
*    if <fs_key>-%key-.
*
*    endif.
*    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_trucksheet_view DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_trucksheet_view IMPLEMENTATION.

  METHOD save_modified.



  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
