@EndUserText.label: 'Milk collection PDF'
@ObjectModel: {
    query: {
        implementedBy: 'ABAP:ZCL_MILK_COLLECTION_PDF'
    }
}
define custom entity ZCE_MILK_COLLECTION_PDF

{
   key mirodoc          : re_belnr;
  key   miro_year        : gjahr;
  
  attachments             : zde_attachment1;
  
}
