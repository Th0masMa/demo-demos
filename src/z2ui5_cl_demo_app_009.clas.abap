CLASS z2ui5_cl_demo_app_009 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA:
      BEGIN OF screen,
        color_01 TYPE string,
        color_02 TYPE string,
        color_03 TYPE string,
        city     TYPE string,
        name     TYPE string,
        lastname TYPE string,
        quantity TYPE string,
        unit     TYPE string,
      END OF screen.

    TYPES:
      BEGIN OF s_suggestion_items,
        selkz TYPE abap_bool,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items.
    DATA mt_suggestion TYPE STANDARD TABLE OF s_suggestion_items WITH EMPTY KEY.
    DATA mt_suggestion_sel TYPE STANDARD TABLE OF s_suggestion_items WITH EMPTY KEY.

    TYPES:
      BEGIN OF s_suggestion_items_city,
        value TYPE string,
        descr TYPE string,
      END OF s_suggestion_items_city.
    DATA mt_suggestion_city TYPE STANDARD TABLE OF s_suggestion_items_city WITH EMPTY KEY.

    TYPES:
      BEGIN OF s_employee,
        selkz    TYPE abap_bool,
        city     TYPE string,
        nr       TYPE string,
        name     TYPE string,
        lastname TYPE string,
      END OF s_employee.
    DATA mt_employees_sel TYPE STANDARD TABLE OF s_employee WITH EMPTY KEY.
    DATA mt_employees TYPE STANDARD TABLE OF s_employee WITH EMPTY KEY.



    DATA mv_view_popup TYPE string.
    METHODS popup_f4_table
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS popup_f4_table_custom
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
  PROTECTED SECTION.

    METHODS z2ui5_on_rendering
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

    METHODS z2ui5_on_event
      IMPORTING
        client TYPE REF TO z2ui5_if_client.
    METHODS z2ui5_on_init.


  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_009 IMPLEMENTATION.


  METHOD popup_f4_table.

    DATA(popup) = z2ui5_cl_xml_view=>factory_popup( ).

    popup->dialog( 'abap2UI5 - F4 Value Help'
      )->table(
            mode  = 'SingleSelectLeft'
            items = client->_bind_edit( mt_suggestion_sel )
        )->columns(
            )->column( '20rem'
                )->text( 'Color' )->get_parent(
            )->column(
                )->text( 'Description'
        )->get_parent( )->get_parent(
        )->items(
            )->column_list_item( selected = '{SELKZ}'
                )->cells(
                    )->text( '{VALUE}'
                    )->text( '{DESCR}'
      )->get_parent( )->get_parent( )->get_parent( )->get_parent(
      )->buttons(
            )->button(
                text  = 'continue'
                press = client->_event( 'POPUP_TABLE_F4_CONTINUE' )
                type  = 'Emphasized' ).
    client->popup_display( popup->stringify( ) ).

  ENDMETHOD.


  METHOD popup_f4_table_custom.

    DATA(popup2) = z2ui5_cl_xml_view=>factory_popup( ).

    popup2 = popup2->dialog( 'abap2UI5 - F4 Value Help' ).

    popup2->simple_form(
        )->label( 'Location'
        )->input(
                value           = client->_bind_edit( screen-city )
                suggestionitems = client->_bind( mt_suggestion_city )
                showsuggestion  = abap_true )->get(
            )->suggestion_items( )->get(
                )->list_item(
                    text           = '{VALUE}'
                    additionaltext = '{DESCR}'
        )->get_parent( )->get_parent(
        )->button(
            text  = 'search...'
            press = client->_event( 'SEARCH' ) ).

    DATA(tab) = popup2->table(
        headertext = 'Employees'
        mode       = 'SingleSelectLeft'
        items      = client->_bind_edit( mt_employees_sel ) ).

    tab->columns(
        )->column( '10rem'
            )->text( 'City' )->get_parent(
        )->column( '10rem'
            )->text( 'Nr' )->get_parent(
        )->column( '15rem'
            )->text( 'Name' )->get_parent(
        )->column( '30rem'
            )->text( 'Lastname' )->get_parent( ).

    tab->items( )->column_list_item( selected = '{SELKZ}'
        )->cells(
            )->text( '{CITY}'
            )->text( '{NR}'
            )->text( '{NAME}'
            )->text( '{LASTNAME}' ).

    popup2->buttons(
                )->button(
                    text  = 'continue'
                    press = client->_event( 'POPUP_TABLE_F4_CUSTOM_CONTINUE' )
                    type  = 'Emphasized' ).
    client->popup_display( popup2->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    CLEAR mv_view_popup.

    IF client->check_on_init( ).
      z2ui5_on_init( ).
    ENDIF.
    z2ui5_on_event( client ).

    z2ui5_on_rendering( client ).

  ENDMETHOD.


  METHOD z2ui5_on_event.

    CASE client->get( )-event.

      WHEN 'POPUP_TABLE_F4'.
        mt_suggestion_sel = mt_suggestion.
        popup_f4_table( client ).

      WHEN 'POPUP_TABLE_F4_CUSTOM'.
        mt_employees_sel = VALUE #( ).
        mt_employees_sel = VALUE #( ).
        popup_f4_table_custom( client ).

      WHEN 'SEARCH'.
        mt_employees_sel = mt_employees.
        IF screen-city IS NOT INITIAL.
          DELETE mt_employees_sel WHERE city <> screen-city.
        ENDIF.
        popup_f4_table_custom( client ).

      WHEN 'POPUP_TABLE_F4_CUSTOM_CONTINUE'.
        DELETE mt_employees_sel WHERE selkz = abap_false.
        IF lines( mt_employees_sel ) = 1.
          screen-name = mt_employees_sel[ 1 ]-name.
          screen-lastname = mt_employees_sel[ 1 ]-lastname.
          client->message_toast_display( 'f4 value selected' ).
          client->popup_destroy( ).
        ENDIF.

      WHEN 'POPUP_TABLE_F4_CONTINUE'.
        DELETE mt_suggestion_sel WHERE selkz = abap_false.
        IF lines( mt_suggestion_sel ) = 1.
          screen-color_02 = mt_suggestion_sel[ 1 ]-value.
          client->message_toast_display( 'f4 value selected' ).
          client->popup_destroy( ).
        ENDIF.

      WHEN 'BUTTON_SEND'.
        client->message_box_display( 'success - values send to the server' ).
      WHEN 'BUTTON_CLEAR'.
        CLEAR screen.
        client->message_box_display( 'View initialized' ).
      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.


  METHOD z2ui5_on_init.

    mt_suggestion = VALUE #(
        ( descr = 'this is the color Green'  value = 'GREEN' )
        ( descr = 'this is the color Blue'   value = 'BLUE' )
        ( descr = 'this is the color Black'  value = 'BLACK' )
        ( descr = 'this is the color Grey'   value = 'GREY' )
        ( descr = 'this is the color Blue2'  value = 'BLUE2' )
        ( descr = 'this is the color Blue3'  value = 'BLUE3' ) ).

    mt_suggestion_city = VALUE #(
        ( value = 'London' descr = 'London' )
        ( value = 'Paris' descr = 'Paris' )
        ( value = 'Rome' descr = 'Rome' ) ).

    mt_employees = VALUE #(
        ( city = 'London' name = 'Tom'       lastname = 'lastname1' nr = '00001' )
        ( city = 'London' name = 'Tom2'      lastname = 'lastname2' nr = '00002' )
        ( city = 'London' name = 'Tom3'      lastname = 'lastname3' nr = '00003' )
        ( city = 'London' name = 'Tom4'      lastname = 'lastname4' nr = '00004' )
        ( city = 'Rome'   name = 'Michaela1' lastname = 'lastname5' nr = '00005' )
        ( city = 'Rome'   name = 'Michaela2' lastname = 'lastname6' nr = '00006' )
        ( city = 'Rome'   name = 'Michaela3' lastname = 'lastname7' nr = '00007' )
        ( city = 'Rome'   name = 'Michaela4' lastname = 'lastname8' nr = '00008' )
        ( city = 'Paris'  name = 'Hermine1'  lastname = 'lastname9' nr = '00009' )
        ( city = 'Paris'  name = 'Hermine2'  lastname = 'lastname10' nr = '00010' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' )
        ( city = 'Paris'  name = 'Hermine3'  lastname = 'lastname11' nr = '00011' ) ).

  ENDMETHOD.


  METHOD z2ui5_on_rendering.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = view->shell(
        )->page(
            title          = 'abap2UI5 - Value Help Examples'
            navbuttonpress = client->_event( 'BACK' )
            shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).

    DATA(form) = page->grid( 'L7 M7 S7'
        )->content( 'layout'
            )->simple_form( 'Input with Value Help'
                )->content( 'form' ).

    form->label( 'Input with sugestion items'
        )->input(
            value           = client->_bind_edit( screen-color_01 )
            placeholder     = 'fill in your favorite colour'
            suggestionitems = client->_bind( mt_suggestion )
            showsuggestion  = abap_true )->get(
            )->suggestion_items( )->get(
                )->list_item(
                    text           = '{VALUE}'
                    additionaltext = '{DESCR}' ).

    form->label( 'Input only numbers allowed'
        )->input(
            value       = client->_bind_edit( screen-quantity )
            type        = 'Number'
            placeholder = 'quantity' ).

    form->label( 'Input with F4'
        )->input(
            value            = client->_bind_edit( screen-color_02 )
            placeholder      = 'fill in your favorite colour'
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( 'POPUP_TABLE_F4' ) ).

    form->label( 'Custom F4 Popup'
        )->input(
            value            = client->_bind_edit( screen-name )
            placeholder      = 'name'
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( 'POPUP_TABLE_F4_CUSTOM' )
        )->input(
            value            = client->_bind_edit( screen-lastname )
            placeholder      = 'lastname'
            showvaluehelp    = abap_true
            valuehelprequest = client->_event( 'POPUP_TABLE_F4_CUSTOM' ) ).

    page->footer(
        )->overflow_toolbar(
            )->toolbar_spacer(
            )->button(
                text    = 'Clear'
                press   = client->_event( 'BUTTON_CLEAR' )
                type    = 'Reject'
                enabled = abap_false
                icon    = 'sap-icon://delete'
            )->button(
                text    = 'Send to Server'
                press   = client->_event( 'BUTTON_SEND' )
                enabled = abap_false
                type    = 'Success' ).



    CASE mv_view_popup.

      WHEN 'POPUP_TABLE_F4'.

        popup_f4_table( client ).

      WHEN 'POPUP_TABLE_F4_CUSTOM'.

        popup_f4_table_custom( client ).

    ENDCASE.

    client->view_display( page->stringify( ) ).


  ENDMETHOD.
ENDCLASS.
