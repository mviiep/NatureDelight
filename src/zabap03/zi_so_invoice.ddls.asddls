@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO data with Invoice'
define root view entity ZI_SO_INVOICE
  as select from    I_SalesDocumentItem    as _soitem
    
    
    left outer join I_DeliveryDocumentItem as _delv    on  _delv.ReferenceSDDocument     = _soitem.SalesDocument
                                                       and _delv.ReferenceSDDocumentItem = _soitem.SalesDocumentItem

    left outer join I_Product              as _mat     on _mat.Product = _soitem.Material

    left outer join I_BillingDocumentItem  as _invitem on  _invitem.ReferenceSDDocument     = _delv.DeliveryDocument
                                                       and _invitem.ReferenceSDDocumentItem = _delv.DeliveryDocumentItem
    left outer join I_BillingDocument as _invihead    on  _invihead.BillingDocument     = _invitem.BillingDocument
{

  key _soitem.SalesDocument,
  key _soitem.SalesDocumentItem,
      _soitem.Material,
      _soitem.OrderQuantityUnit,
      _mat.BaseUnit,
      @Semantics.quantity.unitOfMeasure: 'unit'
      _soitem.TargetQuantity,
      _mat.ProductGroup,
      _delv.DeliveryDocument,
      _delv.DeliveryDocumentItem,
      _invitem.BillingDocument,
      _invihead.YY1_LRNumber_BDH,
      _invitem.BillingDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'unit'
      _invitem.BillingQuantity as qty,
      _invitem.BillingQuantityUnit as unit,
      _invitem.SalesDocumentItemCategory as ItemCategory
} 
where
  _invitem.BillingDocument is not null
