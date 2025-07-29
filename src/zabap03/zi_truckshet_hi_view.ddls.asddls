@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view truck sheet HeaderItem'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_TRUCKSHET_HI_VIEW
  as select from ZI_TRUCKSHET_I as _item

  association to parent  ZI_TRUCKSHET_H as _header on $projection.itemTrucksheetNo = _header.TrucksheetNo
{
  key _item.TrucksheetNo as itemTrucksheetNo,
  key _item.TrucksheetItem,
      _item.Vbeln,
      _item.Kunag,
      _item.Name1,
      _item.Route,
      _item.Matkl,
      _item.Meins,
      @Semantics.quantity.unitOfMeasure : 'Meins'
      _item.Qty,
      _item.Noofcrate,
      _item.Noofcan,
      _item.Currency,
      @Semantics.amount.currencyCode : 'Currency'
      _item.Amount,
//      _header.TrucksheetNo,
//      _header.VehicleNo,
//      _header.DriverName,
//      _header.DriverTelno,
//      _header.TrucksheetDate,
//      _header.TransDocNo,
//      _header.CreatedBy,
//      _header.CreatedOn,
      _header // Make association public
}
