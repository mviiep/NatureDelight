CLASS zcl_milk_collection_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MILK_COLLECTION_FORM IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
    IF io_request->is_data_requested( ).
      DATA: lt_response   TYPE TABLE OF zce_milk_collection_form,
            ls_response   TYPE zce_milk_collection_form,
            lt_response_i TYPE TABLE OF zce_milk_coll_form_item,
            ls_response_i TYPE zce_milk_coll_form_item.
*      ls_response-Rate_difference = 1000.
*      ls_response_i-rate_difference = 20000.
      DATA(lv_top)           = io_request->get_paging( )->get_page_size( ).
      DATA(lv_skip)          = io_request->get_paging( )->get_offset( ).
      DATA(lt_clause)        = io_request->get_filter( )->get_as_sql_string( ).
      DATA(lt_fields)        = io_request->get_requested_elements( ).
      DATA(lt_sort)          = io_request->get_sort_elements( ).
      DATA lv_fr_date TYPE c LENGTH 25.
      DATA lv_to_date TYPE c LENGTH 25.

      TRY.
          DATA(lt_filter_cond) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
          DATA(lv_m) = lx_no_sel_option->get_longtext(   ).
      ENDTRY.
      DATA(lr_miro_no)  =  VALUE  #( lt_filter_cond[ name   = 'MIRODOC' ]-range OPTIONAL ).
      DATA(lr_miro_year)  =  VALUE  #( lt_filter_cond[ name   = 'MIRO_YEAR' ]-range OPTIONAL ).
      DATA(lr_miroyear)  =  VALUE  #( lt_filter_cond[ name   = 'MIROYEAR' ]-range OPTIONAL ).
      DATA(lv_miro_year)  = VALUE gjahr( lr_miro_year[ 1 ]-low OPTIONAL ).
      DATA(lv_miroyear)  = VALUE gjahr( lr_miroyear[ 1 ]-low OPTIONAL ).

      DATA(lv_miro_no)  = VALUE re_belnr( lr_miro_no[ 1 ]-low OPTIONAL ).


      SELECT * FROM  zmm_milkcoll
      WHERE miro_year = @lv_miro_year
      AND mirodoc = @lv_miro_no
      INTO TABLE @DATA(lt_milk_coll).
      SORT lt_milk_coll BY coll_date.
      LOOP AT lt_milk_coll ASSIGNING FIELD-SYMBOL(<fs_milk_coll>). "s







        AT FIRST.
          ls_response-mirodoc = <fs_milk_coll>-mirodoc.
          ls_response-miro_year = <fs_milk_coll>-miro_year.
          ls_response-milk_type  = <fs_milk_coll>-milk_type.
          lv_fr_date = <fs_milk_coll>-coll_date.
          CONDENSE lv_fr_date.
          ls_response-from_date = lv_fr_date+0(8).
          IF ls_response-from_date+6(2) BETWEEN 01 AND 10.
            ls_response-from_date+6(2) = '01'.
            ls_response-to_date = ls_response-from_date.
            ls_response-to_date+6(2) = '10'.
          ELSEIF ls_response-from_date+6(2) BETWEEN 11 AND 20.
            ls_response-from_date+6(2) = '11'.
            ls_response-to_date = ls_response-from_date.
            ls_response-to_date+6(2) = '20'.
          ELSE.
            ls_response-from_date+6(2) = '21'.
            CASE ls_response-from_date+4(2).
              WHEN '01' OR '03'  OR'05' OR '07'  OR '08'  OR '10' OR '12' .
                ls_response-to_date = ls_response-from_date.
                ls_response-to_date+6(2) = 31.
              WHEN '02'.
                ls_response-to_date = ls_response-from_date.
                IF ( ls_response-to_date+0(4) MOD 4 ) = 0.
                  ls_response-to_date = ls_response-from_date.
                  ls_response-to_date+6(2) = 29.
                ELSE.
                  ls_response-to_date = ls_response-from_date.
                  ls_response-to_date+6(2) = 28.
                ENDIF.
              WHEN OTHERS.
                ls_response-to_date = ls_response-from_date.
                ls_response-to_date+6(2) = 30.

            ENDCASE.
          ENDIF.
          ls_response-lifnr     = <fs_milk_coll>-lifnr.
          ls_response-supplier_name = <fs_milk_coll>-name1.

          ls_response-lgort  = <fs_milk_coll>-sloc.
        ENDAT.

        SELECT SINGLE materialdocument FROM i_materialdocumentitem_2
           WHERE reversedmaterialdocument = @<fs_milk_coll>-mblnr
           AND   reversedmaterialdocumentyear = @<fs_milk_coll>-mjahr
           INTO @DATA(lv_revdoc).
        IF  lv_revdoc IS  INITIAL.


          ls_response-total_qty = ls_response-total_qty + <fs_milk_coll>-milk_qty.
          DATA : lv_milk_coll_amount TYPE p DECIMALS 2,
                 lv_rate_diff_1      TYPE p DECIMALS 2,
                 lv_rate_diff_2      TYPE p DECIMALS 2,
                 lv_rate_diff_3      TYPE p DECIMALS 2.
          CLEAR : lv_milk_coll_amount,lv_rate_diff_1,lv_rate_diff_2,lv_rate_diff_3.
