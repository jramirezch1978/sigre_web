$PBExportHeader$w_pt001_partida_titulos.srw
forward
global type w_pt001_partida_titulos from w_abc_mid
end type
end forward

global type w_pt001_partida_titulos from w_abc_mid
integer width = 3470
integer height = 992
string title = "Cuentas Presupuestales - Titulo"
string menuname = "m_mantenimiento_sl"
end type
global w_pt001_partida_titulos w_pt001_partida_titulos

on w_pt001_partida_titulos.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_pt001_partida_titulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
dw_master.height  = newheight - dw_master.y - 10
dw_detmast.height  = newheight - dw_detmast.y - 10
dw_detail.height  = newheight - dw_detail.y - 10
end event

event ue_open_pre();call super::ue_open_pre;// carga datos

dwobject dwo

dw_master.retrieve()
//dw_master.event clicked(0,0,1,dwo)

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
end event

type dw_master from w_abc_mid`dw_master within w_pt001_partida_titulos
integer x = 18
integer width = 1175
integer height = 372
string dataobject = "d_abc_presupuesto_cuenta_n1"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1	
ii_dk[1] = 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::clicked;call super::clicked;// Al hacer click traer datos de detalle
f_select_current_row(this)     // Selecciona fila 
if row > 0 then
	dw_detmast.retrieve(this.object.niv1[row])
	il_row = row
end if
end event

type dw_detail from w_abc_mid`dw_detail within w_pt001_partida_titulos
integer x = 2395
integer y = 16
integer width = 1175
integer height = 372
string dataobject = "d_abc_presupuesto_cuenta_n3"
boolean hscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2

ii_ss = 1
end event

type dw_detmast from w_abc_mid`dw_detmast within w_pt001_partida_titulos
integer x = 1207
integer y = 16
integer width = 1175
integer height = 372
string dataobject = "d_abc_presupuesto_cuenta_n2"
end type

event dw_detmast::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

ii_ss = 1
end event

event dw_detmast::clicked;call super::clicked;// Override
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

// Al hacer click traer datos de detalle
f_select_current_row(this)     // Selecciona fila 
if row > 0 then
	dw_detail.retrieve(this.object.niv1[row], this.object.niv2[row])
	il_row = row
end if
end event

