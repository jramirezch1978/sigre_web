$PBExportHeader$w_fl902_consistencia_pesca.srw
forward
global type w_fl902_consistencia_pesca from w_abc
end type
type rb_rango from radiobutton within w_fl902_consistencia_pesca
end type
type rb_semana from radiobutton within w_fl902_consistencia_pesca
end type
type sle_year from singlelineedit within w_fl902_consistencia_pesca
end type
type sle_semana from singlelineedit within w_fl902_consistencia_pesca
end type
type st_desc_especie from statictext within w_fl902_consistencia_pesca
end type
type sle_especie from singlelineedit within w_fl902_consistencia_pesca
end type
type st_1 from statictext within w_fl902_consistencia_pesca
end type
type em_tpeso from editmask within w_fl902_consistencia_pesca
end type
type uo_fechas from u_ingreso_rango_fechas within w_fl902_consistencia_pesca
end type
type cb_2 from commandbutton within w_fl902_consistencia_pesca
end type
type cb_1 from commandbutton within w_fl902_consistencia_pesca
end type
type st_3 from statictext within w_fl902_consistencia_pesca
end type
type gb_1 from groupbox within w_fl902_consistencia_pesca
end type
end forward

global type w_fl902_consistencia_pesca from w_abc
integer width = 2162
integer height = 772
string title = "Consistencia de Pesca (FL902)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
event ue_aceptar ( )
event ue_cancelar ( )
rb_rango rb_rango
rb_semana rb_semana
sle_year sle_year
sle_semana sle_semana
st_desc_especie st_desc_especie
sle_especie sle_especie
st_1 st_1
em_tpeso em_tpeso
uo_fechas uo_fechas
cb_2 cb_2
cb_1 cb_1
st_3 st_3
gb_1 gb_1
end type
global w_fl902_consistencia_pesca w_fl902_consistencia_pesca

event ue_aceptar();date		ld_fecha1, ld_fecha2
Decimal	ldc_tpeso
String	ls_mensaje, ls_especie
Integer	li_year, li_semana

if rb_rango.checked then
	ld_fecha1 	= uo_fechas.of_get_fecha1()
	ld_fecha2 	= uo_fechas.of_get_fecha2()
else
	li_year 		= Integer(sle_year.text)
	li_Semana 	= Integer(sle_semana.text)
	
	select fecha_inicio, fecha_fin
		into :ld_fecha1, :ld_Fecha2
	from semanas
	where ano = :li_year
	  and semana = :li_Semana;
	
	uo_fechas.of_set_fecha(ld_fecha1, ld_fecha2)
	
end if

//Obtengo datos adicionales
ldc_tpeso	= Dec(em_tpeso.text)
ls_especie	= trim(sle_especie.text)

if ls_especie = '' then
	MessageBox('Error', "Debe especificar una especie primero")
	sle_especie.setFocus( )
	return
end if

//create or replace procedure USP_FL_CONSIST_PESCA(
//      adi_fecha1 	in date,
//      adi_fecha2 	in date
//      ani_tpeso   in number
//) is


DECLARE USP_FL_CONSIST_PESCA PROCEDURE FOR
	USP_FL_CONSIST_PESCA( :ld_fecha1, 
								 :ld_fecha2,
								 :ls_especie,
								 :ldc_tpeso);

EXECUTE USP_FL_CONSIST_PESCA;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_FL_CONSIST_PESCA: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE USP_FL_CONSIST_PESCA;

MessageBox('AVISO', 'CONSISTENCIA PROCESADA SATISFACTORIAMENTE', Information!)


end event

event ue_cancelar();close(this)
end event

on w_fl902_consistencia_pesca.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.rb_rango=create rb_rango
this.rb_semana=create rb_semana
this.sle_year=create sle_year
this.sle_semana=create sle_semana
this.st_desc_especie=create st_desc_especie
this.sle_especie=create sle_especie
this.st_1=create st_1
this.em_tpeso=create em_tpeso
this.uo_fechas=create uo_fechas
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_3=create st_3
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.rb_rango
this.Control[iCurrent+2]=this.rb_semana
this.Control[iCurrent+3]=this.sle_year
this.Control[iCurrent+4]=this.sle_semana
this.Control[iCurrent+5]=this.st_desc_especie
this.Control[iCurrent+6]=this.sle_especie
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.em_tpeso
this.Control[iCurrent+9]=this.uo_fechas
this.Control[iCurrent+10]=this.cb_2
this.Control[iCurrent+11]=this.cb_1
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.gb_1
end on

