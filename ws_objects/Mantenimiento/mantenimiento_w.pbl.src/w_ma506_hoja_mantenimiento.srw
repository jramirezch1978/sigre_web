$PBExportHeader$w_ma506_hoja_mantenimiento.srw
forward
global type w_ma506_hoja_mantenimiento from w_cns
end type
type st_2 from statictext within w_ma506_hoja_mantenimiento
end type
type pb_3 from picturebutton within w_ma506_hoja_mantenimiento
end type
type pb_2 from picturebutton within w_ma506_hoja_mantenimiento
end type
type pb_1 from picturebutton within w_ma506_hoja_mantenimiento
end type
type dw_lista from u_dw_list_tbl within w_ma506_hoja_mantenimiento
end type
type dw_text from datawindow within w_ma506_hoja_mantenimiento
end type
type st_1 from statictext within w_ma506_hoja_mantenimiento
end type
type dw_rpt from u_dw_rpt within w_ma506_hoja_mantenimiento
end type
end forward

global type w_ma506_hoja_mantenimiento from w_cns
integer width = 3639
integer height = 2048
string title = "Hoja de Mantenimiento (MA506)"
string menuname = "m_cns"
st_2 st_2
pb_3 pb_3
pb_2 pb_2
pb_1 pb_1
dw_lista dw_lista
dw_text dw_text
st_1 st_1
dw_rpt dw_rpt
end type
global w_ma506_hoja_mantenimiento w_ma506_hoja_mantenimiento

type variables
String is_col
end variables

on w_ma506_hoja_mantenimiento.create
int iCurrent
call super::create
if this.MenuName = "m_cns" then this.MenuID = create m_cns
this.st_2=create st_2
this.pb_3=create pb_3
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_lista=create dw_lista
this.dw_text=create dw_text
this.st_1=create st_1
this.dw_rpt=create dw_rpt
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.pb_3
this.Control[iCurrent+3]=this.pb_2
this.Control[iCurrent+4]=this.pb_1
this.Control[iCurrent+5]=this.dw_lista
this.Control[iCurrent+6]=this.dw_text
this.Control[iCurrent+7]=this.st_1
this.Control[iCurrent+8]=this.dw_rpt
end on

on w_ma506_hoja_mantenimiento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.pb_3)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_lista)
destroy(this.dw_text)
destroy(this.st_1)
destroy(this.dw_rpt)
end on

event resize;call super::resize;dw_lista.height = newheight - dw_lista.y - 10
dw_lista.width  = newwidth  - dw_lista.x   - 10
dw_rpt.width    = newwidth  - dw_rpt.x   - 10
dw_rpt.height   = newheight - dw_rpt.y   - 10
end event

event ue_open_pre();call super::ue_open_pre;dw_lista.SetTransObject(sqlca)
dw_rpt.SetTransObject(sqlca)
dw_lista.Retrieve()
//idw_1 = dw_lista   // asignar dw corriente
//dw_detail.BorderStyle = StyleRaised! // indicar dw_detail como no activado

//Help
ii_help = 506
of_position_window(0,0)        // Posicionar la ventana en forma fija

end event

type st_2 from statictext within w_ma506_hoja_mantenimiento
integer x = 2080
integer y = 124
integer width = 983
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Dar Doble Click en la Columna a Buscar"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within w_ma506_hoja_mantenimiento
boolean visible = false
integer x = 3104
integer y = 72
integer width = 146
integer height = 120
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\Bmp\PRINTER.BMP"
alignment htextalign = left!
end type

event clicked;dw_rpt.TriggerEvent('ue_print')
end event

type pb_2 from picturebutton within w_ma506_hoja_mantenimiento
integer x = 3269
integer y = 72
integer width = 146
integer height = 120
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "c:\sigre\resources\Bmp\PRINTER.BMP"
alignment htextalign = left!
end type

event clicked;Long 	 ll_currow,ll_rows
String ls_origen,ls_nro_orden


ll_currow = dw_lista.Getrow()

IF dw_lista.IsSelected(ll_currow) THEN
	ls_origen 	 = dw_lista.Object.cod_origen[ll_currow] 
	ls_nro_orden = dw_lista.Object.nro_orden[ll_currow] 
	
	ll_rows = dw_rpt.Retrieve(gs_empresa,gs_user,ls_origen,ls_nro_orden)
	
	IF ll_rows <= 0  THEN Return 
	
	pb_1.Visible 		= True
	pb_2.Visible 		= False
	pb_3.Visible 		= True
	dw_rpt.Visible		= True
	dw_lista.Visible	= False
	dw_text.Visible	= False
	st_1.Visible		= False
	st_2.Visible		= False
	dw_rpt.Object.p_logo.filename = gs_logo
	
ELSE
	Messagebox('Aviso','Debe Seleccionar Algun Registro')
END IF
end event

type pb_1 from picturebutton within w_ma506_hoja_mantenimiento
integer x = 3269
integer y = 72
integer width = 146
integer height = 120
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\Bmp\retroceder.bmp"
alignment htextalign = left!
end type

event clicked;pb_1.Visible 		= False
pb_2.Visible 		= True
pb_3.Visible 		= False
dw_rpt.Visible		= False
dw_lista.Visible	= True
dw_text.Visible	= True
st_1.Visible		= True
st_2.Visible		= True


end event

type dw_lista from u_dw_list_tbl within w_ma506_hoja_mantenimiento
integer x = 9
integer y = 216
integer width = 3392
integer taborder = 20
string dataobject = "d_ord_trabajo_cerradas_tbl"
end type

event doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color, ls_desc_campo
Long ll_row

li_col = dw_lista.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')

IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	ls_desc_campo = This.Describe(ls_column)
	
	st_1.text = 'Busqueda en Campo '+ls_desc_campo+' : '
	
	
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event constructor;call super::constructor;ii_ck[1] = 1          // columnas de lectrua de este dw
end event

type dw_text from datawindow within w_ma506_hoja_mantenimiento
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 946
integer y = 100
integer width = 1102
integer height = 80
integer taborder = 10
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();dw_lista.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_lista.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_lista.scrollnextrow()	
end if
ll_row = dw_text.Getrow()

Return ll_row
end event

event constructor;// Adiciona registro en dw1
Long ll_reg

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
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_lista.find(ls_comando, 1, dw_lista.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_lista.selectrow(0, false)
			dw_lista.selectrow(ll_fila,true)
			dw_lista.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type st_1 from statictext within w_ma506_hoja_mantenimiento
integer x = 27
integer y = 112
integer width = 896
integer height = 64
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

type dw_rpt from u_dw_rpt within w_ma506_hoja_mantenimiento
integer x = 9
integer y = 216
integer width = 3392
integer taborder = 20
string dataobject = "d_rpt_hoja_mantenimiento_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

