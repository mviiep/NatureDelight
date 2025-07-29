CLASS lsc_zi_rmrd_batch_update DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_rmrd_batch_update IMPLEMENTATION.

  METHOD save_modified.
    DATA lo_batch_char TYPE REF TO zcl_rmrd_batch_char_update.

    CREATE OBJECT lo_batch_char.
    DATA : lt_rmrd_batch TYPE TABLE OF ztrmrd_batch,
           lw_rmrd_batch TYPE ztrmrd_batch.
    IF create-zi_rmrd_batch_update IS NOT INITIAL.
      lt_rmrd_batch = CORRESPONDING #( create-zi_rmrd_batch_update
      MAPPING destination_fat = DestinationFat
      destination_protein = DestinationProtein
      destination_snf = DestinationSnf ).
      LOOP AT lt_rmrd_batch INTO lw_rmrd_batch.
*        CALL METHOD lo_batch_char->update_batch_details(
*            im_batch        = lw_rmrd_batch-batch
*            im_material     = lw_rmrd_batch-matnr
*            im_dest_fat     = lw_rmrd_batch-destination_fat
*            im_dest_protien = lw_rmrd_batch-destination_protein
*            im_dest_snf     = lw_rmrd_batch-destination_snf
*          ).

      ENDLOOP.
      INSERT ztrmrd_batch FROM TABLE @lt_rmrd_batch.
    ENDIF.

    IF update IS NOT INITIAL.
      CLEAR lt_rmrd_batch.
      lt_rmrd_batch = CORRESPONDING #( update-zi_rmrd_batch_update
      MAPPING destination_fat = DestinationFat
      destination_protein = DestinationProtein
      destination_snf = DestinationSnf ).
*      LOOP AT lt_rmrd_batch INTO lw_rmrd_batch.
*        CALL METHOD lo_batch_char->update_batch_details(
*            im_batch        = lw_rmrd_batch-batch
*            im_material     = lw_rmrd_batch-matnr
*            im_dest_fat     = lw_rmrd_batch-destination_fat
*            im_dest_protien = lw_rmrd_batch-destination_protein
*            im_dest_snf     = lw_rmrd_batch-destination_snf
*          ).
*
*      ENDLOOP.
MODIFY ENTITIES OF I_BatchTP_2
 ENTITY BatchCharacteristicValue
 UPDATE FROM VALUE #( ( Material = '000000000000000002'
 Batch = '0000000006'
 CharcInternalID = '0000000812'
 ClfnCHarcValuePositionNumber = '001'
 CharcValueIntervalType = '1'
* CharcValue = 'TEST'
* CharcFromNumericValue = '3'
* CharcFromNumericValueUnit = '%'
 CharcFromDecimalValue = '12.14'
* CharcToDecimalValue = '%'
* %control-CharcValue = cl_abap_behv=>flag_changed
* %control-CharcFromNumericValue = cl_abap_behv=>flag_changed
* %control-CharcFromNumericValueUnit = cl_abap_behv=>flag_changed
 %control-CharcValueIntervalType = cl_abap_behv=>flag_changed
  %control-CharcFromDecimalValue = cl_abap_behv=>flag_changed
*  %control-CharcToDecimalValue = cl_abap_behv=>flag_changed
 ) )
      MAPPED DATA(im_mapped)
      FAILED DATA(im_failed)
      REPORTED DATA(im_reported).

LOOP AT im_reported-batchcharacteristicvalue ASSIGNING FIELD-SYMBOL(<ls_so_reported_1>).
   DATA(lv_result1) = <ls_so_reported_1>-%msg->if_message~get_text( ).

 ENDLOOP.
 LOOP AT im_reported-batchcharacteristicvalue ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
    DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).

   ENDLOOP.




*      MODIFY ztrmrd_batch FROM TABLE @lt_rmrd_batch.
    ENDIF.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZI_RMRD_BATCH_UPDATE DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_rmrd_batch_update RESULT result.
    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR zi_rmrd_batch_update RESULT result.

    METHODS updatebatch FOR MODIFY
      IMPORTING keys FOR ACTION zi_rmrd_batch_update~updatebatch RESULT result.

ENDCLASS.

CLASS lhc_ZI_RMRD_BATCH_UPDATE IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_instance_features.
  ENDMETHOD.

  METHOD UpdateBatch.

    " Read relevant MilkCOll instance data
    READ ENTITIES OF ZI_RMRD_BATCH_UPDATE IN LOCAL MODE
    ENTITY zi_rmrd_batch_update
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
