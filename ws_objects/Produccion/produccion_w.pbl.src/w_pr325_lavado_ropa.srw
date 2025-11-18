$PBExportHeader$w_pr325_lavado_ropa.srw
forward
global type w_pr325_lavado_ropa from w_abc
end type
type hpb_2 from hprogressbar within w_pr325_lavado_ropa
end type
type dw_carga_ratios from datawindow within w_pr325_lavado_ropa
end type
type dw_carga_parte from datawindow within w_pr325_lavado_ropa
end type
type hpb_1 from hprogressbar within w_pr325_lavado_ropa
end type
type st_4 from statictext within w_pr325_lavado_ropa
end type
type pb_1 from picturebutton within w_pr325_lavado_ropa
end type
type em_zona from singlelineedit within w_pr325_lavado_ropa
end type
type em_ot_adm from singlelineedit within w_pr325_lavado_ropa
end type
type st_3 from statictext within w_pr325_lavado_ropa
end type
type pb_2 from picturebutton within w_pr325_lavado_ropa
end type
type st_campo from statictext within w_pr325_lavado_ropa
end type
type dw_text from datawindow within w_pr325_lavado_ropa
end type
type st_master from statictext within w_pr325_lavado_ropa
end type
type dw_ratios from u_dw_abc within w_pr325_lavado_ropa
end type
type sle_ot from sle_text within w_pr325_lavado_ropa
end type
type st_2 from statictext within w_pr325_lavado_ropa
end type
type cb_2 from commandbutton within w_pr325_lavado_ropa
end type
type st_ratios from statictext within w_pr325_lavado_ropa
end type
type dw_operaciones from u_dw_abc within w_pr325_lavado_ropa
end type
type sle_parte from singlelineedit within w_pr325_lavado_ropa
end type
type st_1 from statictext within w_pr325_lavado_ropa
end type
type cb_1 from commandbutton within w_pr325_lavado_ropa
end type
type st_operaciones from statictext within w_pr325_lavado_ropa
end type
type dw_detail from u_dw_abc within w_pr325_lavado_ropa
end type
type st_detail from statictext within w_pr325_lavado_ropa
end type
type dw_master from u_dw_abc within w_pr325_lavado_ropa
end type
type gb_1 from groupbox within w_pr325_lavado_ropa
end type
type gb_2 from groupbox within w_pr325_lavado_ropa
end type
type r_1 from rectangle within w_pr325_lavado_ropa
end type
type r_2 from rectangle within w_pr325_lavado_ropa
end type
end forward

global type w_pr325_lavado_ropa from w_abc
integer width = 4466
integer height = 2544
string title = "Partes de Lavado de Ropa (PR325)"
string menuname = "m_mantto_consulta"
windowstate windowstate = maximized!
hpb_2 hpb_2
dw_carga_ratios dw_carga_ratios
dw_carga_parte dw_carga_parte
hpb_1 hpb_1
st_4 st_4
pb_1 pb_1
em_zona em_zona
em_ot_adm em_ot_adm
st_3 st_3
pb_2 pb_2
st_campo st_campo
dw_text dw_text
st_master st_master
dw_ratios dw_ratios
sle_ot sle_ot
st_2 st_2
cb_2 cb_2
st_ratios st_ratios
dw_operaciones dw_operaciones
sle_parte sle_parte
st_1 st_1
cb_1 cb_1
st_operaciones st_operaciones
dw_detail dw_detail
st_detail st_detail
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
r_1 r_1
r_2 r_2
end type
global w_pr325_lavado_ropa w_pr325_lavado_ropa

type variables
// Numerador de Parte de Raciones:
// SEQ_COM_PARTE_RAC

StaticText	ist_1
Long					il_st_color, il_nro_parte
string				is_nro_parte, is_table, is_col, &
						is_zona, is_desc_zona, is_cencos, is_desc_cencos, &
						is_nro_orden, is_oper_sec, is_confin, is_desc_confin, &
						is_tipo_comedor, is_parte_r, is_tipo_r, is_flag_rep_r	
		 
// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_d, is_colname_d[], is_coltype_d[], &
			is_tabla_r, is_colname_r[], is_coltype_r[]
			
n_cst_log_diario	in_log

integer ii_copia, ii_nro_raciones
dec     is_ratio_r
end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
public function boolean of_nro_parte (string as_origen, ref string as_ult_nro)
public function boolean of_current_nro (ref long al_current_nro)
public function boolean of_ot_tipo_adm_default (ref string as_ot_tipo, ref string as_desc_ot_tipo, ref string as_ot_adm, ref string as_desc_ot_adm)
public function integer of_nro_item (datawindow adw_pr)
public function integer of_set_numera ()
end prototypes

public subroutine of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)
dw_master.ii_protect = 0
dw_master.of_protect()
dw_master.ii_update = 0

dw_detail.Retrieve(as_nro_parte)
dw_detail.ii_protect = 0
dw_detail.of_protect()
dw_detail.ii_update = 0

dw_ratios.Retrieve(as_nro_parte)
dw_ratios.ii_protect = 0
dw_ratios.of_protect()
dw_ratios.ii_update = 0

dw_master.SetFocus()


end subroutine

public function boolean of_nro_parte (string as_origen, ref string as_ult_nro);String	ls_mensaje

//create or replace function USF_COM_NUM_PARTE_RACION
//(asi_cod_origen origen.cod_origen%type)
// return varchar2 is

DECLARE USF_COM_NUM_PARTE_RACION PROCEDURE FOR
	USF_COM_NUM_PARTE_RACION( :gs_origen );

EXECUTE USF_COM_NUM_PARTE_RACION;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_NUM_PARTE_RACION: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(as_ult_nro)
	return FALSE
END IF

FETCH USF_COM_NUM_PARTE_RACION INTO :as_ult_nro;
CLOSE USF_COM_NUM_PARTE_RACION;

return TRUE
end function

public function boolean of_current_nro (ref long al_current_nro);String	ls_mensaje

//create or replace function USF_COM_CUR_PARTE_RACION(
//       asi_origen  origen.cod_origen%type 
// ) return number is

DECLARE USF_COM_CUR_PARTE_RACION PROCEDURE FOR
	USF_COM_CUR_PARTE_RACION( :gs_origen );

EXECUTE USF_COM_CUR_PARTE_RACION;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "FUNCTION USF_COM_CUR_PARTE_RACION: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	SetNull(al_current_nro)
	return FALSE
END IF

FETCH USF_COM_CUR_PARTE_RACION INTO :al_current_nro;
CLOSE USF_COM_CUR_PARTE_RACION;

return TRUE

end function

public function boolean of_ot_tipo_adm_default (ref string as_ot_tipo, ref string as_desc_ot_tipo, ref string as_ot_adm, ref string as_desc_ot_adm);integer 	li_ok
string 	ls_mensaje

//create or replace procedure usp_com_default_01(
//       asi_origen        in origen.cod_origen%TYPE      ,
//       aso_ot_tipo       out orden_trabajo.ot_tipo%TYPE ,
//       aso_desc_ot_tipo  out varchar2                   ,
//       aso_ot_adm        out orden_trabajo.ot_adm%TYPE  ,
//       aso_desc_ot_adm   out varchar2                   ,
//       aso_mensaje       out varchar2                   , -- Mensaje de Error
//       aio_ok            out number                     
//       ) is

