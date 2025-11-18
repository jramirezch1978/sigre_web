$PBExportHeader$w_pr312_parte_piso_quick_new.srw
forward
global type w_pr312_parte_piso_quick_new from w_abc_master
end type
type tab_1 from tab within w_pr312_parte_piso_quick_new
end type
type tabpage_1 from userobject within tab_1
end type
type pb_6 from picturebutton within tabpage_1
end type
type st_2 from statictext within tabpage_1
end type
type pb_3 from picturebutton within tabpage_1
end type
type uo_fecha from u_ingreso_fechas_horas within tabpage_1
end type
type st_3 from statictext within tabpage_1
end type
type em_lectura from editmask within tabpage_1
end type
type em_control_hora from editmask within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type pb_4 from picturebutton within tabpage_1
end type
type pb_2 from picturebutton within tabpage_1
end type
type pb_1 from picturebutton within tabpage_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type ln_1 from line within tabpage_1
end type
type tabpage_1 from userobject within tab_1
pb_6 pb_6
st_2 st_2
pb_3 pb_3
uo_fecha uo_fecha
st_3 st_3
em_lectura em_lectura
em_control_hora em_control_hora
st_1 st_1
pb_4 pb_4
pb_2 pb_2
pb_1 pb_1
dw_detail dw_detail
ln_1 ln_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_observacion from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_observacion dw_observacion
end type
type tab_1 from tab within w_pr312_parte_piso_quick_new
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type st_nro from statictext within w_pr312_parte_piso_quick_new
end type
type sle_nro from singlelineedit within w_pr312_parte_piso_quick_new
end type
type cb_1 from commandbutton within w_pr312_parte_piso_quick_new
end type
end forward

global type w_pr312_parte_piso_quick_new from w_abc_master
integer width = 5097
integer height = 2860
string title = "Registro de Partes de Piso(PR312)"
string menuname = "m_mantto_smpl"
event ue_copia_datos ( )
tab_1 tab_1
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
end type
global w_pr312_parte_piso_quick_new w_pr312_parte_piso_quick_new

type variables
u_dw_abc		idw_detail, idw_observacion

// Para el registro del Log
string 	is_tabla_d, is_colname_d[], is_coltype_d[], &
			is_tabla_r, is_colname_r[], is_coltype_r[]
			
Integer	ii_ss
end variables

forward prototypes
public function integer of_set_numera ()
public subroutine of_retrieve (string as_nro_parte)
public subroutine of_asigna_dws ()
public subroutine of_set_modify ()
public subroutine of_retrieve_det (string as_nro_parte, integer ai_nro_control_n, integer ai_nro_lectura_n)
public subroutine ue_llama_copia_event ()
end prototypes

event ue_copia_datos();Long   ll_row_master, li_control_hora, li_lectura, li_nro_version
String ls_nro_parte,	 ls_formato

str_parametros sl_param

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0  THEN RETURN

IF dw_master.ii_update  = 1 OR idw_detail.ii_update = 1 OR &
	idw_observacion.ii_update = 1 THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	Return
END IF

li_control_hora	= integer(tab_1.tabpage_1.em_control_hora.text)
li_lectura 			= integer(tab_1.tabpage_1.em_lectura.text)

//datos del documento/
sl_param.string1     = dw_master.object.nro_parte    [ll_row_master]
sl_param.string2		= dw_master.object.formato      [ll_row_master]
sl_param.w1          = this
sl_param.long1 		= dw_master.object.nro_version  [ll_row_master]
sl_param.long2			= li_control_hora
sl_param.long3			= li_lectura
sl_param.datetime1	= idw_detail.object.hora_inicio [1]

OpenWithParm(w_abc_copia_control_lectura, sl_param)

end event

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM NUM_PROD_PARTE_PISO
	WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE NUM_PROD_PARTE_PISO IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO NUM_PROD_PARTE_PISO(origen, ult_nro)
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
	  FROM NUM_PROD_PARTE_PISO
	 WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE NUM_PROD_PARTE_PISO
		SET ult_nro = ult_nro + 1
	 WHERE origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF

	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	dw_master.object.nro_parte[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
	ELSE
	ls_next_nro = dw_master.object.nro_parte[dw_master.getrow()] 
	END IF

// Asigna numero a detalle dw_detail (detalle de la instruccion)
FOR ll_i = 1 TO idw_detail.RowCount()
	idw_detail.object.nro_parte[ll_i] = ls_next_nro
NEXT
RETURN 1
end function

public subroutine of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)

String ls_nivel

