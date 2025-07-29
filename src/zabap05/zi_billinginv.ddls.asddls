@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Invoice for EINV'
define root view entity ZI_BILLINGINV
  as select from    I_BillingDocument as _header
    left outer join ZI_INVREFNUM on _header.BillingDocument = ZI_INVREFNUM.Docno
    left outer join ztsd_ei_log on _header.BillingDocument = ztsd_ei_log.docno
{

  key  _header.BillingDocument     as BillingDocument,
       _header.SoldToParty         as SoldToParty,
       _header.BillingDocumentDate as BillingDocumentDate,
       _header.BillingDocumentType as BillingDocumentType,
       _header.CompanyCode         as CompanyCode,
       _header.DistributionChannel as DistributionChannel,
       ZI_INVREFNUM.Irn            as Irn,
       ZI_INVREFNUM.IrnStatus      as IrnStatus,
       ztsd_ei_log.message         as MSG
}
//where ZI_INVREFNUM.Irn is null
  
