$PBExportHeader$n_cst_menu_dinamico.sru
$PBExportComments$Funciones para Modificar dinamicamente Menu
forward
global type n_cst_menu_dinamico from nonvisualobject
end type
end forward

global type n_cst_menu_dinamico from nonvisualobject
end type
global n_cst_menu_dinamico n_cst_menu_dinamico

forward prototypes
public subroutine of_set_menu (menu am_menu, datastore ads_datastore)
public subroutine of_get_perfil_menuop (ref datastore ads_opciones, string as_perfil, string as_menu)
public subroutine of_get_perfil_winop (ref datastore ads_opciones, string as_perfil, string as_menu, string as_window)
end prototypes

public subroutine of_set_menu (menu am_menu, datastore ads_datastore);Long		ll_total, ll_row, ll_x
Integer	li_nivel, li_n1, li_n2, li_n3, li_n4, li_n5, li_n6
Boolean	lb_enabled, lb_toolbar
Menu		lm_1, lm_menu

lm_1 = am_menu
ll_total = ads_datastore.RowCount()

For ll_x = 1 to ll_total
	li_nivel = ads_datastore.GetItemNumber(ll_x, 'niveles')
	IF ads_datastore.GetItemString(ll_x, 'enabled') = '1' THEN
		lb_enabled = TRUE
	ELSE
		lb_enabled = FALSE
	END IF
	IF ads_datastore.GetItemString(ll_x, 'toolbar') = '1' THEN
		lb_toolbar = TRUE
	ELSE
		lb_toolbar = FALSE
	END IF
	li_n1 = ads_datastore.GetItemNumber(ll_x, 'n1')	
	CHOOSE CASE li_nivel
		CASE 1
			lm_1.Item[li_n1].enabled = lb_enabled
			lm_1.Item[li_n1].toolbaritemvisible = lb_toolbar
		CASE 2
			li_n2 = ads_datastore.GetItemNumber(ll_x, 'n2')
			lm_1.Item[li_n1].Item[li_n2].enabled = lb_enabled
			lm_1.Item[li_n1].Item[li_n2].toolbaritemvisible = lb_toolbar
		CASE 3
			li_n2 = ads_datastore.GetItemNumber(ll_x, 'n2')
			li_n3 = ads_datastore.GetItemNumber(ll_x, 'n3')
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].enabled = lb_enabled
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].toolbaritemvisible = lb_toolbar
		CASE 4
			li_n2 = ads_datastore.GetItemNumber(ll_x, 'n2')
			li_n3 = ads_datastore.GetItemNumber(ll_x, 'n3')
			li_n4 = ads_datastore.GetItemNumber(ll_x, 'n4')
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].enabled = lb_enabled
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].toolbaritemvisible = lb_toolbar
		CASE 5
			li_n2 = ads_datastore.GetItemNumber(ll_x, 'n2')
			li_n3 = ads_datastore.GetItemNumber(ll_x, 'n3')
			li_n4 = ads_datastore.GetItemNumber(ll_x, 'n4')
			li_n5 = ads_datastore.GetItemNumber(ll_x, 'n5')
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].Item[li_n5].enabled = lb_enabled
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].Item[li_n5].toolbaritemvisible = lb_toolbar
		CASE 6
			li_n2 = ads_datastore.GetItemNumber(ll_x, 'n2')
			li_n3 = ads_datastore.GetItemNumber(ll_x, 'n3')
			li_n4 = ads_datastore.GetItemNumber(ll_x, 'n4')
			li_n5 = ads_datastore.GetItemNumber(ll_x, 'n5')
			li_n6 = ads_datastore.GetItemNumber(ll_x, 'n6')
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].Item[li_n5].Item[li_n6].enabled = lb_enabled
			lm_1.Item[li_n1].Item[li_n2].Item[li_n3].Item[li_n4].Item[li_n5].Item[li_n6].toolbaritemvisible = lb_toolbar
	END CHOOSE
NEXT
	

end subroutine

public subroutine of_get_perfil_menuop (ref datastore ads_opciones, string as_perfil, string as_menu);ads_opciones.DataObject = 'd_perfil_menuop_ds'
ads_opciones.SetTransObject(sqlca)

ads_opciones.Retrieve(as_perfil, as_menu)

end subroutine

public subroutine of_get_perfil_winop (ref datastore ads_opciones, string as_perfil, string as_menu, string as_window);ads_opciones.DataObject = 'd_perfil_winop_ds'
ads_opciones.SetTransObject(sqlca)

ads_opciones.Retrieve(as_perfil, as_window, as_menu)



end subroutine

on n_cst_menu_dinamico.create
TriggerEvent( this, "constructor" )
end on

on n_cst_menu_dinamico.destroy
TriggerEvent( this, "destructor" )
end on

