@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Data'
define root view entity ZI_SO
  as select from zsdt_so
{
  key id       as Id,
      soid     as Soid,
      auart    as Auart,
      vkorg    as Vkorg,
      vtweg    as Vtweg,
      spart    as Spart,
      kunnr    as Kunnr,
      bstkde   as BstkdE,
      bstkd    as Bstkd,
      knumv    as Knumv,
      audat    as Audat,
      prcdate  as PrcDate,
      posnr    as Posnr,
      matnr    as Matnr,
      kdmat    as Kdmat,
      gstin    as Gstin,
      @Semantics.quantity.unitOfMeasure : 'Vrkme'
      kwmeng   as Kwmeng,
      vrkme    as Vrkme,
      pstyv    as Pstyv,
      werks    as Werks,
      vbeln    as Vbeln
}
//where vbeln is null
