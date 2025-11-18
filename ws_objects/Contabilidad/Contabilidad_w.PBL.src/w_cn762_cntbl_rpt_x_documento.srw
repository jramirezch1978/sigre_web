$PBExportHeader$w_cn762_cntbl_rpt_x_documento.srw
forward
global type w_cn762_cntbl_rpt_x_documento from w_report_smpl
end type
type cb_1 from commandbutton within w_cn762_cntbl_rpt_x_documento
end type
type sle_relacion from singlelineedit within w_cn762_cntbl_rpt_x_documento
end type
type st_1 from statictext within w_cn762_cntbl_rpt_x_documento
end type
type st_2 from statictext within w_cn762_cntbl_rpt_x_documento
end type
type st_3 from statictext within w_cn762_cntbl_rpt_x_documento
end type
type sle_tipo from singlelineedit within w_cn762_cntbl_rpt_x_documento
end type
type st_desc_tipo from statictext within w_cn762_cntbl_rpt_x_documento
end type
type sle_numero from singlelineedit within w_cn762_cntbl_rpt_x_documento
end type
type st_razsoc from statictext within w_cn762_cntbl_rpt_x_documento
end type
type gb_1 from groupbox within w_cn762_cntbl_rpt_x_documento
end type
end forward

global type w_cn762_cntbl_rpt_x_documento from w_report_smpl
integer width = 3104
integer height = 1692
string title = "[CN672] Analítico de Cuenta Corriente x Documento"
string menuname = "m_abc_report_smpl"
cb_1 cb_1
sle_relacion sle_relacion
st_1 st_1
st_2 st_2
st_3 st_3
sle_tipo sle_tipo
st_desc_tipo st_desc_tipo
sle_numero sle_numero
st_razsoc st_razsoc
gb_1 gb_1
end type
global w_cn762_cntbl_rpt_x_documento w_cn762_cntbl_rpt_x_documento

on w_cn762_cntbl_rpt_x_documento.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.sle_relacion=create sle_relacion
this.st_1=create st_1
this.st_2=create st_2
this.st_3=create st_3
this.sle_tipo=create sle_tipo
this.st_desc_tipo=create st_desc_tipo
this.sle_numero=create sle_numero
this.st_razsoc=create st_razsoc
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_relacion
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_tipo
this.Control[iCurrent+7]=this.st_desc_tipo
this.Control[iCurrent+8]=this.sle_numero
this.Control[iCurrent+9]=this.st_razsoc
this.Control[iCurrent+10]=this.gb_1
end on

on w_cn762_cntbl_rpt_x_documento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_relacion)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_tipo)
destroy(this.st_desc_tipo)
destroy(this.sle_numero)
destroy(this.st_razsoc)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;string ls_relacion, ls_razsoc, ls_tipo, ls_doc, ls_repor

if TRIM(sle_relacion.text) = '' then
	ls_relacion = '%%'
else
	ls_relacion = TRIM(sle_relacion.text) + '%'
end if

if TRIM(sle_tipo.text) = '' then
	ls_tipo = '%%'
else
	ls_tipo = TRIM(sle_tipo.text) + '%'
end if

if TRIM(sle_numero.text) = '' then
	ls_doc = '%%'
else
	ls_doc = TRIM(sle_numero.text) + '%'
end if

dw_report.settransobject(sqlca)
dw_report.retrieve(ls_relacion, ls_tipo, ls_doc)


dw_report.object.t_user.text     =  gs_user
dw_report.object.t_empresa.text  =  gs_empresa
dw_report.object.p_logo.filename =  gs_logo
dw_report.object.t_windows.text  =  THIS.CLASSNAME()

end event

type dw_report from w_report_smpl`dw_report within w_cn762_cntbl_rpt_x_documento
integer x = 0
integer y = 340
integer width = 2935
integer height = 972
string dataobject = "d_cns_cta_cte_detalle_tbl"
end type

type cb_1 from commandbutton within w_cn762_cntbl_rpt_x_documento
integer x = 2322
integer y = 76
integer width = 347
integer height = 172
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_retrieve()
end event

type sle_relacion from singlelineedit within w_cn762_cntbl_rpt_x_documento
event ue_dobleclick pbm_lbuttondblclk
integer x = 544
integer y = 64
integer width = 311
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT p.proveedor AS CODIGO, " &
		 + "p.nom_proveedor AS DESCRIPCION " &
		 + "FROM proveedor p " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text 		= ls_codigo
	st_razsoc.text = ls_data
end if


end event

type st_1 from statictext within w_cn762_cntbl_rpt_x_documento
integer x = 64
integer y = 84
integer width = 265
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Relación :"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn762_cntbl_rpt_x_documento
integer x = 64
integer y = 164
integer width = 389
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Documento :"
boolean focusrectangle = false
end type

type st_3 from statictext within w_cn762_cntbl_rpt_x_documento
integer x = 64
integer y = 244
integer width = 471
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Número Documento :"
boolean focusrectangle = false
end type

type sle_tipo from singlelineedit within w_cn762_cntbl_rpt_x_documento
event ue_dobleclick pbm_lbuttondblclk
integer x = 544
integer y = 148
integer width = 311
integer height = 80
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT d.tipo_doc AS CODIGO, " &
		 + "d.desc_tipo_doc AS DESCRIPCION " &
		 + "FROM doc_tipo d " 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 		= ls_codigo
	st_desc_tipo.text = ls_data
end if




end event

type st_desc_tipo from statictext within w_cn762_cntbl_rpt_x_documento
integer x = 869
integer y = 152
integer width = 1198
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_numero from singlelineedit within w_cn762_cntbl_rpt_x_documento
integer x = 544
integer y = 232
integer width = 439
integer height = 80
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_razsoc from statictext within w_cn762_cntbl_rpt_x_documento
integer x = 869
integer y = 64
integer width = 1198
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn762_cntbl_rpt_x_documento
integer width = 2295
integer height = 324
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

