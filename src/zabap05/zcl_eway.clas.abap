CLASS zcl_eway DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    DATA: lv_vbeln        TYPE Zchar10,
          lv_gstin        TYPE string,
          wa_billlists    TYPE zsdst_billlists,
          it_billlists TYPE TABLE of zsdst_billlists,
          it_itemlist     TYPE zsdtt_eitemlist,
          wa_itemlist     TYPE zsdst_eitemlist,
          lv_unit_pr      TYPE i_billingdocumentitembasic-netamount,
          lv_disc         TYPE i_billingdocumentbasic-billingdocument,
          lv_asse_val     TYPE i_billingdocumentbasic-totalnetamount,
          lv_tot_asse_val TYPE i_billingdocumentbasic-totalnetamount,
          lv_other_ch     TYPE i_billingdocumentbasic-totalnetamount,
          lv_tot_other    TYPE i_billingdocumentbasic-totalnetamount,
          lv_igst         TYPE i_billingdocumentbasic-totalnetamount,
          lv_cgst         TYPE i_billingdocumentbasic-totalnetamount,
          lv_sgst         TYPE i_billingdocumentbasic-totalnetamount,
          lv_tot_val      TYPE i_billingdocumentbasic-totalnetamount,
          lv_igst_rt      TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_cgst_rt      TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_sgst_rt      TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tot_igst     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tot_cgst     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tot_sgst     TYPE i_billingdocumentitemprcgelmnt-conditionamount,
          lv_tot_item_val TYPE i_billingdocumentitemprcgelmnt-conditionamount.
    DATA : lv_buyer       TYPE i_customer-customer,
           lv_soldtoparty TYPE i_customer-customer,
           lv_shipto      TYPE i_customer-customer.
    METHODS: get_data_ewaybill_non_irn,
      generate_eway_bill_non_irn,
      get_data_ewaybill_with_irn,
      generate_eway_bill_with_irn.

    INTERFACES :if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_EWAY IMPLEMENTATION.


  METHOD generate_eway_bill_non_irn.
  ENDMETHOD.


  METHOD generate_eway_bill_with_irn.
  ENDMETHOD.


  METHOD get_data_ewaybill_non_irn.

    lv_vbeln = '0090000007'.

    READ ENTITY i_billingdocumenttp
        ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
         RESULT FINAL(billingheader)
         FAILED FINAL(failed_data1).

    READ ENTITY i_billingdocumenttp
    BY \_item
  ALL FIELDS WITH VALUE #( ( billingdocument = lv_vbeln ) )
   RESULT FINAL(billingdata)
   FAILED FINAL(failed_data).


    SELECT billingdocument, billingdocumentitem, conditiontype, conditionrateamount, conditionamount
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


      SELECT salesorder, partnerfunction, customer FROM i_salesorderpartner
      FOR ALL ENTRIES IN @billingdata
        WHERE salesorder = @billingdata-salesdocument
        INTO TABLE @DATA(it_vbpa).



      DATA : lv_werks TYPE i_plant-plant.
      READ TABLE billingdata INTO DATA(wa_data) INDEX 1.
      IF sy-subrc = 0.

        READ TABLE billingheader INTO DATA(wa_head) WITH KEY billingdocument =  wa_data-billingdocument.
        IF sy-subrc = 0.

          lv_werks = wa_data-plant.

          READ TABLE it_vbpa INTO DATA(wa_vbpa) WITH KEY partnerfunction = 'AG'.  ""Sold to party
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
            plant,
            plantname
