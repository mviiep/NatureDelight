CLASS lsc_zi_gate_entry DEFINITION INHERITING FROM cl_abap_behavior_saver.

  PROTECTED SECTION.

    METHODS save_modified REDEFINITION.

ENDCLASS.

CLASS lsc_zi_gate_entry IMPLEMENTATION.

  METHOD save_modified.
    DATA : lt_gate_entry TYPE TABLE OF zdt_gate_entry,
           lw_gate_entry TYPE zdt_gate_entry.
    DATA : nr_number  TYPE cl_numberrange_runtime=>nr_number,
           lv_retcode TYPE cl_numberrange_runtime=>nr_returncode.


    IF    create-gateentry IS NOT INITIAL.

      lt_gate_entry = CORRESPONDING #(  create-gateentry  MAPPING
      batch = batch
      comodity = comodity
      driver_mobile = drivermobile
      driver_name = drivername
      entry_type = entrytype
      gate_entry_no = gateentryno
      inbound_type = inboundtype
      in_date = indate
      in_time = intime
      out_date = outdate
      out_time = outtime
      purpose = purpose
      sto_no = stono
      vehicle_no = vehicleno
      vehicle_out = vehicleout
      pdf_attach    = pdfattach
      mimetype    = mimetype
      filename   = filename
      ).

      LOOP AT lt_gate_entry ASSIGNING FIELD-SYMBOL(<fs_gate_entry>).
        TRANSLATE <fs_gate_entry>-vehicle_no TO UPPER CASE.
      ENDLOOP.
      INSERT zdt_gate_entry FROM TABLE @lt_gate_entry.



    ENDIF.


    IF  zbp_i_gate_entry=>mapped_gate_entry IS NOT INITIAL AND update IS NOT INITIAL.


      lt_gate_entry = CORRESPONDING #(  zbp_i_gate_entry=>mapped_gate_entry  MAPPING
   batch = batch
   comodity = comodity
   driver_mobile = drivermobile
   driver_name = drivername
   entry_type = entrytype
   gate_entry_no = gateentryno
   inbound_type = inboundtype
   in_date = indate
   in_time = intime
   out_date = outdate
   out_time = outtime
   purpose = purpose
   sto_no = stono
   vehicle_no = vehicleno
   vehicle_out = vehicleout

    ).
      MODIFY zdt_gate_entry FROM TABLE @lt_gate_entry.
    ENDIF.



    IF    update IS NOT INITIAL AND zbp_i_gate_entry=>mapped_gate_entry IS INITIAL.

      lt_gate_entry = CORRESPONDING #(  update-gateentry  MAPPING
   batch = batch
   comodity = comodity
   driver_mobile = drivermobile
   driver_name = drivername
   entry_type = entrytype
   gate_entry_no = gateentryno
   inbound_type = inboundtype
   in_date = indate
   in_time = intime
   out_date = outdate
   out_time = outtime
   purpose = purpose
   sto_no = stono
   vehicle_no = vehicleno
   vehicle_out = vehicleout

    ).
      LOOP AT lt_gate_entry ASSIGNING <fs_gate_entry>.
        TRANSLATE <fs_gate_entry>-vehicle_no TO UPPER CASE.
      ENDLOOP.
      MODIFY zdt_gate_entry FROM TABLE @lt_gate_entry.
    ENDIF.

    IF   update IS NOT INITIAL AND zbp_i_gate_entry=>mapped_entry IS  NOT  INITIAL.

      lt_gate_entry = CORRESPONDING #(  update-gateentry  MAPPING
    batch = batch
    comodity = comodity
    driver_mobile = drivermobile
    driver_name = drivername
    entry_type = entrytype
    gate_entry_no = gateentryno
    inbound_type = inboundtype
    in_date = indate
    in_time = intime
    out_date = outdate
    out_time = outtime
    purpose = purpose
    sto_no = stono
    vehicle_no = vehicleno
    vehicle_out = vehicleout
    pdf_attach  = pdfattach
    filename    = filename
    mimetype    = mimetype

     ).
      MODIFY zdt_gate_entry FROM TABLE @lt_gate_entry.
    ENDIF.

    IF delete-gateentry IS NOT INITIAL.
      LOOP AT delete-gateentry INTO DATA(gateentry_delete).
        DELETE FROM zdt_gate_entry WHERE gate_entry_no = @gateentry_delete-gateentryno.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


