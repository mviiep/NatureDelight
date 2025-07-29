CLASS zcl_cleartax_ewaybill DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

DATA : gv_exp TYPE c.

DATA : lv_str TYPE string.

DATA : it_data TYPE TABLE OF zsdst_eway_bill,
       wa_data TYPE zsdst_eway_bill.
DATA : it_data1       TYPE TABLE OF zsdst_ewaybill,
       wa_data1       TYPE  zsdst_ewaybill,
       wa_transaction TYPE  zsdst_transaction_waybill,
       wa_buyerdtls   TYPE  zsdst_buyerdtls_wb,
       wa_sellerdtls  TYPE  zsdst_sellerdtls_wb,
       wa_ExpShipDtls TYPE zsdst_shipdtls_wb,
       wa_dispdtls    TYPE  zsdst_dispdtls,
       itemlist       TYPE  zsdtt_itemlist_wb,
       wa_itemlist    TYPE  zsdst_itemlist_wb.


******************************************************************

    DATA : json TYPE string.
    DATA : it_trans            TYPE STANDARD TABLE OF zsdst_einv,
           wa_tran             TYPE zsdst_einv,
           wa_trandtls         TYPE  zsdst_trandtls,
           wa_docdtls          TYPE  zsdst_docdtls,
           wa_shipdtls         TYPE  zsdst_shipdtls,
           wa_valdtls          TYPE  zsdst_valdtls,
           wa_paydtls          TYPE  zsdst_paydtls,
           wa_refdtls          TYPE  zsdst_refdtls,
           addldocdtls         TYPE  zsdtt_addldocdtls,
           wa_addldocdtls      TYPE  zsdst_addldocdtls,
           wa_expdtls          TYPE  zsdst_expdtls,
           wa_ewbdtls          TYPE  zsdst_ewbdtls,
           gv_gstin_seller(18) TYPE c.
    DATA : gv_disp TYPE c,
           gv_ship TYPE c.
    DATA : lv_buyer       TYPE i_customer-customer,
           lv_soldtoparty TYPE i_customer-customer,
           wa_vbrk        TYPE i_billingdocument.
    DATA:
      it_zei_api_url  TYPE STANDARD TABLE OF zei_api_url,
      wa_zei_api_url  TYPE zei_api_url,
      lv_access_token TYPE string,
      lv_url_post     TYPE string,
      lv_access       TYPE string,
      lv_compid       TYPE string.
    DATA : lv_billto_shipto TYPE c,
           lv_billfr_dispfr TYPE c.
    DATA : lv_owner_id TYPE string.

    DATA : lv_token       TYPE string,
           lv_monthyear   TYPE string,
           lv_gstin       TYPE string VALUE '27AAFCN2297L1ZY', "'27AAFCD5862R013',
           IV_GSTIN_TR    TYPE STRING,
           IV_NAME_TR     TYPE STRING,
           IV_DISTANCE    TYPE STRING,
           lv_mvapikey    TYPE string,
           lv_mvsecretkey TYPE string,
           lv_username    TYPE string,
           lv_password    TYPE string.


    DATA: lv_url_get               TYPE string,
          lv_auth_body             TYPE string,
          lv_content_length_value  TYPE i,
          lv_http_return_code      TYPE i,
          lv_http_error_descr      TYPE string,
          lv_http_error_descr_long TYPE xstring,
          lv_xml_result_str        TYPE string,
          lv_RESPONSE              TYPE string,
          LV_STAT                  TYPE C,
          lv_doc_status            TYPE string,
          lv_error_response        TYPE string,
          lv_govt_response         TYPE string,
          lv_success               TYPE c,
          lv_ackno                 TYPE string,
          lv_ackdt(19)             TYPE c,
          lv_irn                   TYPE string,
          lv_ewaybill_irn          TYPE string,
          lv_EwbDt                 TYPE string,
          lv_status                TYPE string,
          lv_valid_till            TYPE string,
          lv_signedinvoice         TYPE string,
          lv_signedqrcode          TYPE string.

    DATA:  WA_zsdt_invrefnum        TYPE zsdt_invrefnum,
           LT_IRN                   TYPE STANDARD TABLE OF zsdt_invrefnum,
           Ls_IRN                   TYPE zsdt_invrefnum,
           WA_zsdt_ewaybill         TYPE zsdt_ewaybill.

    TYPES: BEGIN OF ty_response_auth,
             custom_fields(100)   TYPE c,
             deleted(100)         TYPE c,
             document_status(100) TYPE c,
             error_response(100)  TYPE c,
             govt_response(100)   TYPE c,
             ackno(100)           TYPE c,
             ackdt(100)           TYPE c,
             irn(100)             TYPE c,
             signedinvoice   TYPE xstring,
             signedqrcode    TYPE xstring,
           END OF ty_response_auth.

    DATA : gs_resp_auth   TYPE ty_response_auth,
*           gs_resp_post   TYPE zsei_irn_response,
           wa_ztsd_ei_log TYPE ztsd_ei_log.

    DATA: lv_no(16) TYPE c.
    DATA : v1(20)        TYPE c,
           v2(20)        TYPE c,
           lv_date   TYPE d,
           lv_time   TYPE t,
           lv_cancel TYPE c.

    DATA: lv_vbeln(10) TYPE C.

    DATA : lv_num(5)    TYPE n,
           lv_unit_pr   TYPE i_billingdocumentitembasic-netamount,
           lv_disc      TYPE i_billingdocumentbasic-billingdocument,
           lv_freight   TYPE i_billingdocumentbasic-totalnetamount,
           lv_ins       TYPE i_billingdocumentbasic-totalnetamount,
           lv_asse_val  TYPE i_billingdocumentbasic-totalnetamount,
           lv_asse_val1 TYPE i_billingdocumentbasic-totalnetamount,
           lv_igst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_cgst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_sgst      TYPE i_billingdocumentbasic-totalnetamount,
           lv_igst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_cgst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_sgst_rt   TYPE i_billingdocumentitemprcgelmnt-conditionamount,
           lv_other_ch  TYPE i_billingdocumentitemprcgelmnt-conditionamount.
    DATA: lv_meins TYPE string.

    DATA : lv_tot_val      TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_disc     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_freight  TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_ins      TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_roff     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_asse_val TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_igst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_cgst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_sgst     TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_other    TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_item_val TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_rndof    TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_rndof_i  TYPE i_billingdocumentbasic-totalnetamount.

  DATA : LV_STATE_CD(2) TYPE C.

    METHODS:
      CREATE_EWAY_WITH_IRN,
      CREATE_EWAY_WITHOUT_IRN.

    METHODS: GENERATE_EWAY
      IMPORTING IM_VBELN    TYPE ZCHAR10
                IM_GSTIN    TYPE ZCHAR18
                IM_NAME     type zchar200
                IM_DIST     TYPE ZNUMC10
      EXPORTING EX_RESPONSE TYPE STRING
                EX_STATUS   TYPE C.

    METHODS: CANCEL_EWAY
      IMPORTING IM_VBELN    TYPE ZCHAR10
      EXPORTING EX_RESPONSE TYPE STRING
                EX_STATUS   TYPE C.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CLEARTAX_EWAYBILL IMPLEMENTATION.


  METHOD cancel_eway.

  DATA : cancelRsnCode TYPE string  VALUE 'DATA_ENTRY_MISTAKE',
         cancelRmrk    TYPE string  VALUE 'DATA_ENTRY_MISTAKE',
         ewbNo(12)         TYPE c,
         lv_ewbnumber  TYPE string.

*  if sy-sysid = 'ZJM' or sy-sysid = 'ZXP'.
*   lv_gstin = '27AAFCD5862R013'. "  "'27AAFCN2297L1ZY'.
*  else.
*      SELECT SINGLE * FROM i_businessplace WITH PRIVILEGED ACCESS
*         WHERE companycode = @wa_vbrk-companycode
*         AND   BusinessPlace = '1000'
*       INTO @DATA(wa_j_1bbranch).
*
*      lv_gstin = wa_j_1bbranch-taxnumber1.
    lv_gstin = '27AAFCN2297L1ZY'.
*  endif.


   lv_vbeln = IM_VBELN.

  SELECT * FROM zsdt_ewaybill
    WHERE docno = @lv_vbeln
    AND   status IN ('A', 'P')
    INTO TABLE @data(it_zsdt_ewaybill).
