$PBExportHeader$w_cn814_rpt_txt_pdt0656_sunat.srw
forward
global type w_cn814_rpt_txt_pdt0656_sunat from w_report_smpl
end type
type cb_1 from commandbutton within w_cn814_rpt_txt_pdt0656_sunat
end type
type st_3 from statictext within w_cn814_rpt_txt_pdt0656_sunat
end type
type st_4 from statictext within w_cn814_rpt_txt_pdt0656_sunat
end type
type em_ano from editmask within w_cn814_rpt_txt_pdt0656_sunat
end type
type em_mes from editmask within w_cn814_rpt_txt_pdt0656_sunat
end type
type rb_reporte from radiobutton within w_cn814_rpt_txt_pdt0656_sunat
end type
type rb_texto from radiobutton within w_cn814_rpt_txt_pdt0656_sunat
end type
type ddplb_1 from dropdownpicturelistbox within w_cn814_rpt_txt_pdt0656_sunat
end type
type em_uit from editmask within w_cn814_rpt_txt_pdt0656_sunat
end type
type st_1 from statictext within w_cn814_rpt_txt_pdt0656_sunat
end type
type st_2 from statictext within w_cn814_rpt_txt_pdt0656_sunat
end type
type gb_1 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
end type
type gb_2 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
end type
type gb_3 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
end type
end forward

global type w_cn814_rpt_txt_pdt0656_sunat from w_report_smpl
integer width = 3369
integer height = 1604
string title = "(CN814) Formulario 0656 para la SUNAT"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
st_3 st_3
st_4 st_4
em_ano em_ano
em_mes em_mes
rb_reporte rb_reporte
rb_texto rb_texto
ddplb_1 ddplb_1
em_uit em_uit
st_1 st_1
st_2 st_2
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_cn814_rpt_txt_pdt0656_sunat w_cn814_rpt_txt_pdt0656_sunat

on w_cn814_rpt_txt_pdt0656_sunat.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.cb_1=create cb_1
this.st_3=create st_3
this.st_4=create st_4
this.em_ano=create em_ano
this.em_mes=create em_mes
this.rb_reporte=create rb_reporte
this.rb_texto=create rb_texto
this.ddplb_1=create ddplb_1
this.em_uit=create em_uit
this.st_1=create st_1
this.st_2=create st_2
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.st_4
this.Control[iCurrent+4]=this.em_ano
this.Control[iCurrent+5]=this.em_mes
this.Control[iCurrent+6]=this.rb_reporte
this.Control[iCurrent+7]=this.rb_texto
this.Control[iCurrent+8]=this.ddplb_1
this.Control[iCurrent+9]=this.em_uit
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_2
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
this.Control[iCurrent+14]=this.gb_3
end on

on w_cn814_rpt_txt_pdt0656_sunat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.em_ano)
destroy(this.em_mes)
destroy(this.rb_reporte)
destroy(this.rb_texto)
destroy(this.ddplb_1)
destroy(this.em_uit)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;integer li_ano, li_mes, li_uit
string ls_cuenta

li_ano = integer(em_ano.text)
li_mes = integer(em_mes.text)
li_uit = integer(em_uit.text)

ls_cuenta = trim(right(ddplb_1.text,2))

if isnull(li_ano) or li_ano = 0 then
	MessageBox('Aviso','Debe ingresar año a procesar')
	return
end if

if isnull(li_uit) or li_uit = 0 then
	MessageBox('Aviso','Debe ingresar la Unidad Impositiva Tributaria')
	return
end if

DECLARE pb_usp_cntbl_pdt_0656_sunat PROCEDURE FOR USP_CNTBL_PDT_0656_SUNAT
        ( :li_ano, :li_mes, :ls_cuenta, :li_uit ) ;
EXECUTE pb_usp_cntbl_pdt_0656_sunat ;

if rb_reporte.checked = true then
	idw_1.DataObject='d_rpt_0656_sunat_tbl'
elseif rb_texto.checked = true then
	idw_1.DataObject='d_txt_0656_sunat_tbl'
end if

ib_preview = false
triggerevent('ue_preview')
idw_1.SetTransObject(sqlca)
idw_1.retrieve()

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_nombre.text = gs_empresa
idw_1.object.t_user.text = gs_user

end event

type dw_report from w_report_smpl`dw_report within w_cn814_rpt_txt_pdt0656_sunat
integer x = 23
integer y = 376
integer width = 3291
integer height = 1028
integer taborder = 60
end type

type cb_1 from commandbutton within w_cn814_rpt_txt_pdt0656_sunat
integer x = 2729
integer y = 148
integer width = 297
integer height = 92
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;Parent.Event ue_retrieve()

end event

type st_3 from statictext within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1006
integer y = 172
integer width = 137
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Mes"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_4 from statictext within w_cn814_rpt_txt_pdt0656_sunat
integer x = 585
integer y = 172
integer width = 142
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Año"
alignment alignment = center!
boolean focusrectangle = false
end type

type em_ano from editmask within w_cn814_rpt_txt_pdt0656_sunat
integer x = 731
integer y = 156
integer width = 251
integer height = 84
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment alignment = center!
borderstyle borderstyle = stylelowered!
string mask = "####"
end type

type em_mes from editmask within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1147
integer y = 156
integer width = 160
integer height = 84
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "12"
alignment alignment = center!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
string mask = "##"
end type

type rb_reporte from radiobutton within w_cn814_rpt_txt_pdt0656_sunat
integer x = 119
integer y = 132
integer width = 288
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Reporte"
end type

type rb_texto from radiobutton within w_cn814_rpt_txt_pdt0656_sunat
integer x = 119
integer y = 204
integer width = 288
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Texto"
end type

type ddplb_1 from dropdownpicturelistbox within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1701
integer y = 156
integer width = 270
integer height = 572
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean vscrollbar = true
string item[] = {"12","16","19","42","46"}
borderstyle borderstyle = stylelowered!
integer itempictureindex[] = {1,1,1,1,1}
long picturemaskcolor = 536870912
end type

type em_uit from editmask within w_cn814_rpt_txt_pdt0656_sunat
integer x = 2153
integer y = 156
integer width = 425
integer height = 84
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "##,###,###,###.00"
end type

type st_1 from statictext within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1481
integer y = 172
integer width = 206
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "Cuenta"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1998
integer y = 172
integer width = 146
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 12632256
string text = "U.I.T."
alignment alignment = center!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
integer x = 530
integer y = 84
integer width = 855
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_2 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
integer x = 59
integer y = 60
integer width = 416
integer height = 252
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = " Seleccionar "
end type

type gb_3 from groupbox within w_cn814_rpt_txt_pdt0656_sunat
integer x = 1426
integer y = 84
integer width = 1234
integer height = 204
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = " Registrar Información "
end type

