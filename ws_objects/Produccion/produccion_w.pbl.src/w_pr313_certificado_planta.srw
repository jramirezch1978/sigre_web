$PBExportHeader$w_pr313_certificado_planta.srw
forward
global type w_pr313_certificado_planta from w_abc_master
end type
type dw_detail from u_dw_abc within w_pr313_certificado_planta
end type
type st_nro from statictext within w_pr313_certificado_planta
end type
type sle_nro from singlelineedit within w_pr313_certificado_planta
end type
type cb_1 from commandbutton within w_pr313_certificado_planta
end type
type st_1 from statictext within w_pr313_certificado_planta
end type
type st_tiempo from statictext within w_pr313_certificado_planta
end type
end forward

global type w_pr313_certificado_planta from w_abc_master
integer width = 3419
integer height = 2100
string title = "Certificados de Planta(PR313)"
string menuname = "m_mantto_smpl"
dw_detail dw_detail
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
st_1 st_1
st_tiempo st_tiempo
end type
global w_pr313_certificado_planta w_pr313_certificado_planta

type variables
//string is_action = 'open'

// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[]
			

end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_certificado)
public function longlong of_duracion_certificado ()
end prototypes

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM num_certificado_planta
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE num_certificado_planta IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO num_certificado_planta(origen, ult_nro)
		VALUES( :gs_origen, 1);
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
	END IF
	
	SELECT ult_nro
	  INTO :ll_ult_nro
	FROM num_certificado_planta
	WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE num_certificado_planta
		SET ult_nro = ult_nro + 1
	WHERE origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.cod_certificado[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
	ELSE
	ls_next_nro = dw_master.object.cod_certificado[dw_master.getrow()] 
	END IF

// Asigna numero a detalle dw_detail (detalle del Certificado)
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.cod_certificado[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

public subroutine of_retrieve (string as_nro_certificado);
//dw_detail.reset( )

dw_master.Retrieve(as_nro_certificado)
dw_detail.Retrieve(as_nro_certificado)

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect( )
dw_detail.of_protect( )

dw_master.ii_update = 0
dw_detail.ii_update = 0

//of_duracion_certificado()

is_Action = 'open'
end subroutine

public function longlong of_duracion_certificado ();integer 		dias, li_dia, li_mes, li_dias_1
string 		ls_duracion
Datetime		ld_finicio, ld_ffin

ld_finicio	= dw_master.object.fec_inicio			[dw_master.GetRow()]
ld_ffin  	= dw_detail.object.fec_vencimiento	[dw_detail.GetRow()]

li_dias_1 = DaysAfter(date(ld_finicio),date(ld_ffin))
dias   = li_dias_1 + 1

if dias < 30 then
	li_mes 		= 0
	li_dia 		= dias
	ls_duracion = string(li_mes) + space(1) +  'mes(es) y' + space(1) + string(li_dia)+ space(1) +'días' 

else 
	
	li_mes 		= truncate(dias/30,0)
	li_dia 		= truncate(mod(dias,30),2)
	ls_duracion = string(li_mes) + space(1) +  'mes(es) y' + space(1) + string(li_dia)+ space(1) +'días' 
end if

st_tiempo.text = ls_duracion

Return 1

end function

on w_pr313_certificado_planta.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.dw_detail=create dw_detail
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.st_1=create st_1
this.st_tiempo=create st_tiempo
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.st_nro
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_1
this.Control[iCurrent+5]=this.st_1
this.Control[iCurrent+6]=this.st_tiempo
end on

on w_pr313_certificado_planta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_detail)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_tiempo)
end on

event ue_update_pre;call super::ue_update_pre;long ll_row

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return


//Para la replicacion de datos
dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

// Genera el Código del Certificado
if of_set_numera() = 0 then return

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true

end event

event resize;call super::resize;////Override
//
//dw_master.width  = newwidth  - dw_master.x - 10
//dw_detail.width  = newwidth  - dw_detail.x - 10
//dw_detail.height = newheight - dw_detail.y - 10
//
//

This.SetRedraw(false)

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10



This.SetRedraw(true)
end event

event ue_modify;dw_master.of_protect()
dw_detail.of_protect()
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'CERTIFICADO_PLANTA'
is_tabla_m = 'CERTIFICADO_PLANTA_DET'

dw_detail.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
dw_detail.ii_protect = 0
dw_detail.of_protect()         		// bloquear modificaciones 

end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String   ls_cod_cert

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Para el log diario
IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_Create_log()
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

