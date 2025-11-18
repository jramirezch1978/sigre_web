$PBExportHeader$w_cm018_num_proveedor.srw
forward
global type w_cm018_num_proveedor from w_abc_master
end type
end forward

global type w_cm018_num_proveedor from w_abc_master
integer width = 1193
integer height = 468
string title = "Numeradores"
string menuname = "m_logparam"
long backcolor = 67108864
end type
global w_cm018_num_proveedor w_cm018_num_proveedor

on w_cm018_num_proveedor.create
call super::create
if this.MenuName = "m_logparam" then this.MenuID = create m_logparam
end on

on w_cm018_num_proveedor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;//Override
long ll_row

f_centrar(this)

idw_1 = dw_master             // asignar dw corriente

idw_1.SetTransObject(sqlca)
ll_row = idw_1.retrieve('XX')
if ll_row = 0 then
	this.event ue_insert()
else
	idw_1.ii_protect = 1
	idw_1.of_protect( )
end if

end event

event ue_insert;// overwrite
Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_insert_pos;call super::ue_insert_pos;string ls_nombre
idw_1.object.origen[al_row] = gs_origen
idw_1.object.ult_nro[al_row] = 1
select nombre 
	into :ls_nombre 
	from origen 
	where cod_origen = :gs_origen;
idw_1.object.cadena_t.text = gs_origen + '   ' + ls_nombre
end event

type dw_master from w_abc_master`dw_master within w_cm018_num_proveedor
integer width = 1129
integer height = 268
string dataobject = "d_abc_num_proveedor"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event dw_master::constructor;call super::constructor;is_dwform = 'form'
ii_ck[1] = 1
end event

