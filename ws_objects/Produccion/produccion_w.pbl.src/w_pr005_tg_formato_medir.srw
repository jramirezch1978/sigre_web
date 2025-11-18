$PBExportHeader$w_pr005_tg_formato_medir.srw
forward
global type w_pr005_tg_formato_medir from w_abc_master
end type
type st_master from statictext within w_pr005_tg_formato_medir
end type
type dw_detail from u_dw_abc within w_pr005_tg_formato_medir
end type
type st_detail from statictext within w_pr005_tg_formato_medir
end type
type st_nro from statictext within w_pr005_tg_formato_medir
end type
type sle_nro from singlelineedit within w_pr005_tg_formato_medir
end type
type cb_1 from commandbutton within w_pr005_tg_formato_medir
end type
type ist_1 from statictext within w_pr005_tg_formato_medir
end type
type hpb_1 from hprogressbar within w_pr005_tg_formato_medir
end type
type dw_carga_parte from datawindow within w_pr005_tg_formato_medir
end type
type st_3 from statictext within w_pr005_tg_formato_medir
end type
type em_ot_adm from singlelineedit within w_pr005_tg_formato_medir
end type
type pb_1 from picturebutton within w_pr005_tg_formato_medir
end type
type sle_nro_version from editmask within w_pr005_tg_formato_medir
end type
type dw_carga_cabecera_formato from datawindow within w_pr005_tg_formato_medir
end type
type sle_nro_ver_c from editmask within w_pr005_tg_formato_medir
end type
end forward

global type w_pr005_tg_formato_medir from w_abc_master
integer width = 5600
integer height = 2572
string title = "Formatos de Medición(PR005)"
string menuname = "m_mtto_impresion"
st_master st_master
dw_detail dw_detail
st_detail st_detail
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
ist_1 ist_1
hpb_1 hpb_1
dw_carga_parte dw_carga_parte
st_3 st_3
em_ot_adm em_ot_adm
pb_1 pb_1
sle_nro_version sle_nro_version
dw_carga_cabecera_formato dw_carga_cabecera_formato
sle_nro_ver_c sle_nro_ver_c
end type
global w_pr005_tg_formato_medir w_pr005_tg_formato_medir

type variables

// Para el registro del Log
string 	is_tabla_m, is_colname_m[], is_coltype_m[], &
			is_tabla_v, is_colname_v[], is_coltype_v[], is_formato, &				
		   maquina,		atributo, flag_replicacion, flag_estado, desc_cabecera, &
			desc_unidad, descripcion, tipo_dato, is_flag_visible, atributo_niv3, atributo_niv4
			
dec	medicion_min,	medicion_max

Integer ii_copia, nro_atributo, nro_item, nro_version

end variables

forward prototypes
public function integer of_nro_item (datawindow adw_pr)
public subroutine of_retrieve (string as_formato, integer ai_nro_version)
public function integer of_nro_atributo (datawindow adw_pr)
public function integer of_set_status_copia (datawindow idw)
end prototypes

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_item[li_x] THEN
		li_item = adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public subroutine of_retrieve (string as_formato, integer ai_nro_version);String ls_orientacion

select P.ORIENTACION
  into :ls_orientacion
  from TG_FMT_MED_ACT P
 where P.FORMATO     = :as_formato
   AND p.NRO_VERSION = :ai_nro_version;

     IF     ls_orientacion = '2' then 
	         dw_detail.dataobject = 'd_fmt_med_det_tbl'
			   dw_detail.settransobject(sqlca)
	     ELSEIF ls_orientacion = '3' THEN
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_3_tbl'
			   dw_detail.settransobject(sqlca)
	  ELSEIF ls_orientacion = '4' then
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_4_tbl'
			   dw_detail.settransobject(sqlca)
		END IF
		

dw_master.Retrieve(as_formato, ai_nro_version)
dw_detail.Retrieve(as_formato, ai_nro_version)

dw_master.ii_protect = 0
dw_detail.ii_protect = 0

dw_master.of_protect( )
dw_detail.of_protect( )

dw_master.ii_update = 0
dw_detail.ii_update = 0

dw_master.object.p_logo.filename = gs_logo

is_action = 'open'
end subroutine

