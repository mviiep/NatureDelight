@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_MILKRATECARD_REPORT'
    }
}

@UI.headerInfo: { typeName: 'Milk Rate Card Upload Report' ,
                  typeNamePlural: 'Milk Rate Card Upload Report' }

@EndUserText.label: 'Custom Entity for Milk Rate Card'
define custom entity ZCE_MILKRATECARD
// with parameters Plant : werks_d,
//                 Sloc  : abap.char(4),
//                 effdate : datum
{

 @UI.selectionField    : [{position: 10}]
 @UI.lineItem :  [{label: 'Effective Date', position: 10 ,importance: #HIGH }]
 @UI.identification: [{label: 'Effective Date', position: 10 }] 
  key effdate : datum;

 @UI.selectionField    : [{position: 20 }]
 @UI.lineItem :  [{label: 'Plant', position: 20 ,importance: #HIGH }]
 @UI.identification: [{label: 'Plant', position: 20 }]  
 @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_Plant' ,element: 'Plant' } }]
  key Plant : werks_d;
  
  
 @UI.selectionField    : [{position: 30 }]
 @UI.lineItem :  [{label: 'St. Location', position: 30 ,importance: #HIGH }]
 @UI.identification: [{label: 'St. Location', position: 30 }]  
 @Consumption.valueHelpDefinition: [{ entity: {  name: 'I_StorageLocation' ,element: 'StorageLocation' } }]  
  key Sloc  : abap.char(4);

 @UI.lineItem :  [{label: 'St. Location Name', position: 40 ,importance: #HIGH }]
 @UI.identification: [{label: 'St. Location Name', position: 40 }]  
  lgobe      : abap.char(16);  
}
