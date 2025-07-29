@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_OUTWARDFREIGHT_REPORT'
    }
}

@UI.headerInfo: { typeName: 'Outward Freight Report' ,
                  typeNamePlural: 'Outward Freight Report' }


@EndUserText.label: 'Outward Freight Report' 
define root custom entity ZCE_OUTWARD_FREIGHT_REP

{
//  @UI.facet: [{ id : 'erdat',
//            purpose: #STANDARD,
//            type: #IDENTIFICATION_REFERENCE, 
//            label: 'Outward Freight Report',
//            position: 10 }]

  @UI.facet: [{  id : 'Header',
  purpose: #STANDARD,
  type: #IDENTIFICATION_REFERENCE,
  label: 'Vehicle Data',
  position: 10
   },
   {
    id : 'Item',
  purpose: #STANDARD,
  type: #LINEITEM_REFERENCE,
  label: 'Billing Details',
  position: 20,
  targetElement: '_Item'
   }
   ]


 @UI.selectionField    : [{position: 10 }]
 @UI.lineItem :  [{label: 'Date', position: 10 ,importance: #HIGH }]
 @UI.identification: [{ position: 10 }]
  key erdat : datum;

 @UI.selectionField    : [{position: 20 }]
 @UI.lineItem :  [{label: 'Transporter', position: 20 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Transporter', position: 20 }]
 @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_Supplier' ,element: 'Supplier' } }]  
  key transporter : lifnr;
  
 @UI.selectionField    : [{position: 30 }]
 @UI.lineItem :  [{label: 'Vehicle No', position: 30 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Vehicle No', position: 30 }] 
 @Consumption.valueHelpDefinition: [{ entity: {  name: 'ZI_MM_VEHICLE' ,element: 'VehicleNo' } }]    
  key vehicle     : abap.char(10);   
  
 @UI.lineItem :  [{label: 'Transporter Name', position: 25 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Transporter Name', position: 25 }]  
  key name1 : abap.char(40);   
  
// @UI.lineItem :  [{label: 'Invoice No', position: 40 ,importance: #HIGH }] 
// @UI.identification: [{ label: 'Invoice No', position: 40 }]  
//  vbeln : abap.char(10);  

 @UI.lineItem :  [{label: 'Route', position: 50 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Route', position: 50 }] 
  route       : abap.char(100);

 @UI.lineItem :  [{label: 'Route Name', position: 60 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Route Name', position: 60 }] 
  route_nm       : abap.char(100);

@UI.hidden: true  
  currency    : waers;
  
 @UI.lineItem :  [{label: 'Rate', position: 80 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Rate', position: 80 }] 
  @Semantics.amount.currencyCode : 'currency'
  rate        : abap.curr(10,2);  
  
 @UI.hidden: true 
  uomkms      : meins;
  
 @UI.lineItem :  [{label: 'Distance', position: 90 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Distance', position: 90 }] 
  @Semantics.quantity.unitOfMeasure : 'uomkms'    
  distance    : menge_d;
  
 @UI.lineItem :  [{label: 'Amount', position: 100 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Amount', position: 100 }] 
  @Semantics.amount.currencyCode : 'currency'  
  amount      : abap.curr(10,2);  
  
  @ObjectModel.filter.enabled: false       
//  composition [0..*] of ZI_SALES_ORDER_ITEM as _SalesItem
 _Item : composition[0..*] of ZCE_OUTWARD_FREIGHT_REP_ITEM;
}
