$PBExportHeader$w_prompt_lbs.srw
forward
global type w_prompt_lbs from window
end type
type ddlb_1 from dropdownlistbox within w_prompt_lbs
end type
type cb_sql from commandbutton within w_prompt_lbs
end type
type sle_return from singlelineedit within w_prompt_lbs
end type
type st_titulo from statictext within w_prompt_lbs
end type
type p_1 from picture within w_prompt_lbs
end type
type cb_cancelar from commandbutton within w_prompt_lbs
end type
type cb_aceptar from commandbutton within w_prompt_lbs
end type
end forward

global type w_prompt_lbs from window
integer width = 3081
integer height = 532
boolean titlebar = true
string title = "Ingrese dato solicitado..."
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
ddlb_1 ddlb_1
cb_sql cb_sql
sle_return sle_return
st_titulo st_titulo
p_1 p_1
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
end type
global w_prompt_lbs w_prompt_lbs

type variables
string is_sql
end variables

on w_prompt_lbs.create
this.ddlb_1=create ddlb_1
this.cb_sql=create cb_sql
this.sle_return=create sle_return
this.st_titulo=create st_titulo
this.p_1=create p_1
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.Control[]={this.ddlb_1,&
this.cb_sql,&
this.sle_return,&
this.st_titulo,&
this.p_1,&
this.cb_cancelar,&
this.cb_aceptar}
end on

on w_prompt_lbs.destroy
destroy(this.ddlb_1)
destroy(this.cb_sql)
destroy(this.sle_return)
destroy(this.st_titulo)
destroy(this.p_1)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
end on

event open;str_parametros lstr_param

lstr_param = Message.PowerObjectParm

ddlb_1.SelectItem(lstr_param.string1, 1)

sle_return.text = lstr_param.string2
st_titulo.text = lstr_param.titulo


if trim(lstr_param.sql_text) <> '' then
	cb_sql.visible = true
	cb_sql.enabled = true
	is_sql = lstr_param.sql_text
else
	cb_sql.visible = false
	cb_sql.enabled = false
end if


end event

type ddlb_1 from dropdownlistbox within w_prompt_lbs
integer x = 635
integer y = 192
integer width = 1842
integer height = 352
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean vscrollbar = true
string item[] = {"1 - REMUNERACION COMPUTABLE","2 - GRATIFICACION TRUNCA","3 - CTS TRUNCA","4 - VACACIONES TRUNCAS","5 - DESCUENTO ONP/SNP","6 - DESCUENTOS CNTA CORRIENTE","7 - DESCUENTO RENTA QUINTA","8 - OTROS INGRESOS / DESCUENTOS","9 - APORTACIONES"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;sle_return.text = this.Text

if left(this.text,1) <> '8' then
	//sle_return.DisplayOnly = true
else
	//sle_return.DisplayOnly = false
end if
end event

type cb_sql from commandbutton within w_prompt_lbs
boolean visible = false
integer x = 2487
integer y = 304
integer width = 128
integer height = 100
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean 	lb_ret
String 	ls_codigo, ls_data

lb_ret = f_lista(is_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_return.text = ls_codigo
end if
end event

type sle_return from singlelineedit within w_prompt_lbs
integer x = 635
integer y = 304
integer width = 1842
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_titulo from statictext within w_prompt_lbs
integer x = 640
integer y = 44
integer width = 1975
integer height = 100
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
boolean focusrectangle = false
end type

type p_1 from picture within w_prompt_lbs
integer width = 562
integer height = 304
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type cb_cancelar from commandbutton within w_prompt_lbs
integer x = 2656
integer y = 168
integer width = 402
integer height = 112
integer taborder = 10
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

lstr_param.i_return = -1

CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_prompt_lbs
integer x = 2656
integer y = 36
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

lstr_param.string1 = left(ddlb_1.text,1)
lstr_param.string2 = trim(sle_return.text)
lstr_param.i_return = 1

CloseWithReturn(parent, lstr_param)
end event

