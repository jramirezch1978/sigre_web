$PBExportHeader$w_cn702_cntbl_rpt_maestro_relacion.srw
forward
global type w_cn702_cntbl_rpt_maestro_relacion from w_report_smpl
end type
type cb_1 from commandbutton within w_cn702_cntbl_rpt_maestro_relacion
end type
type st_1 from statictext within w_cn702_cntbl_rpt_maestro_relacion
end type
type rb_1 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
end type
type rb_2 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
end type
type rb_3 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
end type
type gb_1 from groupbox within w_cn702_cntbl_rpt_maestro_relacion
end type
end forward

global type w_cn702_cntbl_rpt_maestro_relacion from w_report_smpl
integer width = 3369
integer height = 1604
string title = "Maestro de relaciones (CN702)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_1 st_1
rb_1 rb_1
rb_2 rb_2
rb_3 rb_3
gb_1 gb_1
end type
global w_cn702_cntbl_rpt_maestro_relacion w_cn702_cntbl_rpt_maestro_relacion

on w_cn702_cntbl_rpt_maestro_relacion.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_1=create st_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.rb_3=create rb_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.rb_1
this.Control[iCurrent+4]=this.rb_2
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.gb_1
end on

on w_cn702_cntbl_rpt_maestro_relacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.rb_3)
destroy(this.gb_1)
end on

event ue_retrieve();call super::ue_retrieve;dw_report.settransobject(sqlca)
choose case dw_report.DataObject
	case 'd_cntbl_cod_relacion_c_tbl'
		  dw_report.retrieve()
	case 'd_cntbl_cod_relacion_n_tbl'
		  dw_report.retrieve()
	case 'd_cntbl_cod_relacion_r_tbl'
		  dw_report.retrieve()
end choose

dw_report.object.p_logo.filename = gs_logo
dw_report.object.t_nombre.text   = gs_empresa
dw_report.object.t_user.text     = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn702_cntbl_rpt_maestro_relacion
integer x = 23
integer y = 304
integer width = 3287
integer height = 1100
integer taborder = 0
end type

type cb_1 from commandbutton within w_cn702_cntbl_rpt_maestro_relacion
integer x = 2953
integer y = 96
integer width = 297
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_preview()
parent.event ue_retrieve()
parent.event ue_preview()
end event

type st_1 from statictext within w_cn702_cntbl_rpt_maestro_relacion
integer x = 283
integer y = 100
integer width = 1170
integer height = 84
boolean bringtotop = true
integer textsize = -12
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 12632256
string text = "MAESTRO DE RELACIONES"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleshadowbox!
boolean focusrectangle = false
end type

type rb_1 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
integer x = 1609
integer y = 80
integer width = 677
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Código Proveedor"
borderstyle borderstyle = styleraised!
end type

event clicked;dw_report.DataObject= 'd_cntbl_cod_relacion_c_tbl'
end event

type rb_2 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
integer x = 1609
integer y = 148
integer width = 677
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Nombre o Razón Social"
borderstyle borderstyle = styleraised!
end type

event clicked;dw_report.DataObject= 'd_cntbl_cod_relacion_n_tbl'
end event

type rb_3 from radiobutton within w_cn702_cntbl_rpt_maestro_relacion
integer x = 2286
integer y = 80
integer width = 562
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Número de R.U.C."
borderstyle borderstyle = styleraised!
end type

event clicked;dw_report.DataObject= 'd_cntbl_cod_relacion_r_tbl'
end event

type gb_1 from groupbox within w_cn702_cntbl_rpt_maestro_relacion
integer x = 1550
integer y = 24
integer width = 1335
integer height = 220
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Seleccione Opción "
end type

