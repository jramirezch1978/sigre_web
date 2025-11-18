$PBExportHeader$w_al021_articulo_venta_precios.srw
forward
global type w_al021_articulo_venta_precios from w_abc_master_smpl
end type
type st_campo from statictext within w_al021_articulo_venta_precios
end type
type dw_1 from datawindow within w_al021_articulo_venta_precios
end type
end forward

global type w_al021_articulo_venta_precios from w_abc_master_smpl
integer width = 3054
integer height = 2204
string title = "[AL021] Precios de Venta de Articulos"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
st_campo st_campo
dw_1 dw_1
end type
global w_al021_articulo_venta_precios w_al021_articulo_venta_precios

type variables
String  is_col = 'cod_art'
Integer ii_ik[]
str_parametros ist_datos
end variables

on w_al021_articulo_venta_precios.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
this.st_campo=create st_campo
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
end on

on w_al021_articulo_venta_precios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event resize;dw_master.width  = newwidth  - dw_master.x
dw_master.height = newheight - dw_master.y
end event

type dw_master from w_abc_master_smpl`dw_master within w_al021_articulo_venta_precios
integer x = 37
integer y = 128
integer width = 2930
integer height = 1316
string dataobject = "d_abc_articulo_venta_precios"
end type

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row


li_col = dw_master.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col    = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color  = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	st_campo.text = "Orden: " + is_col
	dw_1.reset()
	dw_1.InsertRow(0)
	dw_1.SetFocus()
ELSE
	ll_row = this.GetRow()
	
	if ll_row > 0 then		
		Any     la_id
		Integer li_x, li_y
		String  ls_tipo

		FOR li_x = 1 TO UpperBound(ii_ik)			
			la_id = dw_master.object.data.primary.current[dw_master.getrow(), ii_ik[li_x]]
			// tipo del dato
			ls_tipo = This.Describe("#" + String(ii_ik[li_x]) + ".ColType")

			IF LEFT( ls_tipo,1) = 'd' THEN
				ist_datos.field_ret[li_x] = string ( la_id)
			ELSEIF LEFT( ls_tipo,1) = 'c'  THEN
				ist_datos.field_ret[li_x] = la_id
			END IF
			
		NEXT
		
		ist_datos.titulo = "s"		

	END IF
END IF
end event

type st_campo from statictext within w_al021_articulo_venta_precios
integer x = 37
integer y = 36
integer width = 699
integer height = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_al021_articulo_venta_precios
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 768
integer y = 32
integer width = 2199
integer height = 76
integer taborder = 10
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_master.triggerevent(doubleclicked!)
Return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_master.Getrow()

Return ll_row
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
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
	
		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
			this.setfocus()
		end if
	End if	
end if	
SetPointer(arrow!)
end event

