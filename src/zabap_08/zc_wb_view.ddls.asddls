@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Weigh Bridge'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_WB_VIEW
  // provider contract transactional_query
  as projection on ZI_WB_VIEW
{
      @EndUserText.label: 'Gatepass No'
  key gatepass_no,
      @EndUserText.label: 'STO Order'
  key PurchaseOrder,
      @EndUserText.label: 'Item'
  key PurchaseOrderItem,

      @EndUserText.label: 'Total Weigh Bridge Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      TotalWeight,
      @EndUserText.label: 'Weigh Bridge Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      ItemWeight,
      @EndUserText.label: 'Difference Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      DiffWeight,
      @EndUserText.label: 'Trucksheet Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      TrucksheetWeight,
      @EndUserText.label: 'Entry Type'
      EntryType,
      @EndUserText.label: 'Storage Location'
      StorageLocation,
      @Semantics.quantity.unitOfMeasure : 'QuantityUOM'
      Quantity,
      @EndUserText.label: 'Quantity Unit'
      QuantityUOM,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Chilling Center'
      ChilCenter,
      @EndUserText.label: 'Compartment'
      Compartment,
      //      @EndUserText.label: 'Total Weigh Bridge Wt.'
      //      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //      TotalWeight,
      //      @EndUserText.label: 'Weigh Bridge Wt.'
      //      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //      ItemWeight,
      @EndUserText.label: 'Tare Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      TareWeight,
      //      @EndUserText.label: 'Difference Wt.'
      //      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //      DiffWeight,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @EndUserText.label: 'Truksheet No.'
      TrucksheetNo,
      @EndUserText.label: 'Full Truck Unload'
      FullTruckUnload,
      @EndUserText.label: 'Material Document No.'
      MaterialDocument,
      @EndUserText.label: 'Material Document Year'
      MaterialDocumentYear,
      @EndUserText.label: 'Material Document Item'
      MaterialDocumentItem,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Material No.'
      Material,

      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created On'
      CreatedOn,
      @EndUserText.label: 'Changed By'
      ChangedBy,
      @EndUserText.label: 'Changed On'
      ChangedOn
}
