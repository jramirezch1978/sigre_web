$PBExportHeader$w_cw003_equipos_empresa.srw
forward
global type w_cw003_equipos_empresa from window
end type
type pb_save from picturebutton within w_cw003_equipos_empresa
end type
type pb_cerrar from picturebutton within w_cw003_equipos_empresa
end type
type dw_master from u_dw_abc within w_cw003_equipos_empresa
end type
end forward

global type w_cw003_equipos_empresa from window
integer width = 2263
integer height = 916
boolean titlebar = true
string title = "Equipo"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_save pb_save
pb_cerrar pb_cerrar
dw_master dw_master
end type
global w_cw003_equipos_empresa w_cw003_equipos_empresa

type variables

end variables

on w_cw003_equipos_empresa.create
this.pb_save=create pb_save
this.pb_cerrar=create pb_cerrar
this.dw_master=create dw_master
this.Control[]={this.pb_save,&
this.pb_cerrar,&
this.dw_master}
end on

on w_cw003_equipos_empresa.destroy
destroy(this.pb_save)
destroy(this.pb_cerrar)
destroy(this.dw_master)
end on

event open;dw_master.Retrieve(w_consola.ii_equipo_empresa_id)
end event

type pb_save from picturebutton within w_cw003_equipos_empresa
integer x = 1952
integer width = 146
integer height = 120
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\BMP\diskette.bmp"
alignment htextalign = left!
string powertiptext = "Grabar"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al grabar', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type pb_cerrar from picturebutton within w_cw003_equipos_empresa
integer x = 2098
integer width = 160
integer height = 128
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\BMP\close.bmp"
alignment htextalign = left!
string powertiptext = "Cerrar"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw003_equipos_empresa
integer x = 18
integer y = 124
integer width = 2231
integer height = 700
string dataobject = "d_abc_equipos_empresa_ff"
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

