$PBExportHeader$w_cw501_contactos.srw
forward
global type w_cw501_contactos from window
end type
type pb_add_contacto from picturebutton within w_cw501_contactos
end type
type pb_cancel from picturebutton within w_cw501_contactos
end type
type dw_contactos from u_dw_abc within w_cw501_contactos
end type
end forward

global type w_cw501_contactos from window
integer width = 4384
integer height = 1552
boolean titlebar = true
string title = "Contactos"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_add_contacto pb_add_contacto
pb_cancel pb_cancel
dw_contactos dw_contactos
end type
global w_cw501_contactos w_cw501_contactos

type variables
Integer ii_empresa_id, ii_email_empresa_id
end variables

on w_cw501_contactos.create
this.pb_add_contacto=create pb_add_contacto
this.pb_cancel=create pb_cancel
this.dw_contactos=create dw_contactos
this.Control[]={this.pb_add_contacto,&
this.pb_cancel,&
this.dw_contactos}
end on

on w_cw501_contactos.destroy
destroy(this.pb_add_contacto)
destroy(this.pb_cancel)
destroy(this.dw_contactos)
end on

event open;ii_empresa_id = w_consola.ii_empresa_id
dw_contactos.retrieve( ii_empresa_id)
end event

type pb_add_contacto from picturebutton within w_cw501_contactos
integer x = 3954
integer y = 20
integer width = 192
integer height = 140
integer taborder = 20
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
Open(w_cw006_contacto_empresa)
dw_contactos.retrieve( ii_empresa_id)
end event

type pb_cancel from picturebutton within w_cw501_contactos
integer x = 4142
integer y = 20
integer width = 192
integer height = 140
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

type dw_contactos from u_dw_abc within w_cw501_contactos
integer x = 23
integer y = 164
integer width = 4311
integer height = 1280
string dataobject = "d_list_contactos_empresa_tbl"
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

event doubleclicked;call super::doubleclicked;if row = 0 then return
if right(lower(dwo.name),2) = '_t' then return

this.SelectRow(0, false)
this.SelectRow(row, true)

ii_email_empresa_id = this.object.email_empresa_id [row]

gs_action = 'open'
Open(w_cw006_contacto_empresa)
this.retrieve( ii_empresa_id)
end event

event buttonclicked;call super::buttonclicked;Long 		ll_email_empresa_id
string 	ls_mensaje

if lower(dwo.name) = 'b_eliminar' then
	ll_email_empresa_id = Long(this.object.email_empresa_id [row])
	
	//Preguntar si desea eliminar
	if MessageBox('Aviso', 'Deseas eliminar el registro ' + string(row) + ' con id ' + string(ll_email_empresa_id) + '?', Information!, YesNo!, 2) = 2 then return
	
	Delete contactos_empresa
	where email_empresa_id = :ll_email_empresa_id;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = "No se ha podido eliminar el contacto. Mensaje de Error: " + SQLCA.SQLErrText
		ROLLBACK;
		gnvo_app.of_mensaje_error( ls_mensaje )
		return
	end if
	
	commit;
	MessageBox('Aviso', 'Eliminacion realizada satisfactoriamente', Information!)
	
	this.Retrieve(ii_empresa_id)
end if
end event

