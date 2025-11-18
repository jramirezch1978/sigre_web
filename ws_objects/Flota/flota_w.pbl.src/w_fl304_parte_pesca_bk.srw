$PBExportHeader$w_fl304_parte_pesca_bk.srw
forward
global type w_fl304_parte_pesca_bk from w_abc
end type
type cb_bitacora from commandbutton within w_fl304_parte_pesca_bk
end type
type cb_parte from commandbutton within w_fl304_parte_pesca_bk
end type
type cb_narribo from commandbutton within w_fl304_parte_pesca_bk
end type
type cb_nzarpe from commandbutton within w_fl304_parte_pesca_bk
end type
type pb_update from u_pb_update within w_fl304_parte_pesca_bk
end type
type pb_modify from u_pb_modify within w_fl304_parte_pesca_bk
end type
type pb_delete from u_pb_delete within w_fl304_parte_pesca_bk
end type
type dw_master from u_dw_abc within w_fl304_parte_pesca_bk
end type
type cb_marribo from commandbutton within w_fl304_parte_pesca_bk
end type
type cb_bzarpe from commandbutton within w_fl304_parte_pesca_bk
end type
end forward

global type w_fl304_parte_pesca_bk from w_abc
integer width = 2327
integer height = 1860
string title = "Partes de Pesca (FL304)"
string menuname = "m_smpl"
boolean maxbox = false
boolean resizable = false
event ue_save_zarpe ( )
event ue_save_arribo ( )
event ue_act_control ( boolean ab_estado )
event ue_arribo ( string as_parte )
event ue_zarpe ( string as_parte )
cb_bitacora cb_bitacora
cb_parte cb_parte
cb_narribo cb_narribo
cb_nzarpe cb_nzarpe
pb_update pb_update
pb_modify pb_modify
pb_delete pb_delete
dw_master dw_master
cb_marribo cb_marribo
cb_bzarpe cb_bzarpe
end type
global w_fl304_parte_pesca_bk w_fl304_parte_pesca_bk

type variables
string is_tipo_pp
integer ii_new, ii_update
uo_parte_pesca iuo_parte
end variables

forward prototypes
public subroutine of_enabled_buttton (boolean ab_estado)
end prototypes

event ue_save_zarpe();string 	ls_nave, ls_puerto, ls_situac, ls_zona, ls_registro
string 	ls_nro_parte, ls_unidad, ls_origen, ls_aprobado
string 	ls_user, ls_mensaje, ls_observ
integer  li_tiempo
long 	 	ll_row
datetime ld_fecha1, ld_fecha2
boolean  lb_ok


ll_row = dw_master.GetRow()
if ll_row <= 0 then
	return
end if

if idw_1.ii_update <> 1 then
	MessageBox('Aviso', 'NO HAY CAMBIOS QUE GRABAR', Information!)
	return
end if

// Saco todos los datos que necesito
ls_nave 		= idw_1.object.nave_real[ll_row]
ls_puerto 	= idw_1.object.puerto_zarpe[ll_row]
ls_situac  	= idw_1.object.situac_zarpe[ll_row]
ls_zona		= idw_1.object.zona_pesca_zarpe[ll_row]
ls_registro = idw_1.object.registro_zarpe[ll_row]
ls_unidad   = idw_1.object.unidad_operacion[ll_row]
ls_origen	= idw_1.object.origen[ll_row]
ls_user		= idw_1.object.usr_aprob_datos[ll_row]
ls_observ	= idw_1.object.observ_zarpe[ll_row]
ls_nro_parte= idw_1.object.parte_pesca[ll_row]
li_tiempo	= integer(idw_1.object.tiempo_est_oper[ll_row])
ld_fecha1	= DateTime(idw_1.object.fecha_hora_zarpe[ll_row])
ld_fecha2	= DateTime(idw_1.object.fecha_hora_est_arribo[ll_row])

lb_ok = iuo_parte.of_save_zarpe( ls_nave, ls_puerto, &
		  ls_zona, ls_situac, ls_registro, ls_unidad, &
		  ls_origen, ls_aprobado, ls_user, ls_observ, &
		  li_tiempo, ld_fecha1, ld_fecha2, ls_nro_parte, &
		  ii_new )
	
if lb_ok then
	if ii_new = 1 then
		idw_1.object.parte_pesca[ll_row] = iuo_parte.of_get_nro_parte()
		MessageBox('Error', 'PARTE DE PESCA GENERADO: ' &
						+ iuo_parte.of_get_nro_parte() )
	end if
	ii_new = 0
	idw_1.ii_update = 0
end if



end event

event ue_save_arribo();string 	ls_naver, ls_puerto, ls_situac, ls_zona 
string   ls_registro, ls_parte, ls_origen
string   ls_aprobado, ls_mensaje, ls_observ
string 	ls_naved, ls_regpos, ls_tpesca, ls_orden
long 	 	ll_row
datetime ld_fecha
boolean  lb_ok


ll_row = dw_master.GetRow()
if ll_row <= 0 then
	return
end if

if idw_1.ii_update <> 1 then
	MessageBox('Aviso', 'NO HAY CAMBIOS QUE GRABAR', Information!)
	return
end if

