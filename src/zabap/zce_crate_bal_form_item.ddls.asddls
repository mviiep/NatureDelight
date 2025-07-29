@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_CRATE_BAL_FORM'
    }
}
 
@UI.headerInfo: { typeName: 'Crate Balance Form Item' ,
                  typeNamePlural: 'Crate Balance Form Item' }

@EndUserText.label: 'Crate Balance Form Item'
define custom entity ZCE_CRATE_BAL_FORM_ITEM
{
// @UI.selectionField    : [{position: 10}]
// @UI.lineItem :  [{label: 'Customer', position: 10 ,importance: #HIGH }]
// @UI.identification: [{label: 'Customer', position: 10 }]   
// @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer_VH',
//                                               element: 'Customer' } }]
  key Customer : abap.char(10);

// @UI.selectionField    : [{position: 20}]
// @UI.lineItem :  [{label: 'From Date', position: 20 ,importance: #HIGH }]
// @UI.identification: [{label: 'From Date', position: 20 }]    
 key fr_date     : datum;

// @UI.selectionField    : [{position: 30}]
// @UI.lineItem :  [{label: 'To Date', position: 30 ,importance: #HIGH }]
// @UI.identification: [{label: 'To Date', position: 30 }]    
 key to_date     : datum;  


//// @UI.selectionField    : [{position: 40}]
// @UI.lineItem :  [{label: 'Date', position: 40 ,importance: #HIGH }]
// @UI.identification: [{label: 'Date', position: 40 }]    
   MatlDocLatestPostgDate : datum;    
 
// @UI.lineItem :  [{label: 'UoM', position: 50 ,importance: #HIGH }]
// @UI.identification: [{label: 'UoM', position: 50 }]       
      MaterialBaseUnit : meins;    
      
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'          
      OpenQty : abap.quan( 31, 14 );      
      
// @UI.lineItem :  [{label: 'Consumption Qty', position: 70 ,importance: #HIGH }]
// @UI.identification: [{label: 'Consumption Qty', position: 70 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      ConsQty  : abap.quan( 31, 14 );
// @UI.lineItem :  [{label: 'Dispatched Qty', position: 80 ,importance: #HIGH }]
// @UI.identification: [{label: 'Dispatched Qty', position: 80 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      InsrQty  : abap.quan( 31, 14 );
// @UI.lineItem :  [{label: 'Receipt Qty', position: 90 ,importance: #HIGH }]
// @UI.identification: [{label: 'Receipt Qty', position: 90 }]             
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      DesrQty  : abap.quan( 31, 14 );      

  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      CloseQty  : abap.quan( 31, 14 );   
      
      
//      _Header : association to parent ZCE_CRATE_BAL_FORM_HEADER
//        on  $projection.Customer = _Header.Customer 
//        and $projection.fr_date = _Header.fr_date
//        and $projection.to_date = _Header.to_date;           
      
}
