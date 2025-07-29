@EndUserText.label: 'Crate Balance'
@Metadata.allowExtensions: true
define abstract entity ZAE_CRATE_BALANCE

{
  @EndUserText.quickInfo: 'From Date'
  FROM_DATE : abap.dats;
  @EndUserText.quickInfo: 'To Date'
  TO_DATE   : abap.dats;

}
