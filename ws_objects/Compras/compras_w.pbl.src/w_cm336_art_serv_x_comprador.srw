$PBExportHeader$w_cm336_art_serv_x_comprador.srw
forward
global type w_cm336_art_serv_x_comprador from w_abc_list
end type
type st_campo from statictext within w_cm336_art_serv_x_comprador
end type
type dw_text from datawindow within w_cm336_art_serv_x_comprador
end type
type cb_1 from commandbutton within w_cm336_art_serv_x_comprador
end type
type sle_origen from singlelineedit within w_cm336_art_serv_x_comprador
end type
type st_1 from statictext within w_cm336_art_serv_x_comprador
end type
type st_2 from statictext within w_cm336_art_serv_x_comprador
end type
type sle_comprador from singlelineedit within w_cm336_art_serv_x_comprador
end type
type cb_2 from commandbutton within w_cm336_art_serv_x_comprador
end type
type rb_art from radiobutton within w_cm336_art_serv_x_comprador
end type
type rb_serv from radiobutton within w_cm336_art_serv_x_comprador
end type
type cb_3 from commandbutton within w_cm336_art_serv_x_comprador
end type
type gb_1 from groupbox within w_cm336_art_serv_x_comprador
end type
type gb_2 from groupbox within w_cm336_art_serv_x_comprador
end type
end forward

global type w_cm336_art_serv_x_comprador from w_abc_list
integer width = 3410
integer height = 1936
string title = "Artículos/Servicios por Comprador (CM336)"
string menuname = "m_mantto_smpl"
st_campo st_campo
dw_text dw_text
cb_1 cb_1
sle_origen sle_origen
st_1 st_1
st_2 st_2
sle_comprador sle_comprador
cb_2 cb_2
rb_art rb_art
rb_serv rb_serv
cb_3 cb_3
gb_1 gb_1
gb_2 gb_2
end type
global w_cm336_art_serv_x_comprador w_cm336_art_serv_x_comprador

type variables
String is_col, is_comprador, is_origen
end variables

on w_cm336_art_serv_x_comprador.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.st_campo=create st_campo
this.dw_text=create dw_text
this.cb_1=create cb_1
this.sle_origen=create sle_origen
this.st_1=create st_1
this.st_2=create st_2
this.sle_comprador=create sle_comprador
this.cb_2=create cb_2
this.rb_art=create rb_art
this.rb_serv=create rb_serv
this.cb_3=create cb_3
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.sle_origen
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.sle_comprador
this.Control[iCurrent+8]=this.cb_2
this.Control[iCurrent+9]=this.rb_art
this.Control[iCurrent+10]=this.rb_serv
this.Control[iCurrent+11]=this.cb_3
this.Control[iCurrent+12]=this.gb_1
this.Control[iCurrent+13]=this.gb_2
end on

