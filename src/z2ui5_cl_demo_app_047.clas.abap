CLASS z2ui5_cl_demo_app_047 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA int1    TYPE i.
    DATA int2    TYPE i.
    DATA int_sum TYPE i.

    DATA dec1    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec2    TYPE p LENGTH 10 DECIMALS 4.
    DATA dec_sum TYPE p LENGTH 10 DECIMALS 4.

    DATA date    TYPE d.
    DATA time    TYPE t.

    TYPES:
      BEGIN OF ty_s_row,
        date TYPE d,
        time TYPE t,
      END OF ty_s_row.
    DATA mt_tab TYPE STANDARD TABLE OF ty_s_row WITH EMPTY KEY.



  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_047 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).
      date = sy-datum.
      time = sy-uzeit.
      dec1 = - 1 / 3.
      dec2 = 2 / 3.

      mt_tab = VALUE #( ( date = sy-datum time = sy-uzeit ) ).
      client->_bind_edit( mt_tab ).
    ENDIF.

    CASE client->get( )-event.
      WHEN 'BUTTON_INT'.
        int_sum = int1 + int2.
      WHEN 'BUTTON_DEC'.
        dec_sum = dec1 + dec2.
      WHEN 'BACK'.
        client->nav_app_leave( client->get_app( client->get( )-s_draft-id_prev_app_stack ) ).
    ENDCASE.

    DATA(page) = z2ui5_cl_xml_view=>factory( )->shell(
        )->page(
                title          = 'abap2UI5 - Integer and Decimals'
                navbuttonpress = client->_event( 'BACK' )
                shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL ) ).
    page->simple_form( title    = 'Integer and Decimals'
                       editable = abap_true
             )->content( 'form'
                 )->title( 'Input'
                 )->label( 'integer'
                 )->input( value = client->_bind_edit( int1 )
                 )->input( value = client->_bind_edit( int2 )
                 )->input( enabled = abap_false
                           value   = client->_bind_edit( int_sum )
                 )->button( text  = 'calc sum'
                            press = client->_event( 'BUTTON_INT' )
                 )->label( 'decimals'
                 )->input( client->_bind_edit( dec1 )
                 )->input( client->_bind_edit( dec2 )
                 )->input( enabled = abap_false
                           value   = client->_bind_edit( dec_sum )
                 )->button( text  = 'calc sum'
                            press = client->_event( 'BUTTON_DEC' )
                 )->label( 'date'
                 )->input( client->_bind_edit( date )
                 )->label( 'time'
                 )->input( client->_bind_edit( time ) ).

    DATA(tab) = page->scroll_container( height   = '70%'
                                        vertical = abap_true
        )->table(
            growing             = abap_true
            growingthreshold    = '20'
            growingscrolltoload = abap_true
            items               = client->_bind_edit( mt_tab )
            sticky              = 'ColumnHeaders,HeaderToolbar' ).

    tab->columns(
        )->column(
            )->text( 'Date' )->get_parent(
        )->column(
            )->text( 'Time' )->get_parent( ).

    tab->items( )->column_list_item( )->cells(
       )->text( '{DATE}'
       )->text( '{TIME}' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
