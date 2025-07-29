CLASS zcl_cleartax_einvvoice DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA : json TYPE string.
    DATA : it_trans            TYPE STANDARD TABLE OF zsdst_einv,
           wa_tran             TYPE zsdst_einv,
           wa_transaction      TYPE zsdst_transaction,
           wa_trandtls         TYPE  zsdst_trandtls,
           wa_docdtls          TYPE  zsdst_docdtls,
           wa_sellerdtls       TYPE  zsdst_sellerdtls,
           wa_buyerdtls        TYPE  zsdst_buyerdtls,
           wa_dispdtls         TYPE  zsdst_dispdtls,
           wa_shipdtls         TYPE  zsdst_shipdtls,
           itemlist            TYPE  zsdtt_itemlist,
           wa_itemlist         TYPE  zsdst_itemlist,
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
           wa_vbrk        TYPE i_billingdocument,
           lv_acc_ass_grp type I_ProductSalesDelivery-AccountDetnProductGroup.
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
           lv_gstin       TYPE string,
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
          lv_signedinvoice         TYPE string,
          lv_signedqrcode          TYPE string,
          lv_status                TYPE string.

    DATA:  WA_zsdt_invrefnum        TYPE zsdt_invrefnum.

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
    DATA : gv_exp TYPE c.

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
           lv_tot_rndof    TYPE i_billingdocumentbasic-totalnetamount,
           lv_tot_rndof_i  TYPE i_billingdocumentbasic-totalnetamount.

  DATA : LV_STATE_CD(2) TYPE C.

    METHODS: get_data,
      create_json,
      call_api.

    METHODS: GENERATE_IRN
      IMPORTING IM_VBELN    TYPE ZCHAR10
      EXPORTING EX_RESPONSE TYPE STRING
                EX_STATUS   TYPE C.

    METHODS: CANCEL_IRN
      IMPORTING IM_VBELN    TYPE zCHAR10
      EXPORTING EX_RESPONSE TYPE STRING
                EX_STATUS   TYPE C.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CLEARTAX_EINVVOICE IMPLEMENTATION.


  METHOD call_api.

    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_GENERATE_IRN'
                                     service_id     = 'YY1_GENERATEIRN_REST'
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

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>Put ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        lv_RESPONSE = lv_xml_result_str.


