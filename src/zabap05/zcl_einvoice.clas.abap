CLASS zcl_einvoice DEFINITION
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
           lv_soldtoparty TYPE i_customer-customer.
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

    DATA: lv_vbeln TYPE zchar10.

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
           lv_tot_other    TYPE i_billingdocumentbasic-totalnetamount.


    METHODS: get_data,
      create_json,
      login_interface,
      call_api.

    INTERFACES :if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EINVOICE IMPLEMENTATION.


  METHOD call_api.

    DATA:  lv_content_length_value   TYPE i.

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
        i_value = '27AAFCD5862R013' ).

        lo_request->set_header_field( i_name = 'X-Cleartax-Auth-Token'
        i_value = '1.dd710b6d-1c7f-41d0-b28a-dfa1425c776c_71fdc9c7e2e27539946a2ac1cdb64850e4d6f480b2cc43acce9be73cac76f9a8' ).




        lv_content_length_value = strlen( json ).
        lo_request->set_text( i_text = json
                              i_length = lv_content_length_value ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>Put ).
        DATA(lv_xml_results) = lo_response->get_text( ).

      CATCH cx_root INTO DATA(lx_exception).
*        out->write( lx_exception->get_text( ) ).
    ENDTRY.

    " Create structures etc
    TYPES:
      BEGIN OF ts_tag,
        property TYPE string,
        value    TYPE string,
      END OF ts_tag,

      BEGIN OF ts_node,
        id        TYPE string,
        latitude  TYPE string,
        longitude TYPE string,
        tags      TYPE STANDARD TABLE OF ts_tag WITH EMPTY KEY,
      END OF ts_node,

      BEGIN OF ts_metadata,
        osm_base  TYPE string,
        osm_areas TYPE string,
      END OF ts_metadata,

      BEGIN OF ts_osm,
        api_version   TYPE string,
        api_generator TYPE string,
        note          TYPE string,
        metadata      TYPE ts_metadata,
        nodes         TYPE STANDARD TABLE OF ts_node WITH EMPTY KEY,
      END OF ts_osm.

    DATA ls_osm TYPE ts_osm.


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

      json = lv_json.
    ENDIF.
  ENDMETHOD.


  METHOD get_data.

    lv_vbeln = '0090000007'.


*    SELECT * FROM i_billingdocument
*          WHERE billingdocument = @lv_vbeln
**          AND (  accountingtransferstatus  = 'C'
**                  OR accountingtransferstatus  = 'D'
**                  OR accountingtransferstatus  = 'E' )
*          INTO TABLE @DATA(it_vbrk).

*    LOOP AT it_vbrk INTO DATA(wa_vbrk).

    CLEAR lv_cancel.
*      lv_date = wa_vbrk-billingdocumentdate + 7.
*      IF sy-datum > lv_date.
*        CONTINUE.
*      ENDIF.

*      SELECT SINGLE * FROM tvarvc
*      WHERE name = 'ZGSTIN_EINV'
*      INTO @DATA(wa_tvarvc).
*      IF sy-subrc = 0.
*        lv_gstin = wa_tvarvc-low.
*      ELSE.
*      SELECT SINGLE * FROM i_businessplace WITH PRIVILEGED ACCESS
**         WHERE companycode = @wa_vbrk-companycode
**         AND   BusinessPlace = @wa_vbrk-bu
*       INTO @DATA(wa_j_1bbranch).

*      lv_gstin = wa_j_1bbranch-taxnumber1.
    lv_gstin = '27AAFCD5862R013'.  "'27AAFCN2297L1ZY'.
*      ENDIF.

*      SELECT plant, product, billingquantity, material,
*             \_PricingElementBasic~*
*              FROM i_billingdocumentitembasic
*      WHERE billingdocument = @wa_vbrk-billingdocument
*      INTO TABLE @DATA(it_vbrp).

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


*      SELECT plant, product, billingquantity,
*        material, billingquantityinbaseunit,referencesddocument,
*      \_pricingelementbasic-billingdocument AS billingdocument
*       FROM i_billingdocumentitembasic
*      WHERE billingdocument = @wa_vbrk-billingdocument
*      INTO TABLE @DATA(it_vbrp).
*
*      DELETE billingdata WHERE billingquantity IS INITIAL.
*      DELETE billingdata WHERE billingquantity = '0.000'.

    IF billingdata[] IS NOT INITIAL.
