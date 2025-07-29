CLASS zcl_rmrd_batch_char_update DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS update_batch_details IMPORTING
                                   im_batch          TYPE charg_d
                                   im_material       TYPE matnr
                                   im_source_fat     TYPE menge_d OPTIONAL
                                   im_source_snf     TYPE menge_d OPTIONAL
                                   im_source_protien TYPE menge_d OPTIONAL
                                   im_dest_fat       TYPE menge_d OPTIONAL
                                   im_dest_snf       TYPE menge_d  OPTIONAL
                                   im_dest_protien   TYPE menge_d  OPTIONAL.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RMRD_BATCH_CHAR_UPDATE IMPLEMENTATION.


  METHOD update_batch_details .
    READ ENTITIES OF I_BatchTP_2
    ENTITY Batch BY \_BatchCharacteristicTP
    ALL FIELDS WITH VALUE #( ( %key = VALUE #( Material = im_material Batch = im_batch ) ) )
    RESULT DATA(lt_result)
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_reported).

    DATA : lv_char_id    TYPE I_BatchCharacteristicTP_2-CharcInternalID,
           lv_char_value TYPE  p DECIMALS 2.
    LOOP AT lt_result INTO DATA(lw_result).
      CLEAR :lv_char_id ,lv_char_value.
      IF sy-tabix = 4.
        lv_char_id = lw_result-CharcInternalID.
        lv_char_value =  CONV #( im_dest_snf ).
      ELSEIF sy-tabix = 5.
        lv_char_id = lw_result-CharcInternalID.
        lv_char_value  = CONV #( im_dest_fat ).
      ELSEIF sy-tabix = 6.
        lv_char_id = lw_result-CharcInternalID.
        lv_char_value  = CONV #( im_dest_protien ).
      ENDIF.
      IF lv_char_value IS NOT INITIAL.
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
        COMMIT ENTITIES BEGIN
          RESPONSE OF I_BatchTP_2
          FAILED DATA(lt_commit_failed)
          REPORTED DATA(lt_commit_reported).

        COMMIT ENTITIES END.
      ENDIF..
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
