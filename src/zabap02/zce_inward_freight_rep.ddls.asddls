@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_INWARDFREIGHT_REPORT'
    }
}

@UI.headerInfo: { typeName: 'Inward Freight Report' ,
                  typeNamePlural: 'Inward Freight Report' }


@EndUserText.label: 'Inward Freight Report'
define custom entity ZCE_INWARD_FREIGHT_REP

{
  @UI.facet: [{ id : 'erdat',
            purpose: #STANDARD,
            type: #IDENTIFICATION_REFERENCE,
            label: 'Inward Freight Report',
            position: 10 }]


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
  
 @UI.lineItem :  [{label: 'STPO No', position: 40 ,importance: #HIGH }] 
 @UI.identification: [{ label: 'STPO No', position: 40 }]  
  ebeln : ebeln;  

 @UI.lineItem :  [{label: 'Route', position: 50 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Route', position: 50 }] 
  route       : abap.char(200);

 @UI.hidden: true  
  uom         : meins;
  
 @UI.lineItem :  [{label: 'Milk Collected Qty', position: 60 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Milk Collected Qty', position: 60 }] 
  @Semantics.quantity.unitOfMeasure : 'uom'  
  milkqty     : menge_d;
  
 @UI.lineItem :  [{label: 'Tanker Capacity', position: 70 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Tanker Capacity', position: 70 }] 
  @Semantics.quantity.unitOfMeasure : 'uom'    
  capacity    : menge_d;
  
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

 @UI.lineItem :  [{label: 'Amount Calculated', position: 110 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Amount Calculated', position: 110 }] 
  @Semantics.amount.currencyCode : 'currency'  
  amount_cal      : abap.curr(10,2);  
  
@UI.hidden: true  
  capuom    : meins;
    
 @UI.lineItem :  [{label: 'Capacity Utilization %', position: 120 ,importance: #HIGH }]  
 @UI.identification: [{ label: 'Capacity Utilization %', position: 120 }] 
  @Semantics.quantity.unitOfMeasure : 'capuom'   
  caputil     : menge_d;
  
}
