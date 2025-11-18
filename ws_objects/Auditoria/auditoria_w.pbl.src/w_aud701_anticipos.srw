$PBExportHeader$w_aud701_anticipos.srw
forward
global type w_aud701_anticipos from w_report_smpl
end type
type uo_1 from u_ingreso_rango_fechas within w_aud701_anticipos
end type
type cb_3 from commandbutton within w_aud701_anticipos
end type
type rb_antic from radiobutton within w_aud701_anticipos
end type
type rb_cxpag from radiobutton within w_aud701_anticipos
end type
type cbx_aos from checkbox within w_aud701_anticipos
end type
type cbx_aoc from checkbox within w_aud701_anticipos
end type
type rb_ambos from radiobutton within w_aud701_anticipos
end type
type gb_1 from groupbox within w_aud701_anticipos
end type
type gb_2 from groupbox within w_aud701_anticipos
end type
type gb_3 from groupbox within w_aud701_anticipos
end type
end forward

global type w_aud701_anticipos from w_report_smpl
integer width = 3483
integer height = 1724
string title = "Control de anticipos de compras o servicios[AUD701] "
string menuname = "m_reporte"
long backcolor = 12632256
uo_1 uo_1
cb_3 cb_3
rb_antic rb_antic
rb_cxpag rb_cxpag
cbx_aos cbx_aos
cbx_aoc cbx_aoc
rb_ambos rb_ambos
gb_1 gb_1
gb_2 gb_2
gb_3 gb_3
end type
global w_aud701_anticipos w_aud701_anticipos

on w_aud701_anticipos.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.uo_1=create uo_1
this.cb_3=create cb_3
this.rb_antic=create rb_antic
this.rb_cxpag=create rb_cxpag
this.cbx_aos=create cbx_aos
this.cbx_aoc=create cbx_aoc
this.rb_ambos=create rb_ambos
this.gb_1=create gb_1
this.gb_2=create gb_2
this.gb_3=create gb_3
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
this.Control[iCurrent+2]=this.cb_3
this.Control[iCurrent+3]=this.rb_antic
this.Control[iCurrent+4]=this.rb_cxpag
this.Control[iCurrent+5]=this.cbx_aos
this.Control[iCurrent+6]=this.cbx_aoc
this.Control[iCurrent+7]=this.rb_ambos
this.Control[iCurrent+8]=this.gb_1
this.Control[iCurrent+9]=this.gb_2
this.Control[iCurrent+10]=this.gb_3
end on

on w_aud701_anticipos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
destroy(this.cb_3)
destroy(this.rb_antic)
destroy(this.rb_cxpag)
destroy(this.cbx_aos)
destroy(this.cbx_aoc)
destroy(this.rb_ambos)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.gb_3)
end on

event ue_retrieve;call super::ue_retrieve;String ls_doc_anticipo, ls_dolar, ls_doc_aos, ls_doc_aoc, ls_texto
String ls_flag_tipo 
Date ld_fec_desde
Date ld_fec_hasta

SELECT l.cod_dolares 
  INTO :ls_dolar
  FROM logparam l 
 WHERE l.reckey='1' ;

SELECT doc_anticipo_oc, doc_anticipo_os 
  INTO :ls_doc_aoc, :ls_doc_aos 
  FROM finparam l 
 WHERE l.reckey='1' ;

IF rb_antic.checked = TRUE THEN
	ls_flag_tipo = 'A' 
ELSEIF rb_cxpag.checked = TRUE THEN 
	ls_flag_tipo = 'C' 
ELSE
	ls_flag_tipo = 'T' 	
END IF

IF cbx_aos.checked = TRUE THEN
	ls_flag_tipo = ls_flag_tipo + 'S'
	ls_doc_anticipo = ls_doc_aos
ELSEIF cbx_aoc.checked = TRUE THEN
	ls_flag_tipo = ls_flag_tipo + 'C'
	ls_doc_anticipo = ls_doc_aoc
ELSE
	Messagebox('Aviso','Defina tipo de anticipo')
	Return
END IF 

ld_fec_desde=uo_1.of_get_fecha1()
ld_fec_hasta=uo_1.of_get_fecha2()

SetPointer(HourGlass!)

DECLARE PB_USP_AUD_OS_REFERENCIA PROCEDURE FOR USP_AUD_OS_REFERENCIA
        ( :ld_fec_desde, :ld_fec_hasta, :ls_flag_tipo ) ;
EXECUTE PB_USP_AUD_OS_REFERENCIA ;

idw_1.dataobject='d_anticipos_os_tbl'

ib_preview = false
triggerevent('ue_preview')
idw_1.SetTransObject(sqlca)

idw_1.Retrieve()

idw_1.object.t_empresa.text = gs_empresa
idw_1.object.t_objeto.text = 'AUD701'
idw_1.object.t_user.text = gs_user
idw_1.object.t_texto.text = '['+ls_doc_anticipo+']'+' - Del ' + &
									 String(ld_fec_desde,'dd/mm/yyyy') + ' al ' + &
									 String(ld_fec_hasta,'dd/mm/yyyy')
idw_1.object.p_logo.filename = gs_logo

SetPointer(Arrow!)

end event

type dw_report from w_report_smpl`dw_report within w_aud701_anticipos
integer x = 14
integer y = 448
integer width = 3314
integer height = 1044
integer taborder = 30
string dataobject = "d_anticipos_os_tbl"
end type

type uo_1 from u_ingreso_rango_fechas within w_aud701_anticipos
integer x = 1705
integer y = 136
integer taborder = 10
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;string ls_inicio
uo_1.of_set_label('Desde','Hasta')

// obtenemos el primer dia del mes
ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

uo_1.of_set_fecha(date(ls_inicio),today())
uo_1.of_set_rango_inicio(date('01/01/1900'))   // rango inicial
uo_1.of_set_rango_fin(date('31/12/9999'))      // rango final

end event

type cb_3 from commandbutton within w_aud701_anticipos
integer x = 3118
integer y = 124
integer width = 274
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

type rb_antic from radiobutton within w_aud701_anticipos
integer x = 46
integer y = 88
integer width = 439
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anticipos"
end type

type rb_cxpag from radiobutton within w_aud701_anticipos
integer x = 46
integer y = 168
integer width = 439
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cntas x pagar"
end type

type cbx_aos from checkbox within w_aud701_anticipos
integer x = 649
integer y = 116
integer width = 882
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anticipos de Orden de servicio"
boolean checked = true
end type

event clicked;cbx_aos.checked = true
cbx_aoc.checked = false

end event

type cbx_aoc from checkbox within w_aud701_anticipos
integer x = 645
integer y = 196
integer width = 882
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Anticipos de Orden de compra"
end type

event clicked;cbx_aoc.checked = true
cbx_aos.checked = false

end event

type rb_ambos from radiobutton within w_aud701_anticipos
integer x = 46
integer y = 248
integer width = 439
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ambos"
boolean checked = true
end type

type gb_1 from groupbox within w_aud701_anticipos
integer x = 1664
integer y = 72
integer width = 1381
integer height = 192
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = " Ingrese Rango de Fechas "
end type

type gb_2 from groupbox within w_aud701_anticipos
integer x = 27
integer y = 24
integer width = 503
integer height = 316
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opciones"
end type

type gb_3 from groupbox within w_aud701_anticipos
integer x = 608
integer y = 52
integer width = 937
integer height = 244
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Tipo de anticipos"
end type