*           \_address-addressid,
*           \_address-addressuuid,
*           \_address-careofname,
*           \_address-additionalstreetsuffixname,
*           \_address-correspondencelanguage,
*           \_address-prfrdcommmediumtype,
*           \_address-pobox,
*           \_address-poboxiswithoutnumber,
*           \_address-poboxpostalcode,
*           \_address-poboxlobbyname,
*           \_address-poboxdeviatingcityname,
*           \_address-poboxdeviatingregion,
*           \_address-poboxdeviatingcountry,
*           \_address-deliveryservicetypecode,
*           \_address-deliveryservicenumber,
*           \_address-addresstimezone,
*           \_address-cityfileteststatus,
*           \_address-addressstreetunusable,
*           \_address-addresspostboxunusable,
*           \_address-fullname,
*           \_address-cityname,
*           \_address-district,
*           \_address-citycode,
*           \_address-homecityname,
*           \_address-postalcode,
*           \_address-companypostalcode,
*           \_address-streetname,
*           \_address-streetprefixname,
*           \_address-additionalstreetprefixname,
*           \_address-streetsuffixname,
*           \_address-housenumber,
*           \_address-housenumbersupplementtext,
*           \_address-building,
*           \_address-floor,
*           \_address-roomnumber,
*           \_address-country,
*           \_address-region,
*           \_address-county,
*           \_address-countycode,
*           \_address-townshipcode,
*           \_address-townshipname,
*           \_address-formofaddress,
*           \_address-businesspartnername1,
*           \_address-businesspartnername2,
*           \_address-nation,
*           \_address-phonenumber,
*           \_address-faxnumber,
*           \_address-searchterm1,
*           \_address-searchterm2,
*           \_address-streetsearch,
*           \_address-citysearch,
*           \_address-businesspartnername3,
*           \_address-businesspartnername4,
*           \_address-taxjurisdiction,
*           \_address-transportzone,
*           \_address-addresscitypostboxcode,
*           \_address-person
           FROM i_plant
            WHERE plant = @lv_werks
            INTO @DATA(wa_t001w).

          cl_glo_bupla_svc_ext_util=>get_bupla_by_companycode(
                  EXPORTING
                    iv_companycode = wa_head-companycode
                  IMPORTING
                    et_business_place = DATA(et_business_place)
                  ).
          lv_gstin = '27AAFCN2297L1ZY'.

          wa_billlists-supplytype    = 'O'. "NEED TO CHANGE
          IF wa_head-billingdocumenttype = 'ZSTO' OR wa_head-billingdocumenttype = 'ZST1' .
            wa_billlists-subsupplytype = 8.
            wa_billlists-subsupplydesc = 'Stock transfer'.
          ELSEIF wa_head-billingdocumenttype = 'ZSN'.
            wa_billlists-subsupplytype = 4.
          ELSE.
            wa_billlists-subsupplytype = 1.   " it should always be passed without quotes
          ENDIF.

          CASE wa_head-billingdocumenttype.
            WHEN 'ZSP' OR 'ZSTO' OR 'ZST1' OR 'ZSN'.
              wa_billlists-doctype = 'CHL'.
            WHEN OTHERS.
              wa_billlists-doctype = 'INV'.
          ENDCASE.

          wa_billlists-docno  = wa_head-billingdocument.
          CONCATENATE wa_head-billingdocumentdate+6(2) wa_head-billingdocumentdate+4(2) wa_head-billingdocumentdate+0(4)
                      INTO wa_billlists-docdate SEPARATED BY '/'.


*              CONCATENATE wa_t001w-businesspartnername1 wa_t001w-businesspartnername2 INTO wa_billlists-fromtrdname SEPARATED BY ''.
*              CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_billlists-fromaddr1 SEPARATED BY ''.
*              CONCATENATE wa_t001w-streetname wa_t001w-streetprefixname wa_t001w-streetsuffixname INTO wa_billlists-fromaddr2 SEPARATED BY ''.
*
*              wa_billlists-fromgstin =  lv_gstin.
*              wa_billlists-fromplace  = wa_t001w-cityname.
*              wa_billlists-frompincode  = wa_t001w-postalcode.
*              wa_billlists-fromstatecode = wa_t001w-region.
*              wa_billlists-actfromstatecode = wa_t001w-region.


          READ TABLE it_vbpa INTO wa_vbpa WITH  KEY partnerfunction = 'WE'. "SHIP TO PARTY
          IF sy-subrc = 0." AND wa_vbpa-customer NE lv_buyer.

            lv_shipto = wa_vbpa-customer.
            SELECT SINGLE customer
