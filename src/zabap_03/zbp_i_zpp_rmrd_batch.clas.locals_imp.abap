CLASS lsc_zi_zpp_rmrd_batch DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_zpp_rmrd_batch IMPLEMENTATION.

  METHOD save_modified.

    DATA : lt_rmrd_batch        TYPE STANDARD TABLE OF zppt_rmrd_batch,
           ls_rmrd_batch        TYPE                   zppt_rmrd_batch,
           lt_zpp_rmrd_batch_x_control TYPE STANDARD TABLE OF zppt_rmrd_batch.

    IF create-rmrdbatch IS NOT INITIAL.
      lt_rmrd_batch = CORRESPONDING #( create-rmrdbatch MAPPING FROM ENTITY ).
      INSERT zppt_rmrd_batch FROM TABLE @lt_rmrd_batch.

*loop at lt_rmrd_batch into data(ls_rmrd).
*    READ ENTITIES OF I_BatchTP_2
*    ENTITY Batch BY \_BatchCharacteristicTP
*    ALL FIELDS WITH VALUE #( ( %key = VALUE #( Material = ls_rmrd-Matnr Batch = ls_rmrd-batch ) ) )
*    RESULT DATA(lt_result_read)
*    FAILED DATA(lt_failed_read)
*    REPORTED DATA(lt_reported_read).
*    LOOP AT lt_result_read INTO DATA(lw_result_read).
*
*      IF sy-tabix = '4'.
*        DATA(lv_value) = ls_rmrd-destination_snf.
*        DATA(lv_id) = lw_result_read-CharcInternalID.
*      ELSEIF sy-tabix = '5'.
*        lv_value = ls_rmrd-destination_fat.
*        lv_id = lw_result_read-CharcInternalID.
*      ELSEIF sy-tabix = '6'.
*        lv_value = ls_rmrd-destination_protein.
*        lv_id = lw_result_read-CharcInternalID.
*      ENDIF.
*
*
*
*      IF lv_value IS NOT INITIAL.
*
*        READ ENTITIES OF I_BatchTP_2
*       ENTITY BatchCharacteristic BY \_BatchCharacteristicValueTP
*       ALL FIELDS WITH VALUE #( (
*       %key = VALUE #( Material = ls_rmrd-matnr
*       Batch = ls_rmrd-batch
*       CharcInternalID = lv_id ) ) )
*        RESULT DATA(lt_char_result_read)
*        FAILED DATA(lt_char_failed_read)
*        REPORTED DATA(lt_char_reported_read).
*        READ TABLE lt_char_result_read INTO DATA(lw_char_result) INDEX 1.
*
*        IF   lw_char_result-CharcFromDecimalValue IS  NOT  INITIAL.
*
*          MODIFY ENTITIES OF I_BatchTP_2
*          ENTITY BatchCharacteristicValue
*          UPDATE FROM VALUE #( ( Material = ls_rmrd-matnr
*          Batch = ls_rmrd-batch
*          CharcInternalID = lv_id
*          ClfnCHarcValuePositionNumber = '001'
*          CharcValueIntervalType = '1'
*          CharcFromDecimalValue = lv_value
*          %control-CharcValueIntervalType = cl_abap_behv=>flag_changed
*           %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
**  %control-CharcToDecimalValue = cl_abap_behv=>flag_changed
*          ) )
*             MAPPED DATA(im_mapped)
*             FAILED DATA(im_failed)
*             REPORTED DATA(im_reported).
*
**          COMMIT ENTITIES BEGIN
**          RESPONSE OF I_BatchTP_2
**          FAILED DATA(lt_commit_failed)
**          REPORTED DATA(lt_commit_reported).
**          COMMIT ENTITIES END.
*
*        ELSE.
*          MODIFY ENTITIES OF I_BatchTP_2
*         ENTITY BatchCharacteristic
*         CREATE BY \_BatchCharacteristicValueTP
*         FROM VALUE #( (
*         Material = ls_rmrd-matnr
*         Batch = ls_rmrd-batch
*         CharcInternalID = lv_id
*         %target = VALUE #( ( %cid = 'C1'
*         Material = ls_rmrd-matnr
*         Batch = ls_rmrd-batch
*         CharcInternalID = lv_id
*         ClfnCharcValuePositionNumber = '001'
*         CharcValueIntervalType = '1'
*         CharcFromDecimalValue = lv_value
*         %control-Material = cl_abap_behv=>flag_changed
*         %control-Batch = cl_abap_behv=>flag_changed
*         %control-CharcInternalID = cl_abap_behv=>flag_changed
*         %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
*          ) )
*         ) )
*         MAPPED im_mapped
*         FAILED im_failed
*         REPORTED  im_reported.
**          COMMIT ENTITIES BEGIN
**          RESPONSE OF I_BatchTP_2
**          FAILED  lt_commit_failed
**          REPORTED lt_commit_reported.
**          COMMIT ENTITIES END.
*
*
*        ENDIF.
*      ENDIF.
*      CLEAR : lv_value,lt_char_result_read,lt_char_failed_read,lt_char_reported_read,
*      lw_char_result.
*    ENDLOOP.
*
* endloop.


    ENDIF.

    IF update IS NOT INITIAL.
      CLEAR lt_rmrd_batch.
      lt_rmrd_batch = CORRESPONDING #( update-rmrdbatch MAPPING FROM ENTITY ).
      lt_zpp_rmrd_batch_x_control = CORRESPONDING #( update-rmrdbatch MAPPING FROM ENTITY ).
      MODIFY zppt_rmrd_batch FROM TABLE @lt_rmrd_batch.
    ENDIF.
    IF delete IS NOT INITIAL.
      LOOP AT delete-rmrdbatch INTO DATA(rmrd_batch_delete).
        DELETE FROM zppt_rmrd_batch WHERE id = @rmrd_batch_delete-ID.
      ENDLOOP.
    ENDIF.

