@AbapCatalog: {
                sqlViewName: 'ZMATSTOCKBYKDATE',
                preserveKey: true,
                compiler.compareFilter: true
              }
@EndUserText.label: 'Material Stock at posting date'
@AccessControl.authorizationCheck:#PRIVILEGED_ONLY
@ClientHandling.algorithm: #SESSION_VARIABLE
@ObjectModel: {
                usageType: {
                             sizeCategory: #XXL,
                             serviceQuality: #D,
                             dataClass:#TRANSACTIONAL
                           },
                modelingPattern: #ANALYTICAL_QUERY,
                supportedCapabilities: [#ANALYTICAL_QUERY]
              }
//@VDM.viewType: #CONSUMPTION
@Analytics.query : true
@Metadata.allowExtensions: true
/*+[hideWarning] { "IDS" : [ "KEY_CHECK" ]  } */
define view ZMM_STOCKASONDATE
  with parameters
    @Consumption.hidden: true
    @Environment.systemField: #SYSTEM_LANGUAGE
    P_Language : spras,
    @Environment.systemField: #SYSTEM_DATE
    P_KeyDate  : vdm_v_key_date
  as select from I_MaterialStock_2
{
  // Stock Identifier
  @ObjectModel.text.element: ['MaterialName']
  Material,
  @ObjectModel.text.element: ['PlantName']
  @AnalyticsDetails.query.axis: #ROWS
  Plant,
  @ObjectModel.text.element: ['StorageLocationName']
  StorageLocation,
  Batch,
  @ObjectModel.text.element: ['SupplierName']
  Supplier,
  SDDocument,
  SDDocumentItem,
  WBSElementInternalID as WBSElementInternalID,   --I_MaterailStock_2 does a cast to a DE w/o conversion exit, for compatibility reason: cast back
  @ObjectModel.text.element: ['CustomerName']
  Customer,
  @ObjectModel.text.element: ['InventoryStockTypeName']
  InventoryStockType,
  @ObjectModel.text.element: ['InventorySpecialStockTypeName']
  InventorySpecialStockType,

  // Further Stock Groups
  CompanyCode,

  // Quantity and Unit
  @Semantics.unitOfMeasure: true
  MaterialBaseUnit,
  @AnalyticsDetails.query.axis: #COLUMNS
  MatlWrhsStkQtyInMatlBaseUnit,

  // Names and descriptions
  _Material._Text[1: Language=$parameters.P_Language].ProductName as MaterialName,
  _CompanyCode.CompanyCodeName,
  _Plant.PlantName,
  _StorageLocation.StorageLocationName,
  _Supplier.SupplierName,
  _Customer.CustomerName,
  _InventoryStockType._Text[1: Language=$parameters.P_Language].InventoryStockTypeName,
  _InventorySpecialStockType._Text[1: Language=$parameters.P_Language].InventorySpecialStockTypeName
}
where
  MatlDocLatestPostgDate <= $parameters.P_KeyDate   
