$PBExportHeader$w_visitas.srw
forward
global type w_visitas from window
end type
type st_1 from statictext within w_visitas
end type
type cb_cerrar_visita from commandbutton within w_visitas
end type
type cb_grabar_visita from commandbutton within w_visitas
end type
type dw_master_visitas from u_dw_abc within w_visitas
end type
end forward

global type w_visitas from window
integer width = 3022
integer height = 1396
boolean titlebar = true
string title = "Visitas"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_cerrar_visita cb_cerrar_visita
cb_grabar_visita cb_grabar_visita
dw_master_visitas dw_master_visitas
end type
global w_visitas w_visitas

on w_visitas.create
this.st_1=create st_1
this.cb_cerrar_visita=create cb_cerrar_visita
this.cb_grabar_visita=create cb_grabar_visita
this.dw_master_visitas=create dw_master_visitas
this.Control[]={this.st_1,&
this.cb_cerrar_visita,&
this.cb_grabar_visita,&
this.dw_master_visitas}
end on

on w_visitas.destroy
destroy(this.st_1)
destroy(this.cb_cerrar_visita)
destroy(this.cb_grabar_visita)
destroy(this.dw_master_visitas)
end on

event open;if is_action='new' then
	dw_master_visitas.Reset()
	dw_master_visitas.event ue_Insert()
	
	dw_master_visitas.ii_protect = 1
	dw_master_visitas.of_protect()
	
	dw_master_visitas.SetFocus()
	dw_master_visitas.setColumn("visita_id")

elseif is_action = 'open' then
	dw_master_visitas.Retrieve(li_seguimiento_id,li_visita_id)
end if

end event

type st_1 from statictext within w_visitas
integer y = 24
integer width = 3031
integer height = 80
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "REGISTRO DE VISITAS"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cerrar_visita from commandbutton within w_visitas
integer x = 1925
integer y = 1164
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CANCELAR"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type cb_grabar_visita from commandbutton within w_visitas
integer x = 741
integer y = 1164
integer width = 402
integer height = 112
integer taborder = 20
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

dw_master_visitas.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar la Visita', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master_visitas from u_dw_abc within w_visitas
integer x = 37
integer y = 148
integer width = 2917
integer height = 980
string dataobject = "dw_abc_visita_ff"
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

event ue_insert_pre;call super::ue_insert_pre;this.Object.seguimiento_id					[al_row] = li_seguimiento_id
this.Object.visita_id					[al_row] = li_visita_id


this.Object.cotizacion_usuario_id					[al_row] = gi_user_visita
end event

