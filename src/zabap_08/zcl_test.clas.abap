CLASS zcl_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_TEST IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    SELECT SINGLE *
    FROM zmmt_weigh_bridg
    into @data(wa_tab).

wa_tab-gp_no = '1000000012'.
wa_tab-ebeln = '4900000006'.
wa_tab-ebelp = '001'.
wa_tab-fulltruckunload = abap_false.
MODIFY zmmt_weigh_bridg FROM @wa_tab.

  ENDMETHOD.
ENDCLASS.
