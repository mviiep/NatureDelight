CLASS z_form_xml_downalod DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z_FORM_XML_DOWNALOD IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
*****************************************
    "Initiate data service from definition
    TRY.
        DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_MILK_COLLECTION_FORM' ).

      CATCH cx_fp_fdp_error INTO DATA(lo_exception).

    ENDTRY.

    "Retrieve the key fields of the root node
    TRY.
        DATA(lt_keys)  = lo_fdp_util->get_keys( ).
      CATCH cx_fp_fdp_error INTO lo_exception.
    ENDTRY.

    "Fill out key fields (depends on your actual data)

    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
      IF  <fs_keys>-name = 'MIRODOC'.
        <fs_keys>-value = '5105600136'.
      ELSEIF <fs_keys>-name = 'MIRO_YEAR'.
        <fs_keys>-value = '2023'.
*      ELSEIF <fs_keys>-name = 'TO_DATE'.
*        <fs_keys>-value = '20240222'.
      ENDIF.

    ENDLOOP.

*    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*      IF  <fs_keys>-name = 'ACCOUNTINGDOCUMENT'.
*        <fs_keys>-value = '5000000140'.
*      ELSEIF <fs_keys>-name = 'FISCALYEAR'.
*        <fs_keys>-value = '2023'.
**      ELSEIF <fs_keys>-name = 'TO_DATE'.
**        <fs_keys>-value = '20240222'.
*      ENDIF.
*
*    ENDLOOP.

*    LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
*      IF  <fs_keys>-name = 'CUSTOMER'.
*        <fs_keys>-value = '0001000011'.
*      ELSEIF <fs_keys>-name = 'FR_DATE'.
*        <fs_keys>-value = '20240201'.
*      ELSEIF <fs_keys>-name = 'TO_DATE'.
*        <fs_keys>-value = '20240222'.
*      ENDIF.
*
*    ENDLOOP.
*lt_keys[ name = 'BILLINGDOCUMENT' ]-value = 'C100000000'.
* lt_keys[ name = 'TRUCKSHEET_NO' ]-value = '1000000133'.

    "Execute the data service and retrieve the data tree
    TRY.
        DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
      CATCH cx_fp_fdp_error INTO lo_exception.
    ENDTRY.

    "Generate data schema from your service
    TRY.
        DATA(lv_schema) = lo_fdp_util->get_xsd(  ).
      CATCH cx_fp_fdp_error.
        "handle exception
    ENDTRY.

******* To connect

    "Initialize Template Store Client
    TRY.
        DATA(lo_store) = NEW zcl_fp_tmpl_store_client(
          "destination name connecting to the template store in cf destination service
          iv_name = 'AdobeFormService'
          iv_service_instance_name  = 'ZADSRTEMPLATE'

          "name of the comm. arrangement connecting the cf destination service
*  iv_service_instance_name = 'SAP_COM_0276'
        ).
      CATCH zcx_fp_tmpl_store_error INTO DATA(lo_exception1).
    ENDTRY.
***************To Upload schema

    TRY.
        "Get data schema for form object
        lo_store->get_schema_by_name( iv_form_name = 'MILK_COLLECTION_NEW' ).

      CATCH zcx_fp_tmpl_store_error INTO DATA(lo_tmpl_error).
        "Error occurred
        "Check if error occurred because no schema was found
        IF lo_tmpl_error->mv_http_status_code = 404.
          "Upload a new schema to form object
          TRY.
              lo_store->set_schema(
                iv_form_name = 'MILK_COLLECTION_NEW'
                "Generate schema from the data service util
                is_data = VALUE #( note = '' schema_name = 'MILK_COLLECTION_NEW' xsd_schema = lo_fdp_util->get_xsd(  )  )
              ).
            CATCH zcx_fp_tmpl_store_error cx_fp_fdp_error.
              "handle exception
          ENDTRY.
        ELSE.
          "Get error: lo_tmpl_error->get_longtext(  ).
        ENDIF.
    ENDTRY.

*********To downlod

    TRY.
        DATA(ls_template) = lo_store->get_template_by_name(
          "Should the xdp template be retrieved or only metadata
          iv_get_binary     = abap_true
          "Name of the form object in the template store
          iv_form_name      = 'MILK_COLLECTION_NEW'
          "Name of the template in the template store
          iv_template_name  = 'MILK_COLLECTION_NEW'
        ).
      CATCH zcx_fp_tmpl_store_error.
        "handle exception
    ENDTRY.

*To access the template data use:
*ls_template-xdp_template.


  ENDMETHOD.
ENDCLASS.
