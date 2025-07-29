@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Sales Order header'
define root view entity ZI_SALES_ORDER_HEADER
  as select from zsd_sales_header
  composition [0..*] of ZI_SALES_ORDER_ITEM as _SalesItem



{
  key zsd_sales_header.id            as Id,
      zsd_sales_header.soid          as SoID,
      zsd_sales_header.ordertype     as Ordertype,
      zsd_sales_header.salesorg      as Salesorg,
      zsd_sales_header.dischannel    as Dischannel,
      zsd_sales_header.division      as Division,
      zsd_sales_header.soldtoparty   as Soldtoparty,
      zsd_sales_header.customer_ref  as CustomerRef,
      zsd_sales_header.shiptoparty   as Shiptoparty,
      zsd_sales_header.shipcondition as Shipcondition,
      zsd_sales_header.deliverydate  as Deliverydate,
      zsd_sales_header.pricedate     as Pricedate,
      zsd_sales_header.vbeln         as Vbeln,
      zsd_sales_header.lastchangedat as lastchangedat,
      @Semantics.user.createdBy: true
      zsd_sales_header.created_by    as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      zsd_sales_header.created_on    as CreatedOn,
      zsd_sales_header.created_date   as CreatedDate,

      _SalesItem


}
