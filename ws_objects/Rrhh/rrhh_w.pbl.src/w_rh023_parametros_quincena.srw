$PBExportHeader$w_rh023_parametros_quincena.srw
forward
global type w_rh023_parametros_quincena from w_abc_master_smpl
end type
end forward

global type w_rh023_parametros_quincena from w_abc_master_smpl
integer width = 2313
integer height = 1088
string title = "(RH023) Parámetros de Cálculo de Quincena"
string menuname = "m_master_simple"
end type
global w_rh023_parametros_quincena w_rh023_parametros_quincena

on w_rh023_parametros_quincena.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh023_parametros_quincena.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_insert;call super::ue_insert;// La tabla de parámetros solo debe tener un registro

integer ln_contador
select count(reckey)
  into :ln_contador
  from rrhhparquin ;

if ln_contador = 1 then 
 	dw_master.deleterow(0) 
	dw_master.ii_update=0
	messagebox("Aviso","Solo debe existir un registro en este mantenimiento")
end if 

end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string  ls_concepto, ls_flag_pago
integer li_valor, li_row, li_verifica

li_row = dw_master.GetRow()

if li_row > 0 then 

	ls_concepto = Trim(dw_master.GetItemString(li_row,"cncp_quincena"))
	if isnull(ls_concepto) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_concepto ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Concepto de adelanto de quincena no existe. Verifique")
			dw_master.SetColumn("cncp_quincena")
			dw_master.SetFocus()
			return
		end if	
	end if

	ls_flag_pago = Trim(dw_master.GetItemString(li_row,"flag_pago"))
	if isnull(ls_flag_pago) or ls_flag_pago = '' then
		dw_master.ii_update = 0
		messagebox("Validación","Indicador de pago no debe ser nulo. Verifique")
		dw_master.SetColumn("flag_pago")
		dw_master.SetFocus()
		return
	end if

	li_valor = dw_master.GetItemNumber(li_row,"monto_adelanto")
	if isnull(li_valor) or li_valor = 0.00 then
		dw_master.ii_update = 0
		messagebox("Validación","Valor del adelanto debe ser mayor a cero. Verifique")
		dw_master.SetColumn("monto_adelanto")
		dw_master.SetFocus()
		return
	end if

end if	

dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh023_parametros_quincena
integer width = 2176
integer height = 784
string dataobject = "d_parametros_quincena_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::clicked;// Override
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_reckey
choose case dwo.name 
	case 'reckey'
		ls_reckey = Trim(dw_master.GetText())
		if isnull(ls_reckey) or ls_reckey = ' ' then
			Messagebox("Advertencia","Debe ingresar información en esta columna, es obligatorio")
			dw_master.SetColumn("reckey")
			dw_master.SetFocus()
			return 1
		end if 
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("reckey.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_quincena.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("monto_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("imp_redondeo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_judicial.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_cnta_ahorro.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_diferido.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("dias_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_dscto_fijo.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("porc_ad_dsc_imp_nt.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_replicacion.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"reckey","1")

end event