if it_zsdt_ewaybill[] is NOT INITIAL.
  SORT it_zsdt_ewaybill BY egen_dat DESCENDING egen_time DESCENDING.
  READ TABLE it_zsdt_ewaybill INTO data(wa_zsdt_ewaybill) INDEX 1.

  CONCATENATE '{"ewbNo":"' wa_zsdt_ewaybill-ebillno '",'
               '"cancelRsnCode":"' cancelRsnCode '",'
               '"cancelRmrk":"' cancelRmrk '"}'
               INTO json.


    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_CANCEL_EWAY'
                                     service_id     = 'YY1_CANCELEWAY_REST'
                               ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).


        lo_request->set_header_field( i_name = 'Content-Type'
                                      i_value = 'application/json' ).


        lo_request->set_header_field( i_name = 'gstin'
        i_value = LV_GSTIN ).

        lo_request->set_header_field( i_name = 'X-Cleartax-Auth-Token'
         i_value = '1.914f0afe-ec41-44c4-ac5d-9bf71af194ec_92d9e0731153b7c3cfdd75b92be0c1e5ad9a9f76064dea6648e601c56402ba69' ).
*        i_value = '1.dd710b6d-1c7f-41d0-b28a-dfa1425c776c_71fdc9c7e2e27539946a2ac1cdb64850e4d6f480b2cc43acce9be73cac76f9a8' ).


        lv_content_length_value = strlen( json ).
        lo_request->set_text( i_text = json
                              i_length = lv_content_length_value ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>POST ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        lv_RESPONSE = lv_xml_result_str.

        "capture response
    SELECT SINGLE FROM I_BillingDocument
    FIELDS CompanyCode, BillingDocumentDate, BillingDocumentType
    WHERE BillingDocument = @lv_vbeln
    INTO @DATA(LS_BILLDOC).

       clear: wa_ztsd_ei_log.
       wa_ztsd_ei_log-bukrs    = LS_BILLDOC-CompanyCode.
       wa_ztsd_ei_log-docno    = lv_vbeln.
       wa_ztsd_ei_log-doc_year = LS_BILLDOC-BillingDocumentDate+0(4).
       wa_ztsd_ei_log-doc_type = LS_BILLDOC-BillingDocumentType.
       wa_ztsd_ei_log-method   = 'CANCEL_EWAY'.
       wa_ztsd_ei_log-erdat    = sy-datlo.
       wa_ztsd_ei_log-uzeit    = sy-timlo.
       wa_ztsd_ei_log-message  = lv_xml_result_str.
       modify ztsd_ei_log from @wa_ztsd_ei_log.
       COMMIT work.


 DATA : str TYPE string.
  SPLIT lv_xml_result_str AT '"ewbStatus":"'           INTO str lv_status.
  SPLIT lv_xml_result_str AT '"ewbNumber":'            INTO str lv_ewbnumber.

  IF lv_status(9) = 'CANCELLED'.
    wa_zsdt_ewaybill-bukrs    = LS_BILLDOC-CompanyCode.
    wa_zsdt_ewaybill-docno    = lv_vbeln.
    wa_zsdt_ewaybill-gjahr    = LS_BILLDOC-BillingDocumentDate+0(4).
*    wa_zsdt_ewaybill-erdat    = sy-datum.
*    wa_zsdt_ewaybill-vdfmtime = sy-uzeit.
    wa_zsdt_ewaybill-status   = 'C'.

    MODIFY zsdt_ewaybill FROM @wa_zsdt_ewaybill.
    COMMIT WORK.
  endif.


      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
        DATA(LVTXT) = lx_exception->get_text( ).
        LV_RESPONSE = LVTXT.
    ENDTRY.
  endif.


   EX_RESPONSE = lv_RESPONSE.
   EX_STATUS   = LV_STAT.


  ENDMETHOD.


  METHOD CREATE_EWAY_WITHOUT_IRN.

    "GET DATA

    READ ENTITY i_billingdocumenttp
      ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
      ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingdata)
       FAILED FINAL(failed_data).

    IF billingdata[] IS NOT INITIAL.

    SELECT billingdocument, billingdocumentitem, conditiontype,
           conditionrateamount, conditionamount, ConditionRateValue FROM i_billingdocitemprcgelmntbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE billingdocument  = @billingdata-billingdocument
      AND billingdocumentitem = @billingdata-billingdocumentitem
      INTO TABLE @DATA(pricingdata).

    SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE product  = @billingdata-product
      AND plant = @billingdata-plant
      INTO TABLE @DATA(productplantbasic).

*      SELECT * FROM i_productqm
*        FOR ALL ENTRIES IN @billingdata
*        WHERE product = @billingdata-product
*        INTO TABLE @DATA(it_marc).

*      SELECT * FROM i_salesorderpartner
**        FOR ALL ENTRIES IN @billingdata
**        WHERE salesorder = @billingdata-referencesddocument
**        AND   partnerfunction = 'WE'
**        INTO TABLE @DATA(it_vbpa_del).
    ENDIF.

    SELECT partnerfunction, customer FROM i_salesorderpartner "I_SALESORDERITEMPARTNER "i_salesorderpartner
    FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
*      AND   SalesOrderItem = @billingdata-SalesDocumentItem
      INTO TABLE @DATA(it_vbpa).

    select SINGLE a~vehicle_no
    from zsdt_truckshet_h as a
    join zsdt_truckshet_i as b
    on a~trucksheet_no = b~trucksheet_no
    WHERE b~vbeln = @wa_vbrk-BillingDocument
    into @data(lv_vehicle).

    if lv_vehicle is INITIAL.
     lv_vehicle = wa_vbrk-yy1_vehicle_no_bdh.
    endif.
    select SINGLE vehicle_no, lifnr, name1 from ztmm_vehicle
    where vehicle_no = @lv_vehicle
    into @data(ls_vehicle).

    wa_transaction-transname = wa_vbrk-YY1_Transporter_BDH.

   if wa_transaction-transname is INITIAL.
   IF IV_NAME_TR IS NOT INITIAL.
     wa_transaction-transname = IV_NAME_TR.
   else.
     wa_transaction-transname = ls_vehicle-name1.
   endif.
   endif.

   wa_transaction-DISTANCE = IV_DISTANCE.

   IF IV_GSTIN_TR IS NOT INITIAL.
        wa_transaction-TransId   = IV_GSTIN_TR.
   ELSE.
      SELECT SINGLE
      supplier, TaxNumber3
       FROM i_supplier
        WHERE supplier = @ls_vehicle-lifnr
        INTO @DATA(wa_lfa1).
     wa_transaction-TransId   = wa_lfa1-TaxNumber3.
   ENDIF.

       wa_transaction-vehno      = lv_vehicle. "wa_vbrk-yy1_vehicle_no_bdh.
       CONDENSE wa_data-vehno.
      IF wa_vbrk-YY1_LRDate_BDH IS NOT INITIAL.
        CONCATENATE  wa_vbrk-YY1_LRDate_BDH+6(2) '/'  wa_vbrk-YY1_LRDate_BDH+4(2) '/'
                     wa_vbrk-YY1_LRDate_BDH+0(4) INTO  wa_transaction-transdocdt.
      ENDIF.
      IF wa_vbrk-YY1_LRNumber_BDH IS not INITIAL.
        wa_transaction-transdocno = wa_vbrk-YY1_LRNumber_BDH.
      ENDIF.

  wa_transaction-vehtype = 'R'.
*  wa_data1-distance = '100'.
  CONDENSE wa_transaction-distance.

  IF wa_transaction-vehno IS NOT INITIAL.
    wa_transaction-TransMode = 'ROAD'.
  ENDIF.

  "TranDtls
*--------------------------------------------------------------------*
  wa_transaction-supplytype         = 'Outward'. "NEED TO CHANGE
*  wa_transaction-subsupplytyp       = 1.   "Supply it should always be passed without quotes
  wa_transaction-subsupplytyp       = 'JOB_WORK'. "4.   "JOB_WORK
  wa_transaction-documentnumber     = wa_vbrk-BillingDocument.
  wa_transaction-subsupplytypedesc  =  'JOB_WORK'.
  CONCATENATE wa_vbrk-BillingDocumentDate+6(2) wa_vbrk-BillingDocumentDate+4(2)
  wa_vbrk-BillingDocumentDate+0(4) INTO wa_transaction-documentdate SEPARATED BY '/'.

  wa_transaction-documenttype           = 'CHL'.
