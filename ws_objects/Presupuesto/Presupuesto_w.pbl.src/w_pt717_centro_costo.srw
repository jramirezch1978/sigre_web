$PBExportHeader$w_pt717_centro_costo.srw
forward
global type w_pt717_centro_costo from w_report_smpl
end type
end forward

global type w_pt717_centro_costo from w_report_smpl
integer width = 2094
integer height = 1608
string title = "Centros de Costo (PT717)"
string menuname = "m_impresion"
long backcolor = 67108864
end type
global w_pt717_centro_costo w_pt717_centro_costo

on w_pt717_centro_costo.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_pt717_centro_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;This.Event ue_retrieve()
end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve(gs_empresa)
idw_1.Object.p_logo.filename 	= gs_logo
idw_1.Object.t_empresa.text 	= gs_empresa
idw_1.Object.t_objeto.text 	= this.classname( )
idw_1.Object.t_usuario.text 	= gs_user

idw_1.object.Datawindow.Print.Orientation = 2
idw_1.object.Datawindow.Print.Paper.Size = 9
end event

type dw_report from w_report_smpl`dw_report within w_pt717_centro_costo
integer x = 0
integer y = 0
integer width = 1993
integer height = 1348
string dataobject = "d_rpt_centros_costos"
end type

