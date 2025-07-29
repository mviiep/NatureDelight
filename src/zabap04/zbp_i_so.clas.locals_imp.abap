CLASS lsc_zi_so DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_so IMPLEMENTATION.

  METHOD save_modified.

    DATA: ls_so_temp_key TYPE STRUCTURE FOR KEY OF i_salesordertp.
    DATA : lt_zsdt_so           TYPE STANDARD TABLE OF zsdt_so,
           lt_zsdt_new          TYPE STANDARD TABLE OF zsdt_so,
           ls_zsdt_so           TYPE                   zsdt_so,
           lt_zsdt_so_x_control TYPE STANDARD TABLE OF zsdt_so_x,
           lr_id                TYPE RANGE OF zsdt_so-id.

    IF create IS NOT INITIAL.
*      CLEAR lt_zsdt_so.
      lt_zsdt_so = CORRESPONDING #( create-ziso  ).

***************************************************

**********************************************
      MODIFY zsdt_so FROM TABLE @lt_zsdt_so.
    ENDIF.

    IF update IS NOT INITIAL.
      CLEAR lt_zsdt_so.
      lt_zsdt_so = CORRESPONDING #( update-ziso  ).
      lt_zsdt_so_x_control = CORRESPONDING #( update-ziso MAPPING FROM ENTITY USING CONTROL ).

      lr_id = VALUE #( FOR ls_id IN update-ziso
                        (  sign = 'I' option = 'EQ' low = ls_id-id ) ).
      SELECT *
        FROM zsdt_so
        WHERE id IN @lr_id
        INTO TABLE @DATA(lt_so_old).


      "Prepare DB Table to update
      lt_zsdt_new = VALUE #(
                            FOR x = 1 WHILE x <= lines( lt_zsdt_so )
                            LET
                            ls_controlflag = VALUE #( lt_zsdt_so_x_control[ x ] OPTIONAL )
                            ls_so_upd = VALUE #( lt_zsdt_so[ x ] OPTIONAL )
                            ls_so_old = VALUE #( lt_so_old[ id = ls_so_upd-id ] OPTIONAL )
                            IN
                            (
                            id   = ls_so_old-id
                            "Update other columns, if found controlflag as X - else pass DB values
                            soid = COND #( WHEN ls_controlflag-soid IS NOT INITIAL THEN ls_so_upd-soid ELSE ls_so_old-soid )
                            auart = COND #( WHEN ls_controlflag-auart IS NOT INITIAL THEN ls_so_upd-auart ELSE ls_so_old-auart )
                            vkorg = COND #( WHEN ls_controlflag-vkorg IS NOT INITIAL THEN ls_so_upd-vkorg ELSE ls_so_old-vkorg )
                            vtweg = COND #( WHEN ls_controlflag-vtweg IS NOT INITIAL THEN ls_so_upd-vtweg ELSE ls_so_old-vtweg )
                            spart = COND #( WHEN ls_controlflag-spart IS NOT INITIAL THEN ls_so_upd-spart ELSE ls_so_old-spart )
                            kunnr = COND #( WHEN ls_controlflag-kunnr IS NOT INITIAL THEN ls_so_upd-kunnr ELSE ls_so_old-kunnr )
                          bstkde = COND #( WHEN ls_controlflag-bstkde  IS NOT INITIAL THEN ls_so_upd-bstkde ELSE ls_so_old-bstkde )
                            bstkd = COND #( WHEN ls_controlflag-bstkd IS NOT INITIAL THEN ls_so_upd-bstkd ELSE ls_so_old-bstkd )
                            knumv = COND #( WHEN ls_controlflag-knumv IS NOT INITIAL THEN ls_so_upd-knumv ELSE ls_so_old-knumv )
                            audat = COND #( WHEN ls_controlflag-audat IS NOT INITIAL THEN ls_so_upd-audat ELSE ls_so_old-audat )
                         prcdate = COND #( WHEN ls_controlflag-prcdate IS NOT INITIAL THEN ls_so_upd-prcdate ELSE ls_so_old-prcdate )
                            matnr = COND #( WHEN ls_controlflag-matnr IS NOT INITIAL THEN ls_so_upd-matnr ELSE ls_so_old-matnr )
                            posnr = COND #( WHEN ls_controlflag-posnr IS NOT INITIAL THEN ls_so_upd-posnr ELSE ls_so_old-posnr )
                            kdmat = COND #( WHEN ls_controlflag-kdmat IS NOT INITIAL THEN ls_so_upd-kdmat ELSE ls_so_old-kdmat )
                            gstin = COND #( WHEN ls_controlflag-gstin IS NOT INITIAL THEN ls_so_upd-gstin ELSE ls_so_old-gstin )
                            kwmeng = COND #( WHEN ls_controlflag-kwmeng IS NOT INITIAL THEN ls_so_upd-kwmeng ELSE ls_so_old-kwmeng )
                            vrkme = COND #( WHEN ls_controlflag-vrkme IS NOT INITIAL THEN ls_so_upd-vrkme ELSE ls_so_old-vrkme )
                            pstyv = COND #( WHEN ls_controlflag-pstyv IS NOT INITIAL THEN ls_so_upd-pstyv ELSE ls_so_old-pstyv )
                            werks = COND #( WHEN ls_controlflag-werks IS NOT INITIAL THEN ls_so_upd-werks ELSE ls_so_old-werks )
                            vbeln = COND #( WHEN ls_controlflag-vbeln IS NOT INITIAL THEN ls_so_upd-vbeln ELSE ls_so_old-vbeln )
                            )  ).

      MODIFY zsdt_so FROM TABLE @lt_zsdt_new.
    ENDIF.



    IF zbp_i_so=>mapped_sales_order-salesorder IS NOT INITIAL.
      LOOP AT zbp_i_so=>mapped_sales_order-salesorder ASSIGNING FIELD-SYMBOL(<fs_pr_mapped>).
        CONVERT KEY OF i_salesordertp FROM ls_so_temp_key-salesorder TO DATA(ls_so_final_key).
        <fs_pr_mapped>-salesorder = ls_so_final_key-salesorder.

        LOOP AT update-ziso INTO  DATA(ls_so).
          UPDATE zsdt_so SET vbeln = @ls_so_final_key-salesorder WHERE soid = @ls_so-soid.
        ENDLOOP.
      ENDLOOP.
    ENDIF.

    IF delete IS NOT INITIAL.
      lt_zsdt_so = CORRESPONDING #( delete-ziso  ).
      LOOP AT   lt_zsdt_so INTO ls_zsdt_so.
        DELETE  FROM zsdt_so  WHERE  id = @ls_zsdt_so-id.
      ENDLOOP.
    ENDIF.


  ENDMETHOD.

