$PBExportHeader$w_pr324_destajo_masivo.srw
forward
global type w_pr324_destajo_masivo from w_abc_mastdet_smpl
end type
type st_nro from statictext within w_pr324_destajo_masivo
end type
type sle_nro from singlelineedit within w_pr324_destajo_masivo
end type
type cb_1 from commandbutton within w_pr324_destajo_masivo
end type
type dw_1 from u_dw_abc within w_pr324_destajo_masivo
end type
end forward

global type w_pr324_destajo_masivo from w_abc_mastdet_smpl
integer width = 2935
integer height = 2236
string title = "Parte de Destajo Masivo (PR324)"
string menuname = "m_mantto_consulta"
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
dw_1 dw_1
end type
global w_pr324_destajo_masivo w_pr324_destajo_masivo

type variables
String is_tabla_dw1, is_colname_dw1[], is_coltype_dw1[]

end variables

forward prototypes
public function integer of_retrieve (string as_nro_parte)
public function integer of_nro_item (datawindow adw_pr)
public function integer of_set_numera ()
public subroutine of_modify ()
public function integer of_generar (string as_nro_parte_dstj, string as_flag_nuevo, ref string as_nro_pd_ot)
end prototypes

public function integer of_retrieve (string as_nro_parte);event ue_update_Request()

dw_master.Retrieve(as_nro_parte)
dw_master.ii_update = 0
dw_master.ii_protect = 0
dw_master.of_protect( )

dw_detail.Retrieve(as_nro_parte)
dw_detail.ii_update = 0
dw_detail.ii_protect = 0
dw_detail.of_protect( )

dw_1.Retrieve(as_nro_parte)
dw_1.ii_update = 0
dw_1.ii_protect = 0
dw_1.of_protect( )

