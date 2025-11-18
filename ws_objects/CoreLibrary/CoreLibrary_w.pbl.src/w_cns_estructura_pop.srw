$PBExportHeader$w_cns_estructura_pop.srw
forward
global type w_cns_estructura_pop from w_cns
end type
type cb_expand from commandbutton within w_cns_estructura_pop
end type
type cb_lectura from commandbutton within w_cns_estructura_pop
end type
type sle_codigo from singlelineedit within w_cns_estructura_pop
end type
type tv_estructura from u_tv_estructura within w_cns_estructura_pop
end type
end forward

global type w_cns_estructura_pop from w_cns
integer width = 1047
integer height = 1540
boolean maxbox = false
boolean resizable = false
windowtype windowtype = popup!
cb_expand cb_expand
cb_lectura cb_lectura
sle_codigo sle_codigo
tv_estructura tv_estructura
end type
global w_cns_estructura_pop w_cns_estructura_pop

type variables
str_tv_estructura_pop istr_1
String		is_padre, is_articulo, is_descripcion
Long			il_handle, il_del_handle
end variables

on w_cns_estructura_pop.create
int iCurrent
call super::create
this.cb_expand=create cb_expand
this.cb_lectura=create cb_lectura
this.sle_codigo=create sle_codigo
this.tv_estructura=create tv_estructura
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_expand
this.Control[iCurrent+2]=this.cb_lectura
this.Control[iCurrent+3]=this.sle_codigo
this.Control[iCurrent+4]=this.tv_estructura
end on

on w_cns_estructura_pop.destroy
call super::destroy
destroy(this.cb_expand)
destroy(this.cb_lectura)
destroy(this.sle_codigo)
destroy(this.tv_estructura)
end on

event ue_open_pre();//Integer 		x				Ubicación x de la ventana pop
//Integer		y				Ubicación y de la ventana pop
//String			field			columna receptora.
//datawindow   dw          dw receptor

istr_1 = Message.PowerObjectParm						// lectura de parametros
tv_estructura.is_DataObject = 'd_estructura_ds' // asignar datawindow
tv_estructura.ii_numkey = 1  
THIS.x = istr_1.x									// asignar posicion x e y de la ventana
THIS.y = istr_1.y

sle_codigo.SetFocus()

end event

event open;//Override

THIS.EVENT ue_open_pre()
end event

event resize;call super::resize;tv_estructura.width  = newwidth  - tv_estructura.x - 10
tv_estructura.height = newheight - tv_estructura.y - 10
end event

type cb_expand from commandbutton within w_cns_estructura_pop
integer x = 809
integer y = 8
integer width = 192
integer height = 96
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Expand"
end type

event clicked;tv_estructura.ExpandAll(1)
end event

type cb_lectura from commandbutton within w_cns_estructura_pop
integer x = 603
integer y = 8
integer width = 192
integer height = 96
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Lectura"
end type

event clicked;String	ls_key, ls_label

ls_key = sle_codigo.text

SELECT "ARTICULO"."NOM_ARTICULO"  
  INTO :ls_label  
  FROM "ARTICULO"  
 WHERE "ARTICULO"."COD_ART" = :ls_key   ;

IF SQLCA.SQLCODE = 0 THEN
	is_padre = ls_key
	is_descripcion = ls_label
	tv_estructura.of_clear()
	tv_estructura.EVENT ue_populate(is_padre, is_descripcion)
ELSE
	MessageBox("Error en Base ", "No se Encuentra el Articulo")
END IF

end event

type sle_codigo from singlelineedit within w_cns_estructura_pop
integer x = 5
integer y = 8
integer width = 585
integer height = 88
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type tv_estructura from u_tv_estructura within w_cns_estructura_pop
integer y = 116
integer width = 997
integer height = 1304
integer taborder = 0
end type

event doubleclicked;call super::doubleclicked;TreeViewItem	ltvi_Target
Any				la_data

THIS.GetItem(handle, ltvi_Target)

la_data = ltvi_Target.data

istr_1.dw.SetColumn(istr_1.field)
istr_1.dw.SetText(la_data)

Close(Parent)

end event

