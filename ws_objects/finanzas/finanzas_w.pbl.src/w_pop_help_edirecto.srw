$PBExportHeader$w_pop_help_edirecto.srw
forward
global type w_pop_help_edirecto from window
end type
type cbx_1 from checkbox within w_pop_help_edirecto
end type
type cb_3 from commandbutton within w_pop_help_edirecto
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
integer width = 2450
integer height = 364
boolean titlebar = true
string title = "Ingrese Codigo de Relación"
windowtype windowtype = response!
long backcolor = 67108864
boolean center = true
cbx_1 cbx_1
cb_3 cb_3
cb_2 cb_2
sle_2 sle_2
st_1 st_1
sle_1 sle_1
cb_1 cb_1
end type
global w_pop_help_edirecto w_pop_help_edirecto

on w_pop_help_edirecto.create
this.cbx_1=create cbx_1
this.cb_3=create cb_3
this.cb_2=create cb_2
this.sle_2=create sle_2
this.st_1=create st_1
this.sle_1=create sle_1
this.cb_1=create cb_1
this.Control[]={this.cbx_1,&
this.cb_3,&
this.cb_2,&
this.sle_2,&
this.st_1,&
this.sle_1,&
this.cb_1}
end on

on w_pop_help_edirecto.destroy
destroy(this.cbx_1)
destroy(this.cb_3)
destroy(this.cb_2)
destroy(this.sle_2)
destroy(this.st_1)
destroy(this.sle_1)
destroy(this.cb_1)
end on

event open;str_parametros lstr_param

IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	sle_1.text = lstr_param.string3
	SELECT nom_proveedor
		INTO :sle_2.text 
	FROM proveedor
	WHERE proveedor = :sle_1.text;
END IF
//**//




end event

type cbx_1 from checkbox within w_pop_help_edirecto
integer x = 603
integer y = 20
integer width = 1362
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar todos los proveedores"
end type

event clicked;if this.checked then
	sle_1.enabled 	= false
	cb_2.enabled	= false
else
	sle_1.enabled 	= true
	cb_2.enabled	= true
end if
end event

type cb_3 from commandbutton within w_pop_help_edirecto
integer x = 2080
integer y = 120
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

lstr_param.titulo = 'n'

CloseWithReturn(Parent,lstr_param)
end event

type cb_2 from commandbutton within w_pop_help_edirecto
integer x = 462
integer y = 120
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

event clicked;String 	ls_Sql, ls_codigo, ls_data
boolean	lb_ret

ls_sql = "SELECT p.proveedor AS CODIGO ,"&
		  + "p.NOM_PROVEEDOR AS nombre_proveedor, "&
		  + "p.NRO_DOC_IDENT as doc_identidad, " &
		  + "p.ruc as ruc_proveedor " &
		  + "FROM proveedor p " &
		  + "where flag_Estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, "2")

if ls_codigo <> "" then
	sle_1.text = ls_codigo
	sle_2.text = ls_data
END IF
				
end event

type sle_2 from singlelineedit within w_pop_help_edirecto
integer x = 567
integer y = 120
integer width = 1486
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
integer y = 120
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
integer x = 2080
integer y = 28
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

if cbx_1.checked then
	lstr_param.string3 = '%%'
else
	IF Isnull(sle_1.text) OR Trim(sle_1.text) = '' THEN
		Messagebox('Aviso','Debe Ingresar Un Codigo de Relacion Valido !')
		Return
	END IF
	
	lstr_param.string3 = trim(sle_1.text) + '%'
end if

CloseWithReturn(Parent,lstr_param)
end event

