$PBExportHeader$w_cotiza.srw
forward
global type w_cotiza from window
end type
type cb_salir from commandbutton within w_cotiza
end type
type st_leyenda from statictext within w_cotiza
end type
type tab_principal from tab within w_cotiza
end type
type tab_clientes from userobject within tab_principal
end type
type cb_contactos from commandbutton within tab_clientes
end type
type dw_todo_clientes from u_dw_abc within tab_clientes
end type
type b_print from commandbutton within tab_clientes
end type
type b_delete from commandbutton within tab_clientes
end type
type b_nuevo from commandbutton within tab_clientes
end type
type b_open from commandbutton within tab_clientes
end type
type gb_buttons from groupbox within tab_clientes
end type
type tab_clientes from userobject within tab_principal
cb_contactos cb_contactos
dw_todo_clientes dw_todo_clientes
b_print b_print
b_delete b_delete
b_nuevo b_nuevo
b_open b_open
gb_buttons gb_buttons
end type
type tab_maestro_art from userobject within tab_principal
end type
type cb_add_articulos from commandbutton within tab_maestro_art
end type
type dw_articulos_details from u_dw_abc within tab_maestro_art
end type
type cb_agregar_sub_categ from commandbutton within tab_maestro_art
end type
type dw_master_sub_categ from u_dw_abc within tab_maestro_art
end type
type cb_agregar_categ from commandbutton within tab_maestro_art
end type
type dw_master_categ from u_dw_abc within tab_maestro_art
end type
type tab_maestro_art from userobject within tab_principal
cb_add_articulos cb_add_articulos
dw_articulos_details dw_articulos_details
cb_agregar_sub_categ cb_agregar_sub_categ
dw_master_sub_categ dw_master_sub_categ
cb_agregar_categ cb_agregar_categ
dw_master_categ dw_master_categ
end type
type tab_seguimiento from userobject within tab_principal
end type
type cb_add_cartera from commandbutton within tab_seguimiento
end type
type dw_lista_vendedores_segui from datawindow within tab_seguimiento
end type
type cb_add_visitas from commandbutton within tab_seguimiento
end type
type cb_add_cliente from commandbutton within tab_seguimiento
end type
type dw_master_clientes from u_dw_abc within tab_seguimiento
end type
type dw_detalles_visitas from u_dw_abc within tab_seguimiento
end type
type tab_seguimiento from userobject within tab_principal
cb_add_cartera cb_add_cartera
dw_lista_vendedores_segui dw_lista_vendedores_segui
cb_add_visitas cb_add_visitas
cb_add_cliente cb_add_cliente
dw_master_clientes dw_master_clientes
dw_detalles_visitas dw_detalles_visitas
end type
type tabpage_cotizacion from userobject within tab_principal
end type
type cb_exporta_cotiz from commandbutton within tabpage_cotizacion
end type
type cb_update_detail_cotiz from commandbutton within tabpage_cotizacion
end type
type cb_delete_detail_cotiz from commandbutton within tabpage_cotizacion
end type
type cb_nuevo from commandbutton within tabpage_cotizacion
end type
type dw_master_cotiz_cliente from u_dw_abc within tabpage_cotizacion
end type
type cb_add_detail_cotiz from commandbutton within tabpage_cotizacion
end type
type dw_details_cotiz from u_dw_abc within tabpage_cotizacion
end type
type dw_master_cotiz_articulo from u_dw_abc within tabpage_cotizacion
end type
type tabpage_cotizacion from userobject within tab_principal
cb_exporta_cotiz cb_exporta_cotiz
cb_update_detail_cotiz cb_update_detail_cotiz
cb_delete_detail_cotiz cb_delete_detail_cotiz
cb_nuevo cb_nuevo
dw_master_cotiz_cliente dw_master_cotiz_cliente
cb_add_detail_cotiz cb_add_detail_cotiz
dw_details_cotiz dw_details_cotiz
dw_master_cotiz_articulo dw_master_cotiz_articulo
end type
type tab_principal from tab within w_cotiza
tab_clientes tab_clientes
tab_maestro_art tab_maestro_art
tab_seguimiento tab_seguimiento
tabpage_cotizacion tabpage_cotizacion
end type
end forward

global type w_cotiza from window
integer width = 6537
integer height = 3212
boolean titlebar = true
string title = "Modulo de Cotizacion - Sytco "
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_salir cb_salir
st_leyenda st_leyenda
tab_principal tab_principal
end type
global w_cotiza w_cotiza

type variables
Integer ii_usuario_id_lista, li, li_cantidad, li_cotiz_detail_id
long li_contador 
String ls_seleccion, ls_articulo_cod, ls_observaciones, ls_estado_cotizacion
Decimal ld_precio, ld_igv, ld_total
end variables

