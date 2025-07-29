@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Crate Balance Form Display'
define root view entity ZI_CRATE_BALANCE_DISPLAY as select from I_Customer
association[0..*] to ztcrate_balalce as _Crt on _Crt.customer = $projection.Customer

{
    
 key Customer ,
 CustomerName,
 _Crt.customer as customer1,
 _Crt.fr_date,
 _Crt.to_date,
 _Crt.pdf_data
 
}
where CustomerAccountGroup = 'Z007';
