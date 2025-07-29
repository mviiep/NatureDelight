CLASS zcl_ce_trucksheet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CE_TRUCKSHEET IMPLEMENTATION.


  METHOD IF_OO_ADT_CLASSRUN~MAIN.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.
* data io_response TYPE ZCE_TRRUCKSHEET.

*    CASE io_request->get_entity_id( ).
*
*      WHEN 'ZCE_TRRUCKSHEET'.
*        DATA: QUERY_STRING type STRING.

*        IF io_request->is_data_requested( ).
*          DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
*          IF lv_top < 0.
*            lv_top = 1.
*          ENDIF.
*
*          DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).
*
*          DATA(lt_input) = io_request->get_filter( )->get_as_ranges( ).
*          DATA(lt_sql) = io_request->get_filter( )->get_as_sql_string( ).
*
*
*          DATA(lt_filter_cond) = io_request->get_parameters( ).
*
*          IF line_exists( lt_filter_cond[ PARAMETER_NAME  = 'TRUCKSHEET_NO' ] ).
*            DATA(lv_truck) = VALUE #( lt_filter_cond[ parameter_name = 'TRUCKSHEET_NO' ]-value OPTIONAL ) .
*            concatenate   '_truck~itemTrucksheetNo ' '=' lv_truck  into QUERY_STRING separated by SPACE.
*          ENDIF.
*
*          IF line_exists( lt_filter_cond[ PARAMETER_NAME  = 'VEHICLE_NO' ] ).
*            DATA(lv_Vehi) = VALUE #( lt_filter_cond[ parameter_name = 'VEHICLE_NO' ]-value OPTIONAL ) .
*            concatenate   '_truck~VehicleNo ' '=' lv_Vehi  into QUERY_STRING separated by SPACE.
*          ENDIF.
*
*          IF line_exists( lt_filter_cond[ PARAMETER_NAME  = 'TRUCKSHEETDATE' ] ).
*            DATA(lv_date) = VALUE #( lt_filter_cond[ parameter_name = 'TRUCKSHEETDATE' ]-value OPTIONAL ) .
*            concatenate   '_truck~TrucksheetDate ' '=' lv_date  into QUERY_STRING separated by SPACE.
*          ENDIF.
*

*          IF lt_input IS NOT INITIAL.

*          SELECT DISTINCT itemTrucksheetNo
*          FROM ZI_TRUCKSHEET_DATA_DISPLAY AS _truck
**          LEFT OUTER JOIN I_BillingDocumentItem AS _item
**          ON _truck~BillingDocument = _item~BillingDocument
*         WHERE (QUERY_STRING)
*         INTO TABLE @DATA(lt_truck).

*          ENDIF.

*          io_response->set_data( lt_truck ).
*          IF io_request->is_total_numb_of_rec_requested(  ).
*            io_response->set_total_number_of_records( lines( lt_truck ) ).
*          ENDIF.

*        ENDIF.

*        WHEN 'ZCE_TRRUCKSHEET'.

*    ENDCASE.
  ENDMETHOD.
ENDCLASS.
