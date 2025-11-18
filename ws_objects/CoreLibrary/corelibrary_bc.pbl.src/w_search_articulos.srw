$PBExportHeader$w_search_articulos.srw
forward
global type w_search_articulos from w_cns
end type
type cb_cancelar from commandbutton within w_search_articulos
end type
type dw_master from u_dw_abc within w_search_articulos
end type
type uo_search from n_cst_search within w_search_articulos
end type
type dw_detail from u_dw_abc within w_search_articulos
end type
type cb_aceptar from commandbutton within w_search_articulos
end type
end forward

global type w_search_articulos from w_cns
integer width = 3657
integer height = 1972
string title = "Articulos"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_filtro ( string as_filtro )
event ue_aceptar ( )
cb_cancelar cb_cancelar
dw_master dw_master
uo_search uo_search
dw_detail dw_detail
cb_aceptar cb_aceptar
end type
global w_search_articulos w_search_articulos

type variables
str_articulo 	istr_articulo
String			is_array_Clase[]
end variables

forward prototypes
public function string wf_condicion_sql (string as_cadena)
end prototypes

event ue_filtro(string as_filtro);if UpperBound(is_array_clase) = 0 then
	dw_master.Retrieve(as_filtro)
else
	dw_master.Retrieve(as_filtro, is_array_clase)
end if

dw_detail.Reset()

if dw_master.RowCount() > 0 then
	dw_master.setRow(1)
	
	dw_master.SelectRow(0, false)
	dw_master.SelectRow(1, true)
	
	dw_master.event ue_output(1)
	
	cb_aceptar.enabled = true
else
	cb_aceptar.enabled = false
end if
end event

event ue_aceptar();if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = false
	return
end if

if dw_detail.RowCount() = 0 then
	if MessageBox('Informacion', &
		'Ha elegido un articulo que no tiene registro alguno en ningún almacén. ¿Desea Continuar?', &
		Information!, &
		YesNo!, 2 ) = 2 then return
end if

if dw_detail.RowCount() > 0 then
	if dw_detail.GetSelectedRow(0) = 0 then
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
istr_articulo.cnta_prsp_egreso 	= dw_master.object.cnta_prsp_egreso [dw_master.GetRow()]
istr_articulo.cnta_prsp_ingreso 	= dw_master.object.cnta_prsp_ingreso[dw_master.GetRow()]

//Clase de Articulo
istr_articulo.cod_clase 			= dw_master.object.cod_clase 			[dw_master.GetRow()]
istr_articulo.desc_clase 			= dw_master.object.desc_clase			[dw_master.GetRow()]


if dw_detail.RowCount() > 0 and dw_detail.GetSelectedRow(0) > 0 then
	istr_articulo.almacen 		= dw_detail.object.almacen		[dw_detail.getSelectedRow(0)]	
	istr_articulo.saldo_total 	= Dec(dw_detail.object.saldo	[dw_detail.getSelectedRow(0)]	)
else
	istr_articulo.almacen 		= gnvo_app.is_null
	istr_articulo.saldo_total 	= 0.00
end if

CloseWithReturn( this, istr_articulo)

end event

public function string wf_condicion_sql (string as_cadena);return ''
end function

on w_search_articulos.create
int iCurrent
call super::create
this.cb_cancelar=create cb_cancelar
this.dw_master=create dw_master
this.uo_search=create uo_search
this.dw_detail=create dw_detail
this.cb_aceptar=create cb_aceptar
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_cancelar
this.Control[iCurrent+2]=this.dw_master
this.Control[iCurrent+3]=this.uo_search
this.Control[iCurrent+4]=this.dw_detail
this.Control[iCurrent+5]=this.cb_aceptar
end on

on w_search_articulos.destroy
call super::destroy
destroy(this.cb_cancelar)
destroy(this.dw_master)
destroy(this.uo_search)
destroy(this.dw_detail)
destroy(this.cb_aceptar)
end on

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;Str_parametros lstr_param

if not IsNull(Message.PowerObjectParm) and IsValid(Message.PowerObjectParm) then
	lstr_param = Message.PowerObjectParm
	
	if UpperBound(lstr_param.array_clase) > 0 then
		dw_master.DataObject = 'd_sel_articulos_producibles_tv'
	else
		dw_master.DataObject = 'd_sel_articulos_tv'
	end if
	
	is_array_clase = lstr_param.array_clase
end if

dw_master.SetTransObject(SQLCA)


uo_search.of_set_dw(dw_master, dw_detail)

//this.event ue_filtro('%%')
end event

type cb_cancelar from commandbutton within w_search_articulos
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

type dw_master from u_dw_abc within w_search_articulos
integer y = 108
integer width = 2258
integer height = 1264
integer taborder = 30
string dataobject = "d_sel_articulos_tv"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail

end event

event ue_output;call super::ue_output;if al_row > 0 then
	gnvo_app.of_select_current_row(this)
	
	dw_detail.Retrieve(this.object.cod_art [al_row])
	
	if dw_detail.RowCount() = 1 then
		dw_detail.SelectRow(0, false)
		dw_detail.SelectRow(1, true)
		dw_detail.SetRow(1)
	end if
end if
end event

type uo_search from n_cst_search within w_search_articulos
event destroy ( )
integer taborder = 10
boolean bringtotop = true
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event ue_filtro( ls_buscar)
end event

event ue_post_editchanged;call super::ue_post_editchanged;if dw_master.RowCount() = 0 then
	cb_aceptar.enabled = true
else
	cb_aceptar.enabled = false
end if
end event

type dw_detail from u_dw_abc within w_search_articulos
integer y = 1380
integer width = 2203
integer height = 472
integer taborder = 20
string dataobject = "d_saldo_x_almacen_tbl"
boolean maxbox = true
end type

event constructor;call super::constructor;ii_ck[1] = 1
is_dwform = 'tabular' 
end event

type cb_aceptar from commandbutton within w_search_articulos
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

event clicked;parent.event ue_aceptar()
end event