public function integer of_nro_atributo (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x = 1 to adw_pr.RowCount()
	IF li_item < adw_pr.object.nro_atributo[li_x] THEN
		li_item = adw_pr.object.nro_atributo[li_x]
	END IF
Next

Return li_item + 1
end function

public function integer of_set_status_copia (datawindow idw);//Int 	li_estado, li_count, li_nro_version, li_flag_estado
//long	ll_row, ll_master
//String ls_est_det, ls_formato
//
//This.changemenu(m_mtto_impresion)
//
//m_master.m_file.m_basedatos.m_insertar.enabled 		= f_niveles( is_niveles, 'I')  // true
//m_master.m_file.m_basedatos.m_eliminar.enabled 		= f_niveles( is_niveles, 'E')  //true
//m_master.m_file.m_basedatos.m_modificar.enabled 	= f_niveles( is_niveles, 'M') 
//m_master.m_file.m_basedatos.m_anular.enabled 		= True
//m_master.m_file.m_basedatos.m_abrirlista.enabled 	= True
//m_master.m_file.m_basedatos.m_cancelar.enabled 		= True
//
//IF dw_master.getrow() = 0 THEN RETURN 0
//IF dw_detail.getrow() = 0 THEN RETURN 0
//
//ll_master = dw_master.getrow( )
//
//IF is_Action = 'new' THEN
//	// Activa desactiva opcion de modificacion, eliminacion	
//	m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= False
//	m_master.m_file.m_basedatos.m_anular.enabled 		= False
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
//	
//	IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
//		m_master.m_file.m_basedatos.m_insertar.enabled = False
//	ELSE
//		m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
//		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')
//	END IF	
//END IF
//
//IF is_Action = 'open' THEN
//
//	ls_formato	 	= dw_master.object.formato 				[ll_master]
//	li_flag_estado = integer(dw_master.object.flag_estado [ll_master])
//	li_nro_version = dw_master.object.nro_version			[ll_master]
//
//	IF	dw_master.ii_update = 1 THEN
//		Messagebox('Modulo de Producciòn', 'Para Pasar al Detalle Primero debe de Grabar la Cabecera')	
//		dw_detail.reset( )
//	Return 0
//	END IF
//
//if li_flag_estado = 0 then
//	messagebox('Modulo de Producción','Este Formato ya ha sido Anulado.~r~No puede hacer modificaciones')
//	dw_detail.retrieve( ls_formato, li_nro_version)
//		if dw_detail.ii_protect = 0 then
//			dw_detail.of_protect( )
//		else
//			dw_detail.ii_protect = 1
//		end if
//		m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
//		m_master.m_file.m_basedatos.m_modificar.enabled 	= False
//		m_master.m_file.m_basedatos.m_anular.enabled 		= False
//		m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
//	
//	IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
//		m_master.m_file.m_basedatos.m_insertar.enabled = False
//	ELSE
//		m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
//		m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')
//	END IF	
//	return 0
//end if
//
//SELECT COUNT(P.FORMATO)
//  into :li_count
//  FROM TG_FMT_MED_ACT      F,
//       TG_PARTE_PISO       P,
//       TG_PARTE_PISO_DET 	PD,
//       TG_FMT_MED_ACT_DET  FD
//       	 
// WHERE P.FORMATO      = F.FORMATO
//   AND F.FORMATO      = FD.FORMATO
//   AND FD.FORMATO     = PD.FORMATO
//   AND FD.NRO_ITEM    = PD.NRO_ITEM
//   AND P.FLAG_ESTADO  = '1'
//   AND PD.NRO_PARTE   = P.NRO_PARTE
//   AND P.FORMATO      = :ls_formato
//	AND P.NRO_VERSION  = :li_nro_version;
//
//if li_count > 0 then
//	messagebox('Modulo de Producción','El Formato ya ha sido Utilizado en un Parte de Piso. ~r~Si deseas hacer cambios, primero debe de eliminar el Parte de Piso o Crear un Formato Nuevo')
//	dw_detail.retrieve( ls_formato, li_nro_version)
//
//	if dw_detail.ii_protect = 0 then
//		dw_detail.of_protect( )
//	else
//		dw_detail.ii_protect = 1
//	end if
//	
//		m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
//		m_master.m_file.m_basedatos.m_modificar.enabled 	= False
//		m_master.m_file.m_basedatos.m_anular.enabled 		= False
//		m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
//	
//		IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
//			m_master.m_file.m_basedatos.m_insertar.enabled = False
//		ELSE
//			m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
//			m_master.m_file.m_basedatos.m_eliminar.enabled = f_niveles( is_niveles, 'E')
//		END IF	
//	return 0
//end if
//
//	IF li_flag_estado = 0 THEN // Anulado			
//			m_master.m_file.m_basedatos.m_eliminar.enabled 	= False
//			m_master.m_file.m_basedatos.m_modificar.enabled = False
//			m_master.m_file.m_basedatos.m_anular.enabled 	= False
//	END IF
//		
//		IF idw = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento			
//			m_master.m_file.m_basedatos.m_insertar.enabled = f_niveles( is_niveles, 'I')
//		ELSE			
//			m_master.m_file.m_basedatos.m_insertar.enabled = False
//		END IF
//	
//	IF idw = dw_detail THEN
//		ll_row = idw.getrow()
//		m_master.m_file.m_basedatos.m_modificar.enabled = f_niveles( is_niveles, 'M')
//	END IF			
//
//END IF
//
//IF is_Action = 'anu' THEN	
//	m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
//	m_master.m_file.m_basedatos.m_modificar.enabled 	= False
//	m_master.m_file.m_basedatos.m_anular.enabled 		= False
//	m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
//	m_master.m_file.m_basedatos.m_insertar.enabled 		= False	
//
//END IF
//
RETURN 1

end function

on w_pr005_tg_formato_medir.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_impresion" then this.MenuID = create m_mtto_impresion
this.st_master=create st_master
this.dw_detail=create dw_detail
this.st_detail=create st_detail
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.ist_1=create ist_1
this.hpb_1=create hpb_1
this.dw_carga_parte=create dw_carga_parte
this.st_3=create st_3
this.em_ot_adm=create em_ot_adm
this.pb_1=create pb_1
this.sle_nro_version=create sle_nro_version
this.dw_carga_cabecera_formato=create dw_carga_cabecera_formato
this.sle_nro_ver_c=create sle_nro_ver_c
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_master
this.Control[iCurrent+2]=this.dw_detail
this.Control[iCurrent+3]=this.st_detail
this.Control[iCurrent+4]=this.st_nro
this.Control[iCurrent+5]=this.sle_nro
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.ist_1
this.Control[iCurrent+8]=this.hpb_1
this.Control[iCurrent+9]=this.dw_carga_parte
this.Control[iCurrent+10]=this.st_3
this.Control[iCurrent+11]=this.em_ot_adm
this.Control[iCurrent+12]=this.pb_1
this.Control[iCurrent+13]=this.sle_nro_version
this.Control[iCurrent+14]=this.dw_carga_cabecera_formato
this.Control[iCurrent+15]=this.sle_nro_ver_c
end on

on w_pr005_tg_formato_medir.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_master)
destroy(this.dw_detail)
destroy(this.st_detail)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.ist_1)
destroy(this.hpb_1)
destroy(this.dw_carga_parte)
destroy(this.st_3)
destroy(this.em_ot_adm)
destroy(this.pb_1)
destroy(this.sle_nro_version)
destroy(this.dw_carga_cabecera_formato)
destroy(this.sle_nro_ver_c)
end on

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'TG_FMT_MED_ACT'
//is_tabla_m = 'TG_FMT_ACT_DET'

