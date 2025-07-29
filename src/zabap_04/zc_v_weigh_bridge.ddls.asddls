@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Projection View for ZI_V_WEIGH_BRIDGE Weigh Bridge'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZC_V_WEIGH_BRIDGE 
provider contract transactional_query
as projection on ZI_V_WEIGH_BRIDGE
{   
   
//   @Search.defaultSearchElement:true
//   @Consumption.valueHelpDefinition: [{ entity: { name: 'ZV_Weigh_Bridge',
//                                                  element: 'Purchase_Order' },
//                                                  distinctValues: true }]
   @EndUserText.label: 'Gatepass No'
   key ZI_V_WEIGH_BRIDGE.gatepass_no,
  
   @EndUserText.label: 'STPO Order'
   key ZI_V_WEIGH_BRIDGE.EBELN,
   
   @EndUserText.label: 'Item'
   key ZI_V_WEIGH_BRIDGE.EBELP,
   
   @EndUserText.label: 'STO Order'
   key ZI_V_WEIGH_BRIDGE.saveButton,
   
   @EndUserText.label: 'Storage Location'
    ZI_V_WEIGH_BRIDGE.LGORT,
   @EndUserText.label: 'Quantity'
   @Semantics.quantity.unitOfMeasure : 'QuantityUOM'
    ZI_V_WEIGH_BRIDGE.Quantity,
    @EndUserText.label: 'Quantity Unit'
    ZI_V_WEIGH_BRIDGE.QuantityUOM,
    @EndUserText.label: 'Chilling Center'
    ZI_V_WEIGH_BRIDGE.ChilCenter,
    @EndUserText.label: 'Compartment'
    ZI_V_WEIGH_BRIDGE.Compartment,
    @EndUserText.label: 'Total Weigh Bridge Wt.'
    @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
    ZI_V_WEIGH_BRIDGE.Total_wt,
    @EndUserText.label: 'Weigh Bridge Wt.'
    @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
    ZI_V_WEIGH_BRIDGE.Item_Wt,
    @EndUserText.label: 'Difference Weight'
      @Semantics.quantity.unitOfMeasure : 'Weight_Unit'
    ZI_V_WEIGH_BRIDGE.Diff_Wt,
    @EndUserText.label: 'Weight Unit' 
    ZI_V_WEIGH_BRIDGE.Weight_Unit,
    @EndUserText.label: 'Created By'
    ZI_V_WEIGH_BRIDGE.CreatedBy,
    @EndUserText.label: 'Created On'
    ZI_V_WEIGH_BRIDGE.CreatedOn
}
