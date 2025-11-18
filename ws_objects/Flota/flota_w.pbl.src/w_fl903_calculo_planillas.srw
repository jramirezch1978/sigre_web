$PBExportHeader$w_fl903_calculo_planillas.srw
forward
global type w_fl903_calculo_planillas from w_abc
end type
type uo_fechas from u_ingreso_rango_fechas within w_fl903_calculo_planillas
end type
type sle_semana from singlelineedit within w_fl903_calculo_planillas
end type
type sle_year from singlelineedit within w_fl903_calculo_planillas
end type
type rb_semana from radiobutton within w_fl903_calculo_planillas
end type
type rb_rango from radiobutton within w_fl903_calculo_planillas
end type
type st_desc_especie from statictext within w_fl903_calculo_planillas
end type
type sle_especie from singlelineedit within w_fl903_calculo_planillas
end type
type st_1 from statictext within w_fl903_calculo_planillas
end type
type cb_2 from commandbutton within w_fl903_calculo_planillas
end type
type cb_1 from commandbutton within w_fl903_calculo_planillas
end type
type st_politica from statictext within w_fl903_calculo_planillas
end type
type st_3 from statictext within w_fl903_calculo_planillas
end type
type em_politica from editmask within w_fl903_calculo_planillas
end type
type gb_1 from groupbox within w_fl903_calculo_planillas
end type
end forward

global type w_fl903_calculo_planillas from w_abc
integer width = 2126
integer height = 920
string title = "Calculo de Planillas de Tripulantes (FL903)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
event ue_aceptar ( )
event ue_cancelar ( )
uo_fechas uo_fechas
sle_semana sle_semana
sle_year sle_year
rb_semana rb_semana
rb_rango rb_rango
st_desc_especie st_desc_especie
sle_especie sle_especie
st_1 st_1
cb_2 cb_2
cb_1 cb_1
st_politica st_politica
st_3 st_3
em_politica em_politica
gb_1 gb_1
end type
global w_fl903_calculo_planillas w_fl903_calculo_planillas

event ue_aceptar();string	ls_politica, ls_mensaje, ls_especie
date		ld_fecha1, ld_fecha2
Integer	li_year, li_Semana

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

ls_politica	= trim(em_politica.text)
ls_Especie	= trim(sle_especie.text)

if ls_politica = '' then
	MessageBox('ERROR', 'DEBE SELECCIONAR UNA POLITICA DE PAGO', StopSign!)
	return
end if

//create or replace procedure usp_fl_calculo_planillas(
//		adi_fecha1 		in  date,
//    adi_fecha2		in  date,
//    asi_politica 	in  fl_politica_pago.tipo_pol_pago%TYPE
//) is

DECLARE usp_fl_calculo_planillas PROCEDURE FOR
	usp_fl_calculo_planillas( :ld_fecha1, 
									  :ld_fecha2, 
									  :ls_especie,
									  :ls_politica);

EXECUTE usp_fl_calculo_planillas;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_fl_calculo_planillas: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 
END IF

CLOSE usp_fl_calculo_planillas;

MessageBox('AVISO', 'CALCULO DE PLANILLAS EFECTUADO SATISFACTORIAMENTE', Information!)



end event

event ue_cancelar();close(this)
end event

on w_fl903_calculo_planillas.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.uo_fechas=create uo_fechas
this.sle_semana=create sle_semana
this.sle_year=create sle_year
this.rb_semana=create rb_semana
this.rb_rango=create rb_rango
this.st_desc_especie=create st_desc_especie
this.sle_especie=create sle_especie
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_politica=create st_politica
this.st_3=create st_3
this.em_politica=create em_politica
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_fechas
this.Control[iCurrent+2]=this.sle_semana
this.Control[iCurrent+3]=this.sle_year
this.Control[iCurrent+4]=this.rb_semana
this.Control[iCurrent+5]=this.rb_rango
this.Control[iCurrent+6]=this.st_desc_especie
this.Control[iCurrent+7]=this.sle_especie
this.Control[iCurrent+8]=this.st_1
this.Control[iCurrent+9]=this.cb_2
this.Control[iCurrent+10]=this.cb_1
this.Control[iCurrent+11]=this.st_politica
this.Control[iCurrent+12]=this.st_3
this.Control[iCurrent+13]=this.em_politica
this.Control[iCurrent+14]=this.gb_1
end on

