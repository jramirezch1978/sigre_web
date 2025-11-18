$PBExportHeader$w_get_datos_copia.srw
forward
global type w_get_datos_copia from window
end type
type sle_trab2 from singlelineedit within w_get_datos_copia
end type
type st_trab2 from statictext within w_get_datos_copia
end type
type st_6 from statictext within w_get_datos_copia
end type
type st_3 from statictext within w_get_datos_copia
end type
type st_2 from statictext within w_get_datos_copia
end type
type sle_mes2 from singlelineedit within w_get_datos_copia
end type
type sle_mes1 from singlelineedit within w_get_datos_copia
end type
type st_1 from statictext within w_get_datos_copia
end type
type st_trab1 from statictext within w_get_datos_copia
end type
type sle_trab1 from singlelineedit within w_get_datos_copia
end type
type cb_cancelar from commandbutton within w_get_datos_copia
end type
type cb_buscar from commandbutton within w_get_datos_copia
end type
type gb_1 from groupbox within w_get_datos_copia
end type
type gb_2 from groupbox within w_get_datos_copia
end type
end forward

global type w_get_datos_copia from window
integer width = 2176
integer height = 608
boolean titlebar = true
string title = "Ingrese los datos Solicitados"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_buscar ( )
event ue_cancelar ( )
sle_trab2 sle_trab2
st_trab2 st_trab2
st_6 st_6
st_3 st_3
st_2 st_2
sle_mes2 sle_mes2
sle_mes1 sle_mes1
st_1 st_1
st_trab1 st_trab1
sle_trab1 sle_trab1
cb_cancelar cb_cancelar
cb_buscar cb_buscar
gb_1 gb_1
gb_2 gb_2
end type
global w_get_datos_copia w_get_datos_copia

type variables
Integer ii_year
end variables

event ue_buscar();Integer 	li_mes1, li_mes2
String	ls_trab1, ls_trab2

str_parametros lstr_param

li_mes1 = Integer(sle_mes1.text)
li_mes2 = Integer(sle_mes2.text)
ls_trab1 = sle_trab1.text
ls_trab2 = sle_trab2.text

lstr_param.titulo = 's'

lstr_param.int1 	 = li_mes1
lstr_param.int2 	 = li_mes2
lstr_param.string1 = ls_trab1
lstr_param.string2 = ls_trab2

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_get_datos_copia.create
this.sle_trab2=create sle_trab2
this.st_trab2=create st_trab2
this.st_6=create st_6
this.st_3=create st_3
this.st_2=create st_2
this.sle_mes2=create sle_mes2
this.sle_mes1=create sle_mes1
this.st_1=create st_1
this.st_trab1=create st_trab1
this.sle_trab1=create sle_trab1
this.cb_cancelar=create cb_cancelar
this.cb_buscar=create cb_buscar
this.gb_1=create gb_1
this.gb_2=create gb_2
this.Control[]={this.sle_trab2,&
this.st_trab2,&
this.st_6,&
this.st_3,&
this.st_2,&
this.sle_mes2,&
this.sle_mes1,&
this.st_1,&
this.st_trab1,&
this.sle_trab1,&
this.cb_cancelar,&
this.cb_buscar,&
this.gb_1,&
this.gb_2}
end on

on w_get_datos_copia.destroy
destroy(this.sle_trab2)
destroy(this.st_trab2)
destroy(this.st_6)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.sle_mes2)
destroy(this.sle_mes1)
destroy(this.st_1)
destroy(this.st_trab1)
destroy(this.sle_trab1)
destroy(this.cb_cancelar)
destroy(this.cb_buscar)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event open;str_parametros lstr_param

if IsNull(Message.Powerobjectparm) or not IsValid(Message.Powerobjectparm) or &
	Message.powerobjectparm.Classname() <> 'str_parametros' then 
	close(this)
end if

lstr_param = Message.Powerobjectparm

sle_trab1.text = lstr_param.string1
st_trab1.text  = lstr_param.string2
ii_year		   = lstr_param.int1
end event

type sle_trab2 from singlelineedit within w_get_datos_copia
event ue_dobleclick pbm_lbuttondblclk
integer x = 379
integer y = 384
integer width = 343
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event ue_dobleclick;boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

ls_sql = "SELECT distinct a.cod_trabajador AS CODIGO_trabajador, " &
		  + "a.nom_trabajador AS nombre_trabajador " &
		  + "FROM vw_pr_trabajador a, " &
		  + "prsp_proy_hrs_obrero b " &
		  + "where a.cod_trabajador = b.cod_trabajador " &
		  + "and a.flag_estado = '1' " &
		  + "and b.ANO = " + string(ii_year)
			 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	this.text		= ls_codigo
	st_trab2.text	= ls_data
end if

return

end event

event modified;string ls_desc, ls_codigo

ls_codigo = this.text

select nom_trabajador
  into :ls_desc
 from vw_pr_trabajador
where cod_trabajador = :ls_codigo;

st_2.text = ls_desc
end event

type st_trab2 from statictext within w_get_datos_copia
integer x = 731
integer y = 384
integer width = 997
integer height = 84
integer textsize = -8
integer weight = 700
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

type st_6 from statictext within w_get_datos_copia
integer x = 23
integer y = 384
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador:"
boolean focusrectangle = false
end type

type st_3 from statictext within w_get_datos_copia
integer x = 558
integer y = 184
integer width = 302
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Final:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_get_datos_copia
integer x = 23
integer y = 184
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mes Inicial:"
boolean focusrectangle = false
end type

type sle_mes2 from singlelineedit within w_get_datos_copia
integer x = 869
integer y = 184
integer width = 151
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "12"
borderstyle borderstyle = stylelowered!
end type

type sle_mes1 from singlelineedit within w_get_datos_copia
integer x = 379
integer y = 184
integer width = 151
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_get_datos_copia
integer x = 23
integer y = 68
integer width = 343
integer height = 84
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Trabajador:"
boolean focusrectangle = false
end type

type st_trab1 from statictext within w_get_datos_copia
integer x = 731
integer y = 68
integer width = 997
integer height = 84
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

type sle_trab1 from singlelineedit within w_get_datos_copia
integer x = 379
integer y = 68
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16711680
long backcolor = 67108864
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancelar from commandbutton within w_get_datos_copia
integer x = 1774
integer y = 152
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cancelar()
end event

type cb_buscar from commandbutton within w_get_datos_copia
integer x = 1774
integer y = 36
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;parent.event dynamic ue_buscar()

end event

type gb_1 from groupbox within w_get_datos_copia
integer width = 1765
integer height = 312
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Origen"
end type

type gb_2 from groupbox within w_get_datos_copia
integer y = 316
integer width = 1765
integer height = 180
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos Destino"
end type

