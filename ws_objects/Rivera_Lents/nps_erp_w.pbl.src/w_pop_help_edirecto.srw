$PBExportHeader$w_pop_help_edirecto.srw
forward
global type w_pop_help_edirecto from window
end type
type cb_cancelar from commandbutton within w_pop_help_edirecto
end type
type cb_2 from commandbutton within w_pop_help_edirecto
end type
type sle_2 from singlelineedit within w_pop_help_edirecto
end type
type st_1 from statictext within w_pop_help_edirecto
end type
type sle_1 from singlelineedit within w_pop_help_edirecto
end type
type cb_1 from commandbutton within w_pop_help_edirecto
end type
end forward

global type w_pop_help_edirecto from window
integer width = 2574
integer height = 328
boolean titlebar = true
string title = "Ingrese Codigo de Relación"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cb_cancelar cb_cancelar
cb_2 cb_2
sle_2 sle_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
end type
global w_pop_help_edirecto w_pop_help_edirecto

on w_pop_help_edirecto.create
this.cb_cancelar=create cb_cancelar
this.cb_2=create cb_2
this.sle_2=create sle_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.Control[]={this.cb_cancelar,&
this.cb_2,&
this.sle_2,&
this.st_1,&
this.sle_1,&
this.cb_1}
end on

on w_pop_help_edirecto.destroy
destroy(this.cb_cancelar)
destroy(this.cb_2)
destroy(this.sle_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

//f_centrar(This)


IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	sle_1.text = lstr_param.string3
	SELECT nombre INTO :sle_2.text FROM codigo_relacion WHERE cod_relacion = :sle_1.text;
END IF
//**//




end event

type cb_cancelar from commandbutton within w_pop_help_edirecto
integer x = 2190
integer y = 112
integer width = 343
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.bret = false

CloseWithReturn(Parent,lstr_param)
end event

type cb_2 from commandbutton within w_pop_help_edirecto
integer x = 462
integer y = 108
integer width = 91
integer height = 80
integer taborder = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;Str_seleccionar lstr_seleccionar
				
lstr_seleccionar.s_seleccion = 'S'
lstr_seleccionar.s_sql = 'SELECT distinct P.proveedor AS CODIGO ,'&
							  + 'P.NOM_PROVEEDOR AS RAZON_SOCIAL, '&
							  + 'P.RUC AS RUC '&
							  + 'FROM proveedor p, '&
							  + "cntas_cobrar cc " &
							  + "WHERE cc.cod_relacion = p.proveedor " &
							  + "  and cc.flag_estado = '1' " &
							  + "  and (cc.saldo_sol > 0 or cc.saldo_dol > 0) " &
							  + "  and p.FLAG_ESTADO = '1'"
							  
OpenWithParm(w_seleccionar,lstr_seleccionar)
IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm

IF lstr_seleccionar.s_action = "aceptar" THEN
	sle_1.text = lstr_seleccionar.param1[1]
	sle_2.text = lstr_seleccionar.param2[1]
END IF
				
end event

type sle_2 from singlelineedit within w_pop_help_edirecto
integer x = 608
integer y = 108
integer width = 1449
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 12632256
boolean border = false
end type

type st_1 from statictext within w_pop_help_edirecto
integer x = 23
integer y = 28
integer width = 471
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Codigo Relacion :"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_pop_help_edirecto
integer x = 23
integer y = 108
integer width = 430
integer height = 80
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event modified;String ls_cod_relacion,ls_nom_relacion

ls_cod_relacion = sle_1.text

SELECT nombre INTO :ls_nom_relacion FROM codigo_relacion WHERE cod_relacion = :ls_cod_relacion ;

IF Isnull(ls_nom_relacion) OR Trim(ls_nom_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relacion Valido, Verifique')
	This.text = ''
ELSE
	sle_2.text = ls_nom_relacion
END IF
end event

type cb_1 from commandbutton within w_pop_help_edirecto
integer x = 2190
integer y = 8
integer width = 343
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
end type

event clicked;str_parametros lstr_param


IF Isnull(sle_1.text) OR Trim(sle_1.text) = '' THEN
	Messagebox('Aviso','Debe Ingresar Un Codigo de Relacion Valido !')
	Return
END IF

lstr_param.string3 = sle_1.text 
lstr_param.bret = true

CloseWithReturn(Parent,lstr_param)
end event

