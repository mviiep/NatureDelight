@EndUserText.label: 'Gate Entry'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_GATE_PASS_PRINT'
    }
}

@UI.headerInfo: { typeName: 'Gate Pass' ,
                  typeNamePlural: 'Gate Pass' }



define custom entity ZCE_GATE_ENTRY

{
      @UI.facet   : [{ id : 'GateEntryNo',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Gate Entry',
                position: 10 }]


      @UI.selectionField    : [{position: 10 }]
      @UI.lineItem:  [{label: 'Gate Entry', position: 10 ,importance: #HIGH }]
      @UI.identification: [{ position: 10 }]
  key GateEntryNo : abap.char(10);
     
      @UI.lineItem:  [{label: 'PDF', position: 20 ,importance: #HIGH }]
      @UI.identification: [{ position: 20 }]

      attachment  : zde_attachment1;

}
