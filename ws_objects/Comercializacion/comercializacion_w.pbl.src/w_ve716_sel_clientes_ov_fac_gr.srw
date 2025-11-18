$PBExportHeader$w_ve716_sel_clientes_ov_fac_gr.srw
forward
global type w_ve716_sel_clientes_ov_fac_gr from w_abc_list
end type
type cb_4 from commandbutton within w_ve716_sel_clientes_ov_fac_gr
end type
type st_1 from statictext within w_ve716_sel_clientes_ov_fac_gr
end type
type dw_text from datawindow within w_ve716_sel_clientes_ov_fac_gr
end type
end forward

global type w_ve716_sel_clientes_ov_fac_gr from w_abc_list
integer width = 2235
string title = "Selecciona"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
cb_4 cb_4
st_1 st_1
dw_text dw_text
end type
global w_ve716_sel_clientes_ov_fac_gr w_ve716_sel_clientes_ov_fac_gr

type variables
u_dw_abc  idw_otro
integer ii_tipo, ii_mes, ii_ano
String is_col = '', is_type
end variables

on w_ve716_sel_clientes_ov_fac_gr.create
int iCurrent
call super::create
this.cb_4=create cb_4
this.st_1=create st_1
this.dw_text=create dw_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_4
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_text
end on

on w_ve716_sel_clientes_ov_fac_gr.destroy
call super::destroy
destroy(this.cb_4)
destroy(this.st_1)
destroy(this.dw_text)
end on

event ue_open_pre();call super::ue_open_pre;
dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)


dw_1.Retrieve()

end event

event resize;call super::resize;dw_1.height = newheight - dw_1.y - 10
dw_2.height = newheight - dw_2.y - 10
end event

type dw_1 from w_abc_list`dw_1 within w_ve716_sel_clientes_ov_fac_gr
integer y = 144
integer width = 974
integer height = 868
integer taborder = 30
string dataobject = "d_sel_proveedor_ov"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;ii_ss = 0

ii_ck[1] = 1 
ii_dk[1] = 1 
ii_dk[2] = 2 
ii_rk[1] = 1 
ii_rk[2] = 2 

ii_access = 1
end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)

end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column 
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
//messagebox( ls_column, li_pos)
IF li_pos > 0 THEN
	is_col = mid(ls_column,1,li_pos - 1)
	
	st_1.text = "Busca x: " + dw_1.describe( is_col + "_t.text")
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF

end event

type dw_2 from w_abc_list`dw_2 within w_ve716_sel_clientes_ov_fac_gr
integer x = 1202
integer y = 144
integer width = 974
integer height = 868
integer taborder = 60
string dataobject = "d_dddw_proveedor"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;ii_ck[1] = 1 
ii_dk[1] = 1 
ii_dk[2] = 2 
ii_rk[1] = 1 
ii_rk[2] = 2 
end event

event dw_2::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_det.ScrollToRow(ll_row)



end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

type pb_1 from w_abc_list`pb_1 within w_ve716_sel_clientes_ov_fac_gr
event ue_clicked_pre ( )
integer x = 1029
integer y = 480
integer taborder = 40
end type

event ue_clicked_pre;idw_otro = dw_2
end event

type pb_2 from w_abc_list`pb_2 within w_ve716_sel_clientes_ov_fac_gr
integer x = 1029
integer y = 636
integer taborder = 50
end type

type cb_4 from commandbutton within w_ve716_sel_clientes_ov_fac_gr
integer x = 1742
integer y = 20
integer width = 347
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Procesa"
end type

event clicked;// Llena tabla temporal

Long 	ll_row
String ls_dato1, ls_dato2
Date ld_fecha

ld_fecha = today()
delete from tt_alm_seleccion;

FOR ll_row = 1 to dw_2.rowcount()
	ls_dato1 = dw_2.object.proveedor[ll_row]	
	Insert into tt_alm_seleccion(cencos) 
	  values ( :ls_dato1);	
	If sqlca.sqlcode = -1 then
		messagebox("Error al insertar registro",sqlca.sqlerrtext)
	END IF
NEXT

close (parent)
end event

type st_1 from statictext within w_ve716_sel_clientes_ov_fac_gr
integer x = 50
integer y = 40
integer width = 402
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_ve716_sel_clientes_ov_fac_gr
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 370
integer y = 20
integer width = 1157
integer height = 80
integer taborder = 100
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_text.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_1.Getrow()
return  0
//dw_lista.SelectRow(0, false)
//dw_lista.SelectRow(ll_row, true)
//dw_1.object.campo[1] = dw_lista.GetItemString(ll_row, is_col)
end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
dw_1.triggerevent(doubleclicked!)
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
Long ll_fila, li_x

SetPointer(hourglass!)

String ls_campo

if TRIM( is_col) <> '' THEN

	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)	
	if li_longitud > 0 then		// si ha escrito algo	   
	   IF UPPER( is_type) = 'N' then
			ls_comando = is_col + "=" + ls_item 
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF

		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())	
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
else
	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
	dw_text.reset()
	this.insertrow(0)
end if	
SetPointer(arrow!)
end event

