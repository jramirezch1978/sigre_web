$PBExportHeader$w_cw004_cuotas.srw
forward
global type w_cw004_cuotas from window
end type
type pb_cancel from picturebutton within w_cw004_cuotas
end type
type pb_save from picturebutton within w_cw004_cuotas
end type
type dw_master from u_dw_abc within w_cw004_cuotas
end type
end forward

global type w_cw004_cuotas from window
integer width = 2981
integer height = 1044
boolean titlebar = true
string title = "Cuota (w_cw004)"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_save pb_save
dw_master dw_master
end type
global w_cw004_cuotas w_cw004_cuotas

type variables
Integer ii_empresa_id, ii_cronograma_pago_id
end variables

on w_cw004_cuotas.create
this.pb_cancel=create pb_cancel
this.pb_save=create pb_save
this.dw_master=create dw_master
this.Control[]={this.pb_cancel,&
this.pb_save,&
this.dw_master}
end on

on w_cw004_cuotas.destroy
destroy(this.pb_cancel)
destroy(this.pb_save)
destroy(this.dw_master)
end on

event open;String ls_flag_pagado
if gs_action='new' then
	ii_empresa_id = w_consola.ii_empresa_id
	dw_master.Reset()
	dw_master.event ue_Insert()
	
	dw_master.ii_protect = 1
	dw_master.of_protect()
	
	dw_master.SetFocus()
	dw_master.setColumn("nro_cuota")
elseif gs_action = 'open' then
	ii_cronograma_pago_id = w_consola.ii_cronograma_pago_id
	dw_master.Retrieve(ii_cronograma_pago_id)
	ls_flag_pagado = dw_master.object.flag_pagado[1]
	if ls_flag_pagado = '1' then
		pb_save.visible = false;
	end if
end if
end event

type pb_cancel from picturebutton within w_cw004_cuotas
integer x = 2798
integer y = 8
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

type pb_save from picturebutton within w_cw004_cuotas
integer x = 2651
integer y = 8
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

if gs_action = 'open' then
	dw_master.object.modified_by		[1] = gi_user
	dw_master.object.fec_modified	[1] = gnvo_app.of_fecha_actual( )
end if

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al Grabar Cuota', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw004_cuotas
integer x = 27
integer y = 116
integer width = 2921
integer height = 824
string dataobject = "d_abc_cuota_ff"
boolean vscrollbar = false
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

event ue_insert_pre;call super::ue_insert_pre;this.object.empresa_id 		[al_row]	= ii_empresa_id
this.object.dias_tolerancia	[al_row] 	= 0
this.object.flag_pagado 		[al_row] 	= '0'
this.object.created_by 		[al_row] = gi_user
this.object.fec_vencimiento	[al_row] = gnvo_app.of_fecha_actual( )
end event

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nro_solicitud
Long ll_banco_id

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_servicio"

		ls_sql = "select cod_servicio as codigo_servicio, " &
				 + "desc_servicio as descripcion_servicio " &
				 + "from servicios  " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_servicio		[al_row] = ls_codigo
			this.object.desc_servicio		[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_servicio'
		
		// Verifica que codigo ingresado exista			
		Select desc_servicio
	     into :ls_desc
		  from servicios
		 Where cod_servicio = :data  
		   and flag_estado = '1';
			
		// Verifica que el registro exista o no
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Servicio ingresado o no se encuentra activo, por favor verifique")
			this.object.cod_servicio	[row] = ls_null
			this.object.desc_servicio	[row] = ls_null
			return 1
		end if

		this.object.desc_servicio		[row] = ls_desc

END CHOOSE
end event

