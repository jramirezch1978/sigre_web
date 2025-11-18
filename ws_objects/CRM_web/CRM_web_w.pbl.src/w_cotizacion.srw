$PBExportHeader$w_cotizacion.srw
forward
global type w_cotizacion from window
end type
type st_1 from statictext within w_cotizacion
end type
type cb_cerrar_visita from commandbutton within w_cotizacion
end type
type cb_grabar_visita from commandbutton within w_cotizacion
end type
type dw_master_cotizacion from u_dw_abc within w_cotizacion
end type
end forward

global type w_cotizacion from window
integer width = 2615
integer height = 1088
boolean titlebar = true
string title = "Cotizacion"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_cerrar_visita cb_cerrar_visita
cb_grabar_visita cb_grabar_visita
dw_master_cotizacion dw_master_cotizacion
end type
global w_cotizacion w_cotizacion

on w_cotizacion.create
this.st_1=create st_1
this.cb_cerrar_visita=create cb_cerrar_visita
this.cb_grabar_visita=create cb_grabar_visita
this.dw_master_cotizacion=create dw_master_cotizacion
this.Control[]={this.st_1,&
this.cb_cerrar_visita,&
this.cb_grabar_visita,&
this.dw_master_cotizacion}
end on

on w_cotizacion.destroy
destroy(this.st_1)
destroy(this.cb_cerrar_visita)
destroy(this.cb_grabar_visita)
destroy(this.dw_master_cotizacion)
end on

event open;if is_action='new' then
	dw_master_cotizacion.Reset()
	dw_master_cotizacion.event ue_Insert()
	
	dw_master_cotizacion.ii_protect = 1
	dw_master_cotizacion.of_protect()
	
	dw_master_cotizacion.SetFocus()
	dw_master_cotizacion.setColumn("cotizacion_cod_cotizacion")

elseif is_action = 'open' then
	dw_master_cotizacion.Retrieve(gs_cliente_cotiz_id,gi_cotizacion_id)
end if

end event

type st_1 from statictext within w_cotizacion
integer y = 24
integer width = 2606
integer height = 80
integer textsize = -14
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial Narrow"
long textcolor = 33554432
long backcolor = 16777215
string text = "REGISTRO DE COTIZACION"
alignment alignment = center!
boolean focusrectangle = false
end type

type cb_cerrar_visita from commandbutton within w_cotizacion
integer x = 1650
integer y = 840
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "CANCELAR"
end type

event clicked;str_parametros lstr_param

lstr_param.titulo = 'n'
CloseWithReturn(parent, lstr_param)
end event

type cb_grabar_visita from commandbutton within w_cotizacion
integer x = 466
integer y = 840
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "GRABAR"
end type

event clicked;String ls_mensaje
str_parametros	lstr_param

dw_master_cotizacion.update()
if sqlca.sqlCode < 0 then
	ls_mensaje = sqlca.SQLErrText
	ROLLBACK;
	MessageBox('Error al insertar la Cotizacion', ls_mensaje)
	return
end if

COMMIT ;
lstr_param.titulo = 's'
CloseWithReturn(parent, lstr_param)
end event

type dw_master_cotizacion from u_dw_abc within w_cotizacion
integer x = 37
integer y = 148
integer width = 2523
integer height = 652
string dataobject = "dw_abc_cotizacion_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event constructor;call super::constructor;
is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
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

event ue_insert_pre;call super::ue_insert_pre;this.Object.cotizacion_usuario_id					[al_row] = gi_user
this.Object.usuarios_cod_usr					[al_row] = gs_user
end event

event itemchanged;call super::itemchanged;String 	ls_null, ls_desc
Long 		ll_count, ll_banco_id
IF gi_cotizacion_id=0 then return
dw_master_cotizacion.Accepttext()
Accepttext()
SetNull( ls_null)

CHOOSE CASE dwo.name
	CASE 'cotizacion_cliente_id'
		
		// Verifica que codigo ingresado exista			
		Select nombre
	     into :ls_desc
		  from clientes
		 Where cliente_id = :data  
		   and flag_estado = '1';
			
		// Verifica que el registro exista o no
		if SQLCA.SQlCode = 100 then
			ROLLBACK;
			MessageBox("Error", "No existe Cliente ingresado o no se encuentra activo, por favor verifique")
			this.object.cotizacion_cliente_id	[row] = ls_null
			this.object.clientes_nombre	[row] = ls_null
			return 1
			
		end if

		this.object.clientes_nombre		[row] = ls_desc

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

event ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
case "cotizacion_cliente_id"
		ls_sql = "SELECT cliente_id AS ClienteID, " &
				  + "nombre AS Nombres " &
				  + "FROM clientes " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.cotizacion_cliente_id	[al_row] = ls_codigo
			this.object.clientes_nombre	[al_row] = ls_data
			this.ii_update = 1
		end if
//		
//	case "cencos"
//		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
//				  + "desc_cencos AS descripcion_cencos " &
//				  + "FROM centros_costo " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cencos		[al_row] = ls_codigo
//			this.object.desc_cencos	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//	case "cod_origen"
//		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
//				  + "nombre AS descripcion_origen " &
//				  + "FROM origen " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_origen	[al_row] = ls_codigo
//			this.object.nom_origen	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case "cod_responsable"
//		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
//				  + "NOMBRE AS nombre_usuario " &
//				  + "FROM usuario " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_responsable	[al_row] = ls_codigo
//			this.object.nom_usuario			[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
end choose
end event

