$PBExportHeader$w_al727_valorizacion_stock.srw
forward
global type w_al727_valorizacion_stock from w_rpt_list
end type
type cb_seleccionar from commandbutton within w_al727_valorizacion_stock
end type
type st_1 from statictext within w_al727_valorizacion_stock
end type
type dw_text from datawindow within w_al727_valorizacion_stock
end type
type cb_filtrar from commandbutton within w_al727_valorizacion_stock
end type
type sle_almacen from singlelineedit within w_al727_valorizacion_stock
end type
type sle_descrip from singlelineedit within w_al727_valorizacion_stock
end type
type st_2 from statictext within w_al727_valorizacion_stock
end type
end forward

global type w_al727_valorizacion_stock from w_rpt_list
integer width = 3657
integer height = 2008
string title = "Valorizacion de Stock (AL727)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
event ue_seleccionar ( )
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
cb_filtrar cb_filtrar
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
end type
global w_al727_valorizacion_stock w_al727_valorizacion_stock

type variables
String is_ope_vta, is_almacen, is_col = '', is_type
Integer ii_index

end variables

event ue_seleccionar();string ls_almacen

ls_almacen = sle_almacen.text

if IsNull(ls_almacen) or trim(ls_almacen) = '' then
	dw_1.Reset()
	dw_2.Reset()
	MessageBox('Aviso', 'Debe especificar algun almacen')
	return
end if

dw_1.Retrieve(ls_almacen)
dw_2.Reset()

cb_report.enabled = true
cb_seleccionar.visible = true
end event

on w_al727_valorizacion_stock.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.cb_filtrar=create cb_filtrar
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_seleccionar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.cb_filtrar
this.Control[iCurrent+5]=this.sle_almacen
this.Control[iCurrent+6]=this.sle_descrip
this.Control[iCurrent+7]=this.st_2
end on

on w_al727_valorizacion_stock.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.cb_filtrar)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Long 		ll_row
String 	ls_sub_cat, ls_mensaje, ls_almacen
SetPointer( Hourglass!)

dw_report.setfilter('')
if dw_2.rowcount() = 0 then return	

ls_almacen = sle_almacen.text

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
	ls_sub_cat = dw_2.object.cod_sub_cat[ll_row]		
	Insert into tt_alm_seleccion(COD_SUB_CAT) 
	values ( :ls_sub_cat);
				
	If sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		messagebox("Error al insertar registro",ls_mensaje)
		return
	END IF
NEXT	
commit;
	
dw_1.visible = false
dw_2.visible = false		
ib_preview = false		
Event ue_preview()		
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_almacen)	
dw_report.visible = true
dw_report.object.t_user.text = gs_user
dw_report.object.t_almacen.text = sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo
	
//this.enabled = false
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type dw_report from w_rpt_list`dw_report within w_al727_valorizacion_stock
boolean visible = false
integer x = 0
integer y = 140
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_valorizacion_sub_categ_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_al727_valorizacion_stock
integer x = 9
integer y = 228
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_list_sub_categ_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
ii_ck[1] = 1 
ii_ck[2] = 2
ii_ck[3] = 3


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

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

event dw_1::ue_selected_row_pro;//Ancestor Overscrpit
Long 		ll_row, ll_count, ll_rc
Any		la_id
Integer 	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT
	
return 
end event

type pb_1 from w_rpt_list`pb_1 within w_al727_valorizacion_stock
integer x = 1705
integer y = 704
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al727_valorizacion_stock
integer x = 1705
integer y = 872
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al727_valorizacion_stock
integer x = 1893
integer y = 228
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_list_sub_categ_grd"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_2::constructor;call super::constructor;this.SettransObject( sqlca)

ii_ck[1] = 1
ii_ck[2] = 2
ii_ck[3] = 3

ii_dk[1] = 1
ii_dk[2] = 2
ii_dk[3] = 3

ii_rk[1] = 1
ii_rk[2] = 2
ii_rk[3] = 3
end event

type cb_report from w_rpt_list`cb_report within w_al727_valorizacion_stock
integer x = 2391
integer y = 28
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Parent.Event Dynamic ue_retrieve()
end event

type cb_seleccionar from commandbutton within w_al727_valorizacion_stock
integer x = 1998
integer y = 28
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Seleccionar"
end type

event clicked;Parent.event dynamic ue_seleccionar()


end event

type st_1 from statictext within w_al727_valorizacion_stock
integer x = 18
integer y = 156
integer width = 498
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

type dw_text from datawindow within w_al727_valorizacion_stock
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 521
integer y = 148
integer width = 1157
integer height = 80
integer taborder = 90
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

event type long dwnenter();//Send(Handle(this),256,9,Long(0,0))
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

type cb_filtrar from commandbutton within w_al727_valorizacion_stock
integer x = 2784
integer y = 28
integer width = 366
integer height = 84
integer taborder = 60
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;str_parametros lstr_1

//lstr_1.dw_m = dw_report
//openwithparm (w_filtros, lstr_1)
end event

type sle_almacen from singlelineedit within w_al727_valorizacion_stock
event dobleclick pbm_lbuttondblclk
integer x = 320
integer y = 24
integer width = 224
integer height = 88
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT almacen AS CODIGO_almacen, " &
	  	 + "DESC_almacen AS DESCRIPCION_almacen " &
	    + "FROM almacen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	this.text 			= ls_codigo
	sle_descrip.text 	= ls_data
	Parent.event dynamic ue_seleccionar()
end if

end event

event modified;String 	ls_almacen, ls_desc

ls_almacen = sle_almacen.text
if ls_almacen = '' or IsNull(ls_almacen) then
	MessageBox('Aviso', 'Debe Ingresar un codigo de almacen')
	return
end if

SELECT desc_almacen 
	INTO :ls_desc
FROM almacen 
where almacen = :ls_almacen ;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()

end event

type sle_descrip from singlelineedit within w_al727_valorizacion_stock
integer x = 549
integer y = 24
integer width = 1390
integer height = 88
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
textcase textcase = upper!
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_al727_valorizacion_stock
integer x = 14
integer y = 36
integer width = 302
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
boolean focusrectangle = false
end type