ENDCLASS.

CLASS lhc_zi_gate_entry DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_gate_entry RESULT result.
*    METHODS get_instance_features FOR INSTANCE FEATURES
*      IMPORTING keys REQUEST requested_features FOR gateentry RESULT result.
*    METHODS hide_fields_for_outbound FOR DETERMINE ON MODIFY
*      IMPORTING keys FOR gateentry~hide_fields_for_outbound.
    METHODS check_sto_number FOR VALIDATE ON SAVE
      IMPORTING keys FOR gateentry~check_sto_number.
    METHODS validate_material FOR VALIDATE ON SAVE
      IMPORTING keys FOR gateentry~validate_material.
    METHODS populate_entry_on_save FOR DETERMINE ON SAVE
      IMPORTING keys FOR gateentry~populate_entry_on_save.
    METHODS vehicle_out FOR MODIFY
      IMPORTING keys FOR ACTION gateentry~vehicle_out RESULT result.
    METHODS print_gate_pass FOR MODIFY
      IMPORTING keys FOR ACTION gateentry~print_gate_pass RESULT result.
    METHODS validate_vehicle_out FOR VALIDATE ON SAVE
      IMPORTING keys FOR gateentry~validate_vehicle_out.
    METHODS earlynumbering_create FOR NUMBERING
      IMPORTING entities FOR  CREATE gateentry.

ENDCLASS.

CLASS lhc_zi_gate_entry IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD earlynumbering_create.
    DATA lv_message1(50)  TYPE c.
    DATA : nr_number  TYPE cl_numberrange_runtime=>nr_number,
           lv_retcode TYPE cl_numberrange_runtime=>nr_returncode.
    TRY.
        CALL METHOD cl_numberrange_runtime=>number_get
          EXPORTING
            nr_range_nr = '01'
            object      = 'Z_GATE_ENT'
          IMPORTING
            number      = nr_number
            returncode  = lv_retcode.
      CATCH cx_nr_object_not_found.
      CATCH cx_number_ranges..
    ENDTRY.

    LOOP AT entities INTO DATA(lw_entity).

      DATA(lv_number) = |{ nr_number ALPHA = OUT }|.
      APPEND VALUE #(  %cid = lw_entity-%cid
                       gateentryno =  lv_number
                       ) TO mapped-gateentry.
      lv_message1 = 'Gate Entry ' && || && lv_number && ||  &&' Created Sucessfully'.

      APPEND VALUE #(  %cid = lw_entity-%cid
                       %msg = new_message_with_text(
                       severity = if_abap_behv_message=>severity-success
                        text =  lv_message1
                        )

      ) TO  reported-gateentry.
    ENDLOOP.
  ENDMETHOD.

*  METHOD get_instance_features.
*
*
*
*  ENDMETHOD.

*  METHOD hide_fields_for_outbound.
*    READ ENTITIES OF zi_gate_entry IN LOCAL MODE
*      ENTITY gateentry ALL FIELDS  WITH CORRESPONDING #( keys )
*      RESULT DATA(lt_result).
*
*    LOOP AT lt_result INTO DATA(lw_result).
*      IF lw_result-entrytype = 'OUT'.
*        MODIFY ENTITIES OF  zi_gate_entry IN LOCAL MODE
*        ENTITY gateentry UPDATE FIELDS ( inboundtype )
*        WITH VALUE #( ( %tky = lw_result-%tky
*       %control-inboundtype = if_abap_behv=>fc-o-disabled
*          ) ) .
*
*      ENDIF.
*    ENDLOOP.
*
*  ENDMETHOD.

  METHOD check_sto_number.
    READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
    ENTITY gateentry
   FIELDS ( stono ) WITH CORRESPONDING #( keys )
   RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).
      IF  lw_result-inboundtype = 'DOC/OL/BMC' AND lw_result-stono IS INITIAL.
        APPEND VALUE #( %tky =  lw_result-%tky ) TO failed-gateentry.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                         %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                          text = 'Please Enter STO Number'
                          )

        ) TO  reported-gateentry.
      ELSEIF lw_result-inboundtype = 'DOC/OL/BMC' AND lw_result-stono IS NOT INITIAL.

        SELECT  COUNT( * ) FROM  i_purchaseorderapi01 WITH PRIVILEGED ACCESS
        WHERE purchaseorder = @lw_result-stono AND (  purchaseordertype = 'ZSTO' OR purchaseordertype = 'UB' )
        INTO @DATA(lv_count).
        IF lv_count IS INITIAL.

          APPEND VALUE #( %tky =  lw_result-%tky ) TO failed-gateentry.
          APPEND VALUE #( %tky = keys[ 1 ]-%tky
                           %msg = new_message_with_text(
                           severity = if_abap_behv_message=>severity-error
                            text = 'Please Check STO Number'
                            )

          ) TO  reported-gateentry.


        ENDIF.