*--------------------------------------------------------------------*
  "SELLERDTLS

*  if sy-sysid = 'ZJM' or sy-sysid = 'ZXP'.
*   lv_gstin = '27AAFCD5862R013'. "  "'27AAFCN2297L1ZY'.
*  else.
*      SELECT SINGLE * FROM i_businessplace WITH PRIVILEGED ACCESS
**         WHERE companycode = @wa_vbrk-companycode
**         AND   BusinessPlace = @wa_vbrk-bu
*       INTO @DATA(wa_j_1bbranch).
*
*      lv_gstin = wa_j_1bbranch-taxnumber1.
    lv_gstin = '27AAFCN2297L1ZY'.
*  endif.

  gv_gstin_seller = wa_sellerdtls-gstin = lv_gstin.

*  CONCATENATE wa_adrc_bupla-name1 wa_adrc_bupla-name2 INTO wa_sellerdtls-lglnm SEPARATED BY ''.
*  CONCATENATE wa_adrc_bupla-name1 wa_adrc_bupla-name2 INTO wa_sellerdtls-trdnm SEPARATED BY ''.
*  CONCATENATE wa_adrc_bupla-street wa_adrc_bupla-str_suppl1 wa_adrc_bupla-str_suppl2 INTO wa_sellerdtls-addr1 SEPARATED BY ''.
*  CONCATENATE wa_adrc_bupla-street wa_adrc_bupla-str_suppl1 wa_adrc_bupla-str_suppl2 INTO wa_sellerdtls-addr2 SEPARATED BY ''.
*
*  wa_sellerdtls-loc  = wa_adrc_bupla-city1.
*  wa_sellerdtls-pin  = wa_adrc_bupla-post_code1.
*  wa_sellerdtls-stcd = wa_adrc_bupla-region.

*     IF SY-sysid = 'ZJM' OR SY-sysid = 'ZXP'.
      gv_gstin_seller =  wa_sellerdtls-gstin = LV_GSTIN. "wa_j_1bbranch-gstin.
      wa_sellerdtls-lglnm = 'Nature Delight Dairy & Dairy Products Pvt. Ltd.'.
      wa_sellerdtls-trdnm = 'Nature Delight Dairy & Dairy Products Pvt. Ltd.'.
      wa_sellerdtls-addr1 = 'Gat No. 1189, At Post. Kalas,'.
      wa_sellerdtls-addr2 = 'Tal:. Indapur, Dist: Pune'.
      wa_sellerdtls-loc   = 'Kalas'.
      wa_sellerdtls-pin   = '413105'.
      wa_sellerdtls-stcd  = '27'.

      wa_dispdtls-nm = 'Nature Delight Dairy & Dairy Products Pvt. Ltd.'.
      wa_dispdtls-addr1 = 'Gat No. 1189, At Post. Kalas,'.
      wa_dispdtls-addr2 = 'Tal:. Indapur, Dist: Pune'.
      wa_dispdtls-loc   = 'Kalas'.
      wa_dispdtls-pin   = '413105'.
      wa_dispdtls-stcd  = '27'.
*     ENDIF.
*--------------------------------------------------------------------*

*--------------------------------------------------------------------*
      "BUYERDTLS
      READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH  KEY partnerfunction = 'AG'.  ""Sold to party
      IF sy-subrc = 0.
        lv_soldtoparty = wa_vbpa-customer.
      ENDIF.

      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'RE'.  ""Buyer
      IF sy-subrc = 0.
        lv_buyer = wa_vbpa-customer.
      ELSE.
        lv_buyer = lv_soldtoparty.
      ENDIF.


      SELECT SINGLE
      customer, AddressID, CustomerName, TaxNumber3, Country,
      StreetName, CityName, PostalCode, Region, TelephoneNumber1
       FROM i_customer
        WHERE customer = @lv_buyer
        INTO @DATA(wa_kna1).

      CLEAR gv_exp.
      IF wa_kna1-Country NE 'IN'.
        gv_exp = 'X'.
        wa_expdtls-cntcode = wa_kna1-Country.
      ENDIF.

*      SELECT SINGLE * FROM dfkkbptaxnum
*        WHERE partner = @lv_buyer AND taxtype = 'IN3'
*        INTO @DATA(wa_dfkkbptaxnum).
*
      wa_buyerdtls-gstin = wa_kna1-TaxNumber3. "wa_dfkkbptaxnum-taxnum.
      wa_buyerdtls-loc  = wa_kna1-cityname.
      wa_buyerdtls-pin  = wa_kna1-postalcode.
*      wa_buyerdtls-stcd = wa_kna1-region.
*      wa_buyerdtls-pos  = wa_kna1-region.
      wa_buyerdtls-lglnm = wa_kna1-CustomerName.
      wa_buyerdtls-trdnm = wa_kna1-CustomerName.

*      select single * from I_IN_GSTStateCodeMap "j_1istatecdm
*      where region = @wa_kna1-region
*      into @data(ls_stcode).
*      wa_buyerdtls-stcd = ls_stcode-IN_GSTLegalStateCode.

    CALL FUNCTION 'ZGST_STATECODE'
      EXPORTING
       IV_REGION = wa_kna1-region
      IMPORTING
       EV_STATE_CD = LV_STATE_CD.

       wa_buyerdtls-stcd = LV_STATE_CD.
*       wa_buyerdtls-pos  = LV_STATE_CD.

*      CONCATENATE wa_kna1-businesspartnername1 wa_kna1-businesspartnername2 INTO wa_buyerdtls-lglnm SEPARATED BY ''.
*      CONCATENATE wa_kna1-businesspartnername1 wa_kna1-businesspartnername2 INTO wa_buyerdtls-trdnm SEPARATED BY ''.
*      CONCATENATE wa_kna1-streetname wa_kna1-streetprefixname wa_kna1-streetsuffixname INTO wa_buyerdtls-addr1 SEPARATED BY ''.
*      CONCATENATE wa_kna1-streetname wa_kna1-streetprefixname wa_kna1-streetsuffixname INTO wa_buyerdtls-addr2 SEPARATED BY ''.
      CONCATENATE wa_kna1-streetname wa_kna1-cityname  INTO wa_buyerdtls-addr1 SEPARATED BY ''.
      CONCATENATE wa_kna1-streetname wa_kna1-cityname  INTO wa_buyerdtls-addr2 SEPARATED BY ''.

* --------------------------------------------------------------------*
      "SHIPDTLS
      CLEAR : gv_disp, gv_ship.

      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
      IF sy-subrc = 0 AND wa_vbpa-customer NE lv_buyer.
      SELECT SINGLE
      customer, AddressID, CustomerName, TaxNumber3, Country,
      StreetName, CityName, PostalCode, Region, TelephoneNumber1
       FROM i_customer
        WHERE customer = @wa_vbpa-customer
          INTO @DATA(wa_kna1_sh).
        wa_shipdtls-gstin = wa_kna1_sh-TaxNumber3.
        wa_shipdtls-loc   = wa_kna1_sh-cityname.
        wa_shipdtls-pin   = wa_kna1_sh-postalcode.
        wa_shipdtls-stcd  = wa_kna1_sh-region.
        wa_shipdtls-lglnm = wa_kna1_sh-CustomerName.
        wa_shipdtls-trdnm = wa_kna1_sh-CustomerName.

    CALL FUNCTION 'ZGST_STATECODE'
      EXPORTING
       IV_REGION = wa_kna1_sh-region
      IMPORTING
       EV_STATE_CD = LV_STATE_CD.

       wa_shipdtls-stcd = LV_STATE_CD.

      CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-cityname  INTO wa_shipdtls-addr1 SEPARATED BY ''.
      CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-cityname  INTO wa_shipdtls-addr2 SEPARATED BY ''.

      ELSE.
        gv_ship = 'X'.
      ENDIF.


      IF   wa_vbrk-DistributionChannel = '30'
        OR gv_exp = 'X'.
      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'ZE'.
        IF sy-subrc = 0.

          SELECT SINGLE
          customer, AddressID, CustomerName, TaxNumber3, Country,
          StreetName, CityName, PostalCode, Region, TelephoneNumber1
           FROM i_customer
            WHERE customer = @wa_vbpa-customer
              INTO @DATA(wa_kna1_PORT).

          wa_transaction-expshipdtls-addr1 = wa_kna1_PORT-CustomerName.
