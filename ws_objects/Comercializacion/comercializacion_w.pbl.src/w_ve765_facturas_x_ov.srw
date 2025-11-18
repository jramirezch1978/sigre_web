$PBExportHeader$w_ve765_facturas_x_ov.srw
forward
global type w_ve765_facturas_x_ov from w_report_smpl
end type
end forward

global type w_ve765_facturas_x_ov from w_report_smpl
integer width = 3579
integer height = 1392
string title = "[VE700] Movimientos de Almacen x Mov Proy"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 79741120
end type
global w_ve765_facturas_x_ov w_ve765_facturas_x_ov

type variables
str_parametros istr_param
end variables

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_ve765_facturas_x_ov.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_ve765_facturas_x_ov.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.visible = true
ib_preview=false
this.event ue_preview()
dw_report.SetTransObject( sqlca)
dw_report.retrieve(istr_param.string1, istr_param.number1)	
dw_report.Object.DataWindow.Print.Orientation = 1
dw_report.object.t_user.text 		= gs_user
dw_report.Object.p_logo.filename = gs_logo
	

end event

event ue_open_pre;call super::ue_open_pre;if Not IsValid(Message.PowerObjectparm) or IsNull(Message.Powerobjectparm) then return

if Message.Powerobjectparm.ClassNAme( ) <> 'str_parametros' then return

istr_param = Message.PowerObjectparm

this.event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_ve765_facturas_x_ov
integer x = 0
integer y = 0
integer width = 3442
integer height = 1092
string dataobject = "d_rpt_facturas_x_ov_tbl"
end type

