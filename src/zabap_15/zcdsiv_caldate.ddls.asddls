@AbapCatalog.sqlViewName: 'ZCALDATE'
@ObjectModel: {
  usageType: {
    dataClass:      #MIXED,
    serviceQuality: #D,
    sizeCategory:   #XXL
  }
}
//@Analytics.settings.maxProcessingEffort: #HIGH

//@Analytics.dataCategory: #CUBE

@EndUserText.label: 'CalendarDates'
define view ZCDSIV_CALDATE 
with parameters
    @Environment.systemField: #SYSTEM_DATE
    P_Keydate : sydate
as select from I_CalendarDate

{
   key CalendarDate,
   CalendarYear,
   CalendarQuarter,
   CalendarMonth,
   CalendarWeek,
   CalendarDay,
   YearMonth,
   YearQuarter,
   YearWeek,
   WeekDay,
   FirstDayOfWeekDate,
   FirstDayOfMonthDate,
   CalendarDayOfYear,
   YearDay,
   dats_add_days($parameters.P_Keydate,-1,'INITIAL') as PreviousDate,
   /* Associations */
   _CalendarMonth,
   _CalendarQuarter,
   _CalendarWeek,
   _CalendarYear,
   _WeekDay,
   _YearMonth  
  
}
where CalendarDate= $parameters.P_Keydate