*      SELECT * FROM i_productqm
*        FOR ALL ENTRIES IN @billingdata
*        WHERE product = @billingdata-product
*        INTO TABLE @DATA(it_marc).
*
*      SELECT * FROM i_salesorderpartner
*        FOR ALL ENTRIES IN @billingdata
*        WHERE salesorder = @billingdata-referencesddocument
*        AND   partnerfunction = 'WE'
*        INTO TABLE @DATA(it_vbpa_del).
    ENDIF.

    SELECT partnerfunction, customer FROM i_salesorderpartner
    FOR ALL ENTRIES IN @billingdata
      WHERE salesorder = @billingdata-salesdocument
      INTO TABLE @DATA(it_vbpa).



    CLEAR : it_trans[], itemlist[], addldocdtls[].
    CLEAR : wa_transaction, wa_trandtls, wa_docdtls, wa_sellerdtls, wa_buyerdtls, wa_dispdtls,wa_shipdtls,
            wa_itemlist, wa_valdtls, wa_paydtls, wa_refdtls, wa_addldocdtls, wa_expdtls, wa_ewbdtls.



*      SELECT SINGLE * FROM i_address WITH PRIVILEGED ACCESS
*        WHERE addressid = @wa_j_1bbranch-addressid
*        INTO @DATA(wa_adrc_bupla).

    DATA : lv_werks TYPE i_plant-plant.
    READ TABLE billingdata INTO DATA(wa_data) INDEX 1.
    IF sy-subrc = 0.

      READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data-billingdocument.
      lv_werks = wa_data-plant.

      SELECT SINGLE
        plant,
        plantname
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

*      SELECT SINGLE * FROM i_Address
*        WHERE AddressID = wa_t001w-AddressID
*        INTO @dawa_adrc_bupla.

*      SELECT SINGLE * FROM adr6 INTO wa_adr6_bupla
*        WHERE addrnumber = wa_j_1bbranch-adrnr
*        AND   flgdefault = 'X'.

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
      CASE wa_data-billingdocumenttype.
        WHEN 'F2'.
          wa_docdtls-typ           = 'INV'.
          wa_trandtls-suptyp       = 'B2B'.
*        WHEN 'RE'.
*          wa_docdtls-typ           = 'CRN'.
*          wa_trandtls-suptyp       = 'B2B'.
*        WHEN 'ZSEZ'.
*          wa_docdtls-typ           = 'INV'.
*          wa_trandtls-suptyp       = 'SEZWP'.  ""Need to ask Saurab SEZWOP
*        WHEN 'F2' OR 'ZSTO' OR 'ZSN'.
*          wa_docdtls-typ           = 'INV'.
*          wa_trandtls-suptyp       = 'EXPWOP'.
*
*          IF wa_head-accountingtransferstatus = 'E'.
*            wa_docdtls-typ           = 'CRN'.
*          ENDIF.
*        WHEN 'ZF3'.
*          wa_docdtls-typ           = 'INV'.
*          wa_trandtls-suptyp       = 'EXPWP'.
      ENDCASE.

      wa_docdtls-no            = lv_vbeln. "wa_vbrk-xblnr.
      SHIFT wa_docdtls-no LEFT DELETING LEADING '0'.

      CONCATENATE wa_head-billingdocumentdate+6(2) wa_head-billingdocumentdate+4(2)
                  wa_head-billingdocumentdate+0(4) INTO wa_docdtls-dt SEPARATED BY '/'.
*      gv_gstin_seller =  wa_sellerdtls-gstin = wa_j_1bbranch-gstin.



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

      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'RE'.  ""Buyer
      IF sy-subrc = 0.
        lv_buyer = wa_vbpa-customer.
      ELSE.
        lv_buyer = lv_soldtoparty.
      ENDIF.

      SELECT SINGLE
      customer
