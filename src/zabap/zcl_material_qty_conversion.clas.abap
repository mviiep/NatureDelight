CLASS zcl_material_qty_conversion DEFINITION
  PUBLIC
  FINAL
  CREATE PRIVATE. "PUBLIC .

  PUBLIC SECTION.
    CLASS-METHODS material_conversion
      IMPORTING
        im_material     TYPE matnr
        im_source_value TYPE menge_d
        im_source_unit  TYPE meins
        im_target_unit  TYPE meins
      EXPORTING
        e_target_value  TYPE menge_d.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCL_MATERIAL_QTY_CONVERSION IMPLEMENTATION.


  METHOD material_conversion.
    DATA : lv_quan_to_base TYPE menge_d.
    SELECT SINGLE product , baseunit FROM i_product
    WITH PRIVILEGED ACCESS
    WHERE  product = @im_material
    INTO @DATA(lw_material).
    IF sy-subrc = 0.


      SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
      FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
      WHERE alternativeunit = @lw_material-baseunit
      AND product = @im_material
      AND baseunit = @lw_material-baseunit
      INTO @DATA(lw_base_unit).

      SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
      FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
      WHERE alternativeunit = @im_source_unit
      AND product = @im_material
      AND baseunit = @lw_material-baseunit
      INTO @DATA(lw_source_unit).
      IF sy-subrc = 0 AND lw_source_unit-QuantityDenominator IS NOT INITIAL  AND lw_base_unit-QuantityDenominator IS NOT INITIAL.
        lv_quan_to_base = im_source_value
        * ( lw_source_unit-QuantityNumerator / lw_source_unit-QuantityDenominator  )
         * ( lw_base_unit-QuantityNumerator / lw_base_unit-QuantityDenominator  ).
      ENDIF.

      SELECT SINGLE alternativeunit, quantitynumerator,quantitydenominator
      FROM i_productunitsofmeasure WITH PRIVILEGED ACCESS
      WHERE alternativeunit = @im_target_unit
      AND product = @im_material
      AND baseunit = @lw_material-baseunit
      INTO @DATA(lw_destination_unit).
      IF sy-subrc = 0 AND  lw_destination_unit-QuantityNumerator  IS NOT INITIAL AND lw_base_unit-QuantityDenominator IS NOT INITIAL..
        e_target_value = lv_quan_to_base *
        (  lw_destination_unit-QuantityDenominator / lw_destination_unit-QuantityNumerator )
        * ( lw_base_unit-QuantityDenominator / lw_base_unit-QuantityNumerator ).
      ENDIF.
    ENDIF.



  ENDMETHOD.
ENDCLASS.
