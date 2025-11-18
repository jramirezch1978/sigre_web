$PBExportHeader$w_abc_help_fecha.srw
forward
global type w_abc_help_fecha from window
end type
type uo_1 from u_ingreso_rango_fechas within w_abc_help_fecha
end type
type cb_1 from commandbutton within w_abc_help_fecha
end type
end forward

global type w_abc_help_fecha from window
integer width = 1943
integer height = 360
boolean titlebar = true
string title = "Ingrese Fecha de Trabajo"
windowtype windowtype = response!
long backcolor = 67108864
uo_1 uo_1
cb_1 cb_1
end type
global w_abc_help_fecha w_abc_help_fecha

type variables
Str_cns_pop istr_cns_pop
end variables

on w_abc_help_fecha.create
this.uo_1=create uo_1
this.cb_1=create cb_1
this.Control[]={this.uo_1,&
this.cb_1}
end on

on w_abc_help_fecha.destroy
destroy(this.uo_1)
destroy(this.cb_1)
end on

event open;f_centrar(this)
//

istr_cns_pop = Message.PowerObjectParm					// lectura de parametros
end event

type uo_1 from u_ingreso_rango_fechas within w_abc_help_fecha
integer x = 18
integer y = 44
integer taborder = 20
end type

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

event constructor;call super::constructor; string ls_inicio 

 of_set_label('Desde','Hasta') //para setear la fecha inicial

//Obtenemos el Primer dia del Mes

ls_inicio='01'+'/'+string(month(today()))+'/'+string(year(today()))

 of_set_fecha(date(ls_inicio),today())
 of_set_rango_inicio(date('01/01/1900')) // rango inicial
 of_set_rango_fin(date('31/12/9999')) // rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas
 
//Controles a Observar en el Windows

end event

type cb_1 from commandbutton within w_abc_help_fecha
integer x = 1490
integer y = 32
integer width = 389
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;String ls_fec_ini,ls_fec_fin


ls_fec_ini = String(uo_1.of_get_fecha1(),'yyyymmdd')
ls_fec_fin = String(uo_1.of_get_fecha2(),'yyyymmdd')



istr_cns_pop.arg[2] = ls_fec_ini
istr_cns_pop.arg[3] = ls_fec_fin

CloseWithReturn(Parent, istr_cns_pop)



end event

