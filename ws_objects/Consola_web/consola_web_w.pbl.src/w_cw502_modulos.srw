$PBExportHeader$w_cw502_modulos.srw
forward
global type w_cw502_modulos from window
end type
type pb_cancel from picturebutton within w_cw502_modulos
end type
type pb_add_modulo from picturebutton within w_cw502_modulos
end type
type dw_modulos from u_dw_abc within w_cw502_modulos
end type
end forward

global type w_cw502_modulos from window
integer width = 3589
integer height = 1828
boolean titlebar = true
string title = "Modulos (w_cw502)"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_add_modulo pb_add_modulo
dw_modulos dw_modulos
end type
global w_cw502_modulos w_cw502_modulos

on w_cw502_modulos.create
this.pb_cancel=create pb_cancel
this.pb_add_modulo=create pb_add_modulo
this.dw_modulos=create dw_modulos
this.Control[]={this.pb_cancel,&
this.pb_add_modulo,&
this.dw_modulos}
end on

on w_cw502_modulos.destroy
destroy(this.pb_cancel)
destroy(this.pb_add_modulo)
destroy(this.dw_modulos)
end on

event open;dw_modulos.retrieve()
end event

type pb_cancel from picturebutton within w_cw502_modulos
integer x = 3369
integer y = 20
integer width = 192
integer height = 140
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

type pb_add_modulo from picturebutton within w_cw502_modulos
integer x = 3177
integer y = 20
integer width = 192
integer height = 140
integer taborder = 10
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string picturename = "C:\SIGRE\resources\Toolbar\note_add.png"
alignment htextalign = right!
string powertiptext = "Agregar contacto"
end type

event clicked;gs_action = 'new'
Open(w_cw010_modulos)
dw_modulos.retrieve( )
end event

type dw_modulos from u_dw_abc within w_cw502_modulos
integer x = 37
integer y = 164
integer width = 3525
integer height = 1564
string dataobject = "d_list_modulos_tbl"
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

event doubleclicked;call super::doubleclicked;str_parametros sl_param

if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

sl_param.int1	= dw_modulos.object.modulo_id [row]

gs_action = 'open'
dw_modulos.Accepttext()

OpenWithParm( w_cw010_modulos, sl_param)
dw_modulos.Retrieve()
end event

