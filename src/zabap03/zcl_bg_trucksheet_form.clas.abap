CLASS zcl_bg_trucksheet_form DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_serializable_object .
    INTERFACES if_bgmc_operation .
    INTERFACES if_bgmc_op_single_tx_uncontr .
    METHODS constructor
      IMPORTING
        iv_trucksheet_no TYPE zchar10.
  PROTECTED SECTION.


  PRIVATE SECTION.
    DATA :im_trucksheet_no TYPE zchar10.
    METHODS modify
      RAISING
        cx_bgmc_operation.
ENDCLASS.



CLASS ZCL_BG_TRUCKSHEET_FORM IMPLEMENTATION.


  METHOD constructor.
    im_trucksheet_no  = iv_trucksheet_no.

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

        "Initialize class with service definition
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_TRUCKSHEET_PRINT' ).


        "Get initial select keys for service
        DATA(lt_keys)     = lo_fdp_util->get_keys( ).
        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
          IF  <fs_keys>-name = 'TRUCKSHEET_NO'.
            <fs_keys>-value = im_trucksheet_no.

          ENDIF.

        ENDLOOP.
*      lt_keys[ name = 'TRUCKSHEET_NO' ]-value = '1000000014'.
        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).


        DATA(ls_template) = lo_store->get_template_by_name(
          iv_get_binary     = abap_true
          iv_form_name      = 'TRUCK_SHEET' "<= form object in template store
          iv_template_name  = 'TRUCK_SHEET' "<= template (in form object) that should be used
        ).



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
        cl_print_queue_utils=>create_queue_item_by_data(
               "Name of the print queue where result should be stored
               iv_qname = 'DEFAULT'
               iv_print_data = lv_pdf
               iv_name_of_main_doc = 'TruckSheet'
           ).
        UPDATE zsdt_truckshet_h   SET pdf_data = @lv_pdf
        WHERE trucksheet_no = @im_trucksheet_no.

      CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util .

    ENDTRY.

  ENDMETHOD.
ENDCLASS.
