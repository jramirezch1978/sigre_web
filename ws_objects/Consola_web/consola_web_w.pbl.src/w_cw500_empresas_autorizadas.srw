$PBExportHeader$w_cw500_empresas_autorizadas.srw
forward
global type w_cw500_empresas_autorizadas from window
end type
type pb_1 from picturebutton within w_cw500_empresas_autorizadas
end type
type st_1 from statictext within w_cw500_empresas_autorizadas
end type
type dw_master from u_dw_abc within w_cw500_empresas_autorizadas
end type
end forward

global type w_cw500_empresas_autorizadas from window
integer width = 1458
integer height = 1536
boolean titlebar = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_1 pb_1
st_1 st_1
dw_master dw_master
end type
global w_cw500_empresas_autorizadas w_cw500_empresas_autorizadas

on w_cw500_empresas_autorizadas.create
this.pb_1=create pb_1
this.st_1=create st_1
this.dw_master=create dw_master
this.Control[]={this.pb_1,&
this.st_1,&
this.dw_master}
end on

on w_cw500_empresas_autorizadas.destroy
destroy(this.pb_1)
destroy(this.st_1)
destroy(this.dw_master)
end on

event open;dw_master.retrieve( )
end event

type pb_1 from picturebutton within w_cw500_empresas_autorizadas
integer x = 1275
integer width = 155
integer height = 120
integer taborder = 10
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

type st_1 from statictext within w_cw500_empresas_autorizadas
integer x = 18
integer y = 76
integer width = 1413
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "EMPRESAS"
alignment alignment = center!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_cw500_empresas_autorizadas
integer x = 18
integer y = 144
integer width = 1413
integer height = 1296
string dataobject = "d_list_empresas_autorizadas_tbl"
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

event doubleclicked;call super::doubleclicked;String ls_mensaje
Integer li_empresa_id
str_parametros	lstr_param

li_empresa_id = this.object.empresa_id [row]

insert into usr_housing_empresa(empresa_id, usr_housing_id)
values( :li_empresa_id, :gi_usr_hou_id);

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox("Error", "ha ocurrido un error al asignar empresa: " + ls_mensaje, Exclamation!)
	return
	
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

