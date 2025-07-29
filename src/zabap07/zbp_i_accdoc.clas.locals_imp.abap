CLASS lhc_ziaccdoc DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ziaccdoc RESULT result.

*    METHODS postdoc ."FOR MODIFY IMPORTING keys FOR ACTION ziaccdoc~postdoc RESULT result.


*    METHODS postdoc FOR DETERMINE ON SAVE
*      IMPORTING keys FOR ziaccdoc~postdoc.

ENDCLASS.

CLASS lhc_ziaccdoc IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD postdoc.
*
*    DATA: lt_doc_h        TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post,
*          lv_cid          TYPE abp_behv_cid,
*          ls_doc_h        LIKE LINE OF lt_doc_h,
*          ls_glitem       LIKE LINE OF ls_doc_h-%param-_glitems,
*          ls_glcurrency   LIKE LINE OF ls_glitem-_currencyamount,
*          ls_aritem       LIKE LINE OF ls_doc_h-%param-_aritems, "customer
*          ls_custcurrency LIKE LINE OF ls_aritem-_currencyamount,
*          ls_apitem       LIKE LINE OF ls_doc_h-%param-_apitems, "vendor
*          ls_vencurrency  LIKE LINE OF ls_apitem-_currencyamount,
*          lv_docid(10)    TYPE c,
*          lt_temp_key     TYPE zgje_transaction_handler=>tt_temp_key,
*          ls_temp_key     LIKE LINE OF lt_temp_key.
*
*    DATA : update_lines TYPE TABLE FOR UPDATE zi_so\\ziso,
*           update_line  TYPE STRUCTURE FOR UPDATE zi_so\\ziso.
*
*
*
*    READ ENTITIES OF zi_accdoc IN LOCAL MODE
*        ENTITY ziaccdoc
*          ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(members).
*
*    DATA(lt_keys) = keys.
*
*    SORT members BY docid.
*
*    SELECT * FROM zc_accdoc
**     WHERE belnr IS INITIAL
*     INTO TABLE @DATA(it_doc).
*
*
**    TRY.
**        lv_cid = to_upper( cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ) ).
**      CATCH cx_uuid_error.
**        ASSERT 1 = 0.
**    ENDTRY.
*
*    DATA: lv_buzei TYPE i.
*
*    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs_member>).
*
*      lv_cid = <fs_member>-id.
**      IF lv_docid <> <fs>-docid.
**        lv_docid = <fs>-docid.
**
**        LOOP AT it_doc ASSIGNING FIELD-SYMBOL(<fs_member>) WHERE docid = lv_docid.
*
*
*      IF <fs_member>-hkont IS NOT INITIAL.
*        lv_buzei = lv_buzei + 1.
*        ls_glitem-glaccountlineitem = lv_buzei.         ls_glitem-%control-glaccountlineitem = if_abap_behv=>mk-on.
*        ls_glitem-glaccount         = <fs_member>-hkont.ls_glitem-%control-glaccount = if_abap_behv=>mk-on.
**            ls_glitem-costcenter        = <fs_member>-kostl.ls_glitem-%control-costcenter = if_abap_behv=>mk-on.
**            ls_glitem-profitcenter      = <fs_member>-prctr.ls_glitem-%control-profitcenter = if_abap_behv=>mk-on.
*        ls_glitem-housebank = <fs_member>-bank.       ls_glitem-%control-housebank = if_abap_behv=>mk-on.
*        ls_glitem-housebankaccount = <fs_member>-hbkid.   ls_glitem-%control-housebankaccount = if_abap_behv=>mk-on.
*
*
*        ls_glcurrency-journalentryitemamount = <fs_member>-dmbtr.ls_glcurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
*        ls_glcurrency-currency = <fs_member>-waers.             ls_glcurrency-%control-currency = if_abap_behv=>mk-on.
*        ls_glcurrency-currencyrole = '00'.                      ls_glcurrency-%control-currencyrole = if_abap_behv=>mk-on.
*
*        APPEND ls_glcurrency TO ls_glitem-_currencyamount.
*        APPEND ls_glitem TO ls_doc_h-%param-_glitems.
*      ENDIF.
*
*
*      IF <fs_member>-kunnr IS NOT INITIAL.
*        lv_buzei = lv_buzei + 1.
*        ls_aritem-glaccountlineitem = lv_buzei. ls_aritem-%control-glaccountlineitem = if_abap_behv=>mk-on.
*        ls_aritem-customer = <fs_member>-kunnr. ls_aritem-%control-customer = if_abap_behv=>mk-on.
*        ls_aritem-specialglcode     = <fs_member>-umskz.ls_aritem-%control-specialglcode = if_abap_behv=>mk-on.
**            ls_aritem-businessplace = <fs_member>-bupla.
*
*
*        ls_custcurrency-journalentryitemamount = <fs_member>-wrbtr * -1.ls_custcurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
*        ls_custcurrency-currency = <fs_member>-waers.ls_custcurrency-%control-currency = if_abap_behv=>mk-on.
*        ls_custcurrency-currencyrole = '00'.         ls_custcurrency-%control-currencyrole = if_abap_behv=>mk-on.
*
*        APPEND ls_custcurrency TO ls_aritem-_currencyamount.
*        APPEND ls_aritem TO ls_doc_h-%param-_aritems.
*      ENDIF.
*
*
*      IF <fs_member>-lifnr IS NOT INITIAL.
*        lv_buzei = lv_buzei + 1.
*        ls_apitem-glaccountlineitem = lv_buzei. ls_apitem-%control-glaccountlineitem = if_abap_behv=>mk-on.
*        ls_apitem-supplier = <fs_member>-lifnr. ls_apitem-%control-supplier = if_abap_behv=>mk-on.
*        ls_apitem-specialglcode = <fs_member>-umskz. ls_apitem-%control-specialglcode = if_abap_behv=>mk-on.
**            ls_apitem-businessplace = <fs_member>-bupla.
*
*        ls_vencurrency-journalentryitemamount = <fs_member>-wrbtr * -1. ls_vencurrency-%control-journalentryitemamount = if_abap_behv=>mk-on.
*        ls_vencurrency-currency = <fs_member>-waers.  ls_vencurrency-%control-currency = if_abap_behv=>mk-on.
*
*
*        APPEND ls_custcurrency TO ls_aritem-_currencyamount.
*        APPEND ls_apitem TO ls_doc_h-%param-_apitems.
*
*      ENDIF.
*
*      CLEAR: ls_aritem, ls_glcurrency, ls_custcurrency, ls_vencurrency.
**        ENDLOOP.
*
*      ls_doc_h-%cid = lv_cid.
*      ls_doc_h-%param-companycode = <fs_member>-bukrs.
*      ls_doc_h-%param-documentreferenceid = 'BKPFF'.
*      ls_doc_h-%param-createdbyuser = sy-uname.
*      ls_doc_h-%param-businesstransactiontype = 'RFBU'.
*      ls_doc_h-%param-accountingdocumenttype = <fs_member>-blart.
*      ls_doc_h-%param-documentdate = <fs_member>-bldat.
*      ls_doc_h-%param-postingdate = <fs_member>-budat.
*      ls_doc_h-%param-accountingdocumentheadertext = <fs_member>-bktxt.
*
*      ls_doc_h-%param-%control-companycode = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-documentreferenceid = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-createdbyuser = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-businesstransactiontype = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-accountingdocumenttype = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-documentdate = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-postingdate = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-accountingdocumentheadertext = if_abap_behv=>mk-on.
*      ls_doc_h-%param-%control-documentreferenceid = if_abap_behv=>mk-on.
*
*      APPEND ls_doc_h TO lt_doc_h.
*
*
*
**        ----------Hard Code format-----
**      DATA: lt_je_deep TYPE TABLE FOR ACTION IMPORT i_journalentrytp~post.
**      APPEND INITIAL LINE TO lt_je_deep ASSIGNING FIELD-SYMBOL(<je_deep>).
**
**      <je_deep>-%cid = lv_cid.
**      <je_deep>-%param = VALUE #(
**                              companycode = '1000' " Success
**                              documentreferenceid = 'BKPFF'
**                              createdbyuser = 'TEST'
**                              businesstransactiontype = 'RFBU'
**                              accountingdocumenttype = 'DZ'
**                              documentdate = sy-datum
**                              postingdate = sy-datum
**                              accountingdocumentheadertext = 'Journal entry'
**                              _glitems = VALUE #( ( glaccountlineitem = |001|
**                                                  glaccount = '0000142001'
**                                                  housebank = 'BOM01'
**                                                  housebankaccount = '0519'
**                                                  _currencyamount = VALUE #( ( currencyrole = '00'
**                                                          journalentryitemamount = '1000.00'
**                                                          currency = 'INR' ) ) ) )
**                              _aritems = VALUE #( ( customer = '0060000006'
**                                                          glaccountlineitem = |002|
**                                                          specialglcode = 'A'
***                                                        SalesOrder = ''
**                                                          _currencyamount = VALUE #( ( currencyrole = '00'
**                                                                                      journalentryitemamount = '-1000.00'
**                                                                                      currency = 'INR' ) ) ) ) ).
**        ----------Hardcode Format-----
*
*
*      IF lt_doc_h IS NOT INITIAL. "lt_je_deep
*
*        MODIFY ENTITIES OF i_journalentrytp
*            ENTITY journalentry
*            EXECUTE post FROM lt_doc_h
*            FAILED FINAL(ls_failed_deep)
*            REPORTED FINAL(ls_reported_deep)
*            MAPPED FINAL(ls_mapped_deep).
*
**        zbp_i_accdoc=>mapped_accdoc-journalentry = ls_mapped_deep-journalentry.
*
*        IF ls_failed_deep IS NOT INITIAL.
*          LOOP AT ls_failed_deep-journalentry INTO DATA(ls_report).
*            APPEND VALUE #( id = ls_report-%cid
*                            %create = if_abap_behv=>mk-on
**                          %is_draft = if_abap_behv=>mk-on
**                          %msg = ls_report-%fail
*                            ) TO reported-ziaccdoc.
*          ENDLOOP.
*        ENDIF.
*
*        LOOP AT ls_mapped_deep-journalentry INTO DATA(ls_je_mapped).
*          ls_temp_key-cid = ls_je_mapped-%cid.
*          ls_temp_key-pid = ls_je_mapped-%pid.
*          APPEND ls_temp_key TO lt_temp_key.
*        ENDLOOP.
*
*
*        zgje_transaction_handler=>get_instance( )->set_temp_key( lt_temp_key ).
*
*        CLEAR: lt_doc_h[], ls_doc_h.
*      ENDIF.
*
**      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.


