@EndUserText.label: 'Cutom entity truck sheet'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_CE_TRUCKSHEET'

define root custom entity ZCE_TRRUCKSHEET
  // with parameters parameter_name : parameter_type
{

      @EndUserText.label: 'Truck Sheet No'
      @UI             :{lineItem:[{position:10}],
                     identification: [{position:10}]}
  key itemTrucksheetNo   : abap.char(10);

      TrucksheetDate : timestamp;


//      @EndUserText.label: 'Vehicle no'
//      @UI.facet       : [ { label : 'Vehicle No' ,
//                         id : '20',
//                         type : #IDENTIFICATION_REFERENCE } ]
//
//      @UI             :{lineItem:[{position:20}],
//                     identification: [{position:20}],
//                     selectionField:[{position: 20}]}
//
//      @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_TRUCKSHEET_DATA_DISPLAY',
//                                                    element: 'VehicleNo' } }]
//      vehicle_no      : abap.char(10);
//
//      @EndUserText.label: 'Driver Name'
//      @UI.facet       : [ { label : 'Driver Name' ,
//                         id : '30',
//                         type : #IDENTIFICATION_REFERENCE } ]
//
//      @UI             :{lineItem:[{position:30}],
//                     identification: [{position:30}],
//                     selectionField:[{position: 30}]}
//
//      //      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument',
//      //                                                     element: 'DistributionChannel' } }]
//      driver_name     : abap.char(30);
//
//
//
//
//      @EndUserText.label: 'Driver Tel'
//      @UI.facet       : [ { label : 'Driver Tel' ,
//                         id : '40',
//                         type : #IDENTIFICATION_REFERENCE } ]
//
//      @UI             :{lineItem:[{position:40}],
//                     identification: [{position:40}]}
//      driver_telno    : abap.char(10);
//
//
//
//      @UI             : { lineItem  : [{ position: 50,
//                           label: 'Transport Doc no',
//                           type: #FOR_ACTION,
//                           dataAction: 'statusUpdate' } ],
//                           identification: [{ position: 50, label: 'Transport Doc no' } ]
//                   }
//      trans_doc_no    : abap.char(10);


}