on w_cotiza.create
this.cb_salir=create cb_salir
this.st_leyenda=create st_leyenda
this.tab_principal=create tab_principal
this.Control[]={this.cb_salir,&
this.st_leyenda,&
this.tab_principal}
end on

on w_cotiza.destroy
destroy(this.cb_salir)
destroy(this.st_leyenda)
destroy(this.tab_principal)
end on

event resize;//Alineamos el tab
Integer alto, ancho, dw_cat_yz, dw_tab_alto,dw_arti_yx


ancho = this.width
alto = this.height

tab_principal.width = ancho -10
tab_principal.tab_clientes.dw_todo_clientes.width = tab_principal.width - 200

//tab_principal.height = newheight - tab_principal.y - 190
cb_salir.x = tab_principal.width - 600
//alineamos los controles de la tabpage Articulos
tab_principal.tab_clientes.dw_todo_clientes.x = (ancho/2)-(tab_principal.tab_clientes.dw_todo_clientes.width/2)
st_leyenda.x = (ancho/2)-(st_leyenda.width/2)

tab_principal.height = alto - 134
tab_principal.tab_clientes.dw_todo_clientes.height = tab_principal.height - 500

//categorias, subcategorias, articulos
dw_tab_alto = tab_principal.tab_maestro_art.height
tab_principal.tab_maestro_art.dw_master_categ.height = (dw_tab_alto/2) - 250
tab_principal.tab_maestro_art.dw_master_sub_categ.height = (dw_tab_alto/2) - 250
dw_cat_yz = tab_principal.tab_maestro_art.dw_master_categ.y + tab_principal.tab_maestro_art.dw_master_categ.height
dw_arti_yx = dw_cat_yz + 50
tab_principal.tab_maestro_art.dw_articulos_details.y = dw_arti_yx
tab_principal.tab_maestro_art.dw_articulos_details.height = dw_tab_alto - dw_cat_yz - 150

tab_principal.tab_maestro_art.cb_add_articulos.y = tab_principal.tab_maestro_art.dw_articulos_details.y + 30

//tab_principal.tab_seguimiento.dw_master_seguimientos.width = tab_principal.width - tab_principal.tab_seguimiento.dw_master_clientes.width - 50
tab_principal.tab_seguimiento.dw_detalles_visitas.width = tab_principal.width - 50
tab_principal.tab_seguimiento.dw_detalles_visitas.height = tab_principal.height - tab_principal.tab_seguimiento.dw_detalles_visitas.y - 150
end event

event open;if trim(gs_nivel) = 'ADMINI' then 	
	tab_principal.tab_maestro_art.cb_agregar_categ.enabled = true
	tab_principal.tab_maestro_art.cb_agregar_sub_categ.enabled = true
	tab_principal.tab_maestro_art.cb_add_articulos.enabled = true
else
	tab_principal.tab_maestro_art.dw_master_categ.ii_protect=1
	tab_principal.tab_maestro_art.dw_master_sub_categ.ii_protect=1
	tab_principal.tab_maestro_art.dw_articulos_details.ii_protect=1
end if
	
end event

type cb_salir from commandbutton within w_cotiza
integer x = 3616
integer y = 28
integer width = 352
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar Sesion"
end type

event clicked;Close(parent)
end event

type st_leyenda from statictext within w_cotiza
integer x = 1006
integer y = 28
integer width = 1627
integer height = 96
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Modulo de Cotizacion Web - Uso exclusivo SYTCO"
alignment alignment = center!
boolean focusrectangle = false
end type

type tab_principal from tab within w_cotiza
integer y = 132
integer width = 6478
integer height = 2740
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "AppStarting!"
long backcolor = 16777215
boolean raggedright = true
boolean boldselectedtext = true
integer selectedtab = 1
tab_clientes tab_clientes
tab_maestro_art tab_maestro_art
tab_seguimiento tab_seguimiento
tabpage_cotizacion tabpage_cotizacion
end type

on tab_principal.create
this.tab_clientes=create tab_clientes
this.tab_maestro_art=create tab_maestro_art
this.tab_seguimiento=create tab_seguimiento
this.tabpage_cotizacion=create tabpage_cotizacion
this.Control[]={this.tab_clientes,&
this.tab_maestro_art,&
this.tab_seguimiento,&
this.tabpage_cotizacion}
end on

on tab_principal.destroy
destroy(this.tab_clientes)
destroy(this.tab_maestro_art)
destroy(this.tab_seguimiento)
destroy(this.tabpage_cotizacion)
end on