*      \_standardaddress-addressid,
*       \_standardaddress-addressuuid,
*       \_standardaddress-careofname,
*       \_standardaddress-additionalstreetsuffixname,
*       \_standardaddress-correspondencelanguage,
*       \_standardaddress-prfrdcommmediumtype,
*       \_standardaddress-pobox,
*       \_standardaddress-poboxiswithoutnumber,
*       \_standardaddress-poboxpostalcode,
*       \_standardaddress-poboxlobbyname,
*       \_standardaddress-poboxdeviatingcityname,
*       \_standardaddress-poboxdeviatingregion,
*       \_standardaddress-poboxdeviatingcountry,
*       \_standardaddress-deliveryservicetypecode,
*       \_standardaddress-deliveryservicenumber,
*       \_standardaddress-addresstimezone,
*       \_standardaddress-cityfileteststatus,
*       \_standardaddress-addressstreetunusable,
*       \_standardaddress-addresspostboxunusable,
*       \_standardaddress-fullname,
*       \_standardaddress-cityname,
*       \_standardaddress-district,
*       \_standardaddress-citycode,
*       \_standardaddress-homecityname,
*      \_standardaddress-postalcode,
*      \_standardaddress-companypostalcode,
*      \_standardaddress-streetname,
*      \_standardaddress-streetprefixname,
*      \_standardaddress-additionalstreetprefixname,
*      \_standardaddress-streetsuffixname,
*      \_standardaddress-housenumber,
*      \_standardaddress-housenumbersupplementtext,
*      \_standardaddress-building,
*      \_standardaddress-floor,
*      \_standardaddress-roomnumber,
*      \_standardaddress-country,
*      \_standardaddress-region,
*      \_standardaddress-county,
*      \_standardaddress-countycode,
*      \_standardaddress-townshipcode,
*      \_standardaddress-townshipname,
*      \_standardaddress-formofaddress,
*      \_standardaddress-businesspartnername1,
*      \_standardaddress-businesspartnername2,
*      \_standardaddress-nation,
*      \_standardaddress-phonenumber,
*      \_standardaddress-faxnumber,
*      \_standardaddress-searchterm1,
*      \_standardaddress-searchterm2,
*      \_standardaddress-streetsearch,
*      \_standardaddress-citysearch,
*      \_standardaddress-businesspartnername3,
*      \_standardaddress-businesspartnername4,
*      \_standardaddress-taxjurisdiction,
*      \_standardaddress-transportzone,
*      \_standardaddress-addresscitypostboxcode,
*      \_standardaddress-person
       FROM i_customer
        WHERE customer = @lv_buyer
        INTO @DATA(wa_kna1).

      CLEAR gv_exp.
*      IF wa_kna1-countycode NE 'IN'.
        gv_exp = 'X'.
*        wa_expdtls-cntcode = wa_kna1-countycode.
*      ENDIF.

*      SELECT SINGLE * FROM dfkkbptaxnum
*        WHERE partner = @lv_buyer AND taxtype = 'IN3'
*        INTO @DATA(wa_dfkkbptaxnum).
*
*      wa_buyerdtls-gstin = wa_dfkkbptaxnum-taxnum.
*      wa_buyerdtls-loc  = wa_kna1-cityname.
*      wa_buyerdtls-pin  = wa_kna1-postalcode.
*      wa_buyerdtls-stcd = wa_kna1-region.
*      wa_buyerdtls-ph   = wa_kna1-phonenumber.
*      wa_buyerdtls-pos  = wa_kna1-region.
*
*      CONCATENATE wa_kna1-businesspartnername1 wa_kna1-businesspartnername2 INTO wa_buyerdtls-lglnm SEPARATED BY ''.
*      CONCATENATE wa_kna1-businesspartnername1 wa_kna1-businesspartnername2 INTO wa_buyerdtls-trdnm SEPARATED BY ''.
*      CONCATENATE wa_kna1-streetname wa_kna1-streetprefixname wa_kna1-streetsuffixname INTO wa_buyerdtls-addr1 SEPARATED BY ''.
*      CONCATENATE wa_kna1-streetname wa_kna1-streetprefixname wa_kna1-streetsuffixname INTO wa_buyerdtls-addr2 SEPARATED BY ''.

* --------------------------------------------------------------------*
      "SHIPDTLS
      CLEAR : gv_disp, gv_ship.

      READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
      IF sy-subrc = 0 AND wa_vbpa-customer NE lv_buyer.
        SELECT SINGLE customer
