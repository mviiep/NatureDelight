CLASS zcl_inv_form_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_INV_FORM_PRINT IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    DATA: lt_response        TYPE TABLE OF zce_inv_form_print,
          ls_response        TYPE zce_inv_form_print,
          lt_response_i      TYPE TABLE OF zce_inv_form_print_item,
          ls_response_i      TYPE zce_inv_form_print_item,
          lv_roundoff_amount TYPE i_billingdocitemprcgelmntbasic-conditionamount,
          lv_state_cd(2)     TYPE c.
    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).

    TYPES: BEGIN OF ty_items,
             billingdocument         TYPE i_billingdocumentitemtp-billingdocument,
             billingdocumentitem     TYPE i_billingdocumentitemtp-billingdocumentitem,
             product                 TYPE i_billingdocumentitemtp-product,
             billingdocumentitemtext TYPE i_billingdocumentitemtp-billingdocumentitemtext,
             billingquantityunit     TYPE i_billingdocumentitemtp-billingquantityunit,
             billingquantity         TYPE i_billingdocumentitemtp-billingquantity,
             transactioncurrency     TYPE i_billingdocumentitemtp-transactioncurrency,
             plant                   TYPE i_billingdocumentitemtp-plant,
             netamount               TYPE i_billingdocumentitemtp-netamount,
             acc_ass_grp             TYPE i_productsalesdelivery-accountdetnproductgroup,
           END OF ty_items.
    DATA : it_items  TYPE STANDARD TABLE OF ty_items,
           it_items1 TYPE STANDARD TABLE OF ty_items,
           it_items2 TYPE STANDARD TABLE OF ty_items,
           wa_items  TYPE ty_items.

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
        DATA(lv_m) = lx_no_sel_option->get_longtext(   ).
    ENDTRY.

    DATA(lr_inv)    =  VALUE #( lt_filter_cond[ name   = 'BILLINGDOCUMENT' ]-range OPTIONAL ).

    IF lr_inv[] IS NOT INITIAL.
      READ TABLE lr_inv INTO DATA(ls_inv) INDEX 1.
    ENDIF.

    READ ENTITY i_billingdocumenttp
      ALL FIELDS WITH VALUE #( ( billingdocument = ls_inv-low ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
      ALL FIELDS WITH VALUE #( ( billingdocument = ls_inv-low ) )
      RESULT FINAL(billingdata)
      FAILED FINAL(failed_data).

    SELECT billingdocument, billingdocumentitem, conditiontype,
           conditionrateamount, conditionamount, conditionratevalue
     FROM i_billingdocitemprcgelmntbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE billingdocument  = @billingdata-billingdocument
      AND billingdocumentitem = @billingdata-billingdocumentitem
      INTO TABLE @DATA(pricingdata).

    SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE product  = @billingdata-product
      AND plant = @billingdata-plant
      INTO TABLE @DATA(productplantbasic).

    SELECT partnerfunction, customer FROM i_salesorderpartner "i_salesorderitempartner "
    FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
*      AND   salesorderitem = @billingdata-salesdocumentitem
      INTO TABLE @DATA(it_vbpa).

    SELECT partnerfunction, customer FROM i_creditmemoreqpartner
        FOR ALL ENTRIES IN @billingdata
        WHERE creditmemorequest = @billingdata-referencesddocument
        APPENDING TABLE @it_vbpa.

    SELECT partnerfunction, customer FROM i_creditmemoreqpartner
        FOR ALL ENTRIES IN @billingdata
        WHERE creditmemorequest = @billingdata-referencesddocument
        INTO TABLE @DATA(it_vbpa_cr).

    READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument = ls_inv-low.
    READ TABLE billingdata   INTO DATA(wa_item) WITH KEY billingdocument = ls_inv-low.


    IF io_request->is_data_requested( ).


      ls_response-billingdocument      = wa_head-billingdocument.
      ls_response-billingdocumentdate  = wa_head-billingdocumentdate.

      ls_response-lr_no                = wa_head-yy1_lrnumber_bdh.
      ls_response-lr_date              = wa_head-yy1_lrdate_bdh.
      ls_response-transporter           = wa_head-yy1_transporter_bdh.


      IF wa_head-distributionchannel = '20'.
        ls_response-b2b_b2c = 'C'.
      ENDIF.

