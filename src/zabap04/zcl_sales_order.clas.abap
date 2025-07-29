CLASS zcl_sales_order DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES :if_oo_adt_classrun,
      if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_SALES_ORDER IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main .

*    DELETE from zsdt_so_header.
*    DELETE from zsdt_so_item.
*    DELETE from zsdt_so.


*    ---------Start: Journal entry ------------
    DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
          lv_cid     TYPE abp_behv_cid.
    TRY.
        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
      CATCH cx_uuid_error.
        ASSERT 1 = 0.
    ENDTRY.
    APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).

    <je_deep>-%cid = lv_cid.
    <je_deep>-%param = VALUE #(
                            companycode = '1000' " Success
                            documentreferenceid = 'BKPFF'
                            createdbyuser = 'TEST'
                            businesstransactiontype = 'RFBU'
                            accountingdocumenttype = 'DZ'
                            documentdate = sy-datum
                            postingdate = sy-datum
                            accountingdocumentheadertext = 'Journal entry'
                            _glitems = VALUE #( ( glaccountlineitem = |001|
                                                glaccount = '0000142001'
                                                HouseBank = 'BOM01'
                                                HouseBankAccount = '0519'
                                                _currencyamount = VALUE #( ( currencyrole = '00'
                                                        journalentryitemamount = '1000.00'
                                                        currency = 'INR' ) ) ) )
                            _aritems = VALUE #( ( customer = '0060000006'
                                                        glaccountlineitem = |002|
                                                        SpecialGLCode = 'A'
*                                                        SalesOrder = ''
                                                        _currencyamount = VALUE #( ( currencyrole = '00'
                                                                                    journalentryitemamount = '-1000.00'
                                                                                    currency = 'INR' ) )
                             ) )
                            ).
    MODIFY ENTITIES OF i_journalentrytp
    ENTITY journalentry
    EXECUTE post FROM lt_je_deep
    FAILED DATA(ls_failed_deep)
    REPORTED DATA(ls_reported_deep)
    MAPPED DATA(ls_mapped_deep).


    IF ls_failed_deep IS NOT INITIAL.
      LOOP AT ls_reported_deep-journalentry ASSIGNING FIELD-SYMBOL(<ls_reported_deep>).
        DATA(lv_result) = <ls_reported_deep>-%msg->if_message~get_text( ).
      ENDLOOP.
    ELSE.
      COMMIT ENTITIES BEGIN
      RESPONSE OF i_journalentrytp
      FAILED DATA(lt_commit_failed)
      REPORTED DATA(lt_commit_reported).

      COMMIT ENTITIES END.
    ENDIF.
*    ---------End: Journal entry ------------

*    ---------Start: Supplier invoice posting ------------

*    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
*    DATA lt_invoice TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create.
*
*    " The %cid (temporary primary key) has always to be supplied (is omitted in further examples)
*    TRY.
*        DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
*      CATCH cx_uuid_error.
*        "Error handling
*    ENDTRY.
*
*    ls_invoice-%cid = lv_cid.
*    ls_invoice-%param-supplierinvoiceiscreditmemo = abap_false.
*    ls_invoice-%param-companycode = '1010'.
*    ls_invoice-%param-invoicingparty = 'SUPPLIER'.
*    ls_invoice-%param-postingdate = '20210101'.
*    ls_invoice-%param-documentdate = '20210101'.
*    ls_invoice-%param-documentcurrency = 'EUR'.
*    ls_invoice-%param-invoicegrossamount = 100.
*    ls_invoice-%param-taxiscalculatedautomatically = abap_true.
*    ls_invoice-%param-supplierinvoiceidbyinvcgparty = 'INV0001'.
*
*    ls_invoice-%param-_glitems = VALUE #( ( supplierinvoiceitem = '000001'
*                                         debitcreditcode = cl_mmiv_rap_ext_c=>debitcreditcode-debit
*                                         glaccount = '0000400000'
*                                         companycode = '1010'
*                                         taxcode = 'V0'
*                                         documentcurrency = 'EUR'
*                                         supplierinvoiceitemamount = 100
*                                         costcenter = 'SAP-DUMMY' )
*                                        ).
*
*    INSERT ls_invoice INTO TABLE lt_invoice.
*
*    "Register the action
*    MODIFY ENTITIES OF i_supplierinvoicetp
*    ENTITY supplierinvoice
*    EXECUTE create FROM lt_invoice
*    FAILED DATA(ls_failed)
*    REPORTED DATA(ls_reported)
*    MAPPED DATA(ls_mapped).
*
*    IF ls_failed IS NOT INITIAL.
*      DATA lo_message TYPE REF TO if_message.
*      lo_message = ls_reported-supplierinvoice[ 1 ]-%msg.
*      "Error handling
*    ENDIF.
*
*    "Execution the action
*    COMMIT ENTITIES
*     RESPONSE OF i_supplierinvoicetp
*     FAILED DATA(ls_commit_failed)
*     REPORTED DATA(ls_commit_reported).
*
*    IF ls_commit_reported IS NOT INITIAL.
*      LOOP AT ls_commit_reported-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_invoice>).
*        IF <ls_invoice>-supplierinvoice IS NOT INITIAL AND
*        <ls_invoice>-supplierinvoicefiscalyear IS NOT INITIAL.
*          "Success case
*        ELSE.
*          "Error handling
*        ENDIF.
*      ENDLOOP.
*    ENDIF.
*
*    IF ls_commit_failed IS NOT INITIAL.
*      LOOP AT ls_commit_reported-supplierinvoice ASSIGNING <ls_invoice>.
*        "Error handling
*      ENDLOOP.
*    ENDIF.

