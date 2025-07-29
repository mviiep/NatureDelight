@EndUserText.label: 'Consumption View for Sales Order Item'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define view entity ZC_SALES_ORDER_ITEM

  as projection on ZI_SALES_ORDER_ITEM
{
  key ItemId,
      @EndUserText.label: 'Header Id'
      HeaderId,
      @EndUserText.label: 'SO Id'
      SoId,
      @EndUserText.label: 'Item No'
      Item,
      @EndUserText.label: 'Material'
      Product,
      @EndUserText.label: 'GTIN'
      Gtin,
      @EndUserText.label: 'Quantity'
      Quatity,
      @EndUserText.label: 'Quantity Unit'
      Baseunit,
      @EndUserText.label: 'Item Category'
      ItemCategory,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Route'
      Route,
      /* Associations */
      Lastchangedat,
      _SalesHeader : redirected to parent ZC_SALES_ORDER_HEADER
}
