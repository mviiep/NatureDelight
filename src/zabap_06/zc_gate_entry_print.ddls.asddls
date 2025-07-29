@EndUserText.label: 'Gate Entry'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define
root
 view entity ZC_GATE_ENTRY_PRINT as projection on ZI_GATE_ENTRY

{
    key GateEntryNo,
    EntryType,
    VehicleNo,
    DriverName,
    DriverMobile,
    Comodity,
    Material,
    InboundType,
    StoNo,
    Batch,
    Purpose,
    InDate,
    InTime,
    OutDate,
    OutTime,
    VehicleOut
}