*          SELECT SINGLE PrecedingDocument FROM I_SDDocumentMultiLevelProcFlow
*          with PRIVILEGED ACCESS
*
*          WHERE SubsequentDocument = @lS_response-BILLINGDOCUMENT
*          AND SubsequentDocumentCategory = 'M'
*          AND PrecedingDocument = 'J'
*          INTO @ls_response-add_char2.
      SELECT SINGLE FROM i_billingdocumentitem
      WITH PRIVILEGED ACCESS
      FIELDS referencesddocument
      WHERE billingdocument = @ls_response-billingdocument
      INTO @ls_response-add_char2.

      SELECT SINGLE a~vehicle_no
      FROM zsdt_truckshet_h AS a
      JOIN zsdt_truckshet_i AS b
      ON a~trucksheet_no = b~trucksheet_no
      WHERE b~vbeln = @wa_head-billingdocument
      INTO @DATA(lv_vehicle).

      IF lv_vehicle IS INITIAL.
        lv_vehicle = wa_head-yy1_vehicle_no_bdh.
      ENDIF.

      SELECT SINGLE vehicle_no, lifnr, name1 FROM ztmm_vehicle
      WHERE vehicle_no = @lv_vehicle
      INTO @DATA(ls_vehicle).

      ls_response-vehicle_no           = lv_vehicle.
      ls_response-transporter          = wa_head-yy1_transporter_bdh.
      IF ls_response-transporter IS INITIAL.
        ls_response-transporter          = ls_vehicle-name1.
      ENDIF.

      SELECT SINGLE salesorder, purchaseorderbycustomer, customerpurchaseorderdate
      FROM i_salesorder
      WHERE salesorder = @wa_item-salesdocument
      INTO @DATA(ls_salesord).

      ls_response-po_no                 = ls_salesord-purchaseorderbycustomer.
      ls_response-po_date               = ls_salesord-customerpurchaseorderdate.

      SELECT SINGLE creditmemorequest, creditmemorequestdate
      FROM i_creditmemorequest "I_SALESORDER
      WHERE creditmemorequest = @wa_item-referencesddocument
      INTO @DATA(ls_salesord1).

      SELECT SINGLE FROM i_salesdocumentitem
      FIELDS referencesddocument
      WHERE salesdocument = @ls_salesord1-creditmemorequest
      INTO @DATA(lv_refdoc1).
      IF sy-subrc = 0.
        SELECT SINGLE FROM i_salesdocumentitem
       FIELDS referencesddocument
       WHERE salesdocument = @lv_refdoc1
       INTO @DATA(lv_refdoc2).
        IF sy-subrc = 0.
          SELECT SINGLE FROM i_billingdocument
          FIELDS billingdocumentdate
          WHERE billingdocument = @lv_refdoc2
          INTO @DATA(lv_ref_doc_date).
        ELSE.
          lv_refdoc2 = lv_refdoc1.
          SELECT SINGLE FROM i_billingdocument
          FIELDS billingdocumentdate
          WHERE billingdocument = @lv_refdoc2
          INTO @lv_ref_doc_date.
        ENDIF.
      ENDIF.


      ls_response-refdoc                = lv_refdoc2.
      ls_response-refdocdate            = lv_ref_doc_date.

      SELECT SINGLE FROM zsdt_invrefnum
      FIELDS docno, irn, ackno, ackdate, signedqrcode
      WHERE docno = @wa_head-billingdocument
      INTO @DATA(ls_einv).

      ls_response-irn                = ls_einv-irn.
      ls_response-ackno              = ls_einv-ackno.
      ls_response-ackdate            = ls_einv-ackdate.
      ls_response-signedqrcode       = ls_einv-signedqrcode.

      SELECT SINGLE FROM zsdt_ewaybill
      FIELDS docno, ebillno, vdfmdate, vdtodate
      WHERE docno = @wa_head-billingdocument
      INTO @DATA(ls_eway).

      ls_response-ebillno            = ls_eway-ebillno.
      ls_response-vdfmdate           = ls_eway-vdfmdate.
      ls_response-vdtodate           = ls_eway-vdtodate.

      SELECT SINGLE customer, addressid, customername, taxnumber3, country, region
       FROM i_customer
        WHERE customer = @wa_head-payerparty
        INTO @DATA(wa_kna1).
