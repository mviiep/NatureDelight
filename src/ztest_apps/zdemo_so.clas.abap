CLASS zdemo_so DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZDEMO_SO IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA: lt_so_h     TYPE TABLE FOR CREATE i_salesordertp,
          lt_so_i     TYPE TABLE FOR CREATE i_salesordertp\_item,
          ls_so_i     LIKE LINE OF lt_so_i,
          lt_so_p     TYPE TABLE FOR CREATE i_salesordertp\_partner,
          ls_so_p     LIKE LINE OF lt_so_p,
          lv_soid(10) TYPE c.


*  lt_so_h = VALUE #( ( %cid = 'H001'
*                               %data = VALUE #( salesordertype = 'TA'
*                                               salesorganization = '1000'
*                                               distributionchannel = '20'
*                                               organizationdivision = '00'
*                                               soldtoparty = '0001000011'
*                                               purchaseorderbycustomer = '0000000084'
*                                               pricingdate = '20240123'
*                                               requesteddeliverydate = '20240125'
*                                               shippingcondition = '01'
*                                                )
*                               %control = VALUE #(
*                                               salesordertype = if_abap_behv=>mk-on
*                                               salesorganization = if_abap_behv=>mk-on
*                                               distributionchannel = if_abap_behv=>mk-on
*                                               organizationdivision = if_abap_behv=>mk-on
*                                               soldtoparty = if_abap_behv=>mk-on
*                                               purchaseorderbycustomer = if_abap_behv=>mk-on
*                                               pricingdate = if_abap_behv=>mk-on
*                                               requesteddeliverydate = if_abap_behv=>mk-on
*                                               shippingcondition = if_abap_behv=>mk-on
*                                               ) ) ).
*
*    lt_so_p =  VALUE #( ( %cid_ref = 'H001'
*                                 salesorder = space
*                                 %target = VALUE #( ( %cid = 'P001'
*                                                     Customer = '0001000020'
*                                                     %control-Personnel = if_abap_behv=>mk-on
**                                                     Customer = <fs_member>-bstkde
**                                                     %control-Customer = if_abap_behv=>mk-on
**                                                     PartnerFunction = 'WE'
**                                                     %control-PartnerFunction = if_abap_behv=>mk-on
*                                                     partnerfunctionforedit = 'WE'
*                                                     %control-PartnerFunctionForEdit = if_abap_behv=>mk-on
*                                                      ) ) ) ).
*
*
*           APPEND VALUE #(  %cid = '0010'
*                                      product = '000000000000000054'
*                                      %control-product = if_abap_behv=>mk-on
*
*
*                                      requestedquantity = '22.00'
*                                      %control-requestedquantity = if_abap_behv=>mk-on
*                                      requestedquantityunit = 'KG'
*                                      %control-requestedquantityunit = if_abap_behv=>mk-on
**                                      salesorderitemcategory = <fs_member>-pstyv
**                                      %control-salesorderitemcategory = if_abap_behv=>mk-on
*                                      plant = '1101'
*                                      %control-plant = if_abap_behv=>mk-on
*                                      )  TO ls_so_i-%target.
*
*          lt_so_i =  VALUE #( ( %cid_ref = 'H001'
*                                 salesorder = space
*                                 %target =  ls_so_i-%target ) ).
*
*        MODIFY ENTITIES OF i_salesordertp
*          ENTITY salesorder
*          CREATE
*          FROM lt_so_h
*          CREATE BY \_item FROM lt_so_i
*          CREATE BY \_partner FROM lt_so_p
*          MAPPED DATA(ls_mapped)
*          FAILED DATA(ls_failed)
*          REPORTED DATA(ls_reported).