*[{"custom_fields":null,"deleted":false,"document_status":"IRN_GENERATED",
*"error_response":null,"errors":null,
*"govt_response":{"Success":"Y","AckNo":122410095653262,"AckDt":"2024-02-05 12:36:00",
*"Irn":"b84c4cba42c0e0c5f73ad5978370da344be058b587653807c4cb613a20730729",
*"SignedInvoice":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1MTNCODIxRUU0NkM3NDlBNjNCODZFMzE4QkY3MTEwOTkyODdEMUYiLCJ4NXQiOiJGUk80SWU1R3gwbW1PNGJqR0w5eEVKa29mUjgiLCJ0eXAiOiJKV1QifQ.eyJkYXRhIjoie1wiQWNrTm9cIjoxMjI0MTAwOTU2NTMyNjIsXCJBY2tEdFwiOlwiMjAyNC0wMi0wNSAxMjozN
"joyN1wiLFwiSXJuXCI6XCJiODRjNGNiYTQyYzBlMGM1ZjczYWQ1OTc4MzcwZGEzNDRiZTA1OGI1ODc2NTM4MDdjNGNiNjEzYTIwNzMwNzI5XCIsXCJWZXJzaW9uXCI6XCIxLjFcIixcIlRyYW5EdGxzXCI6e1wiVGF4U2NoXCI6XCJHU1RcIixcIlN1cFR5cFwiOlwiQjJCXCIsXCJSZWdSZXZcIjpcIk5cIixcIklnc3RPbkludHJhXCI6XC
"JOXCJ9LFwiRG9jRHRsc1wiOntcIlR5cFwiOlwiSU5WXCIsXCJOb1wiOlwiOTAwMDAwMDdcIixcIkR0XCI6XCIyMS8xMi8yMDIzXCJ9LFwiU2VsbGVyRHRsc1wiOntcIkdzdGluXCI6XCIyN0FBRkNENTg2MlIwMTNcIixcIkxnbE5tXCI6XCJOYXR1cmUgRGVsaWdodCBEYWlyeVwiLFwiVHJkTm1cIjpcIk5hdHVyZSBEZWxpZ2h0IERhaXJ
"5XCIsXCJBZGRyMVwiOlwiS2FsYXMgSW5kYXB1clwiLFwiQWRkcjJcIjpcIkthbGFzIEluZGFwdXJcIixcIkxvY1wiOlwiQmFyYW1hdGlcIixcIlBpblwiOjQxMzEwNSxcIlN0Y2RcIjpcIjI3XCJ9LFwiQnV5ZXJEdGxzXCI6e1wiR3N0aW5cIjpcIjI3QUFBQVAwMjY3SDJaTlwiLFwiTGdsTm1cIjpcIkdva3VsIEluZGlhXCIsXCJUcmRO
"bVwiOlwiR29rdWwgSW5kaWFcIixcIlBvc1wiOlwiMjdcIixcIkFkZHIxXCI6XCJBZGRyZXNzXCIsXCJBZGRyMlwiOlwiQWRkcmVzc1wiLFwiTG9jXCI6XCJQVU5FXCIsXCJQaW5cIjo0MDA2MDYsXCJTdGNkXCI6XCIyN1wifSxcIkl0ZW1MaXN0XCI6W3tcIkl0ZW1Ob1wiOjAsXCJTbE5vXCI6XCIwMDAwMVwiLFwiSXNTZXJ2Y1wiOlwiT
"lwiLFwiUHJkRGVzY1wiOlwiMDAwMDAwMDAwMDAwMDAwMDI2XCIsXCJIc25DZFwiOlwiODgwMjYwMDBcIixcIkJhcmNkZVwiOlwiMDAwMDAwMDAwMDAwMDAwMDI2XCIsXCJRdHlcIjoxMi4wLFwiRnJlZVF0eVwiOjAuMCxcIlVuaXRcIjpcIktHU1wiLFwiVW5pdFByaWNlXCI6MTAwLjAsXCJUb3RBbXRcIjoxMDAuMDAsXCJEaXNjb3VudF
"wiOjAuMDAsXCJQcmVUYXhWYWxcIjowLjAwLFwiQXNzQW10XCI6MTAwLjAwLFwiR3N0UnRcIjo1LjAwMCxcIklnc3RBbXRcIjowLjAwLFwiQ2dzdEFtdFwiOjIuNTAsXCJTZ3N0QW10XCI6Mi41MCxcIkNlc1J0XCI6MC4wMDAsXCJDZXNBbXRcIjowLjAwLFwiU3RhdGVDZXNSdFwiOjAuMDAwLFwiU3RhdGVDZXNBbXRcIjowLjAwLFwiU3R
"hdGVDZXNOb25BZHZsQW10XCI6MC4wMCxcIk90aENocmdcIjowLjAwLFwiVG90SXRlbVZhbFwiOjEwNS4wMCxcIkJjaER0bHNcIjp7XCJObVwiOlwiMDAwMDAwMDAxN1wifSxcIkF0dHJpYkR0bHNcIjpbXX1dLFwiVmFsRHRsc1wiOntcIkFzc1ZhbFwiOjEwMC4wMCxcIkNnc3RWYWxcIjoyLjUwLFwiU2dzdFZhbFwiOjIuNTAsXCJJZ3N0
"VmFsXCI6MC4wMCxcIkNlc1ZhbFwiOjAuMDAsXCJTdENlc1ZhbFwiOjAuMDAsXCJEaXNjb3VudFwiOjAuMDAsXCJPdGhDaHJnXCI6MC4wMCxcIlJuZE9mZkFtdFwiOjAuMDAsXCJUb3RJbnZWYWxcIjoxMDUuMDAsXCJUb3RJbnZWYWxGY1wiOjAuMDB9LFwiUGF5RHRsc1wiOntcIlBheVRlcm1cIjpcIjAwMDFcIixcIkNyRGF5XCI6MSxcI
"lBheW10RHVlXCI6MC4wMH0sXCJSZWZEdGxzXCI6e1wiSW52Um1cIjpcIlJlZlwiLFwiRG9jUGVyZER0bHNcIjp7XCJJbnZTdER0XCI6XCIyMS8xMi8yMDIzXCIsXCJJbnZFbmREdFwiOlwiMjEvMTIvMjAyM1wifSxcIkNvbnRyRHRsc1wiOltdfX0iLCJpc3MiOiJOSUMgU2FuZGJveCJ9.ItiUy_A4-xs_ES2dkOu9qCNSs25kEcSSRTifb
"h2NPJQoz5_IQr7YJkZYhVlB4acMDDgPKvRvVs-R_0lY4yeyb7-v-YLBc1ra_fnt3aZmLoZmr6uFc5i8TLKdmtfhonzcU67Q5hvfkFOY7tMexaMKo1vusnfDBLH8wNZFsEp8G8eVrwWvcSTN95HXojdMVgPBQ4oXWnd3GoJy7eVINIvRbkoyJxbVjh8_R2WXuMj3-x675qRJpIq36xobWjqiSvi4avTJem3J6wfSL58IynUxP_mrdz0eL_w3d1
"TZEEYHZ2DiMh8D1BI6qXq1a3ycHy-NPuV1uH0RQgBrHpZufwEikw",
*"SignedQRCode":"eyJhbGciOiJSUzI1NiIsImtpZCI6IjE1MTNCODIxRUU0NkM3NDlBNjNCODZFMzE4QkY3MTEwOTkyODdEMUYiLCJ4NXQiOiJGUk80SWU1R3gwbW1PNGJqR0w5eEVKa29mUjgiLCJ0eXAiOiJKV1QifQ.eyJkYXRhIjoie1wiU2VsbGVyR3N0aW5cIjpcIjI3QUFGQ0Q1ODYyUjAxM1wiLFwiQnV5ZXJHc3RpblwiOlwiMj
"dBQUFBUDAyNjdIMlpOXCIsXCJEb2NOb1wiOlwiOTAwMDAwMDdcIixcIkRvY1R5cFwiOlwiSU5WXCIsXCJEb2NEdFwiOlwiMjEvMTIvMjAyM1wiLFwiVG90SW52VmFsXCI6MTA1LjAwLFwiSXRlbUNudFwiOjEsXCJNYWluSHNuQ29kZVwiOlwiODgwMjYwMDBcIixcIklyblwiOlwiYjg0YzRjYmE0MmMwZTBjNWY3M2FkNTk3ODM3MGRhMzQ
"0YmUwNThiNTg3NjUzODA3YzRjYjYxM2EyMDczMDcyOVwiLFwiSXJuRHRcIjpcIjIwMjQtMDItMDUgMTI6MzY6MjdcIn0iLCJpc3MiOiJOSUMgU2FuZGJveCJ9.2qkLuPWQli7MDxiPZJX8xaHBIJXfzMdPKO5OLQvkxJtuYsnQvNOanSOnm1nUxeAymxvoscmEO8OdmSL6ndglAiTL30qHc4nWlxxz4OVcCakO7FUq32ERBuL6xb_KVfZyKel
"1VOgR_GKCzPh7J6Q7Z12onae88mQ3c3d6qapbhZHeGC9Y8y1p87TfQgSQ9CZdm0Bgu4PRD_OJuzI_hHwzn5uRijJiQWrmkH96FCsf4qdsbZT3mNt7XQcxjJouMdAiZ4itjQIYKn0jzEGIHtSMiDXt596Vd4HnyAgUavNGvnXoyf-2QxbZjsJrtU-hkl1_Egvk8cvDiXA_8hot1WSZIg",
*"Status":"ACT","info":[{"InfCd":"DUPIRN_CLEARTAX","Desc":"Duplicate IRN; The IRN is already generated & available for this document with ClearTax. We have shared the details in the response payload"}]},
*"group_id":null,"gstin":"27AAFCD5862R013","is_deleted":false,"owner_id":null,"tag_identifier":null,
*"transaction":{"Version":"1.01","TranDtls":{"TaxSch":"GST","RegRev":"N","SupTyp":"B2B","IgstOnIntra":"N"},"DocDtls":{"Typ":"INV","No":"90000007","Dt":"21/12/2023"},"SellerDtls":{"Gstin":"27AAFCD5862R013","LglNm":"Nature Delight Dairy","TrdNm":"Nature De
"light Dairy","Addr1":"Kalas Indapur","Addr2":"Kalas Indapur","Loc":"Baramati","Pin":413105,"Stcd":"27"},"BuyerDtls":{"Gstin":"27AAAAP0267H2ZN","LglNm":"Gokul India","TrdNm":"Gokul India","Pos":"27","Addr1":"Address","Addr2":"Address","Loc":"PUNE","Pin":
"400606,"Stcd":"27"},"DispDtls":{"Nm":"Nature Delight Dairy","Addr1":"Kalas Indapur","Addr2":"Kalas Indapur","Loc":"Baramati","Pin":413105,"Stcd":"27"},"ShipDtls":{"Gstin":"27AAAAP0267H2ZN","LglNm":"Gokul India","TrdNm":"Gokul India","Addr1":"Address","A
"ddr2":"Address","Loc":"PUNE","Pin":400606,"Stcd":"27"},"ItemList":[{"SlNo":"00001","PrdDesc":"000000000000000026","IsServc":"N","HsnCd":"88026000","Barcde":"000000000000000026","Qty":12.000,"FreeQty":0.000,"Unit":"KG","UnitPrice":100.000,"TotAmt":100.00
","Discount":0.00,"PreTaxVal":0.00,"AssAmt":100.00,"GstRt":5.00,"IgstAmt":0.00,"CgstAmt":2.50,"SgstAmt":2.50,"CesRt":0.00,"CesAmt":0.00,"StateCesRt":0.00,"StateCesAmt":0.00,"StateCesNonAdvlAmt":0.00,"OthChrg":0.00,"TotItemVal":105.00,"BchDtls":{"Nm":"000
"0000017"},"AttribDtls":[]}],"ValDtls":{"AssVal":100.00,"CgstVal":2.50,"SgstVal":2.50,"IgstVal":0.00,"CesVal":0.00,"StCesVal":0.00,"Discount":0.00,"OthChrg":0.00,"RndOffAmt":0.00,"TotInvVal":105.00,"TotInvValFc":0.00},"PayDtls":{"PayTerm":"0001","CrDay":
"1,"PaymtDue":0.00},"RefDtls":{"InvRm":"Ref","DocPerdDtls":{"InvStDt":"21/12/2023","InvEndDt":"21/12/2023"},"PrecDocDtls":[],"ContrDtls":[]},"AddlDocDtls":[],"ExpDtls":{"ExpDuty":0.000},"EwbDtls":{"Distance":0}},"transaction_id":"27AAFCD5862R013_90000007
"_INV_2023","transaction_metadata":null}]

     "Capture Log

    SELECT SINGLE FROM I_BillingDocument
    FIELDS CompanyCode, BillingDocumentDate, BillingDocumentType
    WHERE BillingDocument = @lv_vbeln
    INTO @DATA(LS_BILLDOC).

   clear: wa_ztsd_ei_log.
   wa_ztsd_ei_log-bukrs    = LS_BILLDOC-CompanyCode.
   wa_ztsd_ei_log-docno    = lv_vbeln.
   wa_ztsd_ei_log-doc_year = LS_BILLDOC-BillingDocumentDate+0(4).
   wa_ztsd_ei_log-doc_type = LS_BILLDOC-BillingDocumentType.
   wa_ztsd_ei_log-method   = 'GENERATE_IRN'.
   wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
   wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
   wa_ztsd_ei_log-message  = lv_xml_result_str.
   modify ztsd_ei_log from @wa_ztsd_ei_log.
   COMMIT work.

      "CAPTURE RESPONSE
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

  SPLIT lv_xml_result_str AT '"SignedInvoice":"'     INTO str lv_SignedInvoice.
  SPLIT lv_SignedInvoice  AT '"'                     INTO lv_SignedInvoice str .

  SPLIT lv_xml_result_str AT '"SignedQRCode":"'      INTO str lv_SignedQRCode.
  SPLIT lv_SignedQRCode AT '"'                       INTO lv_SignedQRCode str .

  SPLIT lv_xml_result_str AT '"Status":"'            INTO str lv_status.


  IF lv_success EQ 'Y' ."AND ( lv_irn IS NOT INITIAL OR lv_SignedQRCode IS NOT INITIAL )." AND lv_compid is NOT INITIAL.
    DATA : lv_count TYPE i.
    CLEAR wa_zsdt_invrefnum.

    SELECT COUNT( docno )  FROM zsdt_invrefnum
     WHERE docno      = @lv_vbeln
     INTO @DATA(lv_count_1).

*    CLEAR : lv_count. ", i_date, i_fyv, e_fy.
*    lv_count = lines( it_zsdt_invrefnum ).

    lv_count = lv_count_1 + 1.

    wa_zsdt_invrefnum-bukrs      = LS_BILLDOC-CompanyCode.
    wa_zsdt_invrefnum-docno      = lv_vbeln.

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

    wa_zsdt_invrefnum-docyear    = LS_BILLDOC-BillingDocumentDate+0(4). "e_fy.
    wa_zsdt_invrefnum-doctype   = LS_BILLDOC-BillingDocumentType.
*    wa_zsdt_invrefnum-odn        = wa_vbrk-xblnr.
    wa_zsdt_invrefnum-odndate   = LS_BILLDOC-BillingDocumentDate.
    wa_zsdt_invrefnum-irn        = lv_irn(64).
    wa_zsdt_invrefnum-version    = lv_count.
*    wa_zsdt_invrefnum-bupla      = wa_vbrk-bupla.
    wa_zsdt_invrefnum-ackno     = lv_ackno.
    wa_zsdt_invrefnum-ackdate   = lv_ackdt.
    wa_zsdt_invrefnum-irnstatus = 'ACT'. "GS_RESP_POST-RESPONSE-STATUS.
*  WA_J_1IG_INVREFNUM-CANCEL_DATE
    wa_zsdt_invrefnum-ernam      = sy-uname.
    wa_zsdt_invrefnum-erdat      = sy-datlo. "sy-datum.
    wa_zsdt_invrefnum-erzet      = sy-timlo. "sy-uzeit.
    wa_zsdt_invrefnum-signedinv = lv_signedinvoice.
    wa_zsdt_invrefnum-signedqrcode = lv_signedqrcode.

*    MODIFY j_1ig_invrefnum FROM @wa_j_1ig_invrefnum.
    MODIFY zsdt_invrefnum FROM @wa_zsdt_invrefnum.
    COMMIT WORK.

*read ENTITY I_IN_InvcRefNmbrDet ALL FIELDS WITH VALUE #( ( docno = lv_vbeln ) )
*       RESULT FINAL(billingheader)
*       FAILED FINAL(failed_data1).
*
*
*select * from I_IN_InvcRefNmbrDet into TABLE @data(lt_data).

    LV_STAT = 'S'.
  ELSE.
    LV_STAT = 'E'.
  ENDIF.


      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
        DATA(LVTXT) = lx_exception->get_text( ).
        LV_RESPONSE = LVTXT.
    ENDTRY.


  ENDMETHOD.


  METHOD cancel_irn.

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

  SELECT SINGLE * FROM i_billingdocument
      WHERE billingdocument = @lv_vbeln
*      AND   BillingDocumentIsCancelled = 'X'
      INTO @wa_vbrk.
  if sy-subrc = 0.

    select * from zsdt_invrefnum
    WHERE docno = @lv_vbeln
    into TABLE @DATA(lt_irn).
    if lt_irn[] is not INITIAL.
     sort lt_irn by docno ASCENDING version DESCENDING.
    endif.

   READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = lv_vbeln BINARY SEARCH.
   if sy-subrc = 0 AND LS_IRN-IRN IS NOT INITIAL. "AND LS_IRN-IRNSTATUS NE 'CAN'.

     CONCATENATE  '[{"irn": "' LS_IRN-IRN '","CnlRsn": "2","CnlRem": "Wrong"}]'
     INTO JSON.

    " Create HTTP client
    TRY.
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_CANCEL_IRN'
                                     service_id     = 'YY1_CANCELIRN_REST'
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

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>Put ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        lv_RESPONSE = lv_xml_result_str.

     "Capture Log

    SELECT SINGLE FROM I_BillingDocument
    FIELDS CompanyCode, BillingDocumentDate, BillingDocumentType
    WHERE BillingDocument = @lv_vbeln
    INTO @DATA(LS_BILLDOC).

   clear: wa_ztsd_ei_log.
   wa_ztsd_ei_log-bukrs    = LS_BILLDOC-CompanyCode.
   wa_ztsd_ei_log-docno    = lv_vbeln.
   wa_ztsd_ei_log-doc_year = LS_BILLDOC-BillingDocumentDate+0(4).
   wa_ztsd_ei_log-doc_type = LS_BILLDOC-BillingDocumentType.
   wa_ztsd_ei_log-method   = 'CANCEL_IRN'.
   wa_ztsd_ei_log-erdat    = sy-datlo. "sy-datum.
   wa_ztsd_ei_log-uzeit    = sy-timlo. "sy-uzeit.
   wa_ztsd_ei_log-message  = lv_xml_result_str.
   modify ztsd_ei_log from @wa_ztsd_ei_log.
   COMMIT work.

      "CAPTURE RESPONSE
  DATA : str TYPE string.
  CLEAR lv_success.
  SPLIT lv_xml_result_str AT '"document_status":"'   INTO str lv_doc_status.
  SPLIT lv_xml_result_str AT '"error_response":'     INTO str lv_error_response.
  SPLIT lv_xml_result_str AT '"govt_response":'      INTO str lv_govt_response.
  SPLIT lv_xml_result_str AT '"Success":"'           INTO str lv_success.


  SPLIT lv_xml_result_str AT '"AckNo":'              INTO str lv_AckNo.
  SPLIT lv_AckNo AT ','                              INTO lv_AckNo str .

  SPLIT lv_xml_result_str AT '"AckDt":"'             INTO str lv_AckDt.

  SPLIT lv_xml_result_str AT '"Irn":"'               INTO str lv_Irn.
  SPLIT lv_irn AT '"'                                INTO lv_Irn str.

  SPLIT lv_xml_result_str AT '"SignedInvoice":"'     INTO str lv_SignedInvoice.
  SPLIT lv_SignedInvoice  AT '"'                     INTO lv_SignedInvoice str .

  SPLIT lv_xml_result_str AT '"SignedQRCode":"'      INTO str lv_SignedQRCode.
  SPLIT lv_SignedQRCode AT '"'                       INTO lv_SignedQRCode str .

  SPLIT lv_xml_result_str AT '"status":"'            INTO str lv_status.


  IF lv_success = 'Y'.
    ls_irn-irnstatus = 'CAN'.
    ls_irn-canceldate = lv_AckDt."gs_resp_canc_inr-response-canceldate.
    MODIFY zsdt_invrefnum FROM @ls_irn.
    COMMIT WORK.


    LV_STAT = 'S'.
  ELSE.
    LV_STAT = 'E'.
  ENDIF.

      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
        DATA(LVTXT) = lx_exception->get_text( ).
        LV_RESPONSE = LVTXT.
    ENDTRY.



   ENDIF.

   endif.

   EX_RESPONSE = lv_RESPONSE.
   EX_STATUS   = LV_STAT.

  ENDMETHOD.


  METHOD create_json.

    IF it_trans IS NOT INITIAL.
      DATA : lt_mapping  TYPE /ui2/cl_json=>name_mappings.
      lt_mapping = VALUE #(
                        ( abap = 'VERSION' json = 'Version' )
                        ( abap = 'IRN' json = 'Irn' )
                        ( abap = 'TRANDTLS' json = 'TranDtls' )
                        ( abap = 'DOCDTLS' json = 'DocDtls' )
                        ( abap = 'SELLERDTLS' json = 'SellerDtls' )
                        ( abap = 'BUYERDTLS' json = 'BuyerDtls' )
                        ( abap = 'DISPDTLS' json = 'DispDtls' )
                        ( abap = 'SHIPDTLS' json = 'ShipDtls' )
                        ( abap = 'ITEMLIST' json = 'ItemList' )
                        ( abap = 'VALDTLS' json = 'ValDtls' )
                        ( abap = 'PAYDTLS' json = 'PayDtls' )
                        ( abap = 'REFDTLS' json = 'RefDtls' )
                        ( abap = 'ADDLDOCDTLS' json = 'AddlDocDtls' )
                        ( abap = 'EXPDTLS' json = 'ExpDtls' )
                        ( abap = 'EWBDTLS' json = 'EwbDtls' )
                        ( abap = 'TAXSCH' json = 'TaxSch' )
                        ( abap = 'SUPTYP' json = 'SupTyp' )
                        ( abap = 'REGREV' json = 'RegRev' )
                        ( abap = 'ECMGSTIN' json = 'EcmGstin' )
                        ( abap = 'IGSTONINTRA' json = 'IgstOnIntra' )
                        ( abap = 'TYP' json = 'Typ' )
                        ( abap = 'NO' json = 'No' )
                        ( abap = 'DT' json = 'Dt' )
                        ( abap = 'GSTIN' json = 'Gstin' )
                        ( abap = 'LGLNM' json = 'LglNm' )
                        ( abap = 'TRDNM' json = 'TrdNm' )
                        ( abap = 'ADDR1' json = 'Addr1' )
                        ( abap = 'ADDR2' json = 'Addr2' )
                        ( abap = 'LOC' json = 'Loc' )
                        ( abap = 'PIN' json = 'Pin' )
                        ( abap = 'STCD' json = 'Stcd' )
                        ( abap = 'PH' json = 'Ph' )
                        ( abap = 'EM' json = 'Em' )
                        ( abap = 'POS' json = 'Pos' )
                        ( abap = 'NM' json = 'Nm' )
                        ( abap = 'SLNO' json = 'SlNo' )
                        ( abap = 'PRDDESC' json = 'PrdDesc' )
                        ( abap = 'ISSERVC' json = 'IsServc' )
                        ( abap = 'HSNCD' json = 'HsnCd' )
                        ( abap = 'BARCDE' json = 'Barcde' )
                        ( abap = 'QTY' json = 'Qty' )
                        ( abap = 'FREEQTY' json = 'FreeQty' )
                        ( abap = 'UNIT' json = 'Unit' )
                        ( abap = 'UNITPRICE' json = 'UnitPrice' )
                        ( abap = 'TOTAMT' json = 'TotAmt' )
*                    ( abap = 'DISCOUNT' json = 'Discount' )
                        ( abap = 'PRETAXVAL' json = 'PreTaxVal' )
                        ( abap = 'ASSAMT' json = 'AssAmt' )
                        ( abap = 'GSTRT' json = 'GstRt' )
                        ( abap = 'IGSTAMT' json = 'IgstAmt' )
                        ( abap = 'CGSTAMT' json = 'CgstAmt' )
                        ( abap = 'SGSTAMT' json = 'SgstAmt' )
                        ( abap = 'CESRT' json = 'CesRt' )
                        ( abap = 'CESAMT' json = 'CesAmt' )
                        ( abap = 'CESNONADVLAMT' json = 'CesNonAdvlAmt' )
                        ( abap = 'STATECESRT' json = 'StateCesRt' )
                        ( abap = 'STATECESAMT' json = 'StateCesAmt' )
                        ( abap = 'STATECESNONADVLAMT' json = 'StateCesNonAdvlAmt' )
*                    ( abap = 'OTHCHRG' json = 'OthChrg' )
                        ( abap = 'TOTITEMVAL' json = 'TotItemVal' )
                        ( abap = 'ORDLINEREF' json = 'OrdLineRef' )
                        ( abap = 'ORGCNTRY' json = 'OrgCntry' )
                        ( abap = 'PRDSLNO' json = 'PrdSlNo' )
                        ( abap = 'BCHDTLS' json = 'BchDtls' )
                        ( abap = 'ATTRIBDTLS' json = 'AttribDtls' )
*                    ( abap = 'NM' json = 'Nm' )
                        ( abap = 'EXPDT' json = 'ExpDt' )
                        ( abap = 'WRDT' json = 'WrDt' )
*                    ( abap = 'NM' json = 'Nm' )
                        ( abap = 'VAL' json = 'Val' )
                        ( abap = 'ASSVAL' json = 'AssVal' )
                        ( abap = 'CGSTVAL' json = 'CgstVal' )
                        ( abap = 'SGSTVAL' json = 'SgstVal' )
                        ( abap = 'IGSTVAL' json = 'IgstVal' )
                        ( abap = 'CESVAL' json = 'CesVal' )
                        ( abap = 'STCESVAL' json = 'StCesVal' )
                        ( abap = 'DISCOUNT' json = 'Discount' )
                        ( abap = 'OTHCHRG' json = 'OthChrg' )
                        ( abap = 'RNDOFFAMT' json = 'RndOffAmt' )
                        ( abap = 'TOTINVVAL' json = 'TotInvVal' )
                        ( abap = 'TOTINVVALFC' json = 'TotInvValFc' )
                        ( abap = 'ACCDET' json = 'AccDet' )
                        ( abap = 'MODE' json = 'Mode' )
                        ( abap = 'FININSBR' json = 'FinInsBr' )
                        ( abap = 'PAYTERM' json = 'PayTerm' )
                        ( abap = 'PAYINSTR' json = 'PayInstr' )
                        ( abap = 'CRTRN' json = 'CrTrn' )
                        ( abap = 'DIRDR' json = 'DirDr' )
                        ( abap = 'CRDAY' json = 'CrDay' )
                        ( abap = 'PAIDAMT' json = 'PaidAmt' )
                        ( abap = 'PAYMTDUE' json = 'PaymtDue' )
                        ( abap = 'INVRM' json = 'InvRm' )
                        ( abap = 'DOCPERDDTLS' json = 'DocPerdDtls' )
                        ( abap = 'PRECDOCDTLS' json = 'PrecDocDtls' )
                        ( abap = 'CONTRDTLS' json = 'ContrDtls' )
                        ( abap = 'INVSTDT' json = 'InvStDt' )
                        ( abap = 'INVENDDT' json = 'InvEndDt' )
                        ( abap = 'INVNO' json = 'InvNo' )
                        ( abap = 'INVDT' json = 'InvDt' )
                        ( abap = 'OTHREFNO' json = 'OthRefNo' )
                        ( abap = 'RECADVREF' json = 'RecAdvRef' )
                        ( abap = 'RECADVDT' json = 'RecAdvDt' )
                        ( abap = 'TENDREFR' json = 'TendRefr' )
                        ( abap = 'CONTRREFR' json = 'ContrRefr' )
                        ( abap = 'EXTREFR' json = 'ExtRefr' )
                        ( abap = 'PROJREFR' json = 'ProjRefr' )
                        ( abap = 'POREFR' json = 'PORefr' )
                        ( abap = 'POREFDT' json = 'PORefDt' )
                        ( abap = 'URL' json = 'Url' )
                        ( abap = 'DOCS' json = 'Docs' )
                        ( abap = 'INFO' json = 'Info' )
                        ( abap = 'SHIPBNO' json = 'ShipBNo' )
                        ( abap = 'SHIPBDT' json = 'ShipBDt' )
                        ( abap = 'PORT' json = 'Port' )
                        ( abap = 'REFCLM' json = 'RefClm' )
                        ( abap = 'FORCUR' json = 'ForCur' )
                        ( abap = 'CNTCODE' json = 'CntCode' )
                        ( abap = 'EXPDUTY' json = 'ExpDuty' )
                        ( abap = 'TRANSID' json = 'TransId' )
                        ( abap = 'TRANSNAME' json = 'TransName' )
                        ( abap = 'TRANSMODE' json = 'TransMode' )
                        ( abap = 'DISTANCE' json = 'Distance' )
                        ( abap = 'TRANSDOCNO' json = 'TransDocNo' )
                        ( abap = 'TRANSDOCDT' json = 'TransDocDt' )
                        ( abap = 'VEHNO' json = 'VehNo' )
                        ( abap = 'VEHTYPE' json = 'VehType' )
                        ).


      READ TABLE it_trans INTO wa_tran INDEX 1.
      DATA(lv_json) = /ui2/cl_json=>serialize( data      = wa_tran-transaction
                                           compress      = abap_false
                                           pretty_name   = /ui2/cl_json=>pretty_mode-camel_case
                                           name_mappings = lt_mapping ).

      IF gv_disp = 'X'.
