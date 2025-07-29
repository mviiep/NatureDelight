CLASS zcl_rmrd_batch_update DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_RMRD_BATCH_UPDATE IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    READ ENTITIES OF I_BatchTP_2
   ENTITY Batch BY \_BatchCharacteristicTP
   ALL FIELDS WITH VALUE #( ( %key = VALUE #( Material = '000000000000000002' Batch = '0000000006' ) ) )
   RESULT DATA(lt_result)
   FAILED DATA(lt_failed)
   REPORTED DATA(lt_reported).

*   LOOP AT lt_result INTO DATA(lw_result).



*    MODIFY ENTITIES OF I_BatchTP_2
*    ENTITY BatchCharacteristic
*    CREATE BY \_BatchCharacteristicValueTP
*    FROM VALUE #( (
*    Material = '000000000000000002'
**    BatchIdentifyingPlant = '1102'
*    Batch = '0000000006'
*    CharcInternalID = '0000000818'
*    %target = VALUE #( ( %cid = 'C1'
*    Material = '000000000000000002'
**    BatchIdentifyingPlant = '1102'
*    Batch = '0000000006'
*    CharcInternalID = '0000000818' "lw_result-%data-CharcInternalID
**    ClfnCharcValuePositionNumber = '001'
**    CharcFromNumericValue = '3.14'
**    CharcFromNumericValueUnit = '%'
*    CharcValue = '3.14'
*    %control-Material = cl_abap_behv=>flag_changed
**    %control-BatchIdentifyingPlant = cl_abap_behv=>flag_changed
*    %control-Batch = cl_abap_behv=>flag_changed
*    %control-CharcInternalID = cl_abap_behv=>flag_changed
*    %control-CharcValue = cl_abap_behv=>flag_changed
**    %control-ClfnCharcValuePositionNumber = cl_abap_behv=>flag_changed
**    %control-CharcFromNumericValue = cl_abap_behv=>flag_changed
**    %control-CharcFromNumericValueUnit = cl_abap_behv=>flag_changed
*     ) )
*    ) )
*    MAPPED DATA(im_mapped)
*    FAILED DATA(im_failed)
*    REPORTED DATA(im_reported).
*    ENDLOOP.

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
 CharcFromDecimalValue = '38.14'
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
           out->write( 'Item' ).
           out->write( lv_result1 ).
    ENDLOOP.
    LOOP AT im_reported-batchcharacteristicvalue ASSIGNING FIELD-SYMBOL(<ls_so_reported_2>).
      DATA(lv_result2) = <ls_so_reported_2>-%msg->if_message~get_text( ).
           out->write( 'Order' ).
           out->write( lv_result2 ).
    ENDLOOP.
    COMMIT ENTITIES BEGIN
      RESPONSE OF I_BatchTP_2
      FAILED DATA(lt_commit_failed)
      REPORTED DATA(lt_commit_reported).
*    LOOP AT im_mapped-batchcharacteristicvalue ASSIGNING FIELD-SYMBOL(<fs_so_mapped>).
*      CONVERT KEY OF I_BatchTP_2 FROM <fs_so_mapped>-%pid TO DATA(ls_so_key).
*          out->write( 'Purchase Order:'  && ls_so_key-Batch ).
*    ENDLOOP.
    COMMIT ENTITIES END.



  ENDMETHOD.
ENDCLASS.