dw_detail.SetTransObject(sqlca)	// Relacionar el dw con la base de datos
dw_carga_parte.SettransObject( sqlca)
dw_carga_cabecera_formato.SettransObject( sqlca)

dw_detail.ii_protect = 0
dw_detail.of_protect()         		// bloquear modificaciones 

end event

event ue_update;// Ancestor Script has been Override
Boolean  lbo_ok = TRUE
String	ls_msg, ls_nro_emb

dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_Create_log()
	dw_detail.of_Create_log()
END IF

// Grabo el Log del detalle

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
		MessageBox('Error en Base de Datos', 'No se pudo grabar Detalle')
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		dw_master.of_save_log()
		dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;

	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	
	dw_master.ii_protect = 0
	dw_detail.ii_protect = 0

	dw_master.of_protect( )
	dw_detail.of_protect( )
	is_action = 'open'
	
END IF


end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False
// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_detail, "tabular") <> true then return

dw_master.of_set_flag_replicacion()
dw_detail.of_set_flag_replicacion()

is_action = 'new'
	
ib_update_check = true
end event

event ue_query_retrieve;//Override

String 	ls_formato
Integer	li_nro_version

ls_formato 		= trim(sle_nro.text)
li_nro_version	= integer(trim(sle_nro_version.text))

if ls_formato = '' or isnull(ls_formato) then
	Messagebox("Modulo de Producción","Defina el Formato de Medición que desea buscar")
	return
end if

if isnull(string(li_nro_version)) then
	Messagebox("Modulo de Producción","Defina el Nro. de Version del Formato de Medición que desea buscar")
	return
end if
	
string   ls_os, ls_os_1, ls_mensaje

select 	formato
	into 	:ls_os
from 		tg_fmt_med_act
	where	formato = :ls_formato;	

IF SQLCA.sqlcode 	<> 0 THEN
	ls_mensaje 		= "Modulo de Producciòn: EL Formato de Medicioón no ha sido definido" + SQLCA.SQLErrText
	MessageBox('SQL error', ls_mensaje, StopSign!)	
	return
else
	  This.of_retrieve( ls_formato, li_nro_version )
end if


end event

event ue_list_open;//override
// Asigna valores a structura
Integer	li_nro_version

str_parametros sl_param

sl_param.dw1    = 'ds_formato_med_tbl'
sl_param.titulo = 'Formatos de Medición'
sl_param.field_ret_i[1] = 1	//Formato de Medición
sl_param.field_ret_i[2] = 2	//Version del Formato de Medición

OpenWithParm( w_lista, sl_param )

sl_param = Message.PowerObjectParm

IF sl_param.titulo <> 'n' THEN
	of_retrieve(sl_param.field_ret[1], integer(sl_param.field_ret[2]))
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

event ue_modify;dw_master.of_protect( )
dw_detail.of_protect( )

long 		ll_row, ll_master
Integer 	li_count, li_flag_estado
String  	ls_formato_1, ls_flag_estado

ll_master = dw_master.getrow( )

if ll_master < 1 then return

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Formato ya ha sido Anulado.~r~No puede hacerle modificaciones')
//dw_master.of_protect( )
dw_detail.of_protect( )
RETURN
END IF
end event

event ue_anular;call super::ue_anular;long 		ll_row, ll_master
Integer 	li_count, li_nro_version
String  	ls_formato_1, ls_flag_estado

ll_master = dw_master.getrow( )

if ll_master = 0 then return

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso', 'EL Parte de Raciones ya esta anulada, no puedes anularla')
	RETURN
END IF

IF MessageBox('Aviso', 'Esta seguro de anular el Formato de Medición', Information!, YesNo!, 2) = 2 THEN RETURN

dw_master.object.flag_estado[dw_master.GetRow()] = '0'
dw_master.ii_update = 1

is_action = 'anular'


end event

event ue_delete;//Override
long 		ll_row, ll_master
Integer 	li_count, li_nro_version
String  	ls_formato_1, ls_flag_estado

IF dw_master.object.flag_estado[dw_master.GetRow()] = '0' THEN
	MessageBox('Aviso','Este Formato ya ha sido Anulado.~r~No puede hacerle modificaciones')
	RETURN
END IF

ll_master = dw_master.getrow( )

if ll_master < 1 then return

	ls_formato_1 	= dw_master.object.formato 		[ll_master]
	li_nro_version = dw_master.object.nro_version	[ll_master]