*          CONCATENATE wa_kna1_PORT-streetname wa_kna1_PORT-cityname
*          INTO wa_data1-transaction-expshipdtls-addr2 SEPARATED BY ''.
          wa_transaction-expshipdtls-loc   = wa_kna1_PORT-CityName.

        CALL FUNCTION 'ZGST_STATECODE'
          EXPORTING
           IV_REGION = wa_kna1_PORT-region
          IMPORTING
           EV_STATE_CD = LV_STATE_CD.

          wa_transaction-expshipdtls-stcd  = LV_STATE_CD.
          wa_transaction-expshipdtls-pin   = wa_kna1_PORT-PostalCode.
        ENDIF.
      endif.


      IF   wa_vbrk-DistributionChannel = '30'
        OR gv_exp = 'X'.
        wa_transaction-subsupplytyp = 3.
      ENDIF.

    IF GV_SHIP = ''.
      IF wa_transaction-subsupplytyp = '3' OR gv_exp = 'X'.
        wa_shipdtls-stcd = '96'.
        wa_shipdtls-pin  = '999999'.
        wa_expshipdtls-stcd = '96'.
        wa_expshipdtls-pin  = '999999'.
      ENDIF.
    ENDIF.

      IF wa_transaction-subsupplytyp = '3' OR gv_exp = 'X'.
        wa_buyerdtls-gstin = 'URP'.
        wa_buyerdtls-stcd = '96'.
        wa_buyerdtls-pin = '999999'.
      ENDIF.

* --------------------------------------------------------------------*
* Transaction type.
  wa_transaction-transactiontype    = '1'.

*  IF wa_buyerdtls-pin NE wa_expshipdtls-pin.
*    wa_transaction-transactiontype    = '2'.
*  ENDIF.
*
*  IF wa_sellerdtls-pin NE wa_dispdtls-pin.
*    wa_transaction-transactiontype    = '3'.
*  ENDIF.
*
*  IF wa_buyerdtls-pin NE wa_expshipdtls-pin AND wa_sellerdtls-pin NE wa_dispdtls-pin.
*    wa_transaction-transactiontype    = '4'.
*  ENDIF.

  "ITEMLIST
      CLEAR : lv_tot_val, lv_tot_disc, lv_tot_freight, lv_tot_ins, lv_tot_roff, lv_tot_asse_val,
           lv_tot_igst, lv_tot_cgst, lv_tot_sgst, lv_tot_other, lv_tot_rndof, lv_tot_rndof_i.


      LOOP AT billingdata INTO DATA(wa_vbrp).

        CLEAR : lv_unit_pr, lv_disc, lv_freight, lv_asse_val, lv_asse_val1, lv_igst, lv_cgst, lv_sgst,
                lv_igst_rt, lv_cgst_rt, lv_sgst_rt, lv_other_ch, lv_ins, lv_tot_rndof_i.

        lv_num = lv_num + 1.


        CONCATENATE wa_vbrp-product wa_vbrp-BillingDocumentItemText
        into wa_itemlist-prddesc SEPARATED BY '-'.

        wa_itemlist-qty         = wa_vbrp-billingquantity.

        READ TABLE productplantbasic INTO DATA(plantdata) WITH KEY product = wa_vbrp-product
                                                                  plant = wa_vbrp-plant.
        IF sy-subrc = 0.
          wa_itemlist-hsncd =  plantdata-consumptiontaxctrlcode.
        ENDIF.
        CLEAR lv_meins.
*        CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
*          EXPORTING
*            input          = wa_vbrp-BillingQuantityInBaseUnit
*            language       = 'E'
*          IMPORTING
*            output         = lv_meins
*          EXCEPTIONS
*            unit_not_found = 1.

*        READ TABLE it_zei_meins INTO wa_zei_meins WITH KEY sap_uom = lv_meins.
*        IF sy-subrc = 0.
*          wa_itemlist-unit = wa_zei_meins-gst_uom.
*        ELSE.
*        wa_itemlist-unit = wa_vbrp-BillingQuantityUnit. "billingquantityinbaseunit
*        ENDIF.

       case wa_vbrp-BillingQuantityUnit.
       when 'KG'.
         wa_itemlist-unit  = 'KGS'.
       when 'L'.
         wa_itemlist-unit  = 'LTR'.
       when 'EA'.
         wa_itemlist-unit  = 'NOS'.
       when 'CRT'.
         wa_itemlist-unit  = 'BOX'.
       when 'MON'.
         wa_itemlist-unit  = 'NOS'.
       when others.
        wa_itemlist-unit = wa_vbrp-BillingQuantityUnit.
       endcase.


        LOOP AT pricingdata INTO DATA(prcd_elements)
                WHERE billingdocument = wa_vbrp-billingdocument AND
                      billingdocumentitem = wa_vbrp-billingdocumentitem.

          IF  prcd_elements-conditiontype = 'ZPRC' OR
              prcd_elements-conditiontype = 'ZPRB' or
              prcd_elements-conditiontype = 'ZPRS'.
            lv_unit_pr = prcd_elements-ConditionRateValue. "conditionrateamount.
            lv_asse_val = lv_asse_val + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOIG'.
            lv_igst_rt = prcd_elements-ConditionRateValue." / 10.
            lv_igst = lv_igst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOCG'.
            lv_cgst_rt = prcd_elements-ConditionRateValue." / 10.
            lv_cgst = lv_cgst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOSG'.
            lv_sgst_rt = prcd_elements-ConditionRateValue." / 10.
            lv_sgst = lv_sgst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'ZDIP' OR prcd_elements-conditiontype = 'ZDLK'.
            lv_disc = lv_disc + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JTC1' OR prcd_elements-conditiontype = 'JTC2'.
            lv_other_ch = lv_other_ch + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'DRD1'.
           lv_tot_rndof_i = lv_tot_rndof_i + prcd_elements-conditionamount.
          endif.

        ENDLOOP.


        lv_asse_val  = lv_asse_val * wa_vbrk-accountingexchangerate.
        wa_itemlist-assamt    = lv_asse_val - ( lv_disc * wa_vbrk-accountingexchangerate ).
*WA_ITEMLIST-PRETAXVAL =

    IF lv_igst_rt IS NOT INITIAL.
      wa_itemlist-igstrt     = lv_igst_rt.
    ELSEIF lv_cgst_rt IS NOT INITIAL.
      wa_itemlist-cgstrt     = lv_cgst_rt.
    ELSEIF lv_sgst_rt IS NOT INITIAL.
      wa_itemlist-sgstrt     = lv_sgst_rt.
    ENDIF.

    lv_sgst_rt =    lv_cgst_rt.

    wa_itemlist-sgstrt = wa_itemlist-cgstrt.

    wa_itemlist-igstamt = ( lv_asse_val * lv_igst_rt ) / 100.  "LV_IGST * WA_VBRK-KURRF.
    wa_itemlist-cgstamt = ( lv_asse_val * lv_cgst_rt ) / 100.  "LV_CGST * WA_VBRK-KURRF.
    wa_itemlist-sgstamt = ( lv_asse_val * lv_sgst_rt ) / 100.  "LV_SGST * WA_VBRK-KURRF.

    wa_itemlist-othchrg = ( lv_other_ch * wa_vbrk-accountingexchangerate ).

    lv_tot_item_val  =  lv_tot_item_val  + wa_itemlist-assamt + wa_itemlist-igstamt + wa_itemlist-cgstamt + wa_itemlist-sgstamt +
                             wa_itemlist-cesamt + wa_itemlist-cesamt + wa_itemlist-cesnonadvamt +
                             wa_itemlist-othchrg.


    lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-assamt.
    lv_tot_igst     = lv_tot_igst     + wa_itemlist-igstamt.
    lv_tot_cgst     = lv_tot_cgst     + wa_itemlist-cgstamt.
    lv_tot_sgst     = lv_tot_sgst     + wa_itemlist-sgstamt.
    lv_tot_other    = lv_tot_other    + lv_other_ch.
    lv_tot_rndof    = lv_tot_rndof    + lv_tot_rndof_i.

    APPEND wa_itemlist TO itemlist.
    CLEAR wa_itemlist.
  ENDLOOP.


  wa_transaction-totalinvoiceamount = lv_tot_item_val + lv_tot_rndof.
  wa_transaction-TotalCgstAmount    = lv_tot_cgst.
  wa_transaction-TotalSgstAmount    = lv_tot_sgst.
  wa_transaction-totaligstamount    = lv_tot_igst.
  wa_transaction-TotalAssessableAmount    = lv_tot_igst.
  wa_transaction-otheramount        = lv_tot_other.
  wa_transaction-sellerdtls = wa_sellerdtls.
  wa_transaction-buyerdtls  = wa_buyerdtls.
  wa_transaction-dispdtls   = wa_dispdtls.
  wa_transaction-EXPshipdtls = wa_expshipdtls.
  wa_transaction-itemlist[] = itemlist[].
  wa_data1-transaction = wa_transaction.

  CONDENSE wa_data1-transaction-subsupplytyp.
  APPEND wa_data1 TO it_data1.

