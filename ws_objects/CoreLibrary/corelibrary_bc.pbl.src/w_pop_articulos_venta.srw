$PBExportHeader$w_pop_articulos_venta.srw
forward
global type w_pop_articulos_venta from w_cns
end type
type cb_aceptar from commandbutton within w_pop_articulos_venta
end type
type cb_cancelar from commandbutton within w_pop_articulos_venta
end type
type st_2 from statictext within w_pop_articulos_venta
end type
type st_1 from statictext within w_pop_articulos_venta
end type
type uo_search from n_cst_search within w_pop_articulos_venta
end type
type dw_almacen from u_dw_abc within w_pop_articulos_venta
end type
type dw_equivalencias from u_dw_abc within w_pop_articulos_venta
end type
type dw_master from u_dw_cns within w_pop_articulos_venta
end type
end forward

global type w_pop_articulos_venta from w_cns
integer width = 3941
integer height = 1972
string title = "Articulos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_filtro ( string as_filtro )
event ue_aceptar ( )
cb_aceptar cb_aceptar
cb_cancelar cb_cancelar
st_2 st_2
st_1 st_1
uo_search uo_search
dw_almacen dw_almacen
dw_equivalencias dw_equivalencias
dw_master dw_master
end type
global w_pop_articulos_venta w_pop_articulos_venta

type variables
str_articulo istr_articulo
String is_opcion, is_par, is_campo, is_almacen
end variables

forward prototypes
public function string wf_condicion_sql (string as_cadena)
public subroutine of_carga_datos ()
end prototypes

event ue_filtro(string as_filtro);dw_master.Retrieve( as_filtro, is_almacen )
end event

event ue_aceptar();if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = false
	return
end if

if dw_almacen.RowCount() = 0 then
	if MessageBox('Informacion', &
		'Ha elegido un articulo que no tiene registro alguno en ningún almacén. ¿Desea Continuar?', &
		Information!, &
		YesNo!, 2 ) = 2 then return
end if

if dw_almacen.RowCount() > 0 then
	if dw_almacen.GetSelectedRow(0) = 0 then
		gnvo_app.of_mensaje_error('Debe seleccionar al menos un almacen en el registro del detalle')
		return
	end if
end if

istr_articulo.b_return = true

istr_articulo.cod_art 				= dw_master.object.cod_art 			[dw_master.GetRow()]
istr_articulo.desc_art 				= dw_master.object.desc_art 			[dw_master.GetRow()]
istr_articulo.und 					= dw_master.object.und 					[dw_master.GetRow()]
istr_articulo.cat_Art 				= dw_master.object.cat_art 			[dw_master.GetRow()]
istr_articulo.cod_sub_cat			= dw_master.object.cod_sub_cat 		[dw_master.GetRow()]
istr_articulo.cod_sku				= dw_master.object.cod_sku 			[dw_master.GetRow()]
//istr_articulo.cnta_prsp_egreso 	= dw_master.object.cnta_prsp_egreso [dw_master.GetRow()]
//istr_articulo.cnta_prsp_ingreso 	= dw_master.object.cnta_prsp_ingreso[dw_master.GetRow()]

//Pongo los precios
istr_articulo.precio_vta_unidad 	= Dec(dw_master.object.precio_vta_unidad 	[dw_master.GetRow()])
istr_articulo.precio_vta_mayor	= Dec(dw_master.object.precio_vta_mayor 	[dw_master.GetRow()])
istr_articulo.precio_vta_oferta	= Dec(dw_master.object.precio_vta_oferta 	[dw_master.GetRow()])
istr_articulo.precio_vta_min 		= Dec(dw_master.object.precio_vta_min 		[dw_master.GetRow()])

if dw_almacen.RowCount() > 0 and dw_almacen.GetSelectedRow(0) > 0 then
	istr_articulo.almacen 		= dw_almacen.object.almacen			[dw_almacen.getSelectedRow(0)]	
	istr_articulo.saldo_total 	= Dec(dw_almacen.object.sldo_total	[dw_almacen.getSelectedRow(0)]	)