event selectionchanged;Long ll_row
choose case newindex
	case 1
		tab_principal.tab_clientes.dw_todo_clientes.Retrieve()
	case 2
		tab_principal.tab_maestro_art.dw_master_categ.Retrieve()
		tab_principal.tab_maestro_art.dw_master_sub_categ.Retrieve(0)
		tab_principal.tab_maestro_art.dw_master_categ.ii_protect = 0
		tab_principal.tab_maestro_art.dw_master_categ.of_protect()
		tab_principal.tab_maestro_art.dw_master_sub_categ.ii_protect = 0
		tab_principal.tab_maestro_art.dw_master_sub_categ.of_protect()

	case 3
		li_seguimiento_id = 0

		DataWindowChild ldwch_empcro
		tab_principal.tab_seguimiento.dw_lista_vendedores_segui.GetChild("usuario_id", ldwch_empcro)
		ldwch_empcro.SetTransObject(SQLCA)
		ll_row = ldwch_empcro.getselectedrow(0)
		if ll_row = 0 then 
			ii_usuario_id_lista = 0
		else 
			ii_usuario_id_lista	= Integer(tab_principal.tab_seguimiento.dw_lista_vendedores_segui.object.usuario_id [1])
		end if
		ldwch_empcro.Retrieve()
		
		if trim(gs_nivel)='ADMINI' then return
		tab_principal.tab_seguimiento.dw_lista_vendedores_segui.enabled = false
		tab_principal.tab_seguimiento.dw_master_clientes.retrieve(gi_user)
		tab_principal.tab_seguimiento.cb_add_cartera.enabled = false
		
	case 4
		tab_principal.tabpage_cotizacion.dw_master_cotiz_cliente.retrieve()
		tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.retrieve( )
end choose
end event

type tab_clientes from userobject within tab_principal
integer x = 18
integer y = 104
integer width = 6441
integer height = 2620
long backcolor = 16777215
string text = "Clientes"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_contactos cb_contactos
dw_todo_clientes dw_todo_clientes
b_print b_print
b_delete b_delete
b_nuevo b_nuevo
b_open b_open
gb_buttons gb_buttons
end type

on tab_clientes.create
this.cb_contactos=create cb_contactos
this.dw_todo_clientes=create dw_todo_clientes
this.b_print=create b_print
this.b_delete=create b_delete
this.b_nuevo=create b_nuevo
this.b_open=create b_open
this.gb_buttons=create gb_buttons
this.Control[]={this.cb_contactos,&
this.dw_todo_clientes,&
this.b_print,&
this.b_delete,&
this.b_nuevo,&
this.b_open,&
this.gb_buttons}
end on

on tab_clientes.destroy
destroy(this.cb_contactos)
destroy(this.dw_todo_clientes)
destroy(this.b_print)
destroy(this.b_delete)
destroy(this.b_nuevo)
destroy(this.b_open)
destroy(this.gb_buttons)
end on

type cb_contactos from commandbutton within tab_clientes
integer x = 4064
integer y = 44
integer width = 430
integer height = 100
integer taborder = 40
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "MANTENIMIENTO"
end type

event clicked;if gs_cliente="" then return
 is_action='new'
OPEN(w_mantenimiento_clientes)
end event

type dw_todo_clientes from u_dw_abc within tab_clientes
integer x = 32
integer y = 216
integer width = 6377
integer height = 1936
integer taborder = 20
string dataobject = "dw_clientes_tb"
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event clicked;call super::clicked;//Override
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_cliente 				= tab_principal.tab_clientes.dw_todo_clientes.object.cliente_id [row]
gs_cliente_nombre	= tab_principal.tab_clientes.dw_todo_clientes.object.clientes_nombre [row]

if gs_cliente <> "" then
	cb_contactos.visible = true
	cb_contactos.enabled = true
else
	cb_contactos.visible = false
	cb_contactos.enabled = false
end if
end event

event rowfocuschanged;call super::rowfocuschanged;//Override

This.SelectRow(0, False)
This.SelectRow(currentrow, True)
THIS.SetRow(currentrow)
this.event ue_output(currentrow)

end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

gs_cliente = dw_todo_clientes.object.cliente_id [row]

is_action = 'open'
Open(w_clientes)
dw_todo_clientes.retrieve( )
end event

event ue_print;call super::ue_print;str_parametros lstr_rep

IF tab_principal.tab_clientes.dw_todo_clientes.rowcount() = 0 then return
//
//lstr_rep.string1 = dw_master.object.cod_origen[dw_master.getrow()]
//lstr_rep.string2 = dw_master.object.nro_os[dw_master.getrow()]
//OpenSheet(w_rpt_clientes,w_cotiza, 2, layered!)

//
end event