*          lv_milk_coll_amount = ( <fs_milk_coll>-milk_qty * <fs_milk_coll>-rate  ).
*          lv_milk_coll_amount = floor( lv_milk_coll_amount  ).
          lv_milk_coll_amount =
          ( <fs_milk_coll>-milk_qty * <fs_milk_coll>-incentive )  + ( <fs_milk_coll>-base_rate * <fs_milk_coll>-milk_qty )  +
           ( <fs_milk_coll>-transport * <fs_milk_coll>-milk_qty  ) + ( <fs_milk_coll>-commision * <fs_milk_coll>-milk_qty  )
                                .
          lv_milk_coll_amount = floor( lv_milk_coll_amount  ).
          ls_response-milk_amount = ls_response-milk_amount + lv_milk_coll_amount.

          ls_response-rate_diff_a = ls_response-rate_diff_a +  floor( ( <fs_milk_coll>-incentive * <fs_milk_coll>-milk_qty  ) ).
          ls_response-rate_diff_b = ls_response-rate_diff_b + floor( ( <fs_milk_coll>-commision * <fs_milk_coll>-milk_qty   ) ) .
          ls_response-rate_diff_c = ls_response-rate_diff_c + floor( ( <fs_milk_coll>-transport * <fs_milk_coll>-milk_qty ) ).
*        Total Basic amount
          ls_response-total_additions = ls_response-total_additions +  floor( ( <fs_milk_coll>-base_rate * <fs_milk_coll>-milk_qty ) ).

        ENDIF.

        AT LAST .

*          ls_response-to_date = lv_to_date+0(8).


*          lv_milk_coll_amount = ls_response-milk_amount.
*          ls_response-milk_amount = lv_milk_coll_amount.
          ls_response-milk_amount1 =  ls_response-milk_amount.
*          ls_response-total_additions = ls_response-rate_diff_a + ls_response-rate_diff_b +
*          ls_response-rate_diff_c.
          ls_response-sub_total =  ls_response-milk_amount1 + ls_response-total_additions.
          ls_response-total_gross = ls_response-milk_amount + ls_response-total_additions.

        ENDAT.


        CLEAR : lv_revdoc.
      ENDLOOP.