*--------------------------------------------------------------------*

  DATA : lt_mapping  TYPE /ui2/cl_json=>name_mappings.
  lt_mapping = VALUE #(
( abap = 'DOCUMENTNUMBER' JSOn = 'DocumentNumber' )
( abap = 'DOCUMENTTYPE' json = 'DocumentType' )
( abap = 'DOCUMENTDATE' json = 'DocumentDate' )
( abap = 'SUPPLYTYPE' json = 'SupplyType' )
*( abap = 'SUBSUPPLYTYPE' json = 'SubSupplyType' )
( abap = 'SUBSUPPLYTYP' json = 'SubSupplyType' )
( abap = 'SUBSUPPLYTYPEDESC' json = 'SubSupplyTypeDesc' )
( abap = 'TRANSACTIONTYPE' JSon = 'TransactionType' )
( abap = 'BUYERDTLS' json = 'BuyerDtls' )
( abap = 'SELLERDTLS' json = 'SellerDtls' )
( abap = 'EXPSHIPDTLS' json = 'ExpShipDtls' )
( abap = 'DISPDTLS' json = 'DispDtls' )
( abap = 'ITEMLIST' json = 'ItemList' )

( abap = 'TOTALINVOICEAMOUNT' json = 'TotalInvoiceAmount' )
( abap = 'TOTALCGSTAMOUNT' json = 'TotalCgstAmount' )
( abap = 'TOTALSGSTAMOUNT' json = 'TotalSgstAmount' )
( abap = 'TOTALIGSTAMOUNT' json = 'TotalIgstAmount' )
( abap = 'TOTALCESSAMOUNT' json = 'TotalCessAmount' )
( abap = 'TOTALCESSNONADVOLAMOUNT' json = 'TotalCessNonAdvolAmount' )
( abap = 'TOTALASSESSABLEAMOUNT' Json = 'TotalAssessableAmount' )
( abap = 'OTHERAMOUNT' Json = 'OtherAmount' )
( abap = 'OTHERTCSAMOUNT' json = 'OtherTcsAmount' )
( abap = 'TRANSID' json = 'TransId' )
( abap = 'TRANSNAME' JSOn = 'TransName' )
( abap = 'TRANSMODE' JSOn = 'TransMode' )
( abap = 'DISTANCE' json = 'Distance' )
( abap = 'TRANSDOCNO' JSon = 'TransDocNo' )
( abap = 'TRANSDOCDT' JSon = 'TransDocDt' )
( abap = 'VEHNO' json = 'VehNo' )
( abap = 'VEHTYPE' json = 'VehType' )

( abap = 'GSTIN' json = 'Gstin' )
( abap = 'LGLNM' json = 'LglNm' )
( abap = 'TRDNM' json = 'TrdNm' )
( abap = 'ADDR1' json = 'Addr1' )
( abap = 'ADDR2' json = 'Addr2' )
( abap = 'LOC' json = 'Loc' )
( abap = 'PIN' json = 'Pin' )
( abap = 'STCD' json = 'Stcd' )

( abap = 'NM' json = 'Nm' )

( aBAP = 'PRODNAME' JSon = 'ProdName' )
( aBAP = 'PRODDESC' JSon = 'ProdDesc' )
( aBAP = 'HSNCD' json = 'HsnCd' )
( aBAP = 'QTY' json = 'Qty' )
( aBAP = 'UNIT' json = 'Unit' )
( aBAP = 'ASSAMT' json = 'AssAmt' )
( aBAP = 'CGSTRT' json = 'CgstRt' )
( aBAP = 'CGSTAMT' JSOn = 'CgstAmt' )
( aBAP = 'SGSTRT' json = 'SgstRt' )
( aBAP = 'SGSTAMT' JSOn = 'SgstAmt' )
( aBAP = 'IGSTRT' json = 'IgstRt' )
( aBAP = 'IGSTAMT' JSOn = 'IgstAmt' )
( aBAP = 'CESRT' json = 'CesRt' )
( aBAP = 'CESAMT' json = 'CesAmt' )
( aBAP = 'OTHCHRG' JSOn = 'OthChrg' )
( aBAP = 'CESNONADVAMT' json = 'CesNonAdvAmt' )
).
  DATA(lv_json) = /ui2/cl_json=>serialize( data = it_data1 compress = abap_false
  pretty_name = /ui2/cl_json=>pretty_mode-camel_case
        name_mappings = lt_mapping ).
*  SHIFT lv_json LEFT DELETING LEADING '[{"transaction":'.

  IF gv_disp = 'X'.
*   REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""}'
*   IN LV_JSON WITH '"DispDtls": []'.
    REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""},'
    IN lv_json WITH ' '.
  ENDIF.

  IF gv_ship = 'X'.
*   REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""}'
*   IN LV_JSON WITH '"ShipDtls": []'.
    REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""},'
    IN lv_json WITH ''.
  ENDIF.


  REPLACE ALL  OCCURRENCES OF '[{"transaction":' IN lv_json WITH space.
  REPLACE ALL OCCURRENCES OF '"Pin":0,' IN LV_JSON WITH '"Pin": null,'.
*  SHIFT lv_json RIGHT DELETING TRAILING '}]'.

  REPLACE ALL OCCURRENCES OF '""' IN lv_json WITH 'null'.
  REPLACE ALL OCCURRENCES OF '"Distance":null' IN lv_json WITH '"Distance":0'.
  REPLACE ALL OCCURRENCES OF '"Distance":"1"' IN lv_json WITH '"Distance":null'.

  IF wa_data1-transaction-supplytype  = 'EXPWOP' OR wa_data1-transaction-supplytype  = 'SEZWOP'.
    REPLACE ALL OCCURRENCES OF '"irt":null' IN lv_json WITH '"irt":"0.00"'.
  ENDIF.
  REPLACE ALL OCCURRENCES OF '"subsupplytyp":"1"' IN lv_json WITH '"SubSupplyType":1'.
  CONDENSE lv_json.
  REPLACE ALL  OCCURRENCES OF '"VehType":null}}]' IN lv_json WITH '"VehType":null}'.
  REPLACE ALL  OCCURRENCES OF '"VehType":"R"}}]' IN lv_json WITH '"VehType":"R"}'.
  json = lv_json.

*****************************************************************************************

**********************

    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_EWAY_WITHOUT'
                                     service_id     = 'YY1_GENERATEEWAYWO_REST'
                               ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).


        lo_request->set_header_field( i_name = 'Content-Type'
                                      i_value = 'application/json' ).


        lo_request->set_header_field( i_name = 'gstin'
        i_value = LV_GSTIN ).

        lo_request->set_header_field( i_name = 'X-Cleartax-Auth-Token'
         i_value = '1.914f0afe-ec41-44c4-ac5d-9bf71af194ec_92d9e0731153b7c3cfdd75b92be0c1e5ad9a9f76064dea6648e601c56402ba69' ).
