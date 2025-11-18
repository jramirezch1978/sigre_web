$PBExportHeader$w_sg740_usu_sis.srw
forward
global type w_sg740_usu_sis from w_report_smpl
end type
type ddlb_1 from dropdownlistbox within w_sg740_usu_sis
end type
end forward

global type w_sg740_usu_sis from w_report_smpl
integer width = 2222
integer height = 1152
string title = "Roles super-puestos (w_sg730_roles_superpuestos)"
string menuname = "m_rpt_simple"
ddlb_1 ddlb_1
end type
global w_sg740_usu_sis w_sg740_usu_sis

type variables

end variables

on w_sg740_usu_sis.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_simple" then this.MenuID = create m_rpt_simple
this.ddlb_1=create ddlb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.ddlb_1
end on

on w_sg740_usu_sis.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.ddlb_1)
end on

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve()
idw_1.Visible = True
idw_1.Object.p_logo.filename = gs_logo

idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user
idw_1.object.t_cod_obj.text = 'w_sg740_usu_sis'
end event

event open;call super::open;Event ue_retrieve()
end event

type dw_report from w_report_smpl`dw_report within w_sg740_usu_sis
integer x = 0
integer y = 16
integer width = 2030
integer height = 928
string dataobject = "d_usu_sis"
end type

event dw_report::doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN
string ls_usuario
ls_usuario = dw_report.GetItemString( row, 'usuario')
//messagebox('row', ls_usuario)
opensheetWithParm(w_sg740_usu_sis_det, ls_usuario, w_sg740_usu_sis, 0,layered!)




//string ls_columna, ls_titulo, ls_name_titulo, ls_comando
//Long ll_pos
//
//ls_columna = dwo.name
//messagebox('row', ls_columna)
//
//// THIS.Describe(+'acceso_t'+'.text')
//ls_name_titulo = this.describe("DataWindow.Crosstab.Columns")
//messagebox('titulo',ls_name_titulo)
//
//
end event

type ddlb_1 from dropdownlistbox within w_sg740_usu_sis
integer x = 1655
integer y = 60
integer width = 480
integer height = 400
integer taborder = 30
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string item[] = {"CN","LM","SC","SP","*"}
borderstyle borderstyle = stylelowered!
end type

