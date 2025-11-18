$PBExportHeader$w_articulos.srw
forward
global type w_articulos from window
end type
type st_1 from statictext within w_articulos
end type
type dw_master from u_dw_abc within w_articulos
end type
type cb_close from commandbutton within w_articulos
end type
type cb_guardar from commandbutton within w_articulos
end type
end forward

global type w_articulos from window
integer width = 2519
integer height = 1348
boolean titlebar = true
string title = "Articulos"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
dw_master dw_master
cb_close cb_close
cb_guardar cb_guardar
end type
global w_articulos w_articulos

on w_articulos.create
this.st_1=create st_1
this.dw_master=create dw_master
this.cb_close=create cb_close
this.cb_guardar=create cb_guardar
this.Control[]={this.st_1,&
this.dw_master,&
this.cb_close,&
this.cb_guardar}
end on

on w_articulos.destroy
destroy(this.st_1)
destroy(this.dw_master)
destroy(this.cb_close)
destroy(this.cb_guardar)
end on

event open;if is_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("cod_articulo")

elseif is_action = 'open' then
	dw_master.Retrieve(ii_sub_categ_id, ii_articulo_id)
end if

end event

type st_1 from statictext within w_articulos
integer y = 52
integer width = 2533
integer height = 100
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "REGISTRO DE ARTICULOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_articulos
integer x = 27
integer y = 172
integer width = 2446
integer height = 908
string dataobject = "dw_abc_articulos_ff"
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

event ue_insert_pre;call super::ue_insert_pre;if is_action="new" then
	this.Object.flag_estado					[al_row] = '1'
end if
this.Object.sub_categ_id					[al_row] = ii_sub_categ_id
this.Object.usuario_id					[al_row] = gi_user
end event

type cb_close from commandbutton within w_articulos
integer x = 1568
integer y = 1132
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CERRAR"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type cb_guardar from commandbutton within w_articulos
integer x = 480
integer y = 1132
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

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Articulo', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

