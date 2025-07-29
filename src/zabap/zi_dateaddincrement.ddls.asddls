@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Date Operations'
@Metadata.ignorePropagatedAnnotations: true
//@ObjectModel.usageType:{
//    serviceQuality: #X,
//    sizeCategory: #S,
//    dataClass: #MIXED        
//}
@ObjectModel: { usageType: { serviceQuality: #A,
                             sizeCategory: #L,
                             dataClass: #META } }


define view entity ZI_DateAddIncrement 
  with parameters
    p_IncrementDate : datum, -- Pass in today's date in most case
    p_IncrementAmt  : abap.int4,   -- i.e. -1 or -12 or 1 or 12 for examples
    p_IncrementType : abap.char(1) -- D = Days, M = Months
  as
  select from I_CompanyCode
{
    
  $parameters.p_IncrementDate as IncrementDate,
  $parameters.p_IncrementAmt  as IncrementAmt,
  $parameters.p_IncrementType as IncrementType,
  case $parameters.p_IncrementType
  when 'D' then dats_add_days( $parameters.p_IncrementDate, $parameters.p_IncrementAmt, 'UNCHANGED' )
  when 'M' then dats_add_months($parameters.p_IncrementDate, $parameters.p_IncrementAmt, 'UNCHANGED')
  end                         as IncrementedDate
}

where
  I_CompanyCode.CompanyCode  = '1000'