ENDCLASS.

*CLASS lsc_zi_accdoc DEFINITION INHERITING FROM cl_abap_behavior_saver.
*  PROTECTED SECTION.

*    METHODS save_modified REDEFINITION.

*    METHODS cleanup_finalize REDEFINITION.

*ENDCLASS.

**CLASS lsc_zi_accdoc IMPLEMENTATION.

**  METHOD save_modified.

**    DATA: ls_doc_temp_key TYPE STRUCTURE FOR KEY OF i_journalentrytp.
**    DATA : lt_zfit_accdoc           TYPE STANDARD TABLE OF zfit_accdoc,
**           lt_zfit_accdoc_del       TYPE STANDARD TABLE OF zfit_accdoc,
**           lt_zfit_new              TYPE STANDARD TABLE OF zfit_accdoc,
**           ls_zfit_accdoc           TYPE                   zfit_accdoc,
**           lt_zfit_accdoc_x_control TYPE STANDARD TABLE OF zfit_accdoc_x,
**           lr_id                    TYPE RANGE OF zfit_accdoc-id.
**
**    IF create IS NOT INITIAL.
**      CLEAR lt_zfit_accdoc.
**      lt_zfit_accdoc = CORRESPONDING #( create-ziaccdoc MAPPING FROM ENTITY ).
**    ENDIF.
**
**    IF delete IS NOT INITIAL.
**      lt_zfit_accdoc_del = CORRESPONDING #( delete-ziaccdoc MAPPING FROM ENTITY ).
**    ENDIF.
**
**
**    zgje_transaction_handler=>get_instance( )->additional_save( it_create = lt_zfit_accdoc
**                                                                it_delete = lt_zfit_accdoc_del ).
**
**
**    IF update IS NOT INITIAL.
**      CLEAR lt_zfit_accdoc.
**      lt_zfit_accdoc = CORRESPONDING #( update-ziaccdoc  ).
**      lt_zfit_accdoc_x_control = CORRESPONDING #( update-ziaccdoc MAPPING FROM ENTITY USING CONTROL ).
**
**      lr_id = VALUE #( FOR ls_id IN update-ziaccdoc
**                        (  sign = 'I' option = 'EQ' low = ls_id-id ) ).
**      SELECT *
**        FROM zfit_accdoc
**        WHERE id IN @lr_id
**        INTO TABLE @DATA(lt_acc_old).
**
**
**      "Prepare DB Table to update
**      lt_zfit_new = VALUE #(
**                            FOR x = 1 WHILE x <= lines( lt_zfit_accdoc )
**                            LET
**                            ls_controlflag = VALUE #( lt_zfit_accdoc_x_control[ x ] OPTIONAL )
**                            ls_acc_upd = VALUE #( lt_zfit_accdoc[ x ] OPTIONAL )
**                            ls_acc_old = VALUE #( lt_acc_old[ id = ls_acc_upd-id ] OPTIONAL )
**                            IN
**                            (
**                            id   = ls_acc_old-id
**                            "Update other columns, if found controlflag as X - else pass DB values
**                            docid = COND #( WHEN ls_controlflag-docid IS NOT INITIAL THEN ls_acc_upd-docid ELSE ls_acc_old-docid )
**                            belnr = COND #( WHEN ls_controlflag-belnr IS NOT INITIAL THEN ls_acc_upd-belnr ELSE ls_acc_old-belnr )
**                            bukrs = COND #( WHEN ls_controlflag-bukrs IS NOT INITIAL THEN ls_acc_upd-bukrs ELSE ls_acc_old-bukrs )
**                            gjahr = COND #( WHEN ls_controlflag-gjahr IS NOT INITIAL THEN ls_acc_upd-gjahr ELSE ls_acc_old-gjahr )
**                            blart = COND #( WHEN ls_controlflag-blart IS NOT INITIAL THEN ls_acc_upd-blart ELSE ls_acc_old-blart )
**                            bldat = COND #( WHEN ls_controlflag-bldat IS NOT INITIAL THEN ls_acc_upd-bldat ELSE ls_acc_old-bldat )
**                            budat = COND #( WHEN ls_controlflag-budat IS NOT INITIAL THEN ls_acc_upd-budat ELSE ls_acc_old-budat )
**                            waers = COND #( WHEN ls_controlflag-waers IS NOT INITIAL THEN ls_acc_upd-waers ELSE ls_acc_old-waers )
**                            bupla = COND #( WHEN ls_controlflag-bupla IS NOT INITIAL THEN ls_acc_upd-bupla ELSE ls_acc_old-bupla )
**                            secco = COND #( WHEN ls_controlflag-secco IS NOT INITIAL THEN ls_acc_upd-secco ELSE ls_acc_old-secco )
**                            xblnr = COND #( WHEN ls_controlflag-xblnr IS NOT INITIAL THEN ls_acc_upd-xblnr ELSE ls_acc_old-xblnr )
**                            bktxt = COND #( WHEN ls_controlflag-bktxt IS NOT INITIAL THEN ls_acc_upd-bktxt ELSE ls_acc_old-bktxt )
**                            hkont = COND #( WHEN ls_controlflag-hkont IS NOT INITIAL THEN ls_acc_upd-hkont ELSE ls_acc_old-hkont )
**                            dmbtr = COND #( WHEN ls_controlflag-dmbtr IS NOT INITIAL THEN ls_acc_upd-dmbtr ELSE ls_acc_old-dmbtr )
**                            wrbtr = COND #( WHEN ls_controlflag-wrbtr IS NOT INITIAL THEN ls_acc_upd-wrbtr ELSE ls_acc_old-wrbtr )
**                            shkzg = COND #( WHEN ls_controlflag-shkzg IS NOT INITIAL THEN ls_acc_upd-shkzg ELSE ls_acc_old-shkzg )
**                            kostl = COND #( WHEN ls_controlflag-kostl IS NOT INITIAL THEN ls_acc_upd-kostl ELSE ls_acc_old-kostl )
**                            prctr = COND #( WHEN ls_controlflag-prctr IS NOT INITIAL THEN ls_acc_upd-prctr ELSE ls_acc_old-prctr )
**                            mwskz = COND #( WHEN ls_controlflag-mwskz IS NOT INITIAL THEN ls_acc_upd-mwskz ELSE ls_acc_old-mwskz )
**                            bank = COND #( WHEN ls_controlflag-bank IS NOT INITIAL THEN ls_acc_upd-bank ELSE ls_acc_old-bank )
**                            hbkid = COND #( WHEN ls_controlflag-hbkid IS NOT INITIAL THEN ls_acc_upd-hbkid ELSE ls_acc_old-hbkid )
**                            kunnr = COND #( WHEN ls_controlflag-kunnr IS NOT INITIAL THEN ls_acc_upd-kunnr ELSE ls_acc_old-kunnr )
**                            lifnr = COND #( WHEN ls_controlflag-lifnr IS NOT INITIAL THEN ls_acc_upd-lifnr ELSE ls_acc_old-lifnr )
**                            umskz = COND #( WHEN ls_controlflag-umskz IS NOT INITIAL THEN ls_acc_upd-umskz ELSE ls_acc_old-umskz )
**
**)  ).
**
**      MODIFY zfit_accdoc FROM TABLE @lt_zfit_new.
**    ENDIF.



