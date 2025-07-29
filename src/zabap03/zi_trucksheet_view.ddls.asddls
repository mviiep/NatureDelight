@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view for Vehicle Master'
define root view entity ZI_TRUCKSHEET_VIEW
  as select distinct from    I_BillingDocument     as _header
  

//    left outer join I_BillingDocumentItem as _item  on _header.BillingDocument = _item.BillingDocument
    left outer join ZI_BILLING_DOCUMENT_ITEM as _item  on _header.BillingDocument = _item.BillingDocument

    left outer join I_DeliveryDocument    as _delv  on _delv.DeliveryDocument = _item.ReferenceSDDocument

    left outer join I_Customer            as _cust  on _cust.Customer = _header.SoldToParty

    left outer join ZI_TRUCKSHET_HI_VIEW  as _truck on _truck.Vbeln = _header.BillingDocument

  //    left outer join I_CityCode  as _city on _city.CityCode = _header.CityCode

{


  key  _header.BillingDocument     as invid,
  key  _header.BillingDocument     as vbeln,
       _header.SDDocumentCategory  as fktyp,
       _header.SoldToParty         as kunag,
       _cust.BPCustomerName        as name,
       //       _city.CityCode as city,
       _header.TotalNetAmount      as netwr,
       _header.TotalTaxAmount      as taxamount,
       _header.TransactionCurrency as Curr,
       _cust.OrganizationBPName1   as name1,
       _header.DistributionChannel as vtweg,
       _header.BillingDocumentDate as fkdat,
       _delv.ActualDeliveryRoute   as route,
//       @Semantics.quantity.unitOfMeasure: 'unit'
//       sum(_item.BillingQuantity)  as FKIMG,
//         _item.quantity  as FKIMG,
//       _item.BillingQuantityUnit   as unit,
//         _item.BillingQuantityUnit   as unit,
       _truck.itemTrucksheetNo,
       _truck.TrucksheetItem,
       _truck.Matkl,
       _truck.Meins,
       _truck.Qty,
       _truck.Noofcrate,
       _truck.Noofcan,
       _truck.Currency,
       _truck.Amount,
       _truck._header
}
where
  _truck.itemTrucksheetNo is null
  and _header.BillingDocumentIsCancelled is initial
  and _header.CancelledBillingDocument is initial
//  and _header.DistributionChannel = '20'
group by
  _header.BillingDocument,
  _header.SDDocumentCategory,
  _header.SoldToParty,
  _cust.BPCustomerName,
  //  _city.CityCode,
  _header.TotalNetAmount,
  _header.TransactionCurrency,
  _header.DistributionChannel,
  _cust.OrganizationBPName1,
  _header.TotalTaxAmount,
  _header.BillingDocumentDate,
//  _item.BillingQuantityUnit,
//     _item.BillingQuantityUnit,
//     _item.quantity,
  _delv.ActualDeliveryRoute,
  _truck.itemTrucksheetNo,
  _truck.TrucksheetItem,
  _truck.Matkl,
  _truck.Meins,
  _truck.Qty,
  _truck.Noofcrate,
  _truck.Noofcan,
  _truck.Currency,
  _truck.Amount
