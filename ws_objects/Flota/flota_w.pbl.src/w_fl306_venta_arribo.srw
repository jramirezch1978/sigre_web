$PBExportHeader$w_fl306_venta_arribo.srw
forward
global type w_fl306_venta_arribo from w_abc
end type
type pb_update from u_pb_update within w_fl306_venta_arribo
end type
type pb_modify from u_pb_modify within w_fl306_venta_arribo
end type
type pb_new from u_pb_insert within w_fl306_venta_arribo
end type
type pb_delete from u_pb_delete within w_fl306_venta_arribo
end type
type dw_master from u_dw_abc within w_fl306_venta_arribo
end type
end forward

global type w_fl306_venta_arribo from w_abc
integer width = 2226
integer height = 1556
string title = "Venta de Materia Prima (FL305)"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
pb_update pb_update
pb_modify pb_modify
pb_new pb_new
pb_delete pb_delete
dw_master dw_master
end type
global w_fl306_venta_arribo w_fl306_venta_arribo

type variables
string is_nro_parte, is_aprobado
uo_parte_pesca iuo_parte
end variables

on w_fl306_venta_arribo.create
int iCurrent
call super::create
this.pb_update=create pb_update
this.pb_modify=create pb_modify
this.pb_new=create pb_new
this.pb_delete=create pb_delete
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_update
this.Control[iCurrent+2]=this.pb_modify
this.Control[iCurrent+3]=this.pb_new
this.Control[iCurrent+4]=this.pb_delete
this.Control[iCurrent+5]=this.dw_master
end on

on w_fl306_venta_arribo.destroy
call super::destroy
destroy(this.pb_update)
destroy(this.pb_modify)
destroy(this.pb_new)
destroy(this.pb_delete)
destroy(this.dw_master)
end on

event ue_open_pre;str_parametros lstr_parametros

im_1 = CREATE m_rButton      			// crear menu de boton derecho del mouse
dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)

if Message.PowerObjectParm.ClassName() = 'str_parametros' then
	lstr_parametros = Message.PowerObjectParm
	is_nro_parte = lstr_parametros.string1
	is_aprobado  = lstr_parametros.string2
end if

idw_1.Retrieve(is_nro_parte)
idw_1.ii_protect = 0
idw_1.of_protect()

this.Title = "Venta de Materia Prima-> Parte de Pesca: " &
		+ is_nro_parte + " (FL306)"
idw_1.SetFocus()

iuo_parte = CREATE uo_parte_pesca
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

event ue_update_pre;call super::ue_update_pre;Long 		ll_x
string 	ls_cliente, ls_especie, ls_unidad, ls_moneda
decimal	ln_cantidad, ln_precio

ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if


