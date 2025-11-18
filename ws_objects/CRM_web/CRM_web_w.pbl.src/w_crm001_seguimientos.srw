$PBExportHeader$w_crm001_seguimientos.srw
forward
global type w_crm001_seguimientos from window
end type
type cb_salir from commandbutton within w_crm001_seguimientos
end type
type cb_grabar from commandbutton within w_crm001_seguimientos
end type
type dw_master from u_dw_abc within w_crm001_seguimientos
end type
end forward

global type w_crm001_seguimientos from window
integer width = 3090
integer height = 1516
boolean titlebar = true
string title = "Seguimiento"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
cb_salir cb_salir
cb_grabar cb_grabar
dw_master dw_master
end type
global w_crm001_seguimientos w_crm001_seguimientos

type variables

end variables

on w_crm001_seguimientos.create
this.cb_salir=create cb_salir
this.cb_grabar=create cb_grabar
this.dw_master=create dw_master
this.Control[]={this.cb_salir,&
this.cb_grabar,&
this.dw_master}
end on

on w_crm001_seguimientos.destroy
destroy(this.cb_salir)
destroy(this.cb_grabar)
destroy(this.dw_master)
end on

event open;if is_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	 
	dw_master.SetFocus()
	dw_master.setColumn("cliente_id")
elseif is_action = 'open' then
	dw_master.Retrieve(li_seguimiento_id)
end if

end event

type cb_salir from commandbutton within w_crm001_seguimientos
integer x = 1883
integer y = 1260
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CERRAR"
end type

event clicked;Str_parametros lstr_param
lstr_param.b_return	= false
CloseWithReturn(w_crm001_seguimientos, lstr_param)
end event

type cb_grabar from commandbutton within w_crm001_seguimientos
integer x = 795
integer y = 1260
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "GRABAR"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Seguimiento', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.b_return = true
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_crm001_seguimientos
integer x = 41
integer y = 40
integer width = 3017
integer height = 1168
string dataobject = "d_abc_seguimientos_ff"
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

event ue_insert_pre;call super::ue_insert_pre;String ls_nombre, ls_cod_usr

select nombre
into :ls_nombre
from clientes
where cliente_id = :gs_cliente;

select cod_usr
into :ls_cod_usr
from usuarios
where usuario_id = :gi_user;

this.Object.usuario_id					[al_row] = gi_user
this.Object.usuarios_cod_usr		[al_row] = ls_cod_usr
this.Object.cliente_id					[al_row] = gs_cliente
this.Object.clientes_nombre			[al_row] = ls_nombre
this.Object.estado_seguimiento		[al_row] = '1'
this.object.fecha_registro			[al_row] = gnvo_app.of_fecha_Actual()
end event