*        SELECT COUNT( * ) FROM zdt_gate_entry
*         WHERE sto_no =  @lw_result-stono,9
*        INTO @DATA(lv_count1).
*        IF lv_count1 IS NOT INITIAL.
*          APPEND VALUE #( %tky =  lw_result-%tky ) TO failed-gateentry.
*          APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                           %msg = new_message_with_text(
*                           severity = if_abap_behv_message=>severity-error
*                            text = 'STO No is already used in other Gate Entry'
*                            )
*
*          ) TO  reported-gateentry.

*        ENDIF.


      ENDIF.
    ENDLOOP.
  ENDMETHOD.





  METHOD validate_material.

    READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
      ENTITY gateentry
     FIELDS ( material ) WITH CORRESPONDING #( keys )
     RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).

      IF  lw_result-inboundtype = 'BULK' AND lw_result-material IS INITIAL.

        APPEND VALUE #( %tky =  lw_result-%tky ) TO failed-gateentry.
        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                         %msg = new_message_with_text(
                         severity = if_abap_behv_message=>severity-error
                          text = 'Please Enter Material for Bulk Carriage'
                          )

        ) TO  reported-gateentry.

      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD populate_entry_on_save.

    READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
        ENTITY gateentry
       FIELDS ( material ) WITH CORRESPONDING #( keys )
       RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).
      IF lw_result-inboundtype = 'BULK'.
        DATA : nr_number  TYPE cl_numberrange_runtime=>nr_number,
               lv_retcode TYPE cl_numberrange_runtime=>nr_returncode,
               lv_batch   TYPE c LENGTH 9.
        TRY.
            CALL METHOD cl_numberrange_runtime=>number_get
              EXPORTING
                nr_range_nr = '01'
                object      = 'Z_BATCH'
              IMPORTING
                number      = nr_number
                returncode  = lv_retcode.
          CATCH cx_nr_object_not_found.
          CATCH cx_number_ranges..
        ENDTRY.
        lv_batch = |{ nr_number ALPHA = IN }|.
        lw_result-batch = 'B' &&  lv_batch.
        MODIFY ENTITIES OF i_batchtp_2
       ENTITY batch
       CREATE FROM VALUE #( ( material = lw_result-material
       batch = lw_result-batch
       manufacturedate = sy-datum
       %control-material = cl_abap_behv=>flag_changed
       %control-batch = cl_abap_behv=>flag_changed
       %control-manufacturedate = cl_abap_behv=>flag_changed
       %cid = 'C1'
       ) )
       MAPPED DATA(mapped)
       FAILED DATA(failed)
       REPORTED DATA(lt_reported).
      ENDIF.
    ENDLOOP.
    DATA(lv_date) = sy-datlo.
    DATA(lv_time) = sy-timlo.
    DATA lv_out_tiem  TYPE timn.
    MODIFY  ENTITIES OF zi_gate_entry  IN LOCAL MODE
    ENTITY gateentry UPDATE FIELDS ( batch  indate intime outtime )
      WITH VALUE #( ( %tky = lw_result-%tky
     batch = lw_result-batch
     indate = lv_date
     intime = lv_time
     outtime = lv_out_tiem


 ) ) .

  ENDMETHOD.

  METHOD vehicle_out.
    DATA : lt_gate_entry_table TYPE TABLE OF  zdt_gate_entry.
    DATA lt_gate_entry TYPE TABLE FOR UPDATE zi_gate_entry.
    DATA(keys_with_gate_entry) = keys.
    DATA(lv_date) = sy-datlo.
    DATA(lv_time) = sy-timlo.

