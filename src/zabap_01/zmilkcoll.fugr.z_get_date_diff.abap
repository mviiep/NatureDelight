FUNCTION Z_GET_DATE_DIFF.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_DATE) TYPE  DATUM
*"  EXPORTING
*"     REFERENCE(EV_DAYS) TYPE  INT4
*"----------------------------------------------------------------------
    DATA(ST_DATE) = |{ IV_DATE+0(4) }0101 |.
    DATA(ED_DATE) = IV_DATE.
    DATA : N(2) TYPE N.
*    EV_DAYS =  ED_DATE - ST_DATE.

  DATA(YEAR) = ED_DATE+0(4) MOD 4.
  DATA(MONTH) = ED_DATE+4(2).
  MONTH = MONTH - 1.

  IF MONTH GT 0.
    DO MONTH TIMES.
      N = N + 1.
      CASE N.
       WHEN 1.
        EV_DAYS = EV_DAYS + 31.
       WHEN 2.
        IF YEAR = 0. "LEAP YEAR
         EV_DAYS = EV_DAYS + 29.
        ELSE.
         EV_DAYS = EV_DAYS + 28.
        ENDIF.
       WHEN 3.
        EV_DAYS = EV_DAYS + 31.
       WHEN 4.
        EV_DAYS = EV_DAYS + 30.
       WHEN 5.
        EV_DAYS = EV_DAYS + 31.
       WHEN 6.
        EV_DAYS = EV_DAYS + 30.
       WHEN 7.
        EV_DAYS = EV_DAYS + 31.
       WHEN 8.
        EV_DAYS = EV_DAYS + 31.
       WHEN 9.
        EV_DAYS = EV_DAYS + 30.
       WHEN 10.
        EV_DAYS = EV_DAYS + 31.
       WHEN 11.
        EV_DAYS = EV_DAYS + 30.
       WHEN 12.
        EV_DAYS = EV_DAYS + 31.
      ENDCASE.
    ENDDO.
  ENDIF.

  EV_DAYS = EV_DAYS + ED_DATE+6(2).

ENDFUNCTION.
