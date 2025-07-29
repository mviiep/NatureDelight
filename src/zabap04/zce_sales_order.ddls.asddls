@EndUserText.label: 'Custom Entity Sales Order'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_SALES_ORDER'

define custom entity ZCE_SALES_ORDER
{     
  
      @EndUserText.label: 'SO Id'
      @UI   : {
          selectionField: [{ position: 10 }],
          lineItem: [{ position: 10}],
          identification: [{ position: 10 }]
      }
    key soid : abap.char(10);

      @EndUserText.label: 'Sales org'
      @UI   : {
      lineItem: [{position: 30 }],
      identification: [{position: 30 }]
      }
      vkorg : abap.char(4);


      @EndUserText.label: 'Division'
      @UI   : {
          lineItem: [{position: 40 }],
          identification: [{position: 40 }] }
      spart : abap.char(2);

      @EndUserText.label: 'DistributionChannel'
      @UI   : {
          lineItem: [{position: 50 }],
          identification: [{position: 50 }]
      }
      vtweg : abap.char(2);
      @EndUserText.label: 'SoldToParty'
      @UI   : {
          lineItem: [{position: 60 }],
          identification: [{position: 60 }]
      }
      kunnr : abap.char(10);

}