type b_print from commandbutton within tab_clientes
integer x = 5376
integer y = 44
integer width = 343
integer height = 100
integer taborder = 70
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "REPORTE"
end type

event clicked;OPEN(w_rpt_clientes)
end event

type b_delete from commandbutton within tab_clientes
boolean visible = false
integer x = 2592
integer y = 92
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "ELIMINAR"
end type

type b_nuevo from commandbutton within tab_clientes
integer x = 4969
integer y = 44
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
Open(w_clientes)
dw_todo_clientes.retrieve( )
end event

type b_open from commandbutton within tab_clientes
integer x = 4558
integer y = 44
integer width = 347
integer height = 100
integer taborder = 70
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "ACTUALIZAR"
end type

event clicked;dw_todo_clientes.retrieve( )
end event

type gb_buttons from groupbox within tab_clientes
boolean visible = false
integer x = 3223
integer y = 124
integer width = 283
integer height = 1164
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 16777215
end type

type tab_maestro_art from userobject within tab_principal
integer x = 18
integer y = 104
integer width = 6441
integer height = 2620
long backcolor = 16777215
string text = "Maestro de articulos"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_add_articulos cb_add_articulos
dw_articulos_details dw_articulos_details
cb_agregar_sub_categ cb_agregar_sub_categ
dw_master_sub_categ dw_master_sub_categ
cb_agregar_categ cb_agregar_categ
dw_master_categ dw_master_categ
end type

on tab_maestro_art.create
this.cb_add_articulos=create cb_add_articulos
this.dw_articulos_details=create dw_articulos_details
this.cb_agregar_sub_categ=create cb_agregar_sub_categ
this.dw_master_sub_categ=create dw_master_sub_categ
this.cb_agregar_categ=create cb_agregar_categ
this.dw_master_categ=create dw_master_categ
this.Control[]={this.cb_add_articulos,&
this.dw_articulos_details,&
this.cb_agregar_sub_categ,&
this.dw_master_sub_categ,&
this.cb_agregar_categ,&
this.dw_master_categ}
end on

on tab_maestro_art.destroy
destroy(this.cb_add_articulos)
destroy(this.dw_articulos_details)
destroy(this.cb_agregar_sub_categ)
destroy(this.dw_master_sub_categ)
destroy(this.cb_agregar_categ)
destroy(this.dw_master_categ)
end on

type cb_add_articulos from commandbutton within tab_maestro_art
integer x = 5303
integer y = 1204
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean enabled = false
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
if ii_sub_categ_id=0 then return
Open(w_articulos)
tab_principal.tab_maestro_art.dw_articulos_details.retrieve(ii_sub_categ_id)
end event

type dw_articulos_details from u_dw_abc within tab_maestro_art
integer x = 14
integer y = 1172
integer width = 6039
integer height = 1356
integer taborder = 20
string dataobject = "dw_abc_articulos_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 		dw_master_sub_categ		// dw_master
//idw_det  =  				// dw_detail


end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
ii_articulo_id = dw_articulos_details.object.articulo_id [row]


end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

if ii_articulo_id =0 then return
	if gs_nivel = 'VENDED' then return
		is_action = 'open'
		Open(w_articulos)
		dw_articulos_details.retrieve(ii_sub_categ_id)
end event

event buttonclicked;call super::buttonclicked;string 	ls_mensaje, ls_nombre_contacto, ls_descrip_arti
Long 		li_articulo_id