"" soc by naga on 30-04-2025
      SELECT SINGLE TelephoneNumber1 from I_customer

      WHERE customer = @wa_kna1-Customer
        INTO @ls_response-billto_mob .

"" eoc by naga on 30-04-2025
      cl_address_format=>get_instance( )->printform_postal_addr(
            EXPORTING
*                iv_address_type              = '1'
              iv_address_number            = wa_kna1-addressid
*                iv_person_number             =
              iv_language_of_country_field = sy-langu
*                iv_number_of_lines           = 99
*                iv_sender_country            = space
            IMPORTING
              ev_formatted_to_one_line     = DATA(one_line)
              et_formatted_all_lines       = DATA(all_lines)
          ).

      ls_response-billto_party = wa_head-payerparty.
      ls_response-billto_name  = wa_kna1-customername.
      ls_response-billto_gstin = wa_kna1-taxnumber3.

      CALL FUNCTION 'ZGST_STATECODE'
        EXPORTING
          iv_region   = wa_kna1-region
        IMPORTING
          ev_state_cd = lv_state_cd.

      SELECT SINGLE regionname FROM i_regiontext
      WITH PRIVILEGED ACCESS
      WHERE  country = @wa_kna1-country
      AND region = @wa_kna1-region
      AND language = @sy-langu
      INTO @DATA(lv_reg).

      ls_response-billto_state = |{ lv_state_cd } { lv_reg }|.

      LOOP AT all_lines INTO DATA(ls_all_lines).
        CASE sy-tabix.
          WHEN 1.
            ls_response-billto_addr1 = ls_all_lines.
          WHEN 2.
            ls_response-billto_addr2 = ls_all_lines.
          WHEN 3.
            ls_response-billto_addr3 = ls_all_lines.
          WHEN 4.
            ls_response-billto_addr4 = ls_all_lines.
          WHEN 5.
            ls_response-billto_addr5 = ls_all_lines.
          WHEN 6.
            ls_response-billto_addr6 = ls_all_lines.
        ENDCASE.
      ENDLOOP.

      READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
      IF sy-subrc = 0.

        SELECT SINGLE customer, addressid, customername, taxnumber3, country, region
         FROM i_customer
          WHERE customer = @wa_vbpa-customer
          INTO @wa_kna1.
"" soc by naga on 30-04-2025
 SELECT SINGLE TelephoneNumber1 from I_customer

      WHERE customer = @wa_vbpa-Customer
        INTO @ls_response-shipto_mob .