**********************************************************************


      SELECT SUM( qty ) AS qty,
      SUM( avg_fat ) AS avg_fat,
      SUM( avg_snf ) AS avg_snf,
      SUM( total_amt ) AS total_amt,
      milk_type
      FROM Zi_mm_milkcoll_sum
      WHERE mirodoc = @lv_miro_no
      AND miro_year = @lv_miro_year
      GROUP BY milk_type
      INTO TABLE @DATA(it_tab).

      SELECT COUNT( * )
      FROM zmm_milkcoll
      WHERE mirodoc = @lv_miro_no
      AND miro_year = @lv_miro_year
      AND milk_type = 'C'
      INTO @DATA(count_C).

      SELECT COUNT( * )
      FROM zmm_milkcoll
      WHERE mirodoc = @lv_miro_no
      AND miro_year = @lv_miro_year
      AND milk_type = 'B'
      INTO @DATA(count_B).

      ls_response-cm_qty = VALUE #( it_tab[ milk_type = 'C' ]-qty OPTIONAL ).
      ls_response-bm_qty = VALUE #( it_tab[ milk_type = 'B' ]-qty OPTIONAL ).

      IF count_C IS NOT INITIAL.
        ls_response-cm_fat =  VALUE #( it_tab[ milk_type = 'C' ]-avg_fat OPTIONAL ) / count_C.
        ls_response-cm_snf =  VALUE #( it_tab[ milk_type = 'C' ]-avg_snf OPTIONAL ) / count_C.
      ENDIF.

      IF count_B IS NOT INITIAL.
        ls_response-bm_fat = VALUE #( it_tab[ milk_type = 'B' ]-avg_fat OPTIONAL ) / count_B.
        ls_response-bm_snf = VALUE #( it_tab[ milk_type = 'B' ]-avg_snf OPTIONAL ) / count_B.
      ENDIF.

      ls_response-cm_total = VALUE #( it_tab[ milk_type = 'C' ]-total_amt OPTIONAL ).
      ls_response-bm_total = VALUE #( it_tab[ milk_type = 'B' ]-total_amt OPTIONAL ).



**********************************************************************

      SELECT SINGLE banknumber,bankaccount FROM i_businesspartnerbank
      WITH PRIVILEGED ACCESS
      WHERE businesspartner = @ls_response-lifnr
      INTO @DATA(ls_bank_details).
      IF sy-subrc = 0.
        ls_response-account_no = ls_bank_details-bankaccount.
        ls_response-ifsc       = ls_bank_details-banknumber.
      ENDIF.

      SELECT SINGLE postingdate ,supplierinvoicewthnfiscalyear,invoicingparty FROM i_supplierinvoiceapi01
      WITH PRIVILEGED ACCESS
      WHERE supplierinvoice = @lv_miro_no
      AND  fiscalyear      = @lv_miro_year
      INTO @DATA(lw_supplier_data).

*      *******************************   Added by amit
      IF lw_supplier_data IS NOT INITIAL.

        SELECT SINGLE FiscalYear ,CalendarDate , FiscalYearVariant    FROM I_FiscalCalendarDate
        WITH PRIVILEGED ACCESS
        WHERE CalendarDate = @lw_supplier_data-PostingDate
       AND  FiscalYearVariant = 'V3'
       INTO @DATA(lw_fiscal).

      ENDIF.

*      ******************************


******************************
      SELECT CompanyCode , AccountingDocument , FiscalYear,AmountinCompanyCodeCurrency FROM  I_OperationalAcctgDocItem
      WITH PRIVILEGED ACCESS
      WHERE PostingDate = @lw_supplier_data-PostingDate
      AND Supplier = @ls_response-lifnr
      AND AccountingDocumentType = 'KM'
      AND AssignmentReference = @ls_response-lgort
      INTO TABLE @DATA(lw_opacc).

*    if lw_opacc is not initial.
*      SELECT AmountinCompanyCodeCurrency,AccountingDocument,GLAccount,DebitCreditCode      "#EC CI_NOWHERE
*      FROM I_OperationalAcctgDocItem
*      FOR ALL ENTRIES IN @lw_opacc
*      WHERE CompanyCode = @lw_opacc-CompanyCode
*      AND AccountingDocument = @lw_opacc-AccountingDocument
*      AND FiscalYear = @lw_opacc-FiscalYear
*      AND GLAccount IN ('0000401003', '0000401005', '0000281017', '0000414001')
*      INTO TABLE @DATA(tab_add).
*
*     endif.

      IF lw_opacc IS NOT INITIAL.

        SELECT FROM I_OperationalAcctgDocItem  AS o  "o~AmountinCompanyCodeCurrency, o~AccountingDocument, o~GLAccount, o~DebitCreditCode      "#EC CI_NOWHERE
        INNER JOIN @lw_opacc AS l
        ON o~CompanyCode = l~CompanyCode
        AND o~AccountingDocument = l~AccountingDocument
        AND o~FiscalYear = l~FiscalYear
        AND o~GLAccount IN ('0000401003', '0000401005', '0000281017', '0000414001', '0000271002')
        FIELDS o~AmountinCompanyCodeCurrency, o~AccountingDocument, o~GLAccount, o~DebitCreditCode
        INTO TABLE @DATA(tab_add).

