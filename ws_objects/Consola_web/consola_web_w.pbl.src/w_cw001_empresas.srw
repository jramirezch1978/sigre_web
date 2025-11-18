$PBExportHeader$w_cw001_empresas.srw
forward
global type w_cw001_empresas from window
end type
type pb_cancel from picturebutton within w_cw001_empresas
end type
type pb_save from picturebutton within w_cw001_empresas
end type
type dw_master from u_dw_abc within w_cw001_empresas
end type
end forward

global type w_cw001_empresas from window
integer width = 3227
integer height = 1244
boolean titlebar = true
string title = "Registrar Empresa"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_save pb_save
dw_master dw_master
end type
global w_cw001_empresas w_cw001_empresas

on w_cw001_empresas.create
this.pb_cancel=create pb_cancel
this.pb_save=create pb_save
this.dw_master=create dw_master
this.Control[]={this.pb_cancel,&
this.pb_save,&
this.dw_master}
end on

on w_cw001_empresas.destroy
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
	dw_master.setColumn("cod_empresa")
elseif gs_action = 'open' then
	dw_master.Retrieve(gs_empresa)
end if

end event

type pb_cancel from picturebutton within w_cw001_empresas
integer x = 3058
integer y = 24
integer width = 151
integer height = 108
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

type pb_save from picturebutton within w_cw001_empresas
integer x = 2912
integer y = 24
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
if gs_action = "open" then
	dw_master.object.modified_by			[1] = gi_user
	dw_master.object.fec_modified		[1] = gnvo_app.of_fecha_actual( )
end if
dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar Empresa', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw001_empresas
integer x = 9
integer y = 140
integer width = 3200
integer height = 996
string dataobject = "d_abc_empresas_ff"
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

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_buen_contribuyente	[al_row] = '0'
this.object.dias_aviso_declaracion		[al_row] = 5
this.object.flag_autorizado 				[al_row]  = '1'
this.object.nro_licencia 					[al_row]  = 0
this.object.flag_estado 					[al_row]  = '1'
this.object.created_by 					[al_row]  = gi_user
end event

