CLASS zcl_bg_process_bill_print DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single_tx_uncontr .
    INTERFACES if_serializable_object .

    METHODS constructor
        IMPORTING
            iv_Bill TYPE zchar10.

  PROTECTED SECTION.
  PRIVATE SECTION.

        DATA : im_bill TYPE zchar10.

        METHODS modify
            RAISING
                cx_bgmc_operation.

ENDCLASS.



CLASS ZCL_BG_PROCESS_BILL_PRINT IMPLEMENTATION.


  METHOD constructor.
     im_bill = iv_bill.
  ENDMETHOD.


  METHOD if_bgmc_op_single_tx_uncontr~execute.
          modify( ).
  ENDMETHOD.


  METHOD modify.

      TRY.
          "Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client(
            "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
            iv_name = 'AdobeFormService'
            "name of communication arrangement with scenario SAP_COM_0276
            iv_service_instance_name = 'ZADSRTEMPLATE'
          ).
*      out->write( 'Template Store Client initialized' ).
          "Initialize class with service definition
          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_INV_FORM_PRINT' ).
*      out->write( 'Dataservice initialized' ).

          "Get initial select keys for service
          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
          LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
            IF  <fs_keys>-name = 'BILLINGDOCUMENT'.
              <fs_keys>-value = im_bill.
            ENDIF.

          ENDLOOP.

          DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).

       select single from i_billingdocument FIELDS billingdocumenttype
       WHERE billingdocument = @im_bill
       into @data(lv_type).

       if lv_type = 'G2'.
          DATA(ls_template) = lo_store->get_template_by_name(
            iv_get_binary     = abap_true
            iv_form_name      = 'CREDIT_NOTE' "<= form object in template store
            iv_template_name  = 'CREDIT_NOTE' "<= template (in form object) that should be used
          ).
       else.
          ls_template = lo_store->get_template_by_name(
            iv_get_binary     = abap_true
            iv_form_name      = 'INVOICE_FORM' "<= form object in template store
            iv_template_name  = 'INVOICE_FORM' "<= template (in form object) that should be used
          ).
       endif.

*      out->write( 'Form Template retrieved' ).

          cl_fp_ads_util=>render_4_pq(
            EXPORTING
              iv_locale       = 'en_US'
              iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
              iv_xml_data     = lv_xml
              iv_xdp_layout   = ls_template-xdp_template
              is_options      = VALUE #(
                trace_level = 4 "Use 0 in production environment
              )
            IMPORTING
              ev_trace_string = DATA(lv_trace)
              ev_pdl          = DATA(lv_pdf)
         ).

          TRY.

          ENDTRY.

      data : wa_data type zsdt_billprint.
      wa_data-billingdocument = im_bill.
      wa_data-pdf_data = lv_pdf.
      Modify zsdt_billprint FROM @wa_data.


*      out->write( 'Output was generated' ).

*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Gate Entry'
*      ).



*      out->write( 'Output was sent to print queue' ).
        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util.
*      out->write( 'Exception occurred.' ).
      ENDTRY.



  ENDMETHOD.
ENDCLASS.