*      SELECT AmountinCompanyCodeCurrency,AccountingDocument,GLAccount,DebitCreditCode      "#EC CI_NOWHERE
*      FROM I_OperationalAcctgDocItem
*      FOR ALL ENTRIES IN @lw_opacc
*      WHERE CompanyCode = @lw_opacc-CompanyCode
*      AND AccountingDocument = @lw_opacc-AccountingDocument
*      AND FiscalYear = @lw_opacc-FiscalYear
*      AND GLAccount IN ('0000401003', '0000401005', '0000281017', '0000414001')
*      INTO TABLE @DATA(tab_add).

      ENDIF.



      LOOP AT tab_add INTO DATA(ls_opacc_item).

        CASE ls_opacc_item-GLAccount.

          WHEN '0000401003'. "Rate Difference
            CASE ls_opacc_item-DebitCreditCode.
              WHEN 'S'.
                ls_response-Rate_difference_add = ls_opacc_item-AmountinCompanyCodeCurrency + ls_response-Rate_difference_add.
              WHEN 'H'.
                ls_response-Rate_difference_ded = ls_opacc_item-AmountinCompanyCodeCurrency + ls_response-Rate_difference_ded.
            ENDCASE.

          WHEN '0000401005'. "Transport
            CASE ls_opacc_item-DebitCreditCode.
              WHEN 'S'.
                ls_response-transport_add = ls_opacc_item-AmountinCompanyCodeCurrency + ls_response-transport_add.
              WHEN 'H'.
                ls_response-transport_ded = ls_opacc_item-AmountinCompanyCodeCurrency + ls_response-transport_ded.
            ENDCASE.

          WHEN '0000281017' OR '0000414001'. "Other
            IF ls_opacc_item-DebitCreditCode = 'S'.
              ls_response-other = ls_opacc_item-AmountinCompanyCodeCurrency + ls_response-other.
            ENDIF.

          WHEN '0000271002'. "TDS for KM Doc
            DATA(km_tds) = ls_opacc_item-amountincompanycodecurrency .

        ENDCASE.

      ENDLOOP.


*****************************



*      SELECT accountingdocument FROM
*      i_glaccountlineitem WITH PRIVILEGED ACCESS
*       WHERE "documentitemtext = @lv_miro_no
*       Supplier = @ls_response-lifnr
*       AND AssignmentReference =  @ls_response-lgort
*        AND accountingdocumenttype = 'KM'
*      AND PostingDate = @lv_posting_date
*      INTO TABLE @DATA(lt_acc_no).
*    if lt_acc_no[] is NOT INITIAL.
*      SELECT  accountingdocument,glaccount ,amountincompanycodecurrency
*      FROM i_glaccountlineitem WITH PRIVILEGED ACCESS
*      FOR ALL ENTRIES IN @lt_acc_no
*      WHERE AccountingDocument = @lt_acc_no-AccountingDocument
*      AND
*      financialaccounttype = 'S'
*      INTO TABLE @DATA(lt_gl_account).
*     endif.

      SELECT a~accountingdocument, a~postingdate, "b~accountingdocument,
      b~glaccount ,b~amountincompanycodecurrency, a~supplier ,b~supplier  AS sup2,b~DebitCreditCode
      FROM i_glaccountlineitem AS a
      JOIN i_glaccountlineitem AS b
      ON ( a~accountingdocument = b~accountingdocument )
      WHERE a~supplier = @ls_response-lifnr


        AND a~assignmentreference =  @ls_response-lgort
        AND a~accountingdocumenttype = 'KM'
        AND a~postingdate = @lw_supplier_data-postingdate
        AND b~PostingDate = @lw_supplier_data-postingdate
        AND a~FiscalYear  = @lw_fiscal-FiscalYear
