$PBExportHeader$w_messages_error.srw
forward
global type w_messages_error from window
end type
type dw_master from u_dw_abc within w_messages_error
end type
type cb_1 from commandbutton within w_messages_error
end type
end forward

global type w_messages_error from window
integer width = 3241
integer height = 2292
boolean titlebar = true
string title = "Mensajes de error"
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_cerrar ( )
event ue_add_record ( long al_nro_fila,  string as_funcion,  string as_objeto,  string as_mensaje_error )
dw_master dw_master
cb_1 cb_1
end type
global w_messages_error w_messages_error

event ue_cerrar();close(this)
end event

event ue_add_record(long al_nro_fila, string as_funcion, string as_objeto, string as_mensaje_error);Long ll_row
Yield()

ll_row = dw_master.event ue_insert( )

if ll_row > 0 then
	dw_master.object.nro_fila 			[ll_row] = al_nro_fila
	dw_master.object.funcion 			[ll_row] = as_funcion
	dw_master.object.mensaje_Error 	[ll_row] = as_mensaje_error
end if
end event

on w_messages_error.create
this.dw_master=create dw_master
this.cb_1=create cb_1
this.Control[]={this.dw_master,&
this.cb_1}
end on

on w_messages_error.destroy
destroy(this.dw_master)
destroy(this.cb_1)
end on

type dw_master from u_dw_abc within w_messages_error
integer y = 12
integer width = 3205
integer height = 2040
string dataobject = "d_list_errores_tbl"
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

type cb_1 from commandbutton within w_messages_error
integer x = 2779
integer y = 2080
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cerrar"
boolean cancel = true
end type

event clicked;parent.event dynamic ue_cerrar()
end event

