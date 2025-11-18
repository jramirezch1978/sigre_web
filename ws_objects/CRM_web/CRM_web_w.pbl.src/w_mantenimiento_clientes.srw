$PBExportHeader$w_mantenimiento_clientes.srw
forward
global type w_mantenimiento_clientes from window
end type
type sle_cliente_nombre from singlelineedit within w_mantenimiento_clientes
end type
type st_2 from statictext within w_mantenimiento_clientes
end type
type tab_main from tab within w_mantenimiento_clientes
end type
type tabpage_contactos from userobject within tab_main
end type
type cb_cancela_contacto from commandbutton within tabpage_contactos
end type
type cb_guarda_contacto from commandbutton within tabpage_contactos
end type
type dw_master_lista_contactos from u_dw_abc within tabpage_contactos
end type
type cb_add_contacto from commandbutton within tabpage_contactos
end type
type dw_master_contactos from u_dw_abc within tabpage_contactos
end type
type tabpage_contactos from userobject within tab_main
cb_cancela_contacto cb_cancela_contacto
cb_guarda_contacto cb_guarda_contacto
dw_master_lista_contactos dw_master_lista_contactos
cb_add_contacto cb_add_contacto
dw_master_contactos dw_master_contactos
end type
type tabpage_direcciones from userobject within tab_main
end type
type dw_master_lista_direcciones from u_dw_abc within tabpage_direcciones
end type
type cb_cancel from commandbutton within tabpage_direcciones
end type
type cb_guardar from commandbutton within tabpage_direcciones
end type
type cb_1 from commandbutton within tabpage_direcciones
end type
type dw_master_direcciones from u_dw_abc within tabpage_direcciones
end type
type tabpage_direcciones from userobject within tab_main
dw_master_lista_direcciones dw_master_lista_direcciones
cb_cancel cb_cancel
cb_guardar cb_guardar
cb_1 cb_1
dw_master_direcciones dw_master_direcciones
end type
type tab_main from tab within w_mantenimiento_clientes
tabpage_contactos tabpage_contactos
tabpage_direcciones tabpage_direcciones
end type
type st_1 from statictext within w_mantenimiento_clientes
end type
end forward

global type w_mantenimiento_clientes from window
integer width = 3867
integer height = 2388
boolean titlebar = true
string title = "Untitled"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
sle_cliente_nombre sle_cliente_nombre
st_2 st_2
tab_main tab_main
st_1 st_1
end type
global w_mantenimiento_clientes w_mantenimiento_clientes

type variables
String cod_cliente_id, cod_cliente_nombre
Integer li_contacto_clien_id, li_direccion_cliente_id
datawindow data_contactos, data_contactos_lista , data_direcciones, data_direcciones_lista
end variables

on w_mantenimiento_clientes.create
this.sle_cliente_nombre=create sle_cliente_nombre
this.st_2=create st_2
this.tab_main=create tab_main
this.st_1=create st_1
this.Control[]={this.sle_cliente_nombre,&
this.st_2,&
this.tab_main,&
this.st_1}
end on

on w_mantenimiento_clientes.destroy
destroy(this.sle_cliente_nombre)
destroy(this.st_2)
destroy(this.tab_main)
destroy(this.st_1)
end on

event open;if gs_cliente					=	"" then return
cod_cliente_id 				= 	gs_cliente
cod_cliente_nombre 		=	gs_cliente_nombre

sle_cliente_nombre.text	=	string(cod_cliente_nombre)

data_contactos				=	tab_main.tabpage_contactos.dw_master_contactos
data_contactos_lista 		=	tab_main.tabpage_contactos.dw_master_lista_contactos
data_direcciones 			=	tab_main.tabpage_direcciones.dw_master_direcciones
data_direcciones_lista 	=	tab_main.tabpage_direcciones.dw_master_lista_direcciones

if is_action='new' then
	
	tab_main.tabpage_contactos.dw_master_contactos.Reset()
	tab_main.tabpage_direcciones.dw_master_direcciones.Reset()
	
	tab_main.tabpage_contactos.dw_master_contactos.event ue_Insert()
	tab_main.tabpage_direcciones.dw_master_direcciones.event ue_Insert()
	
	tab_main.tabpage_contactos.dw_master_contactos.ii_protect = 1
	tab_main.tabpage_direcciones.dw_master_direcciones.ii_protect = 1
	tab_main.tabpage_contactos.dw_master_contactos.of_protect()
	tab_main.tabpage_direcciones.dw_master_direcciones.of_protect()
	
	tab_main.tabpage_contactos.dw_master_contactos.SetFocus()
	tab_main.tabpage_contactos.dw_master_contactos.setColumn("cliente_id")

elseif is_action = 'open' then
	//data_contactos.Retrieve(gs_cliente)
end if





data_contactos_lista.retrieve(cod_cliente_id)
data_direcciones_lista.retrieve(cod_cliente_id)
data_contactos.insertrow(0)

