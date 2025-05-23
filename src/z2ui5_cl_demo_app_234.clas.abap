CLASS z2ui5_cl_demo_app_234 DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    DATA check_initialized TYPE abap_bool .
  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_234 IMPLEMENTATION.


  METHOD display_view.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
         )->page(
            title          = 'abap2UI5 - Sample: TextArea - Value States'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(layout) = page->vertical_layout(
                         class = `sapUiContentPadding`
                         width = `100%`
                          )->content( ns = `layout`
                              )->text_area( valuestate  = `Warning`
                                            placeholder = `ValueState : Warning`
                                            width       = `100%`
                              )->text_area( valuestate  = `Error`
                                            placeholder = `ValueState : Error`
                                            width       = `100%`
                              )->text_area( valuestate  = `Success`
                                            placeholder = `ValueState : Success`
                                            width       = `100%`
                              )->text_area( valuestate  = `Information`
                                            placeholder = `ValueState : Information`
                                            width       = `100%` ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD on_event.

    CASE client->get( )-event.

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      display_view( client ).
    ENDIF.

    on_event( client ).

  ENDMETHOD.
ENDCLASS.
