@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry'
define root view entity ZI_GATE_ENTRY
  as select from zdt_gate_entry

{
  key gate_entry_no as GateEntryNo,
      entry_type    as EntryType,
      vehicle_no    as VehicleNo,
      driver_name   as DriverName,
      driver_mobile as DriverMobile,
      comodity      as Comodity,
      material      as Material,
      inbound_type  as InboundType,
      sto_no        as StoNo,
      batch         as Batch,
      purpose       as Purpose,
      in_date       as InDate,
      in_time       as InTime,
      out_date      as OutDate,
      out_time      as OutTime,
      vehicle_out   as VehicleOut,
      pdf_attach    as Pdfattach,
      mimetype      as Mimetype,
      filename      as Filename

}
