$PBExportHeader$w_cm726_compras_materiales.srw
forward
global type w_cm726_compras_materiales from w_rpt_list
end type
type gb_fechas from groupbox within w_cm726_compras_materiales
end type
type uo_fecha from u_ingreso_rango_fechas_v within w_cm726_compras_materiales
end type
type rb_soles from radiobutton within w_cm726_compras_materiales
end type
type rb_dolares from radiobutton within w_cm726_compras_materiales
end type
type cb_seleccionar from commandbutton within w_cm726_compras_materiales
end type
type st_1 from statictext within w_cm726_compras_materiales
end type
type dw_text from datawindow within w_cm726_compras_materiales
end type
type sle_origen from singlelineedit within w_cm726_compras_materiales
end type
type cbx_1 from checkbox within w_cm726_compras_materiales
end type
type st_desc_origen from statictext within w_cm726_compras_materiales
end type
type gb_tipo_reporte from groupbox within w_cm726_compras_materiales
end type
type gb_1 from groupbox within w_cm726_compras_materiales
end type
end forward

global type w_cm726_compras_materiales from w_rpt_list
integer width = 3657
integer height = 2516
string title = "[CM726] Compra de Materiales"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
uo_fecha uo_fecha
rb_soles rb_soles
rb_dolares rb_dolares
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
sle_origen sle_origen
cbx_1 cbx_1
st_desc_origen st_desc_origen
gb_tipo_reporte gb_tipo_reporte
gb_1 gb_1
end type
global w_cm726_compras_materiales w_cm726_compras_materiales

type variables
String  is_col = '', is_type
Integer ii_index

end variables

on w_cm726_compras_materiales.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.uo_fecha=create uo_fecha
this.rb_soles=create rb_soles
this.rb_dolares=create rb_dolares
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.sle_origen=create sle_origen
this.cbx_1=create cbx_1
this.st_desc_origen=create st_desc_origen
this.gb_tipo_reporte=create gb_tipo_reporte
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.uo_fecha
this.Control[iCurrent+3]=this.rb_soles
this.Control[iCurrent+4]=this.rb_dolares
this.Control[iCurrent+5]=this.cb_seleccionar
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_text
this.Control[iCurrent+8]=this.sle_origen
this.Control[iCurrent+9]=this.cbx_1
this.Control[iCurrent+10]=this.st_desc_origen
this.Control[iCurrent+11]=this.gb_tipo_reporte
this.Control[iCurrent+12]=this.gb_1
end on

on w_cm726_compras_materiales.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.uo_fecha)
destroy(this.rb_soles)
destroy(this.rb_dolares)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.sle_origen)
destroy(this.cbx_1)
destroy(this.st_desc_origen)
destroy(this.gb_tipo_reporte)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_cm726_compras_materiales
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "dw_rpt_compras_articulos_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_cm726_compras_materiales
integer x = 41
integer y = 408
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "dw_list_articulo_oc_tbl"
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

type pb_1 from w_rpt_list`pb_1 within w_cm726_compras_materiales
integer x = 1728
integer y = 876
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_cm726_compras_materiales
integer x = 1728
integer y = 1044
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_cm726_compras_materiales
integer x = 1906
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "dw_list_articulo_oc_tbl"
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

type cb_report from w_rpt_list`cb_report within w_cm726_compras_materiales
integer x = 3081
integer y = 192
integer width = 366
integer height = 84
integer taborder = 80
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Date 		ld_desde, ld_hasta
string	ls_mensaje, ls_cod, ls_desc, ls_und, &
			ls_soles, ls_dolares, ls_moneda, ls_origen, &
			ls_fecha, ls_desc_moneda
Long 		ll_row

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()

SetPointer( Hourglass!)

if Not f_monedas(ls_soles, ls_dolares) then return

IF dw_2.rowcount() = 0 THEN RETURN

// Llena datos de dw seleccionados a tabla temporal
DELETE FROM TT_CMP_ART_SEL;
COMMIT;

IF rb_soles.checked THEN
	ls_moneda = ls_soles
ELSE
	ls_moneda = ls_dolares
END IF

SELECT DESCRIPCION
  INTO :ls_desc_moneda
FROM moneda
WHERE cod_moneda = :ls_moneda ;

