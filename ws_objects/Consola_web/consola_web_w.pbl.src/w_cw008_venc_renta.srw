$PBExportHeader$w_cw008_venc_renta.srw
forward
global type w_cw008_venc_renta from window
end type
type pb_cancel from picturebutton within w_cw008_venc_renta
end type
type pb_save from picturebutton within w_cw008_venc_renta
end type
type dw_master from u_dw_abc within w_cw008_venc_renta
end type
end forward

global type w_cw008_venc_renta from window
integer width = 2491
integer height = 1096
boolean titlebar = true
string title = "Cronograma Renta (w_cw008)"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_save pb_save
dw_master dw_master
end type
global w_cw008_venc_renta w_cw008_venc_renta

type variables
Integer ii_mes, ii_anio
String is_mensual_anual, is_ult_dig, is_bue_contrib
end variables

on w_cw008_venc_renta.create
this.pb_cancel=create pb_cancel
this.pb_save=create pb_save
this.dw_master=create dw_master
this.Control[]={this.pb_cancel,&
this.pb_save,&
this.dw_master}
end on

on w_cw008_venc_renta.destroy
destroy(this.pb_cancel)
destroy(this.pb_save)
destroy(this.dw_master)
end on

event open;is_mensual_anual = w_consola.is_mensual_anual
if is_mensual_anual = '1' then
	dw_master.object.mes.visible 		= false
	dw_master.object.mes_t.visible 	= false
end if
if gs_action='new' then
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("cod_usr")
elseif gs_action = 'open' then
	is_ult_dig			=	w_consola.is_ult_dig
	ii_anio				=	w_consola.ii_anio
	is_mensual_anual	=	w_consola.is_mensual_anual
	is_bue_contrib		=	w_consola.is_bue_contrib
	ii_mes				=	w_consola.ii_mes 
	dw_master.Retrieve(is_ult_dig, ii_anio, is_mensual_anual, is_bue_contrib, ii_mes)
end if
end event

type pb_cancel from picturebutton within w_cw008_venc_renta
integer x = 2295
integer y = 32
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

type pb_save from picturebutton within w_cw008_venc_renta
integer x = 2149
integer y = 32
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

event clicked;String ls_mensaje, ls_flag_buen_contribuyente
str_parametros	lstr_param

//Si se esta grabando un buen contribuyente al ult_dig_ruc se le asigna '-'
ls_flag_buen_contribuyente = dw_master.object.flag_buen_contribuyente	[1]
if ls_flag_buen_contribuyente = '1' then
	dw_master.object.ult_dig_ruc	[1] =	'-'
end if

//Graba el datawindows
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

type dw_master from u_dw_abc within w_cw008_venc_renta
integer x = 37
integer y = 148
integer width = 2409
integer height = 832
string dataobject = "d_abc_venc_renta_ff"
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

event ue_insert_pre;call super::ue_insert_pre;this.object.flag_buen_contribuyente	[al_row]	=	'0'
if is_mensual_anual = '0' then
	this.object.flag_mensual_anual		[al_row] = '0'
elseif is_mensual_anual = '1' then
	this.object.flag_mensual_anual			[al_row] = '1'
	this.object.mes			[al_row] = 0
end if
this.object.create_by		[al_row] = gi_user
end event

event ue_display;call super::ue_display;/*boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nro_solicitud
Long ll_banco_id

this.AcceptText()

choose case lower(as_columna)
		
	case "flag_buen_contribuyente"
		ls_codigo = this.object.flag_buen_contribuyente		[al_row]
		MessageBox("Aviso", ls_codigo)

		//this.object.banco_id		[al_row] = ll_banco_id
end choose*/
end event