*                          \_standardaddress-addressid,
*                           \_standardaddress-addressuuid,
*                           \_standardaddress-careofname,
*                           \_standardaddress-additionalstreetsuffixname,
*                           \_standardaddress-correspondencelanguage,
*                           \_standardaddress-prfrdcommmediumtype,
*                           \_standardaddress-pobox,
*                           \_standardaddress-poboxiswithoutnumber,
*                           \_standardaddress-poboxpostalcode,
*                           \_standardaddress-poboxlobbyname,
*                           \_standardaddress-poboxdeviatingcityname,
*                           \_standardaddress-poboxdeviatingregion,
*                           \_standardaddress-poboxdeviatingcountry,
*                           \_standardaddress-deliveryservicetypecode,
*                           \_standardaddress-deliveryservicenumber,
*                           \_standardaddress-addresstimezone,
*                           \_standardaddress-cityfileteststatus,
*                           \_standardaddress-addressstreetunusable,
*                           \_standardaddress-addresspostboxunusable,
*                           \_standardaddress-fullname,
*                           \_standardaddress-cityname,
*                           \_standardaddress-district,
*                           \_standardaddress-citycode,
*                           \_standardaddress-homecityname,
*                          \_standardaddress-postalcode,
*                          \_standardaddress-companypostalcode,
*                          \_standardaddress-streetname,
*                          \_standardaddress-streetprefixname,
*                          \_standardaddress-additionalstreetprefixname,
*                          \_standardaddress-streetsuffixname,
*                          \_standardaddress-housenumber,
*                          \_standardaddress-housenumbersupplementtext,
*                          \_standardaddress-building,
*                          \_standardaddress-floor,
*                          \_standardaddress-roomnumber,
*                          \_standardaddress-country,
*                          \_standardaddress-region,
*                          \_standardaddress-county,
*                          \_standardaddress-countycode,
*                          \_standardaddress-townshipcode,
*                          \_standardaddress-townshipname,
*                          \_standardaddress-formofaddress,
*                          \_standardaddress-businesspartnername1,
*                          \_standardaddress-businesspartnername2,
*                          \_standardaddress-nation,
*                          \_standardaddress-phonenumber,
*                          \_standardaddress-faxnumber,
*                          \_standardaddress-searchterm1,
*                          \_standardaddress-searchterm2,
*                          \_standardaddress-streetsearch,
*                          \_standardaddress-citysearch,
*                          \_standardaddress-businesspartnername3,
*                          \_standardaddress-businesspartnername4,
*                          \_standardaddress-taxjurisdiction,
*                          \_standardaddress-transportzone,
*                          \_standardaddress-addresscitypostboxcode,
*                          \_standardaddress-person
             FROM i_customer
              WHERE customer = @wa_vbpa-customer
              INTO @DATA(wa_kna1_sh).

*            IF wa_kna1_sh-countycode NE 'IN'.
*              wa_billlists-tostatecode = '97'.
*              wa_billlists-topincode = '999999'.
*              wa_billlists-togstin = 'URP'.
*            ELSE.


*              wa_billlists-tostatecode = wa_kna1_sh-region.
*              wa_billlists-topincode  = wa_kna1_sh-postalcode.
*        wa_billlists-togstin = wa_kna1_sh-gst. "w_j_1bbranch-gstin.

*              CONCATENATE wa_kna1_sh-businesspartnername1 wa_kna1_sh-businesspartnername2
*                          INTO wa_billlists-totrdname SEPARATED BY ''.
*              CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-streetprefixname wa_kna1_sh-streetsuffixname
*                            INTO wa_billlists-toaddr1 SEPARATED BY ''.
*              CONCATENATE wa_kna1_sh-streetname wa_kna1_sh-streetprefixname wa_kna1_sh-streetsuffixname
*                        INTO wa_billlists-toaddr2 SEPARATED BY ''.
*              wa_billlists-toplace  = wa_kna1_sh-cityname.
*              wa_billlists-topincode  = wa_kna1_sh-postalcode.
*              wa_billlists-tostatecode = wa_kna1_sh-region.
*              wa_billlists-acttostatecode = wa_kna1_sh-region.

