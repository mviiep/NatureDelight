@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'f4 Search help for gatepass'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_GP_NO_SH
  as select from zdt_gate_entry
{
      @EndUserText.label: 'Gate Entry No'
  key gate_entry_no as GateEntryNo,
      entry_type    as EntryType,
      @EndUserText.label: 'Vehicle No'
      vehicle_no    as VehicleNo,
      @EndUserText.label: 'Driver Name'
      driver_name   as DriverName,
      material      as Material,
      inbound_type  as InboundType,
      @EndUserText.label: 'STO No'
      sto_no        as StoNo,
      batch         as Batch
}
