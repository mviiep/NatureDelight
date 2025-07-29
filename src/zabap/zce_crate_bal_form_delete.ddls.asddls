@ObjectModel: {
    query: {
       implementedBy: 'ABAP:ZCL_CRATE_BAL_FORM'
    }
}
 
@UI.headerInfo: { typeName: 'Crate Balance Form' ,
                  typeNamePlural: 'Crate Balance Form' }

@EndUserText.label: 'Crate Balance Form'
define root custom entity ZCE_CRATE_BAL_FORM_delete
{

 @UI.facet   : [{ id : 'CUSTOMER',
                purpose: #STANDARD,
                type: #IDENTIFICATION_REFERENCE,
                label: 'Crate Balance',
                position: 10 }]

// @UI.selectionField    : [{position: 10}]
// @UI.lineItem :  [{label: 'Customer', position: 10 ,importance: #HIGH }]
// @UI.identification: [{label: 'Customer', position: 10 }]   
//// @Consumption.valueHelpDefinition: [{ entity: { name: 'I_Customer_VH',
////                                               element: 'Customer' } }]
  key Customer : abap.char(10);
                        
}
