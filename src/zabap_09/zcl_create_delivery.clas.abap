CLASS zcl_create_delivery DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_CREATE_DELIVERY IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.


MODIFY ENTITIES OF I_OutboundDeliveryTP
 ENTITY OutboundDelivery
 EXECUTE CreateDlvFromSalesDocument
 FROM VALUE #(
 ( %cid = 'DLV001'
 %param = VALUE #(
 %control = VALUE #(
 ShippingPoint = if_abap_behv=>mk-on
 DeliverySelectionDate = if_abap_behv=>mk-on
 DeliveryDocumentType = if_abap_behv=>mk-on )
 ShippingPoint = '1101'
 DeliverySelectionDate = '20240309'
 DeliveryDocumentType = 'LF'
 _ReferenceSDDocumentItem = VALUE #(
 ( %control = VALUE #(
 ReferenceSDDocument = if_abap_behv=>mk-on
* ReferenceSDDocumentItem = if_abap_behv=>mk-on
)
 ReferenceSDDocument = 'C100001036'
 ReferenceSDDocumentItem = '000010'
  ) ) ) ) )
 MAPPED DATA(ls_mapped)
 REPORTED DATA(ls_reported_modify)
 FAILED DATA(ls_failed_modify).

DATA: ls_temporary_key TYPE STRUCTURE FOR KEY OF I_OutboundDeliveryTP.

COMMIT ENTITIES BEGIN
 RESPONSE OF I_OutboundDeliveryTP
 FAILED DATA(ls_failed_save)
 REPORTED DATA(ls_reported_save).

CONVERT KEY OF I_OutboundDeliveryTP FROM ls_temporary_key TO DATA(ls_final_key).
COMMIT ENTITIES END.


*MODIFY ENTITIES OF I_OutboundDeliveryTP
* ENTITY OutboundDelivery
* CREATE BY \_Item
* FROM VALUE #( ( %tky = VALUE #( OutboundDelivery = ls_final_key-OutboundDelivery )
* %target = VALUE #(
* %control = VALUE #( Material = if_abap_behv=>mk-on
*                     ActualDeliveredQtyInOrderUnit = if_abap_behv=>mk-on
*                     OrderQuantityUnit = if_abap_behv=>mk-on
*                     OutboundDeliveryItem = if_abap_behv=>mk-on
*                     BATCH = if_abap_behv=>mk-on )
* ( %cid = 'I001'
* Material = '000000000040000023'
* ActualDeliveredQtyInOrderUnit = '111'
* OrderQuantityUnit = 'L'
* OutboundDeliveryItem = '000010'
* BATCH = '0000000082' ) ) ) )
* MAPPED DATA(ls_mapped_1)
* REPORTED DATA(ls_reported_1)
* FAILED DATA(ls_failed_1).
*
*COMMIT ENTITIES BEGIN
* RESPONSE OF I_OutboundDeliveryTP
* FAILED DATA(ls_failed_save_1)
* REPORTED DATA(ls_reported_save_1).
*
**CONVERT KEY OF I_OutboundDeliveryTP FROM ls_temporary_key TO DATA(ls_final_key).
*COMMIT ENTITIES END.

  ENDMETHOD.
ENDCLASS.