"" eoc by naga on 30-04-2025
        CLEAR : one_line, all_lines[].
        cl_address_format=>get_instance( )->printform_postal_addr(
              EXPORTING
*                iv_address_type              = '1'
                iv_address_number            = wa_kna1-addressid
*                iv_person_number             =
                iv_language_of_country_field = sy-langu
*                iv_number_of_lines           = 99
*                iv_sender_country            = space
              IMPORTING
                ev_formatted_to_one_line     = one_line
                et_formatted_all_lines       = all_lines
            ).

        ls_response-shipto_party = wa_vbpa-customer.
        ls_response-shipto_name  = wa_kna1-customername.
        ls_response-shipto_gstin = wa_kna1-taxnumber3.

        CALL FUNCTION 'ZGST_STATECODE'
          EXPORTING
            iv_region   = wa_kna1-region
          IMPORTING
            ev_state_cd = lv_state_cd.

        SELECT SINGLE regionname FROM i_regiontext
        WITH PRIVILEGED ACCESS
        WHERE  country = @wa_kna1-country
        AND region = @wa_kna1-region
        AND language = @sy-langu
        INTO @lv_reg.

        ls_response-shipto_state = |{ lv_state_cd } { lv_reg }|.

        LOOP AT all_lines INTO ls_all_lines.
          CASE sy-tabix.
            WHEN 1.
              ls_response-shipto_addr1 = ls_all_lines.
            WHEN 2.
              ls_response-shipto_addr2 = ls_all_lines.
            WHEN 3.
              ls_response-shipto_addr3 = ls_all_lines.
            WHEN 4.
              ls_response-shipto_addr4 = ls_all_lines.
            WHEN 5.
              ls_response-shipto_addr5 = ls_all_lines.
            WHEN 6.
              ls_response-shipto_addr6 = ls_all_lines.
          ENDCASE.
        ENDLOOP.

      ENDIF.

      ls_response-currency = wa_head-transactioncurrency.

      CLEAR : lt_response_i[], it_items[], it_items1[].
      LOOP AT billingdata INTO DATA(wa_vbrp1) WHERE billingquantity IS NOT INITIAL.

        MOVE-CORRESPONDING wa_vbrp1 TO wa_items.
        SELECT SINGLE accountdetnproductgroup FROM i_productsalesdelivery
        WHERE product = @wa_vbrp1-product
        AND   productsalesorg = @wa_head-salesorganization
        AND   productdistributionchnl = @wa_head-distributionchannel
        INTO @wa_items-acc_ass_grp.


        IF wa_vbrp1-netamount IS NOT INITIAL.

          APPEND wa_items TO it_items1.
          CLEAR wa_items.

        ELSE.

          APPEND wa_items TO it_items2.
          CLEAR wa_items.

        ENDIF.
      ENDLOOP.

      DATA : lv_matnr TYPE matnr.
      SORT it_items1 BY billingdocument acc_ass_grp product billingdocumentitem.
      LOOP AT it_items1 INTO wa_items.

*         if lv_matnr = wa_items-product AND
*            wa_items-netamount is INITIAL.
*            clear wa_items-billingdocumentitem.
*          collect wa_items into it_items.
*         else.
        APPEND wa_items TO it_items.
*         endif.

*         lv_matnr = wa_items-product.
        CLEAR wa_items.
      ENDLOOP.

      SORT it_items2 BY billingdocument acc_ass_grp product billingdocumentitem.
      LOOP AT it_items2 INTO wa_items.

*         if lv_matnr = wa_items-product AND
*            wa_items-netamount is INITIAL.
        CLEAR wa_items-billingdocumentitem.
        COLLECT wa_items INTO it_items.
*         else.
*          append wa_items to it_items.
*         endif.
*
*         lv_matnr = wa_items-product.
        CLEAR wa_items.
      ENDLOOP.

