$PBExportHeader$w_cn720_rpt_error_asientos.srw
forward
global type w_cn720_rpt_error_asientos from w_report_smpl
end type
type sle_origen from singlelineedit within w_cn720_rpt_error_asientos
end type
type st_1 from statictext within w_cn720_rpt_error_asientos
end type
type st_2 from statictext within w_cn720_rpt_error_asientos
end type
type sle_ano from singlelineedit within w_cn720_rpt_error_asientos
end type
type st_3 from statictext within w_cn720_rpt_error_asientos
end type
type sle_mes from singlelineedit within w_cn720_rpt_error_asientos
end type
type cb_1 from commandbutton within w_cn720_rpt_error_asientos
end type
type rb_codrel from radiobutton within w_cn720_rpt_error_asientos
end type
type rb_cen from radiobutton within w_cn720_rpt_error_asientos
end type
type rb_docum from radiobutton within w_cn720_rpt_error_asientos
end type
type rb_cnta_ctbl from radiobutton within w_cn720_rpt_error_asientos
end type
type rb_ctro_benef from radiobutton within w_cn720_rpt_error_asientos
end type
type gb_1 from groupbox within w_cn720_rpt_error_asientos
end type
end forward

global type w_cn720_rpt_error_asientos from w_report_smpl
integer width = 3410
integer height = 1760
string title = "Error en consistencia de asientos (CN720)"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
sle_origen sle_origen
st_1 st_1
st_2 st_2
sle_ano sle_ano
st_3 st_3
sle_mes sle_mes
cb_1 cb_1
rb_codrel rb_codrel
rb_cen rb_cen
rb_docum rb_docum
rb_cnta_ctbl rb_cnta_ctbl
rb_ctro_benef rb_ctro_benef
gb_1 gb_1
end type
global w_cn720_rpt_error_asientos w_cn720_rpt_error_asientos

type variables
String is_opcion
end variables

on w_cn720_rpt_error_asientos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.sle_origen=create sle_origen
this.st_1=create st_1
this.st_2=create st_2
this.sle_ano=create sle_ano
this.st_3=create st_3
this.sle_mes=create sle_mes
this.cb_1=create cb_1
this.rb_codrel=create rb_codrel
this.rb_cen=create rb_cen
this.rb_docum=create rb_docum
this.rb_cnta_ctbl=create rb_cnta_ctbl
this.rb_ctro_benef=create rb_ctro_benef
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_origen
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.sle_ano
this.Control[iCurrent+5]=this.st_3
this.Control[iCurrent+6]=this.sle_mes
this.Control[iCurrent+7]=this.cb_1
this.Control[iCurrent+8]=this.rb_codrel
this.Control[iCurrent+9]=this.rb_cen
this.Control[iCurrent+10]=this.rb_docum
this.Control[iCurrent+11]=this.rb_cnta_ctbl
this.Control[iCurrent+12]=this.rb_ctro_benef
this.Control[iCurrent+13]=this.gb_1
end on

on w_cn720_rpt_error_asientos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_ano)
destroy(this.st_3)
destroy(this.sle_mes)
destroy(this.cb_1)
destroy(this.rb_codrel)
destroy(this.rb_cen)
destroy(this.rb_docum)
destroy(this.rb_cnta_ctbl)
destroy(this.rb_ctro_benef)
destroy(this.gb_1)
end on

event ue_open_pre();call super::ue_open_pre;String ls_origen, ls_ano, ls_mes
sle_origen.text = gs_origen
sle_ano.text = string( today(), 'yyyy')
sle_mes.text = string( today(), 'mm')
is_opcion='R'

end event

event resize;call super::resize;// prueba

end event

event ue_retrieve();call super::ue_retrieve;String ls_origen, ls_ano, ls_mes
Integer li_ano, li_mes

ls_origen = sle_origen.text
ls_ano = sle_ano.text
ls_mes = sle_mes.text

IF isnull(ls_origen) OR isnull(ls_ano) OR isnull(ls_mes) then
	messagebox('Aviso', 'Corregir datos son nulos')
	return
END IF
li_ano = integer(ls_ano)
li_mes = integer(ls_mes)

idw_1.SetTransObject(sqlca)
idw_1.retrieve(ls_origen, li_ano, li_mes)
idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = 'Origen: ' + ls_origen + '   Año: ' + ls_ano + '   Mes: ' + ls_mes

end event

type dw_report from w_report_smpl`dw_report within w_cn720_rpt_error_asientos
integer x = 18
integer y = 380
integer width = 3333
integer height = 1248
integer taborder = 50
string dataobject = "d_rpt_asiento_codrel_error_tbl"
end type

type sle_origen from singlelineedit within w_cn720_rpt_error_asientos
integer x = 1463
integer y = 208
integer width = 165
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
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cn720_rpt_error_asientos
integer x = 1266
integer y = 204
integer width = 187
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cn720_rpt_error_asientos
integer x = 1989
integer y = 96
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año:"
boolean focusrectangle = false
end type

type sle_ano from singlelineedit within w_cn720_rpt_error_asientos
integer x = 2135
integer y = 88
integer width = 160
integer height = 72
integer taborder = 20
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

type st_3 from statictext within w_cn720_rpt_error_asientos
integer x = 1989
integer y = 204
integer width = 137
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes:"
boolean focusrectangle = false
end type

type sle_mes from singlelineedit within w_cn720_rpt_error_asientos
integer x = 2135
integer y = 196
integer width = 160
integer height = 72
integer taborder = 30
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

type cb_1 from commandbutton within w_cn720_rpt_error_asientos
integer x = 2432
integer y = 124
integer width = 320
integer height = 112
integer taborder = 40
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Imprime"
end type

event clicked;

IF rb_codrel.checked=true then
	idw_1.DataObject='d_rpt_asiento_codrel_error_tbl'
ELSEIF rb_cen.checked=true then
	idw_1.DataObject='d_rpt_asiento_cencos_error_tbl'
ELSEIF rb_ctro_benef.checked=true then
	idw_1.DataObject='d_rpt_asiento_cnta_prsp_error_tbl'
ELSEIF rb_docum.checked=true then
	idw_1.DataObject='d_rpt_asiento_docum_error_tbl'
ELSEIF rb_cnta_ctbl.checked=true then
	idw_1.DataObject='d_rpt_error_cencos_tbl'
ELSE
	messagebox('Seleccione opcion','Detalle o Resumido')
	return
END IF

idw_1.visible = true
//parent.event ue_preview()

parent.event ue_retrieve()

end event

type rb_codrel from radiobutton within w_cn720_rpt_error_asientos
integer x = 91
integer y = 100
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "cód. .relación"
boolean checked = true
end type

event clicked;is_opcion='R'
end event

type rb_cen from radiobutton within w_cn720_rpt_error_asientos
integer x = 91
integer y = 184
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x c. costo"
end type

event clicked;is_opcion='C'
end event

type rb_docum from radiobutton within w_cn720_rpt_error_asientos
integer x = 645
integer y = 184
integer width = 421
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x documento"
end type

event clicked;is_opcion='D'
end event

type rb_cnta_ctbl from radiobutton within w_cn720_rpt_error_asientos
integer x = 1257
integer y = 100
integer width = 530
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x cnta.ctbl y cencos"
end type

event clicked;is_opcion='X'
end event

type rb_ctro_benef from radiobutton within w_cn720_rpt_error_asientos
integer x = 645
integer y = 96
integer width = 549
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "x centro de beneficio "
end type

type gb_1 from groupbox within w_cn720_rpt_error_asientos
integer x = 37
integer y = 28
integer width = 2331
integer height = 280
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Parámetros"
end type

