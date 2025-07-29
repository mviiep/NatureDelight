@AbapCatalog.sqlViewName: 'ZCNMATSTOCK'
@AccessControl.authorizationCheck: #PRIVILEGED_ONLY
//@EndUserText.label: 'Stock at Key Date in Alternative UoM'
@ObjectModel:{
               usageType:{
                            sizeCategory: #XXL,
                            serviceQuality: #C,
                            dataClass:#TRANSACTIONAL
                         },
                modelingPattern: #ANALYTICAL_QUERY,
                supportedCapabilities: [#ANALYTICAL_QUERY]
             }

@Analytics: { 
              query: true   
             // internalName: #LOCAL,
           //   technicalName: 'CMATSTKDATEAUOM'
            }    

@Metadata:{   
            allowExtensions: true,
            ignorePropagatedAnnotations: true -- ignore annotations from I-View w/o inserting here annotations from I-View, bacause AE cosumes the I-View basically.   
          }
@EndUserText.label: 'Consumption View for Gain or Loss Report'
define view ZCN_MatStockView 
with parameters
    
    
    @EndUserText.label: 'Startdate'  
    @AnalyticsDetails.query.variableSequence: 1
    //@Consumption.derivation: { lookupEntity: 'ZCDSIV_CALDATE', resultElement: 'FirstDayOfMonthDate',binding: [{ targetParameter: 'P_keyDate' ,type: #PARAMETER,value:'P_EndDate'}]}
    
//    @Consumption.derivation: {
//      lookupEntity: 'ZCDSIV_CALDATE',
//      resultElement: 'PreviousDate',
//      binding: [
//        { targetParameter : 'P_Keydate' ,
//          type : #PARAMETER, value : 'P_EndDate' }
//      ]
//    }
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate :vdm_v_key_date,
    
    
    
    
    @EndUserText.label: 'EndDate'
    @Environment.systemField: #SYSTEM_DATE
    @AnalyticsDetails.query.variableSequence: 2
    P_EndDate : vdm_v_key_date
    
    


as select from ZCDSIV_OpenCloseStock1( P_StartDate : $parameters.P_StartDate,P_EndDate : $parameters.P_EndDate)

{

    //@AnalyticsDetails.query.axis: #ROWS
  @Consumption: {
     filter: { selectionType: #RANGE, 
               mandatory: false,
               multipleSelections: true }
  }
  Product,
  //@AnalyticsDetails.query.axis: #ROWS
  @Consumption: {
     filter: { selectionType: #RANGE,
               mandatory: false,
               multipleSelections: true }
  }
  Plant,
  StorageLocation,
  @EndUserText.label: 'DerivedBatch'
  Batch1,
  Batch,
  Supplier,
  SDDocument,
  SDDocumentItem,
  WBSElementInternalID,
  Customer,
  SpecialStockIdfgStockOwner,
  InventoryStockType,
  InventorySpecialStockType,
// Quantity in BUoM
  @EndUserText.label: 'MaterialBaseUnit'
  MaterialBaseUnit,
  
  CompanyCode,
  FiscalYearVariant,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  MatlWrhsStkQtyInMatlBaseUnit,
  
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  
  
  ClosingStock,
  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
  @AnalyticsDetails.query.axis: #COLUMNS
  @DefaultAggregation: #SUM
  
  OpeningStock,
  
  @EndUserText.label: 'ReceiptatKalas'
  @DefaultAggregation: #SUM
  ReceiptatKalas,
  
  @EndUserText.label: 'Purchaseondock'
  @DefaultAggregation: #SUM
  Purchaseondock,
  
  GoodsMovementType
  
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
//  MatlCnsmpnQtyInMatlBaseUnit,
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
//  MatlStkIncrQtyInMatlBaseUnit,
//  @Semantics.quantity.unitOfMeasure: 'MaterialBaseUnit' 
//  MatlStkDecrQtyInMatlBaseUnit
}
