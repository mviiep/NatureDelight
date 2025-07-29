@EndUserText.label: 'Yeild Report Item'

@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_YEILD_REPORT'
    }
}
@UI.headerInfo: { typeName: 'Yield Report : '  ,
                  typeNamePlural: 'Yield Report' }
define custom entity ZCE_YEILD_REPORT_ITEM

{
      @UI.facet     : [{ id : 'Item',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Yield Report : Detailed',
                position: 10 }]
      @UI.selectionField  : [{position: 40 }]
      @UI.lineItem  :  [{label: 'Material', position: 40  }]
      @UI.identification  : [{ position: 40 }]
      @EndUserText.label: 'Material'
  key material      : matnr;
      @UI.selectionField  : [{position: 10 }]
      @UI.lineItem  :  [{label: 'Plant', position: 10 }]
      @UI.identification  : [{ position: 10 }]
       @EndUserText.label: 'Plant'
  key plant         : werks_d;
      @UI.selectionField  : [{position: 20 }]
      @UI.lineItem  :  [{label: 'Posting Date', position: 20  }]
      @UI.identification  : [{ position: 20 }]
       @EndUserText.label: 'Posting Date'
  key posting_date  : abap.dats;
      @UI.lineItem  :  [{label: 'Order', position: 30  }]
      @UI.identification  : [{ position: 30 }]
       @EndUserText.label: 'Order'
  key process_order : abap.char(10);
      @UI.lineItem  :  [{label: 'Description', position: 50  }]
      @UI.identification  : [{ position: 50 }]
       @EndUserText.label: 'Description'
      out_mat_descr : abap.char(40);
      @Semantics.quantity.unitOfMeasure: 'unit'
      @UI.lineItem  :  [{label: 'Out Qty', position: 60  }]
      @UI.identification  : [{ position: 60 }]
       @EndUserText.label: 'Out Qty'
      out_qty       : menge_d;
      @UI.lineItem  :  [{label: 'Unit', position: 70  }]
      @UI.identification  : [{ position: 70 }]
       @EndUserText.label: 'Unit'
      unit          : meins;
      @UI.lineItem  :  [{label: 'Movement Type', position: 80  }]
      @UI.identification  : [{ position: 80 }]
       @EndUserText.label: 'Movement Type'
      movement_type : bwart;
      @UI.lineItem  :  [{label: 'Kg Fat %', position: 90  }]
      @UI.identification  : [{ position: 90 }]
       @EndUserText.label: 'Kg Fat %'
      fat_percent   : abap.dec( 10,2 );
      @UI.lineItem  :  [{label: 'Kg SNF %', position: 100  }]
      @UI.identification  : [{ position: 100 }]
       @EndUserText.label: 'Kg SNF %'
      snf_percent   : abap.dec( 10,2 );
      @Semantics.quantity.unitOfMeasure: 'unit'
      @UI.lineItem  :  [{label: 'Kg Fat Qty', position: 120  }]
      @UI.identification  : [{ position: 120 }]
       @EndUserText.label: 'Kg Fat Qty'
      fat_qty       : menge_d;
      @Semantics.quantity.unitOfMeasure: 'unit'
      @UI.lineItem  :  [{label: 'Kg SNF Qty', position: 130  }]
      @UI.identification  : [{ position: 130 }]
       @EndUserText.label: 'Kg SNF Qty'
      snf_qty       : menge_d;
      @ObjectModel.filter.enabled: false
      @ObjectModel.sort.enabled: false            
      _Header       : association to parent ZCE_YEILD_REPORT_HEADER on  _Header.material     = $projection.material
                                                                    and _Header.plant        = $projection.plant
                                                                    and _Header.posting_date = $projection.posting_date;


}