DECLARE usp_com_default_01 PROCEDURE FOR
	usp_com_default_01( :gs_origen );

EXECUTE usp_com_default_01;

IF SQLCA.sqlcode = -1 THEN
	ls_mensaje = "PROCEDURE usp_com_default_01: " + SQLCA.SQLErrText
	Rollback ;
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return false
END IF

FETCH usp_com_default_01 INTO :as_ot_tipo, 
	:as_desc_ot_tipo, :as_ot_adm, :as_desc_ot_adm, 
	:ls_mensaje, :li_ok;
	
CLOSE usp_com_default_01;

if li_ok <> 1 then
	MessageBox('Error PROCEDURE usp_com_default_01', ls_mensaje, StopSign!)	
	return false
end if

as_ot_tipo = trim(as_ot_tipo)
as_ot_adm  = trim(as_ot_adm)

return true

end function

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_item[li_x] THEN
		li_item = adw_pr.object.nro_item[li_x]
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
	  FROM num_prod_parte_lavado
	 WHERE origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE num_prod_parte_lavado IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO num_prod_parte_lavado(origen, ult_nro)
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
	FROM num_prod_parte_lavado
	WHERE origen = :gs_origen FOR UPDATE;
	
	UPDATE num_prod_parte_lavado
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
FOR ll_i = 1 TO dw_detail.RowCount()
	dw_detail.object.nro_parte[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

on w_pr325_lavado_ropa.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.hpb_2=create hpb_2
this.dw_carga_ratios=create dw_carga_ratios
this.dw_carga_parte=create dw_carga_parte
this.hpb_1=create hpb_1
this.st_4=create st_4
this.pb_1=create pb_1
this.em_zona=create em_zona
this.em_ot_adm=create em_ot_adm
this.st_3=create st_3
this.pb_2=create pb_2
this.st_campo=create st_campo
this.dw_text=create dw_text
this.st_master=create st_master
this.dw_ratios=create dw_ratios
this.sle_ot=create sle_ot
this.st_2=create st_2
this.cb_2=create cb_2
this.st_ratios=create st_ratios
this.dw_operaciones=create dw_operaciones
this.sle_parte=create sle_parte
this.st_1=create st_1
this.cb_1=create cb_1
this.st_operaciones=create st_operaciones
this.dw_detail=create dw_detail
this.st_detail=create st_detail
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
this.r_1=create r_1
this.r_2=create r_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_2
this.Control[iCurrent+2]=this.dw_carga_ratios
this.Control[iCurrent+3]=this.dw_carga_parte
this.Control[iCurrent+4]=this.hpb_1
this.Control[iCurrent+5]=this.st_4
this.Control[iCurrent+6]=this.pb_1
this.Control[iCurrent+7]=this.em_zona
this.Control[iCurrent+8]=this.em_ot_adm
this.Control[iCurrent+9]=this.st_3
this.Control[iCurrent+10]=this.pb_2
this.Control[iCurrent+11]=this.st_campo
this.Control[iCurrent+12]=this.dw_text
this.Control[iCurrent+13]=this.st_master
this.Control[iCurrent+14]=this.dw_ratios
this.Control[iCurrent+15]=this.sle_ot
this.Control[iCurrent+16]=this.st_2
this.Control[iCurrent+17]=this.cb_2
this.Control[iCurrent+18]=this.st_ratios
this.Control[iCurrent+19]=this.dw_operaciones
this.Control[iCurrent+20]=this.sle_parte
this.Control[iCurrent+21]=this.st_1
this.Control[iCurrent+22]=this.cb_1
this.Control[iCurrent+23]=this.st_operaciones
this.Control[iCurrent+24]=this.dw_detail
this.Control[iCurrent+25]=this.st_detail
this.Control[iCurrent+26]=this.dw_master
this.Control[iCurrent+27]=this.gb_1
this.Control[iCurrent+28]=this.gb_2
this.Control[iCurrent+29]=this.r_1
this.Control[iCurrent+30]=this.r_2
end on

on w_pr325_lavado_ropa.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_2)
destroy(this.dw_carga_ratios)
destroy(this.dw_carga_parte)
destroy(this.hpb_1)
destroy(this.st_4)
destroy(this.pb_1)
destroy(this.em_zona)
destroy(this.em_ot_adm)
destroy(this.st_3)
destroy(this.pb_2)
destroy(this.st_campo)
destroy(this.dw_text)
destroy(this.st_master)
destroy(this.dw_ratios)
destroy(this.sle_ot)
destroy(this.st_2)
destroy(this.cb_2)
destroy(this.st_ratios)
destroy(this.dw_operaciones)
destroy(this.sle_parte)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.st_operaciones)
destroy(this.dw_detail)
destroy(this.st_detail)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
destroy(this.r_1)
destroy(this.r_2)
end on

event ue_open_pre;call super::ue_open_pre;il_st_color = st_master.backcolor
idw_1			= dw_master
ist_1			= st_master

this.of_current_nro( il_nro_parte )

if IsNull(il_nro_parte) then il_nro_parte = 1

ib_log = TRUE
is_tabla_m = 'PROD_PARTE_LAVADO'
is_tabla_d = 'PROD_PARTE_LAVADO_DET'
is_tabla_r = 'PROD_PARTE_LAV_TARIFA'


dw_master.SetTransObject(SQLCA)  				// Relacionar el dw con la base de datos
dw_detail.SetTransObject(SQLCA)
dw_operaciones.SetTransObject(SQLCA)
dw_ratios.SetTransObject(SQLCA)
dw_carga_parte.settransobject(SQLCA)
dw_carga_ratios.settransobject(SQLCA)

end event

event resize;call super::resize;This.SetRedraw(false)

st_master.x = dw_master.X
st_master.width = dw_master.width

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
st_detail.x = dw_detail.X
st_detail.width = dw_detail.width

dw_operaciones.width = newwidth  - dw_operaciones.x - 10
st_operaciones.x 		= dw_operaciones.X
st_operaciones.width = dw_operaciones.width
r_2.x 		= dw_operaciones.X
r_2.width = dw_operaciones.width

This.SetRedraw(true)
end event

event ue_insert;// Override

Long  	ll_row
string	ls_nro_parte, ls_os
integer  li_count

if idw_1 = dw_master THEN
    dw_master.Reset()
end if

li_count = dw_master.rowcount( )

if li_count > 0 then

	ls_os		 = string(dw_master.object.nro_os[dw_master.getrow( )])

	IF ls_os <> ' ' or not isnull(ls_os) THEN
	Messagebox("Producción","No puede modificar un parte que ha sido amarrado a una Orden de Servicio")
	return
end if
else