*   REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""}'
*   IN LV_JSON WITH '"DispDtls": []'.
        REPLACE ALL OCCURRENCES OF '"DispDtls":{"Nm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""},'
        IN lv_json WITH ' '.
      ENDIF.


*  REPLACE ALL OCCURRENCES OF '"BchDtls":{"Nm":null,"ExpDt":null,"WrDt":null},' IN lv_json WITH ' '.
      REPLACE ALL OCCURRENCES OF '"BchDtls":{"Nm":"","ExpDt":"","WrDt":""},' IN lv_json WITH ' '.


      IF gv_ship = 'X'.

        REPLACE ALL OCCURRENCES OF '"ShipDtls":{"Gstin":"","LglNm":"","TrdNm":"","Addr1":"","Addr2":"","Loc":"","Pin":0,"Stcd":""},'
        IN lv_json WITH ''.
      ENDIF.

*  SHIFT lv_json LEFT DELETING LEADING '['.
*  SHIFT lv_json RIGHT DELETING TRAILING ']'.

      REPLACE ALL OCCURRENCES OF '""' IN lv_json WITH 'null'.
***  REPLACE ALL OCCURRENCES OF ':0*' IN lv_json WITH ':null*'.
***  REPLACE ALL OCCURRENCES OF '":0,' IN lv_json WITH '":null,'.
***  REPLACE ALL OCCURRENCES OF '":"0.00",' IN lv_json WITH '":null,'.
      REPLACE ALL OCCURRENCES OF '"Distance":null' IN lv_json WITH '"Distance":0'.
      REPLACE ALL OCCURRENCES OF '"Distance":"1"' IN lv_json WITH '"Distance":null'.
      REPLACE ALL OCCURRENCES OF '"Ph":0' IN lv_json WITH '"Ph":null'.


      IF wa_tran-transaction-trandtls-suptyp  = 'EXPWOP' OR wa_tran-transaction-trandtls-suptyp  = 'SEZWOP'.
        REPLACE ALL OCCURRENCES OF '"irt":null' IN lv_json WITH '"irt":"0.00"'.
      ENDIF.

   CONCATENATE '[{"transaction": ' lv_json '}]' into lv_json.

      json = lv_json.
    ENDIF.

  ENDMETHOD.


  METHOD generate_irn.
