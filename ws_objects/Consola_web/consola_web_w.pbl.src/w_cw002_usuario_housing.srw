$PBExportHeader$w_cw002_usuario_housing.srw
forward
global type w_cw002_usuario_housing from window
end type
type pb_cancel from picturebutton within w_cw002_usuario_housing
end type
type pb_save from picturebutton within w_cw002_usuario_housing
end type
type dw_master from u_dw_abc within w_cw002_usuario_housing
end type
end forward

global type w_cw002_usuario_housing from window
integer width = 2240
integer height = 864
boolean titlebar = true
string title = "Usuario Housing"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_save pb_save
dw_master dw_master
end type
global w_cw002_usuario_housing w_cw002_usuario_housing

on w_cw002_usuario_housing.create
this.pb_cancel=create pb_cancel
this.pb_save=create pb_save
this.dw_master=create dw_master
this.Control[]={this.pb_cancel,&
this.pb_save,&
this.dw_master}
end on

on w_cw002_usuario_housing.destroy
destroy(this.pb_cancel)
destroy(this.pb_save)
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
	dw_master.Retrieve(gi_usr_hou_id)
end if
end event

type pb_cancel from picturebutton within w_cw002_usuario_housing
integer x = 2016
integer y = 28
integer width = 146
integer height = 120
integer taborder = 20
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

type pb_save from picturebutton within w_cw002_usuario_housing
integer x = 1874
integer y = 28
integer width = 146
integer height = 120
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
boolean originalsize = true
string picturename = "C:\SIGRE\resources\BMP\diskette.bmp"
alignment htextalign = left!
string powertiptext = "Gradar"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Usuario Housing', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw002_usuario_housing
integer x = 27
integer y = 148
integer width = 2135
integer height = 612
string dataobject = "d_abc_usuarios_housing_ff"
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

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'
this.object.flag_empre_ini	[al_row] = '1'
end event