else
	istr_articulo.almacen 		= gnvo_app.is_null
	istr_articulo.saldo_total 	= 0.00
end if

CloseWithReturn( this, istr_articulo)

end event

public function string wf_condicion_sql (string as_cadena);//****************************************************************************************//
// Permite Crear el Criterio de Filtro dentro del Where
//****************************************************************************************//
//String  ls_descripcion
//
//ls_descripcion = "'"+TRIM(dw_1.object.campo[1])+'%'+"'"
//if Pos(UPPER(dw_master.GetSQLSelect()),'WHERE',1) > 0 then
//	as_cadena = ' AND ( '+ as_cadena +' LIKE '+ls_descripcion+' )'
//ELSE
//	as_cadena = ' WHERE ( ' + as_cadena +' LIKE '+ls_descripcion+' )' 
//END IF	
//
Return as_cadena
end function

public subroutine of_carga_datos ();//Decimal ld_stock_disp
//Long ll_row
//
//ll_row = dw_detail_2.getrow( )
//
//if ll_row=0 then
//	MessageBox('Aviso', 'No hay stock disponible en ningun almacen para este articulo, por favor verifique')
//	return
//end if
//	
//ld_stock_disp = dw_detail_2.object.sldo_total[ll_row]
//if ld_stock_disp = 0 then
//	MessageBox('Aviso', 'Se esta seleccionando un almacen en el cual no hay stock disponible, por favor verifique')
//	return
//end if
//	
//ist_datos.field_ret[1] = dw_detail_2.object.cod_art[ll_row]
//ist_datos.field_ret[2] = dw_detail_2.object.desc_Art[ll_row]
//ist_datos.field_ret[3] = dw_detail_2.object.und[ll_row]
//ist_datos.field_ret[4] = String(dw_detail_2.object.costo_ult_compra[ll_row])	
//ist_datos.field_ret[5] = String(dw_detail_2.object.dias_reposicion [ll_row])
//ist_datos.field_ret[6] = String(dw_detail_2.object.dias_rep_import [ll_row])
//ist_datos.field_ret[7] = String(dw_detail_2.object.cnta_prsp_ingreso [ll_row])
//ist_datos.field_ret[8] = dw_detail_2.object.almacen[ll_row]
//ist_datos.field_ret[9] = String(ld_stock_disp)
//ist_datos.field_ret[10] = String(dw_detail_2.object.precio_minorista[ll_row])
//
end subroutine

event ue_open_pre;str_parametros lstr_param

try 
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.string1 = 'stock' then
		
		if upper(gs_empresa) = 'FLORES' or gnvo_App.of_get_parametro("VTA_LISTADO_ARTICULOS_SMALL", "0") = "1" then
			dw_master.DAtaObject = 'd_sel_articulo_venta_small_tbl'
		else
			dw_master.DAtaObject = 'd_sel_articulo_venta_tbl'
		end if
		
	elseif lstr_param.string1 = 'stock_facturable' then
		
		if upper(gs_empresa) = 'FLORES' or gnvo_App.of_get_parametro("VTA_LISTADO_ARTICULOS_SMALL", "0") = "1" then
			dw_master.DAtaObject = 'd_sel_articulo_venta_facturable_small_tbl'
		else
			dw_master.DAtaObject = 'd_sel_articulo_venta_facturable_tbl'
		end if
	
	else
		
		MessageBox('Error', 'No ha expecificado el tipo de String1 en tabla parametros, por favor verifique!', StopSign!)
		post event close()
		return
		
	end if
	
	
	dw_master.SetTransObject(sqlca)
	dw_equivalencias.SetTransObject(sqlca)
	dw_almacen.SetTransObject(sqlca)
	
	uo_search.of_set_dw_cns(dw_master)
	
	if lstr_param.almacen = '' then
		is_almacen = '%%'
	else
		is_almacen = trim(lstr_param.almacen) + '%'
	end if
	
	
	
	if lstr_param.b_precarga then
		this.event dynamic ue_filtro( '%%' )
	end if
	
	uo_search.setFocus()
	uo_search.set_focus_dw( )

