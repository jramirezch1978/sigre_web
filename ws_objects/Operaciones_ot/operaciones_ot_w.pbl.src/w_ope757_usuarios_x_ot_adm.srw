$PBExportHeader$w_ope757_usuarios_x_ot_adm.srw
forward
global type w_ope757_usuarios_x_ot_adm from w_report_smpl
end type
end forward

global type w_ope757_usuarios_x_ot_adm from w_report_smpl
integer width = 3214
integer height = 1548
string title = "(OPE757) Administraciones de OT y usuarios anexados"
string menuname = "m_rpt_smpl"
long backcolor = 10789024
end type
global w_ope757_usuarios_x_ot_adm w_ope757_usuarios_x_ot_adm

on w_ope757_usuarios_x_ot_adm.create
call super::create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
end on

on w_ope757_usuarios_x_ot_adm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Visible = True
This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;dw_report.retrieve()

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_user.text = gs_user
dw_report.object.t_empresa.text = gs_empresa
dw_report.object.t_objeto.text = 'OPE757'
end event

event ue_preview;call super::ue_preview;idw_1.Modify("datawindow.print.preview.zoom = " + String(100))
end event

type dw_report from w_report_smpl`dw_report within w_ope757_usuarios_x_ot_adm
integer x = 37
integer y = 28
integer width = 3109
integer height = 1284
string dataobject = "d_rpt_usuario_x_ot_adm_tbl"
end type