FOR ll_row = 1 TO dw_2.rowcount()
	ls_cod  = dw_2.object.cod_art	 [ll_row]	
	ls_desc = dw_2.object.desc_art [ll_row]
	ls_und  = dw_2.object.und		 [ll_row]
	
	INSERT INTO TT_CMP_ART_SEL( cod_Art, desc_art, und) 
	 VALUES ( :ls_cod, :ls_desc, :ls_und);		
			
	IF sqlca.sqlcode = -1 THEN
		ls_mensaje = SQLCA.SQLerrtext
		ROLLBACK;
		messagebox("Error al insertar registro en TT_CMP_ART_SEL",ls_mensaje)
		RETURN
	END IF
NEXT	

COMMIT;

	
dw_1.visible = FALSE
dw_2.visible = FALSE		

IF cbx_1.checked THEN
	ls_origen = '%%'
ELSE
	ls_origen = trim(sle_origen.text) + '%'
END IF

ls_fecha = 'Desde  ' + String (ld_desde, " dd/mm/yyyy" ) + &
				' Hasta  ' + String (ld_hasta, " dd/mm/yyyy" )

parent.Event ue_preview()		

dw_report.retrieve(ls_moneda, ls_origen, ld_desde, ld_hasta)	
dw_report.visible = TRUE
ib_preview 	= FALSE

dw_report.object.t_fecha.text		= ls_fecha
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_moneda.text	= ls_desc_moneda
dw_report.Object.p_logo.filename = gs_logo
	

end event

type gb_fechas from groupbox within w_cm726_compras_materiales
integer x = 46
integer y = 4
integer width = 667
integer height = 300
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
end type

type uo_fecha from u_ingreso_rango_fechas_v within w_cm726_compras_materiales
integer x = 73
integer y = 72
integer taborder = 10
boolean bringtotop = true
long backcolor = 67108864
end type

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Del:','Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(date(ls_desde), today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))					// rango final

// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_fecha.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event ue_output;call super::ue_output;cb_seleccionar.enabled = true
end event

type rb_soles from radiobutton within w_cm726_compras_materiales
integer x = 2341
integer y = 108
integer width = 475
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Soles"
boolean checked = true
boolean lefttext = true
end type

type rb_dolares from radiobutton within w_cm726_compras_materiales
integer x = 2341
integer y = 184
integer width = 475
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Dolares"
boolean lefttext = true
end type

type cb_seleccionar from commandbutton within w_cm726_compras_materiales
integer x = 3081
integer y = 88
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

event clicked;// Seleccionar articulos

string 	ls_origen
date	 	ld_desde, ld_hasta

IF cbx_1.checked THEN
	ls_origen = '%%'
ELSE
	ls_origen = trim(sle_origen.text) + '%'
END IF

ld_desde = uo_fecha.of_get_fecha1()
ld_hasta = uo_fecha.of_get_fecha2()


dw_1.SetTransObject(SQLCA)
dw_1.retrieve(ld_desde, ld_hasta, ls_origen)

dw_1.visible = TRUE
dw_2.visible = TRUE

dw_report.visible = FALSE



end event

type st_1 from statictext within w_cm726_compras_materiales
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

type dw_text from datawindow within w_cm726_compras_materiales
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

type sle_origen from singlelineedit within w_cm726_compras_materiales
event dobleclick pbm_lbuttondblclk
integer x = 759
integer y = 176
integer width = 169
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
boolean enabled = false
textcase textcase = upper!
integer limit = 2
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
	  	 + "nombre AS DESCRIPCION " &
	    + "FROM origen " 
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
IF ls_codigo <> '' THEN
	This.text 			= ls_codigo
	st_desc_origen.text 	= ls_data
END IF

end event

event modified;String 	ls_desc, ls_origen

ls_origen = sle_origen.text

SELECT nombre 
	INTO :ls_desc
FROM origen
where cod_origen = :ls_origen;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Origen no existe')
	return
end if

st_desc_origen.text = ls_desc

end event

type cbx_1 from checkbox within w_cm726_compras_materiales
integer x = 768
integer y = 80
integer width = 603
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Todos los Origenes"
boolean checked = true
end type

event clicked;IF THIS.checked THEN
	sle_origen.enabled = FALSE
ELSE
	sle_origen.enabled = TRUE
END IF
end event

type st_desc_origen from statictext within w_cm726_compras_materiales
integer x = 937
integer y = 176
integer width = 1289
integer height = 88
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type gb_tipo_reporte from groupbox within w_cm726_compras_materiales
integer x = 2299
integer y = 44
integer width = 562
integer height = 224
integer taborder = 70
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Moneda"
end type

type gb_1 from groupbox within w_cm726_compras_materiales
integer x = 731
integer y = 4
integer width = 1518
integer height = 300
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Origen:"
end type

