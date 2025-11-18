$PBExportHeader$w_al739_mov_articulo_anual.srw
forward
global type w_al739_mov_articulo_anual from w_rpt_list
end type
type cb_seleccionar from commandbutton within w_al739_mov_articulo_anual
end type
type st_1 from statictext within w_al739_mov_articulo_anual
end type
type dw_text from datawindow within w_al739_mov_articulo_anual
end type
type sle_almacen from singlelineedit within w_al739_mov_articulo_anual
end type
type sle_descrip from singlelineedit within w_al739_mov_articulo_anual
end type
type st_2 from statictext within w_al739_mov_articulo_anual
end type
type st_3 from statictext within w_al739_mov_articulo_anual
end type
type sle_year from singlelineedit within w_al739_mov_articulo_anual
end type
type gb_1 from groupbox within w_al739_mov_articulo_anual
end type
end forward

global type w_al739_mov_articulo_anual from w_rpt_list
integer width = 3803
integer height = 3416
string title = "Movimientos anuales (AL739)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
sle_almacen sle_almacen
sle_descrip sle_descrip
st_2 st_2
st_3 st_3
sle_year sle_year
gb_1 gb_1
end type
global w_al739_mov_articulo_anual w_al739_mov_articulo_anual

type variables
String is_ope_vta, is_almacen, is_col = '', is_type
Integer ii_index

end variables

on w_al739_mov_articulo_anual.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.st_2=create st_2
this.st_3=create st_3
this.sle_year=create sle_year
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_seleccionar
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.dw_text
this.Control[iCurrent+4]=this.sle_almacen
this.Control[iCurrent+5]=this.sle_descrip
this.Control[iCurrent+6]=this.st_2
this.Control[iCurrent+7]=this.st_3
this.Control[iCurrent+8]=this.sle_year
this.Control[iCurrent+9]=this.gb_1
end on

on w_al739_mov_articulo_anual.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.st_2)
destroy(this.st_3)
destroy(this.sle_year)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_al739_mov_articulo_anual
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_mov_articulo_anual_tbl"
end type

event dw_report::doubleclicked;call super::doubleclicked;GroupCalc()
end event

type dw_1 from w_rpt_list`dw_1 within w_al739_mov_articulo_anual
integer x = 32
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_sel_mov_almacen_seleccion"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event dw_1::constructor;call super::constructor;this.SettransObject( sqlca)
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

type pb_1 from w_rpt_list`pb_1 within w_al739_mov_articulo_anual
integer x = 1728
integer y = 876
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al739_mov_articulo_anual
integer x = 1728
integer y = 1044
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al739_mov_articulo_anual
integer x = 1915
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_sel_mov_almacen_seleccion"
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

type cb_report from w_rpt_list`cb_report within w_al739_mov_articulo_anual
integer x = 2007
integer y = 132
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;double 	ln_saldo
string	ls_mensaje, ls_almacen, ls_cod
Long 		ll_row, ll_year

ll_year = Long(sle_year.text)
ls_almacen = sle_almacen.text

SetPointer( Hourglass!)

if ls_almacen = '' then
	Messagebox( "Aviso", "Indique almacen")
	return
end if

if dw_2.rowcount() = 0 then return	

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
commit;
	
FOR ll_row = 1 to dw_2.rowcount()
	ls_cod = dw_2.object.cod_art[ll_row]		
	Insert into tt_alm_seleccion( 
			cod_Art) 
	values ( 
			:ls_cod);		
			
	If sqlca.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLerrtext
		ROLLBACK;
		messagebox("Error al insertar registro en tt_alm_seleccion",ls_mensaje)
		return
	END IF
NEXT	

dw_1.visible = false
dw_2.visible = false		
ib_preview = false		
parent.Event ue_preview()		
dw_report.SetTransObject( sqlca)
dw_report.retrieve(ls_almacen, ll_year)	
dw_report.visible = true
dw_report.object.t_year.text 	= 'Año: ' + STRING(ll_year)
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_almacen.text 	= sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo
dw_report.object.Datawindow.print.Orientation = 1
	
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type cb_seleccionar from commandbutton within w_al739_mov_articulo_anual
boolean visible = false
integer x = 2007
integer y = 36
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

event clicked;// Crea archivo temporal
string ls_almacen

dw_1.dataobject = 'd_sel_mov_almacen_seleccion'

ls_almacen = sle_almacen.text

dw_1.SetTransObject(SQLCA)
dw_1.retrieve(ls_almacen)

dw_1.visible = true
dw_2.visible = true
dw_report.visible = false	

cb_seleccionar.visible = false


end event

type st_1 from statictext within w_al739_mov_articulo_anual
integer x = 41
integer y = 328
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

type dw_text from datawindow within w_al739_mov_articulo_anual
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 402
integer y = 320
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

type sle_almacen from singlelineedit within w_al739_mov_articulo_anual
event dobleclick pbm_lbuttondblclk
integer x = 384
integer y = 76
integer width = 224
integer height = 88
integer taborder = 90
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
	cb_seleccionar.visible = true
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

type sle_descrip from singlelineedit within w_al739_mov_articulo_anual
integer x = 631
integer y = 76
integer width = 1330
integer height = 88
integer taborder = 100
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

type st_2 from statictext within w_al739_mov_articulo_anual
integer x = 64
integer y = 88
integer width = 306
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
alignment alignment = right!
boolean focusrectangle = false
end type

type st_3 from statictext within w_al739_mov_articulo_anual
integer x = 64
integer y = 200
integer width = 306
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Año:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_year from singlelineedit within w_al739_mov_articulo_anual
integer x = 384
integer y = 184
integer width = 402
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
borderstyle borderstyle = stylelowered!
end type

type gb_1 from groupbox within w_al739_mov_articulo_anual
integer x = 32
integer width = 1966
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Parametros"
end type