*   IM_VBELN

    lv_vbeln = IM_VBELN. "'B910000005'. "'0090000007'.

  SELECT SINGLE * FROM i_billingdocument
      WHERE billingdocument = @lv_vbeln
*      AND (  accountingtransferstatus  = 'C'
*              OR accountingtransferstatus  = 'D'
*              OR accountingtransferstatus  = 'E' )
      INTO @wa_vbrk.

  if sy-subrc = 0.

    select * from zsdt_invrefnum
    WHERE docno = @lv_vbeln
    into TABLE @DATA(lt_irn).
    if lt_irn[] is not INITIAL.
     sort lt_irn by docno ASCENDING version DESCENDING.
    endif.

   READ TABLE lt_irn INTO DATA(ls_irn) WITH KEY docno = lv_vbeln BINARY SEARCH.
   if sy-subrc NE 0 OR ( SY-SUBRC = 0 AND LS_IRN-IRN IS NOT INITIAL
                     AND LS_IRN-IRNSTATUS EQ 'CAN' ).

    CALL METHOD get_data.
    CALL METHOD create_json.
    CALL METHOD call_api.

   ENDIF.
   endif.

   EX_RESPONSE = lv_RESPONSE.
   EX_STATUS   = LV_STAT.
  ENDMETHOD.


  METHOD get_data.

       CLEAR lv_cancel.

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

    READ ENTITY i_billingdocumenttp
      ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
       RESULT FINAL(billingheader)
       FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
  ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
   RESULT FINAL(billingdata)
   FAILED FINAL(failed_data).


    SELECT billingdocument, billingdocumentitem, conditiontype,
           conditionrateamount, conditionamount, CONDITIONRATEVALUE
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

