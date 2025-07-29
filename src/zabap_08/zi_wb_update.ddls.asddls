@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'GP No View'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType: {
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define root view entity ZI_WB_UPDATE
  as select distinct from zmmt_weigh_bridg
{
  @UI.facet: [{
      id: 'Main',
      label: 'Gatepass Details',
      type: #IDENTIFICATION_REFERENCE,
      position: 10
  }]

@UI.lineItem: [
  { position: 10, label: 'Gate Pass' },
  { type: #FOR_ACTION , dataAction: 'update_truck', label: 'Update' }
]
  key gp_no,

  @EndUserText.label: 'STO Order'
  @UI.lineItem: [{ position: 20 }]
  @UI.identification: [{ position: 20 }]
  key ebeln,

  @EndUserText.label: 'Item'
  @UI.lineItem: [{ position: 30 }]
  @UI.identification: [{ position: 30 }]
key  ebelp,

  @EndUserText.label: 'Full Truck Unload'
  @UI.lineItem: [{ position: 40 }]
  @UI.identification: [{ position: 40 }]
  fulltruckunload

}
where fulltruckunload <> 'X'

group by gp_no, ebeln, ebelp, fulltruckunload;


