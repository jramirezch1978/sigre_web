$PBExportHeader$w_sg730_roles_superpuestos.srw
forward
global type w_sg730_roles_superpuestos from w_report_smpl
end type
end forward

global type w_sg730_roles_superpuestos from w_report_smpl
integer width = 2222
integer height = 1116
string title = "Roles super-puestos (w_sg730_roles_superpuestos)"
string menuname = "m_rpt_simple"
end type
global w_sg730_roles_superpuestos w_sg730_roles_superpuestos

type variables

end variables

on w_sg730_roles_superpuestos.create
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
end on

on w_sg730_roles_superpuestos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo

idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_cod_obj.text = 'w_sg730_roles_superpuestos'
end event

event open;call super::open;Event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_sg730_roles_superpuestos
integer x = 0
integer y = 16
string dataobject = "d_roles_superpuestos"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN
string ls_usuario
ls_usuario = dw_report.GetItemString( row, 'grp_obj_objeto')
//messagebox('row', ls_usuario)
opensheetWithParm(w_sg730_roles_superpuestos_det, ls_usuario, w_sg730_roles_superpuestos, 0,layered!)
end event

