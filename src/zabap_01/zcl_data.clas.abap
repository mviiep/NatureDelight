CLASS zcl_data DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_DATA IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA it_data TYPE TABLE OF zmm_milk_miro.

    it_data = VALUE #( ( mirodoc  = '5105600242'
     miroyear = '2025'
    lifnr   = '20000001'
    name1   = 'test'
    plant    = '1101'
    sloc       = 'S001'    ) ).

    modify zmm_milk_miro from TABLE @it_data.


  ENDMETHOD.
ENDCLASS.
