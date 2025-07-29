@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Interface View for Milk Col Sum'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Zi_mm_milkcoll_sum
  as select from zmm_milkcoll
{
  key mirodoc,
  key miro_year,
      milkuom,
      milk_type,
      currency,
      @Semantics.quantity.unitOfMeasure : 'milkuom'
      milk_qty                as qty,

      cast(
      case
      when milk_qty = 0
      then 0
      else (fat * milk_qty * ( 103 / 100 ) ) /  ( milk_qty * ( 103 / 100 ) )
      end as abap.dec(10,2) ) as avg_fat,

      cast(
      case
      when milk_qty = 0
      then 0
      else (snf * milk_qty * ( 103 / 100 ) ) /  ( milk_qty * ( 103 / 100 ) )
      end as abap.dec(10,2) ) as avg_snf,


      floor(cast(
      ( cast( base_rate as abap.dec( 10, 2 ) ) * milk_qty ) +
      ( cast( commision as abap.dec( 10, 2 ) ) * milk_qty ) +
      ( cast( incentive as abap.dec( 10, 2 ) ) * milk_qty ) +
      ( cast( transport as abap.dec( 10, 2 ) ) * milk_qty )
      as abap.dec(10,2))
      )                       as total_amt


}