is_action = 'open'
return 1
end function

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x 		= 1 to adw_pr.RowCount()
	IF li_item 	< adw_pr.object.nro_item[li_x] THEN
		li_item 	= adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM NUM_PROD_PARTE_DSTJ
	WHERE cod_origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE NUM_PROD_PARTE_DSTJ IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO NUM_PROD_PARTE_DSTJ(cod_origen, ult_nro)
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
	FROM NUM_PROD_PARTE_DSTJ
	WHERE cod_origen = :gs_origen FOR UPDATE;
	
	UPDATE NUM_PROD_PARTE_DSTJ
		SET ult_nro = ult_nro + 1
	WHERE cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_parte_dstj[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
ELSE
	ls_next_nro = dw_master.object.nro_parte_dstj[dw_master.getrow()] 
END IF

// Asigna numero a detalle dw_detail (detalle de la instruccion)
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.nro_parte_dstj[ll_i] = ls_next_nro
NEXT

FOR ll_i = 1 TO dw_1.RowCount()
	dw_1.object.nro_parte_dstj[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

public subroutine of_modify ();dw_detail.Modify("cod_trabajador.Protect ='1~tIf(flag_estado <> ~~'1~~' ,1,0)'")
dw_detail.Modify("cod_trabajador.background.color ='1~tIf(flag_estado <> ~~'1~~', RGB(192,192,192), RGB(255,255,255) )'")
		
dw_detail.Modify("cant_destajada.Protect ='1~tIf(flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("cant_destajada.background.color ='1~tIf(flag_estado <> ~~'1~~', RGB(192,192,192), RGB(255,255,255) )'")

dw_detail.Modify("horas_efectivas.Protect ='1~tIf(flag_estado <> ~~'1~~',1,0)'")
dw_detail.Modify("horas_efectivas.background.color ='1~tIf(flag_estado <> ~~'1~~', RGB(192,192,192), RGB(255,255,255) )'")

end subroutine

public function integer of_generar (string as_nro_parte_dstj, string as_flag_nuevo, ref string as_nro_pd_ot);string ls_mensaje

//create or replace procedure USP_PROD_PROC_DSTJ_MASIVO(
//       asi_nro_parte_dstj  IN prod_parte_dstj.nro_parte_dstj%TYPE,
//       asi_origen          IN origen.cod_origen%TYPE,
//       asi_usuario         IN usuario.cod_usr%TYPE,
//       asi_flag_nuevo      IN VARCHAR2,
//       asi_nro_pd_ot       IN pd_ot.nro_parte%TYPE,
//       aso_nro_pd_ot       OUT varchar2
//) IS

DECLARE 	USP_PROD_PROC_DSTJ_MASIVO PROCEDURE FOR
			USP_PROD_PROC_DSTJ_MASIVO( :as_nro_parte_dstj,
												:gs_origen,
												:gs_user,
												:as_flag_nuevo,
												:as_nro_pd_ot );

EXECUTE 	USP_PROD_PROC_DSTJ_MASIVO;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE USP_PROD_PROC_DSTJ_MASIVO: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return 0
END IF

FETCH USP_PROD_PROC_DSTJ_MASIVO INTO :as_nro_pd_ot;

CLOSE USP_PROD_PROC_DSTJ_MASIVO;

if as_flag_nuevo = '1' then
	MessageBox('Aviso', 'Se ha generado el Nro de Parte ' + as_nro_pd_ot + ' de manera satisfactoria', Information!)
else
	MessageBox('Aviso', 'Proceso Realizado Satisfactoriamente')
end if

return 1

end function

on w_pr324_destajo_masivo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.dw_1=create dw_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_1
end on

on w_pr324_destajo_masivo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0
ib_log = true

dw_1.SetTransObject(sqlca)
dw_1.of_protect()
is_tabla_dw1 = dw_1.Object.Datawindow.Table.UpdateTable


end event

event ue_update_pre;call super::ue_update_pre;long 		ll_row, ll_master
Integer 	li_count

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

if f_row_Processing( dw_1, "tabular") <> true then return

//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_1.of_set_flag_replicacion( )

///////////////////////////////////////////////
if of_set_numera() = 0 then return
///////////////////////////////////////////////

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_list_prod_parte_dstj_grd'
sl_param.titulo = "Partes de Destajo Masivo"
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	of_retrieve (sl_param.field_ret[1])	
END IF

end event

event ue_insert;//Overriding
Long  ll_row

if idw_1 = dw_master then
	if dw_master.ii_update = 1 or &
		dw_1.ii_update 	  = 1 or &
		dw_detail.ii_update = 1 then
		
		MessageBox('Aviso', 'Cambios pendientes en el documento, no puede insertar otro hasta que los grabe')
		return
		
	end if
else
	if dw_master.GetRow() = 0 then return
	
	if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then

		dw_master.ii_protect = 0
		dw_master.of_protect()
	
		dw_detail.ii_protect = 0
		dw_detail.of_protect()
		
		dw_1.ii_protect = 0
		dw_1.of_protect()
	
		MessageBox('Aviso', 'No puede Ingresar ningun Registaro mas este Parte, por favor verifique')	
	
		return
	end if
		
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_modify;//Overriding
if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then

	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_1.ii_protect = 0
	dw_1.of_protect()

	MessageBox('Aviso', 'No puede modificar este Parte, por favor verifique')	
	
	return
end if

of_modify()

dw_master.of_protect()
dw_detail.of_protect()
dw_1.of_protect()

if is_action <> 'new' then is_action = 'edit'

end event

event resize;//Overriding
dw_1.width  	  = newwidth  - dw_1.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_update_request;call super::ue_update_request;//Overriding
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR &
	 dw_detail.ii_update = 1 OR &
	 dw_1.ii_update 		= 1 ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_1.ii_update		  = 0
	END IF
END IF

end event

event ue_update;//Overriding
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()
dw_1.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_1.of_create_log()
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Detalle", ls_msg, StopSign!)
	END IF
END IF

IF	dw_1.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_1.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion Master", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_1.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_1.ii_update = 0
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_1.il_totdel = 0
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	dw_1.ResetUpdate()
	
	if dw_master.GetRow() > 0 then
		of_retrieve(dw_master.object.nro_parte_dstj[dw_master.GetRow()])
	end if
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_open_pos;call super::ue_open_pos;//Overriding

end event

event ue_anular;call super::ue_anular;Long ll_i
if is_action = 'new' then 
	MessageBox('Aviso', 'Accion no permitida, el documento no ha sido grabado')
	return
end if

if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then

	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_1.ii_protect = 0
	dw_1.of_protect()

	MessageBox('Aviso', 'No puede anular este Parte, por favor verifique')	
	
	return
end if

if MessageBox('Informacion', 'Desea anular este parte??', Information!, YesNo!, 2) = 2 then return

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

for ll_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[ll_i] = '0'
	dw_detail.ii_update = 1
next

is_action = 'anular'
end event

event ue_delete;//Overriding
Long  ll_row

if dw_master.GetRow() = 0 then return

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then

	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_1.ii_protect = 0
	dw_1.of_protect()

	MessageBox('Aviso', 'No puede Eliminar registro, por favor verifique')	
	
	return
end if

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr324_destajo_masivo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 152
integer width = 2048
integer height = 1004
string dataobject = "d_abc_prod_parte_dstj_ff"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_labor, ls_tarifa, ls_moneda

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_labor"
		ls_sql = "SELECT distinct l.cod_labor AS CODIGO_labor, " &
				  + "l.desc_labor AS DESCRIPCION_labor " &
				  + "FROM labor l, " &
				  + "labor_ejecutor le " &
				  + "where le.cod_labor = l.cod_labor " &
				  + "and l.flag_estado = '1' " &
				  + "and flag_jornal_destajo = 'D' "
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "cod_ejecutor"
		ls_labor = this.object.cod_labor [al_row]
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Aviso', 'Debe Ingresar un código de labor válido')
			return
		end if
		
		ls_sql = "SELECT e.cod_ejecutor AS CODIGO_ejecutor, " &
				  + "e.descripcion AS DESCRIPCION_ejecutor, " &
				  + "to_char(le.COSTO_UNITARIO, '999,990.0000') as tarifa, " &
				  + "le.cod_moneda as moneda " &
				  + "FROM ejecutor e, " &
				  + "labor_ejecutor le " &
				  + "where le.cod_ejecutor = e.cod_ejecutor " & 
				  + "and le.cod_labor = '" + ls_labor + "' " &
				  + "and e.flag_estado = '1' " 
					 
		lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_tarifa, &
					ls_moneda, '2')
		
		if ls_codigo <> '' then
			this.object.cod_ejecutor	[al_row] = ls_codigo
			this.object.desc_ejecutor	[al_row] = ls_data
			this.object.tarifa			[al_row] = Dec(ls_tarifa)
			this.object.cod_moneda		[al_row] = ls_moneda
			this.ii_update = 1
		end if
		
		return
		
	case "supervisor"
		ls_sql = "SELECT proveedor as codigo_supervisor, " &
				  + "nom_proveedor AS nombre_supervisor, " &
				  + "ruc as ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.supervisor		[al_row] = ls_codigo
			this.object.nom_supervisor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

	case "administrador"
		ls_sql = "SELECT proveedor as codigo_administrador, " &
				  + "nom_proveedor AS nombre_administrador, " &
				  + "ruc as ruc_proveedor " &
				  + "FROM proveedor " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.administrador		[al_row] = ls_codigo
			this.object.nom_administrador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "turno"
		ls_sql = "SELECT turno as codigo_turno, " &
				  + "descripcion AS descripcion_turno " &
				  + "FROM turno " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.turno			[al_row] = ls_codigo
			this.object.desc_turno	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
		
	case "ot_adm"
		ls_sql = "SELECT a.ot_adm as codigo_ot_adm, " &
				  + "a.descripcion AS descripcion_ot_adm " &
				  + "FROM ot_administracion a, " &
				  + "ot_adm_usuario b " &
				  + "where a.ot_adm = b.ot_adm " &
				  + "and b.cod_usr = '" + gs_user + "' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.desc_ot_adm	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return

end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro 		[al_row] = f_fecha_actual()
this.object.hora_inicio  		[al_row] = f_fecha_actual()
this.object.hora_fin  	 		[al_row] = f_fecha_actual()
this.object.cod_origen	 		[al_row] = gs_origen
this.object.cod_usr		 		[al_row] = gs_user
this.object.flag_estado	 		[al_row] = '1'
this.object.flag_replicacion	[al_row] = '1'
is_action = 'new'
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1		

ii_dk[1] = 1		
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::buttonclicked;call super::buttonclicked;string 	ls_labor,ls_ejecutor, ls_nro_parte_dstj
Decimal 	ldc_porcentaje
Long		ll_i, ll_rc
str_parametros lstr_param

If this.Describe("cod_labor.Protect") = '1' and dwo.name <> 'b_generar' then RETURN

ls_labor 	= this.object.cod_labor		[row]
ls_ejecutor = this.object.cod_ejecutor [row]

if ls_labor = '' or IsNull(ls_labor) then
	MessageBox('Aviso', 'Debe indicar un Código de Labor')
	return
end if

if ls_ejecutor = '' or IsNull(ls_ejecutor) then
	MessageBox('Aviso', 'Debe indicar un Código de Ejecutor')
	return
end if

if dwo.name = 'b_importar' then
	// Si es una salida x consumo interno
	lstr_param.w1				= parent
	lstr_param.dw_m			= dw_master
	lstr_param.dw_d			= dw_detail
	lstr_param.dw1      		= 'd_lista_labor_trabajador_tbl'
	lstr_param.titulo    	= 'Lista de Trabajadores '
	lstr_param.tipo		 	= '2S'     // con un parametro del tipo string
	lstr_param.string1   	= ls_labor
	lstr_param.string2	 	= ls_ejecutor
	lstr_param.opcion    	= 1

	OpenWithParm( w_abc_seleccion, lstr_param)

elseif dwo.name = 'b_generar' then

	if dw_master.ii_update = 1 or &
		dw_detail.ii_update = 1 or &
		dw_1.ii_update		  = 1 then
		
		MessageBox('Aviso', 'Existen Cambios pendientes, debe grabar primero antes de procesar')
		return
	end if
	
	if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then
		MessageBox('Aviso', 'El Documento no puede generar Parte Diario de Destajo, Tiene un estado incompatible')
		return
	end if
	
	ldc_porcentaje = 0
	
	for ll_i = 1 to dw_1.RowCount()
		ldc_porcentaje += Dec(dw_1.object.porcentaje[ll_i])
	next
	
	if ldc_porcentaje <> 100 then
		MessageBox('Aviso', 'El porcentaje de distribución no llega al 100%, no es posible la distribución')
	end if
	
	Open(w_abc_pd_ot)
	
	if IsNull(Message.PowerObjectParm) or Not IsValid(Message.PowerObjectParm) then return
	
	if Message.PowerObjectParm.ClassName() <> 'str_parametros' then return
	
	lstr_param = Message.PowerObjectParm
	
	if lstr_param.titulo = 'n' then return
	
	ls_nro_parte_dstj = dw_master.object.nro_parte_dstj[dw_master.GetRow()]
	
	ll_rc = of_generar(ls_nro_parte_dstj, lstr_param.string1, lstr_param.string2)
	
	if ll_rc = 1 then
		of_retrieve(ls_nro_parte_dstj)
	end if
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null, ls_labor, ls_moneda
Decimal	ldc_tarifa

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_labor"
		
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Labor no existe o no está activo", StopSign!)
			this.object.cod_labor	[row] = ls_null
			this.object.desc_labor	[row] = ls_null
			return 1
		end if

		this.object.desc_labor	[row] = ls_data
		
	case "cod_ejecutor"
		
		ls_labor = this.object.cod_labor [row]
		if ls_labor = '' or IsNull(ls_labor) then
			MessageBox('Aviso', 'Debe especificar primero una labor')
			return
		end if
		
		select e.descripcion, le.costo_unitario, le.cod_moneda
			into :ls_data, :ldc_tarifa, :ls_moneda
		from ejecutor e,
			  labor_ejecutor le
		where le.cod_ejecutor = e.cod_ejecutor
		  and le.cod_labor = :ls_labor
		  and e.cod_ejecutor = :data
		  and e.flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Ejecutor no existe, no pertenece a la labor o no está activo", StopSign!)
			this.object.cod_ejecutor	[row] = ls_null
			this.object.desc_ejecutor	[row] = ls_null
			this.object.cod_moneda		[row] = ls_null
			this.object.tarifa			[row]	= 0
			return 1
		end if

		this.object.desc_ejecutor	[row] = ls_data
		this.object.cod_moneda		[row] = ls_moneda
		this.object.tarifa			[row] = ldc_tarifa

	case "supervisor"
		
		select nom_proveedor
			into :ls_data
		from proveedor
		where flag_estado = '1'
		  and proveedor = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Supervisor no existe o no esta activo", StopSign!)
			this.object.supervisor		[row] = ls_null
			this.object.nom_supervisor	[row] = ls_null
			return 1
		end if

		this.object.nom_supervisor	[row] = ls_data

	case "administrador"
		
		select nom_proveedor
			into :ls_data
		from proveedor
		where flag_estado = '1'
		  and proveedor = :data;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Administrador no existe o no esta activo", StopSign!)
			this.object.administrador		[row] = ls_null
			this.object.nom_administrador	[row] = ls_null
			return 1
		end if

		this.object.nom_administrador	[row] = ls_data
		
	case "turno"
		
		select descripcion
		  into :ls_data
		  from turno
		 where flag_estado = '1'
		   and turno = :data;
			
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Turno no existe o no esta activo", StopSign!)
			this.object.turno			[row] = ls_null
			this.object.nom_turno	[row] = ls_null
			return 1
		end if

		this.object.nom_turno	[row] = ls_data
			
	case "ot_adm"
		
		select descripcion
		  into :ls_data
		  from ot_administracion a,
		  		 ot_adm_usuario	 b
		 where a.ot_adm = b.ot_adm
		   and b.cod_usr = :gs_user
			and a.ot_adm = :data;
			
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "OT_ADM no existe, no esta activo o no está autorizado a utilizarlo", StopSign!)
			this.object.ot_adm		[row] = ls_null
			this.object.desc_ot_adm	[row] = ls_null
			return 1
		end if

		this.object.desc_ot_adm	[row] = ls_data

end choose
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr324_destajo_masivo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 1172
integer width = 2834
integer height = 800
string dataobject = "d_abc_prod_parte_dstj_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "cod_trabajador"
		ls_sql = "SELECT cod_trabajador AS codigo_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador " &
				  + "FROM vw_pr_trabajador " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_trabajador	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event dw_detail::ue_insert_pre;//Overrding
String 	ls_nro_parte, ls_moneda
Decimal 	ldc_tarifa, ldc_horas
DateTime	ldt_h1, ldt_h2

if dw_master.GetRow() = 0 then return

ls_nro_parte = dw_master.object.nro_parte_dstj[dw_master.GetRow()]
ls_moneda	 = dw_master.object.cod_moneda[dw_master.GetRow()]
ldc_tarifa 	 = Dec(dw_master.object.tarifa[dw_master.GetRow()])
ldt_h1		 = dw_master.object.hora_inicio[dw_master.GetRow()]
ldt_h2		 = dw_master.object.hora_fin[dw_master.GetRow()]

select usf_alm_dif_dias(:ldt_h1, :ldt_h2)
  into :ldc_horas
  from dual;

if SQLCA.sqlcode < 0 then
	MessageBox('Aviso', SQLCA.SQLerrtext)
	return
end if

If IsNull(ldc_horas) then ldc_horas = 0

this.object.nro_parte_dstj		[al_row] = ls_nro_parte
this.object.flag_estado 		[al_row] = '1'
this.object.flag_replicacion	[al_row] = '1'
this.object.cod_usr				[al_row] = gs_user
this.object.nro_item				[al_row] = of_nro_item(this)
this.object.tarifa_normal		[al_row] = ldc_tarifa
this.object.horas_efectivas	[al_row] = ldc_horas * 24
this.object.cod_moneda			[al_row] = ls_moneda
this.object.und					[al_row] = dw_master.object.und[dw_master.GetRow()]
this.object.und_1					[al_row] = dw_master.object.und[dw_master.GetRow()]
end event

event dw_detail::getfocus;call super::getfocus;if f_row_Processing( dw_master, "form") <> true then 
	dw_master.PostEvent(clicked!)
	return
end if

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

end event

event dw_detail::itemerror;call super::itemerror;return 1
end event

event dw_detail::ue_insert;//Overrding
long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row

end event

event dw_detail::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_detail::itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_trabajador"
		
		select apel_paterno || ' '|| apel_materno || ', ' || nombre1 || ' ' || nombre2
			into :ls_data
		from maestro
		where cod_trabajador = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Código de Trabajador no existe o no está activo", StopSign!)
			this.object.cod_trabajador	[row] = ls_null
			this.object.nom_trabajador	[row] = ls_null
			return 1
		end if

		this.object.nom_trabajador	[row] = ls_data
		
end choose
end event

type st_nro from statictext within w_pr324_destajo_masivo
integer y = 40
integer width = 425
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Parte"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr324_destajo_masivo
integer x = 448
integer y = 28
integer width = 389
integer height = 92
integer taborder = 10
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

type cb_1 from commandbutton within w_pr324_destajo_masivo
integer x = 855
integer y = 20
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

type dw_1 from u_dw_abc within w_pr324_destajo_masivo
event ue_display ( string as_columna,  long al_row )
integer x = 2062
integer y = 152
integer width = 782
integer height = 1004
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_prod_factor_parte_dstj_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo, ls_nro_orden
str_parametros sl_param

this.AcceptText()

choose case lower(as_columna)
		
	case "nro_orden"
		ls_sql = "SELECT distinct ot.nro_orden AS numero_orden, " &
				  + "ot.ot_adm AS ot_administracion, " &
				  + "ot.titulo AS titulo_ot " &
				  + "FROM orden_trabajo ot, " &
				  + "operaciones op, " &
				  + "labor l " &
				  + "where op.nro_orden = ot.nro_orden " &
				  + "and op.cod_labor = l.cod_labor " &
				  + "and l.flag_jornal_destajo = 'D' " &
				  + "and op.flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.ot_adm		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
	case "oper_sec"
		ls_nro_orden = this.object.nro_orden [al_row]
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('Aviso', 'Deben indicar un numero de Orden primero')
			return
		end if
		ls_sql = "SELECT op.oper_sec AS numero_opersec, " &
				  + "op.cod_labor AS codigo_labor, " &
				  + "op.cod_ejecutor AS codigo_ejecutor, " &
				  + "op.desc_operacion AS descripion_operacion " &
				  + "FROM operaciones op, " &
				  + "labor l " &
				  + "where op.cod_labor = l.cod_labor " &
				  + "and l.flag_jornal_destajo = 'D' " &
				  + "and op.nro_orden = '" + ls_nro_orden + "' " &
				  + "and op.flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2	
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_nro_parte

if dw_master.GetRow() = 0 then return

ls_nro_parte = dw_master.object.nro_parte_dstj[dw_master.GetRow()]

this.object.nro_parte_dstj [al_row] = ls_nro_parte
this.object.porcentaje		[al_row] = 0
this.setColumn('nro_orden')
end event

event doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