ls_aprobado = idw_1.object.arribo_aprobado[ll_row]
// Si esta aprobado no debo guardarlo
if ls_aprobado = '1' then
	MessageBox('Aviso', 'NO SE PUEDE GRABAR UN ARRIBO QUE YA HA SIDO APROBADO', Information!)
	return
end if

// Saco todos los datos que necesito
ls_parte		= idw_1.object.parte_pesca[ll_row]
ls_origen	= idw_1.object.origen[ll_row]
ls_orden		= idw_1.object.nro_orden[ll_row]
ls_registro = idw_1.object.registro_arribo[ll_row]
ls_naver		= idw_1.object.nave_real[ll_row]
ls_naved		= idw_1.object.nave_declarada[ll_row]
ls_puerto 	= idw_1.object.puerto_arribo[ll_row]
ls_zona		= idw_1.object.zona_pesca_arribo[ll_row]
ls_situac  	= idw_1.object.situac_arribo[ll_row]
ls_observ	= idw_1.object.observ_arribo[ll_row]
ls_regpos	= idw_1.object.reg_pos_arrib[ll_row]
ls_tpesca   = idw_1.object.flag_tipo_pesca[ll_row]
ld_fecha		= DateTime(idw_1.object.fecha_hora_arribo[ll_row])


lb_ok = iuo_parte.of_save_arribo( ls_parte, ls_origen,&
		  ls_registro, ls_naver, ls_naved, ls_puerto, &
		  ls_zona, ls_situac, ls_observ, ls_regpos, &
		  ls_tpesca, ls_orden, ls_aprobado, ld_fecha, ii_new )
	
if lb_ok then
	if ii_new = 1 and iuo_parte.of_get_tipo_flota( ) <> 'P' then
		idw_1.object.parte_pesca[ll_row] = iuo_parte.of_get_nro_parte()
		MessageBox('Error', 'PARTE DE PESCA GENERADO: ' &
						+ iuo_parte.of_get_nro_parte() )
	end if
	ii_new = 0
	idw_1.ii_update = 0
end if



end event

event ue_act_control(boolean ab_estado);string ls_data

SetNull(ls_data)
if is_tipo_pp= "arribo" then
	
	idw_1.object.nro_orden.visible 			= ab_estado
	idw_1.object.nro_orden_t.visible 		= ab_estado
	idw_1.object.registro_arribo.visible	= ab_estado
	idw_1.object.registro_arribo_t.visible	= ab_estado
	idw_1.object.descripcion_ot.visible 	= ab_estado
	if ab_estado = false then
		idw_1.object.nro_orden[1]		 			= ls_data
		idw_1.object.registro_arribo[1]			= ls_data
	end if
end if

end event

event ue_arribo(string as_parte);string ls_nave, ls_registro

dw_master.DataObject = "d_arribo_ff"
dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(as_parte)
dw_master.ii_update = 0
ii_new = 0
is_tipo_pp = "arribo"

if dw_master.GetRow() > 0 then
	
	ls_nave     = trim( dw_master.object.nave_real[1] )
	
	if iuo_parte.of_get_tipo_flota( ls_nave ) = 'T' then
		this.event ue_act_control(false)
	else
		this.event ue_act_control(true)
	end if
	this.of_enabled_buttton(true)
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	ls_registro = trim( dw_master.object.registro_arribo[1] )
	iuo_parte.of_set_cod_nave( ls_nave )
	iuo_parte.of_set_reg_arribo( ls_registro )
else	
	MessageBox('ERROR', "NO SE HAN REGISTRADO DATOS DE ARRIBO", StopSign!)	
end if
end event

event ue_zarpe(string as_parte);string ls_nave, ls_registro

dw_master.DataObject = "d_zarpe_ff"
dw_master.SetTransObject(SQLCA)
dw_master.Retrieve(as_parte)
dw_master.ii_update = 0
ii_new = 0
is_tipo_pp = "zarpe"

if dw_master.GetRow() > 0 then
	this.of_enabled_buttton(true)
	dw_master.ii_protect = 0
	dw_master.of_protect()
	ls_nave     = trim( dw_master.object.nave_real[1] )
	ls_registro = trim( dw_master.object.registro_zarpe[1] )
	iuo_parte.of_set_cod_nave( ls_nave )
	iuo_parte.of_set_reg_zarpe( ls_registro )
else
	MessageBox('ERROR', "NO SE HAN REGISTRADO DATOS DE ZARPE", StopSign!)
end if

end event

public subroutine of_enabled_buttton (boolean ab_estado);pb_modify.enabled = ab_estado
pb_update.enabled = ab_estado
pb_delete.enabled = ab_estado
end subroutine

on w_fl304_parte_pesca_bk.create
int iCurrent
call super::create
if this.MenuName = "m_smpl" then this.MenuID = create m_smpl
this.cb_bitacora=create cb_bitacora
this.cb_parte=create cb_parte
this.cb_narribo=create cb_narribo
this.cb_nzarpe=create cb_nzarpe
this.pb_update=create pb_update
this.pb_modify=create pb_modify
this.pb_delete=create pb_delete
this.dw_master=create dw_master
this.cb_marribo=create cb_marribo
this.cb_bzarpe=create cb_bzarpe
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_bitacora
this.Control[iCurrent+2]=this.cb_parte
this.Control[iCurrent+3]=this.cb_narribo
this.Control[iCurrent+4]=this.cb_nzarpe
this.Control[iCurrent+5]=this.pb_update
this.Control[iCurrent+6]=this.pb_modify
this.Control[iCurrent+7]=this.pb_delete
this.Control[iCurrent+8]=this.dw_master
this.Control[iCurrent+9]=this.cb_marribo
this.Control[iCurrent+10]=this.cb_bzarpe
end on