*        i_value = '1.dd710b6d-1c7f-41d0-b28a-dfa1425c776c_71fdc9c7e2e27539946a2ac1cdb64850e4d6f480b2cc43acce9be73cac76f9a8' ).




        lv_content_length_value = strlen( json ).
        lo_request->set_text( i_text = json
                              i_length = lv_content_length_value ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>PUT ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        lv_RESPONSE = lv_xml_result_str.

        "capture response
    SELECT SINGLE FROM I_BillingDocument
    FIELDS CompanyCode, BillingDocumentDate, BillingDocumentType
    WHERE BillingDocument = @lv_vbeln
    INTO @DATA(LS_BILLDOC).

       clear: wa_ztsd_ei_log.
       wa_ztsd_ei_log-bukrs    = LS_BILLDOC-CompanyCode.
       wa_ztsd_ei_log-docno    = lv_vbeln.
       wa_ztsd_ei_log-doc_year = LS_BILLDOC-BillingDocumentDate+0(4).
       wa_ztsd_ei_log-doc_type = LS_BILLDOC-BillingDocumentType.
       wa_ztsd_ei_log-method   = 'GENERATE_EWAY'.
       wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
       wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
       wa_ztsd_ei_log-message  = lv_xml_result_str.
       modify ztsd_ei_log from @wa_ztsd_ei_log.
       COMMIT work.


 DATA : str TYPE string.
  SPLIT lv_xml_result_str AT '"document_status":"'   INTO str lv_doc_status.
  SPLIT lv_xml_result_str AT '"error_response":'     INTO str lv_error_response.
  SPLIT lv_xml_result_str AT '"govt_response":'      INTO str lv_govt_response.
  SPLIT lv_xml_result_str AT '"Success":"'           INTO str lv_success.

  SPLIT lv_xml_result_str AT '"AckNo":'              INTO str lv_AckNo.
  SPLIT lv_AckNo AT ','                              INTO lv_AckNo str .

  SPLIT lv_xml_result_str AT '"AckDt":"'             INTO str lv_AckDt.

  SPLIT lv_xml_result_str AT '"Irn":"'               INTO str lv_Irn.
  SPLIT lv_irn AT '"'                                INTO lv_Irn str.

  SPLIT lv_xml_result_str AT '"EwbNo":'              INTO str lv_ewaybill_irn.
  SPLIT lv_ewaybill_irn  AT ','                      INTO lv_ewaybill_irn str .

  SPLIT lv_xml_result_str AT 'EwbDt":"'              INTO str lv_EwbDt.
  SPLIT lv_EwbDt AT '"'                              INTO lv_EwbDt str .

  SPLIT lv_xml_result_str AT '"status":"'            INTO str lv_status.

  SPLIT lv_xml_result_str AT '"EwbValidTill":"'      INTO str lv_valid_till.
  SPLIT lv_valid_till AT '"'                         INTO lv_valid_till str .

   IF "lv_success(1) EQ 'Y'AND
       lv_ewaybill_irn IS NOT INITIAL.
    CLEAR wa_zsdt_ewaybill.
    wa_zsdt_ewaybill-bukrs     = LS_BILLDOC-CompanyCode.
    wa_zsdt_ewaybill-doctyp    = LS_BILLDOC-BillingDocumentType.
    wa_zsdt_ewaybill-docno     = lv_vbeln.

*    i_date = wa_vbrk-fkdat.
*    i_fyv  = 'V3'.
*
*    CALL FUNCTION 'GM_GET_FISCAL_YEAR'
*      EXPORTING
*        i_date = i_date
*        i_fyv  = i_fyv
*      IMPORTING
*        e_fy   = e_fy.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

    wa_zsdt_ewaybill-gjahr = LS_BILLDOC-BillingDocumentDate+0(4).
    wa_zsdt_ewaybill-ebillno = lv_ewaybill_irn."gs_resp_post_topaz-response-ewbno.

    REPLACE ALL OCCURRENCES OF '-' IN lv_EwbDt WITH space.
    CONDENSE lv_EwbDt.
    wa_zsdt_ewaybill-egen_dat = lv_EwbDt(8).

    REPLACE ALL OCCURRENCES OF ':' IN lv_EwbDt WITH space.
    CONDENSE lv_ewbdt.
    wa_zsdt_ewaybill-egen_time = lv_ewbdt+9(6).

    wa_zsdt_ewaybill-vdfmdate = wa_zsdt_ewaybill-egen_dat.
    wa_zsdt_ewaybill-vdfmtime = wa_zsdt_ewaybill-egen_time.

    IF wa_zsdt_ewaybill-egen_dat IS INITIAL.
      wa_zsdt_ewaybill-egen_dat = sy-datlo. "sy-datum.
    ENDIF.
    IF wa_zsdt_ewaybill-egen_time IS INITIAL.
      wa_zsdt_ewaybill-egen_time = sy-timlo. "sy-UZeIT.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '-' IN lv_valid_till WITH space.
    CONDENSE lv_valid_till.

    REPLACE ALL OCCURRENCES OF ':' IN lv_valid_till WITH space.
    CONDENSE lv_valid_till.

   IF lv_valid_till IS NOT INITIAL.
    wa_zsdt_ewaybill-vdtodate  = lv_valid_till(8).
    wa_zsdt_ewaybill-vdtotime  = lv_valid_till+9(6).
   ENDIF.

    wa_zsdt_ewaybill-status = 'P'.
    wa_zsdt_ewaybill-createdby = sy-uname.
    wa_zsdt_ewaybill-createdon = sy-datlo. "sy-datum.
    wa_zsdt_ewaybill-createdat = sy-timlo. "sy-uzeit.

*    wa_zsdt_ewaybill-zzqrcode = gs_resp_post_topaz-response-barcode.

    MODIFY zsdt_ewaybill FROM @wa_zsdt_ewaybill.
    commit work.
    CLEAR wa_zsdt_ewaybill.
   endif.


      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
        DATA(LVTXT) = lx_exception->get_text( ).
        LV_RESPONSE = LVTXT.
    ENDTRY.

  ENDMETHOD.


  METHOD CREATE_EWAY_WITH_IRN.

    "GET DATA

    READ ENTITY i_billingdocumenttp
      ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
      ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingdata)
       FAILED FINAL(failed_data).

    SELECT billingdocument, billingdocumentitem, conditiontype, conditionrateamount, conditionamount FROM i_billingdocitemprcgelmntbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE billingdocument  = @billingdata-billingdocument
      AND billingdocumentitem = @billingdata-billingdocumentitem
      INTO TABLE @DATA(pricingdata).

    SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
    FOR ALL ENTRIES IN @billingdata
    WHERE product  = @billingdata-product
      AND plant = @billingdata-plant
      INTO TABLE @DATA(productplantbasic).

    IF billingdata[] IS NOT INITIAL.
*      SELECT * FROM i_productqm
*        FOR ALL ENTRIES IN @billingdata
*        WHERE product = @billingdata-product
*        INTO TABLE @DATA(it_marc).

*      SELECT * FROM i_salesorderpartner
*        FOR ALL ENTRIES IN @billingdata
*        WHERE salesorder = @billingdata-referencesddocument
*        AND   partnerfunction = 'WE'
*        INTO TABLE @DATA(it_vbpa_del).
    ENDIF.

    SELECT partnerfunction, customer FROM i_salesorderpartner "I_SALESORDERITEMPARTNER "i_salesorderpartner
    FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
*      AND   SalesOrderItem = @billingdata-SalesDocumentItem
      INTO TABLE @DATA(it_vbpa).

    select SINGLE a~vehicle_no
    from zsdt_truckshet_h as a
    join zsdt_truckshet_i as b
    on a~trucksheet_no = b~trucksheet_no
    WHERE b~vbeln = @wa_vbrk-BillingDocument
    into @data(lv_vehicle).

    if lv_vehicle is INITIAL.
     lv_vehicle = wa_vbrk-yy1_vehicle_no_bdh.
    endif.

    select SINGLE vehicle_no, lifnr, name1 from ztmm_vehicle
    where vehicle_no = @lv_vehicle "wa_vbrk-yy1_vehicle_no_bdh
    into @data(ls_vehicle).

    wa_transaction-transname = wa_vbrk-YY1_Transporter_BDH.

   if wa_transaction-transname is INITIAL.

   IF IV_NAME_TR IS NOT INITIAL.
     wa_data-transname = IV_NAME_TR.
   else.
     wa_data-transname = ls_vehicle-name1.
   endif.
   endif.

   wa_transaction-DISTANCE = IV_DISTANCE.

   IF IV_GSTIN_TR IS NOT INITIAL.
        wa_data-TransId   = IV_GSTIN_TR.
   ELSE.
      SELECT SINGLE
      supplier, TaxNumber3
       FROM i_supplier
        WHERE supplier = @ls_vehicle-lifnr
        INTO @DATA(wa_lfa1).

*     wa_data-transname = ls_vehicle-name1.
     wa_data-TransId   = wa_lfa1-TaxNumber3.
   ENDIF.

       wa_data-vehno      = lv_vehicle. "wa_vbrk-yy1_vehicle_no_bdh.
       CONDENSE wa_data-vehno.
      IF wa_vbrk-YY1_LRDate_BDH IS NOT INITIAL.
        CONCATENATE  wa_vbrk-YY1_LRDate_BDH+6(2) '/'  wa_vbrk-YY1_LRDate_BDH+4(2) '/'
                     wa_vbrk-YY1_LRDate_BDH+0(4) INTO  wa_data-transdocdt.
      ENDIF.
      IF wa_vbrk-YY1_LRNumber_BDH IS not INITIAL.
        wa_data-transdocno = wa_vbrk-YY1_LRNumber_BDH.
      ENDIF.

  wa_data-vehtype = 'R'.
  wa_data-irn      = ls_irn-irn.
