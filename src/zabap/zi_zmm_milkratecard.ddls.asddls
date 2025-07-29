//@AbapCatalog.sqlViewName: 'ZI_MILKRATECARD'
//@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View For ZMM_MILKRATECARD'
@ObjectModel.resultSet.sizeCategory: #XS
define root view entity ZI_ZMM_MILKRATECARD 
   as select from zmm_milkratecard
{
   key id as Id,
   plant as Plant,   
   sloc as Sloc,
   lgobe as Lgobe,
   vendor as Vendor,
   name1 as Name1,
   effdate as Effdate,
   milk_type as Milktype,
   matnr as Matnr,
   fatuom as Fatuom, 
   fat as Fat,
   snf as Snf,
   protain as Protain,
   param_1 as Param1,
   param_2 as Param2,
   param_3 as Param3,
   param_4 as Param4,
   param_5 as Param5,
   currency as Currency,
   rate as Rate,
   base_rate as BaseRate,
   incentive as Incentive,
   commision as Commision,
   transport as Transport,
       
//    @Semantics.largeObject: {
//      mimeType: 'Mimetype',
//      fileName: 'Filename',
//      contentDispositionPreference: #INLINE,
//      acceptableMimeTypes: ['application/vnd.openxmlformats-officedocument.spreadsheetml.sheet']      
//    }      
//    attachment            as Attachment,
//    
//    @Semantics.mimeType: true
//    mimetype             as MimeType,
//    
//    filename              as Filename,   
   
   @Semantics.user.createdBy: true
   created_by as CreatedBy,
   @Semantics.systemDateTime.createdAt: true
   created_on as CreatedOn,


//   @Semantics.user.lastChangedBy: true
   changed_by as ChangedBy,
//   @Semantics.systemDateTime.lastChangedAt: true
   changed_on as ChangedOn
}
