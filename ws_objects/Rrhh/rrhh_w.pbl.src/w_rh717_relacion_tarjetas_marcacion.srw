$PBExportHeader$w_rh717_relacion_tarjetas_marcacion.srw
forward
global type w_rh717_relacion_tarjetas_marcacion from w_report_smpl
end type
end forward

global type w_rh717_relacion_tarjetas_marcacion from w_report_smpl
integer width = 2802
integer height = 1244
string title = "[RH717] Relacion de tarjetas de marcación"
string menuname = "m_impresion"
end type
global w_rh717_relacion_tarjetas_marcacion w_rh717_relacion_tarjetas_marcacion

on w_rh717_relacion_tarjetas_marcacion.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_rh717_relacion_tarjetas_marcacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()
idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.Object.t_user.text = gs_user
idw_1.Object.t_texto.text = 'Al ' + STRING(today(), 'dd/mm/yyyy')


end event

event ue_open_pre;call super::ue_open_pre;IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

This.Event ue_retrieve()

// ii_help = 101           // help topic
//dw_report.Object.Datawindow.Print.Orientation = 1    // 0=default,1=Landscape, 2=Portrait
end event

type dw_report from w_report_smpl`dw_report within w_rh717_relacion_tarjetas_marcacion
integer x = 0
integer y = 0
integer width = 2766
integer height = 844
string dataobject = "d_rpt_asignacion_tarjeta_grd"
end type

