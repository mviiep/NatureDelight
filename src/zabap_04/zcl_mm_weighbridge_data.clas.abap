CLASS zcl_mm_weighbridge_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  INTERFACES: if_oo_adt_classrun.
    TYPES: BEGIN OF ty_ekpo,
      ebeln type ebeln,
      ebelp type ebelp,
      lgort type zde_lgort,
      end of ty_ekpo,
      tt_ekpo TYPE TABLE OF ty_ekpo.

    METHODS: me_select
    IMPORTING
      iv_ebeln TYPE ebeln OPTIONAL
    EXPORTING
      et_ekpo TYPE tt_ekpo.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_WEIGHBRIDGE_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    me_select(  ).

  ENDMETHOD.


  METHOD me_select.
*    SELECT ebeln,
*           ebelp,
*           lgort
*      FROM ekpo
*     WHERE ebeln EQ @iv_ebeln
*     into table @et_ekpo.
*    select * from zmmt_weighbridge into table @data(it_ztable).
*if sy-subrc = 0.
*  delete zmmt_weighbridge from table @it_ztable.
*endif.
  ENDMETHOD.
ENDCLASS.
