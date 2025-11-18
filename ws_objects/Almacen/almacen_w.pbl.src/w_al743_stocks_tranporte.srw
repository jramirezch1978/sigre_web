$PBExportHeader$w_al743_stocks_tranporte.srw
forward
global type w_al743_stocks_tranporte from w_rpt_list
end type
type gb_fechas from groupbox within w_al743_stocks_tranporte
end type
type cb_seleccionar from commandbutton within w_al743_stocks_tranporte
end type
type st_1 from statictext within w_al743_stocks_tranporte
end type
type dw_text from datawindow within w_al743_stocks_tranporte
end type
type uo_1 from u_ingreso_fecha within w_al743_stocks_tranporte
end type
type sle_almacen from singlelineedit within w_al743_stocks_tranporte
end type
type sle_descrip from singlelineedit within w_al743_stocks_tranporte
end type
type rb_detalle from radiobutton within w_al743_stocks_tranporte
end type
type rb_resumen from radiobutton within w_al743_stocks_tranporte
end type
type gb_1 from groupbox within w_al743_stocks_tranporte
end type
type gb_tipo_reporte from groupbox within w_al743_stocks_tranporte
end type
end forward

global type w_al743_stocks_tranporte from w_rpt_list
integer width = 3511
integer height = 2000
string title = "Saldos Almacén Tránsito (AL743)"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
uo_1 uo_1
sle_almacen sle_almacen
sle_descrip sle_descrip
rb_detalle rb_detalle
rb_resumen rb_resumen
gb_1 gb_1
gb_tipo_reporte gb_tipo_reporte
end type
global w_al743_stocks_tranporte w_al743_stocks_tranporte

type variables
String is_almacen, is_col = '', is_type
Integer ii_clase

end variables

on w_al743_stocks_tranporte.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.gb_fechas=create gb_fechas
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.uo_1=create uo_1
this.sle_almacen=create sle_almacen
this.sle_descrip=create sle_descrip
this.rb_detalle=create rb_detalle
this.rb_resumen=create rb_resumen
this.gb_1=create gb_1
this.gb_tipo_reporte=create gb_tipo_reporte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_seleccionar
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_text
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.sle_almacen
this.Control[iCurrent+7]=this.sle_descrip
this.Control[iCurrent+8]=this.rb_detalle
this.Control[iCurrent+9]=this.rb_resumen
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_tipo_reporte
end on

on w_al743_stocks_tranporte.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.uo_1)
destroy(this.sle_almacen)
destroy(this.sle_descrip)
destroy(this.rb_detalle)
destroy(this.rb_resumen)
destroy(this.gb_1)
destroy(this.gb_tipo_reporte)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

event ue_retrieve;call super::ue_retrieve;Date ld_desde
double ln_saldo

ld_desde = uo_1.of_get_fecha()
Long 	ll_row
String ls_cod 

SetPointer( Hourglass!)

is_almacen = sle_almacen.text

if dw_2.rowcount() = 0 then return	

// Llena datos de dw seleccionados a tabla temporal
delete from tt_alm_seleccion;
FOR ll_row = 1 to dw_2.rowcount()
	ls_cod = dw_2.object.cod_art[ll_row]		
	Insert into tt_alm_seleccion( cod_Art, fecha1) 
		values ( :ls_cod, :ld_desde);		
	If sqlca.sqlcode = -1 then
		messagebox("Error al insertar registro",sqlca.sqlerrtext)
	END IF
NEXT			
	
dw_1.visible = false
dw_2.visible = false		
pb_1.visible = false
pb_2.visible = false
dw_text.visible = false
st_1.visible = false
ib_preview = false

if rb_detalle.checked = true then
	dw_report.dataobject = 'd_rpt_saldo_alm_transito_det_tbl'
elseif rb_resumen.checked = true then
	dw_report.dataobject = 'd_rpt_saldo_alm_transito_res_tbl'
