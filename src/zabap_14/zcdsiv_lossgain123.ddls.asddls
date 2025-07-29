@AbapCatalog.sqlViewName: 'ZCMLOSSGAIN'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
@Analytics.settings.maxProcessingEffort: #HIGH

@Analytics.dataCategory: #CUBE

@EndUserText.label: 'Loss Gain test'
define view ZCDSIV_LOSSGAIN123  
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate : sydate 
  as select from I_MaterialDocumentItem_2
{

  key MaterialDocumentYear,
  key MaterialDocument,
  key MaterialDocumentItem,
      Material,
      Plant,
      StorageLocation,
      StorageType,
      StorageBin,
      Batch,
      ShelfLifeExpirationDate,
      ManufactureDate,
      Supplier,
//      case
//      when DebitCreditCode = 'S'
//      then QuantityInBaseUnit
//      else
//      QuantityInBaseUnit * -1
//      end as OpeningStock,
      case
      when ((GoodsMovementType = '101' or GoodsMovementType = '352') or ( GoodsMovementType = '302' or GoodsMovementType = '311' )) or ((GoodsMovementType = '102' or GoodsMovementType = '351') or ( GoodsMovementType = '301' or GoodsMovementType = '312' ))
      then
      case
      when DebitCreditCode = 'S'
      then QuantityInBaseUnit
      when DebitCreditCode = 'H'
      then QuantityInBaseUnit * -1 
      else 0 end      
      else 0
      end as OpeningStock, 
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
      OriginalMaterialDocumentItem,
      /* Associations */
      _AccountAssignmentCategory,
      _BPStockOwner,
      _BusinessArea,
      _BusinessPartner,
      _CompanyCode,
      _ControllingArea,
      _CostCenter,
      _Currency,
      _Customer,
      _CustomerCompanyByPlant,
      _DebitCreditCode,
      _DeliveryDocument,
      _DeliveryDocumentItem,
      _EntryUnit,
      _GLAccount,
      _GoodsMovementType,
      _GoodsMvtTypeBySpclStkIndT,
      _InventorySpecialStockType,
      _InventoryStockType,
      _InventoryValuationType,
      _IssgOrRcvgMaterial,
      _IssgOrRcvgSpclStockInd,
      _IssuingOrReceivingPlant,
      _IssuingOrReceivingStorageLoc,
      _LogisticsOrder,
      _Material,
      _MaterialBaseUnit,
      _MaterialDocumentHeader,
      _MaterialDocumentYear,
      _PersonWorkAgreement,
      _Plant,
      _ProjectNetwork,
      _PurchaseOrder,
      _PurchaseOrderItem,
      _ReversedMatDoc,
      _ReversedMatDocItem,
      _SalesOrder,
      _SalesOrderItem,
      _SalesOrderScheduleLine,
      _StockType,
      _StockType_2,
      _StorageLocation,
      _Supplier,
      _SupplierCompanyByPlant,
      _WBSElement,
      _WorkItem
}
where
      PostingDate        <= $parameters.P_EndDate
  and InventoryStockType = '01'