For ll_x = 1 TO idw_1.RowCount()
	//	Validar registro ll_x
	ls_cliente  = idw_1.object.cliente[ll_x]
	ls_especie  = idw_1.object.especie[ll_x]
	ls_unidad   = idw_1.object.unidad[ll_x]
	ls_moneda   = idw_1.object.cod_moneda[ll_x]
	ln_cantidad = dec(idw_1.object.cantidad_real[ll_x])
	ln_precio   = dec(idw_1.object.precio_unitario[ll_x])
	
	IF IsNull(ls_cliente) or ls_cliente = "" THEN
		MessageBox( "ERROR", "CODIGO DE CLIENTE ESTA VACIO", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF IsNull(ls_especie) or ls_especie = "" THEN
		MessageBox( "ERROR", "CODIGO DE ESPECIE ESTA VACIO", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF IsNull(ls_unidad) or ls_unidad = "" THEN
		MessageBox( "ERROR", "CODIGO DE UNIDAD ESTA VACIO", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF IsNull(ls_moneda) or ls_moneda = "" THEN
		MessageBox( "ERROR", "CODIGO DE MONEDA ESTA VACIO", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF IsNull(ln_precio) or ln_precio <= 0 THEN
		MessageBox( "ERROR", "NO TIENE PRECIO", StopSign!  )
		ib_update_check = False
		exit
	END IF

	IF IsNull(ln_cantidad) or ln_cantidad <= 0 THEN
		MessageBox( "ERROR", "NO TIENE CANTIDAD REAL", StopSign!  )
		ib_update_check = False
		exit
	END IF
NEXT

if ib_update_check = false then
	idw_1.ScrollToRow(ll_x)
	idw_1.SelectRow(0, false)
	idw_1.SelectRow(ll_x, true)
end if

dw_master.of_set_flag_replicacion()


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF dw_master.ii_update = 1 THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
	END IF
END IF

end event

type pb_update from u_pb_update within w_fl306_venta_arribo
integer x = 1193
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 50
integer textsize = -2
string text = "&G"
string picturename = "c:\sigre\resources\BMP\grabar.bmp"
string disabledname = "c:\sigre\resources\BMP\grabar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Grabar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', &
		'NO SE PUEDEN HACER MODIFICACIONES, ' &
		+ 'EL ARRIBO ESTA APROBADO', &
		StopSign!)
	return
end if


PARENT.EVENT Dynamic ue_update()
end event

type pb_modify from u_pb_modify within w_fl306_venta_arribo
integer x = 1033
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 40
integer textsize = -2
string text = "&m"
string picturename = "c:\sigre\resources\BMP\modificar.bmp"
string disabledname = "c:\sigre\resources\BMP\modificar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Modificar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', &
		'NO SE PUEDEN HACER MODIFICACIONES, ' &
		+ 'EL ARRIBO ESTA APROBADO', &
		StopSign!)
	return
end if


PARENT.EVENT Dynamic ue_modify()
end event

type pb_new from u_pb_insert within w_fl306_venta_arribo
integer x = 718
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 20
integer textsize = -2
string text = "&I"
string picturename = "c:\sigre\resources\BMP\nuevo.bmp"
string disabledname = "c:\sigre\resources\BMP\nuevo_d.bmp"
boolean map3dcolors = true
string powertiptext = "Insertar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', &
		'NO SE PUEDEN HACER MODIFICACIONES, ' &
		+ 'EL ARRIBO ESTA APROBADO', &
		StopSign!)
	return
end if

PARENT.EVENT ue_insert()
end event

type pb_delete from u_pb_delete within w_fl306_venta_arribo
integer x = 878
integer y = 1284
integer width = 155
integer height = 132
integer taborder = 30
integer textsize = -2
string text = "&e"
string picturename = "c:\sigre\resources\BMP\eliminar.bmp"
string disabledname = "c:\sigre\resources\BMP\eliminar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Eliminar"
end type

event clicked;if parent.is_aprobado = '1' then
	MessageBox('ERROR', &
		'NO SE PUEDEN HACER MODIFICACIONES, ' &
		+ 'EL ARRIBO ESTA APROBADO', &
		StopSign!)
	return
end if


PARENT.EVENT ue_delete()
end event

type dw_master from u_dw_abc within w_fl306_venta_arribo
event ue_dblclick ( string as_columna,  long al_row )
event type integer ue_ver_arribo ( )
integer width = 2203
integer height = 1256
string dataobject = "d_venta_arribo_grid"
end type

event ue_dblclick(string as_columna, long al_row);string ls_codigo, ls_data, ls_sql, ls_parte
long ll_count
str_seleccionar lstr_seleccionar

choose case as_columna

	case "CLIENTE"
		
		ls_sql = "SELECT CLIENTE AS CODIGO, " &
				 + "NOM_PROVEEDOR AS PROVEEDOR " &
             + "FROM vW_FL_NOMB_CLIENTE" 
				 
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
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE CLIENTE", StopSign!)
			return 
		end if
		
		this.object.nom_proveedor[al_row] 	= ls_data		
		this.object.cliente[al_row] 			= ls_codigo
		this.ii_update = 1

	case "ESPECIE"
		
		ls_sql = "SELECT ESPECIE AS CODIGO, " &
				 + "DESCR_ESPECIE AS DESCRIPCION " &
             + "FROM TG_ESPECIES " 
				 
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
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE ESPECIE", StopSign!)
			return 
		end if
		
		this.object.descr_especie[al_row] 	= ls_data		
		this.object.especie[al_row] 			= ls_codigo
		this.ii_update = 1

	case "UNIDAD"
		
		ls_sql = "SELECT UND AS CODIGO, " &
				 + "DESC_UNIDAD AS DESCRIPCION " &
             + "FROM UNIDAD "
				 
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
			Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE UNIDAD", StopSign!)
			return 
		end if
		
		this.object.desc_unidad[al_row] 	= ls_data		
		this.object.unidad[al_row] 		= ls_codigo
		this.ii_update = 1

	case "COD_MONEDA"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				 + "DESCRIPCION AS NOMBRE_MONEDA " &
             + "FROM MONEDA "
				 
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
			Messagebox('Error', "DEBE SELECCIONAR UN TIPO DE MONEDA", StopSign!)
			return 
		end if
		
		this.object.desc_moneda[al_row] 	= ls_data		
		this.object.cod_moneda[al_row] 	= ls_codigo
		this.ii_update = 1

end choose
end event

event type integer ue_ver_arribo();/*
	Esta funcion valida el total capturado y vendido en cada 
	arribo no supere la capacidad de bodega de la nave
	tambien verifica que no sobrepase la capacidad permitida
	de bodega
*/
long 		ll_row
decimal{4} 	ln_cap, ln_real, ln_cast, ln_CapBod, ln_CapPerBod, ln_dcl
string 	ls_nave
date 		ld_fecha

select nave_real, trunc(fecha_hora_arribo)
	into :ls_nave, :ld_fecha
from fl_parte_de_pesca
where parte_pesca = :is_nro_parte;

select nvl(capac_bodega,0), nvl(capac_permitida,0)
	into :ln_CapBod, :ln_CapPerBod
from tg_naves	
where nave = :ls_nave;

ln_cap = 0
ln_dcl = 0
for ll_row = 1 to this.RowCount()
	ln_real 	= dec(this.object.cantidad_real[ll_row])
	ln_cast 	= dec(this.object.cantidad_castigada[ll_row])
	ln_dcl	+= dec(this.object.cantidad_declarada[ll_row])
	ln_cap 	= ln_cap + (ln_real - ln_cast)
next

if ln_cap > ln_CapBod and ln_CapBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD VENDIDA HA SOBREPASADO LA CAPACIDAD DE BODEGA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		return 1
	end if
end if

if ln_dcl > ln_CapPerBod and ln_CapPerBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD DECLARADA HA SOBREPASADO LA CAPACIDAD DE BODEGA PERMITIDA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		
		return 1
	end if
end if

if ln_cap > ln_CapPerBod and ln_CapPerBod <> 0 then
	if MessageBox('FLOTA', 'EN ESTE ARRIBO LA CANTIDAD VENDIDA HA SOBREPASADO LA CAPACIDAD DE BODEGA PERMITIDA DE LA NAVE' & 
				+ '~r~nCapacidad de Bodega: ' + string(ln_CapBod) &
				+ '~r~nCapacidad Permitida: ' + string(ln_CapPerBod) &
				+ '~r~nPesca Vendidad: ' + string(ln_cap) &
				+ '~r~nDESEA CONTINUAR INGRESANDO DATOS? ', &
				Information!, YesNo!, 1) = 2 then
		return 1
	end if
end if

return 0
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

event itemchanged;call super::itemchanged;string 		ls_codigo, ls_data, ls_tipo, ls_parte
long 			ll_count
decimal{4} 	ln_estim, ln_real, ln_cast, ln_dcl

this.AcceptText()
choose case upper(dwo.name)
	case "CLIENTE"
		
		ls_codigo = this.object.cliente[row]
		ls_data = iuo_parte.of_get_nomb_cliente( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE CLIENTE NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.nomb_trip[row] = ls_data

	case "ESPECIE"
		
		ls_codigo = this.object.especie[row]
		ls_data = iuo_parte.of_get_nomb_especie( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE ESPECIE NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.descr_especie[row] = ls_data

	case "UNIDAD"
		
		ls_codigo = this.object.unidad[row]
		ls_data 	 = iuo_parte.of_get_descr_unidad( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE UNIDAD NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.desc_unidad[row] = ls_data

	case "COD_MONEDA"
		
		ls_codigo = this.object.cod_moneda[row]
		ls_data 	 = iuo_parte.of_get_descr_moneda( ls_codigo )
		
		if ls_data = "" then
			Messagebox('Error', "CODIGO DE MONEDA NO EXISTE", StopSign!)
			return 1
		end if
		
		this.object.desc_moneda[row] = ls_data

	CASE 'CANTIDAD_ESTIMADA'
		
		ln_estim = dec(this.object.cantidad_estimada	[row])
		ln_real 	= dec(this.object.cantidad_real		[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		if ln_real = 0 then
			this.object.cantidad_real[row] = ln_estim
			ln_real = ln_estim
		end if
		if ln_dcl = 0 then
			this.object.cantidad_declarada[row] = ln_real - ln_cast
		end if

	CASE 'CANTIDAD_REAL'
		
		ln_real 	= dec(this.object.cantidad_real[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		this.object.cantidad_declarada[row] = ln_real - ln_cast
		
		this.event dynamic ue_ver_arribo( )
		
	CASE 'CANTIDAD_CASTIGADA'
		
		ln_real 	= dec(this.object.cantidad_real[row])
		ln_cast 	= dec(this.object.cantidad_castigada[row])
		ln_dcl	= dec(this.object.cantidad_declarada[row])
		
		this.object.cantidad_declarada[row] = ln_real - ln_cast

		this.event dynamic ue_ver_arribo( )

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

event ue_insert_pre;call super::ue_insert_pre;datetime ld_fecha, ldt_parte
string ls_unidad, ls_moneda, ls_parte

if al_row <= 0 then
	return
end if

ls_parte = parent.is_nro_parte

select fecha_hora_arribo
	into :ldt_parte
from fl_parte_de_pesca
where parte_pesca = :ls_parte;

ld_fecha = DateTime( Date(ldt_parte), Now())

this.object.parte_pesca[al_row] = parent.is_nro_parte
this.object.hora_inicio_descarga[al_row] = ld_fecha
this.object.hora_fin_descarga[al_row] = ld_fecha
this.object.cod_usr[al_row] 	  = gs_user
this.object.cantidad_real[al_row] 		= 0.00
this.object.cantidad_estimada[al_row] 	= 0.00
this.object.cantidad_castigada[al_row] = 0.00	
this.object.cantidad_declarada[al_row] = 0.00	

if al_row > 1 then
	ls_unidad = this.object.unidad[al_row - 1 ]
	ls_moneda = this.object.cod_moneda[al_row - 1 ]
	
	this.object.unidad[al_row] = ls_unidad
	this.object.desc_unidad[al_row] = iuo_parte.of_get_descr_unidad( ls_unidad )
	this.object.cod_moneda[al_row] = ls_moneda
	this.object.desc_moneda[al_row] = iuo_parte.of_get_descr_moneda( ls_moneda )
end if

this.SetColumn(2)
this.SetFocus()

return
end event

