@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Gate Entry Weigh Bridge'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity  ZC_GATE_ENTRY_WEIGHBRIDGE as select distinct from  ZI_GATE_ENTRY
association[0..*] to ZI_WB_VIEW as _WB on $projection.GateEntryNo = _WB.gatepass_no
//association[0..*] to I_PurchaseOrderItemAPI01 as _PO on $projection.StoNo = _PO.PurchaseOrder
//and _PO.PurchasingDocumentDeletionCode  = 'L'
//and _PO.PurgItemIsBlockedForDelivery = 'S'
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
    VehicleOut,
    _WB.FullTruckUnload

}
where VehicleOut is initial
