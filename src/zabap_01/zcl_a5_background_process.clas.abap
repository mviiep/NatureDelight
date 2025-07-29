CLASS zcl_a5_background_process DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .



  PUBLIC SECTION.

    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single_tx_uncontr .

    METHODS constructor
      IMPORTING
        iv_MIRODOC  TYPE re_belnr
        iv_miroyear TYPE gjahr.

  PROTECTED SECTION.
  PRIVATE SECTION.

    DATA : iM_MIRODOC  TYPE re_belnr,
           im_miroyear TYPE gjahr.

    METHODS modify
      RAISING
        cx_bgmc_operation.

    DATA: lv_tenent TYPE c LENGTH 8 .
    DATA :lv_dev(3) TYPE c VALUE 'ZJM',
          lv_qas(3) TYPE c VALUE 'ZXP',
          lv_prd(3) TYPE c VALUE 'ZQN'.


ENDCLASS.



CLASS ZCL_A5_BACKGROUND_PROCESS IMPLEMENTATION.


  METHOD constructor.

    iM_MIRODOC = iv_MIRODOC.
    iM_MIROYEAR = iv_MIROYEAR.

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
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_MILK_COLLECTION_FORM' ).
*      out->write( 'Dataservice initialized' ).

        "Get initial select keys for service
        DATA(lt_keys)     = lo_fdp_util->get_keys( ).
        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
          IF  <fs_keys>-name = 'MIRODOC'.
            <fs_keys>-value = iM_MIRODOC. "'5105600111'. "LS_MIRO-mirodoc.
          ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
            <fs_keys>-value = iM_MIROYEAR. "'2023'. "LS_MIRO-miroyear.
          ENDIF.

        ENDLOOP.

        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).


        CASE sy-sysid.
          WHEN lv_dev.

            DATA(ls_template) = lo_store->get_template_by_name(
              iv_get_binary     = abap_true
              iv_form_name      = 'MILK_COLLECTION_NEW_DEV' "<= form object in template store
              iv_template_name  = 'MILK_COLLECTION_NEW_DEV' "<= template (in form object) that should be used
            ).

            WHEN lv_qas.

            ls_template = lo_store->get_template_by_name(
              iv_get_binary     = abap_true
              iv_form_name      = 'MILK_COLLECTION_NEW_DEV' "<= form object in template store
              iv_template_name  = 'MILK_COLLECTION_NEW_DEV' "<= template (in form object) that should be used
            ).

             WHEN lv_prd.

            ls_template  = lo_store->get_template_by_name(
              iv_get_binary     = abap_true
              iv_form_name      = 'MILK_COLLECTION_NEW' "<= form object in template store
              iv_template_name  = 'MILK_COLLECTION_NEW' "<= template (in form object) that should be used
            ).



        ENDCASE.






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

**********************************************************************        TRY.
*                                               "#EC NO_HANDLER
*        ENDTRY.
*

        UPDATE zmm_milk_miro SET pdf_attach = @lv_pdf
        WHERE mirodoc = @im_mirodoc
        AND   miroyear = @im_miroyear.




*      out->write( 'Output was generated' ).

*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Miro Print'
*      ).



*      out->write( 'Output was sent to print queue' ).
      CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util.   "#EC NO_HANDLER
*      out->write( 'Exception occurred.' ).
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
