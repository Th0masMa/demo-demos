CLASS z2ui5_cl_demo_app_098 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.


    INTERFACES z2ui5_if_app .

    TYPES:
      BEGIN OF ty_row,
        title    TYPE string,
        value    TYPE string,
        descr    TYPE string,
        icon     TYPE string,
        info     TYPE string,
        selected TYPE abap_bool,
        checkbox TYPE abap_bool,
      END OF ty_row .

    DATA
      t_tab TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA
      t_tab2 TYPE STANDARD TABLE OF ty_row WITH EMPTY KEY .
    DATA mv_layout TYPE string .
    DATA mv_title TYPE string .
    DATA check_initialized TYPE abap_bool .
    DATA mv_check_enabled_01 TYPE abap_bool VALUE abap_true.
    DATA mv_check_enabled_02 TYPE abap_bool .
  PROTECTED SECTION.

    DATA client TYPE REF TO z2ui5_if_client.

    METHODS view_display_master.
    METHODS view_display_detail.
    METHODS view_display_detail_detail.

  PRIVATE SECTION.

ENDCLASS.



CLASS Z2UI5_CL_DEMO_APP_098 IMPLEMENTATION.


  METHOD view_display_detail.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view_nested->page( title = `Nested View` ).

    DATA(tab) = page->ui_table( rows               = client->_bind_edit( val = t_tab2 view = client->cs_view-nested )
                                editable           = abap_false
                                alternaterowcolors = abap_true
                                rowactioncount     = '1'
                                enablegrouping     = abap_false
                                fixedcolumncount   = '1'
                                selectionmode      = 'None'
                                sort               = client->_event( 'SORT' )
                                filter             = client->_event( 'FILTER' )
                                customfilter       = client->_event( 'CUSTOMFILTER' ) ).
    tab->ui_extension( )->overflow_toolbar( )->title( text = 'Products' ).
    DATA(lo_columns) = tab->ui_columns( ).

    lo_columns->ui_column( sortproperty                  = 'TITLE'
                                          filterproperty = 'TITLE' )->text( text = `Index` )->ui_template( )->text( text = `{TITLE}` ).
    lo_columns->ui_column( sortproperty   = 'DESCR'
                           filterproperty = 'DESCR' )->text( text = `DESCR` )->ui_template( )->text( text = `{DESCR}` ).
    lo_columns->ui_column( sortproperty   = 'INFO'
                           filterproperty = 'INFO')->text( text = `INFO` )->ui_template( )->text( text = `{INFO}` ).
    lo_columns->get_parent( )->ui_row_action_template( )->ui_row_action(
       )->ui_row_action_item( type = `Navigation` "icon = `sap-icon://navigation-right-arrow`
                           press   = client->_event( val = 'ROW_NAVIGATE' t_arg = VALUE #( ( `${TITLE}` ) ) ) ).

    client->nest_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addMidColumnPage'
      method_destroy = 'removeAllMidColumnPages' ).

  ENDMETHOD.


  METHOD view_display_detail_detail.

    DATA(lo_view_nested) = z2ui5_cl_xml_view=>factory( ).

    DATA(page) = lo_view_nested->page( title = `Nested View` ).

    page = page->text( text = client->_bind( mv_title )
       )->button(
           text  = `frontend event`
           press = client->_event_client( val = client->cs_event-open_new_tab t_arg = VALUE #( ( `https://github.com/abap2UI5/abap2UI5/` ) ) ) ).


    client->nest2_view_display(
      val            = lo_view_nested->stringify( )
      id             = `test`
      method_insert  = 'addEndColumnPage'
      method_destroy = 'removeAllEndColumnPages' ).

  ENDMETHOD.


  METHOD view_display_master.

    DATA(page) = z2ui5_cl_xml_view=>factory(
       )->page(
         showheader       = xsdbool( abap_false = client->get( )-check_launchpad_active )
          title           = 'abap2UI5 - Master Detail Page with Nested View'
          navbuttonpress  = client->_event( 'BACK' )
            shownavbutton = abap_true ).

    page->header_content(
             )->link( text   = 'Demo'
                      target = '_blank'
                      href   = `https://twitter.com/abap2UI5/status/1628701535222865922`
             )->link(
         )->get_parent( ).

    DATA(col_layout) = page->flexible_column_layout( layout = client->_bind_edit( mv_layout )
                                                     id     ='test' ).

    DATA(lr_master) = col_layout->begin_column_pages( ).

    DATA(lr_list) = lr_master->list(
          headertext      = 'List Ouput'
          items           = client->_bind_edit( val = t_tab view = client->cs_view-main )
          mode            = `SingleSelectMaster`
          selectionchange = client->_event( 'SELCHANGE' )
          )->standard_list_item(
              title       = '{TITLE}'
              description = '{DESCR}'
              icon        = '{ICON}'
              info        = '{INFO}'
              press       = client->_event( 'TEST' )
              selected    = `{SELECTED}` ).

    client->view_display( lr_list->stringify( ) ).

  ENDMETHOD.


  METHOD z2ui5_if_app~main.

    me->client = client.

    IF client->check_on_init( ).

      t_tab = VALUE #(
        ( title = 'row_01'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_02'  info = 'incompleted' descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_03'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_04'  info = 'working'     descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_05'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' )
        ( title = 'row_06'  info = 'completed'   descr = 'this is a description' icon = 'sap-icon://account' ) ).

      mv_layout = `OneColumn`.

      view_display_master( ).
      view_display_detail( ).


    ENDIF.

    CASE client->get( )-event.

      WHEN 'ROW_NAVIGATE'.

        IF client->get_event_arg( 1 ) IS NOT INITIAL.
          mv_layout = `ThreeColumnsEndExpanded`.
          mv_title = client->get_event_arg( 1 ).
        ENDIF.

        client->nest_view_model_update( ).
        client->view_model_update( ).
        view_display_detail_detail( ).

      WHEN `SELCHANGE`.
        DATA(lt_sel) = t_tab.
        DELETE lt_sel WHERE selected = abap_false.

        READ TABLE lt_sel INTO DATA(ls_sel) INDEX 1.
        APPEND ls_sel TO t_tab2.

        mv_layout = `TwoColumnsMidExpanded`.

        client->nest_view_model_update( ).
        client->view_model_update( ).

        view_display_detail( ).

      WHEN 'BACK'.
        client->nav_app_leave( ).

    ENDCASE.

  ENDMETHOD.
ENDCLASS.
