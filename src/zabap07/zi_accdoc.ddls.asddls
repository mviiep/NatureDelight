@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface view ZFIT_ACCDOC'
define root view entity ZI_ACCDOC
  as select from zfit_accdoc
{
  key id    as Id,
      belnr as Belnr,
      docid as Docid,
      bukrs as Bukrs,
      gjahr as Gjahr,
      blart as Blart,
      bldat as Bldat,
      budat as Budat,
      waers as Waers,
      bupla as Bupla,
      secco as Secco,
      xblnr as Xblnr,
      bktxt as Bktxt,
      hkont as Hkont,
      dmbtr as Dmbtr,
//      wrbtr as Wrbtr,
      shkzg as Shkzg,
      kostl as Kostl,
      prctr as Prctr,
      mwskz as Mwskz,
      bank  as Bank,
      hbkid as Hbkid,
      kunnr as Kunnr,
      lifnr as Lifnr,
      umskz as Umskz,
      sgtxt as sgtxt,
      zuonr as ZUONR,
      zlsch as zlsch,
      uname as uname
}
