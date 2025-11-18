$PBExportHeader$w_search_clientes.srw
forward
global type w_search_clientes from w_abc
end type
type cb_nuevo from commandbutton within w_search_clientes
end type
type cb_cancelar from commandbutton within w_search_clientes
end type
type dw_master from u_dw_abc within w_search_clientes
end type
type uo_search from n_cst_search within w_search_clientes
end type
end forward

global type w_search_clientes from w_abc
integer width = 3602
integer height = 1864
string title = "Busqueda del Cliente"
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_filtro ( string as_filtro )
event ue_nuevo ( )
cb_nuevo cb_nuevo
cb_cancelar cb_cancelar
dw_master dw_master
uo_search uo_search
end type
global w_search_clientes w_search_clientes

type variables
Str_parametros istr_param
end variables

event ue_filtro(string as_filtro);dw_master.Retrieve( as_filtro )
end event

event ue_nuevo();Str_parametros lstr_param
string			ls_proveedor
long				ll_found

OpenWithParm(w_add_cliente, istr_param)

lstr_param = Message.Powerobjectparm

ls_proveedor = lstr_param.string1

if lstr_param.b_return then 
	
	
	uo_search.event ue_buscar( )
	
	if Not IsNull(ls_proveedor) and trim(ls_proveedor) <> '' then
		ll_found = dw_master.find( "proveedor='" + ls_proveedor + "'", 1, dw_master.RowCount())
		if ll_found > 0 then
			dw_master.setRow( ll_found )
			dw_master.Scrolltorow( ll_found )
			dw_master.selectrow( 0, false)
			dw_master.selectrow( ll_found, true)
		end if
	end if
end if
end event

on w_search_clientes.create
int iCurrent
call super::create
this.cb_nuevo=create cb_nuevo
this.cb_cancelar=create cb_cancelar
this.dw_master=create dw_master
this.uo_search=create uo_search
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_nuevo
this.Control[iCurrent+2]=this.cb_cancelar
this.Control[iCurrent+3]=this.dw_master
this.Control[iCurrent+4]=this.uo_search
end on

on w_search_clientes.destroy
call super::destroy
destroy(this.cb_nuevo)
destroy(this.cb_cancelar)
destroy(this.dw_master)
destroy(this.uo_search)
end on

event resize;call super::resize;uo_search.event ue_resize(sizetype, uo_search.width, newheight)

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10


end event

event ue_open_pre;call super::ue_open_pre;istr_param = Message.PowerObjectparm


If Not IsNull(istr_param) and IsValid(istr_param) then
	
	if (istr_param.tipo_doc = gnvo_app.finparam.is_doc_fac) then
		
		dw_master.DataObject = 'd_sel_clientes_only_fac_tbl'
	
	elseif (istr_param.tipo_doc = gnvo_app.finparam.is_doc_bvc) then
		
		dw_master.DataObject = 'd_sel_clientes_only_bvc_tbl'
		
	elseif istr_param.tipo_doc = gnvo_app.finparam.is_doc_ncc or &
			 istr_param.tipo_doc = gnvo_app.finparam.is_doc_ndc then
			 
		if left(istr_param.serie,1) = 'F' then
			dw_master.DataObject = 'd_sel_clientes_only_ncc_ndc_fac_tbl'
		elseif left(istr_param.serie,1) = 'B' then
			dw_master.DataObject = 'd_sel_clientes_only_ncc_ndc_bvc_tbl'
		else
			dw_master.DataObject = 'd_sel_clientes_only_ncc_ndc_others_tbl'
		end if
		
	else
		
		dw_master.DataObject = 'd_sel_clientes_others_tbl'
		
	end if
	
end if

dw_master.setTransObject(SQLCA)

uo_search.of_set_dw(dw_master)

this.event ue_filtro( '%%' )
uo_search.set_focus_dw( )
end event

event ue_cancelar;call super::ue_cancelar;str_cliente lstr_return

lstr_return.b_return = false

CloseWithReturn(this, lstr_return)
end event

event open;//Override
THIS.EVENT ue_open_pre()
//THIS.EVENT ue_dw_share()
//THIS.EVENT ue_retrieve_dddw()
end event

type cb_nuevo from commandbutton within w_search_clientes
integer x = 2949
integer y = 4
integer width = 288
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Nuevo"
end type

event clicked;parent.event dynamic ue_nuevo( )
end event

type cb_cancelar from commandbutton within w_search_clientes
integer x = 3237
integer y = 4
integer width = 288
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;parent.event ue_cancelar( )
end event

type dw_master from u_dw_abc within w_search_clientes
integer y = 104
integer width = 3182
integer height = 1608
integer taborder = 30
string dataobject = "d_sel_clientes_tbl"
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

event doubleclicked;call super::doubleclicked;str_cliente lstr_return

if row > 0 then
	lstr_return.proveedor 		= this.object.proveedor 		[row]
	lstr_return.nom_proveedor 	= this.object.nom_proveedor 	[row]
	lstr_return.tipo_doc_ident	= this.object.tipo_doc_ident 	[row]
	lstr_return.ruc_dni			= this.object.ruc_dni 			[row]
	lstr_return.direccion		= this.object.direccion 		[row]
	
	
	lstr_return.b_return = true
	
	
	closeWithReturn(parent, lstr_return)
end if
end event

type uo_search from n_cst_search within w_search_clientes
integer y = 4
integer width = 2953
integer height = 96
integer taborder = 30
end type

on uo_search.destroy
call n_cst_search::destroy
end on

event ue_buscar;call super::ue_buscar;String ls_buscar

ls_buscar = this.of_get_filtro()

parent.event dynamic ue_filtro( ls_buscar)
end event