*            ENDIF.

            IF lv_shipto = lv_buyer.
              wa_billlists-transactiontype = '1'.
            ELSE.
              wa_billlists-transactiontype = '2'.
            ENDIF.

            LOOP AT billingdata INTO DATA(wa_vbrp).

              CLEAR : lv_unit_pr, lv_asse_val,  lv_igst, lv_cgst, lv_sgst,
                lv_igst_rt, lv_cgst_rt, lv_sgst_rt.

              wa_itemlist-productname = wa_vbrp-product.
              wa_itemlist-productdesc = wa_vbrp-product.
              wa_itemlist-quantity = wa_vbrp-billingquantity.
              wa_itemlist-qtyunit = wa_vbrp-billingquantityunit.

              READ TABLE productplantbasic INTO DATA(plantdata) WITH KEY product = wa_vbrp-product
                                                                                plant = wa_vbrp-plant.
              IF sy-subrc = 0.
                wa_itemlist-hsncode = plantdata-consumptiontaxctrlcode.
              ENDIF.


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

                IF prcd_elements-conditiontype = 'JTC1' OR prcd_elements-conditiontype = 'JTC2'.
                  lv_other_ch = lv_other_ch + prcd_elements-conditionamount.
                ENDIF.


              ENDLOOP.


              wa_itemlist-cgstrate     = lv_cgst_rt.
              wa_itemlist-sgstrate     = lv_sgst_rt.
              wa_itemlist-igstrate     = lv_igst_rt.

              lv_tot_igst = lv_tot_igst + ( lv_asse_val * lv_igst_rt ) / 100.
              lv_tot_cgst = lv_tot_cgst + ( lv_asse_val * lv_cgst_rt ) / 100.
              lv_tot_sgst = lv_tot_sgst + ( lv_asse_val * lv_sgst_rt ) / 100.
*              wa_itemlist-cessRate =
              wa_itemlist-taxableamount = ( lv_asse_val + lv_disc ) * wa_head-accountingexchangerate.

              lv_tot_item_val  =  lv_tot_item_val  + wa_itemlist-taxableamount + lv_cgst + lv_sgst + lv_igst.
*                             wa_itemlist-cessadvol ."+ wa_itemlist2-othchrg.

              lv_tot_asse_val = lv_tot_asse_val + wa_itemlist-taxableamount.
              lv_tot_other    = lv_tot_other    + lv_other_ch.
              APPEND wa_itemlist TO it_itemlist.
              CLEAR: wa_itemlist, lv_cgst, lv_sgst, lv_igst.

            ENDLOOP.

            wa_billlists-cgstvalue = lv_tot_cgst.
            wa_billlists-sgstvalue = lv_tot_sgst.
            wa_billlists-igstvalue = lv_tot_igst.
            wa_billlists-othervalue = lv_tot_other.
            wa_billlists-totalvalue = lv_tot_asse_val.
            wa_billlists-totinvvalue = lv_tot_item_val.
*            wa_billlists-cessValue
*            wa_billlists-cessNonAdvolValue

            APPEND wa_billlists TO it_billlists. CLEAR wa_billlists.

          ENDIF.

        ENDIF.
      ENDIF.

    ENDIF.



  ENDMETHOD.


  METHOD get_data_ewaybill_with_irn.
  ENDMETHOD.


  METHOD if_oo_adt_classrun~main .

*    CALL METHOD login_interface.
    CALL METHOD get_data_ewaybill_non_irn.
    CALL METHOD generate_eway_bill_non_irn.
  ENDMETHOD.
ENDCLASS.