on w_fl304_parte_pesca_bk.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_bitacora)
destroy(this.cb_parte)
destroy(this.cb_narribo)
destroy(this.cb_nzarpe)
destroy(this.pb_update)
destroy(this.pb_modify)
destroy(this.pb_delete)
destroy(this.dw_master)
destroy(this.cb_marribo)
destroy(this.cb_bzarpe)
end on

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_master              				// asignar dw corriente
iuo_parte = create uo_parte_pesca
ii_pregunta_delete = 1   				// 1 = si pregunta, 0 = no pregunta (default)
end event

event resize;call super::resize;dw_master.width  = newwidth  - dw_master.x - 10
end event

event ue_insert;call super::ue_insert;Long  ll_row
datetime ld_fecha
string ls_unidad, ls_desc_unidad

ll_row = idw_1.Event ue_insert()
idw_1.ib_insert_mode = false
idw_1.ii_update = 0

if ll_row <= 0 then
	return
end if

idw_1.object.origen[ll_row] 					= gs_origen
ld_fecha = DateTime(Today(), Now())
if is_tipo_pp= "zarpe" then
	
	// Datos por defecto si es un zarpe
	
	ls_unidad = "HRS"

	ls_desc_unidad = f_desc_unidad(ls_unidad)

	idw_1.object.fecha_hora_zarpe[ll_row] 		= ld_fecha
	idw_1.object.fecha_hora_est_arribo[ll_row]= ld_fecha
	idw_1.object.zarpe_aprobado[ll_row] 		= '0'
	idw_1.object.desc_unidad[ll_row] 			= ls_desc_unidad
	idw_1.object.unidad_operacion[ll_row] 		= ls_unidad
	idw_1.object.usr_aprob_datos[ll_row]		= gs_user
	
else
	
	// Datos por defecto si es un arribo
	
	idw_1.object.nave_real[ll_row]				= iuo_parte.of_get_cod_nave()
	idw_1.object.nave_declarada[ll_row]			= iuo_parte.of_get_cod_nave()
	idw_1.object.nomb_real[ll_row]				= iuo_parte.of_get_nomb_nave()
	idw_1.object.nomb_declarada[ll_row]			= iuo_parte.of_get_nomb_nave()
	idw_1.object.fecha_hora_arribo[ll_row] 	= ld_fecha
	idw_1.object.flag_tipo_pesca[ll_row] 		= '1' //Industrial
	idw_1.object.arribo_aprobado[ll_row]		= '0'
	
	if iuo_parte.of_get_tipo_flota() = 'P' then
		iuo_parte.of_find_datos_zarpe()
		idw_1.object.parte_pesca[ll_row]			= iuo_parte.of_get_nro_parte()

		// Por defecto el puerto de arribo es el mismo que el zarpe
		idw_1.object.puerto_arribo[ll_row]		= iuo_parte.of_get_cod_pto()
		idw_1.object.descr_puerto[ll_row]		= iuo_parte.of_get_nomb_pto()
		
		// Por defecto la zona de pesca del arribo es la misma que el zarpe
		idw_1.object.zona_pesca_arribo[ll_row]	= iuo_parte.of_get_cod_zona()
		idw_1.object.descr_zona[ll_row]			= iuo_parte.of_get_descr_zona()
		idw_1.object.nave_real.protect 			= '1'
	else
		this.event ue_act_control(false)
		idw_1.object.nave_real.protect 			= '0'
	end if
	
	idw_1.ii_update = 1

end if

idw_1.SetColumn(3)
idw_1.SetFocus()

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_1.AcceptText()
ib_update_check = TRUE

THIS.EVENT ue_update_pre()



end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

If is_tipo_pp = "zarpe" then
	this.event ue_save_zarpe()
elseif is_tipo_pp = "arribo" then
	this.event ue_save_arribo()
end if


end event

event close;call super::close;destroy iuo_parte
end event

event ue_modify;call super::ue_modify;long   ll_row
string ls_aprobado, ls_nave, ls_flota
ll_row = idw_1.GetRow()

if ll_row <= 0 then
	return
end if

if is_tipo_pp = "zarpe" then
	ls_aprobado = trim( idw_1.object.zarpe_aprobado[ll_row] )
else 
	ls_aprobado = trim( idw_1.object.arribo_aprobado[ll_row] )
	ls_nave		= trim( idw_1.object.nave_real[ll_row] )
	ls_flota		= iuo_parte.of_get_tipo_flota( ls_nave )
end if

if ls_aprobado = '1' then
	MessageBox('Error', 'NO SE PUEDE MODIFICAR UN REGISTRO YA APROBADO', StopSign!)
	idw_1.ii_protect = 0
	idw_1.of_Protect()
else
	idw_1.of_protect()
end if

