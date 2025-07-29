CLASS lhc_milkmiro DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR milkmiro RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR milkmiro RESULT result.

    METHODS createmiro FOR MODIFY
      IMPORTING keys FOR ACTION milkmiro~createmiro RESULT result.

ENDCLASS.

CLASS lhc_milkmiro IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD createmiro.

data :  update_lines   TYPE TABLE FOR UPDATE ZI_ZMM_MILKCOLL_miro\\MilkMiro,
        update_line    TYPE STRUCTURE FOR UPDATE ZI_ZMM_MILKCOLL_miro\\MilkMiro.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF zi_zmm_milkcoll_miro IN LOCAL MODE
      ENTITY MilkMiro
        FIELDS ( Lifnr Matnr MilkQty Milkuom Rate ebeln mblnr mjahr ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    DATA ls_invoice TYPE STRUCTURE FOR ACTION IMPORT i_supplierinvoicetp~create.
    DATA lt_invoice TYPE TABLE FOR ACTION IMPORT i_supplierinvoicetp~create.


    LOOP AT members INTO DATA(member) WHERE Mblnr is not initial
                                      AND   Mirodoc is INITIAL.

*  post Miro

    TRY.
     DATA(lv_cid) = cl_uuid_factory=>create_system_uuid( )->create_uuid_x16( ).
     CATCH cx_uuid_error.
     "Error handling
    ENDTRY.

    ls_invoice-%cid = lv_cid.
    ls_invoice-%param-supplierinvoiceiscreditmemo = abap_false.
    ls_invoice-%param-companycode = '1000'.
    ls_invoice-%param-invoicingparty = member-Lifnr.
    ls_invoice-%param-postingdate = cl_abap_context_info=>get_system_date(  ).
    ls_invoice-%param-documentdate = cl_abap_context_info=>get_system_date(  ).
    ls_invoice-%param-documentcurrency = 'INR'.
    ls_invoice-%param-invoicegrossamount = member-MilkQty * member-Rate.
    ls_invoice-%param-taxiscalculatedautomatically = abap_true.
    ls_invoice-%param-supplierinvoiceidbyinvcgparty = member-Lifnr.
    ls_invoice-%param-BusinessPlace = '1000'.
    ls_invoice-%param-BusinessSectionCode = '1000'.
    ls_invoice-%param-PaymentMethod = 'T'.
    ls_invoice-%param-TaxDeterminationDate = cl_abap_context_info=>get_system_date(  ).

    ls_invoice-%param-_itemswithporeference = VALUE #(
     ( supplierinvoiceitem = '000001'
     purchaseorder = member-ebeln
     purchaseorderitem = '00010'
     ReferenceDocument = member-mblnr
     ReferenceDocumentFiscalYear = member-mjahr
     ReferenceDocumentItem = '0001'
     documentcurrency = 'INR'
     supplierinvoiceitemamount = member-MilkQty * member-rate
     purchaseorderquantityunit = 'L'
     quantityinpurchaseorderunit = member-MilkQty
     taxcode = 'G0'
     )
     ).

     INSERT ls_invoice INTO TABLE lt_invoice.

    "Register the action
    MODIFY ENTITIES OF i_supplierinvoicetp
    ENTITY supplierinvoice
    EXECUTE Create from lt_invoice
    FAILED DATA(ls_failed)
    REPORTED DATA(ls_reported)
    MAPPED DATA(ls_mapped).

    IF ls_failed IS NOT INITIAL.
     DATA lo_message TYPE REF TO if_message.
     lo_message = ls_reported-supplierinvoice[ 1 ]-%msg.
          DATA(lv_result2) = lo_message->get_text( ).
     "Error handling
    ENDIF.

*    "Execution the action
*    COMMIT ENTITIES
*     RESPONSE OF i_supplierinvoicetp
*     FAILED DATA(ls_commit_failed)
*     REPORTED DATA(ls_commit_reported).
*
*    IF ls_commit_reported IS NOT INITIAL.
*     LOOP AT ls_commit_reported-supplierinvoice ASSIGNING FIELD-SYMBOL(<ls_invoice>).
*     IF <ls_invoice>-supplierinvoice IS NOT INITIAL AND
*     <ls_invoice>-supplierinvoicefiscalyear IS NOT INITIAL.
*     "Success case
*     ELSE.
*     "Error handling
*     ENDIF.
*     ENDLOOP.
*    ENDIF.

