$PBExportHeader$w_rh006_num_solicitud.srw
forward
global type w_rh006_num_solicitud from w_abc_master_smpl
end type
end forward

global type w_rh006_num_solicitud from w_abc_master_smpl
integer width = 1472
integer height = 792
string title = "(RH006) Ultimo Número de la Solicitud"
string menuname = "m_modifica_graba"
end type
global w_rh006_num_solicitud w_rh006_num_solicitud

on w_rh006_num_solicitud.create
call super::create
if this.MenuName = "m_modifica_graba" then this.MenuID = create m_modifica_graba
end on

on w_rh006_num_solicitud.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)


end event

event ue_update_pre;call super::ue_update_pre;string  ls_llave
integer ln_nro_activo, li_row
li_row = dw_master.GetRow()

if li_row > 0 then
	ls_llave = string(dw_master.GetItemString(li_row,"cod_origen"))
	if isnull(ls_llave) or ls_llave = ' ' then
		dw_master.ii_update = 0
		messagebox("Validación","Ingrese origen del registro")
		dw_master.SetColumn("cod_origen")
		dw_master.SetFocus()
		return
	end if
	ln_nro_activo = dw_master.GetItemNumber(li_row,"ult_nro")
	if isnull(ln_nro_activo) then
		dw_master.ii_update = 0
		messagebox("Validación","Ingrese número inicial igual a cero")
		dw_master.SetColumn("ult_nro")
		dw_master.SetFocus()
		return
	end if
else
	return 
end if

end event

event ue_modify;call super::ue_modify;string ls_protect
ls_protect = dw_master.describe("cod_origen.protect")
if ls_protect = '0' then
   dw_master.of_column_protect('cod_origen')
end if
ls_protect = dw_master.describe("ult_nro.protect")
if ls_protect = '0' then
   dw_master.of_column_protect('ult_nro')
end if

end event

event ue_insert;call super::ue_insert;// Control para insertar un solo registro

integer ln_contador
select count(cod_origen)
  into :ln_contador
  from num_rrhh_credito_sol
  where cod_origen = :gs_origen ;

if ln_contador = 1 then
 	dw_master.deleterow(0) 
	dw_master.ii_update=0
	messagebox("Sistema de Seguridad","No es posible insertar un nuevo registro")
end if

end event

event resize;// Override
end event

event open;call super::open;//dw_master.settransobject(sqlca)
//dw_master.retrieve(gs_origen)
//messagebox('hola',gs_origen)
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh006_num_solicitud
integer x = 55
integer y = 48
integer width = 1317
integer height = 508
boolean enabled = false
string dataobject = "d_nro_solicitud_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.modify("cod_origen.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.modify("ult_nro.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemchanged;call super::itemchanged;string ls_reckey
choose case dwo.name 
	case 'cod_origen'
		ls_reckey = trim(dw_master.GetText())
		if ls_reckey = ' ' then
			messagebox("Validación","Ingrese origen del registro")
			dw_master.SetColumn("cod_origen")
			dw_master.SetFocus()
			return 1
		End if 
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	// Columna de lectrua de este datawindows
end event

event dw_master::clicked;call super::clicked;// Override
end event

