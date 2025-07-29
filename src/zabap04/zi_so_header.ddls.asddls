@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SO Header'
define root view entity ZI_SO_HEADER 
as select from zsdt_so_header as _header
composition [1..*] of ZI_SO_ITEM as _item
{
    key _header.soid as Soid,
    _header.vbeln as Vbeln,
    _header.erdat as Erdat,
    _header.erzet as Erzet,
    _header.ernam as Ernam,
    _header.audat as Audat,
    _header.auart as Auart,
    _header.waerk as Waerk,
    _header.vkorg as Vkorg,
    _header.spart as Spart,
    _header.vtweg as Vtweg,
    _header.kunnr as Kunnr,
    _header.bstkd_e as BstkdE,
    _header.bstkd as Bstkd,
    _header.knumv as Knumv,
    _header.created_by as CreatedBy,
    _header.created_on as CreatedOn,
    _item
}
