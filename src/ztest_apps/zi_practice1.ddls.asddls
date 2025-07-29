@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Practice'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_PRACTICE1 as select from zpractice1

{
    key id as Id,
    name as Name
   
}