*
    READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
           ENTITY gateentry
          FIELDS ( outdate outtime vehicleout  gateentryno entrytype InDate comodity )  WITH CORRESPONDING #( keys_with_gate_entry )
          RESULT DATA(lt_result).

    LOOP AT lt_result ASSIGNING FIELD-SYMBOL(<fs_result>).
      IF <fs_result>-vehicleout = ''.

        SELECT  SINGLE fulltruckunload FROM zmmt_weigh_bridg
        WHERE gp_no  = @<fs_result>-gateentryno
        INTO @DATA(lv_full_truck_unload).
        IF  <fs_result>-indate > '20240423'.
          IF lv_full_truck_unload = '' AND <fs_result>-entrytype = 'IN' AND
          <fs_result>-comodity = 'MILK'.
            APPEND VALUE #( %tky = keys[ 1 ]-%tky
                                 %msg = new_message_with_text(
                                 severity = if_abap_behv_message=>severity-error
                                  text = 'Truck is not fully unloaded'
                                  )

                ) TO  reported-gateentry.


          ELSE.
            APPEND VALUE #( %tky  = <fs_result>-%tky
                           outdate = lv_date
                           outtime = lv_time
                           vehicleout = 'X' ) TO lt_gate_entry.
          ENDIF.
        ELSE.
          APPEND VALUE #( %tky  = <fs_result>-%tky
                     outdate = lv_date
                     outtime = lv_time
                     vehicleout = 'X' ) TO lt_gate_entry.

        ENDIF.

      ELSE.

        APPEND VALUE #( %tky = keys[ 1 ]-%tky
                            %msg = new_message_with_text(
                            severity = if_abap_behv_message=>severity-error
                             text = 'Vehicle is alreday out'
                             )

           ) TO  reported-gateentry.


      ENDIF.

    ENDLOOP.

    MODIFY ENTITIES OF zi_gate_entry  IN LOCAL MODE
    ENTITY gateentry UPDATE FIELDS ( outdate outtime vehicleout )
    WITH lt_gate_entry.

    READ ENTITIES OF  zi_gate_entry  IN LOCAL MODE  ENTITY gateentry
    ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

    result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
     %param = lw_final  )  ).



    DATA : lt_gate TYPE TABLE OF zi_gate_entry.
    lt_gate = CORRESPONDING #( lt_final ).

    zbp_i_gate_entry=>mapped_gate_entry = lt_gate.




  ENDMETHOD.

  METHOD print_gate_pass.

    DATA : lt_gate_entry_table TYPE TABLE OF  zdt_gate_entry.
    DATA lt_gate_entry TYPE TABLE FOR UPDATE zi_gate_entry.

    READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
          ENTITY gateentry
         FIELDS ( gateentryno ) WITH CORRESPONDING #( keys )
         RESULT DATA(lt_result).

    LOOP AT lt_result INTO DATA(lw_result).

      TRY.
          "Initialize Template Store Client
          DATA(lo_store) = NEW zcl_fp_tmpl_store_client(
            "name of the destination (in destination service instance) pointing to Forms Service by Adobe API service instance
            iv_name = 'AdobeFormService'
            "name of communication arrangement with scenario SAP_COM_0276
            iv_service_instance_name = 'ZADSRTEMPLATE'
          ).
*      out->write( 'Template Store Client initialized' ).
          "Initialize class with service definition
          DATA(lo_fdp_util) = cl_fp_fdp_services=>get_instance( 'ZSD_GATE_ENTRY_PRINT' ).
*      out->write( 'Dataservice initialized' ).

          "Get initial select keys for service
          DATA(lt_keys)     = lo_fdp_util->get_keys( ).
          lt_keys[ name = 'GATEENTRYNO' ]-value = lw_result-gateentryno.
          DATA(lv_xml) = lo_fdp_util->read_to_xml( lt_keys ).
*      out->write( 'Service data retrieved' ).

          DATA(ls_template) = lo_store->get_template_by_name(
            iv_get_binary     = abap_true
            iv_form_name      = 'ZGATE_ENTRY' "<= form object in template store
            iv_template_name  = 'GATE_ENTRY' "<= template (in form object) that should be used
          ).

