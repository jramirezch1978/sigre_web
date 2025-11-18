$PBExportHeader$w_ba301_ingreso_vehicular_ficha.srw
forward
global type w_ba301_ingreso_vehicular_ficha from w_report_smpl
end type
end forward

global type w_ba301_ingreso_vehicular_ficha from w_report_smpl
integer x = 5
integer y = 4
integer width = 2838
integer height = 1139
string title = "(BA301) Ficha de Control de Vehiculos"
string menuname = "m_reporte"
end type
global w_ba301_ingreso_vehicular_ficha w_ba301_ingreso_vehicular_ficha

type variables
str_parametros istr_parametros
end variables

on w_ba301_ingreso_vehicular_ficha.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_ba301_ingreso_vehicular_ficha.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve( istr_parametros.long1 )
dw_report.object.t_titulobasc1.text = 'FICHA CONTROL VEHICULOS'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.09.5'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

event ue_open_pre;call super::ue_open_pre;post event ue_retrieve()
end event

event open;call super::open;if isvalid(message.powerobjectparm) then
	istr_parametros = message.powerobjectparm
else
	post close(this)
end if
end event

type dw_report from w_report_smpl`dw_report within w_ba301_ingreso_vehicular_ficha
integer x = 29
integer y = 26
integer width = 2754
integer height = 950
string dataobject = "d_rpt_control_vehiculo_carga_ficha_full"
end type

