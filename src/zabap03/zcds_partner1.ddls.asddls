@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS view for partner function'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_PARTNER1 as select distinct  from I_SalesOrderItmSubsqntProcFlow as sales
// association[1..1]  to  I_SalesOrderPartner as salesP
 inner join I_SalesOrderPartner as salesP
//on  $projection.salesorder = salesP.SalesOrder and salesP.PartnerFunction = 'WE'
  on sales.SalesOrder = salesP.SalesOrder and salesP.PartnerFunction = 'WE'
{
   key sales.SalesOrder as salesorder,
    key sales.SubsequentDocument as vbeln,
   // key sales.SubsequentDocumentItem as subitem,
    //key sales.DocRelationshipUUID as doc,
   // key sales.SalesOrderItem as salesorderitem,
    salesP.Customer as Cust,
    salesP.FullName as name1,
    salesP.PartnerFunction as partnerf
   
}


  
