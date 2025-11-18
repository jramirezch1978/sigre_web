$PBExportHeader$w_cm018_num_proveedor.srw
forward
global type w_cm018_num_proveedor from w_abc_master
end type
end forward

global type w_cm018_num_proveedor from w_abc_master
integer width = 1861
integer height = 996
string title = "[CM018] Numerador de proveedores"
string menuname = "m_save_exit"
long backcolor = 1073741824
end type
global w_cm018_num_proveedor w_cm018_num_proveedor

on w_cm018_num_proveedor.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
end on

on w_cm018_num_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;//Override
long ll_row

//f_centrar(this)

idw_1 = dw_master             // asignar dw corriente

idw_1.SetTransObject(sqlca)
ll_row = idw_1.retrieve('XX')
if ll_row = 0 then
	this.event ue_insert()
else
	idw_1.ii_protect = 1
	idw_1.of_protect( )
end if

is_tabla = dw_master.Object.Datawindow.Table.UpdateTable  //Nombre de tabla a grabar en el Log Diario

end event

event ue_insert;// overwrite
Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

type p_pie from w_abc_master`p_pie within w_cm018_num_proveedor
end type

type ole_skin from w_abc_master`ole_skin within w_cm018_num_proveedor
end type

type uo_h from w_abc_master`uo_h within w_cm018_num_proveedor
boolean visible = false
boolean enabled = false
end type

type st_box from w_abc_master`st_box within w_cm018_num_proveedor
boolean visible = false
end type

type phl_logonps from w_abc_master`phl_logonps within w_cm018_num_proveedor
end type

type p_mundi from w_abc_master`p_mundi within w_cm018_num_proveedor
end type

type p_logo from w_abc_master`p_logo within w_cm018_num_proveedor
end type

type st_filter from w_abc_master`st_filter within w_cm018_num_proveedor
boolean visible = false
boolean enabled = false
end type

type uo_filter from w_abc_master`uo_filter within w_cm018_num_proveedor
boolean visible = false
boolean enabled = false
end type

type dw_master from w_abc_master`dw_master within w_cm018_num_proveedor
integer x = 521
integer y = 276
integer width = 1129
integer height = 268
string dataobject = "d_abc_num_proveedor"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen [al_row] = 'XX'
end event