*  wa_data-distance = '100'.
  CONDENSE wa_data-distance.

**********************
      CLEAR : gv_disp, gv_ship.

      READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
      IF sy-subrc = 0.
      SELECT SINGLE
      customer, AddressID, CustomerName, TaxNumber3, Country,
      StreetName, CityName, PostalCode, Region, TelephoneNumber1
       FROM i_customer
        WHERE customer = @wa_vbpa-customer
          INTO @DATA(wa_kna1_sh).

    wa_data-expshipdtls-addr1 = wa_kna1_sh-CustomerName.
    wa_data-expshipdtls-addr2 = wa_kna1_sh-StreetName.
    wa_data-expshipdtls-loc   = wa_kna1_sh-CityName.
    wa_data-expshipdtls-stcd  = wa_kna1_sh-region.
    wa_data-expshipdtls-pin   = wa_kna1_sh-PostalCode.

    CALL FUNCTION 'ZGST_STATECODE'
      EXPORTING
       IV_REGION = wa_kna1_sh-region
      IMPORTING
       EV_STATE_CD = LV_STATE_CD.

       wa_data-expshipdtls-stcd = LV_STATE_CD.

    IF wa_vbrk-BillingDocumentType = 'F2' AND wa_vbrk-DistributionChannel = '30'.
      wa_data-expshipdtls-stcd  = '96'. "wa_kna1_sh-region.
      wa_data-expshipdtls-pin   = '999999'.
    ENDIF.

    ENDIF.

      IF   wa_vbrk-DistributionChannel = '30'
        OR gv_exp = 'X'.
      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'ZE'.
        IF sy-subrc = 0.

          SELECT SINGLE
          customer, AddressID, CustomerName, TaxNumber3, Country,
          StreetName, CityName, PostalCode, Region, TelephoneNumber1
           FROM i_customer
            WHERE customer = @wa_vbpa-customer
              INTO @DATA(wa_kna1_PORT).

          wa_data-expshipdtls-addr1 = wa_kna1_PORT-CustomerName.
*          CONCATENATE wa_kna1_PORT-streetname wa_kna1_PORT-cityname
*          INTO wa_data1-transaction-expshipdtls-addr2 SEPARATED BY ''.
          wa_data-expshipdtls-loc   = wa_kna1_PORT-CityName.

        CALL FUNCTION 'ZGST_STATECODE'
          EXPORTING
           IV_REGION = wa_kna1_PORT-region
          IMPORTING
           EV_STATE_CD = LV_STATE_CD.

          wa_data-expshipdtls-stcd  = LV_STATE_CD.
          wa_data-expshipdtls-pin   = wa_kna1_PORT-PostalCode.
        ENDIF.
      endif.

*  select SINGLE * FROM ZSDT_PORTOFLOAD INTO @data(wa_ZSDT_PORTOFLOAD)
*    WHERE PORT_OF_LOAD = @wa_vbrk-PORT_OF_LOAD.
*  IF sy-subrc = 0.
*    CONCATENATE wa_ZSDT_PORTOFLOAD-PORT_OF_LOAD wa_ZSDT_PORTOFLOAD-PORT_LOAD_CNTR INTO
*    wa_data-expshipdtls-addr1 SEPARATED BY ''.
*    CONCATENATE wa_ZSDT_PORTOFLOAD-PORT_OF_LOAD wa_ZSDT_PORTOFLOAD-PORT_LOAD_CNTR INTO
*    wa_data-expshipdtls-addr2 SEPARATED BY ''.
*    wa_data-expshipdtls-loc   = wa_ZSDT_PORTOFLOAD-PORT_OF_LOAD.
*    wa_data-expshipdtls-stcd  = wa_ZSDT_PORTOFLOAD-REGIO.
*    wa_data-expshipdtls-pin   = wa_ZSDT_PORTOFLOAD-POST_CODE1.
*  ENDIF.

  IF wa_data-vehno IS NOT INITIAL.
    wa_data-transmode = 'ROAD'.
  ENDIF.


  WA_DATA-sub_supply = 'SUPPLY'.
  IF WA_VBRK-DistributionChannel = '50'.
    WA_DATA-sub_supply = 'JOB_WORK'.
  ENDIF.

  APPEND wa_data TO it_DATA.


**********************

  DATA : lt_mapping  TYPE /ui2/cl_json=>name_mappings.
  lt_mapping = VALUE #(
( abap = 'IRN' json = 'Irn' )
( abap = 'DISTANCE' json = 'Distance' )
( abap = 'TRANSMODE' json = 'TransMode' )
( abap = 'TRANSID' json = 'TransId' )
( abap = 'TRANSNAME' json = 'TransName' )
( abap = 'TRANSDOCDT' json = 'TransDocDt' )
( abap = 'TRANSDOCNO' json = 'TransDocNo' )
( abap = 'VEHNO' json = 'VehNo' )
( abap = 'VEHTYPE' json = 'VehType' )
( abap = 'EXPSHIPDTLS' json = 'ExpShipDtls' )
( abap = 'ADDR1' json = 'Addr1' )
( abap = 'ADDR2' json = 'Addr2' )
( abap = 'LOC' json = 'Loc' )
( abap = 'PIN' json = 'Pin' )
( abap = 'STCD' json = 'Stcd' )
( abap = 'DISPDTLS' json = 'DispDtls' )
( abap = 'NM' json = 'Nm' )
*( abap = 'ADDR11' json = 'Addr1' )
*( abap = 'ADDR22' json = 'Addr2' )
*( abap = 'LOC1' json = 'Loc' )
*( abap = 'PIN1' json = 'Pin' )
*( abap = 'STCD1' json = 'Stcd' )
).

*      READ TABLE it_trans INTO wa_tran INDEX 1.
*      DATA(lv_json) = /ui2/cl_json=>serialize( data      = wa_tran-transaction
*                                           compress      = abap_false
*                                           pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
*                                           name_mappings = lt_mapping ).

  DATA(lv_json) = /ui2/cl_json=>serialize( data = it_data compress = abap_false
                                     pretty_name = /ui2/cl_json=>pretty_mode-camel_case
                                      name_mappings = lt_mapping ).

*  SHIFT lv_json LEFT DELETING LEADING '['.
*  SHIFT lv_json RIGHT DELETING TRAILING ']'.
  REPLACE ALL OCCURRENCES OF '""' IN lv_json WITH 'null'.
  REPLACE ALL OCCURRENCES OF ':0*' IN lv_json WITH ':null*'.
  REPLACE ALL OCCURRENCES OF '":0,' IN lv_json WITH '":null,'.
  REPLACE ALL OCCURRENCES OF '":"0.00",' IN lv_json WITH '":null,'.
  REPLACE ALL OCCURRENCES OF '"Distance":null' IN lv_json WITH '"Distance":0'.
  REPLACE ALL OCCURRENCES OF '"Distance":"1"' IN lv_json WITH '"Distance":null'.

  json = lv_json.


**********************

    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_GENERATE_EWAY'
                                     service_id     = 'YY1_GENERATEEWAY_REST'
                               ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).


        lo_request->set_header_field( i_name = 'Content-Type'
                                      i_value = 'application/json' ).


        lo_request->set_header_field( i_name = 'gstin'
        i_value = LV_GSTIN ).

        lo_request->set_header_field( i_name = 'X-Cleartax-Auth-Token'
         i_value = '1.914f0afe-ec41-44c4-ac5d-9bf71af194ec_92d9e0731153b7c3cfdd75b92be0c1e5ad9a9f76064dea6648e601c56402ba69' ).