* IF zbp_i_zmm_milkcoll=>mapped_purchase_order IS NOT INITIAL
*  AND update IS NOT INITIAL.
*    LOOP AT zbp_i_zmm_milkcoll=>mapped_purchase_order-purchaseorder ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
*      CONVERT KEY OF i_purchaseordertp_2 FROM <fs_pr_mapped>-%pid TO DATA(ls_pr_key).
*      <fs_pr_mapped>-purchaseorder = ls_pr_key-purchaseorder.
*    ENDLOOP.
*    LOOP AT update-milkcoll INTO  DATA(ls_milkcoll). " WHERE %control-OverallStatus = if_abap_behv=>mk-on.
*      " Creates internal table with instance data
**      DATA(creation_date) = cl_abap_context_info=>get_system_date(  ).
*      UPDATE zmm_milkcoll SET ebeln = @ls_pr_key-purchaseorder
*       WHERE id = @ls_milkcoll-ID.
*
*    ENDLOOP.
*  ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_rmrdbatch DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR rmrdbatch RESULT result.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR rmrdbatch RESULT result.

    METHODS updatebatch FOR MODIFY
      IMPORTING keys FOR ACTION rmrdbatch~updatebatch RESULT result.

ENDCLASS.

CLASS lhc_rmrdbatch IMPLEMENTATION.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD updatebatch.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF ZI_ZPP_RMRD_BATCH IN LOCAL MODE
    ENTITY RmrdBatch
        FIELDS ( Matnr batch destinationfat destinationsnf destinationprotein ) WITH CORRESPONDING #( keys )
      RESULT DATA(members).

    LOOP AT members INTO DATA(member).

*---------------------------------------------------


    READ ENTITIES OF I_BatchTP_2
    ENTITY Batch BY \_BatchCharacteristicTP
    ALL FIELDS WITH VALUE #( ( %key = VALUE #( Material = member-Matnr Batch = member-batch ) ) )
    RESULT DATA(lt_result_read)
    FAILED DATA(lt_failed_read)
    REPORTED DATA(lt_reported_read).
    LOOP AT lt_result_read INTO DATA(lw_result_read).

      IF sy-tabix = '4'.
        DATA(lv_value) = member-DestinationSnf.
        DATA(lv_id) = lw_result_read-CharcInternalID.
      ELSEIF sy-tabix = '5'.
        lv_value = member-DestinationFat.
        lv_id = lw_result_read-CharcInternalID.
      ELSEIF sy-tabix = '6'.
        lv_value = member-DestinationProtein.
        lv_id = lw_result_read-CharcInternalID.
      ENDIF.



      IF lv_value IS NOT INITIAL.

        READ ENTITIES OF I_BatchTP_2
       ENTITY BatchCharacteristic BY \_BatchCharacteristicValueTP
       ALL FIELDS WITH VALUE #( (
       %key = VALUE #( Material = member-matnr
       Batch = member-batch
       CharcInternalID = lv_id ) ) )
        RESULT DATA(lt_char_result_read)
        FAILED DATA(lt_char_failed_read)
        REPORTED DATA(lt_char_reported_read).
        READ TABLE lt_char_result_read INTO DATA(lw_char_result) INDEX 1.

        IF   lw_char_result-CharcFromDecimalValue IS  NOT  INITIAL.

          MODIFY ENTITIES OF I_BatchTP_2
          ENTITY BatchCharacteristicValue
          UPDATE FROM VALUE #( ( Material = member-matnr
          Batch = member-batch
          CharcInternalID = lv_id
          ClfnCHarcValuePositionNumber = '001'
          CharcValueIntervalType = '1'
          CharcFromDecimalValue = lv_value
          %control-CharcValueIntervalType = cl_abap_behv=>flag_changed
           %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
*  %control-CharcToDecimalValue = cl_abap_behv=>flag_changed
          ) )
             MAPPED DATA(im_mapped)
             FAILED DATA(im_failed)
             REPORTED DATA(im_reported).

*          COMMIT ENTITIES BEGIN
*          RESPONSE OF I_BatchTP_2
*          FAILED DATA(lt_commit_failed)
*          REPORTED DATA(lt_commit_reported).
*          COMMIT ENTITIES END.

        ELSE.
          MODIFY ENTITIES OF I_BatchTP_2
         ENTITY BatchCharacteristic
         CREATE BY \_BatchCharacteristicValueTP
         FROM VALUE #( (
         Material = member-matnr
         Batch = member-batch
         CharcInternalID = lv_id
         %target = VALUE #( ( %cid = 'C1'
         Material = member-matnr
         Batch = member-batch
         CharcInternalID = lv_id
         ClfnCharcValuePositionNumber = '001'
         CharcValueIntervalType = '1'
         CharcFromDecimalValue = lv_value
         %control-Material = cl_abap_behv=>flag_changed
         %control-Batch = cl_abap_behv=>flag_changed
         %control-CharcInternalID = cl_abap_behv=>flag_changed
         %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
          ) )
         ) )
         MAPPED im_mapped
         FAILED im_failed
         REPORTED  im_reported.
*          COMMIT ENTITIES BEGIN
*          RESPONSE OF I_BatchTP_2
*          FAILED  lt_commit_failed
*          REPORTED lt_commit_reported.
*          COMMIT ENTITIES END.


        ENDIF.
      ENDIF.
      CLEAR : lv_value,lt_char_result_read,lt_char_failed_read,lt_char_reported_read,
      lw_char_result.
    ENDLOOP.



*---------------------------------------------------

    endloop.


  ENDMETHOD.

ENDCLASS.
