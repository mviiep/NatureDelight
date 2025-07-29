@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Invoice data'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_VBRK_DATA
  as select from I_BillingDocumentBasic as _vbrk
  association [0..*] to I_BillingDocumentItem as _vbrp  on $projection.BillingDocument = _vbrk.BillingDocument
{
  key BillingDocument,
      SDDocumentCategory,
      BillingDocumentCategory,
      BillingDocumentType,
      ProposedBillingDocumentType,
      CreatedByUser,
      CreationDate,
      CreationTime,
      LastChangeDate,
      LastChangeDateTime,
      LogicalSystem, 
      SalesOrganization,
      DistributionChannel,
      Division,
      BillingDocumentDate,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalNetAmount,
      TransactionCurrency,
      StatisticsCurrency,
      @Semantics.amount.currencyCode: 'TransactionCurrency'
      TotalTaxAmount,
      ContractAccount,
      CustomerPaymentTerms,
      PaymentMethod,
      PaymentReference,
      FixedValueDate,
      AdditionalValueDays,
      SEPAMandate,
      CompanyCode,
      FiscalYear,
      AccountingDocument,
      FiscalPeriod,
      CustomerAccountAssignmentGroup,
      AccountingExchangeRateIsSet,
      AccountingExchangeRate,
      ExchangeRateDate,
      ExchangeRateType,
      DocumentReferenceID,
      AssignmentReference,
      ReversalReason,
      DunningArea,
      DunningBlockingReason,
      DunningKey,
      InternalFinancialDocument,
      IsRelevantForAccrual,
      InvoiceListType,
      InvoiceListBillingDate,
      BillingDocRequestReference,
      BillgDocReqRefLgclSyst,
      BillgDocReqRefSDDocCategory,
      SoldToParty,
      PartnerCompany,
      PurchaseOrderByCustomer,
      CustomerGroup,
      Country,
      CityCode,
      SalesDistrict,
      Region,
      County,
      _vbrp
}