*    SELECT partnerfunction, customer FROM i_salesorderpartner
*    FOR ALL ENTRIES IN @billingdata
*      WHERE salesorder = @billingdata-salesdocument
*      INTO TABLE @DATA(it_vbpa).

    SELECT partnerfunction, customer FROM i_salesorderpartner "I_SALESORDERITEMPARTNER
    FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
*      AND   SalesOrderItem = @billingdata-SalesDocumentItem
      INTO TABLE @DATA(it_vbpa).

      SELECT partnerfunction, customer FROM I_CreditMemoReqPartner
        FOR ALL ENTRIES IN @billingdata
        WHERE CreditMemoRequest = @billingdata-referencesddocument
        INTO TABLE @DATA(it_vbpa_cr).

    CLEAR : it_trans[], itemlist[], addldocdtls[].
    CLEAR : wa_transaction, wa_trandtls, wa_docdtls, wa_sellerdtls, wa_buyerdtls, wa_dispdtls,wa_shipdtls,
            wa_itemlist, wa_valdtls, wa_paydtls, wa_refdtls, wa_addldocdtls, wa_expdtls, wa_ewbdtls.

    DATA : lv_werks TYPE i_plant-plant.
    READ TABLE billingdata INTO DATA(wa_data) INDEX 1.
    IF sy-subrc = 0.

      READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data-billingdocument.
      lv_werks = wa_data-plant.

      SELECT SINGLE
        plant,
        plantname, AddressID