if is_tipo_pp = "arribo" and ls_flota = 'P' then
	idw_1.object.nave_real.protect = '1'
end if

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

event ue_delete;Long  ll_row
string ls_aprobado, ls_nro_parte
ll_row = idw_1.GetRow()

if ll_row <= 0 then
	return
end if

if is_tipo_pp = "zarpe" then
	ls_aprobado = trim( idw_1.object.zarpe_aprobado[ll_row] )
else 
	ls_aprobado = trim( idw_1.object.arribo_aprobado[ll_row] )
end if

if ls_aprobado = '1' then
	MessageBox('Error', 'NO SE PUEDE ELIMINAR UN REGISTRO APROBADO', StopSign!)
	return
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ls_nro_parte = trim( idw_1.object.parte_pesca[ll_row] )

if is_tipo_pp = "zarpe" then
	if iuo_parte.of_delete_zarpe( ls_nro_parte ) then
		idw_1.Reset()
		idw_1.ii_update = 0
		ii_new = 0
	end if
else
	if iuo_parte.of_delete_arribo( ls_nro_parte ) then
		idw_1.Reset()
		idw_1.ii_update = 0
		ii_new = 0
	end if
end if
end event

type cb_bitacora from commandbutton within w_fl304_parte_pesca_bk
integer x = 1495
integer y = 24
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Bitácora"
end type

event clicked;string ls_parte, ls_nave
long ll_row
str_parametros lstr_param

ll_row = dw_master.GetRow()

if ll_row <= 0 then
	if MessageBox('FLOTA', 'NO HA SELECCIONADO NINGUN PARTE DE PESCA.' &
		+ '~r~nDESEA INGRESAR DE TODAS MANERAS UNA BITACORA?', &
		Information!, YesNo!, 2) = 1 then
		
		SetNull(ls_parte)
		SetNull(ls_nave)
	else
		return
	end if
else
	ls_nave = dw_master.object.nave_real[ll_row]
	ls_parte = dw_master.object.parte_pesca[ll_row]
	
	if IsNull(ls_parte) or trim(ls_parte) = '' then
		MessageBox('AViso', 'No ha definido parte de pesca, por favor Verifique')
		return
	end if
	
	if IsNull(ls_nave) or trim(ls_nave) = '' then
		MessageBox('AViso', 'No ha definido Codigo de Nave, por favor Verifique')
		return
	end if
	
end if

lstr_param.string1 = ls_parte
lstr_param.string2 = ls_nave

OpenSheetWithParm(w_fl310_bitacora, lstr_param, w_main, 0, Layered!)
end event

type cb_parte from commandbutton within w_fl304_parte_pesca_bk
integer x = 1147
integer y = 24
integer width = 343
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_parte
str_buscar lstr_buscar
parent.event ue_update_request()

Open(w_fl502_buscar_parte)

lstr_buscar = Message.PowerObjectParm

if Not IsValid(lstr_buscar) or IsNull(lstr_buscar) then
	return
end if

ls_parte = lstr_buscar.ls_parte
if ls_parte = "" then
	MessageBox("Error", "DEBE ELEGIR UN PARTE DE PESCA", StopSign!)
	return
end if


if lstr_buscar.ls_tipo_pp = "arribo" then
	parent.event ue_arribo(ls_parte)
else
	parent.event ue_zarpe(ls_parte)
end if

end event

type cb_narribo from commandbutton within w_fl304_parte_pesca_bk
integer x = 800
integer y = 24
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Arribo"
end type

event clicked;string ls_codigo, ls_data, ls_sql, ls_tipo_flota
string ls_parte
long   ll_row, ll_count
str_seleccionar lstr_seleccionar

parent.event ue_update_request()

dw_master.Reset()

ls_sql = "SELECT NAVE AS CODIGO, " &
		 + "NOMB_NAVE AS DESCRIPCION, " &
		 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
       + "FROM vw_fl_naves_arribo "
				 
lstr_seleccionar.s_column 	  = '1'
lstr_seleccionar.s_sql       = ls_sql
lstr_seleccionar.s_seleccion = 'S'

OpenWithParm(w_seleccionar,lstr_seleccionar)
		
IF isvalid(message.PowerObjectParm) THEN 
	lstr_seleccionar = message.PowerObjectParm
END IF	

IF lstr_seleccionar.s_action = "aceptar" THEN
	ls_codigo 	  = lstr_seleccionar.param1[1]
	ls_data   	  = lstr_seleccionar.param2[1]
	ls_tipo_flota = lstr_seleccionar.param3[1]
ELSE		
	Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
	return 1
end if

if ls_tipo_flota = 'P' then
	ls_parte = iuo_parte.of_find_zarpe_nave( ls_codigo )
	if ls_parte = '' then 
		MessageBox('Error', "NO PUEDES REGISTRAR EL ARRIBO " &
			+ "DE UNA EMBARCACIÓN PROPIA SIN TENER UN ZARPE ", &
			+ StopSign!)
		return
	else
		iuo_parte.of_set_nro_parte ( ls_parte )
	end if
	parent.event ue_act_control(true)
else
	parent.event ue_act_control(false)
end if

iuo_parte.of_set_nomb_nave( ls_data )
iuo_parte.of_set_cod_nave( ls_codigo )
iuo_parte.of_set_tipo_flota( ls_tipo_flota )
iuo_parte.of_set_reg_arribo( '' )

