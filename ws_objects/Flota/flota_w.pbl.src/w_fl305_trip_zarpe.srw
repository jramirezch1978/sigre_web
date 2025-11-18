$PBExportHeader$w_fl305_trip_zarpe.srw
forward
global type w_fl305_trip_zarpe from w_abc
end type
type pb_load from picturebutton within w_fl305_trip_zarpe
end type
type pb_update from u_pb_update within w_fl305_trip_zarpe
end type
type pb_modify from u_pb_modify within w_fl305_trip_zarpe
end type
type pb_new from u_pb_insert within w_fl305_trip_zarpe
end type
type pb_delete from u_pb_delete within w_fl305_trip_zarpe
end type
type dw_master from u_dw_abc within w_fl305_trip_zarpe
end type
end forward

global type w_fl305_trip_zarpe from w_abc
integer width = 2226
integer height = 1556
string title = "Tripulantes en el zarpe (FL305)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean center = true
event ue_load ( )
pb_load pb_load
pb_update pb_update
pb_modify pb_modify
pb_new pb_new
pb_delete pb_delete
dw_master dw_master
end type
global w_fl305_trip_zarpe w_fl305_trip_zarpe

type variables
string is_nro_parte, is_aprobado
uo_parte_pesca iuo_parte
end variables

event ue_load();string			ls_cod_nave
str_parametros 	lstr_param

if IsNull(is_nro_parte) or is_nro_parte = '' then
	MessageBox('Aviso', 'NO SE HA DEFINIDO EL PARTE DE PESCA',StopSign!)
	return
end if

if is_aprobado = '1' then
	MessageBox('Aviso', 'PARTE DE PESCA ESTA APROBADO, NO PUEDE MODIFICAR',StopSign!)
	return
end if

SetNull(ls_cod_nave)
select nave_real
	into :ls_cod_nave
from fl_parte_de_pesca
where parte_pesca = :is_nro_parte;

if IsNull(ls_cod_nave) or ls_cod_nave = '' then
	MessageBox('Aviso', 'PARTE DE PESCA NO EXISTE O NO SE HA DEFINIDO LA NAVE',StopSign!)
	return
end if

lstr_param.string1 = is_nro_parte
lstr_param.string2 = is_aprobado
lstr_param.string3 = ls_cod_nave
	
OpenWithParm( w_fl318_zarpes_anteriores, lstr_param )
end event

on w_fl305_trip_zarpe.create
int iCurrent
call super::create
this.pb_load=create pb_load
this.pb_update=create pb_update
this.pb_modify=create pb_modify
this.pb_new=create pb_new
this.pb_delete=create pb_delete
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_load
this.Control[iCurrent+2]=this.pb_update
this.Control[iCurrent+3]=this.pb_modify
this.Control[iCurrent+4]=this.pb_new
this.Control[iCurrent+5]=this.pb_delete
this.Control[iCurrent+6]=this.dw_master
end on

on w_fl305_trip_zarpe.destroy
call super::destroy
destroy(this.pb_load)
destroy(this.pb_update)
destroy(this.pb_modify)
destroy(this.pb_new)
destroy(this.pb_delete)
destroy(this.dw_master)
end on

event ue_open_pre;str_parametros lstr_parametros

iuo_parte = create uo_parte_pesca

dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

if Message.PowerObjectParm.ClassName() = 'str_parametros' then
	lstr_parametros 	= Message.PowerObjectParm
	is_nro_parte 		= lstr_parametros.string1
	is_aprobado 		= lstr_parametros.string2
else
	MessageBox('Aviso', "Message.PowerObjectParm no es del tipo 'str_parametros'", StopSign!)
	Close(this)
	return
end if

idw_1.Retrieve(is_nro_parte)
idw_1.ii_protect = 0
idw_1.of_protect()

this.Title = "Tripulantes del Zarpe: " + is_nro_parte + " (FL305)"
idw_1.SetFocus()
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 200
end event

event ue_insert;call super::ue_insert;Long  ll_row

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
	lbo_ok = FALSE
   Rollback ;
	messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
END IF

end event

event ue_modify;call super::ue_modify;dw_master.of_protect()
end event

event close;call super::close;destroy iuo_parte
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type pb_load from picturebutton within w_fl305_trip_zarpe
integer x = 1998
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 60
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve!"
string disabledname = "NotFound!"
alignment htextalign = left!
boolean map3dcolors = true
string powertiptext = "Jalar Asistencia de Zarpes Anteriores"
end type

event clicked;parent.event dynamic ue_load()
end event

type pb_update from u_pb_update within w_fl305_trip_zarpe
integer x = 814
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 50
integer textsize = -2
string text = "&G"
string picturename = "h:\SOURCE\BMP\grabar.bmp"
string disabledname = "h:\SOURCE\BMP\grabar_d.bmp"
string powertiptext = "Grabar"
end type

event clicked;call super::clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', 'NO SE PUEDE MODIFICAR LA TRIPULACION CUANDO EL ZARPE YA FUE APROBADO', StopSign!)
	return
end if

PARENT.EVENT Dynamic ue_update()
end event

type pb_modify from u_pb_modify within w_fl305_trip_zarpe
integer x = 654
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 40
integer textsize = -2
string text = "&m"
string picturename = "h:\SOURCE\BMP\modificar.bmp"
string disabledname = "h:\SOURCE\BMP\modificar_d.bmp"
string powertiptext = "Modificar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', 'NO SE PUEDE MODIFICAR LA TRIPULACION CUANDO EL ZARPE YA FUE APROBADO', StopSign!)
	return
end if

PARENT.EVENT Dynamic ue_modify()
end event

