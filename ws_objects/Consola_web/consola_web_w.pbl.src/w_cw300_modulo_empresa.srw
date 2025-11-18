$PBExportHeader$w_cw300_modulo_empresa.srw
forward
global type w_cw300_modulo_empresa from window
end type
type st_2 from statictext within w_cw300_modulo_empresa
end type
type dw_modulo_empresa from u_dw_abc within w_cw300_modulo_empresa
end type
type cb_delete_all from picturebutton within w_cw300_modulo_empresa
end type
type cb_delete_one from picturebutton within w_cw300_modulo_empresa
end type
type cb_add_one from picturebutton within w_cw300_modulo_empresa
end type
type cb_add_all from picturebutton within w_cw300_modulo_empresa
end type
type st_1 from statictext within w_cw300_modulo_empresa
end type
type dw_modulos from u_dw_abc within w_cw300_modulo_empresa
end type
type pb_cancel from picturebutton within w_cw300_modulo_empresa
end type
end forward

global type w_cw300_modulo_empresa from window
integer width = 4302
integer height = 1568
boolean titlebar = true
string title = "Asignar módulos a empresa"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_2 st_2
dw_modulo_empresa dw_modulo_empresa
cb_delete_all cb_delete_all
cb_delete_one cb_delete_one
cb_add_one cb_add_one
cb_add_all cb_add_all
st_1 st_1
dw_modulos dw_modulos
pb_cancel pb_cancel
end type
global w_cw300_modulo_empresa w_cw300_modulo_empresa

type variables
Integer ii_empresa_id
end variables

on w_cw300_modulo_empresa.create
this.st_2=create st_2
this.dw_modulo_empresa=create dw_modulo_empresa
this.cb_delete_all=create cb_delete_all
this.cb_delete_one=create cb_delete_one
this.cb_add_one=create cb_add_one
this.cb_add_all=create cb_add_all
this.st_1=create st_1
this.dw_modulos=create dw_modulos
this.pb_cancel=create pb_cancel
this.Control[]={this.st_2,&
this.dw_modulo_empresa,&
this.cb_delete_all,&
this.cb_delete_one,&
this.cb_add_one,&
this.cb_add_all,&
this.st_1,&
this.dw_modulos,&
this.pb_cancel}
end on

on w_cw300_modulo_empresa.destroy
destroy(this.st_2)
destroy(this.dw_modulo_empresa)
destroy(this.cb_delete_all)
destroy(this.cb_delete_one)
destroy(this.cb_add_one)
destroy(this.cb_add_all)
destroy(this.st_1)
destroy(this.dw_modulos)
destroy(this.pb_cancel)
end on

event open;//dw_master.Retrieve(w_consola.ii_empresa_id)
ii_empresa_id = w_consola.ii_empresa_id
dw_modulos.retrieve(ii_empresa_id)
dw_modulo_empresa.retrieve(ii_empresa_id)
end event

type st_2 from statictext within w_cw300_modulo_empresa
integer x = 2565
integer y = 76
integer width = 1691
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "MODULOS ASIGNADOS"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_modulo_empresa from u_dw_abc within w_cw300_modulo_empresa
integer x = 2565
integer y = 140
integer width = 1691
integer height = 1336
integer taborder = 20
string dataobject = "d_list_modulo_empresa_tbl"
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

type cb_delete_all from picturebutton within w_cw300_modulo_empresa
integer x = 2395
integer y = 1012
integer width = 137
integer height = 112
integer taborder = 50
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\primero.bmp"
end type

event clicked;String ls_mensaje
Integer li_modulo_empr_id, li_x
Long	ll_row_count

ll_row_count = dw_modulo_empresa.rowcount( )

FOR li_x = 1 to ll_row_count
	li_modulo_empr_id = dw_modulo_empresa.object.modulo_empr_id [li_x]
	
	delete from modulo_empresa 
	where modulo_empr_id = :li_modulo_empr_id;

	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al quitar modulo', ls_mensaje)
		return
	end if
NEXT

dw_modulos.Retrieve(ii_empresa_id) 
dw_modulo_empresa.Retrieve(ii_empresa_id)

COMMIT ;
end event

type cb_delete_one from picturebutton within w_cw300_modulo_empresa
integer x = 2395
integer y = 880
integer width = 146
integer height = 128
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\previous.bmp"
end type

event clicked;String ls_mensaje
Integer li_modulo_empr_id
Long	ll_row

ll_row = dw_modulo_empresa.getselectedrow( 0)
if ll_row = 0 then return

li_modulo_empr_id = dw_modulo_empresa.object.modulo_empr_id [ll_row]

delete from modulo_empresa 
where modulo_empr_id = :li_modulo_empr_id;

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al quitar modulo', ls_mensaje)
	return
end if

dw_modulos.Retrieve(ii_empresa_id)
dw_modulo_empresa.Retrieve(ii_empresa_id)

COMMIT ;
end event

type cb_add_one from picturebutton within w_cw300_modulo_empresa
integer x = 2395
integer y = 748
integer width = 146
integer height = 128
integer taborder = 30
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\next.bmp"
end type

event clicked;String ls_mensaje
Integer li_modulo_id
Long	ll_row

ll_row = dw_modulos.getselectedrow( 0)
if ll_row = 0 then return

li_modulo_id = dw_modulos.object.modulo_id [ll_row]

insert into modulo_empresa(empresa_id, modulo_id)
values( :ii_empresa_id, :li_modulo_id);

if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al asignar modulo', ls_mensaje)
	return
end if

dw_modulos.Retrieve(ii_empresa_id)
dw_modulo_empresa.Retrieve(ii_empresa_id)

COMMIT ;
end event

type cb_add_all from picturebutton within w_cw300_modulo_empresa
integer x = 2395
integer y = 616
integer width = 146
integer height = 128
integer taborder = 20
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\last.bmp"
end type

event clicked;String ls_mensaje
Integer li_modulo_id, li_x
Long	ll_row_count

ll_row_count = dw_modulos.rowcount( )

FOR li_x = 1 to ll_row_count
	li_modulo_id = dw_modulos.object.modulo_id [li_x]
	
	insert into modulo_empresa(empresa_id, modulo_id)
	values( :ii_empresa_id, :li_modulo_id);

	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al asignar modulo', ls_mensaje)
		return
	end if
NEXT

dw_modulos.Retrieve(ii_empresa_id) 
dw_modulo_empresa.Retrieve(ii_empresa_id)

COMMIT ;
end event

type st_1 from statictext within w_cw300_modulo_empresa
integer x = 32
integer y = 76
integer width = 2336
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "MODULOS DISPONIBLES"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_modulos from u_dw_abc within w_cw300_modulo_empresa
integer x = 32
integer y = 140
integer width = 2336
integer height = 1336
string dataobject = "d_list_modulos_disponibles_tbl"
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

type pb_cancel from picturebutton within w_cw300_modulo_empresa
integer x = 4110
integer y = 4
integer width = 151
integer height = 128
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "C:\SIGRE\resources\BMP\close.bmp"
string powertiptext = "Cerrar"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