*      \_standardaddress-addressid,
*       \_standardaddress-addressuuid,
*       \_standardaddress-careofname,
*       \_standardaddress-additionalstreetsuffixname,
*       \_standardaddress-correspondencelanguage,
*       \_standardaddress-prfrdcommmediumtype,
*       \_standardaddress-pobox,
*       \_standardaddress-poboxiswithoutnumber,
*       \_standardaddress-poboxpostalcode,
*       \_standardaddress-poboxlobbyname,
*       \_standardaddress-poboxdeviatingcityname,
*       \_standardaddress-poboxdeviatingregion,
*       \_standardaddress-poboxdeviatingcountry,
*       \_standardaddress-deliveryservicetypecode,
*       \_standardaddress-deliveryservicenumber,
*       \_standardaddress-addresstimezone,
*       \_standardaddress-cityfileteststatus,
*       \_standardaddress-addressstreetunusable,
*       \_standardaddress-addresspostboxunusable,
*       \_standardaddress-fullname,
*       \_standardaddress-cityname,
*       \_standardaddress-district,
*       \_standardaddress-citycode,
*       \_standardaddress-homecityname,
*      \_standardaddress-postalcode,
*      \_standardaddress-companypostalcode,
*      \_standardaddress-streetname,
*      \_standardaddress-streetprefixname,
*      \_standardaddress-additionalstreetprefixname,
*      \_standardaddress-streetsuffixname,
*      \_standardaddress-housenumber,
*      \_standardaddress-housenumbersupplementtext,
*      \_standardaddress-building,
*      \_standardaddress-floor,
*      \_standardaddress-roomnumber,
*      \_standardaddress-country,
*      \_standardaddress-region,
*      \_standardaddress-county,
*      \_standardaddress-countycode,
*      \_standardaddress-townshipcode,
*      \_standardaddress-townshipname,
*      \_standardaddress-formofaddress,
*      \_standardaddress-businesspartnername1,
*      \_standardaddress-businesspartnername2,
*      \_standardaddress-nation,
*      \_standardaddress-phonenumber,
*      \_standardaddress-faxnumber,
*      \_standardaddress-searchterm1,
*      \_standardaddress-searchterm2,
*      \_standardaddress-streetsearch,
*      \_standardaddress-citysearch,
*      \_standardaddress-businesspartnername3,
*      \_standardaddress-businesspartnername4,
*      \_standardaddress-taxjurisdiction,
*      \_standardaddress-transportzone,
*      \_standardaddress-addresscitypostboxcode,
*      \_standardaddress-person
        FROM i_customer
          WHERE customer = @wa_vbpa-customer
          INTO @DATA(wa_kna1_sh).

*        SELECT SINGLE * FROM \_address
*        WHERE addressid = @wa_kna1_sh-addressid
*        INTO @DATA(wa_kna1_sh).

*       wa_shipdtls-gstin = wa_kna1_sh-stcd3.
*        wa_shipdtls-loc   = wa_kna1_sh-cityname.
*        wa_shipdtls-pin   = wa_kna1_sh-postalcode.
*        wa_shipdtls-stcd  = wa_kna1_sh-region.
*
*        CONCATENATE wa_kna1_sh-businesspartnername1 wa_kna1_sh-businesspartnername2 INTO wa_shipdtls-lglnm SEPARATED BY ''.
*        CONCATENATE wa_kna1_sh-businesspartnername1 wa_kna1_sh-businesspartnername2 INTO wa_shipdtls-trdnm SEPARATED BY ''.
*        CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-streetprefixname wa_kna1_sh-streetsuffixname INTO wa_shipdtls-addr1 SEPARATED BY ''.
*        CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-streetprefixname wa_kna1_sh-streetsuffixname INTO wa_shipdtls-addr2 SEPARATED BY ''.
      ELSE.
        gv_ship = 'X'.
      ENDIF.

      IF   wa_data-billingdocumenttype = 'ZF2'
        OR wa_data-billingdocumenttype = 'ZF3'
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


      IF wa_trandtls-suptyp = 'EXPWP' OR wa_trandtls-suptyp  = 'EXPWOP' OR gv_exp = 'X'.
        wa_buyerdtls-gstin = 'URP'.
        wa_buyerdtls-pos = '96'.
        wa_buyerdtls-stcd = '96'.
        wa_buyerdtls-pin = '999999'.
      ENDIF.


* --------------------------------------------------------------------*

      "DISPDTLS

      IF wa_t001w-plantname IS NOT INITIAL.
        wa_dispdtls-nm = wa_t001w-plantname.
      ELSE.
