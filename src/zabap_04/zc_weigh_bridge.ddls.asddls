@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consumption View for Weigh Bridge'
@Metadata.allowExtensions: true
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_WEIGH_BRIDGE
  provider contract transactional_query

  as projection on ZI_WEIGH_BRIDGE
{
      @EndUserText.label: 'Gatepass No'
  key gatepass_no,  
      @EndUserText.label: 'STO Order'
  key PurchaseOrder,
      @EndUserText.label: 'Item'
  key PurchaseOrderItem,
      @EndUserText.label: 'Storage Location'
      StorageLocation,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure : 'QuantityUOM'
      Quantity,
      @EndUserText.label: 'Quantity Unit'
      QuantityUOM,
      @EndUserText.label: 'Chilling Center'
      ChilCenter,
      @EndUserText.label: 'Compartment'
      Compartment,
      @EndUserText.label: 'Total Weigh Bridge Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      TotalWeight,
      @EndUserText.label: 'Weigh Bridge Wt.'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      ItemWeight,
      @EndUserText.label: 'Difference Weight'
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      DiffereceWt,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @EndUserText.label: 'Created By'
      CreatedBy,
      @EndUserText.label: 'Created On'
      CreatedOn
}
