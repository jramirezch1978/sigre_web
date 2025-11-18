$PBExportHeader$w_ve743_stocks_fisico.srw
forward
global type w_ve743_stocks_fisico from w_rpt_list
end type
type gb_fechas from groupbox within w_ve743_stocks_fisico
end type
type cb_seleccionar from commandbutton within w_ve743_stocks_fisico
end type
type st_1 from statictext within w_ve743_stocks_fisico
end type
type dw_text from datawindow within w_ve743_stocks_fisico
end type
type uo_1 from u_ingreso_fecha within w_ve743_stocks_fisico
end type
type rb_1 from radiobutton within w_ve743_stocks_fisico
end type
type rb_2 from radiobutton within w_ve743_stocks_fisico
end type
type gb_1 from groupbox within w_ve743_stocks_fisico
end type
end forward

global type w_ve743_stocks_fisico from w_rpt_list
integer width = 3511
integer height = 2000
string title = "Stocks Fisico (al706)"
string menuname = "m_reporte"
windowstate windowstate = maximized!
long backcolor = 67108864
gb_fechas gb_fechas
cb_seleccionar cb_seleccionar
st_1 st_1
dw_text dw_text
uo_1 uo_1
rb_1 rb_1
rb_2 rb_2
gb_1 gb_1
end type
global w_ve743_stocks_fisico w_ve743_stocks_fisico

type variables
String is_col = '', is_type


end variables

on w_ve743_stocks_fisico.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.gb_fechas=create gb_fechas
this.cb_seleccionar=create cb_seleccionar
this.st_1=create st_1
this.dw_text=create dw_text
this.uo_1=create uo_1
this.rb_1=create rb_1
this.rb_2=create rb_2
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.gb_fechas
this.Control[iCurrent+2]=this.cb_seleccionar
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_text
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.rb_1
this.Control[iCurrent+7]=this.rb_2
this.Control[iCurrent+8]=this.gb_1
end on

on w_ve743_stocks_fisico.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.gb_fechas)
destroy(this.cb_seleccionar)
destroy(this.st_1)
destroy(this.dw_text)
destroy(this.uo_1)
destroy(this.rb_1)
destroy(this.rb_2)
destroy(this.gb_1)
end on

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y

dw_1.height = newheight - dw_1.y
dw_2.height = newheight - dw_2.y
end event

type dw_report from w_rpt_list`dw_report within w_ve743_stocks_fisico
boolean visible = false
integer x = 23
integer y = 312
integer width = 3319
integer height = 1960
integer taborder = 30
string dataobject = "d_rpt_stocks_fisico"
end type

type dw_1 from w_rpt_list`dw_1 within w_ve743_stocks_fisico
integer x = 32
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 100
string dataobject = "d_lista_articulo_almacen_con_stk_tbl"
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
	
	st_1.text = "Busca: " + dw_1.describe( is_col + "_t.text")
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)
END  IF

end event

event dw_1::getfocus;call super::getfocus;dw_text.SetFocus()
end event

type pb_1 from w_rpt_list`pb_1 within w_ve743_stocks_fisico
integer x = 1728
integer y = 876
integer taborder = 110
end type

event pb_1::clicked;call super::clicked;if dw_2.Rowcount() > 0 then
	cb_report.enabled = true
end if
	
end event

type pb_2 from w_rpt_list`pb_2 within w_ve743_stocks_fisico
integer x = 1728
integer y = 1044
integer taborder = 130
alignment htextalign = center!
end type

type dw_2 from w_rpt_list`dw_2 within w_ve743_stocks_fisico
integer x = 1915
integer y = 400
integer width = 1669
integer height = 1416
integer taborder = 120
string dataobject = "d_lista_articulo_almacen_con_stk_tbl"
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

type cb_report from w_rpt_list`cb_report within w_ve743_stocks_fisico
integer x = 1618
integer y = 168
integer width = 366
integer height = 84
integer taborder = 80
boolean enabled = false
string text = "Reporte"
boolean default = true
end type

event cb_report::clicked;call super::clicked;Date ld_desde
double ln_saldo

ld_desde = uo_1.of_get_fecha()
Long 	ll_row
String ls_cod 

SetPointer( Hourglass!)

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
	
dw_report.SetTransObject( sqlca)
parent.Event ue_preview()
dw_report.retrieve(ld_desde)	
dw_report.object.fec_ini.text = STRING(LD_DESDE, "DD/MM/YYYY")
dw_report.object.t_user.text = gs_user
dw_report.object.t_almacen.text = 'Todos los almacenes'
dw_report.Object.p_logo.filename = gs_logo

dw_report.visible = true
		
//this.enabled = false
cb_seleccionar.enabled = true
cb_seleccionar.visible = true

end event

type gb_fechas from groupbox within w_ve743_stocks_fisico
integer x = 46
integer y = 4
integer width = 667
integer height = 252
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

type cb_seleccionar from commandbutton within w_ve743_stocks_fisico
integer x = 1618
integer y = 48
integer width = 366
integer height = 96
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

dw_1.retrieve()
end event

type st_1 from statictext within w_ve743_stocks_fisico
integer y = 328
integer width = 384
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
string text = "Buscar:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_ve743_stocks_fisico
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

type uo_1 from u_ingreso_fecha within w_ve743_stocks_fisico
event destroy ( )
integer x = 78
integer y = 120
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
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

type rb_1 from radiobutton within w_ve743_stocks_fisico
integer x = 869
integer y = 104
integer width = 416
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Saldo actual"
boolean checked = true
end type

type rb_2 from radiobutton within w_ve743_stocks_fisico
integer x = 869
integer y = 172
integer width = 526
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
string text = "Saldo a una fecha"
end type

type gb_1 from groupbox within w_ve743_stocks_fisico
integer x = 850
integer y = 12
integer width = 576
integer height = 252
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opción"
end type

