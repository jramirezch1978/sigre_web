$PBExportHeader$w_cartera_clientes.srw
forward
global type w_cartera_clientes from window
end type
type st_2 from statictext within w_cartera_clientes
end type
type st_1 from statictext within w_cartera_clientes
end type
type cb_eliminar from commandbutton within w_cartera_clientes
end type
type cb_insertar from commandbutton within w_cartera_clientes
end type
type dw_detail_cartera_usuario from u_dw_abc within w_cartera_clientes
end type
type dw_clientes_sin_cartera from u_dw_abc within w_cartera_clientes
end type
type dw_lista_vendedores from u_dw_abc within w_cartera_clientes
end type
end forward

global type w_cartera_clientes from window
integer width = 4014
integer height = 2276
boolean titlebar = true
string title = "Registro de Cartera de Clientes"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_2 st_2
st_1 st_1
cb_eliminar cb_eliminar
cb_insertar cb_insertar
dw_detail_cartera_usuario dw_detail_cartera_usuario
dw_clientes_sin_cartera dw_clientes_sin_cartera
dw_lista_vendedores dw_lista_vendedores
end type
global w_cartera_clientes w_cartera_clientes

type variables
Integer li_usuario_id_cartera, li_cliente_id_cartera, li_cartera_id
end variables

on w_cartera_clientes.create
this.st_2=create st_2
this.st_1=create st_1
this.cb_eliminar=create cb_eliminar
this.cb_insertar=create cb_insertar
this.dw_detail_cartera_usuario=create dw_detail_cartera_usuario
this.dw_clientes_sin_cartera=create dw_clientes_sin_cartera
this.dw_lista_vendedores=create dw_lista_vendedores
this.Control[]={this.st_2,&
this.st_1,&
this.cb_eliminar,&
this.cb_insertar,&
this.dw_detail_cartera_usuario,&
this.dw_clientes_sin_cartera,&
this.dw_lista_vendedores}
end on

on w_cartera_clientes.destroy
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_eliminar)
destroy(this.cb_insertar)
destroy(this.dw_detail_cartera_usuario)
destroy(this.dw_clientes_sin_cartera)
destroy(this.dw_lista_vendedores)
end on

event open;dw_clientes_sin_cartera.retrieve( )
end event

type st_2 from statictext within w_cartera_clientes
integer x = 594
integer y = 264
integer width = 663
integer height = 120
integer textsize = -11
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "Seleccionar usuario:"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cartera_clientes
integer y = 112
integer width = 4023
integer height = 104
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
boolean enabled = false
string text = "ADMINISTRACION DE CARTERA DE CLIENTES"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_eliminar from commandbutton within w_cartera_clientes
integer x = 1897
integer y = 1252
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean enabled = false
string text = "<<-- QUITAR"
end type

event clicked;String ls_mensaje
Long	ll_row
Integer li_cartera

ll_row = dw_detail_cartera_usuario.getselectedrow( 0)
if ll_row = 0 then return

li_cartera = dw_detail_cartera_usuario.object.cartera_clientes_cartera_id [ll_row]

delete from cartera_clientes
where cartera_id = :li_cartera_id;

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al quitar Cliente', ls_mensaje)
	return
end if

dw_clientes_sin_cartera.Retrieve()
dw_detail_cartera_usuario.Retrieve(li_usuario_id_cartera)

COMMIT ;
end event

type cb_insertar from commandbutton within w_cartera_clientes
integer x = 1897
integer y = 768
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
boolean enabled = false
string text = "AGREGAR -->>"
end type

event clicked;String ls_mensaje, ls_cliente_id
Long	ll_row

ll_row = dw_clientes_sin_cartera.getselectedrow( 0)
if ll_row = 0 then return

ls_cliente_id = dw_clientes_sin_cartera.object.cliente_id [ll_row]

insert into cartera_clientes(cliente_id, usuario_id, usu_reg_id)
values( :ls_cliente_id, :li_usuario_id_cartera, :gi_user);

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al asignar Cliente', ls_mensaje)
	return
end if

dw_clientes_sin_cartera.Retrieve()
dw_detail_cartera_usuario.Retrieve(li_usuario_id_cartera)

COMMIT ;
end event

type dw_detail_cartera_usuario from u_dw_abc within w_cartera_clientes
integer x = 2331
integer y = 504
integer width = 1627
integer height = 1384
integer taborder = 30
string dataobject = "dw_abc_cartera_cliente_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 		dw_lista_vendedores		// dw_master
//idw_det  =  				// dw_detail
end event

event clicked;call super::clicked;
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
li_cartera_id = dw_detail_cartera_usuario.object.cartera_clientes_cartera_id [row]

if li_cartera_id=0 then 
	cb_eliminar.enabled = false
	return 
end if
cb_eliminar.enabled = true

end event

type dw_clientes_sin_cartera from u_dw_abc within w_cartera_clientes
integer x = 55
integer y = 504
integer width = 1792
integer height = 1384
integer taborder = 20
string dataobject = "dw_abc_clientes_sin_cartera_tbl"
boolean hscrollbar = false
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

event clicked;call super::clicked;
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)
li_cliente_id_cartera = dw_clientes_sin_cartera.object.cliente_id [row]

if li_usuario_id_cartera=0 and li_cliente_id_cartera=0 then 
	cb_insertar.enabled = false
	return 
else
	cb_insertar.enabled = true
end if
end event

type dw_lista_vendedores from u_dw_abc within w_cartera_clientes
integer x = 1170
integer y = 248
integer width = 1797
integer height = 120
string dataobject = "dw_lista_vendedores_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;this.AcceptText()
li_usuario_id_cartera = Integer(this.object.usuario_id [1])

if li_usuario_id_cartera=0 then return
dw_detail_cartera_usuario.retrieve(li_usuario_id_cartera)

if li_usuario_id_cartera=0 and li_cliente_id_cartera=0 then 
	cb_insertar.enabled = false
	return 
else
	cb_insertar.enabled = true
end if
end event

event constructor;call super::constructor;this.InsertRow(0)
ii_ck[1] = 1	

end event

