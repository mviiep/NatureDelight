CLASS lhc_zi_trucksheet_data_display DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_trucksheet_data_display RESULT result.
    METHODS printform FOR MODIFY
      IMPORTING keys FOR ACTION zi_trucksheet_data_display~printform RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_trucksheet_data_display RESULT result.

ENDCLASS.

CLASS lhc_zi_trucksheet_data_display IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD printform.

    READ ENTITIES OF zi_trucksheet_data_display  IN LOCAL MODE
           ENTITY zi_trucksheet_data_display
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_result).
    LOOP AT lt_result INTO DATA(lw_result).


      try.
      "Initialize Template Store Client
      data(lo_store) = new ZCL_FP_TMPL_STORE_CLIENT(
        "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
        iv_name = 'AdobeFormService'
        "name of communication arrangement with scenario SAP_COM_0276
        iv_service_instance_name = 'ZADSRTEMPLATE'
      ).

      "Initialize class with service definition
      data(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_TRUCKSHEET_PRINT' ).


      "Get initial select keys for service
      data(lt_keys)     = lo_fdp_util->get_keys( ).
        LOOP AT lt_keys ASSIGNING FIELD-SYMBOL(<fs_keys>).
            IF  <fs_keys>-name = 'TRUCKSHEET_NO'.
              <fs_keys>-value = lw_result-TrucksheetNo.

            ENDIF.

          ENDLOOP.
*      lt_keys[ name = 'TRUCKSHEET_NO' ]-value = '1000000014'.
      data(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).


      data(ls_template) = lo_store->get_template_by_name(
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
          is_options      = value #(
            trace_level = 4 "Use 0 in production environment
          )
        IMPORTING
          ev_trace_string = data(lv_trace)
          ev_pdl          = data(lv_pdf)
      ).
*        cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data      = lv_xml
*                                          iv_xdp_layout    = ls_template-xdp_template
*                                          iv_locale        = 'en_US'
**                                          is_options       = ls_options
*                                IMPORTING ev_pdf           = data(lv_pdf)
*                                          ev_pages         = data(ev_pages)
*                                          ev_trace_string  = data(ev_trace_string)
*                                          ).


*      cl_print_queue_utils=>create_queue_item_by_data(
*          "Name of the print queue where result should be stored
*          iv_qname = 'DEFAULT'
*          iv_print_data = lv_pdf
*          iv_name_of_main_doc = 'Gate Entry'
*      ).


    catch cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util .

    endtry.




      DATA : update_lines TYPE TABLE FOR UPDATE zi_trucksheet_data_display,
             update_line  TYPE STRUCTURE FOR UPDATE zi_trucksheet_data_display.

      update_line-%tky                   = lw_result-%tky.
      update_line-pdf                 = lv_pdf.
      APPEND update_line TO update_lines.
      MODIFY ENTITIES OF zi_trucksheet_data_display IN LOCAL MODE
       ENTITY zi_trucksheet_data_display
         UPDATE
*        FIELDS ( DirtyFlag OverallStatus OverallStatusIndicator PurchRqnCreationDate )
         FIELDS ( pdf )
         WITH update_lines
       REPORTED reported
       FAILED failed
       MAPPED mapped.

      READ ENTITIES OF  zi_trucksheet_data_display  IN LOCAL MODE  ENTITY zi_trucksheet_data_display
  ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).
    ENDLOOP.


  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_zi_trucksheet_data_display DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

*    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_zi_trucksheet_data_display IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_truck_sheet TYPE TABLE OF zsdt_truckshet_h.
    IF update-zi_trucksheet_data_display IS NOT INITIAL.
      lt_truck_sheet = CORRESPONDING #( update-zi_trucksheet_data_display MAPPING
    trucksheet_no = trucksheetno
   pdf_data    = pdf

       ).

      LOOP AT lt_truck_sheet INTO DATA(lw_truck_sheet).
        UPDATE zsdt_truckshet_h  SET pdf_data = @lw_truck_sheet-pdf_data WHERE
         trucksheet_no = @lw_truck_sheet-trucksheet_no.
      ENDLOOP.

    ENDIF.

    if  delete-zi_trucksheet_data_display is NOT INITIAL.
    DATA : lt_truck_sheet_data TYPE TABLE FOR DELETE ZI_TRUCKSHEET_DATA_DISPLAY,
           lr_truc_sheet_no type RANGE OF ZDE_TRUCKSHEET_NO.
        lt_truck_sheet_data = CORRESPONDING #( delete-zi_trucksheet_data_display
       ).
lr_truc_sheet_no = VALUE  #( FOR lw_truck_sheet_data  in lt_truck_sheet_data ( SIGN = 'I' option = 'EQ' low = lw_truck_sheet_data-TrucksheetNo  )  ).
*    if lt_truck_sheet_data  is NOT INITIAL.
      DELETE FROM zsdt_truckshet_h WHERE trucksheet_no in @lr_truc_sheet_no.
      DELETE FROM zsdt_truckshet_i WHERE trucksheet_no in @lr_truc_sheet_no.
    Endif.
  ENDMETHOD.

*  METHOD cleanup_finalize.
*  ENDMETHOD.

ENDCLASS.
