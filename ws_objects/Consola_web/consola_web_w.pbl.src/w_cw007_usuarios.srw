$PBExportHeader$w_cw007_usuarios.srw
forward
global type w_cw007_usuarios from window
end type
type pb_save from picturebutton within w_cw007_usuarios
end type
type pb_cancel from picturebutton within w_cw007_usuarios
end type
type dw_master from u_dw_abc within w_cw007_usuarios
end type
end forward

global type w_cw007_usuarios from window
integer width = 1426
integer height = 848
boolean titlebar = true
string title = "Usuario"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_save pb_save
pb_cancel pb_cancel
dw_master dw_master
end type
global w_cw007_usuarios w_cw007_usuarios

type variables
Integer ii_usuario_id
end variables

on w_cw007_usuarios.create
this.pb_save=create pb_save
this.pb_cancel=create pb_cancel
this.dw_master=create dw_master
this.Control[]={this.pb_save,&
this.pb_cancel,&
this.dw_master}
end on

on w_cw007_usuarios.destroy
destroy(this.pb_save)
destroy(this.pb_cancel)
destroy(this.dw_master)
end on

event open;if gs_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("cod_usr")
elseif gs_action = 'open' then
	ii_usuario_id = w_consola.ii_usuario_id
	dw_master.Retrieve(ii_usuario_id)
end if
end event

type pb_save from picturebutton within w_cw007_usuarios
integer x = 1093
integer y = 12
integer width = 151
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\BMP\diskette.bmp"
alignment htextalign = left!
string powertiptext = "Guardar"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al grabar usuario', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type pb_cancel from picturebutton within w_cw007_usuarios
integer x = 1239
integer y = 12
integer width = 151
integer height = 108
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\BMP\close.bmp"
alignment htextalign = left!
string powertiptext = "Cancelar"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw007_usuarios
integer x = 32
integer y = 120
integer width = 1367
integer height = 628
string dataobject = "d_abc_usuarios_ff"
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

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado	[al_row] = '1'
this.object.clave			[al_row]	= 'x'
end event

