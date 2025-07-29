@AbapCatalog.sqlViewName: 'ZCNLOSSGAINR'
@ClientHandling.algorithm: #SESSION_VARIABLE
@AbapCatalog.compiler.compareFilter: true
@ObjectModel.usageType.dataClass: #MIXED
@ObjectModel.usageType.serviceQuality: #D
@ObjectModel.usageType.sizeCategory: #L
//@VDM.viewType: #CONSUMPTION
@Analytics.query: true
//@OData.publish: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
//@AccessControl.personalData.blocking: #NOT_REQUIRED
//@ObjectModel.supportedCapabilities: #ANALYTICAL_QUERY
@ObjectModel.modelingPattern:#ANALYTICAL_QUERY
@EndUserText.label: 'Loss Gain Report'
define view ZCDSCV_LossGainReport 
with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate : sydate
as select from ZCDSIV_OpeningClosingStock(P_EndDate : :P_EndDate)
{
    key MaterialDocumentYear,
    key MaterialDocument,
    key MaterialDocumentItem,
    Material,
    Plant,
    StorageLocation,
    StorageType,
    StorageBin,
    @DefaultAggregation: #SUM
    
      @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit'
      @AnalyticsDetails.query.formula: '(case when DebitCreditCode = "H"  then ( OpeningStock * -1 ) else OpeningStock end)'
    
    OpeningStock,
    Batch,
    ShelfLifeExpirationDate,
    ManufactureDate,
    Supplier,
    SalesOrder,
    SalesOrderItem,
    SalesOrderScheduleLine,
    WBSElementInternalID,
    Customer,
    InventorySpecialStockType,
    InventoryStockType,
    StockOwner,
    GoodsMovementType,
    DebitCreditCode,
    InventoryUsabilityCode,
    QuantityInBaseUnit,
    MaterialBaseUnit,
    QuantityInEntryUnit,
    EntryUnit,
    PostingDate,
    DocumentDate,
    TotalGoodsMvtAmtInCCCrcy,
    CompanyCodeCurrency,
    InventoryValuationType,
    ReservationIsFinallyIssued,
    PurchaseOrder,
    PurchaseOrderItem,
    ProjectNetwork,
    OrderID,
    OrderItem,
    MaintOrderRoutingNumber,
    MaintOrderOperationCounter,
    Reservation,
    ReservationItem,
    DeliveryDocument,
    DeliveryDocumentItem,
    ReversedMaterialDocumentYear,
    ReversedMaterialDocument,
    ReversedMaterialDocumentItem,
    RvslOfGoodsReceiptIsAllowed,
    GoodsRecipientName,
    GoodsMovementReasonCode,
    UnloadingPointName,
    CostCenter,
    GLAccount,
    ServicePerformer,
    PersonWorkAgreement,
    AccountAssignmentCategory,
    WorkItem,
    ServicesRenderedDate,
    IssgOrRcvgMaterial,
    IssuingOrReceivingPlant,
    IssuingOrReceivingStorageLoc,
    IssgOrRcvgBatch,
    IssgOrRcvgSpclStockInd,
    IssuingOrReceivingValType,
    CompanyCode,
    BusinessArea,
    ControllingArea,
    FiscalYearPeriod,
    FiscalYearVariant,
    GoodsMovementRefDocType,
    IsCompletelyDelivered,
    MaterialDocumentItemText,
    IsAutomaticallyCreated,
    SerialNumbersAreCreatedAutomly,
    GoodsReceiptType,
    ConsumptionPosting,
    MultiAcctAssgmtOriglMatlDocItm,
    MultipleAccountAssignmentCode,
    GoodsMovementIsCancelled,
    IssuingOrReceivingStockType,
    ManufacturingOrder,
    ManufacturingOrderItem,
    MaterialDocumentLine,
    MaterialDocumentParentLine,
    SpecialStockIdfgSalesOrder,
    SpecialStockIdfgSalesOrderItem,
    ProfitCenter,
    ProductStandardID,
    GdsMvtExtAmtInCoCodeCrcy,
    ReferenceDocumentFiscalYear,
    InvtryMgmtReferenceDocument,
    InvtryMgmtRefDocumentItem,
    EWMWarehouse,
    EWMStorageBin,
    MaterialDocumentPostingType,
    OriginalMaterialDocumentItem
}
