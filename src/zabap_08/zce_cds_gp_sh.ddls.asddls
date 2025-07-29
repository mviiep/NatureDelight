@EndUserText.label: 'Custom Entity View for Gatepass'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MM_WB_CLASS'
    }
}

define custom entity ZCE_CDS_GP_SH
  // with parameters parameter_name : parameter_type
{
      @EndUserText.label        : 'Gatepass Number'
      @UI           :{ lineItem: [{ position: 10, label: 'Gatepass No.' }],
                identification: [{ position: 10, label: 'Gatepass No.' }],
                selectionField: [{ position: 10 }] }
  key gp_no         : abap.char(10);
      @EndUserText.label        : 'Entry Type'
      entry_type    : zde_gate_entry_type;
      @EndUserText.label        : 'Vehicle Number'
      vehicle_no    : abap.char(10);
      @EndUserText.label        : 'Driver Name'
      driver_name   : abap.char(40);
      @EndUserText.label        : 'Driver Mobile Number'
      driver_mobile : abap.char(10);
      @EndUserText.label        : 'Inbound Type'
      inbound_type  : zde_inbound_type;
      @EndUserText.label        : 'STOP Number'
      sto_no        : abap.char(10);
      @EndUserText.label        : 'Batch'
      batch         : charg_d;

}