*    IF ls_commit_failed IS NOT INITIAL.
*     LOOP AT ls_commit_reported-supplierinvoice ASSIGNING <ls_invoice>.
*     "Error handling
*     ENDLOOP.
*    ENDIF.

 "retrieve the generated
    zbp_i_zmm_milkcoll_miro=>mapped_miro-supplierinvoice  = ls_mapped-supplierinvoice.

    "set a flag to check in the save sequence that purchase requisition has been created
    "the correct value for PurchaseRequisition has to be calculated in the save sequence using convert key
    LOOP AT keys INTO DATA(key).
      IF line_exists( members[ id = key-ID ] ).
*        update_line-DirtyFlag              = abap_true.
        update_line-%tky                   = key-%tky.
        update_line-Mirodoc                  = 'X'.
        APPEND update_line TO update_lines.
      ENDIF.
    ENDLOOP.

MODIFY ENTITIES OF zi_zmm_milkcoll_miro IN LOCAL MODE
      ENTITY MilkMiro
        UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
        FIELDS ( Mirodoc )
        WITH update_lines
      REPORTED reported
      FAILED failed
      MAPPED mapped.

    IF failed IS INITIAL.
      "Read the changed data for action result
      READ ENTITIES OF zi_zmm_milkcoll_miro IN LOCAL MODE
        ENTITY MilkMiro
          ALL FIELDS WITH
          CORRESPONDING #( keys )
        RESULT DATA(result_read).
      "return result entities
      result = VALUE #( FOR result_order IN result_read ( %tky   = result_order-%tky
                                                          %param = result_order ) ).
    ENDIF.

    endloop.

  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_zmm_milkcoll_miro DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_zmm_milkcoll_miro IMPLEMENTATION.

  METHOD cleanup_finalize.

  ENDMETHOD.

  METHOD save_modified.


    DATA : lt_zmm_milkcoll        TYPE STANDARD TABLE OF zmm_milkcoll,
           ls_zmm_milkcoll        TYPE                   zmm_milkcoll,
           lt_zmm_milkcoll_x_control TYPE STANDARD TABLE OF zmm_milkcoll.

*    IF create-milkcoll IS NOT INITIAL.
*      lt_zmm_milkcoll = CORRESPONDING #( create-milkcoll MAPPING FROM ENTITY ).
*      INSERT zmm_milkcoll FROM TABLE @lt_zmm_milkcoll.
*    ENDIF.
*
*    IF update IS NOT INITIAL.
*      CLEAR lt_zmm_milkcoll.
*      lt_zmm_milkcoll = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
*      lt_zmm_milkcoll_x_control = CORRESPONDING #( update-milkcoll MAPPING FROM ENTITY ).
*      MODIFY zmm_milkcoll FROM TABLE @lt_zmm_milkcoll.
*    ENDIF.
*    IF delete IS NOT INITIAL.
*      LOOP AT delete-milkcoll INTO DATA(milkcoll_delete).
*        DELETE FROM zmm_milkcoll WHERE id = @milkcoll_delete-ID.
*      ENDLOOP.
*    ENDIF.

 IF zbp_i_zmm_milkcoll_miro=>mapped_miro IS NOT INITIAL
  AND update IS NOT INITIAL.
    LOOP AT zbp_i_zmm_milkcoll_miro=>mapped_miro-supplierinvoice ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
      CONVERT KEY OF i_supplierinvoicetp FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
      <fs_pr_mapped>-SupplierInvoice = ls_pr_key-SupplierInvoice.
      <fs_pr_mapped>-SupplierInvoiceFiscalYear = ls_pr_key-SupplierInvoiceFiscalYear.
    ENDLOOP.
    LOOP AT update-milkmiro INTO  DATA(ls_milkmiro). " WHERE %control-OverallStatus = if_abap_behv=>mk-on.
      " Creates internal table with instance data
*      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
      UPDATE zmm_milkcoll SET mirodoc = @ls_pr_key-SupplierInvoice,
                              miro_year = @ls_pr_key-SupplierInvoiceFiscalYear
       WHERE id = @ls_milkmiro-ID.

    ENDLOOP.

  ENDIF.

  ENDMETHOD.

ENDCLASS.
