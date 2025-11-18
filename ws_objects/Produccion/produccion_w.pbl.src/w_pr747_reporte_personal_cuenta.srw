$PBExportHeader$w_pr747_reporte_personal_cuenta.srw
forward
global type w_pr747_reporte_personal_cuenta from w_report_smpl
end type
end forward

global type w_pr747_reporte_personal_cuenta from w_report_smpl
integer width = 3506
integer height = 1636
string title = "(PR740) Etiquetas para Cajas de Productos Terminados"
string menuname = "m_reporte"
long backcolor = 79741120
end type
global w_pr747_reporte_personal_cuenta w_pr747_reporte_personal_cuenta

type variables
string is_codigo
end variables

on w_pr747_reporte_personal_cuenta.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_pr747_reporte_personal_cuenta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve()



end event

event ue_open_pre;call super::ue_open_pre;dw_report.SetTransObject(SQLCA)
this.Event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_pr747_reporte_personal_cuenta
integer x = 0
integer y = 0
integer width = 3451
integer height = 1364
integer taborder = 70
string dataobject = "d_rpt_750_cuentas_cuadrillas"
end type

