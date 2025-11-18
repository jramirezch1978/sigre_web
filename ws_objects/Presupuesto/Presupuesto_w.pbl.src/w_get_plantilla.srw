$PBExportHeader$w_get_plantilla.srw
forward
global type w_get_plantilla from window
end type
type cb_cancelar from commandbutton within w_get_plantilla
end type
type cb_buscar from commandbutton within w_get_plantilla
end type
type sle_plantilla from singlelineedit within w_get_plantilla
end type
type st_2 from statictext within w_get_plantilla
end type
end forward

global type w_get_plantilla from window
integer width = 1225
integer height = 380
boolean titlebar = true
string title = "Buscar Documento en Articulo Mov Proy"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_buscar ( )
event ue_cancelar ( )
cb_cancelar cb_cancelar
cb_buscar cb_buscar
sle_plantilla sle_plantilla
st_2 st_2
end type
global w_get_plantilla w_get_plantilla

type variables


end variables

event ue_buscar();string ls_plantilla
str_parametros lstr_param

ls_plantilla = sle_plantilla.text

if ls_plantilla = '' or IsNull(ls_plantilla) then
	MessageBox('Aviso', 'Codigo de Plantilla no existe')
	return
end if

lstr_param.titulo = 's'
lstr_param.string1 	= ls_plantilla

CloseWithReturn(this, lstr_param)
end event

event ue_cancelar();str_parametros lstr_param

lstr_param.titulo = 'n'

CloseWithReturn(this, lstr_param)
end event

on w_get_plantilla.create
this.cb_cancelar=create cb_cancelar
this.cb_buscar=create cb_buscar
this.sle_plantilla=create sle_plantilla
this.st_2=create st_2
this.Control[]={this.cb_cancelar,&
this.cb_buscar,&
this.sle_plantilla,&
this.st_2}
end on

on w_get_plantilla.destroy
destroy(this.cb_cancelar)
destroy(this.cb_buscar)
destroy(this.sle_plantilla)
destroy(this.st_2)
end on

type cb_cancelar from commandbutton within w_get_plantilla
integer x = 823
integer y = 160
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

type cb_buscar from commandbutton within w_get_plantilla
integer x = 823
integer y = 44
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

type sle_plantilla from singlelineedit within w_get_plantilla
event dobleclick pbm_lbuttondblclk
integer x = 325
integer y = 104
integer width = 402
integer height = 88
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_cod_art, ls_data, ls_sql

ls_sql = "SELECT a.cod_plantilla AS codigo_plantilla, " &
		 + "a.cod_art AS codigo_Articulo, " &
		 + "a.forma_embarque AS forma_de_embarque, " &
		 + "a.descripcion AS descripcion_plantilla " &
		 + "FROM presup_plant a " 
		 
lb_ret = f_lista(ls_sql, ls_data, ls_cod_art, '1')
		
if ls_data <> '' then
	this.text = ls_data
end if
end event

type st_2 from statictext within w_get_plantilla
integer x = 41
integer y = 112
integer width = 274
integer height = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Plantilla:"
alignment alignment = right!
boolean focusrectangle = false
end type

