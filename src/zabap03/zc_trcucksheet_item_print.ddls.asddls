@EndUserText.label: 'Truck sheet Item Print'
@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZC_TRCUCKSHEET_ITEM_PRINT as projection on ZI_TRUCKSHEET_ITEM_PRINT
{
    key TrucksheetNo,
    key TrucksheetItem,
    Vbeln,
    Kunag,
    Name1,
    Route,
    Matkl,
    Meins,
    Qty,
    Noofcrate,
    Noofcan,
    Currency,
    Amount,
    StockQty,
    /* Associations */
    _header : redirected to parent ZC_TRCUCKSHEET_HEADER_PRINT
}