dw_master.DataObject = "d_arribo_ff"
dw_master.SetTransObject(sqlca)
dw_master.ii_update = 1

parent.is_tipo_pp = "arribo"
parent.event ue_insert()
parent.of_enabled_buttton(true)
ib_update_check = TRUE
ii_new = 1



end event

type cb_nzarpe from commandbutton within w_fl304_parte_pesca_bk
integer x = 453
integer y = 24
integer width = 343
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Zarpe"
end type

event clicked;parent.event ue_update_request()

dw_master.Reset()
dw_master.DataObject = "d_zarpe_ff"
dw_master.SetTransObject(sqlca)
dw_master.ii_update = 0


parent.is_tipo_pp = "zarpe"
parent.event ue_insert()
parent.of_enabled_buttton(true)
parent.ii_new = 1
end event

type pb_update from u_pb_update within w_fl304_parte_pesca_bk
integer x = 978
integer y = 1484
integer width = 155
integer height = 132
integer taborder = 70
integer textsize = -2
boolean enabled = false
string text = "&G"
string picturename = "c:\sigre\resources\BMP\grabar.bmp"
string disabledname = "c:\sigre\resources\BMP\grabar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Grabar"
end type

type pb_modify from u_pb_modify within w_fl304_parte_pesca_bk
integer x = 1134
integer y = 1484
integer width = 155
integer height = 132
integer taborder = 80
integer textsize = -2
boolean enabled = false
string text = "&m"
string picturename = "c:\sigre\resources\BMP\modificar.bmp"
string disabledname = "c:\sigre\resources\BMP\modificar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Modificar"
end type

type pb_delete from u_pb_delete within w_fl304_parte_pesca_bk
integer x = 823
integer y = 1484
integer width = 155
integer height = 132
integer taborder = 60
integer textsize = -2
boolean enabled = false
string text = "&e"
string picturename = "c:\sigre\resources\BMP\eliminar.bmp"
string disabledname = "c:\sigre\resources\BMP\eliminar_d.bmp"
boolean map3dcolors = true
string powertiptext = "Eliminar"
end type

event clicked;PARENT.EVENT ue_delete()
end event

type dw_master from u_dw_abc within w_fl304_parte_pesca_bk
event type integer ue_dblclick ( string as_columna,  long al_row,  string as_tipo_pp )
integer y = 144
integer width = 2258
integer height = 1320
integer taborder = 50
boolean border = false
borderstyle borderstyle = stylebox!
end type

event type integer ue_dblclick(string as_columna, long al_row, string as_tipo_pp);string ls_codigo, ls_data, ls_sql, ls_cencos
string ls_nave, ls_tipo_flota, ls_parte
long ll_count
str_seleccionar lstr_seleccionar

If as_tipo_pp = "zarpe" then
	choose case as_columna
		
		case "NAVE_REAL"
		
			ls_sql = "SELECT NAVE AS CODIGO, " &
					 + "NOMB_NAVE AS EMBARCACION " &
					 + "FROM vw_fl_naves_zarpe " 
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
				return -1
			end if
			
			this.object.nomb_nave[al_row] = ls_data		
			this.object.nave_real[al_row] = ls_codigo
			
			this.ii_update = 1
		
		case "PUERTO_ZARPE"
		
			ls_sql = "SELECT PUERTO AS CODIGO, " &
					 + "DESCR_PUERTO AS DESCRIPCION " &
					 + "FROM FL_PUERTOS " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UN PUERTO", StopSign!)
				return -1
			end if
			
			this.object.descr_puerto[al_row] = ls_data		
			this.object.puerto_zarpe[al_row] = ls_codigo
			
			this.ii_update = 1

		case "SITUAC_ZARPE"
		
			ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO, " &
					 + "DESCR_SITUACION AS DESCRIPCION " &
					 + "FROM FL_MOTIVO_MOVIMIENTO " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UNA SITUACION DE ZARPE", StopSign!)
				return -1
			end if
			
			this.object.descr_situacion[al_row] = ls_data		
			this.object.situac_zarpe[al_row] 	= ls_codigo
			
			this.ii_update = 1

		case "ZONA_PESCA_ZARPE"
		
			ls_sql = "SELECT ZONA_PESCA AS CODIGO, " &
					 + "DESCR_ZONA AS DESCRIPCION " &
					 + "FROM TG_ZONAS_PESCA " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UNA ZONA DE PESCA", StopSign!)
				return -1
			end if
			
			this.object.descr_zona[al_row] 		 = ls_data		
			this.object.zona_pesca_zarpe[al_row] = ls_codigo
			
			this.ii_update = 1

	end choose