*        sort it_items by BillingDocument billingdocumentitem.
      CLEAR : lv_roundoff_amount.

      LOOP AT it_items INTO DATA(wa_vbrp).
        ls_response_i-billingdocument  = wa_vbrp-billingdocument.
        ls_response_i-item             = sy-tabix.
        ls_response_i-matnr            = wa_vbrp-product.
        ls_response_i-maktx            = wa_vbrp-billingdocumentitemtext.
        ls_response_i-uom              = wa_vbrp-billingquantityunit.
        ls_response_i-quantity         = wa_vbrp-billingquantity.
        ls_response_i-currency         = wa_head-transactioncurrency.

        READ TABLE productplantbasic INTO DATA(plantdata) WITH KEY product = wa_vbrp-product
                                                                   plant = wa_vbrp-plant.
        IF sy-subrc = 0.
          ls_response_i-hsn =  plantdata-consumptiontaxctrlcode.
        ENDIF.

        SELECT SINGLE FROM i_billingdocumentitem
         WITH PRIVILEGED ACCESS
        FIELDS salesdocumentitemcategory
        WHERE billingdocument = @wa_vbrp-billingdocument
        AND billingdocumentitem = @wa_vbrp-billingdocumentitem
        INTO @DATA(lv_item_category).
        IF lv_item_category = 'TAN' OR lv_item_category = 'TAD'
       OR lv_item_category = 'CB1I' OR lv_item_category = 'GAN2' OR
       lv_item_category = 'G2N' OR  lv_item_category = 'L2N'.
          IF wa_vbrp-product = '000000000040000054' OR
             wa_vbrp-product = '000000000040000038' OR
              wa_vbrp-product =  '000000000040000035' OR
             wa_vbrp-product = '000000000040000053'.
          ELSE.
            SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
             FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
             WHERE alternativeunit = @wa_vbrp-billingquantityunit
             AND product = @wa_vbrp-product
             AND baseunit = @wa_vbrp-billingquantityunit
             INTO @DATA(lw_base_unit).

            SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
            FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
            WHERE alternativeunit = 'KI'
            AND product = @wa_vbrp-product
            AND baseunit = @wa_vbrp-billingquantityunit
            INTO @DATA(lw_source_unit).
            IF lw_base_unit-quantitynumerator IS NOT INITIAL
            AND lw_source_unit-quantitynumerator IS NOT INITIAL.

              DATA : lv_crate TYPE i.
              CLEAR :lv_crate.
              lv_crate   = (  wa_vbrp-billingquantity *
                ( lw_base_unit-quantitynumerator / lw_base_unit-quantitydenominator ) *
                ( lw_source_unit-quantitydenominator / lw_source_unit-quantitynumerator ) )
                .

              ls_response_i-add_char1 = lv_crate.
              CONDENSE ls_response_i-add_char1.
            ENDIF.
          ENDIF.


          LOOP AT pricingdata INTO DATA(prcd_elements)
                  WHERE billingdocument = wa_vbrp-billingdocument AND
                        billingdocumentitem = wa_vbrp-billingdocumentitem.

            IF  prcd_elements-conditiontype = 'ZPRC' OR
                prcd_elements-conditiontype = 'ZPRB' OR
                prcd_elements-conditiontype = 'ZPRS' OR
                prcd_elements-conditiontype = 'ZPR0'.
              ls_response_i-rate   = prcd_elements-conditionratevalue.
              ls_response_i-rate_c = |{ ls_response_i-rate } { ls_response_i-currency }|.
              ls_response_i-amount = prcd_elements-conditionamount.
              ls_response-baseamount = ls_response-baseamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'JOIG'.
              ls_response_i-gst_per =  ls_response_i-gst_per + prcd_elements-conditionratevalue.
              ls_response_i-gst_amt = ls_response_i-gst_amt + prcd_elements-conditionamount.
              ls_response-igstamount = ls_response-igstamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'JOCG'.
              ls_response_i-gst_per =  ls_response_i-gst_per + prcd_elements-conditionratevalue.
              ls_response_i-gst_amt = ls_response_i-gst_amt + prcd_elements-conditionamount.
              ls_response-cgstamount = ls_response-cgstamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'JOSG'.
              ls_response_i-gst_per = ls_response_i-gst_per + prcd_elements-conditionratevalue.
              ls_response_i-gst_amt = ls_response_i-gst_amt + prcd_elements-conditionamount.
              ls_response-sgstamount = ls_response-sgstamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'ZDIP' OR prcd_elements-conditiontype = 'ZDLK'.
              ls_response-discamount = ls_response-discamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'JTC1' OR prcd_elements-conditiontype = 'JTC2' OR
            prcd_elements-conditiontype = 'ZTC1' .
              ls_response-tcsper    = prcd_elements-conditionratevalue.
              ls_response-tcsamount = ls_response-tcsamount + prcd_elements-conditionamount.
            ENDIF.

            IF prcd_elements-conditiontype = 'DRD1' .