*    ---------End: Supplier invoice posting ------------

*    ---------Start: Encyrtion ------------

*    TYPES: BEGIN OF ty_data,
*             username(10)               TYPE c,
*             password(10)               TYPE c,
*             appkey(50)                 TYPE c,
*             forcerefreshaccesstoken(4) TYPE c,
*           END OF ty_data.
*
*
*    DATA: it_data TYPE TABLE OF ty_data.
*
*    it_data = VALUE #( ( username = 'DIBAKAR'
*                        password = 'ABC4567890'
*                        appkey = 'ythderhcjnblksiytrfwhjcnbmnbvfrtyuiplkjhnbvcdswert'
*                        forcerefreshaccesstoken = 'true' ) ) .
*
*    READ TABLE it_data INTO DATA(wa_tran) INDEX 1.
*    DATA(lv_json) = /ui2/cl_json=>serialize( data      = wa_tran
*                                         compress      = abap_false
*                                         pretty_name   = /ui2/cl_json=>pretty_mode-camel_case  ).
*
*
*    DATA:
*      lv_data_xstr TYPE xstring,
*      lv_msg       TYPE xstring.
*
*    "Converting the data - From string format to xstring. You can use any other method or function module which converts the string to xstring format
*    lv_data_xstr = '7897HHUYU86SFD8D7G97GDFG9D7GD787BFD79D7F8VD7F7V9FD7V9D'
*
*
*
*    "Encrypt the data using the key
*    cl_sec_sxml_writer (
*      EXPORTING
*        plaintext =  lv_data_xstr
**        key       =  v_key
*        algorithm =  cl_sec_sxml_writer=>co_aes128_algorithm
*      IMPORTING
*        ciphertext = lv_msg ).


*    ---------End: Encyrtion ------------


  ENDMETHOD.


  METHOD  if_rap_query_provider~select.

*    -------Create sales order----
*    MODIFY ENTITIES OF i_salesordertp
*    ENTITY salesorder
*    CREATE
*       FIELDS ( salesordertype
*                salesorganization
*                distributionchannel
*                organizationdivision
*                soldtoparty )
*    WITH VALUE #( ( %cid = 'H001'
*    %data = VALUE #( salesordertype = 'TA'
*                     salesorganization = '1000'
*                     distributionchannel = '20'
*                     organizationdivision = '00'
*                     soldtoparty = '0001000011' ) ) )
*    CREATE BY \_item
*    FIELDS ( product
*    requestedquantity )
*    WITH VALUE #( ( %cid_ref = 'H001'
*                    salesorder = space
*                    %target = VALUE #( ( %cid = 'I001'
*                                        product = '000000000000000024'
*                                        requestedquantity = '10' )
*
*                                        ( %cid = 'I002'
*                                        product = '000000000000000054'
*                                        requestedquantity = '15' ) ) ) )
*    MAPPED DATA(ls_mapped)
*    FAILED DATA(ls_failed)
*    REPORTED DATA(ls_reported).
*
*    COMMIT ENTITIES
*      RESPONSE OF i_salesordertp
*       FAILED DATA(failed_commit)
*       REPORTED DATA(reported_commit).
*
*    READ ENTITIES OF i_salesordertp
*        ENTITY salesorder
*        FROM VALUE #( ( salesorder = space ) )
*        RESULT DATA(lt_so_head)
*        REPORTED DATA(ls_reported_read).


*    ------save in Z table-----

*    DATA: lt_so_header TYPE TABLE FOR CREATE zi_so_header,
*          lt_so_item   TYPE TABLE FOR CREATE zi_so_header\_item.
*
*    lt_so_item = VALUE #( ( %cid_ref = 'C1'
*                            vbeln = '2000000001'
*                            %target = VALUE #( ( %cid = 'ITEM01'
*                                            vbeln = '2000000001'
*                                            %control-vbeln = if_abap_behv=>mk-on
*                                            posnr = '10'
*                                            %control-posnr = if_abap_behv=>mk-on
*                                            matnr = 'MAT123'
*                                            %control-matnr = if_abap_behv=>mk-on
*                                            werks = '1100'
*                                            %control-werks = if_abap_behv=>mk-on
*                                           ) ) ) ).
*
*    lt_so_header = VALUE #( (  %cid = 'C1'
*                              vbeln = '2000000001'
*                              vkorg = '1000'
*                              vtweg = '10'
*                              spart = '11'
*                              kunnr = '1000011111'
*                              %control = VALUE #(
*                                         vbeln = if_abap_behv=>mk-on
*                                         vkorg = if_abap_behv=>mk-on
*                                         vtweg = if_abap_behv=>mk-on
*                                         spart = if_abap_behv=>mk-on
*                                         kunnr = if_abap_behv=>mk-on
*                                        ) ) ).
*
*
*    MODIFY ENTITIES OF zi_so_header
*     ENTITY _iheader
*     CREATE FROM lt_so_header
*     CREATE BY \_item    FROM lt_so_item
*     MAPPED DATA(it_mapped)
*     FAILED DATA(it_failed)
*     REPORTED DATA(it_reported).

*    DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
*    IF lv_top < 0.
*      lv_top = 1.
*    ENDIF.
*
*    DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
*
*    SELECT vbeln, vkorg, spart, vtweg, kunnr FROM zi_so_header
*    INTO TABLE @DATA(lt_so).
*
*    io_response->set_data( lt_so ).
*    IF io_request->is_total_numb_of_rec_requested(  ).
*      io_response->set_total_number_of_records( lines( lt_so ) ).
*    ENDIF.

  ENDMETHOD.
ENDCLASS.
