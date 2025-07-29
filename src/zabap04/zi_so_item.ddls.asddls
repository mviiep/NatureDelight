@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for SO Item'

//@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED
//}

define view entity ZI_SO_ITEM
  as select from zsdt_so_item as _item

  association to parent ZI_SO_HEADER as _header on $projection.Soid = _header.Soid
{
  key   _item.soid  as Soid,
  key   _item.posnr  as Posnr,
        _item.matnr  as Matnr,
        _item.kdmat  as Kdmat,
        _item.meins  as Meins,
        _item.vrkme  as Vrkme,
        @Semantics.quantity.unitOfMeasure : 'Vrkme'
        _item.kwmeng as Kwmeng,
        _item.pstyv  as Pstyv,
        _item.werks  as Werks,
        _item.waerk  as Waerk,
        //      @Semantics.amount.currencyCode : 'Waerk'
        //      _item.netwr  as Netwr,
      _header
}