ENDCLASS.

CLASS lhc_zi_so DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ziso RESULT result.
    METHODS createso FOR MODIFY
      IMPORTING keys FOR ACTION ziso~createso RESULT result.

*    METHODS get_global_features FOR GLOBAL FEATURES
*      IMPORTING REQUEST requested_features FOR ziso RESULT result.

ENDCLASS.

CLASS lhc_zi_so IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD createso.

    DATA: lt_so_h        TYPE TABLE FOR CREATE i_salesordertp,
          lt_so_i        TYPE TABLE FOR CREATE i_salesordertp\_item,
          ls_so_i        LIKE LINE OF lt_so_i,
          lt_so_p        TYPE TABLE FOR CREATE i_salesordertp\_partner,
          ls_so_p        LIKE LINE OF lt_so_p,
          lv_soid(10)    TYPE c,
*          lv_Posnr(6)    type n,
          lv_total_crate TYPE menge_d.

    DATA : update_lines TYPE TABLE FOR UPDATE zi_so\\ziso,
           update_line  TYPE STRUCTURE FOR UPDATE zi_so\\ziso.


    READ ENTITIES OF zi_so IN LOCAL MODE
        ENTITY ziso
          ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(members).

    DATA(lt_keys) = keys.

 if members[] is not initial.
    SORT members BY soid.

    SELECT * FROM ZC_SO
 FOR ALL ENTRIES IN @MEMBERS
 WHERE SOID = @MEMBERS-SOID ORDER BY PRIMARY KEY
 INTO TABLE @DATA(IT_SO) .
    SORT members BY soid.
    DELETE ADJACENT DUPLICATES FROM members COMPARING soid.
    sort IT_SO by soid.
   endif.
    LOOP AT members ASSIGNING FIELD-SYMBOL(<fs>).
      IF lv_soid <> <fs>-soid.
        lv_soid = <fs>-soid.

"#EC CI_SORTED
*        clear lv_Posnr.
        LOOP AT it_so ASSIGNING FIELD-SYMBOL(<fs_member>) WHERE soid = lv_soid.

          lv_total_crate = lv_total_crate + <fs_member>-kwmeng.

          SELECT SINGLE baseunit FROM i_product
          WITH PRIVILEGED ACCESS
          WHERE product = @<fs_member>-matnr
          INTO @DATA(lv_base_unit).

          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = @lv_base_unit
          AND product = @<fs_member>-matnr
          AND baseunit = @lv_base_unit
          INTO @DATA(lw_base_unit).

          SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
          FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
          WHERE alternativeunit = @<fs_member>-vrkme
          AND product = @<fs_member>-matnr
          AND baseunit = @lv_base_unit
          INTO @DATA(lw_source_unit).

          IF lw_base_unit-quantitynumerator IS NOT INITIAL
            AND lw_source_unit-quantitynumerator IS NOT INITIAL.

            <fs_member>-kwmeng = ( lw_base_unit-quantitynumerator / lw_base_unit-quantitydenominator ) *
                                 ( lw_source_unit-quantitynumerator / lw_source_unit-quantitydenominator ) *
                                 <fs_member>-kwmeng.
          ENDIF.

          <fs_member>-vrkme = lv_base_unit.

          lt_so_h = VALUE #( ( %cid = 'H001'
                               %data = VALUE #( salesordertype = <fs_member>-auart
                                               salesorganization = <fs_member>-vkorg
                                               distributionchannel = <fs_member>-vtweg
                                               organizationdivision = <fs_member>-spart
                                               soldtoparty = <fs_member>-kunnr
                                               purchaseorderbycustomer = <fs_member>-bstkd
                                               pricingdate = <fs_member>-prcdate
                                               requesteddeliverydate = <fs_member>-audat
                                               shippingcondition = <fs_member>-knumv
                                               )

                               %control = VALUE #(
                                               salesordertype = if_abap_behv=>mk-on
                                               salesorganization = if_abap_behv=>mk-on
                                               distributionchannel = if_abap_behv=>mk-on
                                               organizationdivision = if_abap_behv=>mk-on
                                               soldtoparty = if_abap_behv=>mk-on
                                               purchaseorderbycustomer = if_abap_behv=>mk-on
                                               pricingdate = if_abap_behv=>mk-on
                                               requesteddeliverydate = if_abap_behv=>mk-on
                                               shippingcondition = if_abap_behv=>mk-on
                                               ) ) )
                                               .
          lt_so_p =  VALUE #( ( %cid_ref = 'H001'
                                 salesorder = space
                                 %target = VALUE #( ( %cid = 'P001'