else

	choose case as_columna
		
		case "NRO_ORDEN"
			
			ls_nave   = trim( this.object.nave_real[al_row] )
			if ls_nave = "" then
				MessageBox('ERROR', 'DEBES TENER PRIMERO UN CODIGO DE NAVE', StopSign!)
				return -1
			end if
			
			if iuo_parte.of_get_tipo_flota( ls_nave ) <> 'P' then
				MessageBox('ERROR', 'LA ORDEN DE TRABAJO SOLO SE ASIGNA A UNA EMBARCACION PROPIA', StopSign!)
				return -1
			end if
			
			ls_cencos = iuo_parte.of_get_cencos_nave( ls_nave )
			
			if ls_cencos = "" then
				MessageBox('ERROR', 'LA NAVE PROPIA DEBE TENER ASIGNADO UN CENTRO DE COSTOS', StopSign!)
				return -1
			end if
			
			ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
					 + "FEC_ESTIMADA AS FECHA_ESTIMADA, " &
					 + "DESCRIPCION AS DESCR_ORDEN " &
					 + "FROM VW_FL_OT_NAVE " &
					 + "WHERE NAVE = '" + ls_nave + "'"
					 
			lstr_seleccionar.s_column 	  = '1'
			lstr_seleccionar.s_sql       = ls_sql
			lstr_seleccionar.s_seleccion = 'S'
	
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN 
				lstr_seleccionar = message.PowerObjectParm
			END IF	
			IF lstr_seleccionar.s_action = "aceptar" THEN
				ls_codigo = lstr_seleccionar.param1[1]
				ls_data   = lstr_seleccionar.param3[1]
			ELSE		
				Messagebox('Error', "DEBE SELECCIONAR UNA ORDEN DE TRABAJO", StopSign!)
				return -1
			end if
			
			this.object.descripcion_ot[al_row]  = ls_data		
			this.object.nro_orden[al_row] 		= ls_codigo
			
			this.ii_update = 1

		case "REG_POS_ARRIB"
			
			ls_nave = this.object.nave_real[al_row]
			
			ls_sql = "SELECT REG_POS_ARRIB AS CODIGO, " &
			 		 + "NAVE AS CODIGO_NAVE, " &
					 + "NOMB_NAVE AS EMBARCACION, " &
					 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA, " &
					 + "FECHA_HORA_REG AS FECHA_REGISTRO, " &
					 + "FECHA_HORA_ARRIBO AS FECHA_ARRIBO " &
					 + "FROM VW_FL_POS_ARRIB " &
					 + "WHERE NAVE = '" + ls_nave + "'"
					 
			lstr_seleccionar.s_column 	  = '2'
			lstr_seleccionar.s_sql       = ls_sql
			lstr_seleccionar.s_seleccion = 'S'
	
			OpenWithParm(w_seleccionar,lstr_seleccionar)
			
			IF isvalid(message.PowerObjectParm) THEN 
				lstr_seleccionar = message.PowerObjectParm
			END IF	
			IF lstr_seleccionar.s_action = "aceptar" THEN
				ls_codigo 		= lstr_seleccionar.param1[1]
				ls_nave   		= lstr_seleccionar.param2[1]
				ls_data   		= lstr_seleccionar.param3[1]
			ELSE		
				Messagebox('Error', "DEBE SELECCIONAR UN REGISTRO DE POSIBLE ARRIBO", StopSign!)
				return -1
			end if
			
			this.object.reg_pos_arrib[al_row]   = ls_codigo
			this.ii_update = 1

		case "NAVE_DECLARADA"
		
			ls_sql = "SELECT NAVE AS CODIGO, " &
					 + "NOMB_NAVE AS EMBARCACION, " &
					 + "FLAG_TIPO_FLOTA AS TIPO_FLOTA " &
					 + "FROM TG_NAVES "
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UN CODIGO DE NAVE", StopSign!)
				return -1
			end if
			
			this.object.nomb_declarada[al_row] = ls_data		
			this.object.nave_declarada[al_row] = ls_codigo
			
			this.ii_update = 1

		case "SITUAC_ARRIBO"
		
			ls_sql = "SELECT MOTIVO_MOVIMIENTO AS CODIGO, " &
					 + "DESCR_SITUACION AS DESCRIPCION " &
					 + "FROM FL_MOTIVO_MOVIMIENTO " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UN MOTIVO DE ARRIBO", StopSign!)
				return -1
			end if
			
			this.object.descr_situacion[al_row] = ls_data		
			this.object.situac_arribo[al_row] 	= ls_codigo
			
			this.ii_update = 1

		case "ZONA_PESCA_ARRIBO"
		
			ls_sql = "SELECT ZONA_PESCA AS CODIGO, " &
					 + "DESCR_ZONA AS DESCRIPCION " &
					 + "FROM TG_ZONAS_PESCA " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UNA ZONA DE PESCA", StopSign!)
				return -1
			end if
			
			this.object.descr_zona[al_row] 		  = ls_data		
			this.object.zona_pesca_arribo[al_row] = ls_codigo
			
			this.ii_update = 1

		case "PUERTO_ARRIBO"
		
			ls_sql = "SELECT PUERTO AS CODIGO, " &
					 + "DESCR_PUERTO AS DESCRIPCION " &
					 + "FROM FL_PUERTOS " &
					 + "WHERE FLAG_ESTADO = '1'"
					 
			lstr_seleccionar.s_column 	  = '2'
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
				Messagebox('Error', "DEBE SELECCIONAR UN PUERTO", StopSign!)
				return -1
			end if
			
			this.object.descr_puerto[al_row]  = ls_data		
			this.object.puerto_arribo[al_row] = ls_codigo
			
			this.ii_update = 1

	end choose
end if
return 1
end event

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1]  = 1				// columnas de lectrua de este dw
ii_update = 0
end event

