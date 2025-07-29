CLASS zcl_test_iris_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST_IRIS_API IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

  DATA : lv_content_length_value   TYPE i,
         lv_xml_result_str        TYPE string,
         LV_JSON type string.

**        TRY.
***            ------------Start: Call API ------------
**            DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
**                                     comm_scenario  = 'YY1_EINV_IRIS_OB'
**                                     service_id     = 'YY1_EINVIRISLOGIN_REST'
**                                   ).
**
**            DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
**            DATA(lo_request) = lo_http_client->get_http_request( ).
**
**            lo_request->set_header_field( i_name = 'Content-Type'
**                                          i_value = 'application/json' ).
**
***            LV_JSON = '{"email":"onkar.belose@pwc.com","password":"Onkar7@indian"}'.
**            LV_JSON = '{"email":"sadik.shaikh@pwc.com","password":"Abcd@12345"}'.
**
**             lv_content_length_value = strlen( LV_JSON ).
**
**             lo_request->set_text( i_text = LV_JSON
**                                   i_length = lv_content_length_value ).
**
**            DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>post ).
**
**
**            DATA(lv_xml_results) = lo_response->get_text( ).
***            ------------End: Call API ------------
**
**
**            TYPES: BEGIN OF ty_data,
**                     weight TYPE string,
**                   END OF ty_data.
**            DATA: it_weight TYPE TABLE OF ty_data.
**            it_weight = VALUE #( ( weight = lv_xml_results ) ) .
**                 out->write( lv_xml_results ).
**
**          CATCH cx_root INTO DATA(lx_exception).
**        ENDTRY.

try.
     LV_JSON = '[{"irn": "1234567890","CnlRsn": "2","CnlRem": "Wrong"}]'.

    " Create HTTP client
        DATA(lo_destination) = cl_http_destination_provider=>create_by_comm_arrangement(
                                 comm_scenario  = 'YY1_ZEI_CLEARTAX_CANCEL_IRN'
                                     service_id     = 'YY1_CANCELIRN_REST'
                               ).

        DATA(lo_http_client) = cl_web_http_client_manager=>create_by_http_destination( i_destination = lo_destination ).
        DATA(lo_request) = lo_http_client->get_http_request( ).


        lo_request->set_header_field( i_name = 'Content-Type'
                                      i_value = 'application/json' ).


        lo_request->set_header_field( i_name = 'gstin'
        i_value = '27AAFCN2297L1ZY' ).

        lo_request->set_header_field( i_name = 'X-Cleartax-Auth-Token'
         i_value = '1.914f0afe-ec41-44c4-ac5d-9bf71af194ec_92d9e0731153b7c3cfdd75b92be0c1e5ad9a9f76064dea6648e601c56402ba69' ).
*        i_value = '1.dd710b6d-1c7f-41d0-b28a-dfa1425c776c_71fdc9c7e2e27539946a2ac1cdb64850e4d6f480b2cc43acce9be73cac76f9a8' ).




        lv_content_length_value = strlen( LV_JSON ).
        lo_request->set_text( i_text = LV_JSON
                              i_length = lv_content_length_value ).

        DATA(lo_response) = lo_http_client->execute( i_method = if_web_http_client=>Put ).
*        DATA(lv_xml) = lo_response->get_text( ).
        lv_xml_result_str = lo_response->get_text( ).
        out->write( lv_xml_result_str ).
          CATCH cx_root INTO DATA(lx_exception).
        ENDTRY.


  ENDMETHOD.
ENDCLASS.