*MODIFY ENTITIES OF i_salesordertp
* ENTITY salesorder
* CREATE
*    FIELDS ( salesordertype
*     salesorganization
*     distributionchannel
*     organizationdivision
*     soldtoparty )
* WITH VALUE #( ( %cid = 'H001'
* %data = VALUE #( salesordertype = 'TA'
* salesorganization = '1000'
* distributionchannel = '20'
* organizationdivision = '00'
* soldtoparty = '0001000011' ) ) )
* CREATE BY \_item
* FIELDS ( product
* requestedquantity )
* WITH VALUE #( ( %cid_ref = 'H001'
* salesorder = space
* %target = VALUE #( ( %cid = 'I001'
* product = '000000000000000054'
* requestedquantity = '1' ) ) ) )
* ENTITY salesorderitem
* CREATE BY \_itempartner
* FIELDS ( partnerfunctionforedit
* customer )
* WITH VALUE #( ( %cid_ref = 'I001'
* salesorder = space
* salesorderitem = space
* %target = VALUE #( ( %cid = 'IP001'
* partnerfunctionforedit = 'WE'
* customer = '0001000020' ) ) ) )
* MAPPED DATA(ls_mapped)
* FAILED DATA(ls_failed)
* REPORTED DATA(ls_reported).
*
*DATA: ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp,
* ls_so_item_temp_key TYPE STRUCTURE FOR KEY OF i_salesorderitemtp,
* ls_so_item_partner_temp_key TYPE STRUCTURE FOR KEY OF i_salesorderitempartnertp.
*
*COMMIT ENTITIES BEGIN
* RESPONSE OF i_salesordertp
* FAILED DATA(ls_save_failed)
* REPORTED DATA(ls_save_reported).
*
**CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).
*
*MOVE-CORRESPONDING ls_mapped-salesorderitem[ 1 ] to ls_so_item_temp_key.
**CONVERT KEY OF i_salesorderitemtp FROM ls_so_item_temp_key TO DATA(ls_so_item_final_key).
*
*MOVE-CORRESPONDING ls_mapped-salesorderitempartner[ 1 ] to ls_so_item_partner_temp_key.
**CONVERT KEY OF i_salesorderitempartnertp FROM ls_so_item_partner_temp_key TO DATA(ls_so_item_partner_final_key).
*
*COMMIT ENTITIES END.


*MODIFY ENTITIES OF i_salesordertp
* ENTITY salesorder
* CREATE
*    FIELDS ( salesordertype
*     salesorganization
*     distributionchannel
*     organizationdivision
*     soldtoparty )
* WITH VALUE #( ( %cid = 'H001'
* %data = VALUE #( salesordertype = 'TA'
* salesorganization = '1000'
* distributionchannel = '20'
* organizationdivision = '00'
* soldtoparty = '0001000011'
* ) ) )
* CREATE BY \_partner
* FIELDS (  Customer
* partnerfunctionforedit )
* WITH VALUE #( ( %cid_ref = 'H001'
* salesorder = space
* %target = VALUE #( ( %cid = 'P001'
* Customer = '0001000020'
*
* partnerfunctionforedit = 'WE' ) ) ) )
*
* MAPPED DATA(ls_mapped)
* FAILED DATA(ls_failed)
* REPORTED DATA(ls_reported).
*
*DATA: ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp,
* ls_so_partner_temp_key TYPE STRUCTURE FOR KEY OF i_salesorderpartnertp.
*
*COMMIT ENTITIES BEGIN
* RESPONSE OF i_salesordertp
* FAILED DATA(ls_save_failed)
* REPORTED DATA(ls_save_reported).

*CONVERT KEY OF i_salesordertp FROM ls_so_temp_key TO DATA(ls_so_final_key).

*MOVE-CORRESPONDING ls_mapped-salesorderpartner[ 1 ] to ls_so_partner_temp_key.
*CONVERT KEY OF i_salesorderpartnertp FROM ls_so_partner_temp_key TO DATA(ls_so_partner_final_key).

*COMMIT ENTITIES END.
*data : lv_mat  type menge_D.
*   call METHOD zcl_material_qty_conversion=>material_conversion(
*   EXPORTING
*    im_material = '000000000040000004'
*    im_source_value = '20'
*    im_source_unit = 'EA'
*    im_target_unit = 'KI'
*     IMPORTING
*     e_target_value = lv_mat
*    ).

    READ ENTITIES OF i_journalentrytp
    ENTITY journalentry ALL FIELDS WITH VALUE #( (
*                                %pid = 'P001'
                                CompanyCode = '1000'
                                AccountingDocument = '0200000006'
                                FiscalYear = '2023'
                                ) )
    RESULT DATA(lt_check_result)
    FAILED DATA(ls_failed_deep)
    REPORTED DATA(ls_reported_deep).


    DATA(lt_check_result1) = lt_check_result.

  ENDMETHOD.
ENDCLASS.
