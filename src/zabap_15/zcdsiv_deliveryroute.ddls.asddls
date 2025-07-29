@AbapCatalog.sqlViewName: 'ZCMSALESDATAB'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
@Analytics.settings.maxProcessingEffort: #HIGH
@Analytics.dataCategory: #CUBE

@EndUserText.label: 'Sales Report for Route base'
define view ZCDSIV_DeliveryRoute
  with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_StartDate : sydate,
    @Environment.systemField: #SYSTEM_DATE
    P_EndDate   : sydate
  as select from I_DeliveryDocumentItem
  association [0..1] to I_BillingDocumentItem as _Billing       on  _Billing.ReferenceSDDocument           = $projection.DeliveryDocument
                                                                and _Billing.ReferenceSDDocumentItem       = $projection.DeliveryDocumentItem
                                                                and (
                                                                   _Billing.ReferenceSDDocumentCategory    = 'J' // Delivery
                                                                   or _Billing.ReferenceSDDocumentCategory = 'T' // Returns Delivery for Order
                                                                 )
  association [0..1] to I_SalesDocumentItem   as _SalesDocument on  $projection.ReferenceSDDocument         = _SalesDocument.SalesDocument
                                                                and $projection.ReferenceSDDocumentItem     = _SalesDocument.SalesDocumentItem
                                                                and $projection.ReferenceSDDocumentCategory = 'C'
  association [0..1] to I_Batch               as _Batch2        on  $projection.Plant    = _Batch2.Plant
                                                                and $projection.Material = _Batch2.Material
                                                                and $projection.Batch    = _Batch2.Batch
  association [0..1] to I_Region              as _Region1       on  $projection.region  = _Region1.Region
                                                                and $projection.country = _Region1.Country
  association [0..1] to I_Customer            as _SoldToParty   on  $projection.soldtoparty = _SoldToParty.Customer
  association [0..1] to I_Customer            as _ShipToParty   on  $projection.shiptoparty = _ShipToParty.Customer
  association [0..1] to I_Product             as _Product1      on  $projection.Product = _Product1.Product
  association [0..1] to I_CustomerGroup       as _CustGrp       on  $projection.customergroup = _CustGrp.CustomerGroup
  association [0..1] to I_Plant               as _Plant1        on  $projection.Plant = _Plant1.Plant
  association [0..1] to I_DistributionChannel as _DistChnl      on  $projection.DistributionChannel = _DistChnl.DistributionChannel
{
  key DeliveryDocument,
  key DeliveryDocumentItem,
      _Billing.BillingDocument,
      _Billing.BillingDocumentItem,


      //      @Semantics.amount.currencyCode: 'TransactionCurrency'
      //      _Billing.NetAmount,

      case
      when _Billing.CancelledBillingDocument is not initial
      then _Billing.NetAmount * -1
      else _Billing.NetAmount
      end                                as NetAmount,

      _Billing.Region,
      _Billing.SoldToParty,
      _Billing.ShipToParty,
      _Billing.Country,
      Product,
      @Semantics.currencyCode: true
      _Billing.TransactionCurrency,
      _Billing.CancelledBillingDocument,
      _Billing._BillingDocument.BillingDocumentIsCancelled,
      _Billing.BillingDocumentDate,
      _Billing.CustomerGroup,
      _DeliveryDocument.ProposedDeliveryRoute,
      //      ActualDeliveredQtyInBaseUnit,
      //      BaseUnit,
      //      IsReturnsItem,
      ReturnsDeliveryItemCode,
      @Semantics.quantity.unitOfMeasure: 'DeliveryQuantityUnit'
      @DefaultAggregation: #SUM

      case
      when _Billing.CancelledBillingDocument is not initial
      then ActualDeliveredQtyInBaseUnit * -1
      else ActualDeliveredQtyInBaseUnit
      end                                as OriginalDeliveryQuantity,
      @Semantics.unitOfMeasure: true
      BaseUnit                           as DeliveryQuantityUnit,
      _SalesDocument.SalesDocument,
      _SalesDocument.SalesDocumentItem,
      @DefaultAggregation: #SUM
      @Semantics.amount.currencyCode: 'SalesTransactionCurrency'
      _SalesDocument.NetAmount           as SalesNetAmount,
      @Semantics.currencyCode: true
      _SalesDocument.TransactionCurrency as SalesTransactionCurrency,
      @Semantics.amount.currencyCode: 'SalesTransactionCurrency'
      _SalesDocument.NetPriceAmount      as SalesNetPriceAmount,
      @Semantics.quantity.unitOfMeasure: 'OrderQuantityUnit'
      @DefaultAggregation: #SUM
      _SalesDocument.OrderQuantity       as SalesOrderQuantity,
      @Semantics.unitOfMeasure: true
      _SalesDocument.OrderQuantityUnit,
      DistributionChannel,
      Division,
      //      @ObjectModel.foreignKey.association: '_Batch2'
      Batch,
      SDDocumentCategory,
      //      TransactionCurrency,
      DeliveryDocumentItemCategory,
      SalesDocumentItemType,
      CreatedByUser,
      CreationDate,
      CreationTime,
      LastChangeDate,
      Material,
      Plant,
      ReferenceSDDocument,
      ReferenceSDDocumentItem,
      ReferenceSDDocumentCategory,
      ProductGroup,


      /* Associations */
      _Billing,

      _Batch2,

      _CreatedByUser,

      _DeliveryDocument,
      //      _DeliveryQuantityUnit,

      _DistributionChannel,
      _Division,

      _Plant,
      _Product,
      _ProductGroup,

      _ReferenceSalesDocumentItem,
      _ReferenceSDDocument,
      _ReferenceSDDocumentCategory,

      _SalesDocumentItemType,

      _SDDocumentCategory,
      _Region1,
      _SoldToParty,
      _ShipToParty,
      _Product1,
      _CustGrp,
      _Plant1,
      _DistChnl


}
