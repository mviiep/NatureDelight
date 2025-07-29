@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_CRATE_BAL_FORM'
    }
}
 
@UI.headerInfo: { typeName: 'Crate Balance Form' ,
                  typeNamePlural: 'Crate Balance Form' }

@EndUserText.label: 'Crate Balance Form'
define root custom entity ZCE_CRATE_BAL_FORM_HEADER
{

 @UI.facet   : [{ id : 'CUSTOMER',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Crate Balance',
                position: 10 }]

// @UI.selectionField    : [{position: 10}]
// @UI.lineItem :  [{label: 'Customer', position: 10 ,importance: #HIGH }]
// @UI.identification: [{label: 'Customer', position: 10 }]   
//// @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer_VH',
////                                               element: 'Customer' } }]
  key Customer : abap.char(10);

// @UI.selectionField    : [{position: 20}]
// @UI.lineItem :  [{label: 'Date', position: 20 ,importance: #HIGH }]
// @UI.identification: [{label: 'Date', position: 20 }]    
//     p_date     : datum;    

// @UI.selectionField    : [{position: 30}]
// @UI.lineItem :  [{label: 'From Date', position: 30 ,importance: #HIGH }]
// @UI.identification: [{label: 'From Date', position: 30 }]    
 key fr_date     : datum;

// @UI.selectionField    : [{position: 40}]
// @UI.lineItem :  [{label: 'To Date', position: 40 ,importance: #HIGH }]
// @UI.identification: [{label: 'To Date', position: 40 }]    
 key to_date     : datum;  

// @UI.lineItem :  [{label: 'Customer Name', position: 50 ,importance: #HIGH }]
// @UI.identification: [{label: 'Customer Name', position: 50 }]       
      Name1    : abap.char(40);           
     
// @UI.lineItem :  [{label: 'UoM', position: 60 ,importance: #HIGH }]
// @UI.identification: [{label: 'UoM', position: 60 }]       
      MaterialBaseUnit : meins;    
// @UI.lineItem :  [{label: 'Opening Qty', position: 70 ,importance: #HIGH }]
// @UI.identification: [{label: 'Opening Qty', position: 70 }]       
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'          
      OpenQty : abap.quan( 31, 14 );
// @UI.lineItem :  [{label: 'Closing Qty', position: 80 ,importance: #HIGH }]
// @UI.identification: [{label: 'Closing Qty', position: 80 }]              
  @Semantics.quantity.unitOfMeasure : 'MaterialBaseUnit'              
      CloseQty  : abap.quan( 31, 14 );   

  @ObjectModel.filter.enabled: false       
 _Item : association[0..*] to ZCE_CRATE_BAL_FORM_ITEM 
 on _Item.Customer  =  $projection.Customer
 and  _Item.fr_date  = $projection.fr_date
 and  _Item.to_date   = $projection.to_date;
                        
}