end event

type sle_cliente_nombre from singlelineedit within w_mantenimiento_clientes
integer x = 1001
integer y = 204
integer width = 1623
integer height = 76
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 15793151
boolean enabled = false
string text = "nombres"
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_mantenimiento_clientes
integer x = 754
integer y = 204
integer width = 242
integer height = 76
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Cliente:"
boolean focusrectangle = false
end type

type tab_main from tab within w_mantenimiento_clientes
integer y = 332
integer width = 3835
integer height = 1980
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 16777215
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_contactos tabpage_contactos
tabpage_direcciones tabpage_direcciones
end type

on tab_main.create
this.tabpage_contactos=create tabpage_contactos
this.tabpage_direcciones=create tabpage_direcciones
this.Control[]={this.tabpage_contactos,&
this.tabpage_direcciones}
end on

on tab_main.destroy
destroy(this.tabpage_contactos)
destroy(this.tabpage_direcciones)
end on

event selectionchanged;choose case newindex
	case 1
		data_contactos.insertrow(0)		
		data_contactos_lista.retrieve(cod_cliente_id)
	case 2
		data_direcciones.insertrow(0)
		data_direcciones_lista.retrieve(cod_cliente_id)
	end choose
end event

type tabpage_contactos from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3799
integer height = 1856
long backcolor = 16777215
string text = "Contactos"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
cb_cancela_contacto cb_cancela_contacto
cb_guarda_contacto cb_guarda_contacto
dw_master_lista_contactos dw_master_lista_contactos
cb_add_contacto cb_add_contacto
dw_master_contactos dw_master_contactos
end type

on tabpage_contactos.create
this.cb_cancela_contacto=create cb_cancela_contacto
this.cb_guarda_contacto=create cb_guarda_contacto
this.dw_master_lista_contactos=create dw_master_lista_contactos
this.cb_add_contacto=create cb_add_contacto
this.dw_master_contactos=create dw_master_contactos
this.Control[]={this.cb_cancela_contacto,&
this.cb_guarda_contacto,&
this.dw_master_lista_contactos,&
this.cb_add_contacto,&
this.dw_master_contactos}
end on

on tabpage_contactos.destroy
destroy(this.cb_cancela_contacto)
destroy(this.cb_guarda_contacto)
destroy(this.dw_master_lista_contactos)
destroy(this.cb_add_contacto)
destroy(this.dw_master_contactos)
end on

type cb_cancela_contacto from commandbutton within tabpage_contactos
integer x = 1906
integer y = 448
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CANCELAR"
end type

event clicked;data_contactos.reset()
data_contactos.insertrow(0)
end event

type cb_guarda_contacto from commandbutton within tabpage_contactos
integer x = 1390
integer y = 448
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GUARDAR"
end type

event clicked;String ls_mensaje

data_contactos.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Contacto', ls_mensaje)
	return
end if

COMMIT ;
data_contactos.reset()
data_contactos.insertrow(0)

data_contactos_lista.retrieve(cod_cliente_id)
end event

type dw_master_lista_contactos from u_dw_abc within tabpage_contactos
integer x = 69
integer y = 604
integer width = 3707
integer height = 1156
integer taborder = 20
string dataobject = "dw_abc_lista_contactos_clientes_tbl"
boolean hscrollbar = false
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

event clicked;call super::clicked;//Override
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_contacto_clien_id 				= data_contactos_lista.object.contacto_clien_id [row]
//gs_cliente_nombre	= tab_principal.tab_clientes.dw_todo_clientes.object.clientes_nombre [row]
//
////if gs_cliente <> "" then
//	cb_contactos.visible = true
//	cb_contactos.enabled = true
//else
//	cb_contactos.visible = false
//	cb_contactos.enabled = false
//end if
end event

event doubleclicked;call super::doubleclicked;
if li_contacto_clien_id = 0 then return

is_action = 'open'
tab_main.tabpage_contactos.dw_master_contactos.retrieve(li_contacto_clien_id)
end event

event buttonclicked;call super::buttonclicked;string 	ls_mensaje, ls_nombre_contacto 

