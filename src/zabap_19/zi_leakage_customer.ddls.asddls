@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Customer'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LEAKAGE_CUSTOMER as select distinct from  I_CustomerReturn
association  [0..*] to  I_Customer as _cust on $projection.SoldToParty = _cust.Customer
{
key    CustomerReturn,
       SoldToParty,
     _cust.Customer,
    _cust.CustomerName
  
    
}