*                                                     Personnel = <fs_member>-bstkde
*                                                     %control-Personnel = if_abap_behv=>mk-on
                                                     customer = <fs_member>-bstkd
                                                     %control-customer = if_abap_behv=>mk-on
*                                                     PartnerFunction = 'WE'
*                                                     %control-PartnerFunction = if_abap_behv=>mk-on
                                                     partnerfunctionforedit = 'WE'
                                                     %control-partnerfunctionforedit = if_abap_behv=>mk-on
                                                      ) ) ) ).

*          lv_Posnr = lv_Posnr + 10.

          APPEND VALUE #(  %cid = <fs_member>-posnr
                                      product = <fs_member>-matnr
                                      %control-product = if_abap_behv=>mk-on
                                      materialbycustomer = <fs_member>-kdmat
                                      %control-materialbycustomer = if_abap_behv=>mk-on
                                      requestedquantity = <fs_member>-kwmeng
                                      %control-requestedquantity = if_abap_behv=>mk-on
                                      requestedquantityunit = <fs_member>-vrkme
                                      %control-requestedquantityunit = if_abap_behv=>mk-on
*                                      salesorderitemcategory = <fs_member>-pstyv
*                                      %control-salesorderitemcategory = if_abap_behv=>mk-on
                                      plant = <fs_member>-werks
                                      %control-plant = if_abap_behv=>mk-on
                                      )  TO ls_so_i-%target.
"#EC CI_SORTED
          AT LAST.
*          lv_Posnr = lv_Posnr + 10.
            <fs_member>-posnr = <fs_member>-posnr + 10.
            APPEND VALUE #(  %cid = <fs_member>-posnr
                                         product = '000000000000000029'
                                         %control-product = if_abap_behv=>mk-on
*                                      materialbycustomer = <fs_member>-Kdmat
*                                      %control-materialbycustomer = if_abap_behv=>mk-on
                                         requestedquantity = lv_total_crate
                                         %control-requestedquantity = if_abap_behv=>mk-on
                                         requestedquantityunit = 'ST'
                                         %control-requestedquantityunit = if_abap_behv=>mk-on
*                                      salesorderitemcategory = <fs_member>-pstyv
*                                      %control-salesorderitemcategory = if_abap_behv=>mk-on
                                         plant = '1101'
                                         %control-plant = if_abap_behv=>mk-on
                                         )  TO ls_so_i-%target.

"#EC CI_SORTED
          ENDAT.

          update_line-id                   = <fs_member>-id.
          update_line-soid                 = <fs_member>-soid.
          APPEND update_line TO update_lines.


        ENDLOOP.


        IF lt_so_h IS NOT INITIAL.
          lt_so_i =  VALUE #( ( %cid_ref = 'H001'
                                 salesorder = space
                                 %target =  ls_so_i-%target ) ).

*    -------Create sales order----

          MODIFY ENTITIES OF i_salesordertp
          ENTITY salesorder
          CREATE
          FROM lt_so_h
          CREATE BY \_item FROM lt_so_i
          CREATE BY \_partner FROM lt_so_p
          MAPPED DATA(ls_mapped)
          FAILED DATA(ls_failed)
          REPORTED DATA(ls_reported).


          "retrieve the generated SO
          zbp_i_so=>mapped_sales_order-salesorder = ls_mapped-salesorder.


          CLEAR:  lt_so_i[], lt_so_h[].
        ENDIF.
      ENDIF.
    ENDLOOP.



*    MODIFY ENTITIES OF zi_so IN LOCAL MODE
*      ENTITY ziso
*      UPDATE
*      FIELDS (  Vbeln )
*      WITH update_lines
*      REPORTED reported
*      FAILED failed
*      MAPPED mapped.
*
*      READ ENTITIES OF  zi_so  IN LOCAL MODE  ENTITY ziso
*    ALL FIELDS WITH CORRESPONDING #( update_lines ) RESULT DATA(lt_final).
*
*    result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
*     %param = lw_final  )  ).


  ENDMETHOD.

*  METHOD get_global_features.
*  ENDMETHOD.

ENDCLASS.
