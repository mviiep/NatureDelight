CLASS zcl_mm_weighbridge DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE. "PUBLIC .

  PUBLIC SECTION.
    INTERFACES: if_rap_query_provider.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MM_WEIGHBRIDGE IMPLEMENTATION.


  METHOD if_rap_query_provider~select.

    IF io_request->is_data_requested( ).
      DATA(lv_top)     = io_request->get_paging( )->get_page_size( ).
      IF lv_top < 0.
        lv_top = 1.
      ENDIF.

      DATA(lv_skip)    = io_request->get_paging( )->get_offset( ).

      TRY.
         DATA(lt_input) = io_request->get_filter( )->get_as_ranges( ).
        CATCH cx_rap_query_filter_no_range INTO DATA(lx_no_sel_option).
      ENDTRY.

      IF lt_input IS NOT INITIAL.
        DATA(lr_ekpo) = lt_input[ name = 'EBELN' ]-range.
        DATA(lv_ebeln)  = VALUE ebeln( lr_ekpo[ 1 ]-low OPTIONAL ).

        SELECT PurchaseOrder as ebeln,
               PurchaseOrderItem as ebelp,
               StorageLocation as lgort,
               OrderQuantity,
               PurchaseOrderQuantityUnit,
               YY1_ChillingCenteChill_PDI as YY1_ChillingCenter_PDI,
*               YY1_ChillingCenter_PDI,
               YY1_Compartment_PDI
        FROM I_PurchaseOrderItemAPI01
       WHERE PurchaseOrder EQ @lv_ebeln
       INTO TABLE @DATA(lt_ekpo).

*    select * from zmmt_weighbridge into table @data(it_ztable).
if sy-subrc = 0.
 " delete zmmt_weighbridge from table @it_ztable.
endif.
      ENDIF.

      io_response->set_data( lt_ekpo ).
      IF io_request->is_total_numb_of_rec_requested(  ).
        io_response->set_total_number_of_records( lines( lt_ekpo ) ).
      ENDIF.

    ENDIF.
  ENDMETHOD.
ENDCLASS.