*       \_address-addressid,
*       \_address-addressuuid,
*       \_address-careofname,
*       \_address-additionalstreetsuffixname,
*       \_address-correspondencelanguage,
*       \_address-prfrdcommmediumtype,
*       \_address-pobox,
*       \_address-poboxiswithoutnumber,
*       \_address-poboxpostalcode,
*       \_address-poboxlobbyname,
*       \_address-poboxdeviatingcityname,
*       \_address-poboxdeviatingregion,
*       \_address-poboxdeviatingcountry,
*       \_address-deliveryservicetypecode,
*       \_address-deliveryservicenumber,
*       \_address-addresstimezone,
*       \_address-cityfileteststatus,
*       \_address-addressstreetunusable,
*       \_address-addresspostboxunusable,
*       \_address-fullname,
*       \_address-cityname,
*       \_address-district,
*       \_address-citycode,
*       \_address-homecityname,
*       \_address-postalcode,
*       \_address-companypostalcode,
*       \_address-streetname,
*       \_address-streetprefixname,
*       \_address-additionalstreetprefixname,
*       \_address-streetsuffixname,
*       \_address-housenumber,
*       \_address-housenumbersupplementtext,
*       \_address-building,
*       \_address-floor,
*       \_address-roomnumber,
*       \_address-country,
*       \_address-region,
*       \_address-county,
*       \_address-countycode,
*       \_address-townshipcode,
*       \_address-townshipname,
*       \_address-formofaddress,
*       \_address-businesspartnername1,
*       \_address-businesspartnername2,
*       \_address-nation,
*       \_address-phonenumber,
*       \_address-faxnumber,
*       \_address-searchterm1,
*       \_address-searchterm2,
*       \_address-streetsearch,
*       \_address-citysearch,
*       \_address-businesspartnername3,
*       \_address-businesspartnername4,
*       \_address-taxjurisdiction,
*       \_address-transportzone,
*       \_address-addresscitypostboxcode,
*       \_address-person
       FROM i_plant
        WHERE plant = @lv_werks
        INTO @DATA(wa_t001w).