on w_fl903_calculo_planillas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_fechas)
destroy(this.sle_semana)
destroy(this.sle_year)
destroy(this.rb_semana)
destroy(this.rb_rango)
destroy(this.st_desc_especie)
destroy(this.sle_especie)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_politica)
destroy(this.st_3)
destroy(this.em_politica)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;Date 		ld_hoy
Integer	li_year, li_semana

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

type uo_fechas from u_ingreso_rango_fechas within w_fl903_calculo_planillas
event destroy ( )
integer x = 517
integer y = 160
integer height = 80
integer taborder = 50
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

type sle_semana from singlelineedit within w_fl903_calculo_planillas
integer x = 773
integer y = 52
integer width = 137
integer height = 80
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

type sle_year from singlelineedit within w_fl903_calculo_planillas
integer x = 544
integer y = 52
integer width = 229
integer height = 80
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

type rb_semana from radiobutton within w_fl903_calculo_planillas
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

type rb_rango from radiobutton within w_fl903_calculo_planillas
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

type st_desc_especie from statictext within w_fl903_calculo_planillas
integer x = 869
integer y = 300
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

type sle_especie from singlelineedit within w_fl903_calculo_planillas
event ue_dobleclick pbm_lbuttondblclk
integer x = 517
integer y = 300
integer width = 343
integer height = 80
integer taborder = 60
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

type st_1 from statictext within w_fl903_calculo_planillas
integer x = 69
integer y = 296
integer width = 421
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

type cb_2 from commandbutton within w_fl903_calculo_planillas
integer x = 1586
integer y = 540
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ca&ncelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar()
end event

type cb_1 from commandbutton within w_fl903_calculo_planillas
integer x = 1207
integer y = 540
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Calcular"
end type

event clicked;parent.event ue_aceptar()
end event

type st_politica from statictext within w_fl903_calculo_planillas
integer x = 869
integer y = 412
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

type st_3 from statictext within w_fl903_calculo_planillas
integer x = 32
integer y = 424
integer width = 457
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
string text = "Politica de Pago:"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_politica from editmask within w_fl903_calculo_planillas
event ue_display ( )
event ue_dblclick pbm_lbuttondblclk
event ue_keydown pbm_keydown
integer x = 517
integer y = 412
integer width = 343
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "##"
end type

event ue_display();string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

ls_sql = "SELECT TIPO_POL_PAGO AS CODIGO, " &
		 + "DESCR_POL_PAGO AS DESCRIPCION " &
       + "FROM FL_TIPO_POLITICA_PAGO " &
		 + "WHERE FLAG_ESTADO = '1'"
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)

IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
ELSE
	RETURN
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo = lstr_seleccionar.param1[1]
	ls_data   = lstr_seleccionar.param2[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UNA POLITICA DE PAGO", StopSign!)
	return 
end if
		
st_politica.text	= ls_data		
this.text			= ls_codigo

end event

event ue_dblclick;this.event ue_display()
end event

event ue_keydown;if key = KeyF2! then
	this.event ue_display()
end if
end event

event modified;string ls_politica, ls_texto, ls_estado
integer ln_count

ls_politica = trim(this.text)

select count(*)
	into :ln_count
from fl_tipo_politica_pago
where tipo_pol_pago = :ls_politica;

if ln_count = 0 then
	this.text 			= ''
	st_politica.text 	= ''
	MessageBox('ERROR', 'NO EXISTE POLITICA DE PAGO', StopSign!)
	return
end if

select descr_pol_pago, flag_estado
	into :ls_texto, :ls_estado
from fl_tipo_politica_pago
where tipo_pol_pago = :ls_politica;

if ls_estado <> '1' then
	this.text 		= ''
	st_politica.text 	= ''
	MessageBox('ERROR', 'POLITICA DE PAGO NO ESTA ACTIVA', StopSign!)
	return
end if

st_politica.text = ls_texto
end event

type gb_1 from groupbox within w_fl903_calculo_planillas
integer width = 2139
integer height = 260
integer taborder = 10
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

