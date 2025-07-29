@EndUserText.label: 'Crate Balance Form Display'
@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.allowExtensions: true
define root view entity ZC_CRATE_BALANCE_FORM_DISPALY
  provider contract transactional_query
  as projection on ZI_CRATE_BALANCE_DISPLAY
{
      @EndUserText.label: 'Customer'
  key Customer,
      @EndUserText.label: 'Customer Name'
      CustomerName,
      customer1,
      pdf_data




}