CHOOSE CASE idw_1
	CASE dw_master
		
		TriggerEvent('ue_update_request')
		dw_master.Reset()
		dw_detail.Reset()
		
	CASE ELSE
		Integer li_estado

		li_estado = long(dw_master.object.flag_estado[dw_master.getrow()])

		IF li_estado = 2 THEN
		Messagebox("Producción","No puede hacer modificaciones, debido a que los costos de este parte ya han sido prorrateados")
		return

		else
	
		idw_1.of_protect( )
		dw_ratios.of_protect()
		dw_operaciones.of_protect()
		dw_detail.of_protect()
		end if
		
		//
		if dw_master.ii_update = 1 then
			MessageBox('Aviso', 'TIENE QUE GRABAR PRIMERO LA CABECERA',StopSign!)
			return
		end if

		ll_row = dw_master.GetRow()
		
		if ll_row <= 0 then
			MessageBox('Producción', 'NO EXISTE CABECERA DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ls_nro_parte = Trim(dw_master.object.nro_parte[ll_row])
		if ls_nro_parte = '' or IsNull(ls_nro_parte) then
			MessageBox('Producción', 'NO ESTA DEFINIDO NUMERO DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
	
END CHOOSE

end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_update_pre;call super::ue_update_pre;long 		ll_row, ll_master

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_ratios, "tabular") <> true then return

//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()
dw_ratios.of_set_flag_replicacion()

///////////////////////////////////////////////
if of_set_numera() = 0 then return
///////////////////////////////////////////////

ib_update_check = true



end event

event ue_update;// Ancestor Script has been Override
Boolean lbo_ok = TRUE

dw_master.AcceptText()
dw_detail.AcceptText()
dw_ratios.accepttext()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Grabo el Log de la Cabezera
IF ib_log THEN
	//ib_control_lin = FALSE
	u_ds_base		lds_log_m
	lds_log_m = Create u_ds_base
	lds_log_m.DataObject = 'd_log_diario_tbl'
	lds_log_m.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log_m, is_colname_m, is_coltype_m, gs_user, is_tabla_m)
END IF

// Grabo el Log de ratios
IF ib_log THEN
	u_ds_base		lds_log_d
	lds_log_d = Create u_ds_base
	lds_log_d.DataObject = 'd_log_diario_tbl'
	lds_log_d.SetTransObject(SQLCA)
	in_log.of_create_log(dw_detail, lds_log_d, is_colname_d, is_coltype_d, gs_user, is_tabla_d)
END IF

// Grabo el Log del Detalle de parte de raciones
IF ib_log THEN
	u_ds_base		lds_log_r
	lds_log_r = Create u_ds_base
	lds_log_r.DataObject = 'd_log_diario_tbl'
	lds_log_r.SetTransObject(SQLCA)
	in_log.of_create_log(dw_ratios, lds_log_r, is_colname_r, is_coltype_r, gs_user, is_tabla_r)
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_detail.ii_update = 1 THEN
	IF dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF dw_ratios.ii_update = 1 THEN
	IF dw_ratios.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
    	Rollback ;
		messagebox("Error en Grabacion Ratios","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_m.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_m
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_d.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_d
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_r.Update() = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log_r
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.il_totdel = 0
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_ratios.ii_update = 0
   is_action = 'open'

END IF
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'ds_partes_de_labado_tbl'
sl_param.titulo = "Partes Diario de Lavado"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = '1SQL'
sl_param.string1 =  " WHERE SUBSTR(NRO_PARTE,1,2) = '"+ gs_origen + "'" 



OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	is_nro_parte = sl_param.field_ret[1]
	This.of_retrieve (is_nro_parte)	
END IF
end event

event ue_query_retrieve;// Ancestor Script has been Override
is_nro_parte = sle_parte.text

if is_nro_parte = '' or isnull(is_nro_parte) then

	Messagebox("Producción","Defina el Nro. del Parte que desea buscar")
	return
end if
	
string   ls_os, ls_os_1, ls_mensaje

select 	nro_os
	into 	:ls_os
from 		prod_parte_lavado
	where	nro_parte = :is_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "PRODUCCIÓN: No se ha encontrado el Parte" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
end if

select 	nro_os
	into 	:ls_os_1
from 		prod_parte_lavado
	where	nro_parte = :is_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Producción: No se ha encontrado el Parte" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
	
else
	if ls_os_1 <> '' or not isnull(ls_os) then 		
		Messagebox("Producción","¡Cuidado!, el Parte que esta tratando de abrir ya ha sido amarrado a una Orden de Servicio")
		This.of_retrieve( is_nro_parte )
	else
		this.of_retrieve( string(sle_parte.text))
end if

end if


end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 or dw_ratios.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
	END IF
END IF
end event

event ue_delete;call super::ue_delete;Long  ll_row
Integer li_estado, li_count
string  ls_os

if idw_1 = dw_master THEN
Messagebox("Producción","No puede eliminar un parte. Es preferible que el parte sea Anulado")
Return
end if

li_count = dw_master.rowcount( )

if li_count > 0 then

	ls_os		 = string(dw_master.object.nro_os[dw_master.getrow( )])
	li_estado = long(dw_master.object.flag_estado[dw_master.getrow()])
	
IF ls_os <> ' ' or not isnull(ls_os) THEN
Messagebox("Producción","No puede modificar un parte que ya ha sido amarrado a una Orden de Servicio")
return

end if

idw_1.of_protect()
dw_ratios.of_protect()
dw_operaciones.of_protect()
dw_detail.of_protect()

END IF

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF


end event

event ue_modify;call super::ue_modify;Integer li_estado
string  ls_os
integer li_count

li_count = dw_master.rowcount( )

if li_count > 0 then

	ls_os		 = string(dw_master.object.nro_os[dw_master.getrow( )])
	li_estado = long(dw_master.object.flag_estado[dw_master.getrow()])
	
	IF ls_os <> ' ' or not isnull(ls_os) THEN
	Messagebox("Producción","No puede modificar un parte que ya ha sido amarrado a una Orden de Servicio")
	return
end if

IF li_estado = 2 THEN
Messagebox("Producción","No puede hacer modificaciones, debido a que los costos de este parte ya han sido prorrateados")
return

else
	
idw_1.of_protect( )
dw_ratios.of_protect()
dw_operaciones.of_protect()
dw_detail.of_protect()
end if

end if
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(idw_1, is_colname_m, is_coltype_m)
	in_log.of_dw_map(dw_detail, is_colname_d, is_coltype_d)
	in_log.of_dw_map(dw_ratios, is_colname_r, is_coltype_r)
END IF


end event

event ue_close_pre;Integer li_count


If ib_log THEN
DESTROY n_cst_log_diario
End If





end event

event ue_anular;call super::ue_anular;Long ll_row

IF dw_master.GetRow() = 0 THEN RETURN

IF MessageBox('Aviso', 'Deseas anular El Parte de Lavado', Information!, YesNo!, 2) = 2 THEN RETURN

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'EL Parte ya ha sido anulada, no puedes anularla')
	RETURN
END IF