*        i_value = '1.dd710b6d-1c7f-41d0-b28a-dfa1425c776c_71fdc9c7e2e27539946a2ac1cdb64850e4d6f480b2cc43acce9be73cac76f9a8' ).




        lv_content_length_value = strlen( json ).
        lo_request->set_text( i_text = json
                              i_length = lv_content_length_value ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>POST ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        lv_RESPONSE = lv_xml_result_str.

        "capture response
    SELECT SINGLE FROM I_BillingDocument
    FIELDS CompanyCode, BillingDocumentDate, BillingDocumentType
    WHERE BillingDocument = @lv_vbeln
    INTO @DATA(LS_BILLDOC).

       clear: wa_ztsd_ei_log.
       wa_ztsd_ei_log-bukrs    = LS_BILLDOC-CompanyCode.
       wa_ztsd_ei_log-docno    = lv_vbeln.
       wa_ztsd_ei_log-doc_year = LS_BILLDOC-BillingDocumentDate+0(4).
       wa_ztsd_ei_log-doc_type = LS_BILLDOC-BillingDocumentType.
       wa_ztsd_ei_log-method   = 'GENERATE_EWAY'.
       wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
       wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
       wa_ztsd_ei_log-message  = lv_xml_result_str.
       modify ztsd_ei_log from @wa_ztsd_ei_log.
       COMMIT work.


 DATA : str TYPE string.
  SPLIT lv_xml_result_str AT '"document_status":"'   INTO str lv_doc_status.
  SPLIT lv_xml_result_str AT '"error_response":'     INTO str lv_error_response.
  SPLIT lv_xml_result_str AT '"govt_response":'      INTO str lv_govt_response.
  SPLIT lv_xml_result_str AT '"Success":"'           INTO str lv_success.

  SPLIT lv_xml_result_str AT '"AckNo":'              INTO str lv_AckNo.
  SPLIT lv_AckNo AT ','                              INTO lv_AckNo str .

  SPLIT lv_xml_result_str AT '"AckDt":"'             INTO str lv_AckDt.

  SPLIT lv_xml_result_str AT '"Irn":"'               INTO str lv_Irn.
  SPLIT lv_irn AT '"'                                INTO lv_Irn str.

  SPLIT lv_xml_result_str AT '"EwbNo":'              INTO str lv_ewaybill_irn.
  SPLIT lv_ewaybill_irn  AT ','                      INTO lv_ewaybill_irn str .

  SPLIT lv_xml_result_str AT 'EwbDt":"'              INTO str lv_EwbDt.
  SPLIT lv_EwbDt AT '"'                              INTO lv_EwbDt str .

  SPLIT lv_xml_result_str AT '"status":"'            INTO str lv_status.

  SPLIT lv_xml_result_str AT '"EwbValidTill":"'      INTO str lv_valid_till.
  SPLIT lv_valid_till AT '"'                         INTO lv_valid_till str .

   IF "lv_success(1) EQ 'Y'AND
       lv_ewaybill_irn IS NOT INITIAL.
    CLEAR wa_zsdt_ewaybill.
    wa_zsdt_ewaybill-bukrs     = LS_BILLDOC-CompanyCode.
    wa_zsdt_ewaybill-doctyp    = LS_BILLDOC-BillingDocumentType.
    wa_zsdt_ewaybill-docno     = lv_vbeln.

*    i_date = wa_vbrk-fkdat.
*    i_fyv  = 'V3'.
*
*    CALL FUNCTION 'GM_GET_FISCAL_YEAR'
*      EXPORTING
*        i_date = i_date
*        i_fyv  = i_fyv
*      IMPORTING
*        e_fy   = e_fy.
*    IF sy-subrc <> 0.
** Implement suitable error handling here
*    ENDIF.

    wa_zsdt_ewaybill-gjahr = LS_BILLDOC-BillingDocumentDate+0(4).
    wa_zsdt_ewaybill-ebillno = lv_ewaybill_irn."gs_resp_post_topaz-response-ewbno.

    REPLACE ALL OCCURRENCES OF '-' IN lv_EwbDt WITH space.
    CONDENSE lv_EwbDt.
    wa_zsdt_ewaybill-egen_dat = lv_EwbDt(8).

    REPLACE ALL OCCURRENCES OF ':' IN lv_EwbDt WITH space.
    CONDENSE lv_ewbdt.
    wa_zsdt_ewaybill-egen_time = lv_ewbdt+9(6).

    wa_zsdt_ewaybill-vdfmdate = wa_zsdt_ewaybill-egen_dat.
    wa_zsdt_ewaybill-vdfmtime = wa_zsdt_ewaybill-egen_time.

    IF wa_zsdt_ewaybill-egen_dat IS INITIAL.
      wa_zsdt_ewaybill-egen_dat = sy-datlo. "sy-datum.
    ENDIF.
    IF wa_zsdt_ewaybill-egen_time IS INITIAL.
      wa_zsdt_ewaybill-egen_time = sy-timlo. "sy-UZeIT.
    ENDIF.

    REPLACE ALL OCCURRENCES OF '-' IN lv_valid_till WITH space.
    CONDENSE lv_valid_till.

    REPLACE ALL OCCURRENCES OF ':' IN lv_valid_till WITH space.
    CONDENSE lv_valid_till.

   IF lv_valid_till IS NOT INITIAL.
    wa_zsdt_ewaybill-vdtodate  = lv_valid_till(8).
    wa_zsdt_ewaybill-vdtotime  = lv_valid_till+9(6).
   ENDIF.

    wa_zsdt_ewaybill-status = 'P'.
    wa_zsdt_ewaybill-createdby = sy-uname.
    wa_zsdt_ewaybill-createdon = sy-datlo. "sy-datum.
    wa_zsdt_ewaybill-createdat = sy-timlo. "sy-uzeit.

*    wa_zsdt_ewaybill-zzqrcode = gs_resp_post_topaz-response-barcode.

    MODIFY zsdt_ewaybill FROM @wa_zsdt_ewaybill.
    commit work.
    CLEAR wa_zsdt_ewaybill.
   endif.


      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
        DATA(LVTXT) = lx_exception->get_text( ).
        LV_RESPONSE = LVTXT.
    ENDTRY.

  ENDMETHOD.


  METHOD generate_eway.

*  if sy-sysid = 'ZJM' or sy-sysid = 'ZXP'.
*   lv_gstin = '27AAFCD5862R013'. "  "'27AAFCN2297L1ZY'.
*  else.
*      SELECT SINGLE * FROM i_businessplace WITH PRIVILEGED ACCESS
*         WHERE companycode = @wa_vbrk-companycode
*         AND   BusinessPlace = '1000'
*       INTO @DATA(wa_j_1bbranch).
*
*      lv_gstin = wa_j_1bbranch-taxnumber1.
    lv_gstin = '27AAFCN2297L1ZY'.
*  endif.

    lv_vbeln = IM_VBELN. "'B910000005'. "'0090000007'.
    IV_GSTIN_TR = IM_GSTIN.
    IV_NAME_TR = IM_NAME.
    IV_DISTANCE = IM_DIST.

  SELECT SINGLE * FROM i_billingdocument
      WHERE billingdocument = @lv_vbeln
      INTO @wa_vbrk.

  if sy-subrc = 0.

    select * from zsdt_invrefnum
    WHERE docno = @lv_vbeln
    into TABLE @lt_irn.
    if lt_irn[] is not INITIAL.
     sort lt_irn by docno ASCENDING version DESCENDING.
    endif.

    select * from zsdt_ewaybill
    where  docno = @lv_vbeln
    into TABLE @DATA(lt_eway).
    if lt_eway[] is NOT INITIAL.
     sort lt_eway by docno ASCENDING createdon DESCENDING createdat DESCENDING.
    endif.

   READ TABLE lt_eway INTO data(ls_eway) WITH KEY docno = lv_vbeln.
   if sy-subrc ne 0 or ( sy-subrc = 0 and ls_eway-status = 'C' ).

   READ TABLE lt_irn INTO ls_irn WITH KEY docno = lv_vbeln BINARY SEARCH.
   if ( SY-SUBRC = 0 AND LS_IRN-IRN IS NOT INITIAL AND LS_IRN-IRNSTATUS EQ 'ACT' ).

    CALL METHOD CREATE_EWAY_WITH_IRN.

   ELSEif ( SY-SUBRC NE 0 ). "OR (  SY-SUBRC EQ 0 AND LS_IRN-IRN IS NOT INITIAL AND LS_IRN-IRNSTATUS EQ 'CAN' )).

    CALL METHOD CREATE_EWAY_WITHOUT_IRN.

   ENDIF.
   endif.
   endif.

   EX_RESPONSE = lv_RESPONSE.
   EX_STATUS   = LV_STAT.

  ENDMETHOD.
ENDCLASS.