*        cl_address_format=>get_instance( )->printform_postal_addr(
*        EXPORTING
**         iv_address_type = '1'
*        iv_address_number = wa_t001w-addressid
**         iv_person_number =
*        iv_language_of_country_field = 'E'
**         iv_number_of_lines = 99
**         iv_sender_country = space
*        IMPORTING
*        ev_formatted_to_one_line = DATA(one_line)
*        et_formatted_all_lines = DATA(all_lines)
*        ).


      wa_transaction-version = '1.01'.

      "TranDtls
*--------------------------------------------------------------------*
      wa_trandtls-taxsch       = 'GST'.

      wa_trandtls-regrev       = 'N'.
*WA_TRANDTLS-ECMGSTIN     =
      wa_trandtls-igstonintra  = 'N'.
*--------------------------------------------------------------------*

      "DOCDTLS
*--------------------------------------------------------------------*

  CASE wa_vbrk-billingdocumenttype.
    WHEN 'F2'.
      wa_docdtls-typ           = 'INV'.
      wa_trandtls-suptyp       = 'B2B'.
    WHEN 'G2'.
      wa_docdtls-typ           = 'CRN'.
      wa_trandtls-suptyp       = 'B2B'.
    WHEN 'L2'.
      wa_docdtls-typ           = 'DBN'.
      wa_trandtls-suptyp       = 'B2B'.
    WHEN OTHERS.
      wa_docdtls-typ           = 'INV'.
      wa_trandtls-suptyp       = 'B2B'.
  ENDCASE.

      wa_docdtls-no            = lv_vbeln. "wa_vbrk-xblnr.
      SHIFT wa_docdtls-no LEFT DELETING LEADING '0'.

      CONCATENATE wa_head-billingdocumentdate+6(2) wa_head-billingdocumentdate+4(2)
                  wa_head-billingdocumentdate+0(4) INTO wa_docdtls-dt SEPARATED BY '/'.

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


*      CONCATENATE wa_t001w-businesspartnername1 wa_t001w-businesspartnername2 INTO wa_sellerdtls-lglnm SEPARATED BY ''.
*      CONCATENATE wa_t001w-businesspartnername1 wa_t001w-businesspartnername2 INTO wa_sellerdtls-trdnm SEPARATED BY ''.
*      CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_sellerdtls-addr1 SEPARATED BY ''.
*      CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_sellerdtls-addr2 SEPARATED BY ''.
*
*      wa_sellerdtls-loc  = wa_t001w-cityname.
*      wa_sellerdtls-pin  = wa_t001w-postalcode.
*      wa_sellerdtls-stcd = wa_t001w-region.
*--------------------------------------------------------------------*
      "BUYERDTLS
      READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH  KEY partnerfunction = 'AG'.  ""Sold to party
      IF sy-subrc = 0.
        lv_soldtoparty = wa_vbpa-customer.
      ENDIF.
      READ TABLE it_vbpa_cr INTO DATA(wa_vbpa_cr) WITH  KEY partnerfunction = 'AG'.  ""Sold to party
      IF sy-subrc = 0.
        lv_soldtoparty = wa_vbpa_cr-customer.
      ENDIF.

      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'RE'.  ""Buyer
      IF sy-subrc = 0.
        lv_buyer = wa_vbpa-customer.
      ELSE.
        lv_buyer = lv_soldtoparty.
      ENDIF.

      READ TABLE it_vbpa_cr INTO wa_vbpa_cr WITH  KEY partnerfunction = 'RE'.  ""Buyer
      IF sy-subrc = 0.
        lv_buyer = wa_vbpa_cr-customer.
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
      wa_buyerdtls-ph   = wa_kna1-TelephoneNumber1.
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
       wa_buyerdtls-pos  = LV_STATE_CD.

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
          INTO @DATA(wa_kna1_sh)..
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

      READ TABLE it_vbpa_cr INTO wa_vbpa_cr WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
      IF sy-subrc = 0 AND wa_vbpa_cr-customer NE lv_buyer.
      clear gv_ship.
      SELECT SINGLE
      customer, AddressID, CustomerName, TaxNumber3, Country,
      StreetName, CityName, PostalCode, Region, TelephoneNumber1
       FROM i_customer
        WHERE customer = @wa_vbpa_cr-customer
          INTO @wa_kna1_sh.
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
        SELECT SINGLE conditiontype FROM i_billingdocumentprcgelmnt
          WHERE billingdocument = @wa_data-billingdocument
          AND   conditiontype IN ('JOCG','JOSG','JOIG','ZOIG')
          INTO @DATA(lv_kschl).
        IF sy-subrc = 0.
          wa_trandtls-suptyp   = 'EXPWP'.
        ELSE.
          wa_trandtls-suptyp   = 'EXPWOP'.
        ENDIF.
      ENDIF.

    IF GV_SHIP = ''.
      IF wa_trandtls-suptyp = 'EXPWP' OR wa_trandtls-suptyp = 'EXPWOP'  OR gv_exp = 'X'.
        wa_shipdtls-stcd = '96'.
        wa_shipdtls-pin  = '999999'.
      ENDIF.
    ENDIF.

      IF wa_trandtls-suptyp = 'EXPWP' OR wa_trandtls-suptyp  = 'EXPWOP' OR gv_exp = 'X'.
        wa_buyerdtls-gstin = 'URP'.
        wa_buyerdtls-pos = '96'.
        wa_buyerdtls-stcd = '96'.
        wa_buyerdtls-pin = '999999'.
      ENDIF.

* --------------------------------------------------------------------*

      "DISPDTLS

*      IF wa_t001w-plantname IS NOT INITIAL.
*        wa_dispdtls-nm = wa_t001w-plantname.
*      ELSE.
**      CONCATENATE wa_adrc_disp- wa_adrc_disp-name2 INTO wa_dispdtls-nm SEPARATED BY ''.
*      ENDIF.
*
*      CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_dispdtls-addr1 SEPARATED BY ''.
*      wa_dispdtls-addr2 = wa_dispdtls-addr1.
*
*      wa_dispdtls-loc  = wa_t001w-cityname.
*      wa_dispdtls-pin  = wa_t001w-postalcode.
*      wa_dispdtls-stcd = wa_t001w-region.

