$PBExportHeader$w_ba705_control_vehiculo_carga_ficha.srw
forward
global type w_ba705_control_vehiculo_carga_ficha from w_report_smpl
end type
end forward

global type w_ba705_control_vehiculo_carga_ficha from w_report_smpl
integer width = 2838
integer height = 1139
string title = "(BA705) Ficha de Control de Vehiculos de Carga"
string menuname = "m_reporte"
end type
global w_ba705_control_vehiculo_carga_ficha w_ba705_control_vehiculo_carga_ficha

type variables

end variables

on w_ba705_control_vehiculo_carga_ficha.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_ba705_control_vehiculo_carga_ficha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.insertrow(0)
dw_report.object.t_titulobasc1.text = 'FICHA CONTROL VEHICULOS DE CARGA'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.09.5'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

event ue_open_pre;call super::ue_open_pre;post event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_ba705_control_vehiculo_carga_ficha
integer x = 29
integer y = 26
integer width = 2754
integer height = 950
string dataobject = "d_rpt_control_vehiculo_carga_ficha"
end type

