@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_OUTWARDFREIGHT_REPORT'
    }
}

@UI.headerInfo: { typeName: 'Outward Freight Report : '  ,
                  typeNamePlural: 'Outward Freight Report' }


@EndUserText.label: 'Outward Freight Report : Item' 
define custom entity ZCE_OUTWARD_FREIGHT_REP_ITEM

{
  @UI.facet: [{ id : 'Item',
            purpose: #STANDARD,
            type: #IDENTIFICATION_REFERENCE, 
            label: 'Outward Freight Report : Items',
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
  
 @UI.lineItem :  [{label: 'Transporter Name', position: 25 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Transporter Name', position: 25 }]  
  key name1 : abap.char(40);   
  
 @UI.lineItem :  [{label: 'Billing Document', position: 30 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Billing Document', position: 30 }] 
  key billingdocument       : abap.char(10);   
  
// @UI.lineItem :  [{label: 'Invoice No', position: 40 ,importance: #HIGH }] 
// @UI.identification: [{ label: 'Invoice No', position: 40 }]  
//  vbeln : abap.char(10);  

 @UI.lineItem :  [{label: 'Route', position: 50 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Route', position: 50 }] 
  route       : abap.char(100);

 @UI.lineItem :  [{label: 'Route Name', position: 60 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Route Name', position: 60 }] 
  route_nm       : abap.char(100);

 @UI.lineItem :  [{label: 'Customer', position: 80 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Customer', position: 80 }] 
  customer       : abap.char(10); 
  
 @UI.lineItem :  [{label: 'Customer Name', position: 90 ,importance: #HIGH }]
 @UI.identification: [{ label: 'Customer Name', position: 90 }] 
  cust_name       : abap.char(40);   

 @ObjectModel.sort.enabled: false
 @ObjectModel.filter.enabled: false
 _Header : association to parent ZCE_OUTWARD_FREIGHT_REP
  on _Header.erdat         = $projection.erdat
 and _Header.vehicle       = $projection.vehicle  
 and  _Header.transporter  = $projection.transporter
 and  _Header.name1        = $projection.name1;  
 

}