*         AND a~FiscalYear  = '2024'
*        AND b~PostingDate = @lw_supplier_data-postingdate
        AND b~financialaccounttype = 'S'
      INTO TABLE @DATA(lt_gl_account).

      SELECT a~accountingdocument, "b~accountingdocument,
    b~glaccount ,b~amountincompanycodecurrency,a~supplier
    FROM i_glaccountlineitem AS a
    JOIN i_glaccountlineitem AS b
    ON ( a~accountingdocument = b~accountingdocument )
    WHERE a~supplier = @ls_response-lifnr
      AND b~Supplier = @ls_response-lifnr
      AND a~assignmentreference =  @ls_response-lgort
      AND a~accountingdocumenttype = 'KM'
      AND a~postingdate = @lw_supplier_data-postingdate
     AND  b~PostingDate = @lw_supplier_data-postingdate
     AND  a~FiscalYear  = @lw_fiscal-FiscalYear
*      AND  a~FiscalYear  = '2024'
      AND b~financialaccounttype = 'K'
      AND b~specialglcode = 'A'
      AND a~specialglcode = 'A'
    INTO TABLE @DATA(lt_gl_account_advance).

      SELECT SINGLE accountingdocument ,fiscalyear
      FROM i_journalentry
      WHERE originalreferencedocument = @lw_supplier_data-supplierinvoicewthnfiscalyear
      INTO @DATA(lw_journal_entry).
      IF sy-subrc = 0.
        SELECT  SINGLE amountincompanycodecurrency FROM i_glaccountlineitem
        WHERE accountingdocument = @lw_journal_entry-accountingdocument
        AND fiscalyear   = @lw_journal_entry-fiscalyear
        AND glaccount = '0000271002'
        AND accountingdocumenttype = 'RE'
        INTO @ls_response-tds.

        ls_response-tds = ls_response-tds + km_tds.

      ENDIF.
*      ls_response-tds = ls_response-tds * -1.
      DATA :lv_add_deduction TYPE i_glaccountlineitem-AmountInCompanyCodeCurrency.
      CLEAR :lv_add_deduction .
      LOOP AT lt_gl_account INTO DATA(lw_gl_account).


        CASE lw_gl_account-glaccount.
          WHEN '0000281001'.
            ls_response-ded_c_feed1 = ( lw_gl_account-amountincompanycodecurrency  ) + ls_response-ded_c_feed.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
          WHEN '0000281002'.
            ls_response-ded_c_feed2 = ( lw_gl_account-amountincompanycodecurrency  ) + ls_response-ded_c_feed.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
          WHEN '0000321008'.
            ls_response-ded_protine = ( lw_gl_account-amountincompanycodecurrency  ) + ls_response-ded_protine.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency ).
          WHEN '0000281003'.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
            ls_response-ded_patasanth    = ls_response-ded_patasanth + ( lw_gl_account-amountincompanycodecurrency ).
          WHEN  '0000172001'.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
            ls_response-ded_advance =         ls_response-ded_advance + ( lw_gl_account-amountincompanycodecurrency  ).
          WHEN '0000281017'  OR '0000414001'. "OR '0000401003'
            IF lw_gl_account-DebitCreditCode = 'H'.
              ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
              ls_response-ded_other = ( lw_gl_account-amountincompanycodecurrency ) + ls_response-ded_other.
            ENDIF.
*          WHEN '0000271002'.
*            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency * -1 ).
*            ls_response-tds = ( lw_gl_account-amountincompanycodecurrency * -1 ).
          WHEN '0000281016'.
            ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account-amountincompanycodecurrency  ).
            ls_response-ded_store =  ls_response-ded_store + ( lw_gl_account-amountincompanycodecurrency ).
