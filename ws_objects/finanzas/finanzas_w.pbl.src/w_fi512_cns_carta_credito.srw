$PBExportHeader$w_fi512_cns_carta_credito.srw
forward
global type w_fi512_cns_carta_credito from window
end type
type cb_1 from commandbutton within w_fi512_cns_carta_credito
end type
type dw_1 from datawindow within w_fi512_cns_carta_credito
end type
type st_campo from statictext within w_fi512_cns_carta_credito
end type
type dw_3 from datawindow within w_fi512_cns_carta_credito
end type
end forward

global type w_fi512_cns_carta_credito from window
integer width = 2217
integer height = 1528
boolean titlebar = true
string title = "Consulta Carta Credito (FI512)"
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
dw_1 dw_1
st_campo st_campo
dw_3 dw_3
end type
global w_fi512_cns_carta_credito w_fi512_cns_carta_credito

type variables
String is_col,is_tipo
end variables

on w_fi512_cns_carta_credito.create
this.cb_1=create cb_1
this.dw_1=create dw_1
this.st_campo=create st_campo
this.dw_3=create dw_3
this.Control[]={this.cb_1,&
this.dw_1,&
this.st_campo,&
this.dw_3}
end on

on w_fi512_cns_carta_credito.destroy
destroy(this.cb_1)
destroy(this.dw_1)
destroy(this.st_campo)
destroy(this.dw_3)
end on

event open;String ls_ot_adm

is_col = 'nom_banco'
is_tipo = LEFT( dw_1.Describe(is_col + ".ColType"),1)	

st_campo.text = "Orden: " + is_col

ls_ot_adm = Message.StringParm

dw_1.retrieve(ls_ot_adm)
end event

type cb_1 from commandbutton within w_fi512_cns_carta_credito
integer x = 878
integer y = 1336
integer width = 379
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cerrar"
end type

event clicked;Close(Parent)
end event

type dw_1 from datawindow within w_fi512_cns_carta_credito
integer x = 46
integer y = 136
integer width = 2139
integer height = 1152
integer taborder = 20
string dragicon = "H:\Source\ICO\snap.ico"
string title = "none"
string dataobject = "d_abc_lista_ov_ccredito_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event clicked;This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)


This.Drag(Begin!)
end event

event constructor;Settransobject(sqlca)

end event

event doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
//	is_tipo = 
	is_col  = UPPER( mid(ls_column,1,li_pos - 1) )	
	is_tipo = LEFT( this.Describe(is_col + ".ColType"),1)	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_3.reset()
	dw_3.InsertRow(0)
	dw_3.SetFocus()

END IF
end event

event rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type st_campo from statictext within w_fi512_cns_carta_credito
integer x = 59
integer y = 24
integer width = 713
integer height = 92
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Busqueda :"
boolean focusrectangle = false
end type

type dw_3 from datawindow within w_fi512_cns_carta_credito
event ue_tecla pbm_dwnkey
event dw_enter pbm_dwnprocessenter
integer x = 823
integer y = 16
integer width = 974
integer height = 80
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if

ll_row = dw_3.Getrow()

Return 1
end event

event dw_enter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
	//	ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		IF Upper( is_tipo) = 'N' OR UPPER( is_tipo) = 'D' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_tipo) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
			dw_3.Setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

