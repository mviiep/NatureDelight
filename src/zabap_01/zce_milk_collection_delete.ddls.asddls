@EndUserText.label: 'Milk collection PDF Delete'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MILK_COLLECTION_DELETE'
    }
}
define custom entity ZCE_MILK_COLLECTION_DELETE

{
   key mirodoc          : re_belnr;
   key miro_year        : gjahr;
    
}
