@EndUserText.label: 'Custom Entity View for Weigh Bridge'

@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MM_WB_CLASS'
    }
}

define root custom entity ZCE_CDS_WB
  // with parameters parameter_name : parameter_type
{

      @EndUserText.label        : 'Gatepass Number'
      @UI                       :{ lineItem: [{ position: 10, label: 'Gatepass No.' }],
            identification      : [{ position: 10, label: 'Gatepass No.' }],
            selectionField      : [{ position: 10 }] }
  key gp_no                     : abap.char(10);
      @EndUserText.label        : 'STOP Number'
  key ebeln                     : ebeln;
      @EndUserText.label        : 'STOP Item'
  key ebelp                     : ebelp;
      @EndUserText.label        : 'Gross Weight'
  key total_wt                  : menge_d;
      @EndUserText.label        : 'Weighbridge Weight'
  key item_wt                   : menge_d;
      @EndUserText.label        : 'Difference Weight'
  key diff_wt                   : menge_d;
      @EndUserText.label        : 'Tare Weight'
      tare_wt                   : menge_d;
      @EndUserText.label        : 'Trucksheet Weight'
      tsheet_wt                : menge_d;
      @EndUserText.label        : 'Plant'
      werks                     : werks_d;
      @EndUserText.label        : 'Material Document'
      mblnr                     : mblnr;
      @EndUserText.label        : 'MaterialDocumentYear'
      mjahr                     : mjahr;
      @EndUserText.label        : 'MaterialDocumentItem'
      zeile                     : mblpo;
      @EndUserText.label        : 'Material'
      matnr                     : matnr;
      @EndUserText.label        : 'Storare Location'
      lgort                     : zde_lgort1;
      @EndUserText.label        : 'Storare Location Name'
      lgort_name                : abap.char( 16 );
      @EndUserText.label        : 'Entry Type'
      entry_type                : zde_gate_entry_type;
      @EndUserText.label        : 'Batch'
      charg                     : charg_d;
      @EndUserText.label        : 'Quantity'
      OrderQuantity             : zde_bstmg;
      @EndUserText.label        : 'Quantity UOM'
      @Semantics.unitOfMeasure  : true
      PurchaseOrderQuantityUnit : zde_bstme;
      @EndUserText.label        : 'Chilling Center'
      ChillingCenter            : abap.char( 4 );
      @EndUserText.label        : 'Compartment'
      Compartment               : abap.char( 1 );

      @EndUserText.label        : 'Weight UOM'
      @Semantics.unitOfMeasure  : true
      weight_unit               : meins;
      @EndUserText.label        : 'Trucksheet No.'
      trucksheet_no             : abap.char(10);
      @EndUserText.label        : 'fromDB'
      from_DB                   : abap_boolean;
      fulltruckunload           : abap_boolean;
}
