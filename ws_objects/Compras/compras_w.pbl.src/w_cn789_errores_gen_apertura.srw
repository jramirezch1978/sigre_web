$PBExportHeader$w_cn789_errores_gen_apertura.srw
forward
global type w_cn789_errores_gen_apertura from w_report_smpl
end type
type cb_1 from commandbutton within w_cn789_errores_gen_apertura
end type
type sle_ano from singlelineedit within w_cn789_errores_gen_apertura
end type
type st_11 from statictext within w_cn789_errores_gen_apertura
end type
type rb_cencos from radiobutton within w_cn789_errores_gen_apertura
end type
type rb_codrel from radiobutton within w_cn789_errores_gen_apertura
end type
type rb_flag_mov from radiobutton within w_cn789_errores_gen_apertura
end type
type gb_12 from groupbox within w_cn789_errores_gen_apertura
end type
type gb_1 from groupbox within w_cn789_errores_gen_apertura
end type
end forward

global type w_cn789_errores_gen_apertura from w_report_smpl
integer width = 3515
integer height = 1780
string title = "(CN789) Errores a corregir antes generar apertura"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
cb_1 cb_1
sle_ano sle_ano
st_11 st_11
rb_cencos rb_cencos
rb_codrel rb_codrel
rb_flag_mov rb_flag_mov
gb_12 gb_12
gb_1 gb_1
end type
global w_cn789_errores_gen_apertura w_cn789_errores_gen_apertura

on w_cn789_errores_gen_apertura.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.sle_ano=create sle_ano
this.st_11=create st_11
this.rb_cencos=create rb_cencos
this.rb_codrel=create rb_codrel
this.rb_flag_mov=create rb_flag_mov
this.gb_12=create gb_12
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.sle_ano
this.Control[iCurrent+3]=this.st_11
this.Control[iCurrent+4]=this.rb_cencos
this.Control[iCurrent+5]=this.rb_codrel
this.Control[iCurrent+6]=this.rb_flag_mov
this.Control[iCurrent+7]=this.gb_12
this.Control[iCurrent+8]=this.gb_1
end on

on w_cn789_errores_gen_apertura.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.sle_ano)
destroy(this.st_11)
destroy(this.rb_cencos)
destroy(this.rb_codrel)
destroy(this.rb_flag_mov)
destroy(this.gb_12)
destroy(this.gb_1)
end on

event ue_retrieve;call super::ue_retrieve;Long ll_ano, ll_mes
String ls_texto

ll_ano = LONG(sle_ano.text)
ls_texto = 'Período contable ' + string(ll_ano)

SetPointer(HourGlass!)

IF rb_cencos.checked THEN
	idw_1.dataobject='d_rpt_error_apertura_cencos_tbl'
END IF
IF rb_cencos.checked THEN
	idw_1.dataobject='d_rpt_error_apertura_codrel_tbl'
END IF
IF rb_flag_mov.checked THEN
	idw_1.dataobject='d_rpt_error_apertura_flag_mov_tbl'
END IF

idw_1.SettransObject(sqlca)

idw_1.object.p_logo.filename = gs_logo
idw_1.object.t_texto.text = ls_texto
idw_1.object.t_user.text = gs_user
idw_1.object.t_empresa.text = gs_empresa

ib_preview = FALSE
idw_1.ii_zoom_actual = 100
//Parent.Event ue_preview()

Event ue_preview()

idw_1.retrieve(ll_ano)

SetPointer(Arrow!)


end event

type dw_report from w_report_smpl`dw_report within w_cn789_errores_gen_apertura
integer x = 23
integer y = 336
integer width = 3406
integer height = 1076
integer taborder = 90
string dataobject = "d_rpt_error_apertura_cencos_tbl"
end type

type cb_1 from commandbutton within w_cn789_errores_gen_apertura
integer x = 1280
integer y = 144
integer width = 315
integer height = 92
integer taborder = 80
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

type sle_ano from singlelineedit within w_cn789_errores_gen_apertura
integer x = 1061
integer y = 152
integer width = 192
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type st_11 from statictext within w_cn789_errores_gen_apertura
integer x = 891
integer y = 160
integer width = 155
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
string text = "Año :"
alignment alignment = center!
boolean focusrectangle = false
end type

type rb_cencos from radiobutton within w_cn789_errores_gen_apertura
integer x = 87
integer y = 88
integer width = 622
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Centro de costo "
boolean checked = true
end type

type rb_codrel from radiobutton within w_cn789_errores_gen_apertura
integer x = 87
integer y = 156
integer width = 622
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Código de relación"
end type

type rb_flag_mov from radiobutton within w_cn789_errores_gen_apertura
integer x = 87
integer y = 224
integer width = 622
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 12632256
string text = "Flag movimiento"
end type

type gb_12 from groupbox within w_cn789_errores_gen_apertura
integer x = 859
integer y = 76
integer width = 763
integer height = 200
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = " Periodo Contable "
end type

type gb_1 from groupbox within w_cn789_errores_gen_apertura
integer x = 59
integer y = 24
integer width = 695
integer height = 288
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 12632256
string text = "Parámetro"
end type