catch ( Exception ex )
	gnvo_app.of_catch_Exception(ex, "Error al abrir el listado de articulos de ventas")
	
finally
	/*statementBlock*/
end try

end event

on w_pop_articulos_venta.create
int iCurrent
call super::create
this.cb_aceptar=create cb_aceptar
this.cb_cancelar=create cb_cancelar
this.st_2=create st_2
this.st_1=create st_1
this.uo_search=create uo_search
this.dw_almacen=create dw_almacen
this.dw_equivalencias=create dw_equivalencias
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_aceptar
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.uo_search
this.Control[iCurrent+6]=this.dw_almacen
this.Control[iCurrent+7]=this.dw_equivalencias
this.Control[iCurrent+8]=this.dw_master
end on

on w_pop_articulos_venta.destroy
call super::destroy
destroy(this.cb_aceptar)
destroy(this.cb_cancelar)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.uo_search)
destroy(this.dw_almacen)
destroy(this.dw_equivalencias)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width		= newwidth  - dw_master.x - 10

dw_equivalencias.width		= newwidth/2  - dw_equivalencias.x - 10
dw_equivalencias.height		= newheight - dw_equivalencias.y - 10
st_1.width						= dw_equivalencias.width


dw_almacen.x			= dw_equivalencias.x + dw_equivalencias.width + 10
dw_almacen.width		= newwidth  - dw_almacen.x - 10
dw_almacen.height		= newheight - dw_almacen.y - 10

st_2.x					= dw_almacen.x
st_2.width				= dw_almacen.width
end event

type cb_aceptar from commandbutton within w_pop_articulos_venta
integer x = 2939
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "Aceptar"
end type

event clicked;parent.event dynamic ue_aceptar()
end event

type cb_cancelar from commandbutton within w_pop_articulos_venta
integer x = 3223
integer width = 283
integer height = 80
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;istr_articulo.b_Return = false
CloseWithReturn( parent, istr_articulo)

end event

type st_2 from statictext within w_pop_articulos_venta
integer x = 2277
integer y = 1308
integer width = 1353
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Saldos en almacen"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_pop_articulos_venta
integer y = 1308
integer width = 2263
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Equivalencias"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type uo_search from n_cst_search within w_pop_articulos_venta
event destroy ( )
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event dynamic ue_filtro( ls_buscar)
end event

type dw_almacen from u_dw_abc within w_pop_articulos_venta
integer x = 2277
integer y = 1392
integer width = 1353
integer height = 472
integer taborder = 30
string dataobject = "d_sel_articulo_almacen_venta"
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

type dw_equivalencias from u_dw_abc within w_pop_articulos_venta
integer y = 1392
integer width = 2263
integer height = 472
integer taborder = 20
string dataobject = "d_sel_articulo_equivalencias_venta"
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

f_Select_current_row(this)

Choose case is_opcion
	case '3'		
		dw_almacen.retrieve( this.object.cod_equiva[currentrow], is_almacen)
		dw_almacen.SelectRow(1, true)
End Choose
end event

type dw_master from u_dw_cns within w_pop_articulos_venta
integer y = 100
integer width = 3602
integer height = 1196
boolean bringtotop = true
string dataobject = "d_sel_articulo_venta_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

f_Select_current_row(this)

this.event ue_output(currentrow)
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event ue_aceptar( )
end if
end event

event ue_output;call super::ue_output;dw_equivalencias.retrieve( this.object.cod_art[al_row])
dw_equivalencias.SelectRow(0, False)

dw_almacen.retrieve( dw_master.object.cod_art[al_row], is_almacen)
dw_almacen.SelectRow(1, true)


cb_aceptar.enabled = true
end event

event clicked;call super::clicked;if row > 0 then
	this.event ue_output(row)
end if
end event

