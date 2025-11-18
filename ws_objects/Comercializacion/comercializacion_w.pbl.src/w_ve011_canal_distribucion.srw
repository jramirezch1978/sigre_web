$PBExportHeader$w_ve011_canal_distribucion.srw
forward
global type w_ve011_canal_distribucion from w_abc_mastdet
end type
end forward

global type w_ve011_canal_distribucion from w_abc_mastdet
integer width = 2231
integer height = 1388
string title = "CANAL DE DISTRIBUCION (VE011)"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
end type
global w_ve011_canal_distribucion w_ve011_canal_distribucion

on w_ve011_canal_distribucion.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve011_canal_distribucion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

of_position_window(50,50)
end event

type dw_master from w_abc_mastdet`dw_master within w_ve011_canal_distribucion
integer x = 37
integer y = 32
integer width = 2121
integer height = 516
string dataobject = "d_abc_canal_distribucion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

is_dwform = 'tabular' // tabular form
ii_ss = 1
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)

idw_det.ScrollToRow(al_row)


end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(aa_id[1])
end event

type dw_detail from w_abc_mastdet`dw_detail within w_ve011_canal_distribucion
integer x = 37
integer y = 576
integer width = 2121
integer height = 548
string dataobject = "d_abc_canal_distribucion_det"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

ii_ss = 1
end event

