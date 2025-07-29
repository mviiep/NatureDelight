CLASS zcl_qm_rmrd_batch_upd DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_QM_RMRD_BATCH_UPD IMPLEMENTATION.


  METHOD if_rap_query_provider~select.
*    DATA : lt_result TYPE STANDARD TABLE OF zce_rmrd_batch_update,
*           lw_result TYPE zce_rmrd_batch_update.
*           lw_result-batch ='0000000006'.
*           APPEND lw_result to lt_result.
*
*    TRY.
*        TRY.
*            TRY.
*                IF io_request->is_data_requested( ).
*                  io_request->get_paging( ).
*
*                  DATA(lt_filter_cond) = io_request->get_parameters( ).
*                  DATA(lt_filter_cond2) = io_request->get_filter( )->get_as_ranges( ).
*                  DATA(lv_batch) = VALUE #( lt_filter_cond[ parameter_name = 'P_BATCH' ]-value OPTIONAL ). "Fetching the parameter value
*                  DATA(lv_fat) = VALUE #( lt_filter_cond[ parameter_name = 'P_FAT' ]-value OPTIONAL ). "Fetching the parameter value
*                  DATA(lv_snf) = VALUE #( lt_filter_cond[ parameter_name = 'P_SNF' ]-value OPTIONAL ).
*                  DATA(lv_protein) = VALUE #( lt_filter_cond[ parameter_name = 'P_PROTEIN' ]-value OPTIONAL ).
*                  "Initialize values
*                  SELECT SINGLE Material FROM I_Batch
*                  WHERE Batch = @lv_batch
*                  INTO @DATA(lv_material).
*                  IF sy-subrc = 0.
*                    READ ENTITIES OF I_BatchTP_2
*                    ENTITY Batch BY \_BatchCharacteristicTP
*                    ALL FIELDS WITH VALUE #( ( %key = VALUE #( Material = lv_material Batch = lv_batch ) ) )
*                    RESULT DATA(lt_result_read)
*                    FAILED DATA(lt_failed_read)
*                    REPORTED DATA(lt_reported_read).
*                    LOOP AT lt_result_read INTO DATA(lw_result_read).
*
*                      IF sy-tabix = '4'.
*                        DATA(lv_value) = lv_snf.
*                        DATA(lv_id) = lw_result_read-CharcInternalID.
*                      ELSEIF sy-tabix = '5'.
*                        lv_value = lv_fat.
*                        lv_id = lw_result_read-CharcInternalID.
*                      ELSEIF sy-tabix = '6'.
*                        lv_value = lv_protein.
*                        lv_id = lw_result_read-CharcInternalID.
*                      ENDIF.
*
*
*
*                      IF lv_value IS NOT INITIAL.
*
*                        READ ENTITIES OF I_BatchTP_2
*                       ENTITY BatchCharacteristic BY \_BatchCharacteristicValueTP
*                       ALL FIELDS WITH VALUE #( (
*                       %key = VALUE #( Material = lv_material
*                       Batch = lv_batch
*                       CharcInternalID = lv_id ) ) )
*                        RESULT DATA(lt_char_result_read)
*                        FAILED DATA(lt_char_failed_read)
*                        REPORTED DATA(lt_char_reported_read).
*                        READ TABLE lt_char_result_read INTO DATA(lw_char_result) INDEX 1.
*
*                        IF   lw_char_result-CharcFromDecimalValue IS  NOT  INITIAL.
*
*                          MODIFY ENTITIES OF I_BatchTP_2
*                          ENTITY BatchCharacteristicValue
*                          UPDATE FROM VALUE #( ( Material = lv_material
*                          Batch = lv_batch
*                          CharcInternalID = lv_id
*                          ClfnCHarcValuePositionNumber = '001'
*                          CharcValueIntervalType = '1'
*                          CharcFromDecimalValue = lv_value
*                          %control-CharcValueIntervalType = cl_abap_behv=>flag_changed
*                           %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
**  %control-CharcToDecimalValue = cl_abap_behv=>flag_changed
*                          ) )
*                             MAPPED DATA(im_mapped)
*                             FAILED DATA(im_failed)
*                             REPORTED DATA(im_reported).
*                          COMMIT ENTITIES BEGIN
*                          RESPONSE OF I_BatchTP_2
*                          FAILED DATA(lt_commit_failed)
*                          REPORTED DATA(lt_commit_reported).
*                          COMMIT ENTITIES END.
*
*                        ELSE.
*                          MODIFY ENTITIES OF I_BatchTP_2
*                         ENTITY BatchCharacteristic
*                         CREATE BY \_BatchCharacteristicValueTP
*                         FROM VALUE #( (
*                         Material = lv_material
*                         Batch = lv_batch
*                         CharcInternalID = lv_id
*                         %target = VALUE #( ( %cid = 'C1'
*                         Material = lv_material
*                         Batch = lv_batch
*                         CharcInternalID = lv_id
*                         ClfnCharcValuePositionNumber = '001'
*                         CharcValueIntervalType = '1'
*                         CharcFromDecimalValue = lv_value
*                         %control-Material = cl_abap_behv=>flag_changed
*                         %control-Batch = cl_abap_behv=>flag_changed
*                         %control-CharcInternalID = cl_abap_behv=>flag_changed
*                         %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
*                          ) )
*                         ) )
*                         MAPPED im_mapped
*                         FAILED im_failed
*                         REPORTED  im_reported.
*                          COMMIT ENTITIES BEGIN
*                          RESPONSE OF I_BatchTP_2
*                          FAILED  lt_commit_failed
*                          REPORTED lt_commit_reported.
*                          COMMIT ENTITIES END.
*
*
*                        ENDIF.
*                      ENDIF.
*                      CLEAR : lv_value,lt_char_result_read,lt_char_failed_read,lt_char_reported_read,
*                      lw_char_result.
*                    ENDLOOP.
*
*                  ENDIF.
*
*                  DATA(lv_offset) = io_request->get_paging( )->get_offset( ).
*                  DATA(lv_page_size) = io_request->get_paging( )->get_page_size( ).
*                  io_response->set_total_number_of_records( lines( lt_result  ) ).
*                  io_response->set_data( lt_result ).
*                ENDIF.
*              CATCH cx_rap_query_provider INTO DATA(lx_exc).
*            ENDTRY.
*          CATCH cx_rfc_dest_provider_error INTO DATA(lx_dest).
*        ENDTRY.
*      CATCH cx_rap_query_filter_no_range.
*    ENDTRY.
****

  ENDMETHOD.
ENDCLASS.