if lower(dwo.name) = 'b_delete_item' then
	li_articulo_id = Long(this.object.articulo_id [row])
	ls_descrip_arti = String(this.object.descripcion [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro '  + string(ls_descrip_arti) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete ARTICULOS
	where ARTICULO_ID = :li_articulo_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar el articulo. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(ii_sub_categ_id)
end if
end event

type cb_agregar_sub_categ from commandbutton within tab_maestro_art
integer x = 5600
integer y = 164
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean enabled = false
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
if ii_categoria_id=0 then return
Open(w_sub_categoria_articulo)
dw_master_sub_categ.retrieve(ii_categoria_id)
end event

type dw_master_sub_categ from u_dw_abc within tab_maestro_art
integer x = 2190
integer y = 132
integer width = 3867
integer height = 992
integer taborder = 20
string dataobject = "d_abc_sub_categ_articulo_tbl"
end type

event ue_insert_pre;call super::ue_insert_pre;this.object.categ_id		[al_row] = ii_sub_categ_id
this.object.flag_estado	[al_row] = '1'
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
idw_det  =  		dw_articulos_details		// dw_detail
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
ii_sub_categ_id = dw_master_sub_categ.object.sub_cat_id [row]
dw_articulos_details.retrieve(ii_sub_categ_id)

end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

if ii_sub_categ_id =0 then return
	if gs_nivel = 'VENDED' then return
		is_action = 'open'
		Open(w_sub_categoria_articulo)
		dw_master_sub_categ.retrieve(ii_categoria_id)
end event

event buttonclicked;call super::buttonclicked;string 	ls_mensaje, ls_nombre_contacto, ls_descrip_subcat
Long 		li_subcate

if lower(dwo.name) = 'b_delete_sub' then
	li_subcate = Long(this.object.sub_cat_id [row])
	ls_descrip_subcat = String(this.object.descripcion [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro '  + string(ls_descrip_subcat) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete SUB_CATEG_ARTICULO
	where SUB_CAT_ID = :li_subcate;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la sub-categoria. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(ii_categoria_id)
end if
end event

type cb_agregar_categ from commandbutton within tab_maestro_art
integer x = 1787
integer y = 172
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean enabled = false
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
Open(w_categoria_articulo)
dw_master_categ.retrieve( )
end event

type dw_master_categ from u_dw_abc within tab_maestro_art
integer x = 14
integer y = 132
integer width = 2149
integer height = 992
integer taborder = 20
string dataobject = "d_abc_categoria_articulos_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado	[al_row] = '1'
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
ii_categoria_id = dw_master_categ.object.categ_arti_id [row]
dw_master_sub_categ.retrieve(ii_categoria_id)

end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

if ii_sub_categ_id =0 then return
if gs_nivel = 'VENDED' then return
is_action = 'open'
Open(w_categoria_articulo)
dw_master_categ.retrieve( )
end event

event buttonclicked;call super::buttonclicked;string 	ls_mensaje, ls_nombre_contacto, ls_descrip_cat
Long 		li_cate

if lower(dwo.name) = 'b_delete_item' then
	li_cate = Long(this.object.categ_arti_id [row])
	ls_descrip_cat = String(this.object.descripcion [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro '  + string(ls_descrip_cat) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete CATEGORIA_ARTICULO
	where CATEG_ARTI_ID = :li_cate;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la categoria. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve()
end if
end event

type tab_seguimiento from userobject within tab_principal
event create ( )
event destroy ( )
integer x = 18
integer y = 104
integer width = 6441
integer height = 2620
long backcolor = 16777215
string text = "Seguimiento y Visitas"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_add_cartera cb_add_cartera
dw_lista_vendedores_segui dw_lista_vendedores_segui
cb_add_visitas cb_add_visitas
cb_add_cliente cb_add_cliente
dw_master_clientes dw_master_clientes
dw_detalles_visitas dw_detalles_visitas
end type

on tab_seguimiento.create
this.cb_add_cartera=create cb_add_cartera
this.dw_lista_vendedores_segui=create dw_lista_vendedores_segui
this.cb_add_visitas=create cb_add_visitas
this.cb_add_cliente=create cb_add_cliente
this.dw_master_clientes=create dw_master_clientes
this.dw_detalles_visitas=create dw_detalles_visitas
this.Control[]={this.cb_add_cartera,&
this.dw_lista_vendedores_segui,&
this.cb_add_visitas,&
this.cb_add_cliente,&
this.dw_master_clientes,&
this.dw_detalles_visitas}
end on

on tab_seguimiento.destroy
destroy(this.cb_add_cartera)
destroy(this.dw_lista_vendedores_segui)
destroy(this.cb_add_visitas)
destroy(this.cb_add_cliente)
destroy(this.dw_master_clientes)
destroy(this.dw_detalles_visitas)
end on

type cb_add_cartera from commandbutton within tab_seguimiento
integer x = 3470
integer y = 16
integer width = 645
integer height = 112
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "Administrar Cartera de Clientes"
end type

event clicked;open(w_cartera_clientes)

end event

type dw_lista_vendedores_segui from datawindow within tab_seguimiento
integer x = 160
integer y = 40
integer width = 1760
integer height = 128
integer taborder = 40
string title = "none"
string dataobject = "dw_lista_vendedores_ff"
boolean border = false
boolean livescroll = true
end type

event constructor;this.InsertRow(0)
end event

event itemchanged;Integer li_usuario_id
this.AcceptText()
li_usuario_id = Integer(this.object.usuario_id [1])
gi_user_visita = li_usuario_id
if gi_user_visita=0 then return
tab_principal.tab_seguimiento.dw_master_clientes.retrieve(gi_user_visita)
end event

type cb_add_visitas from commandbutton within tab_seguimiento
integer x = 5952
integer y = 184
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
if li_seguimiento_id=0 then return
Open(w_visitas)
tab_principal.tab_seguimiento.dw_detalles_visitas.retrieve(li_seguimiento_id)
end event

type cb_add_cliente from commandbutton within tab_seguimiento
boolean visible = false
integer x = 2162
integer y = 196
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "AGREGAR"
end type

event clicked;is_action = 'new'
Open(w_clientes)
dw_master_clientes.retrieve( )
end event

type dw_master_clientes from u_dw_abc within tab_seguimiento
integer x = 32
integer y = 168
integer width = 1824
integer height = 2024
integer taborder = 20
string dataobject = "dw_clientes_lista_simple_tb"
boolean hscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
if trim(gs_cliente)='0' or isnull(gs_cliente) then return
is_action = 'open'
Open(w_clientes)
tab_principal.tab_seguimiento.dw_master_clientes.retrieve( )
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
gs_cliente = dw_master_clientes.object.clientes_cliente_id [row]
//tab_principal.tab_seguimiento.dw_master_seguimientos.retrieve(gs_cliente)
end event

type dw_detalles_visitas from u_dw_abc within tab_seguimiento
integer x = 1911
integer y = 168
integer width = 4521
integer height = 2032
integer taborder = 20
string dataobject = "dw_visita_tb"
end type

event constructor;call super::constructor;
is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 		dw_master_clientes		// dw_master
//idw_det  =  		dw_master_clientes		// dw_detail
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
li_visita_id = dw_detalles_visitas.object.visita_visita_id [row]


end event

event doubleclicked;call super::doubleclicked;if li_visita_id=0 then return
is_action = 'open'
Open(w_visitas)
tab_principal.tab_seguimiento.dw_detalles_visitas.retrieve(li_seguimiento_id )
end event

type tabpage_cotizacion from userobject within tab_principal
integer x = 18
integer y = 104
integer width = 6441
integer height = 2620
long backcolor = 16777215
string text = "Cotizacion"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
cb_exporta_cotiz cb_exporta_cotiz
cb_update_detail_cotiz cb_update_detail_cotiz
cb_delete_detail_cotiz cb_delete_detail_cotiz
cb_nuevo cb_nuevo
dw_master_cotiz_cliente dw_master_cotiz_cliente
cb_add_detail_cotiz cb_add_detail_cotiz
dw_details_cotiz dw_details_cotiz
dw_master_cotiz_articulo dw_master_cotiz_articulo
end type

on tabpage_cotizacion.create
this.cb_exporta_cotiz=create cb_exporta_cotiz
this.cb_update_detail_cotiz=create cb_update_detail_cotiz
this.cb_delete_detail_cotiz=create cb_delete_detail_cotiz
this.cb_nuevo=create cb_nuevo
this.dw_master_cotiz_cliente=create dw_master_cotiz_cliente
this.cb_add_detail_cotiz=create cb_add_detail_cotiz
this.dw_details_cotiz=create dw_details_cotiz
this.dw_master_cotiz_articulo=create dw_master_cotiz_articulo
this.Control[]={this.cb_exporta_cotiz,&
this.cb_update_detail_cotiz,&
this.cb_delete_detail_cotiz,&
this.cb_nuevo,&
this.dw_master_cotiz_cliente,&
this.cb_add_detail_cotiz,&
this.dw_details_cotiz,&
this.dw_master_cotiz_articulo}
end on

on tabpage_cotizacion.destroy
destroy(this.cb_exporta_cotiz)
destroy(this.cb_update_detail_cotiz)
destroy(this.cb_delete_detail_cotiz)
destroy(this.cb_nuevo)
destroy(this.dw_master_cotiz_cliente)
destroy(this.cb_add_detail_cotiz)
destroy(this.dw_details_cotiz)
destroy(this.dw_master_cotiz_articulo)
end on

type cb_exporta_cotiz from commandbutton within tabpage_cotizacion
integer x = 4608
integer y = 1120
integer width = 320
integer height = 112
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "EXPORTAR"
end type

event clicked;open(w_rpt_cotizacion)
end event

type cb_update_detail_cotiz from commandbutton within tabpage_cotizacion
integer x = 4087
integer y = 1120
integer width = 320
integer height = 112
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "ACTUALIZAR"
end type

event clicked;Integer li_contador_detail, li_cantidad_detail
Decimal ld_precio_detail, ld_igv_detail, ld_total_detail
String ls_observaciones_detail, ls_mensaje_detail

li_contador_detail = tab_principal.tabpage_cotizacion.dw_details_cotiz.rowcount()

if li_contador_detail = 0 or gi_cotizacion_id=0 or li_cotiz_detail_id = 0 then return

//recorro datawindow articulos
FOR li=1 to li_contador_detail
	li_cantidad_detail		 	= Integer(tab_principal.tabpage_cotizacion.dw_details_cotiz.getitemstring(li,"cantidad") )
	ld_precio_detail 			= Dec(tab_principal.tabpage_cotizacion.dw_details_cotiz.getitemstring(li,"precio") )
	ld_igv_detail 				= ld_precio_detail * 0.18
	ld_total_detail 				= ld_precio_detail + ld_igv_detail
	ls_observaciones_detail 	= String(tab_principal.tabpage_cotizacion.dw_details_cotiz.getitemstring(li,"observaciones") )

	if MessageBox('Aviso', 'Desea actualizar los detalles de la cotizacion?', Information!, YesNo!, 2) = 2 then 
		
		ROLLBACK;
		tab_principal.tabpage_cotizacion.dw_details_cotiz.retrieve(gi_cotizacion_id)
		cb_update_detail_cotiz.visible = false
		return
		
	else
		
		update cotizacion_det 
			set cantidad		= :li_cantidad_detail , 
				 precio			= :ld_precio_detail , 
				 igv				= :ld_igv_detail , 
				 total			= :ld_total_detail , 
				 observaciones	= :ls_observaciones_detail , 
				 usuario_id		= :gi_user
		where cotiz_det_id	= :li_cotiz_detail_id 
		  and cotizacion_id	= :gi_cotizacion_id;
		  
		if sqlca.sqlCode < 0 then
			ls_mensaje_detail = sqlca.SQLErrText
			ROLLBACK;
			MessageBox('Error', "Error al actualizar cotizacion_det. Mensaje: " + ls_mensaje_detail)
			return
		end if
		
	end if
next

cb_update_detail_cotiz.visible = false
commit;

MessageBox('Aviso', 'Actualizacion de los datos realizada correctamente', Information!)
end event

type cb_delete_detail_cotiz from commandbutton within tabpage_cotizacion
integer x = 2350
integer y = 2052
integer width = 320
integer height = 148
integer taborder = 40
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "QUITAR<"
end type

event clicked;String ls_mensaje
Integer li_count, li_cod_arti_update
li_contador = tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.rowcount()
if li_contador = 0 or gi_cotizacion_id=0 or li_cotiz_detail_id=0 then return

if MessageBox('Aviso', 'Desea eliminar el item seleccionado?', Information!, YesNo!, 2) = 2 then return

delete from cotizacion_det t where t.cotiz_det_id=:li_cotiz_detail_id;
	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al eliminar detalle', ls_mensaje)
		return
	end if
	commit;
MessageBox('Correcto', "Correcto")
tab_principal.tabpage_cotizacion.dw_details_cotiz.retrieve(gi_cotizacion_id)


end event

type cb_nuevo from commandbutton within tabpage_cotizacion
integer x = 4859
integer y = 72
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
string text = "AGREGAR"
end type

event clicked;/*if ii_cotiz_id=0 then
	dw_master_cotiz_cliente.reset()
	dw_master_cotiz_cliente.insertrow(0)
	dw_master_cotiz_cliente.SetFocus()
	dw_master_cotiz_cliente.setColumn("cotizacion_cod_cotizacion")
//	dw_master_cotiz_cliente.object.cotizacion_usuario_id	=		gi_user
end if*/

is_action = 'new'
Open(w_cotizacion)
dw_master_cotiz_cliente.retrieve( )
end event

type dw_master_cotiz_cliente from u_dw_abc within tabpage_cotizacion
integer x = 37
integer y = 48
integer width = 6368
integer height = 1016
integer taborder = 20
string dataobject = "dw_lista_cotizaciones"
boolean hscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
if trim(gs_cliente)='0' or isnull(gs_cliente) then return
is_action = 'open'
Open(w_cotizacion)
tab_principal.tabpage_cotizacion.dw_master_cotiz_cliente.retrieve( )
end event

event clicked;call super::clicked;
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
gi_cotizacion_id 		= 		dw_master_cotiz_cliente.object.cotizacion_cotizacion_id [row]
gs_cliente_cotiz_id 	=  		dw_master_cotiz_cliente.object.cotizacion_cliente_id 		[row]
ls_estado_cotizacion 		= 		dw_master_cotiz_cliente.object.cotizacion_flag_estado	[row]

tab_principal.tabpage_cotizacion.dw_details_cotiz.retrieve(gi_cotizacion_id)
if ls_estado_cotizacion='0' then 
	tab_principal.tabpage_cotizacion.dw_details_cotiz.ii_protect=1
	tab_principal.tabpage_cotizacion.dw_details_cotiz.enabled = false
else
	tab_principal.tabpage_cotizacion.dw_details_cotiz.ii_protect=0
	tab_principal.tabpage_cotizacion.dw_details_cotiz.enabled = true
end if


end event

type cb_add_detail_cotiz from commandbutton within tabpage_cotizacion
integer x = 2350
integer y = 1424
integer width = 320
integer height = 148
integer taborder = 30
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">AGREGAR"
end type

event clicked;String ls_mensaje, ls_produ_descr
Integer li_count, li_cod_arti_update
li_contador = tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.rowcount()
if li_contador = 0 or gi_cotizacion_id=0 then return

//recorro datawindow articulos
FOR li=1 to li_contador
	ls_seleccion 	= String(tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.getitemstring(li,"seleccionado") ) //.object.Data[1,li])
	ls_articulo_cod 	= String(tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.getitemstring(li,"cod_articulo"))
	ls_produ_descr	=	String(tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.getitemstring(li,"descripcion"))
	ld_precio 	= Dec(tab_principal.tabpage_cotizacion.dw_master_cotiz_articulo.getitemstring(li,"precio"))
	ld_igv = ld_precio * 0.18
	ld_total = ld_precio + ld_igv
	
	
	if ls_seleccion = '1' then //SI ESTA SELECCIONADO
		
		select count(*) into :li_count from cotizacion_det where cotizacion_id=:gi_cotizacion_id and cod_articulo=:ls_articulo_cod; //REVISO QUE NO ESTE REGISTRADO
		
		if li_count = 0 then // 0 no esta registrado en el detalle
			insert into cotizacion_det(cotizacion_id, cod_articulo,cantidad, precio,igv,total,observaciones , usuario_id)
			values( :gi_cotizacion_id, :ls_articulo_cod,1,:ld_precio, :ld_igv, :ld_total, '', :gi_user);
			if sqlca.sqlCode < 0 then
				ls_mensaje = sqlca.SQLErrText
				ROLLBACK;
				MessageBox('Error al registrar detalle', ls_mensaje)
				return
			end if
			commit;
		else   // esta registrado en el detalle
			if MessageBox('Aviso', 'El articulo: ' +string(ls_produ_descr) +' ya esta incluido en el detalle, desea actualizarlo?', Information!, YesNo!, 2) = 2 then return
				update cotizacion_det set cantidad =1, precio=:ld_precio,igv=:ld_igv,total=:ld_total,observaciones='' where cotizacion_id=:gi_cotizacion_id and cod_articulo=:ls_articulo_cod;
				commit;
		end if
		
		
	end if	

next
MessageBox('Correcto', "Correcto")
tab_principal.tabpage_cotizacion.dw_details_cotiz.retrieve(gi_cotizacion_id)
				


end event

type dw_details_cotiz from u_dw_abc within tabpage_cotizacion
integer x = 2693
integer y = 1108
integer width = 3721
integer height = 1364
integer taborder = 20
string dataobject = "d_abc_cotizacion_det_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 			dw_master_cotiz_cliente	// dw_master
//idw_det  =  				// dw_detail

end event

event retrieveend;call super::retrieveend;li_contador = dw_details_cotiz.rowcount()
if li_contador = 0 then return
tab_principal.tabpage_cotizacion.cb_delete_detail_cotiz.enabled = true
end event

event itemchanged;call super::itemchanged;INTEGER li_return = 0
DECIMAL{2} ldc_cantidad, ldc_precio

CHOOSE CASE LOWER(dwo.name)
	CASE 'cantidad'
		ldc_cantidad = DEC(data)
		IF (ldc_cantidad < 0) THEN
			li_return = 1
			MESSAGEBOX('ERROR', 'NO PUEDE INGRESAR NEGATIVOS')
		ELSE
			cb_update_detail_cotiz.visible = true
		END IF
	CASE 'precio'
		ldc_precio = DEC(data)
		IF (ldc_precio < 0) THEN
			li_return = 1
			MESSAGEBOX('ERROR', 'NO PUEDE INGRESAR NEGATIVOS')
		ELSE
			cb_update_detail_cotiz.visible = true
		END IF
	END CHOOSE
RETURN(li_return)
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_cotiz_detail_id = dw_details_cotiz.object.cotiz_det_id [row]

end event

type dw_master_cotiz_articulo from u_dw_abc within tabpage_cotizacion
integer x = 37
integer y = 1108
integer width = 2304
integer height = 1364
integer taborder = 20
string dataobject = "d_lista_articulos_cotizacion_tbl"
end type

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;call super::clicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

//ls_seleccion = dw_master_cotiz_articulo.object.seleccionado
//
//li_articulo_id = dw_master_cotiz_articulo.object.cod_articulo [row]
//if li_articulo_id>0 and li_cliente_id_cartera=0 then 
////	cb_insertar.enabled = false
////	return 
////else
////	cb_insertar.enabled = true
////end if
end event

