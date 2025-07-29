@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view INVREFNUM'

define root view entity ZI_INVREFNUM
  as select from zsdt_invrefnum
{
  key bukrs         as Bukrs,
  key docno         as Docno,
  key docyear      as DocYear,
  key doctype      as DocType,
  key odn           as Odn,
  key irn           as Irn,
  key version       as Version,
      bupla         as Bupla,
      odndate      as OdnDate,
      ackno        as AckNo,
      ackdate      as AckDate,
      irnstatus    as IrnStatus,
      canceldate   as CancelDate,
      ernam         as Ernam,
      erdat         as Erdat,
      erzet         as Erzet,
      signedinv    as SignedInv,
      signedqrcode as SignedQrcode
}