*        WHEN '0000401005'.
*             lv_add_deduction = lv_add_deduction + lw_gl_account-amountincompanycodecurrency.
        ENDCASE.



      ENDLOOP.

      LOOP AT lt_gl_account_advance INTO DATA(lw_gl_account_advance).
*        ls_response-total_deductions =  ls_response-total_deductions +  ( lw_gl_account_advance-amountincompanycodecurrency  ).
        ls_response-ded_advance =   ls_response-ded_advance + ( lw_gl_account_advance-amountincompanycodecurrency ).
      ENDLOOP.



      ls_response-total_deductions = ls_response-total_deductions + ls_response-tds + ls_response-ded_advance + ls_response-Rate_difference_ded
      + ls_response-transport_ded.
      ls_response-net_amount = ls_response-milk_amount + ls_response-total_deductions + ( ls_response-Rate_difference_add + ls_response-transport_add + ls_response-other ).

      SELECT SINGLE businesspartnerpannumber  FROM i_supplier
      WITH PRIVILEGED ACCESS
      WHERE supplier = @ls_response-lifnr
      INTO @ls_response-pan.

      SELECT SINGLE storagelocationname
      FROM i_storagelocation
      WITH PRIVILEGED ACCESS
      WHERE storagelocation = @ls_response-lgort
      INTO @ls_response-lgort_name.

      SELECT * FROM zi_zmm_milkcoll

      WHERE mirodoc = @lv_miro_no
      AND miroyear = @lv_miroyear
      INTO   TABLE @DATA(lt_milk_coll_item).
      LOOP AT lt_milk_coll_item INTO DATA(lw_milk_coll_item).
        CLEAR : lv_revdoc ,ls_response_i.
        SELECT SINGLE materialdocument FROM i_materialdocumentitem_2
            WHERE reversedmaterialdocument = @lw_milk_coll_item-mblnr
            AND   reversedmaterialdocumentyear = @lw_milk_coll_item-mjahr
            INTO @lv_revdoc.
        IF sy-subrc = 0 AND lv_revdoc IS NOT INITIAL.
          CONTINUE.
        ENDIF.




        ls_response_i = CORRESPONDING #( lw_milk_coll_item ).
        ls_response_i-Milktype  = ls_response_i-Milktype.
        ls_response_i-Rate      = ls_response_i-baserate.
        ls_response_i-baserate  = ls_response_i-baserate * ls_response_i-milkqty.
        ls_response_i-baserate  = floor( ls_response_i-baserate ).
        ls_response_i-commision = ls_response_i-commision * ls_response_i-milkqty.
        ls_response_i-commision = floor( ls_response_i-commision ).
        ls_response_i-incentive = ls_response_i-incentive * ls_response_i-milkqty.
        ls_response_i-incentive = floor( ls_response_i-incentive ).
        ls_response_i-transport = ls_response_i-transport * ls_response_i-milkqty.
*       ls_response_i-total_amount = ls_response_i-rate * ls_response_i-MilkQty.
        ls_response_i-transport = Floor( ls_response_i-transport ).
        ls_response_i-total_amount = ls_response_i-baserate + ls_response_i-commision +
        ls_response_i-incentive +  ls_response_i-transport.
        ls_response_i-total_amount = floor( ls_response_i-total_amount ).
*        ls_response-Rate_difference = '12345'.
        APPEND ls_response_i TO lt_response_i.

      ENDLOOP.

      SORT lt_response_i BY CollDate ASCENDING Milktype DESCENDING.



      APPEND ls_response TO lt_response.
      CASE io_request->get_entity_id( ).
        WHEN 'ZCE_MILK_COLLECTION_FORM'.
          io_response->set_data( lt_response ).
          io_response->set_total_number_of_records( lines( lt_response ) ).

        WHEN 'ZCE_MILK_COLL_FORM_ITEM'.
          io_response->set_data( lt_response_i ).
          io_response->set_total_number_of_records( lines( lt_response_i ) ).

      ENDCASE.
*      io_response->set_data( lt_response ).
*      io_response->set_total_number_of_records( lines( lt_response ) ).

    ENDIF.
  ENDMETHOD.
ENDCLASS.
