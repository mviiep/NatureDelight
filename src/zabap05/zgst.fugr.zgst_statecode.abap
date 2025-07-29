FUNCTION ZGST_STATECODE.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_REGION) TYPE  REGIO
*"  EXPORTING
*"     REFERENCE(EV_STATE_CD) TYPE  ZCHAR2
*"----------------------------------------------------------------------
 CASE IV_REGION.

 WHEN 'JK'.
   EV_STATE_CD = '01'.
 WHEN 'HP'.
   EV_STATE_CD = '02'.
 WHEN 'PB'.
   EV_STATE_CD = '03'.
 WHEN 'CH'.
   EV_STATE_CD = '04'.
 WHEN 'UK'.
   EV_STATE_CD = '05'.
 WHEN 'HR'.
   EV_STATE_CD = '06'.
 WHEN 'DL'.
   EV_STATE_CD = '07'.
 WHEN 'RJ'.
   EV_STATE_CD = '08'.
 WHEN 'UP'.
   EV_STATE_CD = '09'.
 WHEN 'BR'.
   EV_STATE_CD = '10'.
 WHEN 'SK'.
   EV_STATE_CD = '11'.
 WHEN 'AR'.
   EV_STATE_CD = '12'.
 WHEN 'NL'.
   EV_STATE_CD = '13'.
 WHEN 'MN'.
   EV_STATE_CD = '14'.
 WHEN 'MZ'.
   EV_STATE_CD = '15'.
 WHEN 'TR'.
   EV_STATE_CD = '16'.
 WHEN 'ML'.
   EV_STATE_CD = '17'.
 WHEN 'AS'.
   EV_STATE_CD = '18'.
 WHEN 'WB'.
   EV_STATE_CD = '19'.
 WHEN 'JH'.
   EV_STATE_CD = '20'.
 WHEN 'OD'.
   EV_STATE_CD = '21'.
 WHEN 'CG'.
   EV_STATE_CD = '22'.
 WHEN 'MP'.
   EV_STATE_CD = '23'.
 WHEN 'GJ'.
   EV_STATE_CD = '24'.
 WHEN 'DH'.
   EV_STATE_CD = '26'.
 WHEN 'MH'.
   EV_STATE_CD = '27'.
 WHEN 'AP'.
   EV_STATE_CD = '37'.
 WHEN 'KA'.
   EV_STATE_CD = '29'.
 WHEN 'GA'.
   EV_STATE_CD = '30'.
 WHEN 'LD'.
   EV_STATE_CD = '31'.
 WHEN 'KL'.
   EV_STATE_CD = '32'.
 WHEN 'TN'.
   EV_STATE_CD = '33'.
 WHEN 'PY'.
   EV_STATE_CD = '34'.
 WHEN 'AN'.
   EV_STATE_CD = '35'.
 WHEN 'TS'.
   EV_STATE_CD = '36'.
 WHEN 'LA'.
   EV_STATE_CD = '38'.
 ENDCASE.



ENDFUNCTION.
