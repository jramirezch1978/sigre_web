$PBExportHeader$w_cn740_cp_rpt_formatos.srw
forward
global type w_cn740_cp_rpt_formatos from w_report_smpl
end type
type cb_1 from commandbutton within w_cn740_cp_rpt_formatos
end type
type sle_descripcion from singlelineedit within w_cn740_cp_rpt_formatos
end type
type cb_4 from commandbutton within w_cn740_cp_rpt_formatos
end type
type sle_tipo from singlelineedit within w_cn740_cp_rpt_formatos
end type
type sle_formato from singlelineedit within w_cn740_cp_rpt_formatos
end type
type gb_22 from groupbox within w_cn740_cp_rpt_formatos
end type
end forward

global type w_cn740_cp_rpt_formatos from w_report_smpl
integer width = 3451
integer height = 1508
string title = "Plantillas de Costos de Producción de Azúcar (CN740)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_descripcion sle_descripcion
cb_4 cb_4
sle_tipo sle_tipo
sle_formato sle_formato
gb_22 gb_22
end type
global w_cn740_cp_rpt_formatos w_cn740_cp_rpt_formatos

type variables
String is_opcion

end variables

on w_cn740_cp_rpt_formatos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_descripcion=create sle_descripcion
this.cb_4=create cb_4
this.sle_tipo=create sle_tipo
this.sle_formato=create sle_formato
this.gb_22=create gb_22
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_descripcion
this.Control[iCurrent+3]=this.cb_4
this.Control[iCurrent+4]=this.sle_tipo
this.Control[iCurrent+5]=this.sle_formato
this.Control[iCurrent+6]=this.gb_22
end on

on w_cn740_cp_rpt_formatos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_descripcion)
destroy(this.cb_4)
destroy(this.sle_tipo)
destroy(this.sle_formato)
destroy(this.gb_22)
end on

event ue_retrieve;call super::ue_retrieve;String ls_tipo, ls_formato, ls_descripcion

ls_tipo        = String(sle_tipo.text)
ls_formato     = String(sle_formato.text)
ls_descripcion = String(sle_descripcion.text)

dw_report.retrieve(ls_tipo,ls_formato)

dw_report.object.p_logo.filename    = gs_logo
dw_report.object.t_nombre.text      = gs_empresa
dw_report.object.t_user.text        = gs_user
dw_report.object.t_descripcion.text = ls_descripcion

end event

type dw_report from w_report_smpl`dw_report within w_cn740_cp_rpt_formatos
integer x = 23
integer y = 288
integer width = 3374
integer height = 1024
integer taborder = 30
string dataobject = "d_cp_rpt_formatos_tbl"
end type

type cb_1 from commandbutton within w_cn740_cp_rpt_formatos
integer x = 3040
integer y = 100
integer width = 270
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type sle_descripcion from singlelineedit within w_cn740_cp_rpt_formatos
integer x = 1115
integer y = 116
integer width = 1829
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_4 from commandbutton within w_cn740_cp_rpt_formatos
integer x = 457
integer y = 116
integer width = 87
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;// Abre ventana de ayuda 

str_parametros sl_param

sl_param.dw1 = "d_cp_consulta_formato_tbl"
sl_param.titulo = "Seleccionar Búsqueda"
sl_param.field_ret_i[1] = 1
sl_param.field_ret_i[2] = 2
sl_param.field_ret_i[3] = 3

OpenWithParm( w_search, sl_param)		
sl_param = MESSAGE.POWEROBJECTPARM
IF sl_param.titulo <> 'n' THEN
	sle_tipo.text        = sl_param.field_ret[1]
	sle_formato.text     = sl_param.field_ret[2]
	sle_descripcion.text = sl_param.field_ret[3]
END IF

end event

type sle_tipo from singlelineedit within w_cn740_cp_rpt_formatos
integer x = 576
integer y = 116
integer width = 187
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type sle_formato from singlelineedit within w_cn740_cp_rpt_formatos
integer x = 795
integer y = 116
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type gb_22 from groupbox within w_cn740_cp_rpt_formatos
integer x = 407
integer y = 44
integer width = 2583
integer height = 184
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Formato "
end type

