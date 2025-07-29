@EndUserText.label: 'Custom entiry for Weighbridge STO'

@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MM_WEIGHBRIDGE'
    }
}

define root custom entity ZCE_ZMM_WEIGHBRIDGE
  // with parameters p_ebeln : ebeln
{                      
      @EndUserText.label: 'STPO Number'
      @UI.facet: [ { label : 'Purchasing Document' , 
                        id : '10', 
                      type : #IDENTIFICATION_REFERENCE } ]
      @UI   :{  lineItem:[{position:10} 
           //,{ type: #FOR_ACTION, dataAction: 'saveData', label: 'Save Data', invocationGrouping: #CHANGE_SET }
           ], 
                identification: [{position:10} 
                //,{ type: #FOR_ACTION, dataAction: 'saveData', label: 'Save Data' }
                ], 
                selectionField:[{position: 10}]    }
  key ebeln : ebeln;
  key ebelp : ebelp;
      lgort : zde_lgort;
      
//      @Semantics.quantity.unitOfMeasure: 'PurchaseOrderQuantityUnit' 
      OrderQuantity : zde_bstmg;
      
      @Semantics.unitOfMeasure: true
      PurchaseOrderQuantityUnit : zde_bstme;
      
      @EndUserText.label: 'Chilling Center'
      YY1_ChillingCenter_PDI : abap.char( 4 );
      
      @EndUserText.label: 'Compartment'
      YY1_Compartment_PDI : abap.char( 1 ) ;
      
      @EndUserText.label: 'Date and Time'
      YY1_Compartment_PD : timestamp ;
}
