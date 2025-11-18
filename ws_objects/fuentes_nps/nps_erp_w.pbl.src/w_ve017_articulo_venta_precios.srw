$PBExportHeader$w_ve017_articulo_venta_precios.srw
forward
global type w_ve017_articulo_venta_precios from w_abc_master_smpl
end type
type st_campo from statictext within w_ve017_articulo_venta_precios
end type
type dw_1 from datawindow within w_ve017_articulo_venta_precios
end type
end forward

global type w_ve017_articulo_venta_precios from w_abc_master_smpl
integer width = 3054
integer height = 2328
string title = "[VE017] Precios de Venta de Articulos"
string menuname = "m_mtto_smpl"
st_campo st_campo
dw_1 dw_1
end type
global w_ve017_articulo_venta_precios w_ve017_articulo_venta_precios

type variables
String  is_col = 'cod_art'
Integer ii_ik[]
str_parametros ist_datos
end variables

on w_ve017_articulo_venta_precios.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
this.st_campo=create st_campo
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_1
end on

on w_ve017_articulo_venta_precios.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type ole_skin from w_abc_master_smpl`ole_skin within w_ve017_articulo_venta_precios
end type

type uo_h from w_abc_master_smpl`uo_h within w_ve017_articulo_venta_precios
end type

type st_box from w_abc_master_smpl`st_box within w_ve017_articulo_venta_precios
end type

type st_filter from w_abc_master_smpl`st_filter within w_ve017_articulo_venta_precios
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_ve017_articulo_venta_precios
end type

type dw_master from w_abc_master_smpl`dw_master within w_ve017_articulo_venta_precios
integer x = 503
integer y = 376
integer width = 2935
integer height = 1136
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

type st_campo from statictext within w_ve017_articulo_venta_precios
integer x = 558
integer y = 284
integer width = 699
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
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_1 from datawindow within w_ve017_articulo_venta_precios
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 1289
integer y = 280
integer width = 2190
integer height = 80
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