SELECT  A.ORIENTACION
  INTO :ls_nivel
  FROM TG_FMT_MED_ACT A,
       TG_PARTE_PISO  B
 WHERE A.FORMATO      = B.FORMATO
   AND A.NRO_VERSION  = B.NRO_VERSION
   AND B.NRO_PARTE = :as_nro_parte;

     IF    ls_nivel = '2' then 
	         tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_ff_new'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
     ELSEIF ls_nivel = '3' THEN
			   tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_nivel_3_tbl'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
	  ELSEIF ls_nivel = '4' then
			   idw_detail.dataobject = 'd_pr_parte_piso_det_nivel_4_tbl'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
		END IF
		
long li_control = 1, li_lectura = 1

idw_detail.retrieve(as_nro_parte, li_control, li_lectura)

idw_observacion.Retrieve(as_nro_parte)

idw_1.ii_protect 					= 0
idw_detail.ii_protect 			= 0
idw_observacion.ii_protect 	= 0
idw_1.of_protect( )
idw_detail.of_protect( )
idw_observacion.of_protect( )
idw_1.ii_update 					= 0
idw_detail.ii_update 			= 0
idw_observacion.ii_update 		= 0
dw_master.object.p_logo.filename = gs_logo
is_Action = 'open'
of_set_modify()
end subroutine

public subroutine of_asigna_dws ();idw_detail		 	 = tab_1.tabpage_1.dw_detail
idw_observacion	 = tab_1.tabpage_2.dw_observacion
end subroutine

public subroutine of_set_modify ();//valor_lectura_texto

idw_detail.Modify("valor_lectura_texto.Protect ='1 ~t If(flag_tipo_dato = ~~'C~~',0,If(flag_tipo_dato = ~~'H~~',1,If(flag_tipo_dato = ~~'N~~',1,0)))'")

idw_detail.Modify("valor_lectura_texto.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(255,255,222)) &
		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(192,192,192)) + ",If(flag_tipo_dato = ~~'N~~'," &
		+ string(RGB(192,192,192)) + "," + string(RGB(0,0,0)) +")))'")

		
//idw_detail.Modify("tipo_dato.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(255,255,222)) & 
//		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(192,192,192)) + ",If(flag_tipo_dato = ~~'N~~'," &
//		+ string(RGB(192,192,192)) + "," + string(RGB(0,0,0)) +")))'")
//

//valor_lectura_numero

idw_detail.Modify("valor_lect_numerico.Protect ='1 ~t If(flag_tipo_dato = ~~'C~~',1,If(flag_tipo_dato = ~~'H~~',1,If(flag_tipo_dato = ~~'N~~',0,0)))'")

idw_detail.Modify("valor_lect_numerico.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(192,192,192)) &
		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(192,192,192)) + ",If(flag_tipo_dato = ~~'N~~'," &
		+ string(RGB(255,255,222)) + "," + string(RGB(0,0,0)) +")))'")
		
//idw_detail.Modify("tipo_dato.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(192,192,192)) & 
//		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(192,192,192)) + ",If(flag_tipo_dato = ~~'N~~'," &
//		+ string(RGB(255,255,222)) + "," + string(RGB(0,0,0)) +")))'")
		
		
//valor_lectura_datetime

idw_detail.Modify("valor_lect_fec_hora.Protect ='1 ~t If(flag_tipo_dato = ~~'C~~',1,If(flag_tipo_dato = ~~'H~~',0,If(flag_tipo_dato = ~~'N~~',1,0)))'")


idw_detail.Modify("valor_lect_fec_hora.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(192,192,192)) &
		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(255,255,222)) + ",If(flag_tipo_dato = ~~'N~~'," &
		+ string(RGB(192,192,192)) + "," + string(RGB(0,0,0)) +")))'")
		
//idw_detail.Modify("tipo_dato.Background.Color ='" + string(RGB(10,0,0)) + " ~t If(flag_tipo_dato = ~~'C~~'," + string(RGB(192,192,192)) & 
//		+ ",If(flag_tipo_dato = ~~'H~~'," + string(RGB(255,255,222)) + ",If(flag_tipo_dato = ~~'N~~'," &
//	   + string(RGB(192,192,192)) + "," + string(RGB(0,0,0)) +")))'")
//

//idw_detail.Modify("valor_lectura.EditMask.Mask ='~~'~~' ~t If(flag_tipo_dato = ~~'C~~',~~'!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!~~',If(flag_tipo_dato = ~~'H~~',~~'##:##:##   !!~~',If(flag_tipo_dato = ~~'N~~',~~'#!!!!!!!!!!!!!!~~',~~'~~')))'")





end subroutine