IF	dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF

//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		dw_detail.of_save_log()
	END IF
END IF
//

IF lbo_ok THEN
	COMMIT using SQLCA;
			
//	ls_cod_cert = dw_master.object.cod_certificado[dw_master.GetRow()]
//	
//   of_retrieve(ls_cod_cert)
		
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_detail.ii_protect = 0

	dw_master.of_protect( )
	dw_detail.of_protect( )

	is_action = 'open'

	
END IF
	



end event

event ue_update_request;//Override
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF dw_master.ii_update = 1 &
	or dw_detail.ii_update = 1 THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF
end event

event ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'ds_certificado_calidad_tbl'
sl_param.titulo = 'Certificados de Calidad'
sl_param.field_ret_i[1] = 1	//Cod_certificado

OpenWithParm( w_lista, sl_param )


sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_insert;// Override
Long  ll_row


if idw_1 = dw_master THEN
    dw_master.Reset()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if


end event

event ue_query_retrieve;//Override
String ls_cod_certi

ls_cod_certi = sle_nro.text

if ls_cod_certi = '' or isnull(ls_cod_certi) then

	Messagebox("Modulo de Producción","Defina el Cod. de Certificado que desea buscar")
	return
end if
	
string   ls_os, ls_os_1, ls_mensaje

select 	cod_certificado
	into 	:ls_os
from 		certificado_planta
	where	cod_certificado = :ls_cod_certi;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Producciòn: EL Certificado no ha sido definido" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
else
	  This.of_retrieve( ls_cod_certi )
end if


end event

event ue_anular;call super::ue_anular;Long ll_row

IF dw_master.GetRow() = 0 THEN RETURN

IF MessageBox('Aviso', 'Deseas anular El Parte Diario de Comedores', Information!, YesNo!, 2) = 2 THEN RETURN

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'EL Parte de Raciones ya esta anulada, no puedes anularla')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

is_action = 'anular'


end event

