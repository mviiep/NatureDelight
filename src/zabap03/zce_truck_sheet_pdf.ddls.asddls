@EndUserText.label: 'Truck Sheet PDF'

@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_TRUCK_SHEET_PDF'
    }
}

@UI.headerInfo: { typeName: 'Truck Sheet' ,
                  typeNamePlural: 'Truck Sheet' }
define custom entity ZCE_TRUCK_SHEET_PDF
{

  @UI.facet   : [{ id : 'trucksheet_no',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Truck Sheet',
                position: 10 }]


      @UI.selectionField    : [{position: 10 }]
      @UI.lineItem:  [{label: 'Truck Sheet', position: 10 ,importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
key trucksheet_no : abap.char(10) ;
  @UI.lineItem:  [{label: 'PDF', position: 20 ,importance: #HIGH }]
      @UI.identification: [{ position: 20 }]
attachment  : zde_attachment1;
  
}
