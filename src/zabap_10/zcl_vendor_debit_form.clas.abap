CLASS zcl_vendor_debit_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_VENDOR_DEBIT_FORM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.


    DATA: lt_response   TYPE TABLE OF zce_vendor_debit_form,
          ls_response   TYPE zce_vendor_debit_form,
          lt_response_i TYPE TABLE OF zce_vendor_debit_form_item,
          ls_response_i TYPE zce_vendor_debit_form_item.
    DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
    DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
    DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
    DATA(lt_fields)        = io_request->get_requested_elements( ).
    DATA(lt_sort)          = io_request->get_sort_elements( ).

    TRY.
        DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
      CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
    ENDTRY.

    DATA(lr_acc_no)  =  VALUE  #( lt_filter_cond[ name   = 'ACCOUNTINGDOCUMENT' ]-range OPTIONAL ).
    DATA(lr_fiscal_year)  =  VALUE  #( lt_filter_cond[ name   = 'FISCALYEAR' ]-range OPTIONAL ).
    DATA(lv_fiscal_year)  = VALUE gjahr( lr_fiscal_year[ 1 ]-low OPTIONAL ).
    DATA(lv_acc_no)  = VALUE re_belnr( lr_acc_no[ 1 ]-low OPTIONAL ).
    CASE io_request->get_entity_id( ).
      WHEN 'ZCE_VENDOR_DEBIT_FORM'.
        IF io_request->is_data_requested( ).
          SELECT SINGLE supplier FROM i_journalentryitem
          WITH PRIVILEGED ACCESS
          WHERE accountingdocument = @lv_acc_no
          AND fiscalyear = @lv_fiscal_year
          AND financialaccounttype = 'K'
          INTO @DATA(lv_supplier). "FinancialAccountType = K
          IF sy-subrc   = 0.
            SELECT SINGLE suppliername,
            streetname, cityname,postalcode,region,country,taxnumber3
            FROM i_supplier WITH PRIVILEGED ACCESS
            WHERE supplier = @lv_supplier
            INTO @DATA(lw_supplier).
            IF sy-subrc = 0.
              ls_response-ship_to_name = lw_supplier-suppliername.
              ls_response-ship_to_street1 = lw_supplier-streetname.
              ls_response-ship_to_city = lw_supplier-cityname.
              ls_response-ship_to_state_code = lw_supplier-region.
              ls_response-ship_to_country = lw_supplier-country.
              ls_response-ship_to_pin = lw_supplier-postalcode.
              ls_response-ship_to_gstin = lw_supplier-taxnumber3.
              SELECT SINGLE regionname FROM i_regiontext
              WITH PRIVILEGED ACCESS
              WHERE country = @lw_supplier-country
              AND region = @lw_supplier-region
              AND language = @sy-langu
              INTO @ls_response-ship_to_state.
              SELECT SINGLE CountryName FROM I_CountryText
              WITH PRIVILEGED ACCESS
              WHERE country = @lw_supplier-country
              AND Language = @sy-langu
              INTO @ls_response-ship_to_country.

              ls_response-bill_to_name = lw_supplier-suppliername.
              ls_response-bill_to_street1 = lw_supplier-streetname.
              ls_response-bill_to_city = lw_supplier-cityname.
              ls_response-bill_to_state_code = lw_supplier-region.
              ls_response-bill_to_country = ls_response-ship_to_country.
              ls_response-bill_to_pin = lw_supplier-postalcode.
              ls_response-bill_to_gstin = lw_supplier-taxnumber3.
              ls_response-bill_to_state = ls_response-ship_to_state.

            ENDIF.

            SELECT SINGLE accountingdocument,documentdate,postingdate,documentreferenceid
            FROM i_journalentry WITH PRIVILEGED ACCESS
            WHERE accountingdocument = @lv_acc_no
            AND fiscalyear = @lv_fiscal_year
            INTO @DATA(lw_journalentry).
            IF sy-subrc = 0.
              ls_response-accountingdocument = lw_journalentry-accountingdocument.
              ls_response-debit_note_date = lw_journalentry-postingdate.
              ls_response-invoice_num = lw_journalentry-documentreferenceid.
              ls_response-invoice_date = lw_journalentry-documentdate.


            ENDIF.

          ENDIF.
          SELECT taxamountincocodecrcy,transactiontypedetermination
          FROM i_operationalacctgdoctaxitem
          WHERE accountingdocument = @lv_acc_no
            AND fiscalyear = @lv_fiscal_year
            INTO TABLE @DATA(lt_tax_data).
          LOOP AT lt_tax_data INTO DATA(lw_tax_data).

            CASE lw_tax_data-transactiontypedetermination.
              WHEN 'JIC'.
                ls_response-cgst = ls_response-cgst + ( lw_tax_data-taxamountincocodecrcy *  -1 ) .
              WHEN 'JIS'.
                ls_response-sgst = ls_response-sgst + ( lw_tax_data-taxamountincocodecrcy *  -1 ).
              WHEN 'JII'.
                ls_response-igst = ls_response-igst + ( lw_tax_data-taxamountincocodecrcy *  -1 ).
            ENDCASE.


          ENDLOOP.
          ls_response-total_tax = ls_response-cgst + ls_response-sgst + ls_response-igst.

          SELECT SUM( AmountInCompanyCodeCurrency ) FROM i_journalentryitem
          WITH PRIVILEGED ACCESS
           WHERE accountingdocument = @lv_acc_no
           AND fiscalyear = @lv_fiscal_year
           AND ( transactiontypedetermination = 'WRX' OR transactiontypedetermination
           = 'BSX' )
           INTO  @ls_response-additional_amount1.
           ls_response-additional_amount1 = ls_response-additional_amount1 * -1.

          ls_response-total_debit_note = ls_response-additional_amount1 + ls_response-total_tax.
          ls_response-net_value = ls_response-total_debit_note  + ls_response-tds_amount.
          DATA lv_amount TYPE string.
          lv_amount = ls_response-net_value.
          CONDENSE  lv_amount.
          DATA(lo_amount) = NEW zz_amount_in_words(  ).