public subroutine of_retrieve_det (string as_nro_parte, integer ai_nro_control_n, integer ai_nro_lectura_n);String ls_nivel

SELECT  A.ORIENTACION
  INTO :ls_nivel
  FROM TG_FMT_MED_ACT A,
       TG_PARTE_PISO  B
 WHERE A.FORMATO      = B.FORMATO
   AND A.NRO_VERSION  = B.NRO_VERSION
   AND B.NRO_PARTE = :as_nro_parte;

     IF    ls_nivel = '2' then 
	         tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_ff_new'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
     ELSEIF ls_nivel = '3' THEN
			   tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_nivel_3_tbl'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
	  ELSEIF ls_nivel = '4' then
			   idw_detail.dataobject = 'd_pr_parte_piso_det_nivel_4_tbl'
			   idw_detail.settransobject(sqlca)
				of_set_modify()
		END IF
		
idw_detail.retrieve(as_nro_parte, ai_nro_control_n, ai_nro_lectura_n)

tab_1.tabpage_1.em_control_hora.text = string(ai_nro_control_n)
tab_1.tabpage_1.em_lectura.text = string(ai_nro_lectura_n)

idw_detail.ii_update 			= 1

is_Action = 'open'
of_set_modify()
end subroutine

public subroutine ue_llama_copia_event ();//parent.event ue_update( )
end subroutine

on w_pr312_parte_piso_quick_new.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.tab_1=create tab_1
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.tab_1
this.Control[iCurrent+2]=this.st_nro
this.Control[iCurrent+3]=this.sle_nro
this.Control[iCurrent+4]=this.cb_1
end on

on w_pr312_parte_piso_quick_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.tab_1)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
end on

event resize;//Oberride
dw_master.width  = newwidth  - dw_master.x - 10

////dw_detailWidth = tab_1.width - idw_telefonos.x - 520
////idw_telefonos.height= tab_1.height - idw_telefonos.y - 50
//
////tab_1.tabpage_1.dw_detail.width  = newwidth  - dw_master.x - 10
////tab_1.tabpage_1.dw_detail.height = newheight - dw_master.y - 10
//tab_1.tabpage_2.dw_observacion.width  = newwidth  - dw_master.x - 10
//tab_1.tabpage_2.dw_observacion.height = newheight - dw_master.y - 10

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

event ue_list_open;call super::ue_list_open;//override
// Asigna valores a structura 

str_parametros sl_param

sl_param.dw1    = 'ds_partes_piso_tbl'
sl_param.titulo = 'Partes de Piso'
sl_param.field_ret_i[1] = 1	//Nro_Parte

sl_param.tipo    = '1SQL'
sl_param.string1 =  " WHERE substr(tg.nro_parte,1,2) = '"+ gs_origen + "' ORDER BY tg.nro_parte" 


OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event open;call super::open;//of_asigna_dws( )

end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws( )

ib_log 		= TRUE

is_tabla_d 	= 'TG_PARTE_PISO_DET'
is_tabla_r 	= 'TG_PARTE_PISO_OBS'

idw_detail.settransobject(sqlca)
idw_observacion.settransobject(sqlca)

idw_detail.ii_protect		= 0
idw_observacion.ii_protect = 0

idw_detail.of_protect()
idw_observacion.of_protect()




end event

event ue_modify;//Override

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte ha sido Anulado.~r~No puede hacerle modificaciones')
RETURN
END IF

Long 		ll_row, ll_master
Integer 	li_count
String  	ls_nro_parte

ll_master = dw_master.getrow( )

if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte [ll_master]

SELECT COUNT(B.COD_USR)
		 INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;

if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar las Firmas')
	return
end if

dw_master.of_protect() 
idw_detail.of_protect()
idw_observacion.of_protect()

of_set_modify()
end event

event ue_query_retrieve;//Override
String ls_nro_parte

ls_nro_parte = sle_nro.text

if ls_nro_parte = ' ' or isnull(ls_nro_parte) then

	Messagebox("Modulo de Producción","Defina el Nro. de Parte que desea buscar")
	return
end if

string   ls_os, ls_os_1, ls_mensaje

select 	nro_parte
	into 	:ls_os
from 		tg_parte_piso
	where	nro_parte = :ls_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Producciòn: EL Nro. de Parte no ha sido definido" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
else
	  This.of_retrieve( ls_nro_parte )
end if

end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String   ls_cod_cert, ls_nro_parte
long     ll_master, li_count

dw_master.AcceptText( )
idw_detail.AcceptText( )
idw_observacion.Accepttext( )

ll_master = dw_master.getrow( )


