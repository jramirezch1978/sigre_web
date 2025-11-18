$PBExportHeader$w_cw005_pago_cuota.srw
forward
global type w_cw005_pago_cuota from window
end type
type pb_cancel from picturebutton within w_cw005_pago_cuota
end type
type pb_save from picturebutton within w_cw005_pago_cuota
end type
type dw_master from u_dw_abc within w_cw005_pago_cuota
end type
end forward

global type w_cw005_pago_cuota from window
integer width = 2048
integer height = 1560
boolean titlebar = true
string title = "Pagar Cuota (w_cw005)"
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
pb_cancel pb_cancel
pb_save pb_save
dw_master dw_master
end type
global w_cw005_pago_cuota w_cw005_pago_cuota

type variables
Integer ii_cronograma_pago_id
end variables

on w_cw005_pago_cuota.create
this.pb_cancel=create pb_cancel
this.pb_save=create pb_save
this.dw_master=create dw_master
this.Control[]={this.pb_cancel,&
this.pb_save,&
this.dw_master}
end on

on w_cw005_pago_cuota.destroy
destroy(this.pb_cancel)
destroy(this.pb_save)
destroy(this.dw_master)
end on

event open;ii_cronograma_pago_id = w_consola.ii_cronograma_pago_id

dw_master.Retrieve(ii_cronograma_pago_id)
dw_master.object.flag_pagado [1] = '1'
dw_master.object.fec_pago		[1] = gnvo_app.of_fecha_actual( )
end event

type pb_cancel from picturebutton within w_cw005_pago_cuota
integer x = 1874
integer y = 20
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

type pb_save from picturebutton within w_cw005_pago_cuota
integer x = 1728
integer y = 20
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

dw_master.object.modified_by		[1] = gi_user
dw_master.object.fec_modified	[1] = gnvo_app.of_fecha_actual( )

dw_master.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al Grabar Pago', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master from u_dw_abc within w_cw005_pago_cuota
integer x = 18
integer y = 132
integer width = 2002
integer height = 1304
string dataobject = "d_abc_pago_cuota_ff"
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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql, ls_nro_solicitud
Long ll_banco_id

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_banco"

		ls_sql = "select cod_banco as codigo_banco, " &
				 + "desc_banco as descripcion_banco " &
				 + "from bancos  " &
				 + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			Select banco_id
	     		into :ll_banco_id
		  	from bancos
		 	Where cod_banco = :ls_codigo  
		   		and flag_estado = '1';
			
			this.object.banco_id		[al_row] = ll_banco_id
			this.object.cod_banco		[al_row] = ls_codigo
			this.object.desc_banco	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count, ll_banco_id

dw_master.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cod_banco'
		
		// Verifica que codigo ingresado exista			
		Select banco_id, desc_banco
	     into :ll_banco_id, :ls_desc
		  from bancos
		 Where cod_banco = :data  
		   and flag_estado = '1';
			
		// Verifica que el registro exista o no
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Banco ingresado o no se encuentra activo, por favor verifique")
			this.object.banco_id	[row] = ls_null
			this.object.desc_banco	[row] = ls_null
			return 1
			
		end if

		this.object.banco_id		[row] = ll_banco_id
		this.object.desc_banco		[row] = ls_desc

END CHOOSE
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

