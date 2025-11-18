$PBExportHeader$w_pt319_copiar.srw
forward
global type w_pt319_copiar from w_abc
end type
type st_6 from statictext within w_pt319_copiar
end type
type em_fecha2 from editmask within w_pt319_copiar
end type
type st_5 from statictext within w_pt319_copiar
end type
type st_4 from statictext within w_pt319_copiar
end type
type sle_descripcion from singlelineedit within w_pt319_copiar
end type
type em_fecha1 from editmask within w_pt319_copiar
end type
type em_semana from editmask within w_pt319_copiar
end type
type em_year from editmask within w_pt319_copiar
end type
type st_3 from statictext within w_pt319_copiar
end type
type st_2 from statictext within w_pt319_copiar
end type
type st_1 from statictext within w_pt319_copiar
end type
type cb_2 from commandbutton within w_pt319_copiar
end type
type cb_1 from commandbutton within w_pt319_copiar
end type
end forward

global type w_pt319_copiar from w_abc
integer width = 2418
integer height = 1092
string title = "[PT319] Ingresar o Datos "
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
st_6 st_6
em_fecha2 em_fecha2
st_5 st_5
st_4 st_4
sle_descripcion sle_descripcion
em_fecha1 em_fecha1
em_semana em_semana
em_year em_year
st_3 st_3
st_2 st_2
st_1 st_1
cb_2 cb_2
cb_1 cb_1
end type
global w_pt319_copiar w_pt319_copiar

type variables
str_parametros istr_param
Long	il_find
end variables

event ue_aceptar();str_parametros	lstr_param

lstr_param.long1 = Long(em_year.text)
lstr_param.long2 = Long(em_semana.text)
lstr_param.date1 = Date(em_fecha1.text)
lstr_param.date2 = Date(em_fecha2.text)
lstr_param.string1 = sle_descripcion.text

lstr_param.titulo = 's'
CloseWithReturn(this, lstr_param)

end event

on w_pt319_copiar.create
int iCurrent
call super::create
this.st_6=create st_6
this.em_fecha2=create em_fecha2
this.st_5=create st_5
this.st_4=create st_4
this.sle_descripcion=create sle_descripcion
this.em_fecha1=create em_fecha1
this.em_semana=create em_semana
this.em_year=create em_year
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_2=create cb_2
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_6
this.Control[iCurrent+2]=this.em_fecha2
this.Control[iCurrent+3]=this.st_5
this.Control[iCurrent+4]=this.st_4
this.Control[iCurrent+5]=this.sle_descripcion
this.Control[iCurrent+6]=this.em_fecha1
this.Control[iCurrent+7]=this.em_semana
this.Control[iCurrent+8]=this.em_year
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.st_2
this.Control[iCurrent+11]=this.st_1
this.Control[iCurrent+12]=this.cb_2
this.Control[iCurrent+13]=this.cb_1
end on

on w_pt319_copiar.destroy
call super::destroy
destroy(this.st_6)
destroy(this.em_fecha2)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.sle_descripcion)
destroy(this.em_fecha1)
destroy(this.em_semana)
destroy(this.em_year)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_2)
destroy(this.cb_1)
end on

event open;// Ancestor Script has been Override
THIS.EVENT ue_open_pre()


end event

event ue_open_pre;call super::ue_open_pre;DateTime	ldt_now
Integer	li_year, li_Semana
Date		ld_fecha1, ld_fecha2

try 
	ldt_now = gnvo_app.of_fecha_actual()
	
	//Obtengo el año y la semana
	li_year = year(Date(ldt_now))
	
	li_Semana = gnvo_app.of_get_semana(Date(ldt_now))
	gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
	
	em_year.text 	= string(li_year)
	em_semana.text	= string(li_Semana)
	em_fecha1.text = string(ld_fecha1, 'dd/mm/yyyy')
	em_fecha2.text = string(ld_fecha1, 'dd/mm/yyyy')
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception, ' + ex.getMessage() + ', por favor verifique')

end try
end event

type st_6 from statictext within w_pt319_copiar
integer y = 136
integer width = 334
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Descripcion :"
alignment alignment = right!
boolean focusrectangle = false
end type

type em_fecha2 from editmask within w_pt319_copiar
integer x = 1998
integer y = 32
integer width = 370
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type st_5 from statictext within w_pt319_copiar
integer x = 1646
integer y = 28
integer width = 329
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Fin :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pt319_copiar
integer x = 910
integer y = 28
integer width = 329
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Fecha Inicio :"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_descripcion from singlelineedit within w_pt319_copiar
integer y = 220
integer width = 2395
integer height = 612
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 1000
borderstyle borderstyle = stylelowered!
end type

type em_fecha1 from editmask within w_pt319_copiar
integer x = 1262
integer y = 28
integer width = 370
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = datemask!
string mask = "dd/mm/yyyy"
boolean dropdowncalendar = true
end type

type em_semana from editmask within w_pt319_copiar
integer x = 704
integer y = 28
integer width = 187
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
end type

event modified;Integer 	li_year, li_semana
Date		ld_fecha1, ld_Fecha2



try 
	// Verifica que codigo ingresado exista			
	li_year 		= Integer(em_year.text)
	li_semana 	= Integer(em_Semana.text)
	
	gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
	
	em_Fecha1.text = string(ld_fecha1, 'dd/mm/yyyy')
	em_Fecha2.text = string(ld_fecha2, 'dd/mm/yyyy')
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción, por favor verifique. Excepcion: ' + ex.getMessage())
	
end try

end event

type em_year from editmask within w_pt319_copiar
integer x = 201
integer y = 28
integer width = 288
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
alignment alignment = right!
borderstyle borderstyle = stylelowered!
string mask = "0000"
boolean spin = true
double increment = 1
end type

event modified;Integer 	li_year, li_semana
Date		ld_fecha1, ld_Fecha2



try 
	// Verifica que codigo ingresado exista			
	li_year 		= Integer(em_year.text)
	li_semana 	= Integer(em_Semana.text)
	
	gnvo_app.of_get_fechas( li_year, li_Semana, ld_fecha1, ld_fecha2)
	
	em_Fecha1.text = string(ld_fecha1, 'dd/mm/yyyy')
	em_Fecha2.text = string(ld_fecha2, 'dd/mm/yyyy')
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepción, por favor verifique. Excepcion: ' + ex.getMessage())
	
end try

end event

type st_3 from statictext within w_pt319_copiar
integer x = 494
integer y = 28
integer width = 201
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes :"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_pt319_copiar
integer y = 28
integer width = 197
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type st_1 from statictext within w_pt319_copiar
integer y = 28
integer width = 197
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Año :"
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pt319_copiar
integer x = 1984
integer y = 868
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn( parent, lstr_param)
end event

type cb_1 from commandbutton within w_pt319_copiar
integer x = 1554
integer y = 868
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;parent.event ue_aceptar()
end event

