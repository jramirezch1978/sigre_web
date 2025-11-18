$PBExportHeader$w_al713_articulo.srw
forward
global type w_al713_articulo from w_report_smpl
end type
end forward

global type w_al713_articulo from w_report_smpl
integer width = 2967
integer height = 1544
string title = "Rpt Articulos (AL713)"
string menuname = "m_impresion"
long backcolor = 12632256
end type
global w_al713_articulo w_al713_articulo

on w_al713_articulo.create
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
end on

on w_al713_articulo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;// Reposición parametros

idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_objeto.text = 'AL713'
idw_1.object.t_user.text = gs_user
end event

event ue_open_pre;call super::ue_open_pre;

This.Event ue_retrieve()

IF UPPER(gs_lpp) = 'S' THEN THIS.EVENT ue_set_retrieve_as_needed('S')

idw_1.Visible = True
end event

type dw_report from w_report_smpl`dw_report within w_al713_articulo
integer x = 9
integer y = 8
integer width = 2875
integer height = 1304
string dataobject = "d_rpt_articulo_tbl"
end type

