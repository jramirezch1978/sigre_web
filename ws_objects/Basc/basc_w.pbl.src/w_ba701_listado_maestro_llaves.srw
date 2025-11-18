$PBExportHeader$w_ba701_listado_maestro_llaves.srw
forward
global type w_ba701_listado_maestro_llaves from w_report_smpl
end type
end forward

global type w_ba701_listado_maestro_llaves from w_report_smpl
integer width = 2853
integer height = 1203
string title = "(BA701) Listado Maestro de Llaves"
string menuname = "m_reporte"
end type
global w_ba701_listado_maestro_llaves w_ba701_listado_maestro_llaves

type variables

end variables

on w_ba701_listado_maestro_llaves.create
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
end on

on w_ba701_listado_maestro_llaves.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_report.insertrow(0)
dw_report.object.t_titulobasc1.text = 'LISTADO  MAESTRO DE LLAVES'
dw_report.object.t_titulobasc2.text = ''
dw_report.object.t_codigobasc.text = 'CANT.FO.06.2'
dw_report.object.t_versionbasc.text = 'VERSIÓN: 00'
dw_report.object.t_usuario.text = UPPER(GS_USER)
dw_report.object.p_logo.filename = gs_logo
end event

event ue_open_pre;call super::ue_open_pre;post event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_ba701_listado_maestro_llaves
integer x = 37
integer y = 32
integer width = 2747
integer height = 963
string dataobject = "d_rpt_basc_listado_maestro_llaves_1_1"
end type

