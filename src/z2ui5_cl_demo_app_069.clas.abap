CLASS z2ui5_cl_demo_app_069 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_t_tree3,
        is_selected TYPE abap_bool,
        text        TYPE string,
      END OF ty_t_tree3,
      BEGIN OF ty_t_tree2,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree3 WITH DEFAULT KEY,
      END OF ty_t_tree2,
      BEGIN OF ty_t_tree1,
        is_selected TYPE abap_bool,
        text        TYPE string,
        nodes       TYPE STANDARD TABLE OF ty_t_tree2 WITH DEFAULT KEY,
      END OF ty_t_tree1,
      ty_t_tree TYPE STANDARD TABLE OF ty_t_tree1 WITH DEFAULT KEY.

    DATA mt_tree TYPE ty_t_tree.
    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool.

  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_app_01.
    METHODS view_display_app_02.

  PRIVATE SECTION.

ENDCLASS.



CLASS z2ui5_cl_demo_app_069 IMPLEMENTATION.


  METHOD view_display_app_01.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = lo_view_nested->page( title = `APP_01` ).

    page->button( text  = 'Update this view'
                  press = client->_event( 'UPDATE_DETAIL' ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages' ).

  ENDMETHOD.


  METHOD view_display_app_02.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).
    DATA(page) = lo_view_nested->page( title = `APP_02` ).

    page->button( text  = 'Update this view'
                  press = client->_event( 'UPDATE_DETAIL' )
      )->input( ).

    page->button(
          text    = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
          text    = 'button 01'
          press   = client->_event( `NEST_TEST` )
          enabled = client->_bind( mv_check_enabled_01 ) ).

    page->button(
        text    = 'button 02'
        press   = client->_event( `NEST_TEST` )
        enabled = client->_bind( mv_check_enabled_02 ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages' ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA(view) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = view->shell( )->page(
          title          = 'abap2UI5 - Master-Detail View with Nested Views'
          navbuttonpress = client->_event( 'BACK' )
          shownavbutton  = abap_true ).

    DATA(lr_master) = page->flexible_column_layout( layout = 'TwoColumnsBeginExpanded'
                                                    id     ='test' )->begin_column_pages( ).

    lr_master->tree( items = client->_bind( mt_tree ) )->items(
        )->standard_tree_item(
            type  = 'Active'
            title = '{TEXT}'
            press = client->_event( val = `EVENT_ITEM`
                t_arg = VALUE #( ( `${TEXT}` ) )
                 ) ).

    client->view_display( page->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      mt_tree = VALUE #( ( text = 'Apps'
                    nodes       = VALUE #( ( text = 'Frontend'
                                       nodes      = VALUE #( ( text = 'App_001' )
                                                        ( text = 'App_002' )
                  ) ) ) )
                  ( text  = 'Configuration'
                    nodes = VALUE #( ( text  = 'User Interface'
                                       nodes = VALUE #( ( text = 'Theme' )
                                                        ( text = 'Library' )
                                     ) )
                                     ( text  = 'Database'
                                       nodes = VALUE #( ( text = 'HANA' )
                                                         ( text = 'ANY DB' )
         ) ) ) ) ).

      view_display_master( ).

    ENDIF.

    CASE client->get( )-event.

      WHEN `UPDATE_DETAIL`.
        view_display_app_01( ).

      WHEN `EVENT_ITEM`.
        CASE client->get_event_arg( 1 ).
          WHEN 'App_001'.
            view_display_app_01( ).
          WHEN 'App_002'.
            view_display_app_02( ).
        ENDCASE.

      WHEN `NEST_TEST`.
        mv_check_enabled_01 = xsdbool( mv_check_enabled_01 = abap_false ).
        mv_check_enabled_02 = xsdbool( mv_check_enabled_01 = abap_false ).

        client->nest_view_model_update( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).
    ENDCASE.

  ENDMETHOD.
ENDCLASS.
