$PBExportHeader$w_cw301_empresa_version.srw
forward
global type w_cw301_empresa_version from window
end type
type pb_save from picturebutton within w_cw301_empresa_version
end type
type st_1 from statictext within w_cw301_empresa_version
end type
type dw_version from u_dw_abc within w_cw301_empresa_version
end type
type pb_cancel from picturebutton within w_cw301_empresa_version
end type
end forward

global type w_cw301_empresa_version from window
integer width = 2395
integer height = 1568
boolean titlebar = true
string title = "Asignar versión a empresa"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_save pb_save
st_1 st_1
dw_version dw_version
pb_cancel pb_cancel
end type
global w_cw301_empresa_version w_cw301_empresa_version

type variables
Integer ii_empresa_id
end variables

on w_cw301_empresa_version.create
this.pb_save=create pb_save
this.st_1=create st_1
this.dw_version=create dw_version
this.pb_cancel=create pb_cancel
this.Control[]={this.pb_save,&
this.st_1,&
this.dw_version,&
this.pb_cancel}
end on

on w_cw301_empresa_version.destroy
destroy(this.pb_save)
destroy(this.st_1)
destroy(this.dw_version)
destroy(this.pb_cancel)
end on

event open;//dw_master.Retrieve(w_consola.ii_empresa_id)
ii_empresa_id = w_consola.ii_empresa_id
dw_version.retrieve(ii_empresa_id)
end event

type pb_save from picturebutton within w_cw301_empresa_version
integer x = 2066
integer y = 12
integer width = 151
integer height = 128
integer taborder = 20
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
Integer li_version_id, li_version_actual, li_x
Long	ll_row, ll_row_count

li_version_id = 0

ll_row_count = dw_version.rowcount( )

FOR li_x = 1 to ll_row_count
	if dw_version.object.seleccionado	[li_x] = 1 then
		li_version_id = dw_version.object.version_id [li_x]
		exit
	end if
NEXT

//ll_row = dw_version.getselectedrow( 0)
if li_version_id = 0 then 
	update empresa_versiones 
	set flag_estado = '0'
	where empresa_id = :ii_empresa_id;
	COMMIT ;
	return
end if

select version_id 
into :li_version_actual
from empresa_versiones 
where empresa_id = : ii_empresa_id
		and flag_estado = '1';

if li_version_id <> li_version_actual then
	update empresa_versiones 
	set flag_estado = '0'
	where empresa_id = :ii_empresa_id;
	
	insert into empresa_versiones(empresa_id, version_id)
	values( :ii_empresa_id, :li_version_id);

	if sqlca.sqlCode < 0 then
		ls_mensaje = sqlca.SQLErrText
		ROLLBACK;
		MessageBox('Error al asignar modulo', ls_mensaje)
		return
	end if
	
	COMMIT ;
end if

dw_version.Retrieve(ii_empresa_id)

end event

type st_1 from statictext within w_cw301_empresa_version
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
string text = "VERSIONES"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_version from u_dw_abc within w_cw301_empresa_version
integer x = 32
integer y = 140
integer width = 2336
integer height = 1336
string dataobject = "d_list_versiones_tbl"
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

event clicked;call super::clicked;Long		ll_empresa_id,ll_row_count
Integer li_x

if lower(dwo.name) = 'seleccionado' then

	ll_row_count = dw_version.rowcount( )

	FOR li_x = 1 to ll_row_count
		this.object.seleccionado	[li_x] = 0
	NEXT
	
end if
end event

type pb_cancel from picturebutton within w_cw301_empresa_version
integer x = 2217
integer y = 12
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

