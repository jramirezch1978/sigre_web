$PBExportHeader$w_rh242_permiso_papeleta_impresion.srw
forward
global type w_rh242_permiso_papeleta_impresion from w_report_smpl
end type
end forward

global type w_rh242_permiso_papeleta_impresion from w_report_smpl
integer x = 5
integer y = 4
integer width = 3277
integer height = 1219
string title = "(RH242) Papeleta de Permiso"
string menuname = "m_impresion"
end type
global w_rh242_permiso_papeleta_impresion w_rh242_permiso_papeleta_impresion

type variables
str_parametros istr_parametros
end variables

on w_rh242_permiso_papeleta_impresion.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rh242_permiso_papeleta_impresion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.RETRIEVE( istr_parametros.string1 )
dw_report.object.t_titulobasc1.text = 'PAPELETA DE SALIDA DE PERSONAL'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.09.4'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = upper(gs_user)
dw_report.object.p_logo.filename = gs_logo
end event

event open;call super::open;if isvalid(message.powerobjectparm) then
	istr_parametros = message.powerobjectparm
else
	post close(this)
end if
end event

event ue_open_pre;call super::ue_open_pre;event post ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_rh242_permiso_papeleta_impresion
integer x = 29
integer y = 26
integer width = 3193
integer height = 1027
integer taborder = 30
string dataobject = "d_abc_papeleta_permiso_impresion"
end type