IF MessageBox("Anulacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
	RETURN
END IF

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

is_action = 'anular'


end event

type hpb_2 from hprogressbar within w_pr325_lavado_ropa
boolean visible = false
integer x = 846
integer y = 940
integer width = 1632
integer height = 84
boolean bringtotop = true
string pointer = "H:\source\CUR\SEARCH.CUR"
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_carga_ratios from datawindow within w_pr325_lavado_ropa
boolean visible = false
integer x = 841
integer y = 1028
integer width = 1641
integer height = 400
integer taborder = 30
boolean titlebar = true
string title = "Cargando Tarifas..."
string dataobject = "d_tt_raciones_parte"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type dw_carga_parte from datawindow within w_pr325_lavado_ropa
boolean visible = false
integer x = 841
integer y = 1448
integer width = 3415
integer height = 880
integer taborder = 30
boolean titlebar = true
string title = "Cargando Detalle del Parte..."
string dataobject = "d_carga_parte_detalle"
string icon = "DataWindow5!"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type hpb_1 from hprogressbar within w_pr325_lavado_ropa
boolean visible = false
integer x = 846
integer y = 1364
integer width = 3392
integer height = 84
boolean bringtotop = true
string pointer = "H:\source\CUR\SEARCH.CUR"
unsignedinteger maxposition = 100
integer setstep = 1
end type

type st_4 from statictext within w_pr325_lavado_ropa
integer x = 2400
integer y = 748
integer width = 457
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Centro de Costo"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_1 from picturebutton within w_pr325_lavado_ropa
integer x = 2075
integer y = 660
integer width = 256
integer height = 152
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
string picturename = "AlignBottom!"
alignment htextalign = right!
vtextalign vtextalign = top!
end type

event clicked;string 	ls_parte, ls_nro_parte_new
datetime ldt_new_fecha
long 		ll_parte_ant, ll_rec, ll_rac_ant, ll_row, ll_row_d, ll_row_r

if dw_master.RowCount( ) = 0 then return
ll_row	= dw_master.GetRow()
ll_row_d	= dw_detail.GetRow()
ll_row_r	= dw_ratios.GetRow()

if ll_row_d > 0 then
	messagebox('Producción', 'El PARTE YA TIENE ASIGNADO UN DETALLE, NO PUEDE PROCEDER')
	return
end if


if ll_row_r > 0 then
	messagebox('Producción', 'El PARTE YA TIENE TARIFAS ASIGNADAS, NO PUEDE PROCEDER')
	return
end if

ls_nro_parte_new = dw_master.object.nro_parte [dw_master.GetRow( )]

if ls_nro_parte_new = '' or IsNull(ls_nro_parte_new) then
	MessageBox('Producción', 'Debe indicar un Nro. De parte')
	return
end if

ls_parte  		= trim(em_ot_adm.text)

if ls_parte = '' or IsNull(ls_parte) then
	MessageBox('Producción', 'Debe indicar un Nro. De parte')
	return
end if

DECLARE USP_PR_CARGA_PARTE_LAV PROCEDURE FOR
	     USP_PR_CARGA_PARTE_LAV(:ls_parte, :ls_nro_parte_new);

EXECUTE USP_PR_CARGA_PARTE_LAV;

IF sqlca.sqlcode = -1 THEN
		messagebox( "Producción", sqlca.sqlerrtext)
		Return
END IF

CLOSE   USP_PR_CARGA_PARTE_LAV;

ll_rac_ant   = dw_carga_ratios.retrieve()

IF ll_rac_ant >=1 THEN 
	
	dw_carga_ratios.visible 	 = TRUE
						 ii_copia    = 1
						 
	hpb_2.maxposition        = ll_rac_ant
	hpb_2.visible = TRUE
	
	FOR ll_rec = 1 TO ll_rac_ant
		
		is_parte_r				= dw_carga_ratios.object.nro_parte	   	[1]
		is_tipo_r		 	   = dw_carga_ratios.object.tipo_prenda	   [1]
		is_ratio_r			 	= dw_carga_ratios.object.tarifa         	[1]
		is_flag_rep_r			= dw_carga_ratios.object.flag_replicacion [1]

		dw_carga_ratios.deleterow(1)
		dw_ratios.event ue_insert()
		hpb_2.position = ll_rec
		
	next
	
	ii_copia = 0
	
   if dw_ratios.rowcount( ) <> ll_rac_ant then 
		messagebox('Producción', "No se han copiado correctamente los registros de Tarifas. Vuelva a intentarlo")
		dw_ratios.reset( )
	end if
	
	hpb_2.visible 					= false
	dw_carga_ratios.visible 	= false
	
end if

ll_parte_ant = dw_carga_parte.retrieve()

IF ll_parte_ant >=1 THEN 
	
	dw_carga_parte.visible 	 = TRUE
						 ii_copia = 1
						 
	hpb_1.maxposition        = ll_parte_ant
	hpb_1.visible 				 = TRUE
	FOR ll_rec 					 = 1 TO ll_parte_ant
		
		is_zona				 	= dw_carga_parte.object.zona_proceso   	[1]
		is_desc_zona		 	= dw_carga_parte.object.desc_zona       	[1]
		is_cencos			 	= dw_carga_parte.object.cencos         	[1]
		is_desc_cencos			= dw_carga_parte.object.desc_cencos       [1]
		is_tipo_comedor		= dw_carga_parte.object.tipo_prenda       [1]
		ii_nro_raciones		= dw_carga_parte.object.nro_prendas       [1]
		is_nro_orden   		= dw_carga_parte.object.nro_orden         [1]
		is_oper_sec				= dw_carga_parte.object.oper_sec          [1]
	
		dw_carga_parte.deleterow(1)
		dw_detail.event ue_insert()
		hpb_1.position = ll_rec
		
	next
	
	ii_copia = 0
	
   if dw_detail.rowcount( ) <> ll_parte_ant then 
		messagebox('Producción', "No se han copiado correctamente los registros del Parte. Vuelva a intentarlo")
		dw_detail.reset( )
	end if
	
	hpb_1.visible 					= false
	dw_carga_parte.visible 	   = false
	
end if

end event

type em_zona from singlelineedit within w_pr325_lavado_ropa
event dobleclick pbm_lbuttondblclk
integer x = 2862
integer y = 752
integer width = 384
integer height = 72
integer taborder = 40
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_tipo, ls_nro_parte
long 		ll_row, ll_row_d, ll_row_r

if dw_master.RowCount( ) = 0 then return
if dw_detail.RowCount( ) = 0 then return

ls_nro_parte = dw_master.object.nro_parte [dw_master.GetRow()]

ls_sql = "SELECT DISTINCT C.CENCOS AS CODIGO_CENCOS, " &
				  + "C.DESC_CENCOS AS DESCRIPCION " &
				  + "FROM CENTROS_COSTO C, PROD_PARTE_LAVADO_DET B " &
				  + "WHERE C.FLAG_ESTADO = '1' " &
				  + "AND C.CENCOS = B.CENCOS " &
				  + "AND B.NRO_PARTE= '" + ls_nro_parte + "'"
				  
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
if ls_codigo <> '' then
	
this.text= ls_codigo

end if
end event

type em_ot_adm from singlelineedit within w_pr325_lavado_ropa
event dobleclick pbm_lbuttondblclk
integer x = 1664
integer y = 692
integer width = 384
integer height = 72
integer taborder = 30
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "H:\Source\CUR\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_tipo
long 		ll_row, ll_row_d, ll_row_r

if dw_master.RowCount( ) = 0 then return

ll_row	= dw_master.GetRow()
ll_row_d	= dw_detail.GetRow()
ll_row_r	= dw_ratios.GetRow()


if ll_row_d > 0 then
	messagebox('Producción', 'El PARTE YA TIENE ASIGNADO UN DETALLE, NO PUEDE PROCEDER')
	return
end if


if ll_row_r > 0 then
	messagebox('Producción', 'El PARTE YA TIENE TARIFAS ASIGNADAS, NO PUEDE PROCEDER')
	return
end if


ls_sql = "SELECT C.NRO_PARTE AS NRO_PARTE, to_char(C.FEC_PARTE_LAV, 'DD/MM/YYYY') AS FECHA_DE_PARTE, to_char(C.FEC_REGISTRO, 'DD/MM/YYYY') " &
				  + "FROM prod_parte_lavado C " &
				  + "WHERE SUBSTR(C.NRO_PARTE,1,2) = '" + gs_origen + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			
if ls_codigo <> '' then
	
this.text= ls_codigo

end if


end event

type st_3 from statictext within w_pr325_lavado_ropa
integer x = 1358
integer y = 648
integer width = 288
integer height = 180
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Cargar Detalle de Parte"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type pb_2 from picturebutton within w_pr325_lavado_ropa
integer x = 3273
integer y = 740
integer width = 174
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
string picturename = "Update!"
alignment htextalign = right!
vtextalign vtextalign = top!
end type

event clicked;string 	ls_zona, ls_nro_parte_new, ls_nro_orden, ls_oper_sec, ls_zona_d
datetime ldt_new_fecha
long 		ll_parte_ant, ll_rec, ll_rac_ant, ll_row, ll_row_d, ll_row_r, ll_i

if dw_master.RowCount( ) = 0 then return
if dw_detail.RowCount( ) = 0 then return
if dw_ratios.RowCount( ) = 0 then return
	
ls_zona  		= trim(em_zona.text)
	
if ls_zona = '' or IsNull(ls_zona) then
	MessageBox('Aviso', 'Debe indicar un Centro de Costo')
	return
end if

ls_nro_orden = trim(sle_ot.text)

if ls_nro_orden = '' or IsNull(ls_nro_orden) then
	MessageBox('Aviso', 'Debe indicar un Nro. de Orden')
	return
end if

if dw_operaciones.GetRow( ) < 1 then
	MessageBox('Aviso', 'No existen Operaciones para el Nro. de Orden Seleccionado')
	return
end if
	

ls_oper_sec = dw_operaciones.object.oper_sec [dw_operaciones.GetRow()]

if ls_oper_sec = '' or IsNull(ls_oper_sec) then
	MessageBox('Aviso', 'Debe indicar una Operacion')
	return
end if

	FOR ll_i = 1 TO dw_detail.RowCount( )
		
		ls_zona_d = dw_detail.object.cencos [ll_i]
	
		if trim(ls_zona) = trim(ls_zona_d) then
					
			dw_detail.object.nro_orden [ll_i] = ls_nro_orden
			dw_detail.object.oper_sec  [ll_i] = ls_oper_sec
		
		end if
		
	next
	
	dw_detail.ii_update = 1

end event

type st_campo from statictext within w_pr325_lavado_ropa
integer x = 2386
integer y = 200
integer width = 791
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "CAMPO:"
boolean focusrectangle = false
end type

type dw_text from datawindow within w_pr325_lavado_ropa
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 3195
integer y = 200
integer width = 951
integer height = 72
integer taborder = 20
boolean bringtotop = true
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event dw_enter;dw_operaciones.triggerevent(doubleclicked!)
return 1
end event

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_operaciones.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_operaciones.scrollnextrow()	
end if
ll_row = dw_text.Getrow()
end event

event constructor;Long ll_reg
ll_reg = this.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_longitud
string 	ls_item, ls_ordenado_por, ls_comando
Long 		ll_fila

SetPointer(hourglass!)

if TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo
		ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + string(ls_item) + "'"
	
		ll_fila = dw_operaciones.find(ls_comando, 1, dw_operaciones.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_operaciones.selectrow(0, false)
			dw_operaciones.selectrow(ll_fila,true)
			dw_operaciones.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)

end event

type st_master from statictext within w_pr325_lavado_ropa
integer y = 116
integer width = 1335
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Cabecera del Parte de Lavado"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_ratios from u_dw_abc within w_pr325_lavado_ropa
integer x = 1344
integer y = 192
integer width = 1015
integer height = 416
integer taborder = 30
string dataobject = "d_partes_lavado_tarifa_tbl"
boolean vscrollbar = true
boolean hsplitscroll = true
borderstyle borderstyle = styleraised!
end type

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_ratios
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert;// Ancestor Script has been Override
long ll_row

if dw_master.getrow( ) = 0 then 
	Messagebox('Producción', 'No ha definido cabecera del Parte')
	Return 1
end If

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
	THIS.SetColumn('tipo_prenda')
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_parte
long		ll_row

if ii_copia = 1 then

	this.object.nro_parte				[al_row] = is_parte_r
	this.object.tipo_prenda				[al_row] = is_tipo_r
	this.object.tarifa					[al_row] = is_ratio_r
	this.object.flag_replicacion		[al_row] = is_flag_rep_r

ELSE

	ll_row 			= dw_master.GetRow()
	ls_nro_parte	= dw_master.object.nro_parte[ll_row]

	this.object.nro_parte[al_row] = ls_nro_parte
	this.object.tarifa [al_row] = 1.00

END IF

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_tipo_rac
long		ll_row_find
DEC 		ldc_ratio

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "TIPO_PRENDA"
		
		ls_codigo = this.object.tipo_prenda[row]
		
		if ls_codigo = '' or IsNull(ls_codigo) then
			SetColumn('tipo_prenda')
			return 1
		end if
		
		ll_row_find = this.find("tipo_prenda = '" + ls_codigo + "'", 1, this.RowCount() )
		
		if ll_row_find > 0 and ll_row_find <> row then
			SetNull(ls_codigo)
			MessageBox('Aviso', 'Tipo de tipo_prenda ya ha sido ingresada', StopSign!)
			this.object.tipo_prenda[row] = ls_codigo
			setColumn('tipo_prenda')
			return 1
		end if
	
end choose

end event

type sle_ot from sle_text within w_pr325_lavado_ropa
integer x = 2944
integer y = 16
integer width = 357
integer height = 84
integer taborder = 20
integer textsize = -8
integer limit = 10
end type

event ue_keydwn;// Ancestor Script has been Override
if Key = KeyF2! then
	this.event dynamic ue_display()	
elseIF key = KeyEnter! THEN
	cb_2.triggerevent(clicked!)
END IF
end event

event ue_display;call super::ue_display;string 	ls_sql, ls_codigo, ls_data
Boolean 	lb_ret
ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
		  + "to_char(FEC_INICIO, 'dd/mm/yyyy') AS FECHA_INICIO, " &
		  + "to_char(FEC_ESTIMADA, 'dd/mm/yyyy') AS FECHA_ESTIMADA " &
		  + "FROM ORDEN_TRABAJO " &
		  + "WHERE FLAG_ESTADO IN ('1','3') " &
		  + "AND COD_ORIGEN = '" + gs_origen + "'"

lb_ret = f_lista(ls_sql, ls_codigo, &
			ls_data, '1')
		
if ls_codigo <> '' then
	this.text = ls_codigo
	dw_operaciones.Retrieve(ls_codigo)
end if

end event

type st_2 from statictext within w_pr325_lavado_ropa
integer x = 2395
integer y = 36
integer width = 489
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Trabajo:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type cb_2 from commandbutton within w_pr325_lavado_ropa
integer x = 3374
integer y = 24
integer width = 398
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Operaciones"
end type

event clicked;string ls_nro_orden
ls_nro_orden = sle_ot.text

dw_operaciones.Retrieve (ls_nro_orden)	

end event

type st_ratios from statictext within w_pr325_lavado_ropa
integer x = 1339
integer y = 116
integer width = 1019
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Tarifa de Prendas"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_operaciones from u_dw_abc within w_pr325_lavado_ropa
integer x = 2386
integer y = 284
integer width = 1760
integer height = 396
integer taborder = 20
string dragicon = "H:\Source\ICO\row.ico"
string dataobject = "d_abc_operacion_orden_trabajo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
end event

event clicked;call super::clicked;if this.RowCount() > 0 then
	This.Drag(Begin!)
else
	This.Drag(Cancel!)
end if
end event

event dragleave;call super::dragleave;if source = dw_operaciones then
	source.DragIcon = "Error!"
end if
end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col, j
String  ls_column , ls_report, ls_color
Long ll_row

li_col 		= dw_operaciones.GetColumn()
ls_column 	= THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	
	st_campo.text = "Parte: " + is_col
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
END IF
end event

type sle_parte from singlelineedit within w_pr325_lavado_ropa
event ue_tecla pbm_keydown
integer x = 361
integer y = 20
integer width = 357
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
textcase textcase = upper!
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF key = KeyEnter! THEN
	cb_1.triggerevent(clicked!)
END IF
end event

type st_1 from statictext within w_pr325_lavado_ropa
integer x = 46
integer y = 32
integer width = 306
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nro Parte :"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_pr325_lavado_ropa
integer x = 727
integer y = 20
integer width = 306
integer height = 80
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;is_nro_parte = sle_parte.text

if is_nro_parte = '' or isnull(is_nro_parte) then

	Messagebox("Modulo de Comedores","Defina el Nro. del Parte que desea buscar")
	return
end if
	
string   ls_os, ls_os_1, ls_mensaje

select 	nro_os
	into 	:ls_os
from 		com_parte_rac
	where	parte_racion = :is_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Comedores: No se ha encontrado el Parte de Raciones" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
end if

select 	nro_os
	into 	:ls_os_1
from 		com_parte_rac
	where	parte_racion = :is_nro_parte;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Comedores: No se ha encontrado el Parte de Raciones" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
	
else
	if ls_os_1 <> '' or not isnull(ls_os) then 		
		Messagebox("Modulo de Comedores","¡Cuidado!, el Parte que esta tratando de abrir ya ha sido amarrado a una Orden de Servicio")
		parent.of_retrieve( is_nro_parte )
	else
		parent.of_retrieve( string(sle_parte.text))
end if

end if
	

end event

type st_operaciones from statictext within w_pr325_lavado_ropa
integer x = 2377
integer y = 116
integer width = 1769
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Operaciones Segun O.T."
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_pr325_lavado_ropa
event ue_display ( string as_columna,  long al_row )
integer y = 948
integer width = 3593
integer height = 996
integer taborder = 20
string dataobject = "d_parte_lavado_detalle_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
	case "ZONA_PROCESO"
		
		if gs_origen = 'SP' or gs_origen = 'PS' then
			
		
		ls_sql = "SELECT ZONA_PROCESO AS CODIGO_ZONA, " &
				  + "DESCR_ZONA_PROC AS DESCRIPCION_ZONA " &
				  + "FROM COM_ZONA_PROCESO " &
				  + "WHERE FLAG_ESTADO = '1'" &
				  + "AND NIVEL = 'D' AND origen = '" + gs_origen + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.zona_proceso[al_row] = ls_codigo
			this.object.desc_zona	[al_row] = ls_data
			
			select cencos 
				into :ls_cencos
			from com_zona_proceso
			where zona_proceso = :ls_codigo;
			
			select desc_cencos
				into :ls_desc_cencos
			from centros_costo
			where cencos = :ls_cencos;
			
			this.object.cencos 		[al_row] = ls_Cencos
			this.object.desc_cencos	[al_row] = ls_desc_cencos
			this.ii_update = 1
		end if
		
	else
		
		ls_sql = "SELECT ZONA_PROCESO AS CODIGO_ZONA, " &
				  + "DESCR_ZONA_PROC AS DESCRIPCION_ZONA " &
				  + "FROM COM_ZONA_PROCESO " &
				  + "WHERE FLAG_ESTADO = '1'" &
				  + "AND NIVEL = 'D' AND origen NOT IN('SP', 'PS')"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.zona_proceso[al_row] = ls_codigo
			this.object.desc_zona	[al_row] = ls_data
			
			select cencos 
				into :ls_cencos
			from com_zona_proceso
			where zona_proceso = :ls_codigo;
			
			select desc_cencos
				into :ls_desc_cencos
			from centros_costo
			where cencos = :ls_cencos;
			
			this.object.cencos 		[al_row] = ls_Cencos
			this.object.desc_cencos	[al_row] = ls_desc_cencos
			this.ii_update = 1
		end if
	end if
		
	case "CENCOS"

		ls_sql = "SELECT 	CENCOS AS CODIGO_CENCOS, " &
				  + "DESC_CENCOS AS DESCRIPCION " &
				  + "FROM CENTROS_COSTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.object.desc_cencos	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "NRO_ORDEN"

		ls_sql = "SELECT NRO_ORDEN AS CODIGO, " &
				  + "to_char(FEC_INICIO, 'dd/mm/yyyy') AS FECHA_INICIO, " &
				  + "to_char(FEC_ESTIMADA, 'dd/mm/yyyy') AS FECHA_ESTIMADA " &
				  + "FROM ORDEN_TRABAJO " &
				  + "WHERE FLAG_ESTADO IN ('1','3') "

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden[al_row] = ls_codigo

			SetNull(ls_oper_sec)
			this.object.oper_sec	[al_row]	= ls_oper_sec
			
			if ls_codigo <> sle_ot.Text then
				sle_ot.Text = ls_codigo
				dw_operaciones.Retrieve(ls_codigo)
			end if
			
			this.ii_update = 1
		end if

	case "OPER_SEC"
		
		ls_nro_orden = this.object.nro_orden[al_row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('COMEDORES', 'NRO DE ORDEN DE TRABAJO INDEFINIDO',StopSign!)
			return
		end if

		ls_sql = "SELECT OPER_SEC AS CODIGO, " &
			  	 + "DESC_OPERACION AS DESCRIPCION, " &
				 + "to_char(FEC_INICIO, 'dd/mm/yyyy') AS FECHA_INICIO " &
				 + "FROM OPERACIONES " &
				 + "WHERE FLAG_ESTADO IN ('1','3') " &
				 + "AND NRO_ORDEN = '" + ls_nro_orden + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			
			SELECT  C.CENCOS, C.DESC_CENCOS into :ls_cencos_r, :ls_desc_cencos_r
			FROM    OPERACIONES O, CENTROS_COSTO C
			WHERE   O.CENCOS    =  C.CENCOS
			AND     O.OPER_SEC  =  :ls_codigo;
			
			this.object.oper_sec		[al_row] = ls_codigo
			this.object.cencos		[al_row] = ls_cencos_r
			this.object.desc_cencos [al_row] = ls_desc_cencos_r	
			
			ll_row_find = dw_operaciones.Find("oper_sec = '" + ls_codigo + "'", &
							1, dw_operaciones.RowCount() )
							
			if ll_row_find <> 0 then
				dw_operaciones.SetRow(ll_row_find)
				f_select_current_row( dw_operaciones )
			end if
			
			this.ii_update = 1
		end iF
		
end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_detail
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_nro_parte, ls_nro_orden
long		ll_row

If dw_ratios.RowCount() = 0  then
	ib_update_check = false
	MessageBox('Aviso', 'No ha ingresado ningun ratio al parte',StopSign!)
	dw_detail.reset( )
	return
end if


if ii_copia = 1 then
	
ll_row 			= dw_master.GetRow()
ls_nro_parte	= dw_master.object.nro_parte[ll_row]

this.object.nro_item		[al_row] = of_nro_item(this)
this.object.nro_parte	[al_row] = ls_nro_parte
	
   this.object.zona_proceso 	[al_row] = is_zona
	this.object.desc_zona	 	[al_row] = is_desc_zona
	this.object.cencos		 	[al_row] = is_cencos
	this.object.desc_cencos	 	[al_row] = is_desc_cencos
	this.object.tipo_prenda	   [al_row] = is_tipo_comedor
	this.object.nro_prendas 	[al_row] = ii_nro_raciones
	this.object.nro_orden	 	[al_row] = is_nro_orden
	this.object.oper_sec		 	[al_row] = is_oper_sec

ELSE
	
ll_row 			= dw_master.GetRow()
ls_nro_parte	= dw_master.object.nro_parte[ll_row]

this.object.nro_item		[al_row] = of_nro_item(this)
this.object.nro_parte	[al_row] = ls_nro_parte
this.object.nro_prendas [al_row] = 0

if al_row > 1 then
	this.object.zona_proceso [al_row] = this.object.zona_proceso[al_row - 1]
	this.object.desc_zona	 [al_row] = this.object.desc_zona	[al_row - 1]
	this.object.cencos		 [al_row] = this.object.cencos		[al_row - 1]
	this.object.desc_cencos	 [al_row] = this.object.desc_cencos	[al_row - 1]
	this.object.nro_orden	 [al_row] = this.object.nro_orden	[al_row - 1]
	this.object.oper_sec		 [al_row] = this.object.oper_sec		[al_row - 1]
end if
END IF

end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
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

event dragenter;call super::dragenter;if source = dw_operaciones then
	source.DragIcon = "H:\Source\ICO\row.ico"
end if
end event

event dragleave;call super::dragleave;if source = dw_operaciones then
	source.DragIcon = "Error!"
end if
end event

event dragdrop;call super::dragdrop;string 	ls_oper_sec, ls_nro_orden, ls_nro_parte, ls_cencos_r, ls_desc_cencos_r
long		ll_row_det,  ll_row_oper, ll_row_mas

// Antes de hacer el Drag and Drop debo cerciorarme que
// Exista la cabecera del parte Diario

ll_row_mas = dw_master.GetRow()
if ll_row_mas <= 0 then
	MessageBox('PRODUCCIÓN', 'NO SE HA DENIFIDO LA CABECERA DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
end if

ls_nro_parte = dw_master.object.nro_parte[ll_row_mas]
if ls_nro_parte = '' or IsNull(ls_nro_parte) then
	MessageBox('PRODUCCIÓN', 'NO SE HA DENIFIDO NUMERO DEL PARTE, POR FAVOR VERIFIQUE',StopSign!)
	return
end if


if source = dw_operaciones then
	ll_row_det = this.il_row
	if ll_row_det = 0 then
		MessageBox('PRODUCCIÓN', 'DEBE ELEGIR UN REGISTRO PARA EFECTUAR ESTA OPERACION',StopSign!)
		return
	end if
	
	ll_row_oper	= dw_operaciones.GetRow()
	if ll_row_oper = 0 then return
	
	ls_oper_sec 	= dw_operaciones.object.oper_sec[ll_row_oper]
	ls_nro_orden 	= dw_operaciones.object.nro_orden[ll_row_oper]
	this.object.oper_sec		[ll_row_det] = ls_oper_sec
	this.object.nro_orden	[ll_row_det] = ls_nro_orden
	
	SELECT  C.CENCOS, C.DESC_CENCOS into :ls_cencos_r, :ls_desc_cencos_r
			FROM    OPERACIONES O, CENTROS_COSTO C
			WHERE   O.CENCOS    =  C.CENCOS
			AND     O.OPER_SEC  =  :ls_oper_sec;
			
			this.object.cencos		[ll_row_det] = ls_cencos_r
			this.object.desc_cencos [ll_row_det] = ls_desc_cencos_r	
	this.ii_update = 1
	
end if
end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF

end event

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_nro_orden, ls_cencos_r, ls_desc_cencos_r
long		ll_count, ll_row_find

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "ZONA_PROCESO"
		
		ls_codigo = this.object.zona_proceso[row]

		SetNull(ls_data)
		select descr_zona_proc
			into :ls_data
		from com_zona_proceso
		where zona_proceso = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "ZONA DE PROCESO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.zona_proceso	[row] = ls_codigo
			this.object.desc_zona		[row] = ls_codigo
			return 1
		end if

		this.object.desc_zona[row] = ls_data

	case "CENCOS"
		ls_codigo = this.object.cencos[row]
		
		SetNull(ls_data)
		select desc_cencos
			into :ls_data
		from centros_costo
		where cencos = :ls_codigo
		  and flag_estado = '1';

		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE CENTRO DE COSTO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cencos		[row] = ls_codigo
			this.object.desc_cencos	[row] = ls_codigo
			return 1
		end if
		
		this.object.desc_cencos[row] = ls_data

	case "TIPO_PRENDA"
		ls_codigo = this.object.tipo_prenda[row]
		
		if ls_codigo = '' or IsNull(ls_codigo) then
			return
		end if
		
		ll_row_find = dw_ratios.find( "tipo_prenda = '" + ls_codigo + "'", 1, dw_ratios.RowCount() )
		
		if ll_row_find = 0 then
			SetNull(ls_codigo)
			MessageBox('Aviso', 'No ha ingresado la tarifa para este Tipo de Prenda', StopSign!)
			this.object.tipo_prenda[row] = ls_codigo
			SetColumn('tipo_prenda')
			return 1
		end if
		

	case "NRO_ORDEN"
		ls_codigo = this.object.nro_orden[row]
		
		if ls_codigo = '' or IsNull(ls_codigo) then
			return
		end if
		
		SetNull(ls_data)

		select count(*)
			into :ll_count
		from orden_trabajo
		where nro_orden = :ls_codigo
		  and flag_estado in ('1', '2');

		
		if ll_count = 0 then 
			Messagebox('PRODUCCIÓN', "ORDEN DE TRABAJO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.nro_orden	[row] = ls_codigo
			this.object.oper_sec		[row] = ls_codigo
			return 1
		end if
		
		this.object.oper_sec			[row] = ls_data

	case "OPER_SEC"
		
		ls_nro_orden = this.object.nro_orden[row]
		
		if ls_nro_orden = '' or IsNull(ls_nro_orden) then
			MessageBox('PRODUCCIÓN', 'NRO DE ORDEN DE TRABAJO INDEFINIDO',StopSign!)
			return
		end if
		
		ls_codigo = this.object.oper_sec[row]
		
		select count(*)
			into :ll_count
		from operaciones
		where nro_orden = :ls_nro_orden
		  and oper_sec  = :ls_codigo
		  and flag_estado in ('1', '2');
		

		if ll_count = 0 then 
			Messagebox('PRODUCCIÓN', "OPER_SEC NO EXISTE, NO ESTA ACTIVO O NO CORRESPONDE A LA O.T.", StopSign!)
			SetNull(ls_codigo)
		return 1
		else
			
		SELECT  C.CENCOS, C.DESC_CENCOS into :ls_cencos_r, :ls_desc_cencos_r
		FROM    OPERACIONES O, CENTROS_COSTO C
			WHERE   O.CENCOS    =  C.CENCOS
			AND     O.OPER_SEC  =  :ls_codigo;
			
			this.object.oper_sec		[row] = ls_codigo
			this.object.cencos		[row] = ls_cencos_r
			this.object.desc_cencos [row] = ls_desc_cencos_r	
		end if
	
end choose
end event

event ue_insert;// Ancestor Script has been Override
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
	THIS.SetColumn('zona_proceso')
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

type st_detail from statictext within w_pr325_lavado_ropa
integer x = 5
integer y = 856
integer width = 3589
integer height = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Detalles de los partes de Lavado"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_master from u_dw_abc within w_pr325_lavado_ropa
event ue_display ( string as_columna,  long al_row )
integer y = 196
integer width = 1335
integer height = 656
string dataobject = "d_partes_lavado_ff"
borderstyle borderstyle = styleraised!
end type

event ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_MONEDA"
		
		ls_sql = "SELECT COD_MONEDA AS CODIGO, " &
				  + "DESCRIPCION AS DESCR_MONEDA " &
				  + "FROM MONEDA " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.object.desc_moneda	[al_row] = ls_data
			this.ii_update = 1
		end if
	
	case "PROVEEDOR"
		
		ls_sql = "SELECT PROVEEDOR AS CODIGO, " &
				  + "NOM_PROVEEDOR AS NOMBRE " &
				  + "FROM PROVEEDOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.proveedor			[al_row] = ls_codigo
			this.object.nom_proveedor  	[al_row] = ls_data
			this.ii_update = 1
		end if		
		
end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

ist_1.backcolor  = il_st_color
ist_1.italic     = false
ist_1 = st_master
ist_1.backcolor = rgb(100,0,0)
ist_1.italic = true
end event

event constructor;call super::constructor;is_dwform  = 'form'			// tabular, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert;// Ancestor Script has been Override

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
	this.SetColumn('fec_registro')
	THIS.SetFocus()						// poner el focus en el primer campo
END IF

RETURN ll_row

end event

event ue_insert_pre;call super::ue_insert_pre;Date 		ld_fecha
string	ls_nro_parte
Boolean	lb_ret
Integer	li_ano, li_semana

is_action = 'new'

ld_fecha = date(f_fecha_actual())

this.object.nro_parte			[al_row] = ls_nro_parte
this.object.fec_registro		[al_row] = f_fecha_actual()
this.object.fec_parte_lav		[al_row] = f_fecha_actual()
this.object.flag_estado			[al_row]	= '1'
this.object.cod_usr 				[al_row] = gs_user

lb_ret = f_get_semana( ld_fecha, li_ano, li_semana )
		
if lb_ret = FALSE then
	SetNull(li_ano)
	SetNull(li_semana)
	MessageBox('PRODUCCIÓN', 'NO EXISTE FECHA EN MAESTRO DE SEMANAS DE PRODUCCIÓN',StopSign!)
end if
		
this.object.ano	[al_row] = li_ano
this.object.semana[al_row] = li_semana

dw_detail.reset( )
dw_ratios.reset( )



end event

event doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
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

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data
Date 		ld_fecha
Integer	li_ano, li_semana
Long		ll_count
Boolean	lb_ret

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	CASE "FECHA_PARTE"
		
		ld_fecha = Date(this.object.fecha_parte[row])
		lb_ret = f_get_semana( ld_fecha, li_ano, li_semana )
		
		if lb_ret = FALSE then
			SetNull(li_ano)
			SetNull(li_semana)
			MessageBox('PRODUCCIÓN', 'NO EXISTE FECHA EN MAESTRO DE SEMANAS',StopSign!)
		end if
		
		this.object.ano	[row] = li_ano
		this.object.semana[row] = li_semana

	case "COD_MONEDA"
		
		ls_codigo = this.object.cod_moneda[row]

		SetNull(ls_data)
		select descripcion
			into :ls_data
		from moneda
		where cod_moneda = :ls_codigo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "CODIGO DE MONEDA NO EXISTE", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_moneda [row] = ls_codigo
			this.object.desc_moneda[row] = ls_codigo
			return 1
		end if

		this.object.desc_moneda[row] = ls_data

	case "PROVEEDOR"
		ls_codigo = this.object.proveedor[row]

		SetNull(ls_data)
		select NOM_PROVEEDOR
			into :ls_data
		from PROVEEDOR
		where PROVEEDOR = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCIÓN', "PROVEEDOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.proveedor 	  	  [row] = ls_codigo
			this.object.nom_proveedor	  [row] = ls_codigo
			return 1
		end if

		this.object.nom_proveedor		  [row] = ls_data
		
end choose
end event

event ue_delete;// Ancestor Script has been Override
long ll_row 

ib_insert_mode = False

//dw_detail.event ue_delete_all( )
//dw_ratios.event ue_delete_all( )

return 1

ll_row = THIS.DeleteRow (0)
IF ll_row = -1 then
	messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
ELSE
	il_totdel ++
	ii_update = 1								// indicador de actualizacion pendiente
	THIS.Event Post ue_delete_pos()
END IF

RETURN ll_row

end event

type gb_1 from groupbox within w_pr325_lavado_ropa
integer x = 1344
integer y = 620
integer width = 1010
integer height = 220
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
borderstyle borderstyle = styleraised!
end type

type gb_2 from groupbox within w_pr325_lavado_ropa
integer x = 2377
integer y = 696
integer width = 1102
integer height = 152
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 134217739
string text = "Cambiar Nro. De Orden y Opersec"
end type

type r_1 from rectangle within w_pr325_lavado_ropa
integer linethickness = 1
long fillcolor = 12632256
integer y = 12
integer width = 2368
integer height = 100
end type

type r_2 from rectangle within w_pr325_lavado_ropa
integer linethickness = 1
long fillcolor = 12632256
integer x = 2373
integer y = 12
integer width = 1774
integer height = 100
end type