on w_cm336_art_serv_x_comprador.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.cb_1)
destroy(this.sle_origen)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.sle_comprador)
destroy(this.cb_2)
destroy(this.rb_art)
destroy(this.rb_serv)
destroy(this.cb_3)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event resize;call super::resize;//dw_report.width = newwidth - dw_report.x
//dw_report.height = newheight - dw_report.y
//
dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_2.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF dw_2.ii_update = 1 THEN
	IF dw_2.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    Rollback ;
		messagebox("Error en Grabación","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_2.ii_update = 0
END IF

end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = True
//Long 		ll_x, ll_row[]
//
//of_get_row_update(dw_2, ll_row[])
//
//For ll_x = 1 TO UpperBound(ll_row)
////	Validar registro ll_x
//	IF ERROR THEN
//		MessageBox(  )
//		ib_update_check = False
//	END IF
//NEXT
//
//
//dw_2.of_set_flag_replicacion()
end event

event ue_open_pre;call super::ue_open_pre;sle_origen.Text = gs_origen
sle_comprador.SetFocus()
end event

event ue_delete;//Override
end event

type dw_1 from w_abc_list`dw_1 within w_cm336_art_serv_x_comprador
integer x = 32
integer y = 376
integer width = 1545
integer height = 1356
string dataobject = "d_list_articulo"
end type

event dw_1::constructor;call super::constructor;//SetTransObject(sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2
end event

event dw_1::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col = dw_1.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Buscar x : " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

event dw_1::dwnenter;call super::dwnenter;dw_1.triggerevent(doubleclicked!)
return 1
end event

event dw_1::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

end event

event dw_1::ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

//Le Pongo el Origen y el Comprador
//ls_comprador = sle_comprador.Text
//ls_
idw_det.SetItem(ll_row, "comprador", is_comprador)
idw_det.SetItem(ll_row, "cod_origen", is_origen)

idw_det.ScrollToRow(ll_row)
end event

type dw_2 from w_abc_list`dw_2 within w_cm336_art_serv_x_comprador
integer x = 1792
integer y = 376
integer width = 1545
integer height = 1356
string dataobject = "d_list_comprador_art_origen"
end type

event dw_2::constructor;call super::constructor;//SetTransObject(sqlca)

ii_ck[1] = 1
ii_ck[2] = 2

ii_dk[1] = 1
ii_dk[2] = 2

ii_rk[1] = 1
ii_rk[2] = 2

end event

event dw_2::ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop

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

type pb_1 from w_abc_list`pb_1 within w_cm336_art_serv_x_comprador
integer x = 1614
integer y = 896
alignment htextalign = center!
end type

event pb_1::clicked;call super::clicked;dw_2.ii_update = 1
end event

type pb_2 from w_abc_list`pb_2 within w_cm336_art_serv_x_comprador
integer x = 1614
integer y = 1024
integer height = 112
alignment htextalign = center!
end type

event pb_2::clicked;call super::clicked;dw_2.ii_update = 1
end event

type st_campo from statictext within w_cm336_art_serv_x_comprador
integer x = 32
integer y = 300
integer width = 622
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar x NOM_ARTICULO"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_cm336_art_serv_x_comprador
event dw_enter pbm_dwnprocessenter
event ue_key pbm_dwnkey
integer x = 649
integer y = 288
integer width = 928
integer height = 84
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;mESSAGEBOX("","ENTER")
dw_1.triggerevent(doubleclicked!)
return 1
end event

event ue_key;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_1.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_1.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;InsertRow(0)
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
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_1.find(ls_comando, 1, dw_1.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_1.selectrow(0, false)
			dw_1.selectrow(ll_fila,true)
			dw_1.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type cb_1 from commandbutton within w_cm336_art_serv_x_comprador
boolean visible = false
integer x = 2359
integer y = 224
integer width = 288
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;String  ls_campo,ls_cadena,ls_sql_old,ls_sql_new,ls_tabla, ls_art[2]
Integer li_opcion

dw_text.Accepttext()

ls_campo = Upper(String(dw_text.object.campo [1]))

//IF rb_proveedor.checked = true then
//ELSEIF rb_cencos.checked = true then
//	ls_tabla = 'CENTROS_COSTO.'
//ELSEIF rb_cuenta.checked = true then
//	ls_tabla = 'PRESUPUESTO_CUENTA.'
//ELSE
//	Messagebox('Aviso','Debe Seleccionar algun tipo de Dato Verifique!')
//	Return
//END IF

ls_tabla = "ARTICULO."

///pendiente
IF Isnull(ls_campo) OR Trim(ls_campo) = '' THEN
	li_opcion = Messagebox('Pregunta','Desea Filtrar Por Algun Campo ',question!,yesno!)	
	IF li_opcion = 1 THEN
		dw_text.SetFocus()
		Return
	ELSE
		ls_cadena = ''
	END IF
ELSE
	IF Isnull(is_col) OR Trim(is_col) = '' THEN 
		Messagebox('Aviso','Debe Seleccionar Una Columna a Buscar , Doble Clicked en Columna a Buscar')
		Return
	END IF	
	
	if isnull(ls_tabla) or trim(ls_tabla) = '' then
		ls_cadena = ' AND UPPER('+is_col+') Like '+"'"+ls_campo+"%'" 
	else
		ls_cadena = ' AND '+'UPPER('+ls_tabla+is_col+') Like '+"'"+ls_campo+"%'" 		
	end if

END IF




//dw_report.visible = false
//cb_report.enabled = false
//dw_report.SetTransObject(sqlca)


dw_1.reset()
//dw_2.reset()

ls_sql_old = dw_1.getsqlselect()
ls_sql_new = ls_sql_old	+ ls_cadena



dw_1.setsqlselect(ls_sql_new)
ls_art[1]='07'
ls_art[2]='08'
dw_1.retrieve(ls_art,is_origen, is_comprador)
dw_1.setsqlselect(ls_sql_old)

end event

type sle_origen from singlelineedit within w_cm336_art_serv_x_comprador
integer x = 393
integer y = 52
integer width = 174
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event modified;dw_1.reset()
dw_2.reset()
end event

type st_1 from statictext within w_cm336_art_serv_x_comprador
integer x = 105
integer y = 64
integer width = 270
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Origen:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_2 from statictext within w_cm336_art_serv_x_comprador
integer x = 46
integer y = 152
integer width = 329
integer height = 64
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Comprador:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_comprador from singlelineedit within w_cm336_art_serv_x_comprador
integer x = 393
integer y = 144
integer width = 274
integer height = 76
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
integer limit = 6
borderstyle borderstyle = stylelowered!
end type

type cb_2 from commandbutton within w_cm336_art_serv_x_comprador
integer x = 1207
integer y = 168
integer width = 297
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Aceptar"
end type

event clicked;String ls_orig, ls_compr, ls_art[2]
Long ll_count

ls_orig = Trim(sle_origen.Text)
ls_compr = Trim(sle_comprador.Text)

is_origen = ls_orig
is_comprador = ls_compr

Select count(*) 
  into :ll_count
  from origen
 where cod_origen =:ls_orig;
 
If ll_count = 0 then
	MessageBox("Aviso","Origen No Existe")
	Return
end if

Select count(*) 
  into :ll_count
  from usuario
 where cod_usr =:ls_compr;
 
If ll_count = 0 then
	MessageBox("Aviso","Comprador No Existe")
	Return
end if

dw_1.SetTransObject(sqlca)
dw_2.SetTransObject(sqlca)
If rb_art.Checked then
	ls_art[1]='07'
	ls_art[2]='08'
	dw_1.Retrieve(ls_art[],ls_orig, ls_compr)
elseif rb_serv.Checked then
	dw_1.Retrieve(ls_orig, ls_compr)
end if
dw_2.Retrieve(ls_orig,ls_compr)

/////////////////////////////
//String  ls_campo,ls_cadena,ls_sql_old,ls_sql_new,ls_tabla//, ls_art[2]
//Integer li_opcion
//
//dw_text.Accepttext()
//
//ls_campo = Upper(String(dw_text.object.campo [1]))
//
////IF rb_proveedor.checked = true then
////ELSEIF rb_cencos.checked = true then
////	ls_tabla = 'CENTROS_COSTO.'
////ELSEIF rb_cuenta.checked = true then
////	ls_tabla = 'PRESUPUESTO_CUENTA.'
////ELSE
////	Messagebox('Aviso','Debe Seleccionar algun tipo de Dato Verifique!')
////	Return
////END IF
//
//ls_tabla = "ARTICULO."
//
/////pendiente
//IF Isnull(ls_campo) OR Trim(ls_campo) = '' THEN
////	li_opcion = Messagebox('Pregunta','Desea Filtrar Por Algun Campo ',question!,yesno!)	
////	IF li_opcion = 1 THEN
////		dw_text.SetFocus()
////		Return
////	ELSE
//		ls_cadena = ''
////	END IF
//ELSE
//	IF Isnull(is_col) OR Trim(is_col) = '' THEN 
//		Messagebox('Aviso','Debe Seleccionar Una Columna a Buscar , Doble Clicked en Columna a Buscar')
//		Return
//	END IF	
//	
//	if isnull(ls_tabla) or trim(ls_tabla) = '' then
//		ls_cadena = ' AND UPPER('+is_col+') Like '+"'"+ls_campo+"%'"
//	else
//		ls_cadena = ' AND '+'UPPER('+ls_tabla+is_col+') Like '+"'"+ls_campo+"%'" &
//		//ls_cadena = " AND A."+is_col+" Like '"+ls_campo+"%'" &
//	   //ls_cadena = " AND (ARTICULO.COD_CLASE) NOT IN ('07','08')"&
//	   //+" AND (ARTICULO.COD_ART) NOT IN (SELECT COD_ART FROM COMPRADOR_ART_ORIGEN WHERE COMPRADOR = '"+is_comprador+"' AND COD_ORIGEN = '"+is_origen+"')"
//
////	   +" AND UPPER("+ls_tabla+"COD_CLASE) NOT IN ('07','08')"&
//	//   +" AND UPPER("+ls_tabla+"COD_ART) NOT IN (SELECT COD_ART FROM COMPRADOR_ART_ORIGEN WHERE COMPRADOR = '"+is_comprador+"' AND COD_ORIGEN = '"+is_origen+"')"
//	end if
//
//END IF
//
//
//
//
////dw_report.visible = false
////cb_report.enabled = false
////dw_report.SetTransObject(sqlca)
//
//
//dw_1.reset()
////dw_2.reset()
//
//ls_sql_old = dw_1.getsqlselect()
//ls_sql_new = ls_sql_old	+ ls_cadena
//MessageBox("",ls_sql_new)
//
//
//
//dw_1.setsqlselect(ls_sql_new)
//ls_art[1]='07'
//ls_art[2]='08'
//dw_1.retrieve(ls_art,is_origen, is_comprador)
//dw_1.setsqlselect(ls_sql_old)
//
end event

type rb_art from radiobutton within w_cm336_art_serv_x_comprador
integer x = 823
integer y = 84
integer width = 297
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
string text = "Artículos"
boolean checked = true
end type

event clicked;If Checked then
	dw_1.DataObject = "d_list_articulo"
	dw_2.DataObject = "d_list_comprador_art_origen"
end if
end event

type rb_serv from radiobutton within w_cm336_art_serv_x_comprador
integer x = 823
integer y = 140
integer width = 302
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
string text = "Servicios"
end type

event clicked;If Checked then
	dw_1.DataObject = "d_list_servicios"
	dw_2.DataObject = "d_list_comprador_serv_origen"
end if
end event

type cb_3 from commandbutton within w_cm336_art_serv_x_comprador
integer x = 677
integer y = 140
integer width = 87
integer height = 80
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

event clicked;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "select c.comprador as comprador, "&
			+"u.nombre as nombre from comprador c, usuario u "&
			+"where c.comprador = u.cod_usr and c.flag_estado = '1'"
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

if ls_codigo <> '' then
	sle_comprador.Text = ls_codigo
	dw_1.reset()
	dw_2.reset()
end if
end event

type gb_1 from groupbox within w_cm336_art_serv_x_comprador
integer x = 791
integer y = 36
integer width = 370
integer height = 188
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opción"
end type

type gb_2 from groupbox within w_cm336_art_serv_x_comprador
integer x = 32
integer width = 1166
integer height = 252
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

