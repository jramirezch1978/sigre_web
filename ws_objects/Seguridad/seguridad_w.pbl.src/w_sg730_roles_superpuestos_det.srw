$PBExportHeader$w_sg730_roles_superpuestos_det.srw
forward
global type w_sg730_roles_superpuestos_det from w_report_smpl
end type
end forward

global type w_sg730_roles_superpuestos_det from w_report_smpl
integer width = 2363
integer height = 1080
string menuname = "m_rpt_simple"
end type
global w_sg730_roles_superpuestos_det w_sg730_roles_superpuestos_det

on w_sg730_roles_superpuestos_det.create
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
end on

on w_sg730_roles_superpuestos_det.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event open;call super::open;string ls_usuario 
ls_usuario = Message.StringParm
this.title = 'Detalle del objeto ' + ls_usuario + ' (w_sg730_roles_superpuestos_det)'
dw_report.SetTransObject(SQLCA)
dw_report.Retrieve(ls_usuario)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_cod_obj.text = 'SG730D'
idw_1.object.titulo.text = 'Detalle del objeto ' + ls_usuario 
dw_report.Show()

end event

type dw_report from w_report_smpl`dw_report within w_sg730_roles_superpuestos_det
integer x = 0
integer width = 2098
string dataobject = "d_roles_superpuestos_det"
end type