*          ls_response-amount_in_words =  lo_amount->num2words(
*          EXPORTING iv_num  = lv_amount



          CALL METHOD lo_amount->num2words(
            EXPORTING
              iv_num   = lv_amount
            RECEIVING
              rv_words = ls_response-amount_in_words ).
            ls_response-fiscalyear = lv_fiscal_year.
              APPEND ls_response to lt_response.

          io_response->set_data( lt_response ).
          io_response->set_total_number_of_records( lines( lt_response ) ).

        ENDIF.

      WHEN 'ZCE_VENDOR_DEBIT_FORM_ITEM'.

        IF io_request->is_data_requested( ).



          SELECT ledgergllineitem, product ,quantity,baseunit ,amountincompanycodecurrency,
          PurchasingDocument, PurchasingDocumentItem

          FROM i_journalentryitem
           WITH PRIVILEGED ACCESS
           WHERE accountingdocument = @lv_acc_no
           AND fiscalyear = @lv_fiscal_year
           AND ( transactiontypedetermination = 'WRX' OR transactiontypedetermination
           = 'BSX' )
           INTO TABLE @DATA(lt_item).

          IF sy-subrc = 0.
            SELECT product, plant, consumptiontaxctrlcode FROM i_productplantbasic
            FOR ALL ENTRIES IN @lt_item
            WHERE product  = @lt_item-product
            AND Plant  = '1101'
            INTO TABLE @DATA(lt_productplantbasic).

            SELECT * FROM   i_producttext
            FOR ALL ENTRIES IN @lt_item
            WHERE product  = @lt_item-product
            AND language = @sy-langu
            INTO TABLE @DATA(lt_product_text).

             SELECT SINGLE documentreferenceid
            FROM i_journalentry WITH PRIVILEGED ACCESS
            WHERE accountingdocument = @lv_acc_no
            AND fiscalyear = @lv_fiscal_year
            INTO @DATA(lv_doc_ref_id).

            SELECT PurchaseOrder ,PurchaseOrderItem, QuantityInPurchaseOrderUnit,
            PurchaseOrderQuantityUnit
            from I_SuplrInvcItemPurOrdRefAPI01 WITH PRIVILEGED ACCESS
            FOR ALL ENTRIES IN @lt_item
            WHERE SupplierInvoice = @lv_doc_ref_id
            AND FiscalYear = @lv_fiscal_year
            AND PurchaseOrder = @lt_item-PurchasingDocument
            AND PurchaseOrderItem = @lt_item-PurchasingDocumentItem
            INTO TABLE @data(lt_supplier_invoice).

          ENDIF.

          LOOP AT lt_item INTO DATA(lw_item).
            ls_response_i-accountingdocument = lv_acc_no.
            ls_response_i-fiscalyear = lv_fiscal_year.
            ls_response_i-item = lw_item-ledgergllineitem.
            READ TABLE lt_supplier_invoice INTO data(lw_supplier_invoice)
            WITH key PurchaseOrder = lw_item-PurchasingDocument
            PurchaseOrderItem = lw_item-PurchasingDocumentItem.
            if sy-subrc = 0.
            ls_response_i-quantity = lw_supplier_invoice-QuantityInPurchaseOrderUnit.
            ls_response_i-unit = lw_supplier_invoice-PurchaseOrderQuantityUnit.
            ENDIF.

            ls_response_i-value = lw_item-AmountInCompanyCodeCurrency * -1.
            if lw_item-quantity  is NOT INITIAL.
            ls_response_i-rate =  ( lw_item-AmountInCompanyCodeCurrency / lw_item-quantity ) .
            ENDIF.
            ls_response_i-hsn = VALUE #( lt_productplantbasic[ product = lw_item-product  ]-consumptiontaxctrlcode  OPTIONAL ).
            ls_response_i-description = VALUE #( lt_product_text[ product = lw_item-product  ]-productname  OPTIONAL ).
            APPEND ls_response_i TO lt_response_i.
            CLEAR : ls_response_i.
          ENDLOOP.

          io_response->set_total_number_of_records( lines( lt_response_i ) ).
          io_response->set_data( lt_response_i ).

        ENDIF.
    ENDCASE.



  ENDMETHOD.
ENDCLASS.