SELECT COUNT(P.FORMATO)
  into :li_count
  FROM TG_FMT_MED_ACT     	F,
       TG_PARTE_PISO      	P,
       TG_PARTE_PISO_DET 	PD,
       TG_FMT_MED_ACT_DET 	FD
       	 
 WHERE P.FORMATO      = F.FORMATO
   AND F.FORMATO      = FD.FORMATO
   AND FD.FORMATO     = PD.FORMATO
   AND FD.NRO_ITEM    = PD.NRO_ITEM
   AND P.FLAG_ESTADO  = '1'
   AND PD.NRO_PARTE   = P.NRO_PARTE
   AND P.FORMATO      = :ls_formato_1;

if li_count > 0 then
	messagebox('Modulo de Producción','Este Formato ya ha sido Utilizado en un Parte de Piso. ~r~ No puede hacerle modificaciones.~r~ Si deseas hacer cambios primero debes de eliminar los Partes o Crear un Nuevo Formato')
	dw_detail.retrieve( ls_formato_1, li_nro_version)
	dw_master.ii_protect = 1
	if dw_detail.ii_protect = 0 then
			dw_detail.of_protect( )
		else
			dw_detail.ii_protect = 1
		end if
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

event resize;//Override
dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

type dw_master from w_abc_master`dw_master within w_pr005_tg_formato_medir
event ue_display ( string as_columna,  long al_row )
integer x = 14
integer y = 324
integer width = 4576
integer height = 644
string dataobject = "d_pr_formato_de_medicion_ff"
boolean vscrollbar = true
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

choose case upper(as_columna)
		
		case "COD_LABOR"

		ls_sql = "SELECT COD_LABOR AS CODIGO_LABOR, " &
				  + "DESC_LABOR AS DESCRIPCION " &
				  + "FROM LABOR " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor		[al_row] = ls_codigo
			this.object.desc_labor		[al_row] = ls_data
			this.ii_update = 1
		end if

case "TIPO_FORMATO"

		ls_sql = "SELECT TIPO_FORMATO AS CODIGO, " &
				  + "DESC_TIPO_FORMATO AS DESCRIPCION " &
				  + "FROM TG_TIPO_FORMATO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.tipo_formato				[al_row] = ls_codigo
			this.object.desc_tipo_formato			[al_row] = ls_data
			this.ii_update = 1
		end if
			
	case "APROBADOR"

		ls_sql = "SELECT a.aprobador as Codigo, " &
				  + "u.nombre as Nombre "&
				  + "FROM usuario u, aprob_parte_piso a "&
				  + "WHERE a.FLAG_ESTADO = '1' and u.cod_usr = a.aprobador"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.aprobador			[al_row] = ls_codigo
			this.ii_update = 1
		end if
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'md'		// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
	                        
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle


idw_mst  = 				dw_master
idw_det  =  			dw_detail
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_formato
Long		ll_count
integer	li_item, li_nro_version

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
		
	case "cod_labor"
		
		ls_codigo = this.object.cod_labor[row]

		SetNull(ls_data)
		select desc_labor
			into :ls_data
		from labor
		where cod_labor = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Labor no existe o no esta definida", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_labor	  	[row] = ls_codigo
			this.object.desc_labor		[row] = ls_codigo
			return 1
		end if

		this.object.desc_labor			[row] = ls_data
		
case "tipo_formato"
		
		ls_codigo = this.object.tipo_formato[row]

		SetNull(ls_data)
		select desc_tipo_formato
			into :ls_data
		from tg_tipo_formato
		where tipo_formato = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Tipo de Formato no existe o no ha sido definido", StopSign!)
			SetNull(ls_codigo)
			this.object.tipo_formato	  		[row] = ls_codigo
			this.object.desc_tipo_formato		[row] = ls_codigo
			return 1
		end if
		this.object.desc_tipo_formato			[row] = ls_data
		
  CASE "niveles"
	 
	ls_formato     = this.object.formato [row]
	li_nro_version = this.object.nro_version [row]
	 	
	  IF     data = '2' then 
	         dw_detail.dataobject = 'd_fmt_med_det_tbl'
			   dw_detail.settransobject(sqlca)
				dw_detail.Retrieve(ls_formato, li_nro_version)
     ELSEIF data = '3' THEN
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_3_tbl'
			   dw_detail.settransobject(sqlca)
				dw_detail.Retrieve(ls_formato, li_nro_version)
	  ELSEIF data = '4' then
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_4_tbl'
			   dw_detail.settransobject(sqlca)
				dw_detail.Retrieve(ls_formato, li_nro_version)
		END IF
		
	
end choose
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fecha_formato				[al_row] = f_fecha_actual()
this.object.p_logo.filename 					   = gs_logo

dw_detail.reset()

//if ii_copia = 1 then
//
//   this.object.cod_labor		  [al_row] = is_cod_labor
//	this.object.descripcion 	  [al_row] = is_desc
//	this.object.flag_estado		  [al_row] = is_flag_estado
//	this.object.flag_replicacion [al_row] = is_flag_replicacion
//	this.object.tipo_formato	  [al_row] = is_tipo_formato
//	this.object.aprobador	     [al_row] = is_aprobador
//	this.object.niveles  	     [al_row] = is_orientacion
//	this.object.fecha_formato 	  [al_row] = id_fecha_formato
//	
//END IF

is_action = 'new'


end event

type st_master from statictext within w_pr005_tg_formato_medir
integer x = 14
integer y = 216
integer width = 3072
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Formatos de Medición - Cabecera"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within w_pr005_tg_formato_medir
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 1064
integer width = 4585
integer height = 1268
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_fmt_med_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor, ls_return1, ls_return2, ls_return3, ls_return4
			
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)

	case 'COD_MAQUINA'
		
		ls_sql = "select cod_maquina as codigo, " & 
					+ "desc_maq as descripcion " &
					+ "from maquina " &
					+ "where flag_estado = '1'"
	
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_maquina			[al_row] = ls_codigo
			this.object.desc_cabecera		[al_row] = ls_data
			this.ii_update = 1
		end if

	case 'ATRIBUTO'
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion, desc_unidad as medida, tipo_dato from vw_tg_atrib_und"
		
		f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.atributo					[al_row] = ls_return1
		this.object.descripcion_nivel2	[al_row] = ls_return2
		this.object.desc_un2		         [al_row] = ls_return3
		this.object.tipo_dato_2 		   [al_row] = ls_return4
		this.ii_update = 1
	
   case 'ATRIBUTO_NIV3'
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion, desc_unidad as medida, tipo_dato from vw_tg_atrib_und"
		
		f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.atributo_niv3			[al_row] = ls_return1
		this.object.description_nivel3	[al_row] = ls_return2
		this.object.desc_un3 		      [al_row] = ls_return3
		this.object.tipo_dato_3		      [al_row] = ls_return4
		this.ii_update = 1
	
   case 'ATRIBUTO_NIV4'
		
		ls_sql = "select atrib_cod as codigo, atrib_desc as descripcion, desc_unidad as medida, tipo_dato from vw_tg_atrib_und"
		
		f_lista_4ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, '2')
		
		if isnull(ls_return1) or trim(ls_return1) = '' then return
		
		this.object.atributo_niv4      [al_row] = ls_return1
		this.object.description_nivel4 [al_row] = ls_return2
		this.object.desc_un4 		    [al_row] = ls_return3
		this.object.tipo_dato_4		    [al_row] = ls_return4
		this.ii_update = 1
end choose
end event

event constructor;call super::constructor;//is_mastdet = 'd'		   // 'm' = master sin detalle (default), 'd' =  detalle,
	                     //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1]  = 1			// columnas de lectrua de este dw
//ii_ck[2]  = 12			// columnas de lectrua de este dw
ii_rk[1]  = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master
idw_det  =  			dw_detail

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

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_und, ls_tipo_dato
Long		ll_count
integer	li_item

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
						
	case "cod_maquina"
		
		ls_codigo = this.object.cod_maquina[row]

		SetNull(ls_data)
		select desc_maq
			into :ls_data
		from maquina
		where cod_maquina = :ls_codigo
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Maquina no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_maquina	  		[row] = ls_codigo
			this.object.desc_cabecera		[row] = ls_codigo
			return 1
		end if

		this.object.desc_cabecera		[row] = ls_data
		
	case "atributo"
		
		ls_codigo = this.object.atributo[row]

		SetNull(ls_data)
		select 	atrib_desc, desc_unidad, tipo_dato
			into 	:ls_data, :ls_und, :ls_tipo_dato
			from 	vw_tg_atrib_und
		  where 	atrib_cod = :ls_codigo;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Atributo no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.atributo	  		          [row] = ls_codigo
			this.object.descripcion_nivel2       [row] = ls_codigo
			this.object.tipo_dato_2		          [row] = ls_codigo
			return 1
		end if
		this.object.descripcion_nivel2 	[row] = ls_data
		this.object.desc_un2        		[row] = ls_und
		this.object.tipo_dato_2		    	[row] = ls_tipo_dato
		
	case "atributo_niv3"
		
		ls_codigo = this.object.atributo_niv3[row]

		SetNull(ls_data)
		select 	atrib_desc, desc_unidad, tipo_dato
			into 	:ls_data, :ls_und, :ls_tipo_dato
			from 	vw_tg_atrib_und
		  where 	atrib_cod = :ls_codigo;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Atributo no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.atributo_niv3	          [row] = ls_codigo
			this.object.description_nivel3       [row] = ls_codigo
			this.object.tipo_dato_3		          [row] = ls_codigo
			return 1
		end if
		this.object.description_nivel3 	[row] = ls_data
		this.object.desc_un3        		[row] = ls_und
		this.object.tipo_dato_3		    	[row] = ls_tipo_dato
		
	case "atributo_niv4"
		
		ls_codigo = this.object.atributo_niv4[row]

		SetNull(ls_data)
		select 	atrib_desc, desc_unidad, tipo_dato
			into 	:ls_data, :ls_und, :ls_tipo_dato
			from 	vw_tg_atrib_und
		  where 	atrib_cod = :ls_codigo;
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Atributo no existe o no esta activo", StopSign!)
			SetNull(ls_codigo)
			this.object.atributo_niv4	          [row] = ls_codigo
			this.object.description_nivel4       [row] = ls_codigo
			this.object.tipo_dato_4		          [row] = ls_codigo
			return 1
		end if
		this.object.description_nivel4 	[row] = ls_data
		this.object.desc_un4        		[row] = ls_und
		this.object.tipo_dato_4		    	[row] = ls_tipo_dato
		
end choose
		
end event

event itemerror;call super::itemerror;RETURN 1
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

event ue_insert_pre;call super::ue_insert_pre;long 		ll_row, ll_master
Integer 	li_count, li_nro_version
String  	ls_flag_estado, ls_formato, li_nivel

ll_master 		= dw_master.getrow( )

ls_formato	 	= dw_master.object.formato 		[ll_master]
ls_flag_estado = dw_master.object.flag_estado 	[ll_master]
li_nro_version = dw_master.object.nro_version	[ll_master]

if ii_copia = 1 then
	
   this.object.formato	[al_row] = ls_formato
   li_nivel = dw_master.object.niveles	[ll_master]
	 	
	  IF li_nivel = '2' then 
		  this.object.formato		 		[al_row] = is_formato
		  this.object.nro_version 			[al_row] = nro_version
		  this.object.cod_maquina		 	[al_row] = maquina
		  this.object.atributo		 		[al_row] = atributo
		  this.object.medicion_min	 		[al_row] = medicion_min
		  this.object.medicion_max	   	[al_row] = medicion_max
		  this.object.flag_replicacion 	[al_row] = flag_replicacion
		  this.object.nro_atributo	 		[al_row] = nro_atributo
		  this.object.flag_estado		 	[al_row] = flag_estado
		  this.object.desc_cabecera		[al_row] = desc_cabecera
		  this.object.desc_un2		 		[al_row] = desc_unidad
		  this.object.descripcion_nivel2 [al_row] = descripcion
		  this.object.tipo_dato_2	 		[al_row] = tipo_dato
		  this.object.nro_item	 			[al_row] = nro_item
		  this.object.flag_visible			[al_row] = is_flag_visible

     ELSEIF li_nivel = '3' THEN
			this.object.formato		 			[al_row] = is_formato
			this.object.nro_version 			[al_row] = nro_version
			this.object.cod_maquina		 		[al_row] = maquina
			this.object.atributo		 			[al_row] = atributo
			this.object.medicion_min	 		[al_row] = medicion_min
			this.object.medicion_max	   	[al_row] = medicion_max
			this.object.flag_replicacion 		[al_row] = flag_replicacion
			this.object.nro_atributo	 		[al_row] = nro_atributo
			this.object.flag_estado		 		[al_row] = flag_estado
			this.object.desc_cabecera		 	[al_row] = desc_cabecera
			this.object.desc_un2		 		   [al_row] = desc_unidad
			this.object.descripcion_nivel2   [al_row] = descripcion
			this.object.tipo_dato_2	 			[al_row] = tipo_dato
			this.object.nro_item	 				[al_row] = nro_item
			this.object.flag_visible			[al_row] = is_flag_visible
			this.object.atributo_niv3			[al_row] = atributo_niv3

	  ELSEIF li_nivel = '4' then
		   this.object.formato		 			[al_row] = is_formato
			this.object.nro_version 			[al_row] = nro_version
			this.object.cod_maquina		 		[al_row] = maquina
			this.object.atributo		 			[al_row] = atributo
			this.object.medicion_min	 		[al_row] = medicion_min
			this.object.medicion_max	   	[al_row] = medicion_max
			this.object.flag_replicacion 		[al_row] = flag_replicacion
			this.object.nro_atributo	 		[al_row] = nro_atributo
			this.object.flag_estado		 		[al_row] = flag_estado
			this.object.desc_cabecera		 	[al_row] = desc_cabecera
			this.object.desc_un2		 		   [al_row] = desc_unidad
			this.object.descripcion_nivel2   [al_row] = descripcion
			this.object.tipo_dato_2	 			[al_row] = tipo_dato
			this.object.nro_item	 				[al_row] = nro_item
			this.object.flag_visible			[al_row] = is_flag_visible
			this.object.atributo_niv3			[al_row] = atributo_niv3
			this.object.atributo_niv4			[al_row] = atributo_niv4

		END IF
ELSE

	this.object.formato		[al_row]  				= ls_formato
	this.object.nro_item		[al_row] 				= of_nro_item(this)
	this.object.nro_version [al_row]					= li_nro_version
	this.object.nro_atributo[al_row]					= of_nro_atributo(this)

		if al_row > 1 then
			this.object.cod_maquina   [al_row] = this.object.cod_maquina[al_row - 1]
			this.object.desc_cabecera [al_row] = this.object.desc_cabecera[al_row - 1]
		end if
	
END IF



end event

event ue_insert;//Overriding
long ll_row, ll_master
Integer 	li_count, li_nro_version
String  	ls_flag_estado, ls_formato

ll_master = dw_master.getrow( )
if ll_master < 0 then return 0


ls_formato	 	= dw_master.object.formato 		[ll_master]
ls_flag_estado = dw_master.object.flag_estado 	[ll_master]
li_nro_version = dw_master.object.nro_version	[ll_master]

//IF	dw_master.ii_update = 1 THEN
//Messagebox('Modulo de Producciòn', 'Para Pasar al Detalle Primero debe de Grabar la Cabecera')	
//dw_detail.reset( )
//Return 0
//END IF

if ls_flag_estado = '0' then
	messagebox('Modulo de Producción','Este Formato ya ha sido Anulado.~r~No puede hacer modificaciones')
	dw_detail.retrieve( ls_formato, li_nro_version)
		if dw_detail.ii_protect = 0 then
			dw_detail.of_protect( )
		else
			dw_detail.ii_protect = 1
		end if
		
			m_master.m_file.m_basedatos.m_eliminar.enabled 		= False
			m_master.m_file.m_basedatos.m_modificar.enabled 	= False
			m_master.m_file.m_basedatos.m_anular.enabled 		= False
			m_master.m_file.m_basedatos.m_abrirlista.enabled 	= False
	
		IF idw_1 = dw_master THEN		// Si es master, tiene que estar activo para adicionar otro documento
			m_master.m_file.m_basedatos.m_insertar.enabled = False
		ELSE
			if is_flag_insertar = '1' then
				m_master.m_file.m_basedatos.m_insertar.enabled = true
			else
				m_master.m_file.m_basedatos.m_insertar.enabled = false
			end if

			if is_flag_eliminar = '1' then
				m_master.m_file.m_basedatos.m_eliminar.enabled = true
			else
				m_master.m_file.m_basedatos.m_eliminar.enabled = false
			end if
		END IF	
		
	return 0
end if

SELECT COUNT(P.FORMATO)
  into :li_count
  FROM TG_FMT_MED_ACT      F,
       TG_PARTE_PISO       P,
       TG_PARTE_PISO_DET 	PD,
       TG_FMT_MED_ACT_DET  FD
       	 
 WHERE P.FORMATO      = F.FORMATO
   AND F.FORMATO      = FD.FORMATO
   AND FD.FORMATO     = PD.FORMATO
   AND FD.NRO_ITEM    = PD.NRO_ITEM
   AND P.FLAG_ESTADO  = '1'
   AND PD.NRO_PARTE   = P.NRO_PARTE
   AND P.FORMATO      = :ls_formato
	AND P.NRO_VERSION  = :li_nro_version;

if li_count > 0 then
	messagebox('Modulo de Producción','El Formato ya ha sido Utilizado en un Parte de Piso. ~r~Si deseas hacer cambios, primero debe de eliminar el Parte de Piso o Crear un Formato Nuevo')
	dw_detail.retrieve( ls_formato, li_nro_version)

	if dw_detail.ii_protect = 0 then
			dw_detail.of_protect( )
		else
			dw_detail.ii_protect = 1
		end if
	return 0
end if

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

type st_detail from statictext within w_pr005_tg_formato_medir
integer x = 9
integer y = 984
integer width = 4585
integer height = 68
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Formatos de Medición - Detalle"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type st_nro from statictext within w_pr005_tg_formato_medir
integer x = 18
integer y = 52
integer width = 498
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
string text = "Formato de Medición y Versión"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr005_tg_formato_medir
integer x = 530
integer y = 68
integer width = 539
integer height = 92
integer taborder = 10
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
textcase textcase = upper!
integer limit = 15
borderstyle borderstyle = stylelowered!
end type

event modified;cb_1.event clicked()
end event

type cb_1 from commandbutton within w_pr005_tg_formato_medir
integer x = 1339
integer y = 60
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

event clicked;string 	ls_formato
integer	li_nro_version

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_formato		 = Trim(sle_nro.text)
li_nro_version	 = integer(trim(sle_nro_version.text))

of_retrieve(ls_formato, li_nro_version)

end event

type ist_1 from statictext within w_pr005_tg_formato_medir
integer x = 3081
integer y = 216
integer width = 1509
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Versiones"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type hpb_1 from hprogressbar within w_pr005_tg_formato_medir
boolean visible = false
integer x = 480
integer y = 1284
integer width = 3392
integer height = 84
boolean bringtotop = true
string pointer = "H:\source\CUR\SEARCH.CUR"
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_carga_parte from datawindow within w_pr005_tg_formato_medir
boolean visible = false
integer x = 475
integer y = 1368
integer width = 3415
integer height = 880
integer taborder = 40
boolean bringtotop = true
boolean titlebar = true
string title = "Cargando Detalle del Formato"
string dataobject = "ds_carga_formatos_tbl"
string icon = "DataWindow5!"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type st_3 from statictext within w_pr005_tg_formato_medir
integer x = 2505
integer y = 52
integer width = 521
integer height = 136
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 16777215
long backcolor = 134217729
string text = "Cargar Detalle de Formato"
alignment alignment = center!
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type em_ot_adm from singlelineedit within w_pr005_tg_formato_medir
event dobleclick pbm_lbuttondblclk
integer x = 3049
integer y = 60
integer width = 507
integer height = 92
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
string 	ls_codigo, ls_data, ls_sql, ls_flag_tipo
long 		ll_row, ll_row_d, ll_row_r

if dw_master.RowCount( ) = 0 then return

ll_row	= dw_master.GetRow()
ll_row_d	= dw_detail.GetRow()

ls_flag_tipo = dw_master.object.tipo_formato [dw_master.GetRow()]

if isnull(ls_flag_tipo) or ls_flag_tipo = '' then
	messagebox('Producción', 'Debe de Indicar un Tipo de formato')
	Return
end if

if ll_row_d > 0 then
	messagebox('Producción', 'El FORMATO YA TIENE ASIGNADO UN DETALLE, NO PUEDE PROCEDER')
	return
end if

if ll_row_r > 0 then
	messagebox('Producción', 'El PARTE YA TIENE TARIFAS ASIGNADAS, NO PUEDE PROCEDER')
	return
end if
ls_sql = "SELECT F.FORMATO AS COD_FORMATO, F.DESCRIPCION as DESC_FORMATO "&
			+ "FROM tg_fmt_med_act F "&
			+ "WHERE f.tipo_formato = '" + ls_flag_tipo + "' and f.flag_estado = '1'"	 

lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')	

if ls_codigo <> '' then
	this.text= ls_codigo
end if


end event

type pb_1 from picturebutton within w_pr005_tg_formato_medir
integer x = 3872
integer y = 20
integer width = 256
integer height = 152
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "HyperLink!"
string picturename = "AlignBottom!"
alignment htextalign = right!
vtextalign vtextalign = top!
end type

event clicked;string 	ls_parte_c, ls_nro_parte_new, ls_nivel
datetime ldt_new_fecha
long 		ll_parte_ant, ll_rec, ll_rac_ant, ll_row, ll_row_d, &
			ll_row_r, ll_nwe_nro_version, ll_parte_cab_ant
Integer	ll_nro_version_c

if  dw_master.RowCount( ) = 0 then return

ll_row	= dw_master.GetRow()
ll_row_d	= dw_detail.GetRow()

if ll_row_d > 0 then
	messagebox('Producción', 'El FORMATO YA TIENE DETALLE ASIGNADO, NO PUEDE PROCEDER')
	return
end if

ls_nro_parte_new 		= dw_master.object.formato    [ll_row]
ll_nwe_nro_version	= dw_master.object.nro_version[ll_row]

if ls_nro_parte_new = '' or IsNull(ls_nro_parte_new) then
	MessageBox('Producción', 'Debe indicar un Codigo de formato')
	return
end if

if IsNull(string(ll_nwe_nro_version)) then
	MessageBox('Producción', 'Debe indicar un Nro de version')
	return
end if

ls_parte_c 			= trim(em_ot_adm.text)
ll_nro_version_c  = integer(trim(sle_nro_ver_c.text))

if ls_parte_c = '' or IsNull(ls_parte_c) then
	MessageBox('Producción', 'Debe indicar un Codigo de formato')
	return
end if

Select f.orientacion
  into :ls_nivel
  From tg_fmt_med_act f
 where f.formato 		= :ls_parte_c
   and f.nro_version = :ll_nro_version_c;
	
Update tg_fmt_med_act p
   set p.orientacion = :ls_nivel
 where p.formato 		= :ls_nro_parte_new
   and p.nro_version = :ll_nwe_nro_version;
	 	
	  IF     ls_nivel = '2' then 
	         dw_detail.dataobject = 'd_fmt_med_det_tbl'
			   dw_detail.settransobject(sqlca)
		ELSEIF ls_nivel = '3' THEN
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_3_tbl'
			   dw_detail.settransobject(sqlca)
	  ELSEIF ls_nivel = '4' then
			   dw_detail.dataobject = 'd_fmt_med_det_nivel_4_tbl'
			   dw_detail.settransobject(sqlca)
		END IF
		

DECLARE USP_PR_CARGA_FORMATOS PROCEDURE FOR
	     USP_PR_CARGA_FORMATOS(:ls_parte_c, :ll_nro_version_c, :ls_nro_parte_new, :ll_nwe_nro_version);
EXECUTE USP_PR_CARGA_FORMATOS;
IF sqlca.sqlcode = -1 THEN
		messagebox( "Producción", sqlca.sqlerrtext)
		Return
END IF
CLOSE   USP_PR_CARGA_FORMATOS;

dw_master.retrieve(ls_nro_parte_new, ll_nwe_nro_version)

ll_parte_ant     = dw_carga_parte.retrieve()

IF ll_parte_ant >= 1 THEN 
	dw_carga_parte.visible 	 = TRUE
						 ii_copia = 1
						 
	hpb_1.maxposition        = ll_parte_ant
	hpb_1.visible 				 = TRUE
	
	FOR ll_rec 					 = 1 TO ll_parte_ant
		
		is_formato					= dw_carga_parte.object.formato		   	[1]
		nro_version					= dw_carga_parte.object.nro_version			[1]
		maquina				 		= dw_carga_parte.object.maquina		   	[1]
		atributo		 				= dw_carga_parte.object.atributo	       	[1]
		medicion_min			 	= dw_carga_parte.object.medicion_min	   [1]
		medicion_max				= dw_carga_parte.object.medicion_max      [1]
		flag_replicacion			= dw_carga_parte.object.flag_replicacion  [1]
		nro_atributo				= dw_carga_parte.object.nro_atributo      [1]
		flag_estado   				= dw_carga_parte.object.flag_estado       [1]
		desc_cabecera				= dw_carga_parte.object.desc_cabecera     [1]
		nro_item					   = dw_carga_parte.object.nro_item          [1]
		desc_unidad					= dw_carga_parte.object.desc_unidad       [1]
		is_flag_visible			= dw_carga_parte.object.flag_visible      [1]
		atributo_niv3				= dw_carga_parte.object.atributo_niv3     [1]
		atributo_niv4				= dw_carga_parte.object.atributo_niv4     [1]
		
		dw_carga_parte.deleterow(1)
		dw_detail.event ue_insert()
		hpb_1.position = ll_rec
		
	next
	
	ii_copia = 0
	
   if dw_detail.rowcount( ) <> ll_parte_ant then 
		messagebox('Producción', "No se han copiado correctamente los registros del Formato. Vuelva a intentarlo")
		dw_detail.reset( )
		Return
	end if
	
	hpb_1.visible 					= false
	dw_carga_parte.visible 	   = false
	
end if

end event

type sle_nro_version from editmask within w_pr005_tg_formato_medir
integer x = 1079
integer y = 68
integer width = 210
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean autoskip = true
boolean spin = true
string minmax = "0~~"
end type

event modified;cb_1.event clicked()
end event

type dw_carga_cabecera_formato from datawindow within w_pr005_tg_formato_medir
boolean visible = false
integer x = 3858
integer y = 376
integer width = 411
integer height = 304
integer taborder = 50
boolean bringtotop = true
boolean titlebar = true
string title = "Cargando Detalle del Formato"
string dataobject = "d_carga_cabecera_formato_ff"
string icon = "DataWindow5!"
boolean livescroll = true
borderstyle borderstyle = styleraised!
end type

type sle_nro_ver_c from editmask within w_pr005_tg_formato_medir
integer x = 3575
integer y = 60
integer width = 210
integer height = 96
integer taborder = 20
boolean bringtotop = true
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
string mask = "##0"
boolean autoskip = true
boolean spin = true
string minmax = "0~~"
end type