end if
dw_report.SetTransObject( sqlca)
this.Event ue_preview()
dw_report.retrieve(is_almacen, ld_desde)	
dw_report.object.fec_ini.text = STRING(LD_DESDE, "DD/MM/YYYY")
dw_report.object.t_user.text 		= gs_user
dw_report.object.t_empresa.text 	= gs_empresa
dw_report.object.t_objeto.text 	= this.Classname( )
dw_report.object.t_almacen.text 	= sle_descrip.text
dw_report.Object.p_logo.filename = gs_logo

dw_report.visible = true
		
//this.enabled = false
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type dw_report from w_rpt_list`dw_report within w_al743_stocks_tranporte
boolean visible = false
integer x = 0
integer y = 232
integer width = 3333
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_saldo_alm_transito_res_tbl"
end type

type dw_1 from w_rpt_list`dw_1 within w_al743_stocks_tranporte
integer x = 9
integer y = 320
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

type pb_1 from w_rpt_list`pb_1 within w_al743_stocks_tranporte
integer x = 1705
integer y = 796
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_al743_stocks_tranporte
integer x = 1705
integer y = 964
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_al743_stocks_tranporte
integer x = 1893
integer y = 320
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

type cb_report from w_rpt_list`cb_report within w_al743_stocks_tranporte
integer x = 3040
integer y = 112
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;SetPointer(HourGlass!)
parent.event ue_retrieve( )
SetPointer(Arrow!)
end event

type gb_fechas from groupbox within w_al743_stocks_tranporte
integer x = 46
integer width = 667
integer height = 228
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

type cb_seleccionar from commandbutton within w_al743_stocks_tranporte
boolean visible = false
integer x = 3040
integer y = 16
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

event clicked;String ls_clase

dw_1.visible = true
dw_2.visible = true
pb_1.visible = true
pb_2.visible = true
dw_text.visible = true
st_1.visible = false

dw_report.visible = false	
dw_1.reset()
dw_2.reset()

dw_1.retrieve( sle_almacen.text)
end event

type st_1 from statictext within w_al743_stocks_tranporte
integer x = 18
integer y = 248
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

type dw_text from datawindow within w_al743_stocks_tranporte
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 379
integer y = 240
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

type uo_1 from u_ingreso_fecha within w_al743_stocks_tranporte
event destroy ( )
integer x = 78
integer y = 120
integer taborder = 70
boolean bringtotop = true
end type

on uo_1.destroy
call u_ingreso_fecha::destroy
end on

event constructor;call super::constructor;String ls_desde
 
 of_set_label('Al:') 								//	para setear la fecha inicial
 
 ls_desde = '01/' + string(month(today()))+'/' + string(year(today()))
 of_set_fecha(today()) 				// para seatear el titulo del boton
 of_set_rango_inicio(date('01/01/1900')) 				// rango inicial
 of_set_rango_fin(date('31/12/9999'))		
end event

type sle_almacen from singlelineedit within w_al743_stocks_tranporte
event dobleclick pbm_lbuttondblclk
integer x = 759
integer y = 104
integer width = 224
integer height = 88
integer taborder = 100
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
	    + "FROM almacen " &
		 + "where flag_tipo_almacen = 'O'"
				 
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
where almacen = :ls_almacen 
  and flag_tipo_almacen = 'O';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Almacen no existe o no es un almacén de tránsito')
	return
end if

sle_descrip.text = ls_desc
Parent.event dynamic ue_seleccionar()
cb_seleccionar.visible = true

end event

type sle_descrip from singlelineedit within w_al743_stocks_tranporte
integer x = 987
integer y = 104
integer width = 1211
integer height = 88
integer taborder = 110
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

type rb_detalle from radiobutton within w_al743_stocks_tranporte
integer x = 2341
integer y = 64
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Detalle"
boolean checked = true
boolean lefttext = true
end type

type rb_resumen from radiobutton within w_al743_stocks_tranporte
integer x = 2341
integer y = 140
integer width = 594
integer height = 76
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resumen"
boolean lefttext = true
end type

type gb_1 from groupbox within w_al743_stocks_tranporte
integer x = 731
integer width = 1518
integer height = 228
integer taborder = 40
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Almacen:"
end type

type gb_tipo_reporte from groupbox within w_al743_stocks_tranporte
integer x = 2299
integer width = 667
integer height = 228
integer taborder = 80
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Tipo Reporte"
end type

