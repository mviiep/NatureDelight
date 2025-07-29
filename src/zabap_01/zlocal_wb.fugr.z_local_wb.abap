FUNCTION Z_LOCAL_WB.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(MODE) TYPE  I
*"     REFERENCE(COMMPORT) TYPE  I
*"     REFERENCE(SETTINGS) TYPE  C
*"     REFERENCE(OUTPUT) TYPE  C
*"     REFERENCE(SEPRTOR) TYPE  ZCHAR10
*"  EXPORTING
*"     REFERENCE(INPUT) TYPE  ZCHAR200
*"----------------------------------------------------------------------
CONSTANTS:
  SABC_ACT_READ(4)               VALUE 'READ',
  SABC_ACT_WRITE(5)              VALUE 'WRITE',
  SABC_ACT_READ_WITH_FILTER(16)  VALUE 'READ_WITH_FILTER',
  SABC_ACT_WRITE_WITH_FILTER(17) VALUE 'WRITE_WITH_FILTER',
  SABC_ACT_DELETE(6)             VALUE 'DELETE',
  SABC_ACT_INIT(4)               VALUE 'INIT',
  SABC_ACT_ACCEPT(6)             VALUE 'ACCEPT',
  SABC_ACT_CALL(4)               VALUE 'CALL'.

* checking whether the weighbridge is connected to the system or not
*
*  DATA: wa_repid LIKE sy-repid .
*  wa_repid = sy-repid.
*  CALL FUNCTION 'AUTHORITY_CHECK_OLE'
*    EXPORTING
*      program          = wa_repid
*      activity         = sabc_act_call
*      application      = 'MSCOMMLIB.MSCOMM.1'
**      application      = 'MSCOMMLIB.MSCOMM.6'
*    EXCEPTIONS
*      no_authority     = 1
*      activity_unknown = 2
*      OTHERS           = 3.
*  IF sy-subrc <> 0.
*    MESSAGE ID sy-msgid TYPE 'E' NUMBER sy-msgno
*    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4 .
*  ENDIF.
*  CREATE OBJECT o_obj 'MSCOMMLib.MSComm.1'.
**  CREATE OBJECT o_obj 'MSCOMMLib.MSComm.6'.
**  CREATE OBJECT o_obj 'MSCOMMLIB.MSCOMM.1'.
*  IF sy-subrc = 2.
*    MESSAGE 'WB is not connected the system' TYPE 'I' DISPLAY LIKE 'I'.
*  ENDIF.



ENDFUNCTION.