*     *--------------------------------------------------------------------*

      "ITEMLIST
      CLEAR : lv_tot_val, lv_tot_disc, lv_tot_freight, lv_tot_ins, lv_tot_roff, lv_tot_asse_val,
           lv_tot_igst, lv_tot_cgst, lv_tot_sgst, lv_tot_other, lv_tot_rndof, lv_tot_rndof_i.


      LOOP AT billingdata INTO DATA(wa_vbrp).

        CLEAR : lv_unit_pr, lv_disc, lv_freight, lv_asse_val, lv_asse_val1, lv_igst, lv_cgst, lv_sgst,
                lv_igst_rt, lv_cgst_rt, lv_sgst_rt, lv_other_ch, lv_ins, lv_tot_rndof_i.

       select single AccountDetnProductGroup from I_ProductSalesDelivery
       where product = @wa_vbrp-product
       and   ProductSalesOrg = @wa_vbrk-SalesOrganization
       and   ProductDistributionChnl = @wa_vbrk-DistributionChannel
       into @lv_acc_ass_grp.

        lv_num = lv_num + 1.

        wa_itemlist-slno        = lv_num.

        CONCATENATE wa_vbrp-product wa_vbrp-BillingDocumentItemText
        into wa_itemlist-prddesc SEPARATED BY '-'.
*        wa_itemlist-prddesc     = wa_vbrp-product.

        if lv_acc_ass_grp = 'Z5' or lv_acc_ass_grp = 'Z7'.
         wa_itemlist-isservc     = 'Y'.
        else.
         wa_itemlist-isservc     = 'N'.
        endif.

        wa_itemlist-qty         = wa_vbrp-billingquantity.

        wa_itemlist-barcde      = wa_vbrp-product.

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
       when 'MON' or 'CV' or 'CS'.
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


        lv_asse_val  = lv_asse_val * wa_head-accountingexchangerate.
        wa_itemlist-unitprice = ( lv_unit_pr  * wa_head-accountingexchangerate ).
        wa_itemlist-totamt    = lv_asse_val. "( lv_unit_pr  * wa_vbrk-AccountingExchangeRate ) * wa_vbrp-fkimg.
        wa_itemlist-discount  = ( lv_disc * wa_head-accountingexchangerate ).
        wa_itemlist-assamt    = lv_asse_val - ( lv_disc * wa_head-accountingexchangerate ).
*WA_ITEMLIST-PRETAXVAL =

        IF lv_igst_rt IS NOT INITIAL.
          wa_itemlist-gstrt     = lv_igst_rt.
        ELSEIF lv_cgst_rt IS NOT INITIAL.
          wa_itemlist-gstrt     = lv_cgst_rt.
        ELSEIF lv_sgst_rt IS NOT INITIAL.
          wa_itemlist-gstrt     = lv_sgst_rt.
        ENDIF.

        IF lv_cgst_rt IS NOT INITIAL AND lv_sgst_rt IS NOT INITIAL.
          wa_itemlist-gstrt = lv_cgst_rt + lv_sgst_rt.
        ENDIF.


        wa_itemlist-igstamt = ( lv_asse_val * lv_igst_rt ) / 100.
        wa_itemlist-cgstamt = ( lv_asse_val * lv_cgst_rt ) / 100.
        wa_itemlist-sgstamt = ( lv_asse_val * lv_sgst_rt ) / 100.

        lv_other_ch = lv_other_ch + lv_freight + lv_ins.
        lv_other_ch = lv_other_ch * wa_head-accountingexchangerate.

        wa_itemlist-totitemval = wa_itemlist-assamt + wa_itemlist-igstamt + wa_itemlist-cgstamt + wa_itemlist-sgstamt +
                                 wa_itemlist-cesamt + wa_itemlist-statecesamt + wa_itemlist-statecesnonadvlamt.

        wa_itemlist-bchdtls-nm = wa_vbrp-batch.
        lv_tot_val      = lv_tot_val      + wa_itemlist-totitemval + lv_other_ch.
        lv_tot_disc     = lv_tot_disc     + wa_itemlist-discount.
        lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-assamt.
        lv_tot_igst     = lv_tot_igst     + wa_itemlist-igstamt.
        lv_tot_cgst     = lv_tot_cgst     + wa_itemlist-cgstamt.
        lv_tot_sgst     = lv_tot_sgst     + wa_itemlist-sgstamt.
        lv_tot_other    = lv_tot_other    + lv_other_ch.
        lv_tot_rndof    = lv_tot_rndof    + lv_tot_rndof_i.

        APPEND wa_itemlist TO itemlist.
        CLEAR wa_itemlist.

      ENDLOOP.

      wa_valdtls-assval   = lv_tot_asse_val.
      wa_valdtls-cgstval  = lv_tot_cgst.
      wa_valdtls-sgstval  = lv_tot_sgst.
      wa_valdtls-igstval  = lv_tot_igst.
      wa_valdtls-discount = lv_tot_disc.
      wa_valdtls-othchrg  = lv_tot_other.
      wa_valdtls-totinvval = lv_tot_val + lv_tot_rndof.
      wa_valdtls-rndoffamt = lv_tot_rndof.

*--------------------------------------------------------------------*


      wa_refdtls-invrm = 'Ref'.
      wa_refdtls-docperddtls-invstdt = wa_head-billingdocumentdate+6(2) && |/|
                                && wa_head-billingdocumentdate+4(2) && |/| &&  wa_head-billingdocumentdate+0(4).
      wa_refdtls-docperddtls-invenddt = wa_refdtls-docperddtls-invstdt.


      SELECT SINGLE *
            FROM i_paymenttermstext
            WHERE paymentterms = @wa_head-customerpaymentterms AND language = 'E'
            INTO @DATA(wa_zterm).


      wa_paydtls-nm = wa_zterm-paymenttermsdescription.
      wa_paydtls-payterm  = wa_head-customerpaymentterms.
      wa_paydtls-crday    =  wa_zterm-paymentterms.

      wa_transaction-trandtls   = wa_trandtls.
      wa_transaction-docdtls    = wa_docdtls.
      wa_transaction-sellerdtls = wa_sellerdtls.
      wa_transaction-buyerdtls  = wa_buyerdtls.
      wa_transaction-dispdtls   = wa_dispdtls.
      wa_transaction-shipdtls   = wa_shipdtls.
      wa_transaction-itemlist[] = itemlist[].
      wa_transaction-paydtls    = wa_paydtls.
      wa_transaction-refdtls    = wa_refdtls.
      wa_transaction-valdtls    = wa_valdtls.
      wa_transaction-expdtls    = wa_expdtls.

      wa_tran-transaction = wa_transaction.
      APPEND wa_tran TO it_trans.

    ENDIF.

  ENDMETHOD.
ENDCLASS.