type dw_master from w_abc_master`dw_master within w_pr313_certificado_planta
event ue_display ( string as_columna,  long al_row )
integer y = 216
integer width = 3287
integer height = 776
string dataobject = "d_pr_certificado_planta_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta		[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
			this.ii_update = 1
		end if

case "PROVEEDOR"

		ls_sql = "SELECT PROVEEDOR AS CODIGO_PROVEEDOR, " &
				  + "NOM_PROVEEDOR AS DESCRIPCION " &
				  + "FROM PROVEEDOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor				[al_row] = ls_codigo
			this.object.nom_proveedor	      [al_row] = ls_data
			this.ii_update = 1
		end if


		CASE "DIRECCTION_ITEM"					
			
		ls_proveedor = dw_master.object.proveedor [al_row]
		
		IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
			Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
			Return 
		END IF
		
		// Solo Tomo la Direccion de facturacion
		ls_sql = "SELECT TO_CHAR(ITEM) AS ITEM," &    
				 + "TRIM(DIR_DIRECCION)  || ' ' || TRIM(DIR_DEP_ESTADO) || ' ' || TRIM(DIR_DISTRITO) AS DIRECCION, " &
				 + "DIR_URBANIZACION AS URBANIZACION," &
				 + "DIR_MNZ          AS MANZANA		," &
				 + "DIR_LOTE         AS LOTE			," &
				 + "DIR_NUMERO       AS NUMERO		," &
				 + "DIR_PAIS         AS PAIS			," &     
				 + "DESCRIPCION      AS DESCRIPCION "  &
				 + "FROM DIRECCIONES " &
				 + "WHERE CODIGO = '" + ls_proveedor +"' " &
				 + "AND FLAG_USO = '1'"
												
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> "" then
			this.object.direcction_item	[al_row] = Integer(ls_codigo)
			this.object.direccion			[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "UND"

		ls_sql = "SELECT UND AS CODIGO, " &
				  + "DESC_UNIDAD AS DESCRIPCION " &
				  + "FROM UNIDAD " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.und					[al_row] = ls_codigo
			this.object.desc_unidad	      [al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::constructor;call super::constructor;//is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  =  dw_detail
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
//str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_planta"
		
		ls_codigo = this.object.cod_planta[row]

		SetNull(ls_data)
		select desc_planta
			into :ls_data
		from tg_plantas
		where cod_planta = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Planta no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_planta	  	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_codigo
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
		case "proveedor"
		
		ls_codigo = this.object.proveedor[row]

		SetNull(ls_data)
		select nom_proveedor
			into :ls_data
		from proveedor
		where proveedor = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Proveedor no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.proveedor	  	[row] = ls_codigo
			this.object.nom_proveedor	[row] = ls_codigo
			return 1
		end if

		this.object.nom_proveedor		[row] = ls_data
		
	case "direcction_item"
		
		ls_proveedor = dw_master.object.proveedor [row]
		
	IF Isnull(ls_proveedor) OR Trim(ls_proveedor)  = "" THEN
		Messagebox("Aviso","Debe Ingresar Codigo de Proveedor , Verifique!")
		Return 
	END IF
	
	li_item = Integer(data)
	
	// Solo Tomo la Direccion de facturacion
	SELECT TRIM(DIR_DIRECCION)  || ' ' || TRIM(DIR_DEP_ESTADO) || ' ' 
			|| TRIM(DIR_DISTRITO) 
		into :ls_desc
	FROM DIRECCIONES 
	WHERE CODIGO 	= :ls_proveedor 
	  and item 		= :li_item
	  and flag_uso = '1';
											
	if SQLCA.SQLCode = 100 then
		MessageBox('Aviso', 'Item de Direccion no existe o no es de facturacion' + string(li_item))
		SetNull(li_item)
		this.object.direcction_item	[row] = li_item
		this.object.direccion			[row] = ls_null
		return 1
	end if
	
	this.object.direccion [row] = ls_desc
	
		case "und"
		
		ls_codigo = this.object.und[row]

		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Unidad no existe o no esta activoa", StopSign!)
			SetNull(ls_codigo)
			this.object.und	  		[row] = ls_codigo
			this.object.desc_unidad	[row] = ls_codigo
			return 1
		end if

		this.object.desc_unidad		[row] = ls_data
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'

this.object.fec_registro			[al_row] = f_fecha_actual()
this.object.cod_usr					[al_row] = gs_user
this.object.p_logo.filename 					= gs_logo

dw_detail.reset()




end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
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
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
Return 1
end event

type dw_detail from u_dw_abc within w_pr313_certificado_planta
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 1028
integer width = 3291
integer height = 696
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_pr_certificado_planta_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_SERVICIO"

		ls_sql = "SELECT COD_SERVICIO as CODIGO_SERVICIO, " &
				  + "DESC_SERVICIO AS DESCRIPCION " &
				  + "FROM CERTIFICADO_SERVICIO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_servicio		[al_row] = ls_codigo
			this.object.desc_servicio		[al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,

is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = dw_master

end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

THIS.AcceptText()
IF THIS.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, ll_row)
END IF

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_servicio"
		
		ls_codigo = this.object.cod_servicio[row]

		SetNull(ls_data)
		select desc_servicio
			into :ls_data
		from certificado_servicio
		where cod_servicio = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Sertificado_Servicio no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_servicio	  	[row] = ls_codigo
			this.object.desc_servicio		[row] = ls_codigo
			return 1
		end if

		this.object.desc_servicio		[row] = ls_data
		
	 //case "fec_vencimiento"
			//of_duracion_certificado()
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
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;//is_action = 'new'

IF	dw_master.ii_update = 1 THEN

Messagebox('Modulo de Producciòn', 'Para Pasar al Detalle Primero debe de Grabar la Cabecera')	

dw_detail.reset( )

Return

END IF

String ls_cod_cert

ls_cod_cert = idw_1.object.cod_certificado	[idw_1.getrow()]

This.object.cod_certificado 	 [this.getrow()] 		= ls_cod_cert



end event

type st_nro from statictext within w_pr313_certificado_planta
integer x = 37
integer y = 40
integer width = 539
integer height = 132
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Numero de Certificado:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr313_certificado_planta
integer x = 622
integer y = 56
integer width = 389
integer height = 92
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_pr313_certificado_planta
integer x = 1051
integer y = 52
integer width = 402
integer height = 100
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;string ls_nro_certificado

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro_certificado = Trim(sle_nro.text)

of_retrieve(ls_nro_certificado)

end event

type st_1 from statictext within w_pr313_certificado_planta
boolean visible = false
integer x = 46
integer y = 1796
integer width = 315
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long backcolor = 67108864
string text = "Duración:"
boolean focusrectangle = false
end type

type st_tiempo from statictext within w_pr313_certificado_planta
boolean visible = false
integer x = 343
integer y = 1796
integer width = 2117
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
boolean focusrectangle = false
end type

