@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Consuption View For Billing Document'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
    
@Metadata.allowExtensions: true
define root view entity ZC_BILLINGDOCUMENT 
  provider contract transactional_query 
as projection on ZI_BILLINGDOCUMENT as BillDoc
{
  @EndUserText.label: 'Billing Doc'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocument', element: 'BillingDocument' } }]          
    key BillingDocument,

  @EndUserText.label: 'Billing Doc Type'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_BillingDocumentType', element: 'BillingDocumentType' } }]              
    BillingDocumentType,

  @EndUserText.label: 'Sold To Party'
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer', element: 'Customer' } }]                  
    SoldToParty,
    
  @EndUserText.label: 'Sold To Party Name'    
    CustomerFullName,

  @EndUserText.label: 'Sales Org'        
    SalesOrganization,

  @EndUserText.label: 'Distribution Channel'            
  @Search.defaultSearchElement: true
  @Consumption.valueHelpDefinition: [{ entity: { name: 'I_DistributionChannel', element: 'DistributionChannel' } }]                    
    DistributionChannel,

  @EndUserText.label: 'Division'                
    Division,
    
  @EndUserText.label: 'Billing Date'                    
    BillingDocumentDate,
    
  @EndUserText.label: 'Total Net Amount'                    
    @Semantics.amount.currencyCode : 'TransactionCurrency'        
    TotalNetAmount,
    
  @EndUserText.label: 'Currency'                        
    TransactionCurrency,
    
  @EndUserText.label: 'Total Tax Amount'                        
    @Semantics.amount.currencyCode : 'TransactionCurrency'            
    TotalTaxAmount,
     @Semantics.amount.currencyCode : 'TransactionCurrency'  
    @EndUserText.label: 'Total Amount' 
    TotalAmount,
    
  @EndUserText.label: 'Company Code'                        
    CompanyCode,
    
  @EndUserText.label: 'Fiscal Year'                        
    FiscalYear,
    
  @EndUserText.label: 'Accounting Doc No'                        
    AccountingDocument,
    
  @EndUserText.label: 'Created By'                        
    CreatedByUser,
    
  @EndUserText.label: 'Created On Date'                        
    CreationDate,
//    /* Associations */
//    _SoldToParty
 pdf_data 
}