*      out->write( 'Form Template retrieved' ).

          cl_fp_ads_util=>render_4_pq(
            EXPORTING
              iv_locale       = 'en_US'
              iv_pq_name      = 'DEFAULT' "<= Name of the print queue where result should be stored
              iv_xml_data     = lv_xml
              iv_xdp_layout   = ls_template-xdp_template
              is_options      = VALUE #(
                trace_level = 4 "Use 0 in production environment
              )
            IMPORTING
              ev_trace_string = DATA(lv_trace)
              ev_pdl          = DATA(lv_pdf)
          ).

          TRY.
*Render PDF
*    cl_fp_ads_util=>render_pdf( EXPORTING iv_xml_data      = lv_xml
*                                          iv_xdp_layout    = ls_template-xdp_template
*                                          iv_locale        = 'en_US'
**                                          is_options       = ls_options
*                                IMPORTING ev_pdf           = data(ev_pdf)
*                                          ev_pages         = data(ev_pages)
*                                          ev_trace_string  = data(ev_trace_string)
*                                          ).
*
*  CATCH cx_fp_ads_util INTO data(lx_fp_ads_util).

          ENDTRY.
*      out->write( 'Output was generated' ).

          cl_print_queue_utils=>create_queue_item_by_data(
              "Name of the print queue where result should be stored
              iv_qname = 'DEFAULT'
              iv_print_data = lv_pdf
              iv_name_of_main_doc = 'Gate Entry'
          ).

          APPEND VALUE #( %tky  = lw_result-%tky
                         mimetype = 'APPLICATION/PDF’'
                         filename = 'GateEntry.pdf'
                         pdfattach = lv_pdf ) TO lt_gate_entry.

*      out->write( 'Output was sent to print queue' ).
        CATCH cx_fp_fdp_error zcx_fp_tmpl_store_error cx_fp_ads_util.
*      out->write( 'Exception occurred.' ).
      ENDTRY.
*    out->write( 'Finished processing.' ).


    ENDLOOP.
    IF  lt_gate_entry IS NOT INITIAL.



      MODIFY ENTITIES OF zi_gate_entry  IN LOCAL MODE
      ENTITY gateentry UPDATE FIELDS ( pdfattach filename mimetype  )
      WITH lt_gate_entry.

      READ ENTITIES OF  zi_gate_entry  IN LOCAL MODE  ENTITY gateentry
      ALL FIELDS WITH CORRESPONDING #( lt_result ) RESULT DATA(lt_final).

      result =  VALUE #( FOR  lw_final IN  lt_final ( %tky = lw_final-%tky
       %param = lw_final  )  ).

      DATA : lt_gate TYPE TABLE OF zi_gate_entry.
      lt_gate = CORRESPONDING #( lt_final ).

      zbp_i_gate_entry=>mapped_entry = lt_gate.

    ENDIF.



  ENDMETHOD.

  METHOD validate_vehicle_out.
*   READ ENTITIES OF zi_gate_entry  IN LOCAL MODE
*    ENTITY gateentry
*   ALL FIELDS  WITH CORRESPONDING #( keys )
*   RESULT DATA(lt_result).
*   LOOP AT lt_result INTO DATA(lw_result).
*   TRANSLATE lw_result-VehicleNo to UPPER CASE.
*   SELECT SINGLE FROM zdt_gate_entry
*   FIELDS vehicle_no
*   WHERE vehicle_no = @lw_result-VehicleNo
*   AND vehicle_out is INITIAL
*   INTO @data(lv_vehicel_no).
*   if lv_vehicel_no is NOT INITIAL.
*
*       APPEND VALUE #( %tky =  lw_result-%tky ) TO failed-gateentry.
*        APPEND VALUE #( %tky = keys[ 1 ]-%tky
*                         %msg = new_message_with_text(
*                         severity = if_abap_behv_message=>severity-error
*                          text = 'Please do vehicel out before making new entry'
*                          )
*
*        ) TO  reported-gateentry.
*
*   ENDIF.
*
*
*   ENDLOOP.
  ENDMETHOD.

ENDCLASS.