*             OR prcd_elements-conditiontype = 'JTC1'
*             OR prcd_elements-conditiontype = 'ZTC1' OR prcd_elements-conditiontype = 'JTCB'.


              lv_roundoff_amount = lv_roundoff_amount + prcd_elements-conditionamount.
            ENDIF.

          ENDLOOP.
        ENDIF.


        APPEND ls_response_i TO lt_response_i.
        CLEAR : ls_response_i,lv_item_category.

      ENDLOOP.

      ls_response-tot_tax = ls_response-igstamount + ls_response-cgstamount +
                            ls_response-sgstamount + ls_response-tcsamount.
*        if (  wa_head-DistributionChannel = '30'  or wa_head-DistributionChannel = '50') AND
*        ( wa_head-Division = '06' or wa_head-Division = '05'  or  wa_head-Division = '00').
*       lS_response-NetAmount = lS_response-BASEAmount + lS_response-DiscAmount +
*                               lS_response-FreightAmount + lS_response-tot_tax  + lv_roundoff_amount .
*         ELSE.
*
*       lS_response-NetAmount = lv_roundoff_amount.
*       ENDIF.

      IF (  wa_head-distributionchannel = '20' ) AND (  wa_head-division = '00'  OR
      wa_head-division = '01' OR wa_head-division = '02'  OR wa_head-division = '03'
      OR wa_head-division = '04' OR wa_head-division = '08' OR wa_head-division = '09'
     OR  wa_head-division = '10' OR wa_head-division = '11' OR wa_head-division = '12').

        ls_response-netamount = ls_response-baseamount + ls_response-discamount +
                                ls_response-freightamount + ls_response-tot_tax  + lv_roundoff_amount .
      ELSEIF (  wa_head-distributionchannel = '10'  or wa_head-distributionchannel = '30'
      ) AND (  wa_head-division = '05'  OR wa_head-division = '07' or   wa_head-division = '00' ).

        ls_response-netamount = ls_response-baseamount + ls_response-discamount +
                                    ls_response-freightamount + ls_response-tot_tax  + lv_roundoff_amount .
      ELSEIF (  wa_head-distributionchannel = '50' ) AND (  wa_head-division = '00' OR wa_head-division = '06'  ).
        ls_response-netamount = ls_response-baseamount + ls_response-discamount +
                                       ls_response-freightamount + ls_response-tot_tax  + lv_roundoff_amount .

      ELSE.
        ls_response-netamount = lv_roundoff_amount.

      ENDIF.

*lS_response-NetAmount = lS_response-BASEAmount + lS_response-DiscAmount +
*                               lS_response-FreightAmount + lS_response-tot_tax  .
      DATA lv_amount TYPE string.
      lv_amount = ls_response-netamount.
      CONDENSE  lv_amount.
      DATA(lo_amount) = NEW zz_amount_in_words(  ).
      IF    wa_head-transactioncurrency = 'INR'.
        CALL METHOD lo_amount->num2words(
          EXPORTING
            iv_num   = lv_amount
          RECEIVING
            rv_words = ls_response-amountinwords ).
      ELSE.

        CALL METHOD lo_amount->amount_dollar(
          EXPORTING
            iv_num   = lv_amount
          RECEIVING
            rv_words = ls_response-amountinwords ).

      ENDIF.
      APPEND ls_response TO lt_response.
      CLEAR ls_response.

    ENDIF.

    CASE io_request->get_entity_id( ).
      WHEN 'ZCE_INV_FORM_PRINT'.

        io_response->set_total_number_of_records( lines( lt_response ) ).
        io_response->set_data( lt_response ).

      WHEN 'ZCE_INV_FORM_PRINT_ITEM'.

        io_response->set_total_number_of_records( lines( lt_response_i ) ).
        io_response->set_data( lt_response_i ).

      WHEN 'ZCE_INV_FORM_DELETE'.

*      DATA: lt_res TYPE TABLE OF ZCE_CRATE_BAL_FORM_DELETE,
*            ls_res TYPE ZCE_CRATE_BAL_FORM_DELETE.
*
*
*      io_response->set_total_number_of_records( lines( lt_res ) ).
*      io_response->set_data( lt_res ).

    ENDCASE.



  ENDMETHOD.
ENDCLASS.
