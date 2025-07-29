@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_CRATE_BAL_REP'
    }
}
 
@UI.headerInfo: { typeName: 'Crate Balance Report' ,
                  typeNamePlural: 'Crate Balance Report' }

@EndUserText.label: 'Custom Entity For Crate Balance Report'
define custom entity ZCE_CRATE_BAL_REP
// with parameters P_WERKS : werks_d,
//                 P_MATNR : matnr,
//                 P_DATE : datum 
{
 @UI.selectionField    : [{position: 10}]
 @UI.lineItem :  [{label: 'Plant', position: 10 ,importance: #HIGH }]
 @UI.identification: [{label: 'Plant', position: 10 }] 
 @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant',
                                               element: 'Plant' } }]
  key Plant : werks_d;
 @UI.selectionField    : [{position: 20}]
 @UI.lineItem :  [{label: 'Material', position: 20 ,importance: #HIGH }]
 @UI.identification: [{label: 'Material', position: 20 }]   
 @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH',
                                               element: 'Product' } }] 
  key Product : matnr;
 @UI.selectionField    : [{position: 30}]
 @UI.lineItem :  [{label: 'Customer', position: 30 ,importance: #HIGH }]
 @UI.identification: [{label: 'Customer', position: 30 }]   
 @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer_VH',
                                               element: 'Customer' } }]
  key Customer : abap.char(10);
 @UI.selectionField    : [{position: 40}]
 @UI.lineItem :  [{label: 'Date', position: 40 ,importance: #HIGH }]
 @UI.identification: [{label: 'Date', position: 40 }]    
 //@UI.hidden: true 
      p_date     : datum;  
 //@UI.selectionField    : [{position: 25}]
 @UI.lineItem :  [{label: 'Material Desc.', position: 25 ,importance: #HIGH }]
 @UI.identification: [{label: 'Material desc', position: 25 }]       
      MAKTX    : abap.char(40);
// @UI.selectionField    : [{position: 45}]
 @UI.lineItem :  [{label: 'Customer Name', position: 35 ,importance: #HIGH }]
 @UI.identification: [{label: 'Customer Name', position: 35 }]       
      Name1    : abap.char(40);
      
 @UI.lineItem :  [{label: 'Cust Group', position: 45 ,importance: #HIGH }]
 @UI.identification: [{label: 'Cust Group', position: 45 }]             
      CustomerGroup : abap.char(20);
      
 @UI.lineItem :  [{label: 'UoM', position: 50 ,importance: #HIGH }]
 @UI.identification: [{label: 'UoM', position: 50 }]       
      MaterialBaseUnit : meins;    
 @UI.lineItem :  [{label: 'Opening Qty', position: 60 ,importance: #HIGH }]
 @UI.identification: [{label: 'Opening Qty', position: 60 }]       
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'          
      OpenQty : abap.quan( 31, 3 );
 @UI.lineItem :  [{label: 'Consumption Qty', position: 70 ,importance: #HIGH }]
 @UI.identification: [{label: 'Consumption Qty', position: 70 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      ConsQty  : abap.quan( 31, 3 );
 @UI.lineItem :  [{label: 'Dispatched Qty', position: 80 ,importance: #HIGH }]
 @UI.identification: [{label: 'Dispatched Qty', position: 80 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      InsrQty  : abap.quan( 31, 3 );
 @UI.lineItem :  [{label: 'Receipt Qty', position: 90 ,importance: #HIGH }]
 @UI.identification: [{label: 'Receipt Qty', position: 90 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      DesrQty  : abap.quan( 31, 3 );   
 @UI.lineItem :  [{label: 'Closing Qty', position: 100 ,importance: #HIGH }]
 @UI.identification: [{label: 'Closing Qty', position: 100 }]              
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      CloseQty  : abap.quan( 31, 3 );          
 @UI.lineItem :  [{label: 'Transit Qty', position: 110 ,importance: #HIGH }]
 @UI.identification: [{label: 'Transit Qty', position: 110 }]              
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'                    
  TransitQty   : abap.quan( 31, 3 );
   @UI.lineItem :  [{label: 'Route', position: 120 ,importance: #HIGH }]
 @UI.identification: [{label: 'Route', position: 120 }]              

  route  :abap.char(6);
   @UI.lineItem :  [{label: 'Route Name', position: 120 ,importance: #HIGH }]
 @UI.identification: [{label: 'Route Name', position: 120 }]     
  route_name : abap.char(40);
          
  
}
