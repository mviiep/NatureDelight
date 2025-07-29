@EndUserText.label: 'Weigh Bridge Display'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_WB_DISPALY
  provider contract transactional_query
  as projection on ZI_WB_DISPLAY
{
      @EndUserText.label: 'Gatepass No'
  key GpNo,
      @EndUserText.label: 'STO Order'
  key Ebeln,
      @EndUserText.label: 'Item'
  key Ebelp,
      @EndUserText.label: 'Entry Type'
      EntryType,
      @EndUserText.label: 'Storage Location'
      Lgort,
      @EndUserText.label: 'STPO Quantity'
      Quantity,
      @EndUserText.label: 'Unit'
      Qtyuom,
      @EndUserText.label: 'Batch'
      Charg,
      @EndUserText.label: 'Material'
      Matnr,
      @EndUserText.label: 'Chilling Center'
      Yy1ChillingcenterPdi,
      @EndUserText.label: 'Compartment'
      Yy1CompartmentPdi,
      @EndUserText.label: 'Total Weigh Bridge Wt.'
      TotalWt,
      @EndUserText.label: 'Weigh Bridge Wt.'
      ItemWt,
      @EndUserText.label: 'Tare Wt.'
      TareWt,
      @EndUserText.label: 'Difference Wt.'
      DiffWt,
      @EndUserText.label: 'Trucksheet Wt.'
      TsheetWt,
      @EndUserText.label: 'Weight Unit'
      WeightUnit,
      @EndUserText.label: 'Truksheet No.'
      TrucksheetNo,
      @EndUserText.label: 'Material Document No.'
      Mblnr,
      @EndUserText.label: 'Material Document Item.'
      Zeile,
      @EndUserText.label: 'Material Document Year.'
      Mjahr,
      @EndUserText.label: 'Plant.'
      Werks,
      @EndUserText.label: 'Full Truck Unloaded.'
      Fulltruckunload,
      @EndUserText.label: 'Created By.'
      CreatedBy,
      @EndUserText.label: 'Created On'
      CreatedOn,
      @EndUserText.label: 'Changed By.'
      ChangedBy,
      @EndUserText.label: 'Changed on.'
      ChangedOn
}