ls_nro_parte = dw_master.object.nro_parte [ll_master]

SELECT COUNT(B.COD_USR)
		 INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;

if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso ya ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar las Firmas')
	return 
end if

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Para el log diario
IF ib_log THEN
	
	dw_master.of_create_log()
	idw_detail.of_create_log()
	idw_observacion.of_Create_log()
	
END IF

IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF
IF	idw_detail.ii_update = 1 THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF
IF	idw_observacion.ii_update = 1 THEN
	IF idw_observacion.Update(true, false) = -1 then		// Grabacion de las Observaciones
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF
//Para el log diario
IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		idw_detail.of_save_log()
		idw_observacion.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	idw_detail.ii_update = 0
	idw_observacion.ii_update = 0
	
	dw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_observacion.ii_protect = 0
	
	dw_master.of_protect( )
	idw_detail.of_protect( )
	idw_observacion.of_protect( )
	
	dw_master.ResetUpdate( )
	idw_detail.ResetUpdate( )
	idw_observacion.ResetUpdate( )
	is_action = 'open'
END IF
	
end event

event ue_update_pre;call super::ue_update_pre;long 		ll_row
String  	ls_nro_parte

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detail, "tabular") <> true then return
if f_row_Processing( idw_observacion, "tabular") <> true then return
//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()
idw_observacion.of_set_flag_replicacion()

///////////////////////////////////////////////
if of_set_numera() = 0 then return
///////////////////////////////////////////////

// Si todo ha salido bien cambio el indicador ib_update_check a true, para indicarle
// al evento ue_update que todo ha salido bien
ib_update_check = true

end event

event ue_update_request;//Override

Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si 
// se quiere actualizar

IF (dw_master.ii_update 	  = 1 or idw_detail.ii_update = 1 or & 
	idw_observacion.ii_update = 1) THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result 			= 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 			= 0
		idw_detail.ii_update 		= 0
		idw_observacion.ii_update	= 0
	END IF
END IF

end event

event ue_anular;call super::ue_anular;Long 		ll_row, ll_master
Integer 	li_count
String  	ls_nro_parte

ll_master = dw_master.getrow( )

if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte [ll_master]

SELECT COUNT(B.COD_USR)
		 INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;

if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso ya ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar las Firmas')
	return
end if

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Producción', 'EL Parte de Piso ya esta anulado')
	RETURN
END IF

IF MessageBox('Producción', 'Esta seguro de Anular el Parte de Piso', Information!, YesNo!, 2) = 2 THEN RETURN

dw_master.object.flag_estado[ll_master] = '0'
dw_master.ii_update = 1

is_action = 'anular'


end event

event ue_delete;long 		ll_row, ll_master
Integer 	li_count
String  	ls_nro_parte

ll_master = dw_master.getrow( )

if ll_master < 1 then return


IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte de piso ya ha sido Anulado.~r~No puede hacerle modificaciones')
RETURN
END IF


ls_nro_parte = dw_master.object.nro_parte [ll_master]

SELECT COUNT(B.COD_USR)
		 INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;

if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso ya ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar las Firmas')
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

