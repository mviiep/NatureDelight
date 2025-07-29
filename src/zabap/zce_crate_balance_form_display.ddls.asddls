@EndUserText.label: 'Crate Balance Form Display'
@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_CRATE_BAL_FORM_DISPLAY'
    }
}
define custom entity ZCE_CRATE_BALANCE_FORM_DISPLAY

{
  key Customer : abap.char(10);
  key fr_date  : datum;
  key to_date  : datum;
      PDF_DATA : zde_attachment1;

}