event doubleclicked;call super::doubleclicked;long ll_row

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = this.GetRow()

this.event ue_dblclick( upper(dwo.name), ll_row, parent.is_tipo_pp )
end event

event itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_tipo, ls_unidad
string ls_nave, ls_cencos
long ll_row, ll_count
integer li_ano, li_mes
long ll_tiempo, ll_dias
datetime ld_fecha
time lt_time

this.AcceptText()
ll_row = this.GetRow()
if parent.is_tipo_pp = "zarpe" then
	choose case upper(dwo.name)
		case "NAVE_REAL"
			
			ls_codigo = this.object.nave_real[ll_row]
			
			SetNull(ls_data)
			
			select nomb_nave
				into :ls_data
			from vw_fl_naves_zarpe
			where nave = :ls_codigo;
	
			if ls_data = "" or isNull(ls_data) then
				Messagebox('Error', "CODIGO DE NAVE NO ES PROPIA, NO EXISTE O YA TIENE UN ZARPE", StopSign!)
				return 1
			end if
			
			// Verifico si antes de zarpar no tenga arribos pendientes
			if iuo_parte.of_verif_nav_zarpe( ls_codigo ) then
				this.object.nomb_nave[ll_row] = ls_data
			else
				return 1
			end if
			
		case "PUERTO_ZARPE"
			
			ls_codigo = this.object.puerto_zarpe[ll_row]
	
			ls_data = iuo_parte.of_get_nomb_pto(ls_codigo)			
	
			if ls_data = "" then
				Messagebox('Error', "CODIGO DE PUERTO NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_puerto[ll_row] = ls_data
			
		case "SITUAC_ZARPE"
			
			ls_codigo = this.object.situac_zarpe[ll_row]
	
			ls_data = iuo_parte.of_get_descr_situac(ls_codigo)			
	
			if ls_data = "" then
				Messagebox('Error', "SITUACION DE ZARPE NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_situacion[ll_row] = ls_data

		case "ZONA_PESCA_ZARPE"
			
			ls_codigo = this.object.zona_pesca_zarpe[ll_row]
	
			ls_data = iuo_parte.of_get_descr_zona(ls_codigo)
			
			if ls_data = "" then
				Messagebox('Error', "ZONA DE PESCA NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_zona[ll_row] = ls_data

		CASE "UNIDAD_OPERACION"
	
			ls_codigo = this.object.unidad_operacion[ll_row]
			
			ls_data   = iuo_parte.of_get_descr_unidad(ls_codigo)
	
			if ls_data = "" then
				Messagebox('Error', "UNIDAD NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.desc_unidad[ll_row] = ls_data

			ll_tiempo = long(this.object.tiempo_est_oper[ll_row])
			ls_unidad = trim(this.object.unidad_operacion[ll_row])
			ld_fecha  = datetime(this.object.fecha_hora_zarpe[ll_row])
			
			ld_fecha = f_relative_date( ld_fecha, ll_tiempo, ls_unidad )
			this.object.fecha_hora_est_arribo[ll_row] = ld_fecha

		CASE "TIEMPO_EST_OPER", "FECHA_HORA_ZARPE"
			
			ll_tiempo = long(this.object.tiempo_est_oper[ll_row])
			ls_unidad = trim(this.object.unidad_operacion[ll_row])
			ld_fecha  = datetime(this.object.fecha_hora_zarpe[ll_row])

			ld_fecha = f_relative_date( ld_fecha, ll_tiempo, ls_unidad )
			
			this.object.fecha_hora_est_arribo[ll_row] = ld_fecha
		
		case "REGISTRO_ZARPE"
			
			ls_codigo = trim( this.object.registro_zarpe[ll_row] )
			
			if not iuo_parte.of_verif_reg_zarpe( ls_codigo ) then
				return 1
			end if
		
	end choose
else
	
	choose case upper(dwo.name)

		case "NAVE_DECLARADA"
			
			ls_codigo = this.object.nave_declarada[ll_row]
			ls_data = iuo_parte.of_get_nomb_nave(ls_codigo)			
	
			if ls_data = "" then
				Messagebox('Error', "CODIGO DE NAVE NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.nomb_declarada[ll_row] = ls_data

		case "NRO_ORDEN"
			
			ls_nave   = trim( this.object.nave_real[ll_row] )
			ls_codigo = trim( this.object.nro_orden[ll_row] )
			if ls_nave = "" then
				MessageBox('ERROR', 'DEBES TENER PRIMERO UN CODIGO DE NAVE', StopSign!)
				return -1
			end if
			
			if iuo_parte.of_get_tipo_flota( ls_nave ) <> 'P' then
				MessageBox('ERROR', 'LA ORDEN DE TRABAJO SOLO SE ASIGNA A UNA ' &
					+ 'EMBARCACION PROPIA', StopSign!)
				return -1
			end if
			
			ls_cencos = iuo_parte.of_get_cencos_nave( ls_nave )
			
			if ls_cencos = "" then
				MessageBox('ERROR', 'LA NAVE PROPIA DEBE TENER ASIGNADO UN ' &
					+ 'CENTRO DE COSTOS', StopSign!)
				return -1
			end if
			
			SELECT DESCRIPCION
				into :ls_data
			FROM VW_FL_OT_NAVE 
			WHERE NAVE = :ls_nave
			  and nro_orden = :ls_codigo;
					 
			this.object.descripcion_ot[ll_row]  = ls_data		

	case "PUERTO_ARRIBO"
			
			ls_codigo = this.object.puerto_zarpe[ll_row]
			ls_data = iuo_parte.of_get_nomb_pto(ls_codigo)			
	
			if ls_data = "" then
				Messagebox('Error', "CODIGO DE PUERTO NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_puerto[ll_row] = ls_data
			
		case "SITUAC_ARRIBO"
			
			ls_codigo = this.object.situac_arribo[ll_row]
			ls_data = iuo_parte.of_get_descr_situac(ls_codigo)			
	
			if ls_data = "" then
				Messagebox('Error', "MOTIVO DE ARRIBO NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_situacion[ll_row] = ls_data

		case "ZONA_PESCA_ARRIBO"
			
			ls_codigo = this.object.zona_pesca_arribo[ll_row]
	
			ls_data = iuo_parte.of_get_descr_zona(ls_codigo)
			
			if ls_data = "" then
				Messagebox('Error', "ZONA DE PESCA NO EXISTE", StopSign!)
				return 1
			end if
			
			this.object.descr_zona[ll_row] = ls_data

		case "REGISTRO_ARRIBO"
			
			ls_codigo = trim( this.object.registro_arribo[ll_row] )
			
			if not iuo_parte.of_verif_reg_arribo( ls_codigo ) then
				return 1
			end if
		
	end choose
end if
end event

event itemerror;call super::itemerror;return 1
end event

event buttonclicked;call super::buttonclicked;long 				ll_row
string 			ls_nro_parte, ls_aprobado
str_parametros 	lstr_param

this.AcceptText()
ll_row = this.GetRow()
choose case upper(dwo.name)
	case "B_TRIP_ZARPE"
		
		if this.ii_update = 1 then
			MessageBox('Error', 'DEBE GRABAR PRIMERO EL ZARPE ' &
				+ 'PARA INGRESAR/MODIFICAR LA ASISTENCIA', StopSign!)
			return
		end if
		
		ls_nro_parte 	= trim( this.object.parte_pesca	  [ll_row] )
		ls_aprobado 	= trim( this.object.zarpe_aprobado [ll_row])

		if IsNull(ls_nro_parte) or ls_nro_parte = "" then
			MessageBox('Error', 'SE DEBE TENER UN NUMERO DE PARTE ' &
				+ 'PARA INGRESAR/MODIFICAR LA ASISTENCIA', StopSign!)
			return
		end if
		
		lstr_param.string1 = ls_nro_parte
		lstr_param.string2 = ls_aprobado
		
		OpenWithParm( w_fl305_trip_zarpe, lstr_param )

	case "B_VENTA"
		
		if this.ii_update = 1 then
			MessageBox('Error', 'DEBE GRABAR PRIMERO EL ARRIBO ' &
				+ 'PARA INGRESAR/MODIFICAR LA VENTA', StopSign!)
			return
		end if
		
		ls_nro_parte = trim( this.object.parte_pesca[ll_row] )
		
		if IsNull(ls_nro_parte) or ls_nro_parte = "" then
			MessageBox('Error', 'SE DEBE TENER UN NUMERO DE PARTE ' &
				+ 'PARA INGRESAR/MODIFICAR LA VENTA', StopSign!)
			return
		end if
		
		ls_aprobado = trim(this.object.arribo_aprobado[ll_row])
		
		lstr_param.string1 = ls_nro_parte
		lstr_param.string2 = ls_aprobado
		
		OpenWithParm( w_fl306_venta_arribo, lstr_param )
		
end choose
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
	// Verifico que no este protegido
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	// Obtengo el nombre de la columna
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )

	ll_row = this.GetRow()
	if ls_columna <> "" then
	 	this.event ue_dblclick( ls_columna, ll_row, parent.is_tipo_pp )
	end if

end if
return 0
end event

type cb_marribo from commandbutton within w_fl304_parte_pesca_bk
boolean visible = false
integer x = 1243
integer y = 496
integer width = 398
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "&Buscar Arribo"
end type

event clicked;string ls_parte, ls_nave, ls_registro

parent.event ue_update_request()

Open(w_fl501_buscar_arribo)

ls_parte = Message.StringParm

if IsNull( ls_parte ) or ls_parte = "" then
	MessageBox('Aviso', 'NO HA SELECCIONADO NINGUN PARTE DE PESCA',StopSign!)
	return
end if

parent.event ue_arribo(ls_parte)

end event

type cb_bzarpe from commandbutton within w_fl304_parte_pesca_bk
boolean visible = false
integer x = 855
integer y = 496
integer width = 393
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = "B&uscar Zarpe"
end type

event clicked;string ls_nro_parte, ls_nave, ls_registro

parent.event ue_update_request()

Open(w_fl500_buscar_zarpe)

ls_nro_parte = Message.StringParm

if IsNull( ls_nro_parte ) or ls_nro_parte = "" then
	MessageBox('Aviso', 'NO HA SELECCIONADO NINGUN PARTE DE PESCA',StopSign!)
	return
end if


end event

