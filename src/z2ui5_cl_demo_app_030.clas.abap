CLASS z2ui5_cl_demo_app_030 DEFINITION PUBLIC.

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app.

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        checkbox TYPE abap_bool,
      END OF ty_row.


    DATA t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_030 IMPLEMENTATION.


  METHOD z2ui5_if_app~main.

    IF client->check_on_init( ).

      t_tab = VALUE #(
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'incompleted' descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
            ( title = 'Peter'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' ) ).

    ENDIF.


    CASE client->get( )-event.

      WHEN 'BUTTON_ROUNDTRIP'.
        DATA(lv_dummy) = 'user pressed a button, your custom implementation can be called here'.

      WHEN 'BUTTON_MSG_BOX'.
        client->message_box_display(
          text = 'this is a message box with a custom text'
          type = 'success' ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).


    DATA(page) = view->dynamic_page(
        showfooter = abap_true
       "  headerExpanded = abap_true
      "   toggleHeaderOnTitleClick = client->_event( 'ON_TITLE' )
      ).


    DATA(header_title) = page->title( ns = 'f' )->get( )->dynamic_page_title( ).

    header_title->heading( ns = 'f' )->title( 'Header Title' ).

    header_title->expanded_content( 'f'
             )->label( text = 'this is a subheading' ).

    header_title->snapped_content( ns = 'f'
             )->label( text = 'this is a subheading' ).

    header_title->actions( ns = 'f' )->overflow_toolbar(
         )->overflow_toolbar_button(
             icon    = `sap-icon://edit`
             text    = 'edit header'
             type    = 'Emphasized'
             tooltip = 'edit'
         )->overflow_toolbar_button(
             icon    = `sap-icon://pull-down`
             text    = 'show section'
             type    = 'Emphasized'
             tooltip = 'pull-down'
         )->overflow_toolbar_button(
             icon    = `sap-icon://show`
             text    = 'show state'
             tooltip = 'show'
         )->button(
            " icon = `sap-icon://edit`
             text  = 'Go Back'
             press = client->_event( 'BACK' ) ).

    header_title->navigation_actions(
            )->button( icon = 'sap-icon://full-screen'
                       type = 'Transparent'
            )->button( icon = 'sap-icon://exit-full-screen'
                       type = 'Transparent'
            )->button( icon = 'sap-icon://decline'
                       type = 'Transparent' ).

    page->header( )->dynamic_page_header( pinnable = abap_true
        )->horizontal_layout(
            )->vertical_layout(
                   )->object_attribute( title = 'Location'
                                        text  = 'Warehouse A'
                   )->object_attribute( title = 'Halway'
                                        text  = '23L'
                   )->object_attribute( title = 'Rack'
                                        text  = '34'
             )->get_parent(
               )->vertical_layout(
                    )->object_attribute( title = 'Location'
                                         text  = 'Warehouse A'
                    )->object_attribute( title = 'Halway'
                                         text  = '23L'
                    )->object_attribute( title = 'Rack'
                                         text  = '34'
             )->get_parent(
              )->vertical_layout(
                   )->object_attribute( title = 'Location'
                                        text  = 'Warehouse A'
                   )->object_attribute( title = 'Halway'
                                        text  = '23L'
                   )->object_attribute( title = 'Rack'
                                        text  = '34' ).


    DATA(cont) = page->content( ns = 'f' ).

    cont->list(
         headertext = 'List Ouput'
         items      = client->_bind( t_tab )
         )->standard_list_item(
             title       = '{TITLE}'
             description = '{DESCR}'
             icon        = '{ICON}'
             info        = '{INFO}' ).


    page->footer( ns = `f` )->overflow_toolbar(
             )->overflow_toolbar_button(
                 icon    = `sap-icon://edit`
                 text    = 'edit header'
                 type    = 'Emphasized'
                 tooltip = 'edit'
             )->overflow_toolbar_button(
                 icon    = `sap-icon://pull-down`
                 text    = 'show section'
                 type    = 'Emphasized'
                 tooltip = 'pull-down' ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.
ENDCLASS.
