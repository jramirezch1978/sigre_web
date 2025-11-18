$PBExportHeader$w_fi739_vouchers_masivos.srw
forward
global type w_fi739_vouchers_masivos from w_report_smpl
end type
type cb_1 from commandbutton within w_fi739_vouchers_masivos
end type
type uo_1 from u_ingreso_rango_fechas within w_fi739_vouchers_masivos
end type
type sle_tipo_doc from singlelineedit within w_fi739_vouchers_masivos
end type
type cb_2 from commandbutton within w_fi739_vouchers_masivos
end type
type rb_esp from radiobutton within w_fi739_vouchers_masivos
end type
type rb_gen from radiobutton within w_fi739_vouchers_masivos
end type
type gb_1 from groupbox within w_fi739_vouchers_masivos
end type
type gb_2 from groupbox within w_fi739_vouchers_masivos
end type
type gb_3 from groupbox within w_fi739_vouchers_masivos
end type
end forward

global type w_fi739_vouchers_masivos from w_report_smpl
integer width = 2889
integer height = 944
string title = "(FI739) Impresion Masiva de Vouchers"
string menuname = "m_reporte"
long backcolor = 67108864
cb_1 cb_1
uo_1 uo_1
sle_tipo_doc sle_tipo_doc
cb_2 cb_2
rb_esp rb_esp
rb_gen rb_gen
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_fi739_vouchers_masivos w_fi739_vouchers_masivos

on w_fi739_vouchers_masivos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.cb_1=create cb_1
this.uo_1=create uo_1
this.sle_tipo_doc=create sle_tipo_doc
this.cb_2=create cb_2
this.rb_esp=create rb_esp
this.rb_gen=create rb_gen
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.uo_1
this.Control[iCurrent+3]=this.sle_tipo_doc
this.Control[iCurrent+4]=this.cb_2
this.Control[iCurrent+5]=this.rb_esp
this.Control[iCurrent+6]=this.rb_gen
this.Control[iCurrent+7]=this.gb_1
this.Control[iCurrent+8]=this.gb_2
this.Control[iCurrent+9]=this.gb_3
end on

on w_fi739_vouchers_masivos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.uo_1)
destroy(this.sle_tipo_doc)
destroy(this.cb_2)
destroy(this.rb_esp)
destroy(this.rb_gen)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;date ad_inicio, ad_fin
string ls_tipo, ls_flag_rep

ls_tipo = sle_tipo_doc.text

if ls_tipo = '' or isnull(ls_tipo) then
	messagebox('Aviso','Debe de seleccionar un Tipo de Documento')
	return
end if

ad_inicio = uo_1.of_get_fecha1()
ad_fin    = uo_1.of_get_fecha2()

IF rb_gen.checked THEN
	ls_flag_rep = 'G'
ELSEIF rb_esp.checked THEN
	ls_flag_rep = 'E'	
END IF

dw_report.settransobject(sqlca)
dw_report.retrieve(ad_inicio, ad_fin, ls_tipo, ls_flag_rep, gs_empresa )

//dw_report.Object.desde_t.text = string(ad_inicio)
//dw_report.Object.hasta_t.text = string(ad_fin)
//dw_report.Object.usuario_t.text = gs_user
//dw_report.Object.empresa_t.text = gs_empresa
//dw_report.object.p_logo.filename = gs_logo
end event

type dw_report from w_report_smpl`dw_report within w_fi739_vouchers_masivos
integer x = 37
integer y = 256
integer width = 2747
integer height = 420
string dataobject = "d_rpt_comprobante_egreso_masivo_tbl"
end type

type cb_1 from commandbutton within w_fi739_vouchers_masivos
integer x = 2487
integer y = 128
integer width = 297
integer height = 100
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event ue_retrieve()
end event

type uo_1 from u_ingreso_rango_fechas within w_fi739_vouchers_masivos
integer x = 73
integer y = 104
integer taborder = 50
boolean bringtotop = true
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(Date('01/01/2001'), date(gd_fecha)) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/2002')) // rango inicial
of_set_rango_fin(date(gd_fecha)) // rango final

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type sle_tipo_doc from singlelineedit within w_fi739_vouchers_masivos
integer x = 1458
integer y = 108
integer width = 187
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean enabled = false
textcase textcase = upper!
integer limit = 4
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_fi739_vouchers_masivos
integer x = 1659
integer y = 108
integer width = 137
integer height = 84
integer taborder = 70
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;str_seleccionar lstr_seleccionar

lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_PAGAR.TIPO_DOC AS CODIGO_DOC,'&
								+'VW_FIN_DOC_X_GRUPO_PAGAR.DESC_TIPO_DOC AS DESCRIPCION '&
								+'FROM VW_FIN_DOC_X_GRUPO_PAGAR '  
														
OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
   sle_tipo_doc.text = trim(lstr_seleccionar.param1[1])
end if
end event

type rb_esp from radiobutton within w_fi739_vouchers_masivos
integer x = 1902
integer y = 160
integer width = 530
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Especial"
end type

type rb_gen from radiobutton within w_fi739_vouchers_masivos
integer x = 1902
integer y = 92
integer width = 530
integer height = 52
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato GENERAL"
boolean checked = true
end type

type gb_1 from groupbox within w_fi739_vouchers_masivos
integer x = 37
integer y = 32
integer width = 1358
integer height = 196
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Fechas"
end type

type gb_2 from groupbox within w_fi739_vouchers_masivos
integer x = 1426
integer y = 32
integer width = 411
integer height = 196
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Tipo Doc"
end type

type gb_3 from groupbox within w_fi739_vouchers_masivos
integer x = 1865
integer y = 32
integer width = 590
integer height = 196
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Impresión"
end type

