CLASS zcl_mm_weighbridge_api DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
  "Constructor
  CLASS-METHODS: get_Instance RETURNING VALUE(ro_instance) TYPE REF TO zcl_mm_weighbridge_api.
  PROTECTED SECTION.
  PRIVATE SECTION.
  CLASS-DATA: mo_instance TYPE REF TO zcl_mm_weighbridge_api,
              gt_records TYPE TABLE OF zmmt_weighbridge.
ENDCLASS.



CLASS ZCL_MM_WEIGHBRIDGE_API IMPLEMENTATION.


  METHOD get_instance.
    mo_instance = ro_instance = COND #(  WHEN mo_instance IS BOUND
                                         THEN mo_instance
                                         ELSE NEW #(  ) ).
  ENDMETHOD.
ENDCLASS.