if lower(dwo.name) = 'b_delete_item' then
	li_contacto_clien_id = Long(this.object.contacto_clien_id [row])
	ls_nombre_contacto = String(this.object.nombres [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro '  + string(ls_nombre_contacto) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete CONTACTOS_CLIENTES
	where CONTACTO_CLIEN_ID = :li_contacto_clien_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la empresa. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(cod_cliente_id)
end if
end event

type cb_add_contacto from commandbutton within tabpage_contactos
integer x = 3593
integer y = 48
integer width = 137
integer height = 136
integer taborder = 30
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "+"
end type

event clicked;is_action="new"

data_contactos_lista.enabled =	false
data_contactos.reset()
data_contactos.insertrow(0)
end event

type dw_master_contactos from u_dw_abc within tabpage_contactos
integer x = 69
integer y = 20
integer width = 3707
integer height = 412
integer taborder = 20
string dataobject = "dw_abc_contactos_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

event ue_insert_pre;call super::ue_insert_pre;
this.Object.cliente_id					[al_row] = cod_cliente_id
this.Object.usuario_id					[al_row] = gi_user


end event

type tabpage_direcciones from userobject within tab_main
integer x = 18
integer y = 108
integer width = 3799
integer height = 1856
long backcolor = 16777215
string text = "Direcciones"
long tabtextcolor = 33554432
long tabbackcolor = 16777215
long picturemaskcolor = 536870912
dw_master_lista_direcciones dw_master_lista_direcciones
cb_cancel cb_cancel
cb_guardar cb_guardar
cb_1 cb_1
dw_master_direcciones dw_master_direcciones
end type

on tabpage_direcciones.create
this.dw_master_lista_direcciones=create dw_master_lista_direcciones
this.cb_cancel=create cb_cancel
this.cb_guardar=create cb_guardar
this.cb_1=create cb_1
this.dw_master_direcciones=create dw_master_direcciones
this.Control[]={this.dw_master_lista_direcciones,&
this.cb_cancel,&
this.cb_guardar,&
this.cb_1,&
this.dw_master_direcciones}
end on

on tabpage_direcciones.destroy
destroy(this.dw_master_lista_direcciones)
destroy(this.cb_cancel)
destroy(this.cb_guardar)
destroy(this.cb_1)
destroy(this.dw_master_direcciones)
end on

type dw_master_lista_direcciones from u_dw_abc within tabpage_direcciones
integer x = 69
integer y = 452
integer width = 3424
integer height = 1304
integer taborder = 20
string dataobject = "dw_abc_lista_direcciones_clientes_tbl"
boolean hscrollbar = false
boolean livescroll = false
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

event buttonclicked;call super::buttonclicked;string 	ls_mensaje, ls_direccion
Long 		li_direccion_clien_id

if lower(dwo.name) = 'b_delete_item' then
	li_direccion_clien_id = Long(this.object.direccion_clien_id [row])
	ls_direccion = String(this.object.direccion [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro '  + string(ls_direccion) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete DIRECCION_CLIENTES
	where DIRECCION_CLIEN_ID = :li_direccion_clien_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar la direccion. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(cod_cliente_id)
end if
end event

event clicked;call super::clicked;//Override
if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

li_direccion_cliente_id 				= data_direcciones.object.direccion_clien_id [row]
end event

event doubleclicked;call super::doubleclicked;
if li_direccion_cliente_id = 0 then return

is_action = 'open'
tab_main.tabpage_direcciones.dw_master_direcciones.retrieve(li_direccion_cliente_id)
end event

type cb_cancel from commandbutton within tabpage_direcciones
integer x = 1879
integer y = 280
integer width = 334
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "CANCELAR"
end type

event clicked;data_contactos.reset()
data_contactos.insertrow(0)
end event

type cb_guardar from commandbutton within tabpage_direcciones
integer x = 1102
integer y = 280
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GUARDAR"
end type

event clicked;String ls_mensaje

data_direcciones.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Direccion', ls_mensaje)
	return
end if

COMMIT ;

MessageBox('Correcto', 'Se inserto Correctamente')

data_direcciones.reset()
data_direcciones.insertrow(0)

data_direcciones.retrieve(cod_cliente_id)
end event

type cb_1 from commandbutton within tabpage_direcciones
integer x = 3305
integer y = 104
integer width = 123
integer height = 124
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "+"
end type

event clicked;is_action="new"

data_direcciones_lista.enabled =	false
data_direcciones.reset()
data_direcciones.insertrow(0)
end event

type dw_master_direcciones from u_dw_abc within tabpage_direcciones
integer x = 69
integer y = 76
integer width = 3424
integer height = 192
integer taborder = 20
string dataobject = "dw_abc_direccion_clientes_ff"
boolean hscrollbar = false
boolean vscrollbar = false
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

event ue_insert_pre;call super::ue_insert_pre;////String ls_nombre, ls_cod_usr
//
this.Object.cliente_id					[al_row] = cod_cliente_id
this.Object.usuario_id					[al_row] = gi_user

if is_action="open" then 
this.Object.contacto_clien_id		[al_row] = li_contacto_clien_id
end if
//this.Object.cliente_id					[al_row] = gs_cliente
//this.Object.clientes_nombre			[al_row] = ls_nombre
//this.Object.estado_seguimiento		[al_row] = '1'
//this.object.fecha_registro			[al_row] = gnvo_app.of_fecha_Actual()
end event

type st_1 from statictext within w_mantenimiento_clientes
integer y = 56
integer width = 3826
integer height = 104
integer textsize = -12
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "MANTENIMIENTO CLIENTES"
alignment alignment = center!
boolean focusrectangle = false
end type