*    IF zbp_i_accdoc=>mapped_accdoc-journalentry IS NOT INITIAL.
*      LOOP AT zbp_i_accdoc=>mapped_accdoc-journalentry ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
*
*        CONVERT KEY OF i_journalentrytp FROM ls_doc_temp_key TO DATA(ls_doc_final_key).
*
*        <fs_pr_mapped>-accountingdocument = ls_doc_final_key-accountingdocument.
*        <fs_pr_mapped>-companycode = ls_doc_final_key-fiscalyear.
*        <fs_pr_mapped>-fiscalyear = ls_doc_final_key-fiscalyear.
*
*        LOOP AT update-ziaccdoc INTO  DATA(ls_doc).
*          UPDATE zfit_accdoc SET belnr = @ls_doc_final_key-accountingdocument WHERE docid = @ls_doc-docid.
*        ENDLOOP.
*      ENDLOOP.
*    ENDIF.

*    IF delete IS NOT INITIAL.
*      lt_zfit_accdoc_del = CORRESPONDING #( delete-ziaccdoc MAPPING FROM ENTITY ).
*      LOOP AT   lt_zfit_accdoc_del INTO ls_zfit_accdoc.
*        DELETE  FROM zfit_accdoc  WHERE  id = @ls_zfit_accdoc-id.
*      ENDLOOP.
*    ENDIF.


*  ENDMETHOD.

*  METHOD cleanup_finalize.
*    zgje_transaction_handler=>get_instance( )->clean_up( ).
*  ENDMETHOD.

**ENDCLASS.
