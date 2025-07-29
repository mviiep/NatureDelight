@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Leakage Return Code'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZI_LEAKAGE_RETURN_CODE as select from I_CustomerReturnItem 
association[0..*] to I_ReturnReasonText as _reason
on $projection.ReturnReason = _reason.ReturnReason
and _reason.Language = $session.system_language

{
   key CustomerReturn,
   key CustomerReturnItem,
       ReturnReason,
       _reason.ReturnReasonName,
       _reason
}
