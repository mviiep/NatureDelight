@EndUserText.label: 'Consumption View for Sales Order Header'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define 
root view entity ZC_SALES_ORDER_HEADER 
 provider contract transactional_query
as projection on ZI_SALES_ORDER_HEADER
{
    key Id,
    @EndUserText.label: 'SO Id'
     SoID,
    @EndUserText.label: 'Order Type'
    Ordertype,
    @EndUserText.label: 'Sales Org'
    Salesorg,
    @EndUserText.label: 'Distribution Channel'
    Dischannel,
    @EndUserText.label: 'Divsion'
    Division,
    @EndUserText.label: 'Sold To Party'
    Soldtoparty,
    @EndUserText.label: 'Customer Reference'
    CustomerRef,
    @EndUserText.label: 'Ship To Party'
    Shiptoparty,
    @EndUserText.label: 'Shipping Condition'
    Shipcondition,
    @EndUserText.label: 'Delivery Date'
    Deliverydate,
    @EndUserText.label: 'Pricing Date'
    Pricedate,
    @EndUserText.label: 'Sales Order'
    Vbeln,
    
    lastchangedat,
    CreatedBy,
    CreatedOn,
     @EndUserText.label: 'Created Date'
    CreatedDate,
    /* Associations */
    _SalesItem  : redirected to composition child ZC_SALES_ORDER_ITEM
}