type pb_new from u_pb_insert within w_fl305_trip_zarpe
integer x = 334
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 20
integer textsize = -2
string text = "&I"
string picturename = "h:\SOURCE\BMP\nuevo.bmp"
string disabledname = "h:\SOURCE\BMP\nuevo_d.bmp"
string powertiptext = "Insertar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', 'NO SE PUEDE MODIFICAR LA TRIPULACION CUANDO EL ZARPE YA FUE APROBADO', StopSign!)
	return
end if

PARENT.EVENT dynamic ue_insert()
end event

type pb_delete from u_pb_delete within w_fl305_trip_zarpe
integer x = 494
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 30
integer textsize = -2
string text = "&e"
string picturename = "h:\SOURCE\BMP\eliminar.bmp"
string disabledname = "h:\SOURCE\BMP\eliminar_d.bmp"
string powertiptext = "Eliminar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', 'NO SE PUEDE MODIFICAR LA TRIPULACION CUANDO EL ZARPE YA FUE APROBADO', StopSign!)
	return
end if

PARENT.EVENT dynamic ue_delete()
end event

type dw_master from u_dw_abc within w_fl305_trip_zarpe
event ue_dblclick ( string as_columna,  long al_row )
integer width = 2203
integer height = 1256
string dataobject = "d_trip_zarpe_grid"
boolean vscrollbar = true
end type

event ue_dblclick(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql, ls_parte
long ll_count
str_seleccionar lstr_seleccionar

choose case as_columna
		
	case "TRIPULANTE"
		
		ls_sql = "SELECT CODIGO_TRIPULANTE AS COD_TRIP, " &
				 + "NOMB_TRIP AS NOMBRE " &
             + "FROM VW_TRIPULANTES "
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE TRIPULANTES", StopSign!)
			return 
		end if
		
		ls_parte = parent.is_nro_parte
		
		select count(*)
			into :ll_count
		from fl_tripulacion_zarpe
		where parte_pesca = :ls_parte
		  and tripulante = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "TRIPULANTE YA EXISTE", StopSign!)
			return 
		end if

		this.object.nomb_trip[al_row] 	= ls_data		
		this.object.tripulante[al_row] 	= ls_codigo

		//Obtengo el cargo por defecto del tripulante
		ls_codigo = iuo_parte.of_find_cargo_trip( ls_codigo )
		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		this.object.cargo_tripulante[al_row] =	ls_codigo
		this.object.descr_cargo[al_row]      = ls_data

		this.ii_update = 1

	case "CARGO_TRIPULANTE"
		
		ls_sql = "SELECT CARGO_TRIPULANTE AS CODIGO, " &
				 + "DESCR_CARGO AS DESCRIPCION " &
             + "FROM FL_CARGO_TRIPULANTES " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lstr_seleccionar.s_column 	  = '1'
		lstr_seleccionar.s_sql       = ls_sql
		lstr_seleccionar.s_seleccion = 'S'

		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN 
			lstr_seleccionar = message.PowerObjectParm
		END IF	
		IF lstr_seleccionar.s_action = "aceptar" THEN
			ls_codigo = lstr_seleccionar.param1[1]
			ls_data   = lstr_seleccionar.param2[1]
		ELSE		
			Messagebox('Error', "DEBE SELECCIONAR UN CARGO DE TRIPULANTES", StopSign!)
			return 
		end if
		
		this.object.descr_cargo[al_row] 			= ls_data		
		this.object.cargo_tripulante[al_row] 	= ls_codigo
		this.ii_update = 1

end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event doubleclicked;call super::doubleclicked;long ll_row

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()
this.event ue_dblclick(upper(dwo.name), ll_row)
end event

event ue_insert;call super::ue_insert;long ll_row

ll_row = this.GetRow()

if ll_row <= 0 then
	return ll_row
end if

this.object.parte_pesca[ll_row] = parent.is_nro_parte
this.object.cod_usr[ll_row] 	  = gs_user
this.SetColumn(4)
this.SetFocus()

return ll_row
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_tipo, ls_parte
long ll_row, ll_count

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "TRIPULANTE"
		
		ls_codigo = this.object.tripulante[ll_row]

		SetNull(ls_data)
		select nomb_trip
			into :ls_data
		from vw_tripulantes
		where codigo_tripulante = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Error', "CODIGO DE TRIPULANTE NO EXISTE", StopSign!)
			return 1
		end if
		
		ls_parte = parent.is_nro_parte
		
		select count(*)
			into :ll_count
		from fl_tripulacion_zarpe
		where parte_pesca = :ls_parte
		  and tripulante  = :ls_codigo;
		
		if ll_count > 0 then
			Messagebox('Error', "TRIPULANTE YA HA SIDO INGRESADO", StopSign!)
			return 1
		end if
		
		this.object.nomb_trip[ll_row] 		 = ls_data

		//Obtengo el cargo por defecto del tripulante
		ls_codigo = iuo_parte.of_find_cargo_trip( ls_codigo )
		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		this.object.cargo_tripulante[ll_row] =	ls_codigo
		this.object.descr_cargo[ll_row]      = ls_data

	case "CARGO_TRIPULANTE"
		
		ls_codigo = this.object.cargo_tripulante[ll_row]

		ls_data	 = iuo_parte.of_find_desc_cargo( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE CARGO NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.descr_cargo[ll_row] = ls_data

end choose
end event

event itemerror;call super::itemerror;return 1
end event

event keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event ue_dblclick( ls_columna, ll_row )
	end if
end if
return 0
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, false)
this.SelectRow(currentrow, true)
this.SetRow(currentrow)
end event

