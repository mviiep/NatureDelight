@EndUserText.label: 'Yeild Report Header'
@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_YEILD_REPORT'
    }
}
@UI.headerInfo: { typeName: 'Yield Report' ,
                  typeNamePlural: 'Yield Report' }



define root custom entity ZCE_YEILD_REPORT_HEADER

{
      @UI.facet           : [{  id : 'Header',
      purpose             : #STANDARD,
      type                : #IDENTIFICATION_REFERENCE,
      label               : 'Yield Report Summary',
      position            : 10
       },
       {
        id                : 'Item',
      purpose             : #STANDARD,
      type                : #LINEITEM_REFERENCE,
      label               : 'Yield Reports Detailed',
      position            : 20,
      targetElement       : '_Item'
       }
       ]
      @UI.selectionField  : [{position: 10 }]
      @UI.lineItem        :  [{label: 'Material', position: 35 ,importance: #HIGH }]
      @UI.identification  : [{ position: 35 }]
      @EndUserText.label: 'Material'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_ProductStdVH',
                                                    element: 'Product' } }]       
  key material            : matnr;
      @UI.selectionField  : [{position: 20 }]
      @UI.lineItem        :  [{label: 'Plant', position: 20 ,importance: #HIGH }]
      @UI.identification  : [{ position: 20 }]
       @EndUserText.label: 'Plant'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Plant',
                                               element: 'Plant' } }]       
  key plant               : werks_d;
      @UI.selectionField  : [{position: 30 }]
      @UI.lineItem        :  [{label: 'Posting Date', position: 30 ,importance: #HIGH }]
      @UI.identification  : [{ position: 30 }]
       @EndUserText.label: 'Posting Date'
  key posting_date        : abap.dats;

      @UI.lineItem        :  [{label: 'Description', position: 40 ,importance: #HIGH }]
      @UI.identification  : [{ position: 40 }]
       @EndUserText.label: 'Description'
      out_mat_descr       : abap.char(40);
      @UI.selectionField  : [{position: 37 }]
      @UI.identification  : [{ position: 37 }]
      @UI.lineItem  : [{ position: 37 }]
      @EndUserText.label: 'MRP Controller'
      @Consumption.valueHelpDefinition: [{ entity: { name: 'I_MRPControllerVH',
                                                     element: 'MRPController' } }]       
      MRP_CONTROLLER      : abap.char(3);
      @Semantics.quantity.unitOfMeasure: 'unit'
      @UI.lineItem        :  [{label: 'Out Qty', position: 50 ,importance: #HIGH }]
      @UI.identification  : [{ position: 50 }]
       @EndUserText.label: 'Out Qty'
      out_qty             : menge_d;
      @UI.lineItem        :  [{label: 'Unit', position: 60 ,importance: #HIGH }]
      @UI.identification  : [{ position: 60 }]
       @EndUserText.label: 'Unit'
      unit                : meins;
      @UI.lineItem        :  [{label: 'Fat %', position: 70 ,importance: #HIGH }]
      @UI.identification  : [{ position: 70 }]
       @EndUserText.label: 'Fat %'
      out_fat_percent     : abap.dec( 10,2 );
      @UI.lineItem        :  [{label: 'Out KG Fat', position: 80 ,importance: #HIGH }]
      @UI.identification  : [{ position: 80 }]
      @Semantics.quantity.unitOfMeasure: 'out_fat_unit'
       @EndUserText.label: 'Out KG Fat'
      out_fat_qty         : menge_d;
      @UI.lineItem        :  [{label: 'Out Fat Unit', position: 85 ,importance: #HIGH }]
      @UI.identification  : [{ position: 85 }]
       @EndUserText.label: 'Out Fat Unit'
      out_fat_unit        : meins;
      @UI.lineItem        :  [{label: 'SNF %', position: 90 ,importance: #HIGH }]
      @UI.identification  : [{ position: 90 }]
       @EndUserText.label: 'SNF %'
      out_snf_percent     : abap.dec( 10,2 );
      @Semantics.quantity.unitOfMeasure: 'out_snf_unit'
      @UI.lineItem        :  [{label: 'Out KG SNF', position: 100 ,importance: #HIGH }]
      @UI.identification  : [{ position: 100 }]
       @EndUserText.label: 'Out KG SNF'
      out_snf_qty         : menge_d;
      @UI.lineItem        :  [{label: 'Out SNF Unit', position: 105 ,importance: #HIGH }]
      @UI.identification  : [{ position: 105 }]
       @EndUserText.label: 'OutSNF Unit'
       out_snf_unit         : meins;
      @UI.lineItem        :  [{label: 'Input Material 2', position: 140 ,importance: #HIGH }]
      @UI.identification  : [{ position: 140 }]
       @EndUserText.label: 'Input Material 2'
      in_material_1       : matnr;
      @UI.lineItem        :  [{label: 'Input Material 2 Descr', position: 150 ,importance: #HIGH }]
      @UI.identification  : [{ position: 150 }]
       @EndUserText.label: 'Input Material 2 Descr'
      in_material_descr_1 : abap.char(40);
      @Semantics.quantity.unitOfMeasure: 'in_fat_unit'
      @UI.lineItem        :  [{label: 'Input KG Fat Qty', position: 130 ,importance: #HIGH }]
      @UI.identification  : [{ position: 130 }]
       @EndUserText.label: 'Input KG Fat Qty'
      in_fat_qty          : menge_d;
      @UI.lineItem        :  [{label: 'In Fat Unit', position: 131 ,importance: #HIGH }]
      @UI.identification  : [{ position: 131 }]
       @EndUserText.label: 'In Fat Unit'
      in_fat_unit       : meins;
      @UI.lineItem        :  [{label: 'Input Material 1', position: 110 ,importance: #HIGH }]
      @UI.identification  : [{ position: 110 }]
       @EndUserText.label: 'Input Material 1'
       
      in_material_2       : matnr;
      @UI.lineItem        :  [{label: 'Input Material 1 Descr', position: 120 ,importance: #HIGH }]
      @UI.identification  : [{ position: 120 }]
       @EndUserText.label: 'Input Material 1 Descr'
      in_material_descr_2 : abap.char(40);
      @Semantics.quantity.unitOfMeasure: 'in_snf_unit'
      @UI.lineItem        :  [{label: 'Input KG SNF Qty', position: 160 ,importance: #HIGH }]
      @UI.identification  : [{ position: 160 }]
       @EndUserText.label: 'Input KG SNF Qty'
      in_snf_qty          : menge_d;
      @UI.lineItem        :  [{label: 'IN SNF Unit', position: 161 ,importance: #HIGH }]
      @UI.identification  : [{ position: 161 }]
      @EndUserText.label: 'IN SNF Unit'
      in_snf_unit        : meins;
      @UI.lineItem        :  [{label: 'Yield Fat %', position: 170 ,importance: #HIGH }]
      @UI.identification  : [{ position: 170 }]
       @EndUserText.label: 'Yeild Fat %'
       
      fat_yeild_percent   : abap.dec( 10,3 );
      @UI.lineItem        :  [{label: 'Yield SNF %', position: 180 ,importance: #HIGH }]
      @UI.identification  : [{ position: 180 }]
       @EndUserText.label: 'Yeild SNF %'
      snf_yeild_percent   : abap.dec( 10,3 );
      @ObjectModel.filter.enabled: false
      _Item               : composition [0..*] of ZCE_YEILD_REPORT_ITEM;




}