type dw_master from w_abc_master`dw_master within w_pr312_parte_piso_quick_new
event ue_display ( string as_columna,  long al_row )
integer y = 208
integer width = 3849
integer height = 584
string dataobject = "d_ap_pp_quick_ff"
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_parte, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor, ls_des_formato, ls_nivel
			
Long		ll_row_find
Integer	li_version, li_count

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta  	[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
			this.ii_update = 1
		end if

case "FORMATO"
			
		ls_nro_parte = dw_master.object.nro_parte[al_row]
	
	SELECT COUNT(*)
	  INTO :li_count
     FROM TG_PARTE_PISO_DET A
    WHERE a.nro_parte = :ls_nro_parte;
	 
	 IF li_count > 0 or idw_detail.rowcount( ) > 0 then
		 messagebox('Producción', 'No puede cambiar El Código del Formato. El parte de Piso ya Tiene Lecturas')
		 this.object.formato.protect = 1
		 this.object.nro_version.protect = 1
		Return
	 End if
		 
	
		ls_sql = "SELECT FORMATO as CÓDIGO, " &
				  + "nro_version ||' Versión '||DESCRIPCION AS DESCRIPCION " &
				  + "FROM TG_FMT_MED_ACT " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
					
		Select trim(nro_version), DESCRIPCION, orientacion
		  into :li_version, :ls_des_formato, :ls_nivel
		  from tg_fmt_med_act
		 where formato =:ls_codigo;
		 
	  if ls_codigo <> '' then
			this.object.formato				[al_row] = ls_codigo
			this.object.desc_formato      [al_row] = ls_des_formato
			this.object.nro_version       [al_row] = li_version
			this.object.nivel				   [al_row] = ls_nivel
			this.ii_update = 1
		end if
		
		IF    ls_nivel = '2' then 
	         tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_ff_new'
			   idw_detail.settransobject(sqlca)
     ELSEIF ls_nivel = '3' THEN
			   tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_nivel_3_tbl'
			   idw_detail.settransobject(sqlca)
	  ELSEIF ls_nivel = '4' then
			   idw_detail.dataobject = 'd_pr_parte_piso_det_nivel_4_tbl'
			   idw_detail.settransobject(sqlca)
		END IF

		case "TURNO"

		ls_sql = "SELECT TURNO AS CODIGO, " &
				  + "DESCRIPCION AS DESCRIPCION " &
				  + "FROM TURNO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.turno					[al_row] = ls_codigo
			this.object.desc_turno	      [al_row] = ls_data
			this.ii_update = 1
		end if
					
end choose
end event

event dw_master::constructor;call super::constructor;//is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte, &
			ls_nivel
Long		ll_count, ll_cuenta, ll_detail
integer	li_item, li_nro_version

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
			this.object.cod_planta   	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_data
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
		case 'formato'
		
		ls_nro_parte 	= this.object.nro_parte[row]
				
		select count(*)
			into :ll_cuenta
			from tg_parte_piso_det 
			where trim(nro_parte) = trim(:ls_nro_parte);

		ll_detail = tab_1.tabpage_1.dw_detail.rowcount( )
		
		if ll_cuenta > 0 or ll_detail > 0 then
			messagebox(parent.title, 'No puede modificar el formato si ya se han ingresado lecturas')
			return
		end if
		
		ls_codigo = this.object.formato[row]

		SetNull(ls_data)
		//SetNull(ls_nivel)
		
		select descripcion, orientacion
			into :ls_data, :ls_nivel
		from tg_fmt_med_act
		where formato = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Formato no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.formato	  			[row] = ls_codigo
			this.object.desc_formato		[row] = ls_codigo
			return 1
		end if
		
	  IF     ls_nivel = '2' then 
	         tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_ff_new'
			   idw_detail.settransobject(sqlca)
     ELSEIF ls_nivel = '3' THEN
			   tab_1.tabpage_1.dw_detail.dataobject = 'd_pr_parte_piso_det_nivel_3_tbl'
			   idw_detail.settransobject(sqlca)
	  ELSEIF ls_nivel = '4' then
			   idw_detail.dataobject = 'd_pr_parte_piso_det_nivel_4_tbl'
			   idw_detail.settransobject(sqlca)
		END IF

	
		this.object.desc_formato 			[row] = ls_data

	case 'nro_version'
		
		ls_nro_parte 	= this.object.nro_parte[row]
		select count(*)
			into :ll_cuenta
			from tg_parte_piso_det 
			where trim(nro_parte) = trim(:ls_nro_parte);

		ll_detail = tab_1.tabpage_1.dw_detail.rowcount( )
		
		if ll_cuenta > 0 or ll_detail > 0 then
			messagebox(parent.title, 'No puede modificar el formato si ya se han ingresado lecturas')
			return
		end if
		
		ls_codigo = this.object.formato[row]
	
		SetNull(ls_data)
		select formato
		  into :ls_data
		  from tg_fmt_med_act
		 where formato = :ls_codigo and nro_version = :data and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Producción', "Nro. De Version no esta definido para el Formato Seleccionado", StopSign!)
			this.object.nro_version [row] = 0
			return 1
		end if

	case "turno"
		
		ls_codigo = this.object.turno[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from turno
		where turno = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Turno no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.turno	  		[row] = ls_codigo
			this.object.desc_turno	[row] = ls_codigo
			return 1
		end if

		this.object.desc_turno		[row] = ls_data
		
		
end choose
end event

event dw_master::itemerror;call super::itemerror;Return 1
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;is_action = 'new'

this.object.fecha_reg			[al_row] = f_fecha_actual()
this.object.cod_usr				[al_row] = gs_user
this.object.p_logo.filename 			   = gs_logo
this.object.fecha_parte			[al_row] = f_fecha_actual()

idw_detail.reset()
idw_observacion.reset()

end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
Return 1
end event

type tab_1 from tab within w_pr312_parte_piso_quick_new
event ue_modify ( )
event ue_update ( )
event ue_copia_datos ( )
integer x = 5
integer y = 812
integer width = 4686
integer height = 1628
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

event ue_modify();parent.event ue_modify( )
end event

event ue_update();parent.event ue_update_request( )
end event

event ue_copia_datos();Parent.event ue_copia_datos()
end event

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.Control[]={this.tabpage_1,&
this.tabpage_2}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
end on

type tabpage_1 from userobject within tab_1
event ue_modify ( )
event ue_update ( )
event ue_copia_datos ( )
integer x = 18
integer y = 104
integer width = 4649
integer height = 1508
long backcolor = 79741120
string text = "Detalle del Parte de Piso"
long tabtextcolor = 134217746
long picturemaskcolor = 134217744
pb_6 pb_6
st_2 st_2
pb_3 pb_3
uo_fecha uo_fecha
st_3 st_3
em_lectura em_lectura
em_control_hora em_control_hora
st_1 st_1
pb_4 pb_4
pb_2 pb_2
pb_1 pb_1
dw_detail dw_detail
ln_1 ln_1
end type

event ue_modify();parent.event ue_modify( )
end event

event ue_update();parent.event ue_update( )
end event

event ue_copia_datos();Parent.Event ue_copia_datos()
end event

on tabpage_1.create
this.pb_6=create pb_6
this.st_2=create st_2
this.pb_3=create pb_3
this.uo_fecha=create uo_fecha
this.st_3=create st_3
this.em_lectura=create em_lectura
this.em_control_hora=create em_control_hora
this.st_1=create st_1
this.pb_4=create pb_4
this.pb_2=create pb_2
this.pb_1=create pb_1
this.dw_detail=create dw_detail
this.ln_1=create ln_1
this.Control[]={this.pb_6,&
this.st_2,&
this.pb_3,&
this.uo_fecha,&
this.st_3,&
this.em_lectura,&
this.em_control_hora,&
this.st_1,&
this.pb_4,&
this.pb_2,&
this.pb_1,&
this.dw_detail,&
this.ln_1}
end on

on tabpage_1.destroy
destroy(this.pb_6)
destroy(this.st_2)
destroy(this.pb_3)
destroy(this.uo_fecha)
destroy(this.st_3)
destroy(this.em_lectura)
destroy(this.em_control_hora)
destroy(this.st_1)
destroy(this.pb_4)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.dw_detail)
destroy(this.ln_1)
end on

type pb_6 from picturebutton within tabpage_1
integer x = 1646
integer y = 52
integer width = 165
integer height = 112
integer taborder = 70
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "Retrieve!"
string powertiptext = "Buscar Registro"
end type

event clicked;long 		ll_master, ll_detail
string 	ls_nro_parte, ls_msg
integer 	li_control_hora, li_lectura, li_msg

ll_master 		= dw_master.getrow( )

if ll_master 	< 1 then 
	messagebox('Modulo de Producción','No ha definifo el de parte de piso')
	return
end if

ls_nro_parte = dw_master.object.nro_parte[dw_master.getrow( )]

if isnull(ls_nro_parte) or trim(ls_nro_parte) = '' then
	messagebox('Modulo de Producción','No hay ningún formato de parte de piso definido')
	return
end if

li_control_hora 	= integer(tab_1.tabpage_1.em_control_hora.text)
li_lectura 			= integer(tab_1.tabpage_1.em_lectura.text)

idw_detail.retrieve(ls_nro_parte, li_control_hora, li_lectura)

of_set_modify()
end event

type st_2 from statictext within tabpage_1
integer x = 2514
integer y = 24
integer width = 718
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cambiar Hora de Inicio"
boolean focusrectangle = false
end type

type pb_3 from picturebutton within tabpage_1
string tag = "Reemplazar Valores"
integer x = 3337
integer y = 24
integer width = 178
integer height = 168
integer taborder = 50
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\flecha_abajo.bmp"
alignment htextalign = left!
end type

event clicked;long		 ll_total, ll_i
time 		 lt_hora, lt_hora_null
String 	 ls_turno, ls_ot_am, ls_tipo_mov

ll_total = idw_detail.rowcount( )

if ll_total < 1 then return

idw_detail.ii_update = 1

for ll_i = 1 to ll_total
	
    lt_hora = time(uo_fecha.of_get_fecha1())
		
	 if lt_hora <= lt_hora_null Then 
		 Messagebox('Asistencia', 'La Hora de Entrada no debe ser Menor a: "DD/MM/YYYY 00:00"')
		 Exit
	 end If
			
	idw_detail.object.hora_inicio[ll_i] = uo_fecha.of_get_fecha1()
	
next

end event

type uo_fecha from u_ingreso_fechas_horas within tabpage_1
event destroy ( )
integer x = 2501
integer y = 88
integer width = 786
integer taborder = 40
boolean bringtotop = true
end type

on uo_fecha.destroy
call u_ingreso_fechas_horas::destroy
end on

event constructor;call super::constructor;of_set_label('Entrada:','Hasta:')// para seatear el titulo del boton 
of_set_fecha(DateTime(today(),now()), DateTime('31/12/9999')) //para setear la fecha inicial
of_set_rango_inicio(datetime('01/01/1900')) // rango inicial
of_set_rango_fin(datetime('31/12/9999')) // rango final
end event

type st_3 from statictext within tabpage_1
integer x = 750
integer y = 68
integer width = 343
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Nro. Lectura"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type em_lectura from editmask within tabpage_1
integer x = 1106
integer y = 68
integer width = 165
integer height = 76
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~"
end type

type em_control_hora from editmask within tabpage_1
integer x = 581
integer y = 68
integer width = 165
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "01"
borderstyle borderstyle = stylelowered!
string mask = "00"
boolean spin = true
double increment = 1
string minmax = "1~~2"
end type

type st_1 from statictext within tabpage_1
integer x = 23
integer y = 68
integer width = 553
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Turno: 1 = ~"A~"; 2 = ~"B~""
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type pb_4 from picturebutton within tabpage_1
integer x = 1883
integer y = 44
integer width = 585
integer height = 120
integer taborder = 60
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Copiar Datos"
string picturename = "H:\source\BMP\aceptara.bmp"
alignment htextalign = right!
string powertiptext = "Buscar Registro"
end type

event clicked;Parent.event ue_copia_datos()

end event

type pb_2 from picturebutton within tabpage_1
integer x = 1298
integer y = 52
integer width = 165
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\new.bmp"
string powertiptext = "Nuevo"
end type

event clicked;long 		ll_master, ll_detail, ll_i
string 	ls_nro_parte, ls_msg, ls_formato
integer 	li_control_hora, li_lectura, li_msg, li_count, li_nro_version

ll_master = dw_master.getrow( )

if ll_master = 0 then return
ls_nro_parte 	= dw_master.object.nro_parte 	[ll_master]
ls_formato   	= dw_master.object.formato   	[ll_master]
li_nro_version = dw_master.object.nro_version[ll_master]

of_set_modify()

//if idw_detail.ii_protect = 1 then parent.event ue_modify( )

SELECT COUNT(*)
  INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;

if li_count > 0 then
	messagebox('Producción','El parte de Piso ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si desea hacer cambios primero debe de eliminar las Firmas')
	return
end if

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Parte ha sido Anulado.~r~No puede hacerle modificaciones')
RETURN
END IF

li_control_hora	= integer(tab_1.tabpage_1.em_control_hora.text)
li_lectura 			= integer(tab_1.tabpage_1.em_lectura.text)

parent.event ue_update( )
if idw_detail.ii_protect = 1 then parent.event ue_modify( )

ll_detail 			= idw_detail.retrieve(ls_nro_parte, li_control_hora, li_lectura)

if ll_detail > 1 then
	messagebox('Producción', 'Ya existen Datos para el Control: '+string(li_control_hora)+' y la Lectura: '+string(li_lectura))
	return
end if

declare 	usp_pr_parte_piso_det_quick procedure for 
			usp_pr_parte_piso_det_quick(:ls_nro_parte,
												 :ls_formato,
												 :li_nro_version,
												 :li_control_hora, 
												 :li_lectura);

execute 	usp_pr_parte_piso_det_quick;
fetch 	usp_pr_parte_piso_det_quick into :li_msg, :ls_msg;
close 	usp_pr_parte_piso_det_quick;

if li_msg = 1 then
	messagebox('Modulo de Producción', ls_msg)
	return
end if

ll_detail = idw_detail.retrieve(ls_nro_parte, li_control_hora, li_lectura)

idw_detail.ii_update = 1	 


end event

type pb_1 from picturebutton within tabpage_1
integer x = 1472
integer y = 52
integer width = 165
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\source\BMP\delete.bmp"
string powertiptext = "Eliminar"
end type

event clicked;long 		ll_det, ll_row, ll_master
integer 	li_count, li_control_hora, li_lectura
String	ls_nro_parte

ll_master = dw_master.getrow( )
if ll_master < 1 then return

ls_nro_parte = dw_master.object.nro_parte [ll_master]

SELECT COUNT(*)
		 INTO :li_count
  FROM TG_PARTE_PISO A, 
       TG_PARTE_PISO_FIRMAS B
 WHERE A.NRO_PARTE = B.NRO_PARTE
       AND A.NRO_PARTE =:ls_nro_parte;
		 
if li_count > 0 then
	messagebox('Modulo de Producción','El parte de Piso ya ha sido firmado. ~r~ No puede hacer modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar las Firmas')
	return
end if

ll_det = idw_detail.rowcount( )

if ll_det < 1 then return
if messagebox('Modulo de Producción', '¿Está seguro que desea eliminar TODO el detalle mostrado?', Question!, YesNo!, 2) = 2 then return

for ll_row = ll_det to 1 step -1
	 idw_detail.scrolltorow(ll_row)
	 idw_detail.setrow(ll_row)
	 idw_detail.selectrow(ll_row, true)
	 idw_detail.deleterow(ll_row)
next

idw_detail.ii_update = 1
parent.event ue_update( )

li_control_hora	= integer(tab_1.tabpage_1.em_control_hora.text)
li_lectura 			= integer(tab_1.tabpage_1.em_lectura.text)
idw_detail.retrieve(ls_nro_parte, li_control_hora, li_lectura)


	
end event

type dw_detail from u_dw_abc within tabpage_1
integer x = 9
integer y = 200
integer width = 4613
integer height = 1272
integer taborder = 20
string dataobject = "d_pr_parte_piso_det_ff_new"
boolean hscrollbar = true
boolean vscrollbar = true
boolean resizable = true
end type

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master
idw_det  =  			tab_1.tabpage_1.dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;//Override

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Formato ya ha sido Anulado.~r~No puede hacerle modificaciones')
RETURN
END IF

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		THIS.SetItem(al_row, ii_rk[li_x], la_id)
	NEXT
END IF


end event

event ue_delete;//Override
Return 1
end event

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;idw_detail.Accepttext( )
end event

event doubleclicked;call super::doubleclicked;
Dec ldc_valor_numerico

    ldc_valor_numerico = this.object.valor_lect_numerico[row]
	 
	 If not isnull(ldc_valor_numerico) then
	  	 Setnull(ldc_valor_numerico)
	 	 this.object.valor_lect_numerico[row] = ldc_valor_numerico
    end if
	
idw_detail.ii_update = 1
end event

type ln_1 from line within tabpage_1
integer linethickness = 11
integer beginx = 18
integer beginy = 160
integer endx = 1257
integer endy = 160
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4649
integer height = 1508
long backcolor = 79741120
string text = "Observaciones para el Parte"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_observacion dw_observacion
end type

on tabpage_2.create
this.dw_observacion=create dw_observacion
this.Control[]={this.dw_observacion}
end on

on tabpage_2.destroy
destroy(this.dw_observacion)
end on

type dw_observacion from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer x = 23
integer y = 88
integer width = 4457
integer height = 1420
integer taborder = 20
string dataobject = "d_ap_pp_obs_quick_tbl"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

choose case upper(as_columna)
		
	case "AUTOR"

		ls_sql = "SELECT u.cod_usr as Codigo, " &
				  + "u.nombre as Nombre "&
				  + "FROM usuario u "&
				  + "WHERE u.FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.autor			[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                     // 'md' = master con detalle, 'dd' = detalle con detalle a la vez

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = 			dw_master
idw_det  =  		idw_observacion
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;integer 	li_item
long 		ll_rows, ll_master
string 	ls_nro_parte

ll_master = dw_master.getrow( )

if ll_master < 1 then
	messagebox('Modulo de Produccion','No se puede insertar una observación sin número de parte')
   //this.event ue_delete( )
	return
end if

ls_nro_parte = dw_master.object.nro_parte[ll_master]

ll_rows = this.rowcount( )

if ll_rows < 2 then
	li_item = 1
else
	li_item = this.object.item[ll_rows - 1] + 1
end if

this.object.nro_parte	[al_row] = ls_nro_parte
this.object.item			[al_row] = li_item
this.object.autor			[al_row] = gs_user
end event

event doubleclicked;call super::doubleclicked;string ls_columna
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

event itemerror;call super::itemerror;Return 1
end event

type st_nro from statictext within w_pr312_parte_piso_quick_new
integer x = 27
integer y = 40
integer width = 439
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
string text = "Numero de Parte:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr312_parte_piso_quick_new
integer x = 498
integer y = 56
integer width = 411
integer height = 92
integer taborder = 30
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

type cb_1 from commandbutton within w_pr312_parte_piso_quick_new
integer x = 946
integer y = 52
integer width = 402
integer height = 100
integer taborder = 20
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