on w_fl902_consistencia_pesca.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.rb_rango)
destroy(this.rb_semana)
destroy(this.sle_year)
destroy(this.sle_semana)
destroy(this.st_desc_especie)
destroy(this.sle_especie)
destroy(this.st_1)
destroy(this.em_tpeso)
destroy(this.uo_fechas)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_3)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date 		ld_hoy
Integer	li_year, li_semana

if gs_empresa='CANTABRIA' then
	em_tpeso.visible = false
	em_tpeso.enabled = false
	st_3.visible = false
else
	em_tpeso.visible = true
	em_tpeso.enabled = true
	st_3.visible = true
end if;


//Obtengo la semana por defecto
ld_hoy = Date(gnvo_app.of_fecha_actual( ))

select ano, semana
	into :li_year, :li_Semana
from semanas
where :ld_hoy between fecha_inicio and fecha_fin;

sle_year.text = string(li_year)
sle_semana.text = string(li_semana)

rb_semana.checked = true
uo_fechas.of_enabled(false)
	
	
end event

type rb_rango from radiobutton within w_fl902_consistencia_pesca
integer x = 41
integer y = 160
integer width = 494
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rango de Fecha : "
end type

event clicked;if this.checked then
	uo_fechas.of_enabled(true)
	sle_year.enabled 		= false
	sle_semana.enabled 	= false
end if
end event

type rb_semana from radiobutton within w_fl902_consistencia_pesca
integer x = 41
integer y = 52
integer width = 494
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Semana de Pesca :"
boolean checked = true
end type

event clicked;if this.checked then
	uo_fechas.of_enabled(false)
	sle_year.enabled 		= true
	sle_semana.enabled 	= true
end if

end event

type sle_year from singlelineedit within w_fl902_consistencia_pesca
integer x = 544
integer y = 52
integer width = 229
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

type sle_semana from singlelineedit within w_fl902_consistencia_pesca
integer x = 773
integer y = 52
integer width = 137
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

type st_desc_especie from statictext within w_fl902_consistencia_pesca
integer x = 869
integer y = 292
integer width = 1202
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type sle_especie from singlelineedit within w_fl902_consistencia_pesca
event ue_dobleclick pbm_lbuttondblclk
integer x = 517
integer y = 292
integer width = 343
integer height = 80
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;String ls_sql, ls_codigo, ls_data

ls_sql = "select distinct te.especie as codigo_Especie, " &
		 + "te.descr_especie as descripcion_Especie " &
		 + "from tg_especies te, " &
		 + "     fl_venta		flv " &
		 + "where te.especie = flv.especie " &
		 + "  and te.flag_estado = '1'"
				 
f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> "" then
	this.text = ls_codigo
	st_desc_especie.text = ls_data
end if
end event

type st_1 from statictext within w_fl902_consistencia_pesca
integer x = 69
integer y = 288
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Especie :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_tpeso from editmask within w_fl902_consistencia_pesca
integer x = 517
integer y = 396
integer width = 343
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "10.00"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "###,##0.00"
end type

type uo_fechas from u_ingreso_rango_fechas within w_fl902_consistencia_pesca
event destroy ( )
integer x = 517
integer y = 160
integer height = 80
integer taborder = 40
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(date(f_fecha_Actual()), date(f_fecha_actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type cb_2 from commandbutton within w_fl902_consistencia_pesca
integer x = 1691
integer y = 440
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_1 from commandbutton within w_fl902_consistencia_pesca
integer x = 1339
integer y = 440
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;parent.event ue_aceptar()
end event

type st_3 from statictext within w_fl902_consistencia_pesca
integer x = 69
integer y = 396
integer width = 402
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Tasa de Peso:"
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_fl902_consistencia_pesca
integer width = 2139
integer height = 260
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Modo de Proceso"
end type