*      CONCATENATE wa_adrc_disp- wa_adrc_disp-name2 INTO wa_dispdtls-nm SEPARATED BY ''.
      ENDIF.

*      CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_dispdtls-addr1 SEPARATED BY ''.
*      wa_dispdtls-addr2 = wa_dispdtls-addr1.
*
*      wa_dispdtls-loc  = wa_t001w-cityname.
*      wa_dispdtls-pin  = wa_t001w-postalcode.
*      wa_dispdtls-stcd = wa_t001w-region.


*     *--------------------------------------------------------------------*

      "ITEMLIST
      CLEAR : lv_tot_val, lv_tot_disc, lv_tot_freight, lv_tot_ins, lv_tot_roff, lv_tot_asse_val,
           lv_tot_igst, lv_tot_cgst, lv_tot_sgst, lv_tot_other.


      LOOP AT billingdata INTO DATA(wa_vbrp).

        CLEAR : lv_unit_pr, lv_disc, lv_freight, lv_asse_val, lv_asse_val1, lv_igst, lv_cgst, lv_sgst,
                lv_igst_rt, lv_cgst_rt, lv_sgst_rt, lv_other_ch, lv_ins.

        lv_num = lv_num + 1.

        wa_itemlist-slno        = lv_num.
        wa_itemlist-prddesc     = wa_vbrp-product.
        wa_itemlist-isservc     = 'N'.
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
        wa_itemlist-unit = wa_vbrp-BillingQuantityUnit. "billingquantityinbaseunit
*        ENDIF.

        LOOP AT pricingdata INTO DATA(prcd_elements)
                WHERE billingdocument = wa_vbrp-billingdocument AND
                      billingdocumentitem = wa_vbrp-billingdocumentitem.

          IF  prcd_elements-conditiontype = 'ZPRC' OR prcd_elements-conditiontype = 'ZPRB'.
            lv_unit_pr = prcd_elements-conditionrateamount.
            lv_asse_val = lv_asse_val + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOIG'.
            lv_igst_rt = prcd_elements-conditionrateamount." / 10.
            lv_igst = lv_igst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOCG'.
            lv_igst_rt = prcd_elements-conditionrateamount." / 10.
            lv_igst = lv_igst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'JOSG'.
            lv_igst_rt = prcd_elements-conditionrateamount." / 10.
            lv_igst = lv_igst + prcd_elements-conditionamount.
          ENDIF.

          IF prcd_elements-conditiontype = 'ZDIP' OR prcd_elements-conditiontype = 'ZDLK'.
            lv_disc = lv_igst + prcd_elements-conditionamount.
          ENDIF.
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
                                 wa_itemlist-cesamt + wa_itemlist-statecesamt + wa_itemlist-statecesnonadvlamt. " +

        wa_itemlist-bchdtls-nm = wa_vbrp-batch.
        lv_tot_val      = lv_tot_val      + wa_itemlist-totitemval + lv_other_ch.
        lv_tot_disc     = lv_tot_disc     + wa_itemlist-discount.
        lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-assamt.
        lv_tot_igst     = lv_tot_igst     + wa_itemlist-igstamt.
        lv_tot_cgst     = lv_tot_cgst     + wa_itemlist-cgstamt.
        lv_tot_sgst     = lv_tot_sgst     + wa_itemlist-sgstamt.
        lv_tot_other    = lv_tot_other    + lv_other_ch.

        APPEND wa_itemlist TO itemlist.
        CLEAR wa_itemlist.

      ENDLOOP.

      wa_valdtls-assval   = lv_tot_asse_val.
      wa_valdtls-cgstval  = lv_tot_cgst.
      wa_valdtls-sgstval  = lv_tot_sgst.
      wa_valdtls-igstval  = lv_tot_igst.
      wa_valdtls-discount = lv_tot_disc.
      wa_valdtls-othchrg  = lv_tot_other.
      wa_valdtls-totinvval = lv_tot_val.

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

      CALL METHOD create_json.

    ENDIF.


  ENDMETHOD.


  METHOD if_oo_adt_classrun~main .

    CALL METHOD get_data.
    CALL METHOD login_interface.
    CALL METHOD call_api.
  ENDMETHOD.


  METHOD login_interface.

  ENDMETHOD.
ENDCLASS.
