$PBExportHeader$w_pop_articulos.srw
forward
global type w_pop_articulos from w_cns
end type
type st_master from statictext within w_pop_articulos
end type
type st_detail from statictext within w_pop_articulos
end type
type uo_search from n_cst_search within w_pop_articulos
end type
type cb_cancelar from commandbutton within w_pop_articulos
end type
type cb_aceptar from commandbutton within w_pop_articulos
end type
type dw_detail from u_dw_abc within w_pop_articulos
end type
type dw_master from u_dw_cns within w_pop_articulos
end type
end forward

global type w_pop_articulos from w_cns
integer width = 4059
integer height = 2356
string title = "Articulos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_aceptar ( )
event ue_filtro ( string as_filtro )
st_master st_master
st_detail st_detail
uo_search uo_search
cb_cancelar cb_cancelar
cb_aceptar cb_aceptar
dw_detail dw_detail
dw_master dw_master
end type
global w_pop_articulos w_pop_articulos

type variables
str_articulo 	istr_articulo
str_parametros istr_param

end variables

event ue_aceptar();if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = false
	return
end if

istr_articulo.b_return = true

istr_articulo.cod_art 				= dw_master.object.cod_art 			[dw_master.GetRow()]
istr_articulo.desc_art 				= dw_master.object.desc_art 			[dw_master.GetRow()]
istr_articulo.und 					= dw_master.object.und 					[dw_master.GetRow()]
istr_articulo.und2 					= dw_master.object.und2					[dw_master.GetRow()]
istr_articulo.cat_Art 				= dw_master.object.cat_art 			[dw_master.GetRow()]
istr_articulo.cod_sub_cat			= dw_master.object.cod_sub_cat 		[dw_master.GetRow()]
istr_articulo.cod_sku				= dw_master.object.cod_sku 			[dw_master.GetRow()]

//Pongo los precios
istr_articulo.precio_vta_unidad 	= Dec(dw_master.object.precio_vta_unidad 	[dw_master.GetRow()])
istr_articulo.precio_vta_mayor	= Dec(dw_master.object.precio_vta_mayor 	[dw_master.GetRow()])
istr_articulo.precio_vta_oferta	= Dec(dw_master.object.precio_vta_oferta 	[dw_master.GetRow()])
istr_articulo.precio_vta_min 		= Dec(dw_master.object.precio_vta_min 		[dw_master.GetRow()])

istr_articulo.almacen 				= gnvo_app.is_null
istr_articulo.saldo_total 			= 0.00

CloseWithReturn( this, istr_articulo)

end event

event ue_filtro(string as_filtro);if istr_param.string1 = 'clase' then
	dw_master.Retrieve( as_filtro, istr_param.string2 )
else
	dw_master.Retrieve( as_filtro )
end if
end event

on w_pop_articulos.create
int iCurrent
call super::create
this.st_master=create st_master
this.st_detail=create st_detail
this.uo_search=create uo_search
this.cb_cancelar=create cb_cancelar
this.cb_aceptar=create cb_aceptar
this.dw_detail=create dw_detail
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.st_detail
this.Control[iCurrent+3]=this.uo_search
this.Control[iCurrent+4]=this.cb_cancelar
this.Control[iCurrent+5]=this.cb_aceptar
this.Control[iCurrent+6]=this.dw_detail
this.Control[iCurrent+7]=this.dw_master
end on

on w_pop_articulos.destroy
call super::destroy
destroy(this.st_master)
destroy(this.st_detail)
destroy(this.uo_search)
destroy(this.cb_cancelar)
destroy(this.cb_aceptar)
destroy(this.dw_detail)
destroy(this.dw_master)
end on

event resize;call super::resize;dw_master.width  	= newwidth  - dw_master.x - 10
st_master.width 	= dw_master.width

dw_detail.width  	= newwidth  - dw_detail.x - 10
dw_detail.height 	= newheight - dw_detail.y - 10
st_detail.width 	= dw_detail.width
end event

event ue_open_pre;call super::ue_open_pre;
istr_param = Message.PowerObjectParm

if istr_param.string1 = 'clase' then
	
	dw_master.DataObject = 'd_sel_articulos_usuario_tbl'
	
elseif istr_param.string1 = 'bonif' then
	
	dw_master.DataObject = 'd_sel_articulos_bonif_tbl'
	
elseif istr_param.string1 = 'activos' then
	
	dw_master.DataObject = 'd_sel_articulos_activos_tbl'	
	
else
	
	dw_master.DataObject = 'd_sel_articulos_all_tbl'
	
end if


dw_master.SetTransObject(sqlca)
dw_detail.SetTransObject(sqlca)

uo_search.of_set_dw_cns(dw_master)

if istr_param.b_precarga then
	this.event dynamic ue_filtro( '%%' )
end if

uo_search.setFocus()
uo_search.set_focus_dw( )
end event

type st_master from statictext within w_pop_articulos
integer y = 84
integer width = 2199
integer height = 80
integer textsize = -9
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 8388608
string text = "Listado de Articulos"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_detail from statictext within w_pop_articulos
integer y = 1692
integer width = 2199
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

type uo_search from n_cst_search within w_pop_articulos
event destroy ( )
integer taborder = 10
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event dynamic ue_filtro( upper(ls_buscar))
end event

type cb_cancelar from commandbutton within w_pop_articulos
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

type cb_aceptar from commandbutton within w_pop_articulos
integer x = 2939
integer width = 283
integer height = 80
integer taborder = 10
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

type dw_detail from u_dw_abc within w_pop_articulos
integer y = 1784
integer width = 2199
integer height = 472
integer taborder = 20
string dataobject = "d_sel_articulo_equivalencias_venta"
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

type dw_master from u_dw_cns within w_pop_articulos
integer y = 176
integer width = 2199
integer height = 1512
boolean bringtotop = true
string dataobject = "d_sel_articulos_all_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'  	// tabular(default), form

ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
end event

event getfocus;call super::getfocus;//dw_1.SetFocus()
end event

event doubleclicked;call super::doubleclicked;if row > 0 then
	parent.event ue_aceptar( )
end if
end event

event rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

f_Select_current_row(this)

dw_Detail.retrieve( this.object.cod_art[currentrow])
dw_Detail.SelectRow(0, False)

cb_aceptar.enabled = true
end event

