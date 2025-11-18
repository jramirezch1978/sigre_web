$PBExportHeader$w_cm730_aprobadores_ot.srw
forward
global type w_cm730_aprobadores_ot from w_report_smpl
end type
end forward

global type w_cm730_aprobadores_ot from w_report_smpl
integer height = 1120
string title = "Reporte de Aprobadores de OT (CM730)"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_cm730_aprobadores_ot w_cm730_aprobadores_ot

on w_cm730_aprobadores_ot.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_cm730_aprobadores_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;This.Event ue_retrieve()


dw_report.Object.Datawindow.Print.Orientation = 1    
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_objeto.text = 'CM730'

end event

type dw_report from w_report_smpl`dw_report within w_cm730_aprobadores_ot
string dataobject = "d_ot_aprobaciones_usuarios_tbl"
end type

