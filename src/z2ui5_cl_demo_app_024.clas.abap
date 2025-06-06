CLASS z2ui5_cl_demo_app_024 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    DATA mv_input TYPE string.
    DATA mv_input2 TYPE string.
    DATA mv_backend_event TYPE string.

  PROTECTED SECTION.

    METHODS display_view
      IMPORTING
        client TYPE REF TO z2ui5_if_client.

  PRIVATE SECTION.
ENDCLASS.



CLASS z2ui5_cl_demo_app_024 IMPLEMENTATION.


  METHOD display_view.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).
    view->shell(
        )->page( title = 'abap2UI5 - flow logic - APP 01'
        navbuttonpress = client->_event( val = 'BACK' )
        shownavbutton  = xsdbool( client->get( )-s_draft-id_prev_app_stack IS NOT INITIAL )
       )->grid( 'L6 M12 S12' )->content( 'layout'
       )->simple_form( 'Controller' )->content( 'form'
      )->label( 'Demo'
         )->button( text  = 'call new app (first View)'
                    press = client->_event( 'CALL_NEW_APP' )
         )->label( 'Demo'
         )->button( text  = 'call new app (second View)'
                    press = client->_event( 'CALL_NEW_APP_VIEW' )
         )->label( 'Demo'
         )->button( text  = 'call new app (set Event)'
                    press = client->_event( 'CALL_NEW_APP_EVENT' )
         )->label( 'Demo'
         )->input( client->_bind_edit( mv_input )
         )->button( text  = 'call new app (set data)'
                    press = client->_event( 'CALL_NEW_APP_READ' )
              )->label( 'some data, you can read in the next app'
         )->input( client->_bind_edit( mv_input2 ) ).

    client->view_display( view->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    IF client->check_on_navigated( ).
      display_view( client ).
      IF mv_backend_event = 'CALL_PREVIOUS_APP_INPUT_RETURN'.
        DATA(lo_called_app) = CAST z2ui5_cl_demo_app_025( client->get_app_prev( ) ).
        CLEAR mv_backend_event.
        client->message_box_display( `Input made in the previous app:` && lo_called_app->mv_input ).
      ENDIF.
      RETURN.
    ENDIF.

    CASE client->get( )-event.

      WHEN 'CALL_NEW_APP'.
        client->nav_app_call( NEW z2ui5_cl_demo_app_025( ) ).

      WHEN 'CALL_NEW_APP_VIEW'.
        DATA(lo_app) = NEW z2ui5_cl_demo_app_025( ).
        lo_app->mv_show_view = 'SECOND'.
        client->nav_app_call( lo_app ).

      WHEN 'CALL_NEW_APP_READ'.
        DATA(lo_app_next) = NEW z2ui5_cl_demo_app_025( ).
        lo_app_next->mv_input_previous_set = mv_input.
        client->nav_app_call( lo_app_next ).

      WHEN 'CALL_NEW_APP_EVENT'.
        lo_app_next = NEW z2ui5_cl_demo_app_025( ).
        lo_app_next->mv_event_backend = 'NEW_APP_EVENT'.
        client->nav_app_call( lo_app_next ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
