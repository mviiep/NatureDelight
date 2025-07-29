@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'MIRO PRINT'
define root view entity ZI_ZMM_MIRO_PRINT 
as select from zmm_milk_miro
{
    key mirodoc as Mirodoc,
    key miroyear as Miroyear,
    lifnr as Lifnr,
    name1 as Name1,
    plant as Plant,
    sloc as Sloc,
    pdf_attach as PdfAttach
}
