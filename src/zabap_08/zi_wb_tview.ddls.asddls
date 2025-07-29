@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface Entity View for Weigh Bridge'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_WB_TVIEW
  as select from zmmt_weigh_bridg
{
  key gp_no                  as gatepass_no,
  key ebeln                  as PurchaseOrder,
  key ebelp                  as PurchaseOrderItem,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      total_wt               as TotalWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      item_wt                as ItemWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      diff_wt                as DiffWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      tsheet_wt              as TrucksheetWeight,
      entry_type             as EntryType,
      lgort                  as StorageLocation,
      @Semantics.quantity.unitOfMeasure: 'QuantityUOM'
      quantity               as Quantity,
      qtyuom                 as QuantityUOM,
      charg                  as Batch,
      yy1_chillingcenter_pdi as ChilCenter,
      yy1_compartment_pdi    as Compartment,
      //@Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //total_wt               as TotalWeight,
      //@Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //item_wt                as ItemWeight,
      @Semantics.quantity.unitOfMeasure : 'WeightUnit'
      tare_wt                as TareWeight,
      //@Semantics.quantity.unitOfMeasure : 'WeightUnit'
      //diff_wt                as DiffWeight,
      weight_unit            as WeightUnit,
      trucksheet_no          as TrucksheetNo,
      fulltruckunload        as FullTruckUnload,
      mblnr                  as MaterialDocument,
      mjahr                  as MaterialDocumentYear,
      zeile                  as MaterialDocumentItem,
      werks                  as Plant,
      matnr                  as Material,
      created_by             as CreatedBy,
      created_on             as CreatedOn,
      changed_by             as ChangedBy,
      changed_on             as ChangedOn
}
