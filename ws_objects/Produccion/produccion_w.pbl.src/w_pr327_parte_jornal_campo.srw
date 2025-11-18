$PBExportHeader$w_pr327_parte_jornal_campo.srw
forward
global type w_pr327_parte_jornal_campo from w_abc_mastdet_smpl
end type
type hpb_1 from hprogressbar within w_pr327_parte_jornal_campo
end type
type dw_origen from u_dw_abc within w_pr327_parte_jornal_campo
end type
type sle_ot_adm from singlelineedit within w_pr327_parte_jornal_campo
end type
type st_2 from statictext within w_pr327_parte_jornal_campo
end type
type sle_desc_ot_adm from singlelineedit within w_pr327_parte_jornal_campo
end type
type cb_1 from commandbutton within w_pr327_parte_jornal_campo
end type
type uo_fechas from u_ingreso_rango_fechas_v within w_pr327_parte_jornal_campo
end type
type sle_cod_tra from singlelineedit within w_pr327_parte_jornal_campo
end type
type sle_nom_tra from singlelineedit within w_pr327_parte_jornal_campo
end type
type st_1 from statictext within w_pr327_parte_jornal_campo
end type
type st_procesando from statictext within w_pr327_parte_jornal_campo
end type
type sle_labor from singlelineedit within w_pr327_parte_jornal_campo
end type
type sle_desc_labor from singlelineedit within w_pr327_parte_jornal_campo
end type
type st_3 from statictext within w_pr327_parte_jornal_campo
end type
type st_4 from statictext within w_pr327_parte_jornal_campo
end type
type sle_nom_cuad from singlelineedit within w_pr327_parte_jornal_campo
end type
type sle_cod_cuad from singlelineedit within w_pr327_parte_jornal_campo
end type
type cb_importar from commandbutton within w_pr327_parte_jornal_campo
end type
type sle_desc_ot from singlelineedit within w_pr327_parte_jornal_campo
end type
type sle_nro_ot from singlelineedit within w_pr327_parte_jornal_campo
end type
type st_5 from statictext within w_pr327_parte_jornal_campo
end type
type st_registros from statictext within w_pr327_parte_jornal_campo
end type
type gb_2 from groupbox within w_pr327_parte_jornal_campo
end type
end forward

global type w_pr327_parte_jornal_campo from w_abc_mastdet_smpl
integer width = 5253
integer height = 2984
string title = "[PR327] Parte Jornaleros de Campo"
string menuname = "m_mantto_smpl"
event ue_retrieve ( )
event ue_retrieve_hrs_row ( long al_row )
event ue_retrieve_dw_detail ( long al_row )
event ue_saveas_excel ( )
hpb_1 hpb_1
dw_origen dw_origen
sle_ot_adm sle_ot_adm
st_2 st_2
sle_desc_ot_adm sle_desc_ot_adm
cb_1 cb_1
uo_fechas uo_fechas
sle_cod_tra sle_cod_tra
sle_nom_tra sle_nom_tra
st_1 st_1
st_procesando st_procesando
sle_labor sle_labor
sle_desc_labor sle_desc_labor
st_3 st_3
st_4 st_4
sle_nom_cuad sle_nom_cuad
sle_cod_cuad sle_cod_cuad
cb_importar cb_importar
sle_desc_ot sle_desc_ot
sle_nro_ot sle_nro_ot
st_5 st_5
st_registros st_registros
gb_2 gb_2
end type
global w_pr327_parte_jornal_campo w_pr327_parte_jornal_campo

type variables
string is_ot_adm, is_labor, is_cod_trab, is_ot, is_origen[]
u_ds_base ids_cultivos


end variables

forward prototypes
public function integer of_set_ot (string as_lote, string as_variedad, string as_labor, string as_ot_adm, long al_row)
public function boolean of_calc_hrs_jornal ()
public function integer of_set_variedad (string as_lote, long al_row)
public function integer of_nro_item (date ad_fecha, string as_codtra, long al_row)
public function decimal of_set_hrs_normales (string as_codtra, date ad_fecha, long al_row)
public function boolean of_set_ot_opersec (long al_row)
public function boolean of_set_opersec (long al_row, string as_nro_ot)
public function boolean of_set_labor (long al_row)
public function boolean of_select_origen ()
public function boolean of_validar_save ()
end prototypes

event ue_retrieve();Date		ld_fecha1, ld_fecha2
Long 		ll_row, ll_count
String 	ls_null[], ls_cuadrilla

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

if trim(sle_ot_adm.text) = '' then
	is_ot_adm = '%%'
else
	is_ot_adm = sle_ot_adm.text
end if

is_labor = sle_labor.text
if is_labor = '' then
	is_labor = '%%'
else
	is_labor = sle_labor.text
end if

is_cod_trab = sle_cod_tra.text
if is_cod_trab = '' then 
	is_cod_trab = '%%'
else
	is_cod_trab = trim(is_cod_trab) + '%'
end if

is_ot = sle_nro_ot.text
if is_ot = '' then 
	is_ot = '%%'
else
	is_ot = trim(is_ot) + '%'
end if

if trim(sle_cod_cuad.text) = '' then
	ls_cuadrilla = '%%'
else
	ls_cuadrilla = trim(sle_cod_cuad.text) + '%'
end if

ll_count = 0
is_origen = ls_null
for ll_row = 1 to dw_origen.RowCount()
	if dw_origen.object.chec[ll_row] = '1' then
		ll_count ++
		is_origen[ll_count] = dw_origen.object.cod_origen [ll_row]
	end if
next

if ll_count = 0 then
	MessageBox('Error', 'Debe seleccionar un origen')
	return
end if

dw_master.retrieve(is_ot_adm, is_labor, is_origen, is_cod_trab, is_ot, ls_cuadrilla, ld_fecha1, ld_fecha2, gs_user)
dw_detail.reset( )

st_registros.text = string(dw_master.RowCount()) + ' Registros'
end event

event ue_retrieve_hrs_row(long al_row);string 	ls_codtra
date		ld_fecha
decimal	ldc_jornal_basico, ldc_asign_familiar, ldc_imp_hrs_norm, &
			ldc_imp_hrs_25, ldc_imp_hrs_35, ldc_imp_hrs_noc_35, &
			ldc_imp_hrs_100, ldc_aporte_oblig, ldc_comision_var, &
			ldc_prima_seguro, ldc_aporte_essalud, ldc_imp_dominical, &
			ldc_gratificacion, ldc_bonificacion
Integer	li_nro_item			

//Name              Type         Nullable Default Comments          
//----------------- ------------ -------- ------- ----------------- 
//FECHA             DATE                          fecha             
//COD_TRABAJADOR    CHAR(8)                       cod trabajador    
//COD_LABOR         CHAR(8)      Y                cod labor         
//FLAG_TRAB_GENERAL CHAR(1)               '0'     flag_trab_general 
//HRS_NORMALES      NUMBER(10,2) Y                hrs_normales      
//HRS_EXTRAS_25     NUMBER(10,2) Y                hrs_extras_25     
//HRS_EXTRAS_35     NUMBER(10,2) Y                hrs_extras_35     
//HRS_NOC_EXTRAS_35 NUMBER(10,2) Y                hrs_noc_extras_35 
//HRS_EXTRAS_100    NUMBER(10,2) Y                hrs_extras_100    
//JORNAL_BASICO     NUMBER(10,2) Y                jornal_basico     
//ASIGN_FAMILIAR    NUMBER(10,2) Y                asign_familiar    
//IMP_HRS_NORM      NUMBER(10,2) Y                imp_hrs_norm      
//IMP_HRS_25        NUMBER(10,2) Y                imp_hrs_25        
//IMP_HRS_35        NUMBER(10,2) Y                imp_hrs_35        
//IMP_HRS_NOC_35    NUMBER(10,2) Y                imp_hrs_noc_35    
//IMP_HRS_100       NUMBER(10,2) Y                imp_hrs_100       
//APORTE_OBLIG      NUMBER(10,2) Y                aporte_oblig      
//COMISION_VAR      NUMBER(10,2) Y                comision_var      
//PRIMA_SEGURO      NUMBER(10,2) Y                prima_seguro      
//APORTE_ESSALUD    NUMBER(10,2) Y                aporte_essalud    
//OT_ADM            VARCHAR2(10) Y                ot_adm   
//GRATIFICACION     NUMBER(10,2)          0                         
//BON_GRATIFICACION NUMBER(10,2)          0                         
//OPER_SEC          CHAR(10)     Y                                  


if al_row = 0 then return

ls_codtra 		= dw_master.object.cod_trabajador[al_row]
ld_fecha 		= Date(dw_master.object.fecha		[al_row])
li_nro_item		= Int(dw_master.object.nro_item	[al_row])

select 	JORNAL_BASICO, ASIGN_FAMILIAR, IMP_HRS_NORM,
			IMP_HRS_25, IMP_HRS_35, IMP_HRS_NOC_35,
			IMP_HRS_100, APORTE_OBLIG, COMISION_VAR,
			PRIMA_SEGURO, APORTE_ESSALUD, IMP_DOMINICAL, GRATIFICACION,
			BON_GRATIFICACION
into  :ldc_jornal_basico, :ldc_asign_familiar, :ldc_imp_hrs_norm, 
		:ldc_imp_hrs_25, :ldc_imp_hrs_35, :ldc_imp_hrs_noc_35, 
		:ldc_imp_hrs_100, :ldc_aporte_oblig, :ldc_comision_var, 
		:ldc_prima_seguro, :ldc_aporte_essalud, :ldc_imp_dominical,
		:ldc_gratificacion, :ldc_bonificacion
from pd_jornal_campo
where fecha 			= :ld_fecha
  and cod_trabajador	= :ls_codtra
  and nro_item			= :li_nro_item;

if SQLCA.SQLCode = 100 then
	ldc_jornal_basico 	= 0
	ldc_asign_familiar	= 0
	ldc_imp_hrs_norm		= 0
	ldc_imp_hrs_25			= 0
	ldc_imp_hrs_35			= 0
	ldc_imp_hrs_noc_35	= 0
	ldc_imp_hrs_100		= 0
	ldc_aporte_oblig		= 0
	ldc_comision_var		= 0
	ldc_prima_seguro		= 0
	ldc_aporte_essalud	= 0
	ldc_imp_dominical		= 0
	ldc_gratificacion		= 0
	ldc_bonificacion		= 0
end if

dw_master.object.JORNAL_BASICO		[al_row] = ldc_jornal_basico
dw_master.object.ASIGN_FAMILIAR		[al_row] = ldc_asign_familiar
dw_master.object.IMP_HRS_NORM			[al_row] = ldc_imp_hrs_norm
dw_master.object.IMP_HRS_25			[al_row] = ldc_imp_hrs_25
dw_master.object.IMP_HRS_35			[al_row] = ldc_imp_hrs_35
dw_master.object.IMP_HRS_NOC_35		[al_row] = ldc_imp_hrs_noc_35
dw_master.object.IMP_HRS_100			[al_row] = ldc_imp_hrs_100
dw_master.object.APORTE_OBLIG			[al_row] = ldc_aporte_oblig
dw_master.object.COMISION_VAR			[al_row] = ldc_comision_var
dw_master.object.PRIMA_SEGURO			[al_row] = ldc_prima_seguro
dw_master.object.APORTE_ESSALUD		[al_row] = ldc_aporte_essalud
dw_master.object.IMP_DOMINICAL		[al_row] = ldc_imp_dominical
dw_master.object.GRATIFICACION		[al_row] = ldc_gratificacion
dw_master.object.BON_GRATIFICACION	[al_row] = ldc_bonificacion
		 

end event

event ue_retrieve_dw_detail(long al_row);string 	ls_nro_lote, ls_codtra
decimal	ldc_imp_neto
Date		ld_fecha
Long		ll_row
Integer	li_nro_item

//SQL> desc pd_jornal_campo_lote
//Name           Type         Nullable Default Comments       
//-------------- ------------ -------- ------- -------------- 
//NRO_LOTE       VARCHAR2(20)                  nro_lote       
//IMP_NETO       NUMBER(10,2) Y                imp_neto       
//FECHA          DATE                          fecha          
//COD_TRABAJADOR CHAR(8)                       cod trabajador 
//VARIEDAD       CHAR(12)                      variedad       
//OPER_SEC       CHAR(10)     Y                oper_sec            

if al_row = 0 then return

ls_codtra 		= dw_master.object.cod_trabajador[al_row]
ld_fecha 		= Date(dw_master.object.fecha		[al_row])
li_nro_item		= Int(dw_master.object.nro_item	[al_row])

for ll_row = 1 to dw_detail.RowCount( )
	ls_nro_lote = dw_detail.object.nro_lote [ll_row]
	
	if IsNull(ls_nro_lote) or ls_nro_lote = '' then continue
	
	select 	imp_neto
	into  :ldc_imp_neto
	from pd_jornal_campo_lote
	where fecha 			= :ld_fecha
	  and cod_trabajador	= :ls_codtra
	  and nro_item			= :li_nro_item
	  and nro_lote			= :ls_nro_lote;
	
	if SQLCA.SQLCode = 100 then
		ldc_imp_neto			= 0
	end if
	
	dw_detail.object.imp_neto[ll_row] = ldc_imp_neto
next
end event

event ue_saveas_excel();string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "Hoja de Excel (*.xls),*.xls" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( idw_1, ls_file )
End If
end event

public function integer of_set_ot (string as_lote, string as_variedad, string as_labor, string as_ot_adm, long al_row);string 	ls_nro_ot, ls_oper_sec
integer 	li_year

li_year = year(date(dw_master.object.fecha[dw_master.GetRow()]))

select op.nro_orden, op.oper_sec
	into :ls_nro_ot, :ls_oper_sec
from operaciones 	 op,
	  orden_trabajo ot
where ot.nro_orden  = op.nro_orden
  and ot.lote_campo = :as_lote
  and ot.variedad	  = :as_variedad
  and op.cod_labor  = :as_labor
  and ot.ot_adm	  = :as_ot_adm
  and op.flag_estado = '1'
  and to_number(to_char(op.fec_inicio, 'yyyy')) = :li_year;

if SQLCA.SQLCode = 100 then
	MessageBox('Error', "No existe ninguna operación activa para la "&
				+ "~r~nLabor: " + as_labor &
				+ "~r~nLote: " + as_lote &
				+ "~t~nVariedad: " + as_variedad &
				+ "~t~nOT_ADM: " + as_ot_adm &
				+ "~r~nAño: " + string(li_year))
	return 0
end if

dw_detail.object.nro_orden [al_row] = ls_nro_ot
dw_detail.object.oper_sec 	[al_row] = ls_oper_sec

return 1
end function

public function boolean of_calc_hrs_jornal ();String	ls_mensaje
Date		ld_fecha1, ld_fecha2
long		ll_row, ll_i

try 
	if dw_master.RowCount() = 0 then return true
	ll_row = dw_master.getRow()
	
	ld_fecha1 = Date(dw_master.object.fecha[1])
	ld_fecha2 = Date(dw_master.object.fecha[1])
	
	for ll_i = 1 to dw_master.RowCount()
		if Date(dw_master.object.fecha[ll_i]) < ld_fecha1 then
			ld_fecha1 = Date(dw_master.object.fecha[ll_i])
		end if
		if Date(dw_master.object.fecha[ll_i]) > ld_fecha2 then
			ld_fecha2 = Date(dw_master.object.fecha[ll_i])
		end if
	
	next
	
	if gs_empresa = 'AGROVALKO' then
	
		//create or replace procedure USP_RH_HORAS_JORNAL_CAMPO(
		//		 adi_fecha1 IN DATE,
		//		 adi_fecha2 IN DATE
		//
		//) IS
	
		DECLARE 	USP_RH_HORAS_JORNAL_CAMPO PROCEDURE FOR
					USP_RH_HORAS_JORNAL_CAMPO( :ld_fecha1,
														:ld_fecha2);
		EXECUTE 	USP_RH_HORAS_JORNAL_CAMPO ;
		
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE USP_RH_HORAS_JORNAL_CAMPO: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return false
		END IF
		
		CLOSE USP_RH_HORAS_JORNAL_CAMPO;
		
		commit;
		
	end if
	
	if gnvo_app.of_get_parametro("COSTOS_JORNAL_CAMPO", "1") = "1" then
	
		//CREATE OR REPLACE Procedure USP_RH_JORNAL_CAMPO_COSTO(
		//       adi_fecha1           in DATE,
		//       adi_fecha2           IN DATE
		//) Is
	
		DECLARE 	USP_RH_JORNAL_CAMPO_COSTO PROCEDURE FOR
					USP_RH_JORNAL_CAMPO_COSTO( :ld_fecha1,
														:ld_fecha2);
		EXECUTE 	USP_RH_JORNAL_CAMPO_COSTO ;
		
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE USP_RH_JORNAL_CAMPO_COSTO: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return false
		END IF
		
		CLOSE USP_RH_JORNAL_CAMPO_COSTO;
		
		commit;
	
		
	end if
	
	
	return true

catch ( Exception ex )
	
	gnvo_app.of_catch_exception(ex, '')
	return false
	
end try




end function

public function integer of_set_variedad (string as_lote, long al_row);long ll_count
String ls_codigo, ls_Desc

select count(*)
  into :ll_count
from cultivos
where nro_lote = :as_lote
  and flag_estado ='1';

if ll_count <> 1 then return 0

select a.cod_art, a.desc_art
	into :ls_codigo, :ls_desc
from 	articulo a,
		cultivos c
where c.variedad = a.cod_art
  and c.nro_lote = :as_lote
  and c.flag_estado = '1';

dw_detail.object.variedad 			[al_row] = ls_codigo  
dw_detail.object.desc_variedad 	[al_row] = ls_desc

return 1



end function

public function integer of_nro_item (date ad_fecha, string as_codtra, long al_row);integer li_item = 0, li_row

for li_row = 1 to dw_master.RowCount( )
	
	if Date(dw_master.object.fecha [li_row])= ad_fecha and &
		dw_master.object.cod_trabajador[li_row] = as_codtra and &
		li_row <> al_row then
		
		if li_item < Int(dw_master.object.nro_item[li_row]) then
			li_item = Int(dw_master.object.nro_item[li_row])
		end if
		
	end if
next

li_item ++

return li_item
end function

public function decimal of_set_hrs_normales (string as_codtra, date ad_fecha, long al_row);decimal 	ldc_hrs_totales = 0, ldc_return
Long		ll_row
date		ld_fecha
String 	ls_codtra

for ll_row = 1 to dw_master.RowCount() 
	
	ls_codtra = dw_master.object.cod_trabajador	[ll_row]
	ld_fecha  = Date(dw_master.object.fecha		[ll_row])
	
	if ll_row <> al_row and ls_codtra = as_codtra and ld_fecha = ad_fecha then
		ldc_hrs_totales += Dec(dw_master.object.hrs_normales[ll_row])
	end if
	
next

if ldc_hrs_totales > 8 then
	ldc_return = 0
else
	ldc_return = 8 - ldc_hrs_totales
end if


return ldc_return

end function

public function boolean of_set_ot_opersec (long al_row);String 	ls_ot_adm, ls_labor, ls_null, ls_nro_ot, ls_oper_sec
long		ll_count
date 		ld_fecha

if al_row <= 0 then return true

SetNull(ls_null)

// Esta función asigna el nro de ot y el oper sec a la cabecera del
// parte de jornaleros
ls_ot_adm = dw_master.object.ot_adm [al_row]

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	dw_master.object.cod_labor		[al_row] = ls_null
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar un ot adm")
	dw_master.setColumn( "ot_adm")
	dw_master.setFocus( )
	return false
end if

ls_labor = dw_master.object.cod_labor [al_row]

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar una Labor")
	dw_master.setColumn( "cod_labor")
	dw_master.setFocus( )
	return false
end if

ld_fecha = date(dw_master.object.fecha [al_row])

//busco el opersec necesario para el ot_adm y la labor indicada
select count(*)
	into :ll_count
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and op.cod_labor	= :ls_labor
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

if ll_count = 0 then
	MessageBox('Error', 'No hay operacion aprobada, ni orden de trabajo aprobado para el periodo y labor indicado' &
						+ '~r~nLabor: ' + ls_labor &
						+ '~r~nOT_ADM: ' + ls_ot_adm &
						+ '~r~nPeriodo: ' + string(ld_fecha, 'yyyy'))
	return false
end if

select ot.nro_orden, op.oper_sec
	into :ls_nro_ot, :ls_oper_sec
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and op.cod_labor	= :ls_labor
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

dw_master.object.nro_orden [al_row] = ls_nro_ot
dw_master.object.oper_sec 	[al_row] = ls_oper_sec

return true
end function

public function boolean of_set_opersec (long al_row, string as_nro_ot);String 	ls_ot_adm, ls_labor, ls_null, ls_oper_sec
long		ll_count
date 		ld_fecha

if al_row <= 0 then return true

SetNull(ls_null)

// Esta función asigna el nro de ot y el oper sec a la cabecera del
// parte de jornaleros
ls_ot_adm = dw_master.object.ot_adm [al_row]

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	dw_master.object.cod_labor		[al_row] = ls_null
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar un ot adm")
	dw_master.setColumn( "ot_adm")
	dw_master.setFocus( )
	return false
end if

ls_labor = dw_master.object.cod_labor [al_row]

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar una Labor")
	dw_master.setColumn( "cod_labor")
	dw_master.setFocus( )
	return false
end if

ld_fecha = date(dw_master.object.fecha [al_row])

//busco el opersec necesario para el ot_adm y la labor indicada
select count(*)
	into :ll_count
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and ot.nro_orden	= :as_nro_ot
  and op.cod_labor	= :ls_labor
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

if ll_count = 0 then
	MessageBox('Error', 'No hay operacion aprobada, ni orden de trabajo aprobado para el periodo y labor indicado' &
						+ '~r~nLabor: ' + ls_labor &
						+ '~r~nOT_ADM: ' + ls_ot_adm &
						+ "~r~nNRO_OT: " + as_nro_ot &
						+ '~r~nPeriodo: ' + string(ld_fecha, 'yyyy'))
	return false
end if

select op.oper_sec
	into :ls_oper_sec
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and op.cod_labor	= :ls_labor
  and ot.nro_orden	= :as_nro_ot
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

dw_master.object.oper_sec 	[al_row] = ls_oper_sec

return true
end function

public function boolean of_set_labor (long al_row);String 	ls_ot_adm, ls_trabajador, ls_labor, ls_desc_labor, &
			ls_null, ls_nro_ot, ls_oper_sec
long		ll_count
date 		ld_fecha

if al_row <= 0 then return true

SetNull(ls_null)

// Esta función asigna el nro de ot y el oper sec a la cabecera del
// parte de jornaleros
ls_ot_adm = dw_master.object.ot_adm [al_row]

if IsNull(ls_ot_adm) or ls_ot_adm = '' then
	dw_master.object.cod_labor		[al_row] = ls_null
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar un ot adm")
	dw_master.setColumn( "ot_adm")
	dw_master.setFocus( )
	return false
end if

ls_trabajador = dw_master.object.cod_trabajador [al_row]

if IsNull(ls_trabajador) or ls_trabajador = '' then
	dw_master.object.desc_labor	[al_row] = ls_null
	dw_master.object.cod_labor		[al_row] = ls_null
	dw_master.object.nro_orden		[al_row] = ls_null
	dw_master.object.oper_sec		[al_row] = ls_null
	MessageBox("Error", "Debe especificar un trabajador")
	dw_master.setColumn( "cod_trabajador")
	dw_master.setFocus( )
	return false
end if


select l.cod_labor, l.desc_labor
	into :ls_labor, :ls_desc_labor
from 	labor_trabajador 	lt,
		labor					l
where lt.cod_labor = l.cod_labor
  and lt.cod_trabajador = :ls_trabajador;

dw_master.object.desc_labor	[al_row] = ls_desc_labor
dw_master.object.cod_labor		[al_row] = ls_labor


ld_fecha = date(dw_master.object.fecha [al_row])

//busco el opersec necesario para el ot_adm y la labor indicada
select count(*)
	into :ll_count
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and op.cod_labor	= :ls_labor
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

if ll_count = 0 then
	MessageBox('Error', 'No hay operacion aprobada, ni orden de trabajo aprobado para el periodo y labor indicado' &
						+ '~r~nLabor: ' + ls_labor &
						+ '~r~nOT_ADM: ' + ls_ot_adm &
						+ '~r~nPeriodo: ' + string(ld_fecha, 'yyyy') &
						+ '~r~nCodigo Trabajador: ' + ls_trabajador)
	return false
end if

select ot.nro_orden, op.oper_sec
	into :ls_nro_ot, :ls_oper_sec
from 	orden_trabajo 	ot,
		operaciones		op
where ot.nro_orden = op.nro_orden
  and ot.flag_estado = '1'
  and op.flag_estado = '1'
  and ot.ot_adm 		= :ls_ot_adm
  and op.cod_labor	= :ls_labor
  and to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy');

dw_master.object.nro_orden [al_row] = ls_nro_ot
dw_master.object.oper_sec 	[al_row] = ls_oper_sec

return true
end function

public function boolean of_select_origen ();Long ll_count, ll_row

ll_count = 0
for ll_row = 1 to dw_origen.RowCount()
	if dw_origen.object.chec[ll_row] = '1' then
		ll_count ++
	end if
next

if ll_count = 0 then
	return false
end if

return true
end function

public function boolean of_validar_save ();Long 		ll_row, ll_count, ll_nro_item
date		ld_fecha
String	ls_cod_trabaj

dwItemStatus ldis_status

for ll_row = 1 to dw_master.RowCount()
	ldis_status = dw_master.GetItemStatus(ll_row, 0, Primary!)
	
	if ldis_status = NewModified! or ldis_status = New! then
		ld_fecha 		= date(dw_master.object.fecha [ll_row])
		ls_cod_trabaj 	= dw_master.object.cod_trabajador [ll_row]
		ll_nro_item 	= Long(dw_master.object.nro_item [ll_row])
		
		select count(*)
			into :ll_count
		from pd_jornal_campo p
		where p.fecha 				= :ld_fecha
		  and p.cod_trabajador 	= :ls_cod_trabaj
		  and p.nro_item			= :ll_nro_item;
		
		if ll_count > 0 then
			MessageBox('Error', 'Esta ingresando la asistencia de un trabajador que ya existe, por favor verifique' &
							+ '~r~nfecha: ' + string(ld_fecha, 'dd/mm/yyyy') &
							+ '~r~nCod Trabajador: ' + ls_Cod_trabaj &
							+ '~r~nNro Item: ' + string(ll_nro_item) )
			
			dw_master.selectRow(0, false)
			dw_master.selectRow(ll_row, true)
			dw_master.SetFocus()
			dw_master.setColumn('cod_trabajador')
			return false
		end if
	end if
next


return true
end function

on w_pr327_parte_jornal_campo.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
this.hpb_1=create hpb_1
this.dw_origen=create dw_origen
this.sle_ot_adm=create sle_ot_adm
this.st_2=create st_2
this.sle_desc_ot_adm=create sle_desc_ot_adm
this.cb_1=create cb_1
this.uo_fechas=create uo_fechas
this.sle_cod_tra=create sle_cod_tra
this.sle_nom_tra=create sle_nom_tra
this.st_1=create st_1
this.st_procesando=create st_procesando
this.sle_labor=create sle_labor
this.sle_desc_labor=create sle_desc_labor
this.st_3=create st_3
this.st_4=create st_4
this.sle_nom_cuad=create sle_nom_cuad
this.sle_cod_cuad=create sle_cod_cuad
this.cb_importar=create cb_importar
this.sle_desc_ot=create sle_desc_ot
this.sle_nro_ot=create sle_nro_ot
this.st_5=create st_5
this.st_registros=create st_registros
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.hpb_1
this.Control[iCurrent+2]=this.dw_origen
this.Control[iCurrent+3]=this.sle_ot_adm
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.sle_desc_ot_adm
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.uo_fechas
this.Control[iCurrent+8]=this.sle_cod_tra
this.Control[iCurrent+9]=this.sle_nom_tra
this.Control[iCurrent+10]=this.st_1
this.Control[iCurrent+11]=this.st_procesando
this.Control[iCurrent+12]=this.sle_labor
this.Control[iCurrent+13]=this.sle_desc_labor
this.Control[iCurrent+14]=this.st_3
this.Control[iCurrent+15]=this.st_4
this.Control[iCurrent+16]=this.sle_nom_cuad
this.Control[iCurrent+17]=this.sle_cod_cuad
this.Control[iCurrent+18]=this.cb_importar
this.Control[iCurrent+19]=this.sle_desc_ot
this.Control[iCurrent+20]=this.sle_nro_ot
this.Control[iCurrent+21]=this.st_5
this.Control[iCurrent+22]=this.st_registros
this.Control[iCurrent+23]=this.gb_2
end on

on w_pr327_parte_jornal_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.hpb_1)
destroy(this.dw_origen)
destroy(this.sle_ot_adm)
destroy(this.st_2)
destroy(this.sle_desc_ot_adm)
destroy(this.cb_1)
destroy(this.uo_fechas)
destroy(this.sle_cod_tra)
destroy(this.sle_nom_tra)
destroy(this.st_1)
destroy(this.st_procesando)
destroy(this.sle_labor)
destroy(this.sle_desc_labor)
destroy(this.st_3)
destroy(this.st_4)
destroy(this.sle_nom_cuad)
destroy(this.sle_cod_cuad)
destroy(this.cb_importar)
destroy(this.sle_desc_ot)
destroy(this.sle_nro_ot)
destroy(this.st_5)
destroy(this.st_registros)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master

dw_origen.setTransobject( SQLCA )
dw_origen.retrieve()

ib_log = TRUE

ids_cultivos = create u_ds_base
ids_cultivos.dataobject = 'd_list_cultivos_x_lote_tbl'
ids_cultivos.setTransobject( SQLCA )
ids_cultivos.Retrieve( )

if upper(gs_empresa) = 'CEPIBO' then
	dw_master.DataObject = 'd_abc_pd_jornal_campo_cepibo_tbl'
else
	dw_master.DataObject = 'd_abc_pd_jornal_campo_tbl'
end if

dw_master.setTransObject(SQLCA)
end event

event ue_insert;//Override
Long  	ll_row, ll_count
string 	ls_null[]

is_ot_adm = sle_ot_adm.text
if is_ot_adm = '' then
 	is_ot_adm = '%%'
else
	is_ot_adm = sle_ot_adm.text
end if


ll_count = 0
is_origen = ls_null
for ll_row = 1 to dw_origen.RowCount()
	if dw_origen.object.chec[ll_row] = '1' then
		ll_count ++
		is_origen[ll_count] = dw_origen.object.cod_origen [ll_row]
	end if
next

if ll_count = 0 then
	MessageBox('Error', 'Debe seleccionar un origen')
	return
end if


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_update;//Override
Boolean 	lbo_ok = TRUE
String	ls_msg, ls_crlf
Long		ll_i

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
END IF

//Open(w_log)
//lds_log.RowsCopy(1, lds_log.RowCount(),Primary!,w_log.dw_log,1,Primary!)


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

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	if not of_calc_hrs_jornal( ) then 
		ROLLBACK;
		return
	end if

	COMMIT using SQLCA;
	
	hpb_1.minposition = 1
	hpb_1.maxposition = dw_master.RowCount()
	hpb_1.position = 0
	hpb_1.visible = true
	st_procesando.visible = true
	
	for ll_i = 1 to dw_master.RowCount()
		hpb_1.position = ll_i
		this.event ue_retrieve_hrs_row( ll_i )
	next
	
	// Actualizo el dw detalle con el importe neto
	this.event ue_retrieve_dw_detail( dw_master.getRow() )

	hpb_1.visible = false
	st_procesando.visible = false
	
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.ii_protect = 0
	dw_master.of_protect()
	
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_master.REsetUpdate()
	dw_detail.ResetUpdate()
	
	st_registros.text = string(dw_master.RowCount()) + ' Registros'
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
	
END IF
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = false

if not gnvo_app.of_row_processing( dw_master ) then return
if not gnvo_app.of_row_processing( dw_detail ) then return

if dw_master.ii_update = 1 and not of_validar_save() then return

dw_master.of_set_flag_replicacion( )
dw_detail.of_set_flag_replicacion( )

ib_update_check = true
end event

event close;call super::close;destroy ids_cultivos
end event

event ue_delete;call super::ue_delete;st_registros.text = string(dw_master.RowCount()) + ' Registros'
end event

event resize;call super::resize;//Override

dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight * 0.15
dw_detail.y = newheight  - dw_detail.height - 10

//newheight - dw_detail.y - 10

dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = dw_detail.y - dw_master.y - 10

end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_pr327_parte_jornal_campo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 576
integer width = 3575
integer height = 1628
string dataobject = "d_abc_pd_jornal_campo_tbl"
end type

event dw_master::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_origen, ls_ot_adm, ls_und, &
			ls_null, ls_labor, ls_nro_ot, ls_oper_sec, ls_dni, ls_trabajador, ls_tipo_trabaj
long		ll_i
date		ld_fecha

SetNull(ls_null)

ls_origen = ''

for ll_i = 1 to UpperBound(is_origen)
	if len(ls_origen) = 0 then
		ls_origen = "'" + is_origen[ll_i] + "'"
	else
		ls_origen += ", '" + is_origen[ll_i] + "'"
	end if
next

choose case lower(as_columna)
	case 'nro_doc_ident_rtps'
		ld_Fecha = Date(this.object.fecha[al_row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe especificar una fecha', StopSign!)
			this.setColumn('fecha')
			return
		end if
		
		ls_sql = "select m.cod_trabajador as codigo, " &
		 		 + "m.nom_trabajador as nom_trabajador, " &
				 + "m.nro_doc_ident_rtps as dni, " &
				 + "m.tipo_trabajador as tipo_trabajador " &
		 		 + "from vw_pr_trabajador m, " &
				 + "     tipo_trabajador_user ttu " &
		 		 + "where ttu.tipo_trabajador = m.tipo_trabajador " &
				 + "  and m.tipo_trabajador in ('JOR', 'EJO') " &
				 + "  and ttu.cod_usr = '" + gs_user + "'" &
				 + "  and m.flag_estado = '1' " &
				 + "  and (trunc(m.fec_cese) >= to_date('" + string(ld_fecha, 'dd/mm/yyyy') +"','dd/mm/yyyy') or m.fec_cese is null)" &
				 + "  and trunc(m.fec_ingreso) <= to_date('" + string(ld_fecha, 'dd/mm/yyyy') +"','dd/mm/yyyy')" &
				 + "  and m.cod_origen in (" + ls_origen + ")" 
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_dni, ls_tipo_trabaj, '3')
		
		if lb_ret then
			this.object.cod_trabajador		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.tipo_trabajador	[al_row] = ls_tipo_trabaj
			this.object.nro_item				[al_row] = of_nro_item( ld_fecha, ls_codigo, al_row)
			this.object.hrs_normales 		[al_row] = of_set_hrs_normales(ls_codigo, ld_fecha, al_row)
			this.object.nro_doc_ident_rtps[al_row] = ls_dni
			
			of_set_labor(al_row)
			
			this.ii_update = 1
		end if
		
	case "cod_trabajador"
		ld_Fecha = Date(this.object.fecha[al_row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe especificar una fecha', StopSign!)
			this.setColumn('fecha')
			return
		end if
		
		ls_sql = "select m.cod_trabajador as codigo, " &
		 		 + "m.nom_trabajador as nom_trabajador, " &
				 + "m.nro_doc_ident_rtps as dni, " &
				 + "m.tipo_trabajador as tipo_trabajador " &
		 		 + "from vw_pr_trabajador m, " &
				 + "     tipo_trabajador_user ttu " &
		 		 + "where ttu.tipo_trabajador = m.tipo_trabajador " &
				 + "  and m.tipo_trabajador in ('JOR', 'EJO') " &
				 + "  and ttu.cod_usr = '" + gs_user + "'" &
				 + "  and m.flag_estado = '1' " &
				 + "  and (trunc(m.fec_cese) >= to_date('" + string(ld_fecha, 'dd/mm/yyyy') +"','dd/mm/yyyy') or m.fec_cese is null)" &
				 + "  and trunc(m.fec_ingreso) <= to_date('" + string(ld_fecha, 'dd/mm/yyyy') +"','dd/mm/yyyy')" &
				 + "  and m.cod_origen in (" + ls_origen + ")" 
				 
		lb_ret = gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, ls_dni, ls_tipo_trabaj, '1')
		
		if lb_ret then
			
			this.object.cod_trabajador		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.tipo_trabajador	[al_row] = ls_tipo_trabaj
			this.object.nro_item				[al_row] = of_nro_item( ld_fecha, ls_codigo, al_row)
			this.object.hrs_normales 		[al_row] = of_set_hrs_normales(ls_codigo, ld_fecha, al_row)
			this.object.nro_doc_ident_rtps[al_row] = ls_dni
			
			of_set_labor(al_row)
			
			this.ii_update = 1
		end if
		
	case "cod_cuadrilla"
		ls_trabajador = this.object.cod_trabajador[al_row]
		
		if IsNull(ls_trabajador) or ls_trabajador = '' then
			MessageBox('Error', 'Debe especificar un trabajador')
			this.setColumn('cod_trabajador')
			return
		end if
		
		ls_sql = "select distinct a.cod_cuadrilla as codigo_cuadrilla, " &
				 + "a.desc_cuadrilla as descripcion_cuadrilla " &
				 + "from tg_cuadrillas a, " &
				 + "     tg_cuadrillas_det b " &
				 + "where a.cod_cuadrilla = b.cod_cuadrilla " &
				 + "  and b.cod_trabajador = '" + ls_trabajador + "' " &
				 + "  and a.flag_estado    <> '0'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_cuadrilla		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "ot_adm"
		
		ls_sql = "SELECT o.ot_adm as codigo_ot_adm, " &
			    + "o.descripcion as descripcion_ot_adm " &
				 + "FROM ot_administracion o, " &
				 + "	   ot_adm_user_prod u " &
				 + "WHERE o.ot_adm = u.ot_adm " &
				 + "  and u.cod_usr = '" + gs_user + "'" &
				 + "  and o.flag_estado = '1'";
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.ot_adm		[al_row] = ls_codigo
			this.object.cod_labor	[al_row] = ls_null
			this.object.desc_labor	[al_row] = ls_null
			this.object.und			[al_row] = ls_null
			this.ii_update = 1
		end if

	case "cod_labor"
		ld_Fecha = Date(this.object.fecha[al_row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe especificar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[al_row]

		if ls_ot_adm = '' then
			MessageBox('Error', 'Debe especificar un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if
		
		ls_trabajador = this.object.cod_trabajador[al_row]
		
		if IsNull(ls_trabajador) or ls_trabajador = '' then
			MessageBox('Error', 'Debe especificar un trabajador')
			this.setColumn('cod_trabajador')
			return
		end if
		
		ls_sql = "SELECT DISTINCT la.cod_labor as codigo_labor, " &
				 + "la.desc_labor as descripción_labor, " &
				 + "und as unidad " &
				 + "FROM orden_trabajo ot, " &
				 + "     operaciones   op, " &
				 + "     labor         la, " &
				 + "		labor_trabajador lt " &
				 + "WHERE ot.nro_orden = op.nro_orden " &
				 + "  AND op.cod_labor = la.cod_labor " &
				 + "  AND la.cod_labor = lt.cod_labor " &
				 + "  AND lt.cod_trabajador = '" + ls_trabajador + "'" &
				 + "  AND op.flag_estado = '1' " &
				 + "  AND ot.flag_estado = '1' " &
				 + "  AND ot.ot_adm = '" + ls_ot_adm + "' " &
				 + "  AND to_char(op.fec_inicio, 'yyyy') = '" + string(ld_fecha, 'yyyy') + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.cod_labor	[al_row] = ls_codigo
			this.object.desc_labor	[al_row] = ls_data
			this.object.und			[al_row] = ls_und
			
			parent.of_set_ot_opersec( al_row )
			
			this.ii_update = 1
		end if

	case "nro_orden"
		ld_Fecha = Date(this.object.fecha[al_row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe especificar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[al_row]

		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox('Error', 'Debe especificar un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if
		
		ls_labor = this.object.cod_labor[al_row]
		if IsNull(ls_labor) or ls_labor = '' then
			MessageBox('Error', 'Debe especificar una labor primero')
			this.setColumn('ls_labor')
			return
		end if
		

		ls_sql = "SELECT DISTINCT ot.nro_orden as numero_orden, " &
				 + "ot.titulo as titulo_ot, " &
				 + "op.oper_sec as oper_sec, " &
				 + "op.cencos as Centro_costo " &
				 + "FROM orden_trabajo ot, " &
				 + "     operaciones   op, " &
				 + "     labor         la " &
				 + "WHERE ot.nro_orden = op.nro_orden " &
				 + "  AND op.cod_labor = la.cod_labor " &
				 + "  AND op.flag_estado = '1' " &
				 + "  AND ot.ot_adm = '" + ls_ot_adm + "' " &
				 + "  AND op.cod_labor = '" + ls_labor + "' " &
				 + "  AND to_char(op.fec_inicio, 'yyyy') <= '" + string(ld_fecha, 'yyyy') + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_oper_sec, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden	[al_row] = ls_codigo
			this.object.oper_sec		[al_row] = ls_oper_sec
			
			//parent.of_set_ot_opersec( al_row, ls_codigo )
			
			this.ii_update = 1
		end if

	case "oper_sec"
		ld_Fecha = Date(this.object.fecha[al_row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe especificar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		ls_ot_adm = this.object.ot_adm	[al_row]

		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox('Error', 'Debe especificar un OT_ADM')
			this.setColumn('ot_adm')
			return
		end if
		
		ls_labor = this.object.cod_labor[al_row]
		if IsNull(ls_labor) or ls_labor = '' then
			MessageBox('Error', 'Debe especificar una labor primero')
			this.setColumn('ls_labor')
			return
		end if
		
		ls_nro_ot = this.object.nro_orden[al_row]
		if IsNull(ls_nro_ot) or ls_nro_ot = '' then
			MessageBox('Error', 'Debe especificar un numero de OT')
			this.setColumn('ls_nro_ot')
			return
		end if

		ls_sql = "SELECT DISTINCT op.oper_sec as op.oper_sec, " &
				 + "op.descripcion as descripcion_operacion, " &
				 + "op.cencos as Centro_Costo " &
				 + "FROM orden_trabajo ot, " &
				 + "     operaciones   op, " &
				 + "     labor         la " &
				 + "WHERE ot.nro_orden = op.nro_orden " &
				 + "  AND op.cod_labor = la.cod_labor " &
				 + "  AND op.flag_estado = '1' " &
				 + "  AND ot.ot_adm = '" + ls_ot_adm + "' " &
				 + "  AND op.cod_labor = '" + ls_labor + "' " &
				 + "  AND ot.nro_orden = '" + ls_nro_ot &
				 + "  AND to_char(op.fec_inicio, 'yyyy') <= '" + string(ld_fecha, 'yyyy') + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, ls_data, ls_und, '1')
		
		if ls_codigo <> '' then
			this.object.oper_sec	[al_row] = ls_codigo
			
			//parent.of_set_ot_opersec( al_row )
			
			this.ii_update = 1
		end if

end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_ck[3] = 3			// columnas de lectrua de este dw

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2 	      // columnas que se pasan al detalle
ii_dk[3] = 3 	      // columnas que se pasan al detalle
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_master::ue_insert_pre;call super::ue_insert_pre;String 	ls_und, ls_codtra
Date		ld_fecha
DateTime	ldt_hora1, ldt_hora2
DEcimal	ldc_horas

ld_fecha = uo_fechas.of_get_fecha1( )

this.object.fecha					[al_row] = ld_fecha
this.object.hrs_normales 		[al_row] = 0.00
this.object.hrs_extras_25 		[al_row] = 0.00
this.object.hrs_extras_35 		[al_row] = 0.00
this.object.hrs_noc_extras_35	[al_row] = 0.00
this.object.hrs_extras_100		[al_row] = 0.00
this.object.rendimiento			[al_row] = 0.00
this.object.hrs_noc_normal		[al_row] = 0.00
this.object.hrs_noc_extras_25	[al_row] = 0.00



this.object.jornal_basico		[al_row] = 0.00
this.object.asign_familiar		[al_row] = 0.00
this.object.imp_hrs_norm		[al_row] = 0.00
this.object.imp_hrs_25			[al_row] = 0.00
this.object.imp_hrs_35			[al_row] = 0.00
this.object.imp_hrs_noc_35		[al_row] = 0.00
this.object.imp_hrs_100			[al_row] = 0.00
this.object.imp_hrs_noc_nor	[al_row] = 0.00
this.object.imp_hrs_noc_25		[al_row] = 0.00
this.object.imp_dominical		[al_row] = 0.00

if trim(upper(gs_empresa)) = 'FRUITXCHANGE' then
	ldt_hora1 = DateTime(ld_fecha, Time("06:00:00"))
else
	ldt_hora1 = DateTime(ld_fecha, Time("08:00:00"))
end if

this.object.hora_inicio		[al_row] = ldt_hora1
this.object.hora_fin			[al_row] = ldt_hora1


//LA fecha de registro
this.object.fec_registro		[al_row] = gnvo_app.of_fecha_actual()


this.object.aporte_oblig		[al_row] = 0.00
this.object.comision_var		[al_row] = 0.00
this.object.prima_seguro		[al_row] = 0.00
this.object.aporte_essalud		[al_row] = 0.00

this.object.cod_usr				[al_row] = gs_user
this.object.cod_origen			[al_row] = gs_origen

if is_ot_adm <> '%%' then
	this.object.ot_adm			[al_row] = is_ot_adm
elseif al_row > 1 then
	this.object.ot_adm			[al_row] = this.object.ot_adm			[al_row - 1]
end if

if is_labor <> '%%' then
	this.object.cod_labor		[al_row] = is_labor
	this.object.desc_labor		[al_row] = sle_desc_labor.text
	
	select und
	  into :ls_und
	  from labor
	 where cod_labor = :is_labor;
	
	this.object.und				[al_row] = ls_und
elseif al_row > 1 then
	this.object.cod_labor		[al_row] = this.object.cod_labor		[al_row - 1]
	this.object.desc_labor		[al_row] = this.object.desc_labor	[al_row - 1]
	this.object.und				[al_row] = this.object.und				[al_row - 1]
end if

this.object.flag_trab_general [al_row] = '0'

if al_row > 1 then
	this.object.fecha					[al_row] = this.object.fecha				 	[al_row - 1]
	this.object.nro_doc_ident_rtps[al_row] = this.object.nro_doc_ident_rtps	[al_row - 1]
	this.object.cod_trabajador		[al_row] = this.object.cod_trabajador	 	[al_row - 1]
	this.object.nom_trabajador		[al_row] = this.object.nom_trabajador	 	[al_row - 1]
	
	ld_fecha  = Date(this.object.fecha		[al_row])
	ls_codtra = this.object.cod_trabajador	[al_row]
	
	if trim(upper(gs_empresa)) = 'FRUITXCHANGE' then
		ldc_horas = 8
	else
		ldc_horas = of_set_hrs_normales(ls_codtra, ld_fecha, al_row)
	end if
	ldt_hora1 = DateTime( this.object.hora_inicio [al_Row])
	
	select :ldt_hora1 + :ldc_horas / 24
		into :ldt_hora2
	from dual;
	
	
	this.object.hora_fin 		[al_Row] = ldt_hora2
	this.object.hrs_normales 	[al_row] = ldc_horas
	this.object.nro_item 		[al_row] = of_nro_item( ld_fecha, ls_codtra, al_row)
	
	dw_detail.reset( )
end if

st_registros.text = string(this.RowCount()) + ' Registros'

end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_codtra, ls_expresion, &
			ls_nro_lote, ls_variedad, ls_ot_adm, ls_labor, &
			ls_und, ls_prim_dig, ls_dni, ls_nro_ot, ls_oper_sec, &
			ls_tipo_trabaj, ls_mensaje
Date 		ld_fecha
DateTime	ldt_hora1, ldt_hora2, ldt_temp
Long		ll_found, ll_row, ll_year, ll_year1, ll_year2
Decimal	ldc_hrs_norm, ldc_hrs_25, ldc_hrs_35

this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case 'fecha'
		//Valido si el año
		ld_fecha = date(mid(data,1,10))
		ll_year = year(ld_fecha)
		
		ll_year1 = year(uo_fechas.of_get_fecha1())
		ll_year2 = year(uo_fechas.of_get_fecha2())
		
		if ll_year < ll_year1 or ll_year > ll_year2 then
			setNull(ld_fecha)
			this.object.fecha[row] = ld_fecha
			
			MessageBox('Error', 'El año ingresado ' + string(ll_year) &	
					+ ' no está en el rango permitido. ' &
					+ '~r~nRango: ' + string(ll_year1) + ' - ' + string(ll_year2))
			this.setColumn( "fecha")
			this.setFocus( )
					
			return
		end if
		
		ls_codtra = this.object.cod_trabajador[row]
		if IsNull(ls_Codtra) or trim(ls_CodTra) = '' then 
			this.SetColumn( "cod_trabajador" )
			return
		end if
		
		//Valido si el trabajador es correcto para esta fecha
		select trim(apel_paterno || ' ' || apel_materno || ', ' || nombre1 || ' ' || nombre2)
			into :ls_data
		from 	maestro m,
				tipo_trabajador_user ttu
		where m.tipo_trabajador = ttu.tipo_trabajador
		  and ttu.cod_usr 		= :gs_user
		  and m.cod_trabajador 	= :ls_codtra
		  and m.flag_estado 		= '1'
		  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
		  and m.fec_ingreso <= :ld_fecha;

		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Codigo de Trabajador no accesible, posiblemente por las siguientes razones: "&
							+ "~r~n1.- Codigo de Trabajador no existe "&
							+ "~r~n2.- Codigo de Trabajador no está activo"&
							+ "~r~n3.- Codigo de Trabajador no ha ingresado en el periodo indicado "&
							+ "~r~n4.- Codigo de Trabaajdor ha cesado antes el periodo indicado "&
							+ "~r~n5.- Codigo de Trabajador pertenece a un tipo de trabajador al cual no tiene acceso."&
							+ "~r~nPor favor verifique con las area involucradas.....", StopSign!)
			this.object.cod_trabajador	[row] = gnvo_app.is_null
			this.object.nom_trabajador	[row] = gnvo_app.is_null
			
			this.setColumn("cod_trabajador")
			return 1
		end if

		this.object.nro_item		  [row] = of_nro_item( Date(data), ls_codtra, row)
		
		//Verificando si la labor es null
		ls_labor = this.object.cod_labor[row]
		
		if IsNull(ls_labor) or trim(ls_labor) = '' then
			this.SetColumn( "cod_labor" )
			return
		end if
		
		ldc_hrs_norm = of_set_hrs_normales(ls_codtra, ld_fecha, row)
		this.object.hrs_normales 	[row] = ldc_hrs_norm
		
		ldt_temp = DateTime(this.object.hora_inicio [row])
		
		select to_date(to_char(:ld_fecha, 'dd/mm/yyyy') || ' ' || to_char(:ldt_temp, 'hh24:mi:ss'), 'dd/mm/yyyy hh24:mi:ss')
			into :ldt_hora1
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQlErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al calcular la hora de Inicio. Mensaje: ' &
								+ ls_mensaje, StopSign!)
			return
		end if
		
		//Obtengo la fecha y hora de fin
		select :ldt_hora1 + :ldc_hrs_norm/24
			into :ldt_hora2
		from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQlErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al calcular la hora de FIN. Mensaje: ' &
								+ ls_mensaje, StopSign!)
			return
		end if
		
		this.object.hora_inicio 	[row] = ldt_hora1
		this.object.hora_fin		 	[row] = ldt_hora2
		
		
		this.setColumn( "flag_trab_general" )

	case "nro_doc_ident_rtps"
		ld_fecha = Date(this.object.fecha [row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe ingresar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		select m.cod_trabajador, trim(apel_paterno || ' ' || apel_materno || ', ' || nombre1 || ' ' || nombre2),
				 m.tipo_trabajador
			into :ls_codtra, :ls_data, :ls_tipo_trabaj
		from 	maestro m,
				tipo_trabajador_user ttu
		where m.tipo_trabajador 		= ttu.tipo_trabajador
		  and ttu.cod_usr 				= :gs_user
		  and m.nro_doc_ident_rtps 	= :data
		  and m.flag_estado 				= '1'
		  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
		  and m.fec_ingreso <= :ld_fecha;

		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Documento de Identidad del trabajador no existe, "&
							+ "no está activo o ha cesado antes de la "&
							+ "fecha indicada o ha ingresado después de "&
							+ "la fecha indicada o no tiene autorización "&
							+ "a ingresar ese tipo de trabaajdor", StopSign!)
			this.object.nro_doc_ident_rtps	[row] = gnvo_app.is_null
			this.object.cod_trabajador			[row] = gnvo_app.is_null
			this.object.nom_trabajador			[row] = gnvo_app.is_null
			this.object.tipo_trabajador		[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.cod_trabajador	[row] = ls_codtra
		this.object.nom_trabajador [row] = ls_data
		this.object.nro_item		   [row] = of_nro_item( ld_fecha, data, row )
		this.object.tipo_trabajador[row] = ls_tipo_trabaj

		this.object.hrs_normales 	[row] = of_set_hrs_normales(ls_codtra, ld_fecha, row)
		
		of_set_labor(row)
		
		return 1
		
	case "cod_trabajador"
		ld_fecha = Date(this.object.fecha [row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe ingresar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		if len(data) < 8 then
			select substr(to_char(ult_nro), 1,1)
			  into :ls_prim_dig
			  from num_maestro
			 where origen = :gs_origen;
			
			ls_codtra = ls_prim_dig + string(integer(data), '0000000')
			this.object.cod_trabajador	[row] = ls_codtra
		else
			ls_codtra = data
		end if
		
		select trim(apel_paterno || ' ' || apel_materno || ', ' || nombre1 || ' ' || nombre2),
				 m.nro_doc_ident_rtps, m.tipo_trabajador
			into :ls_data, :ls_dni, :ls_tipo_trabaj
		from 	maestro m,
				tipo_trabajador_user ttu
		where m.tipo_trabajador = ttu.tipo_trabajador
		  and ttu.cod_usr 		= :gs_user
		  and m.cod_trabajador 	= :ls_codtra
		  and m.flag_estado 		= '1'
		  and (m.fec_cese is null or m.fec_cese >= :ld_fecha)
		  and m.fec_ingreso <= :ld_fecha;

		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Código de trabajador no existe, "&
							+ "no está activo o ha cesado antes de la "&
							+ "fecha indicada o ha ingresado después de "&
							+ "la fecha indicada o no tiene autorización "&
							+ "a ingresar ese tipo de trabaajdor", StopSign!)
			this.object.cod_trabajador			[row] = gnvo_app.is_null
			this.object.nom_trabajador			[row] = gnvo_app.is_null
			this.object.nro_doc_ident_rtps	[row] = gnvo_app.is_null
			this.object.tipo_trabajador		[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.nom_trabajador 		[row] = ls_data
		this.object.nro_item		   		[row] = of_nro_item( ld_fecha, data, row )
		this.object.cod_trabajador			[row] = ls_codtra
		this.object.nro_doc_ident_rtps	[row] = ls_dni
		this.object.tipo_trabajador		[row] = ls_tipo_trabaj
		
		this.object.hrs_normales 			[row] = of_set_hrs_normales(ls_codtra, ld_fecha, row)
		of_set_labor(row)
		
		return 1
	
	case "cod_labor"
		ld_fecha = Date(this.object.fecha [row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe ingresar una fecha')
			this.setColumn('fecha')
			return
		end if
		
		select desc_labor, und
			into :ls_data, :ls_und
		from 	labor
		where cod_labor = :data
		  and flag_estado = '1';

		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Código de labor no existe", StopSign!)
			this.object.cod_labor	[row] = gnvo_app.is_null
			this.object.desc_labor	[row] = gnvo_app.is_null
			this.object.und			[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.desc_labor	[row] = ls_data
		this.object.und			[row] = ls_und

	case "flag_trab_general"
		ls_labor = this.object.cod_labor[row]
		
		if IsNull(ls_labor) or ls_labor = '' then
			MessageBox('Error', 'Debe Ingresar una labor')
			this.setColumn("cod_labor")
			this.setfocus( )
			return
		end if
		
		ls_ot_adm = this.object.ot_adm[row]
		if IsNull(ls_ot_adm) or ls_ot_adm = '' then
			MessageBox('Error', 'Debe seleccionar un ot_adm')
			this.setColumn("ot_adm")
			this.setfocus( )
			return
		end if

		if data = '1' then
			for ll_row = 1 to ids_cultivos.RowCount( )
				ls_nro_lote = ids_cultivos.object.nro_lote [ll_row]
				ls_variedad = ids_cultivos.object.variedad [ll_row]
				
				ls_expresion = "nro_lote = '" + ls_nro_lote + "' " &
								 + "AND variedad = '" + ls_variedad + "'"
				
				ll_found = dw_detail.find( ls_expresion, 1, dw_detail.RowCount())
				
				if ll_found = 0 then
					ll_found = dw_detail.event ue_insert( )
					if ll_found > 0 then
						dw_detail.object.nro_lote 		 [ll_found] = ids_cultivos.object.nro_lote		[ll_row]
						dw_detail.object.desc_lote 	 [ll_found] = ids_cultivos.object.desc_lote		[ll_row]
						dw_detail.object.variedad 		 [ll_found] = ids_cultivos.object.variedad		[ll_row]
						dw_detail.object.desc_variedad [ll_found] = ids_cultivos.object.desc_variedad	[ll_row]
						of_set_ot( ls_nro_lote, ls_variedad, ls_labor, ls_ot_adm, ll_found )					
					end if
				end if
			next
		end if
	
	case "hora_inicio"
		ldt_hora1 = DateTime(this.object.hora_inicio[row])
		
		select :ldt_hora1 + 8/24
			into :ldt_hora2
			from dual;
			
		this.object.hora_fin 	[row] = ldt_hora2	
		
	case "hora_fin"
		ldt_hora1 = DateTime(this.object.hora_inicio	[row])
		ldt_hora2 = DateTime(this.object.hora_fin		[row])

		
		if IsNull(ldt_hora1) then
			MessageBox('Error', 'Debe Ingresar una Fecha y Hora de Inicio')
			this.setColumn("hora_inicio")
			this.setfocus( )
			return
		end if
		
		if IsNull(ldt_hora2) then
			MessageBox('Error', 'Debe Ingresar una Fecha y Hora de Inicio')
			this.setColumn("hora_inicio")
			this.setfocus( )
			return
		end if
		
		select :ldt_hora2 - :ldt_hora1
			into :ldc_hrs_norm
			from dual;
		
		ldc_hrs_norm = ldc_hrs_norm * 24
		
		if ldc_hrs_norm > 8 then
			ldc_hrs_25 = ldc_hrs_norm - 8
			ldc_hrs_norm = 8
		else
			ldc_hrs_25 = 0
		end if
		
		if ldc_hrs_25 > 2 then
			ldc_hrs_25 = 2
			ldc_hrs_35 = ldc_hrs_25 - 2
		else
			ldc_hrs_35 = 0
		end if
		
		this.object.hrs_normales 	[row] = ldc_hrs_norm
		this.object.hrs_extras_25 	[row] = ldc_hrs_25
		this.object.hrs_extras_35 	[row] = ldc_hrs_35

	case "nro_orden"	
		
		ls_nro_ot = this.object.nro_orden [row]
		ls_ot_adm = this.object.ot_adm[row]
		ls_labor = this.object.cod_labor[row]
		ld_fecha = Date(this.object.fecha [row])
		
		if IsNull(ld_fecha) then
			MessageBox('Error', 'Debe Seleccionar un Nro de OT')
			this.setColumn('fecha')
			return
		end if
		
		SELECT DISTINCT op.oper_sec 
			INTO :ls_oper_sec
			FROM orden_trabajo ot, 
				operaciones   op, 
				labor         la 
			WHERE ot.nro_orden = op.nro_orden 
				AND op.cod_labor = la.cod_labor 
				AND op.flag_estado = '1' 
				AND ot.flag_estado = '1' 
				AND ot.ot_adm = :ls_ot_adm
				AND op.cod_labor = :ls_labor
				AND op.nro_orden = :ls_nro_ot
				AND to_char(op.fec_inicio, 'yyyy') = to_char(:ld_fecha, 'yyyy') ;
				 
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Nro de Orden de Trabajo No Existe o No Se Encuentra Activo", StopSign!)
			this.object.nro_orden	[row] = gnvo_app.is_null
			this.object.oper_sec			[row] = gnvo_app.is_null
			return 1
		end if
		
		this.object.oper_sec [row] = ls_oper_sec

		return 1
		
end choose
end event

event dw_master::ue_output;call super::ue_output;THIS.EVENT ue_retrieve_det(al_row)
end event

event dw_master::ue_retrieve_det_pos;call super::ue_retrieve_det_pos;idw_det.retrieve(Date(aa_id[1]), aa_id[2], aa_id[3])
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;if currentrow = 0 then return

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	THIS.Event ue_output(currentrow)
	RETURN
END IF
end event

event dw_master::ue_retrieve_det;//Override
if al_Row <= 0 then return

Any		la_id[]
Integer	li_x

FOR li_x = 1 TO UpperBound(ii_dk)
	if IsNull(THIS.object.data.primary.current[al_row, ii_dk[li_x]]) then return
	la_id[li_x] = THIS.object.data.primary.current[al_row, ii_dk[li_x]]
NEXT

THIS.EVENT ue_retrieve_det_pos(la_id)
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_pr327_parte_jornal_campo
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 2220
integer width = 3570
integer height = 412
string dataobject = "d_abc_pd_jornal_campo_lote_tbl"
end type

event dw_detail::ue_display(string as_columna, long al_row);boolean lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_lote, ls_null, &
			ls_nro_orden, ls_variedad, ls_labor, ls_ot_adm

SetNull(ls_null)

choose case lower(as_columna)
		
	case "nro_lote"
		
		if dw_master.GetRow() = 0 then
			MessageBox('Error', 'No ha ingresado información en la cabecera del Parte Diario')
			return
		end if

		ls_labor = dw_master.object.cod_labor[dw_master.getRow()]
		
		if IsNull(ls_labor) or trim(ls_labor) = "" then
			MessageBox("Error", "Debe ingresar un codigo de labor primero")
			dw_master.setFocus()
			dw_master.setColumn('cod_labor')
			return
		end if

		ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
		
		if IsNull(ls_labor) or trim(ls_labor) = "" then
			MessageBox("Error", "Debe ingresar un OT_ADM primero")
			dw_master.setFocus()
			dw_master.setColumn('ot_adm')
			return
		end if

		ls_sql = "SELECT nro_lote as mumero_lote, " &
				  + "descripcion AS DESCRIPCION_lote, " &
				  + "total_ha as total_hectareas " &
				  + "FROM lote_campo " &
				  + "where flag_estado ='1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_lote 		[al_row] = ls_codigo
			this.object.desc_lote		[al_row] = ls_data
			
			if parent.of_set_variedad( ls_Codigo, al_row) = 1 then
				ls_variedad = this.object.variedad [al_row]
				
				parent.of_set_ot( ls_codigo, ls_variedad, ls_labor, ls_ot_adm, al_row)
			else
				this.object.variedad 		[al_row] = ls_null
				this.object.desc_variedad 	[al_row] = ls_null
				this.object.nro_orden 		[al_row] = ls_null
				this.object.oper_sec			[al_row] = ls_null
			end if
			this.ii_update = 1
		end if
	
	case "variedad"
		ls_lote = this.object.nro_lote [al_row]
		
		if IsNull(ls_lote) or ls_lote = '' then
			MessageBox('Error', 'No ha especificado un número de lote')
			this.setColumn('variedad')
			return
		end if
		
		ls_labor = dw_master.object.cod_labor[dw_master.getRow()]
		
		if IsNull(ls_labor) or trim(ls_labor) = "" then
			MessageBox("Error", "Debe ingresar un codigo de labor primero")
			dw_master.setFocus()
			dw_master.setColumn('cod_labor')
			return
		end if

		ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
		
		if IsNull(ls_labor) or trim(ls_labor) = "" then
			MessageBox("Error", "Debe ingresar un OT_ADM primero")
			dw_master.setFocus()
			dw_master.setColumn('ot_adm')
			return
		end if

		
		ls_sql   = "SELECT a.cod_art AS CODIGO_articulo, "&
		 		   + "a.desc_art AS DESCRIPCION_artículo, "&
				   + "a.und AS unidad "&
				   + "FROM articulo a, "&
				   + "cultivos cc " &
				   + "WHERE a.cod_art = cc.variedad " &
				   + "and a.FLAG_ESTADO = '1' " &
					+ "and cc.nro_lote = '" + ls_lote + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.variedad 		[al_row] = ls_codigo
			this.object.desc_variedad	[al_row] = ls_data
			this.object.nro_orden 		[al_row] = ls_null
			this.object.oper_sec			[al_row] = ls_null
			parent.of_set_ot( ls_lote, ls_codigo, ls_labor, ls_ot_adm, al_row)
			this.ii_update = 1
		end if
	
	case "nro_orden"
		ls_lote = this.object.nro_lote [al_row]
		
		if IsNull(ls_lote) or ls_lote = '' then
			MessageBox('Error', 'No ha especificado un número de lote')
			this.setColumn('nro_lote')
			return
		end if
		
		ls_variedad = this.object.variedad [al_row]
		
		if IsNull(ls_variedad) or ls_variedad = '' then
			MessageBox('Error', 'No ha especificado una variedad de cultivo')
			this.setColumn('variedad')
			return
		end if
		
		ls_sql = "SELECT ot.nro_orden as numero_ot, " &
				 + "ot.descripcion as descripcion_ot " &
				 + "FROM orden_trabajo ot, " &
				 + "     operaciones   op " &
				 + "WHERE ot.nro_orden = op.nro_orden " &
				 + "  AND op.cod_labor = '" + is_labor + "' " &
				 + "  AND op.flag_estado = '1' " &
				 + "  AND ot.ot_adm = '" + is_ot_adm + "' " &
				 + "  and ot.lote_campo = '" + ls_lote + "' " &
				 + "  and ot.variedad = '" + ls_variedad + "' " 
				 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nro_orden 		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "oper_sec"
		ls_lote = this.object.nro_lote [al_row]
		
		if IsNull(ls_lote) or ls_lote = '' then
			MessageBox('Error', 'No ha especificado un número de lote')
			this.setColumn('nro_lote')
			return
		end if
		
		ls_variedad = this.object.variedad [al_row]
		
		if IsNull(ls_variedad) or ls_variedad = '' then
			MessageBox('Error', 'No ha especificado una variedad de cultivo')
			this.setColumn('variedad')
			return
		end if
		
		ls_nro_orden = this.object.nro_orden [al_row]
		
		if IsNull(ls_nro_orden) or ls_nro_orden = '' then
			MessageBox('Error', 'No ha especificado una variedad de cultivo')
			this.setColumn('nro_orden')
			return
		end if

		ls_sql = "SELECT op.oper_sec as codigo_operacion, " &
				 + "op.desc_operacion as descripcion_operacion " &
				 + "FROM orden_trabajo ot, " &
				 + "     operaciones   op " &
				 + "WHERE ot.nro_orden = op.nro_orden " &
				 + "  AND op.cod_labor = '" + is_labor + "' " &
				 + "  AND op.flag_estado = '1' " &
				 + "  AND ot.ot_adm = '" + is_ot_adm + "' " &
				 + "  and ot.lote_campo = '" + ls_lote + "' " &
				 + "  and ot.variedad = '" + ls_variedad + "' " &
				 + "  and ot.nro_orden = '" + ls_nro_orden + "' "
				 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.oper_sec 		[al_row] = ls_codigo
			this.ii_update = 1
		end if		
end choose

end event

event dw_detail::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      // columnas que recibimos del master
ii_rk[3] = 3 	      // columnas que recibimos del master


end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna
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

event dw_detail::keydwn;call super::keydwn;string ls_columna, ls_cadena
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

event dw_detail::itemchanged;call super::itemchanged;string 	ls_null, ls_mensaje, ls_desc, ls_codvar, ls_desc_var, &
			ls_lote, ls_labor, ls_ot_adm

This.AcceptText()
if row = 0 then return

Setnull( ls_null)

CHOOSE CASE lower(dwo.name)
	
	CASE 'nro_lote'
		
		if dw_master.GetRow() = 0 then
			MessageBox('Error', 'No ha ingresado información en la cabecera del Parte Diario')
			return
		end if

		ls_labor = dw_master.object.cod_labor[dw_master.getRow()]
		
		if IsNull(ls_labor) or trim(ls_labor) = "" then
			MessageBox("Error", "Debe ingresar un codigo de labor primero")
			dw_master.setFocus()
			dw_master.setColumn('cod_labor')
			return
		end if
		
		ls_ot_adm = dw_master.object.ot_adm[dw_master.getRow()]
		
		if IsNull(ls_ot_adm) or trim(ls_ot_adm) = "" then
			MessageBox("Error", "Debe ingresar un OT_ADM primero")
			dw_master.setFocus()
			dw_master.setColumn('ot_adm')
			return
		end if


		if len(trim(data)) < 3 and len(trim(data)) > 0 then
			ls_lote = '%' + data + '%'
			
			select lc.nro_lote
				into :ls_lote
			from lote_campo lc,
				  cultivos	 c,
				  articulo	 a
			where lc.nro_lote = c.nro_lote
			  and c.variedad = a.cod_art
			  and lc.nro_lote like :ls_lote
			order by lc.nro_lote;
			
			if SQLCA.SQlCode <> 100 then
				this.object.nro_lote [row] = ls_lote
			else
				this.object.nro_lote [row] = ls_null
			end if
			
		else
			ls_lote = data			
		end if

		select lc.descripcion, c.variedad, a.desc_art
			into :ls_desc, :ls_codvar, :ls_desc_var
		from lote_campo lc,
			  cultivos	 c,
			  articulo	 a
		where lc.nro_lote = c.nro_lote
		  and c.variedad = a.cod_art
		  and lc.nro_lote = :ls_lote
		  and c.flag_estado = '1';
	  
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso','Lote no existe o su cultivo no está activo, por favor verifique')
			this.Object.nro_lote			[row] = ls_null
			this.object.desc_lote		[row] = ls_null
			this.Object.variedad			[row] = ls_null
			this.object.desc_variedad	[row] = ls_null
			this.Object.nro_orden		[row] = ls_null
			this.object.oper_sec			[row] = ls_null
			this.object.imp_neto			[row] = 0
			return 1
		end if			
		
		this.object.nro_lote			[row] = ls_lote
		this.object.desc_lote		[row] = ls_desc
		this.Object.variedad			[row] = ls_codvar
		this.object.desc_variedad	[row] = ls_desc_var
		
	
		parent.of_set_ot( ls_lote, ls_codvar, ls_labor, ls_ot_adm, row)
		
		return 1

		
END CHOOSE

end event

type hpb_1 from hprogressbar within w_pr327_parte_jornal_campo
boolean visible = false
integer x = 46
integer y = 472
integer width = 2272
integer height = 64
boolean bringtotop = true
unsignedinteger maxposition = 100
integer setstep = 1
end type

type dw_origen from u_dw_abc within w_pr327_parte_jornal_campo
integer x = 672
integer y = 76
integer width = 818
integer height = 396
boolean bringtotop = true
string dataobject = "d_ap_origen_liq_pesca_tbl"
end type

event constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

type sle_ot_adm from singlelineedit within w_pr327_parte_jornal_campo
event dobleclick pbm_lbuttondblclk
integer x = 1833
integer y = 60
integer width = 439
integer height = 72
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

ls_sql = "SELECT O.OT_ADM AS CODIGO, " &
		 + "O.DESCRIPCION AS DESCRIPCIÓN " &
		 + "FROM OT_ADMINISTRACION O, "&
		 + "ot_adm_user_prod P " &
		 + "WHERE O.OT_ADM = P.OT_ADM " &
		 + "AND P.COD_USR = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
if ls_codigo <> '' then
	this.text= ls_codigo
	sle_desc_ot_adm.text = ls_data
end if


end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text

if ls_codigo = '' then 
	sle_desc_ot_adm.text = ''
	return
end if

SELECT o.descripcion INTO :ls_desc
FROM ot_administracion o,
	  ot_adm_user_prod u
WHERE o.ot_adm = o.ot_adm
  and u.cod_usr = :gs_user
  and o.ot_adm =:ls_codigo;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de OT_ADM no existe o no lo tiene asignado')
	sle_ot_adm.text = ''
	sle_ot_adm.setfocus( )
	return
end if

sle_desc_ot_adm.text = ls_desc


end event

type st_2 from statictext within w_pr327_parte_jornal_campo
integer x = 1536
integer y = 60
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "OT.Adm:"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_desc_ot_adm from singlelineedit within w_pr327_parte_jornal_campo
integer x = 2281
integer y = 60
integer width = 1422
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type cb_1 from commandbutton within w_pr327_parte_jornal_campo
integer x = 3813
integer y = 72
integer width = 421
integer height = 228
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;parent.event ue_retrieve( )
end event

type uo_fechas from u_ingreso_rango_fechas_v within w_pr327_parte_jornal_campo
event destroy ( )
integer x = 23
integer y = 76
integer taborder = 60
boolean bringtotop = true
end type

on uo_fechas.destroy
call u_ingreso_rango_fechas_v::destroy
end on

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') // para seatear el titulo del boton
of_set_fecha(RelativeDate(date(f_fecha_actual()), - 7), date(f_fecha_actual())) //para setear la fecha inicial
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas
end event

type sle_cod_tra from singlelineedit within w_pr327_parte_jornal_campo
event dobleclick pbm_lbuttondblclk
integer x = 1833
integer y = 220
integer width = 439
integer height = 72
integer taborder = 80
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

ls_sql = "select m.cod_trabajador as codigo_trabajador, " &
		 + "	     m.nom_trabajador as nombre_trabajador, " &
		 + "		  m.nro_doc_ident_rtps as nro_doc_ident " &
		 + "from vw_pr_trabajador 		m, " &
	  	 + "		tipo_trabajador_user ttu " &
		 + "WHERE m.tipo_trabajador = ttu.tipo_trabajador" &
		 + "  and (m.fec_cese >= to_date('" + string(ld_fecha1, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') or m.fec_cese is null)" &
		 + "  and m.fec_ingreso <= to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy')" &
		 + "  and ttu.cod_usr = '" + gs_user + "'" &
		 + "  and m.flag_estado = '1'"

		 

if not gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then return

sle_cod_tra.text = ls_codigo
sle_nom_tra.text = ls_data

end event

event modified;String 	ls_codigo, ls_desc, ls_prim_dig
date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

ls_codigo = this.text

if ls_codigo = '' or IsNull(ls_codigo) then
	sle_nom_tra.text = ''
	is_cod_trab = '%%'
	return
end if

if len(ls_codigo) < 8 then
	select substr(to_char(ult_nro), 1,1)
	  into :ls_prim_dig
	  from num_maestro
	 where origen = :gs_origen;
	
	ls_codigo = ls_prim_dig + string(integer(ls_codigo), '0000000')
	this.text = ls_codigo
end if

SELECT apel_paterno || ' ' || apel_materno || ', ' || nombre1 
	INTO :ls_desc
FROM maestro m,
	  tipo_trabajador_user ttu
WHERE m.tipo_trabajador = ttu.tipo_trabajador
  and (m.fec_cese >= :ld_fecha1 or m.fec_cese is null)
  and m.fec_ingreso <= :ld_fecha2
  and m.cod_trabajador =:ls_codigo
  and ttu.cod_usr = :gs_user
  and m.flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', "Codigo de Trabajador no accesible, posiblemente por las siguientes razones: "&
					+ "~r~n1.- Codigo de Trabajador no existe "&
					+ "~r~n2.- Codigo de Trabajador no está activo"&
					+ "~r~n3.- Codigo de Trabajador no ha ingresado en el periodo indicado "&
					+ "~r~n4.- Codigo de Trabaajdor ha cesado antes el periodo indicado "&
					+ "~r~n5.- Codigo de Trabajador pertenece a un tipo de trabajador al cual no tiene acceso."&
					+ "~r~nPor favor verifique con las area involucradas.....")
	sle_nom_tra.text = ''
	sle_cod_tra.text = ''
	return
end if

sle_nom_tra.text = ls_desc


end event

type sle_nom_tra from singlelineedit within w_pr327_parte_jornal_campo
integer x = 2281
integer y = 220
integer width = 1422
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type st_1 from statictext within w_pr327_parte_jornal_campo
integer x = 1536
integer y = 220
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Trabajador"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_procesando from statictext within w_pr327_parte_jornal_campo
boolean visible = false
integer x = 50
integer y = 396
integer width = 407
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Procesando ..."
boolean focusrectangle = false
end type

type sle_labor from singlelineedit within w_pr327_parte_jornal_campo
event dobleclick pbm_lbuttondblclk
integer x = 1833
integer y = 140
integer width = 439
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean lb_ret
string ls_codigo, ls_data, ls_sql

if sle_ot_adm.text = '' then
	is_ot_adm = '%%'
else
	is_ot_adm = sle_ot_adm.text
end if

ls_sql = "SELECT DISTINCT la.cod_labor as codigo_labor, " &
		 + "la.desc_labor as descripción_labor " &
		 + "FROM orden_trabajo ot, " &
		 + "     operaciones   op, " &
		 + "     labor         la, " &
		 + "		ot_adm_user_prod oa " &
		 + "WHERE ot.nro_orden = op.nro_orden " &
		 + "  AND op.cod_labor = la.cod_labor " &
		 + "  AND ot.ot_adm	  = oa.ot_adm " &
		 + "  AND op.flag_estado = '1' " &
		 + "  AND ot.flag_estado = '1' " &
		 + "  AND ot.ot_adm like '" + is_ot_adm + "'" &
		 + "  AND oa.cod_usr = '" + gs_user + "'"
				 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
			
			
if ls_codigo <> '' then
	this.text= ls_codigo
	sle_desc_labor.text = ls_data
end if


end event

event modified;String ls_codigo, ls_desc

ls_codigo = this.text

if ls_codigo = '' or IsNull(ls_codigo) then
	sle_desc_labor.text = ''
	is_labor = '%%'
	return
end if

if sle_ot_adm.text = '' then
	is_ot_adm = '%%'
else
	is_ot_adm = sle_ot_adm.text
end if

SELECT DISTINCT la.desc_labor
	into :ls_desc
FROM orden_trabajo 		ot,
     operaciones   		op,
     labor         		la,
	  ot_adm_user_prod	oa
WHERE ot.nro_orden 	= op.nro_orden
  AND op.cod_labor 	= la.cod_labor
  and ot.ot_adm 	 	= oa.ot_adm
  AND op.flag_estado = '1'
  AND ot.flag_estado = '1'
  and ot.ot_adm like :is_ot_adm
  and la.cod_labor 	= :ls_codigo
  and oa.cod_usr		= :gs_user;

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', 'Codigo de Labor no existe, no está activo o no se está asignado a su usuario')
	return
end if

sle_desc_labor.text = ls_desc




end event

type sle_desc_labor from singlelineedit within w_pr327_parte_jornal_campo
integer x = 2281
integer y = 140
integer width = 1422
integer height = 72
integer taborder = 20
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type st_3 from statictext within w_pr327_parte_jornal_campo
integer x = 1536
integer y = 140
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Labor:"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_4 from statictext within w_pr327_parte_jornal_campo
integer x = 1536
integer y = 380
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Cuadrilla"
alignment alignment = right!
boolean focusrectangle = false
end type

type sle_nom_cuad from singlelineedit within w_pr327_parte_jornal_campo
integer x = 2281
integer y = 380
integer width = 1422
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type sle_cod_cuad from singlelineedit within w_pr327_parte_jornal_campo
event dobleclick pbm_lbuttondblclk
integer x = 1833
integer y = 380
integer width = 439
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_turno, ls_desc_turno
Date		ld_fecha1, ld_fecha2

ls_sql = "select tc.cod_cuadrilla as codigo_cuadrilla, " &
				 + "		  tc.desc_cuadrilla as descripcion_cuadrilla, " &
				 + "		  tu.turno as codigo_turno, " &
				 + "		  tu.descripcion as descripcion_turno " &
				 + "from tg_cuadrillas tc, " &
				 + "     turno 		  tu " &
				 + "where tc.turno = tu.turno " &
				 + "  and tc.flag_estado = '1'"
				 
lb_ret = f_lista_4ret(ls_sql, ls_codigo, ls_data, ls_turno, ls_desc_turno, '1')
		
if ls_codigo <> '' then
	sle_cod_cuad.text = ls_codigo
	sle_nom_cuad.text = ls_data
	cb_importar.enabled = true
else
	sle_cod_cuad.text = ''
	sle_nom_cuad.text = ''
	cb_importar.enabled = false
end if

end event

event modified;String ls_desc, ls_codigo

ls_codigo = trim(this.text)

select tc.desc_cuadrilla
	into :ls_desc
from 	tg_cuadrillas tc, 
		turno 		  tu 
where tc.turno = tu.turno 
  and tc.flag_estado = '1'
  and tc.cod_cuadrilla = :ls_codigo;

if SQLCA.SQLCode = 100 then
	cb_importar.enabled = false
	MessageBox('Error', 'No existe código de cuadrilla ' + ls_codigo + ' o no se encuentra activo, por favor verifique!')
	return
end if

sle_nom_cuad.text = ls_desc
cb_importar.enabled = true




	
end event

type cb_importar from commandbutton within w_pr327_parte_jornal_campo
integer x = 3712
integer y = 380
integer width = 165
integer height = 72
integer taborder = 60
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean enabled = false
string text = ">>"
end type

event clicked;String 		ls_cuadrilla, ls_ot_adm, ls_trabajador, ls_labor, ls_desc_labor, ls_und, ls_nro_ot, ls_oper_sec
Date 			ld_fec_parte
Integer 		li_i, li_row, li_j
u_ds_base 	ds_cuadrilla_det


ls_cuadrilla = sle_cod_cuad.text

if ls_cuadrilla = '' or IsNull(ls_cuadrilla) then
	MessageBox('Error', 'Debe elegir una cuadrilla primero', StopSign!)
	return
end if

ld_fec_parte =  uo_fechas.of_get_fecha1( )

if not of_select_origen() then
	MessageBox('Error', 'Debe seleccionar un origen antes de importar una cuadrilla', StopSign!)
	return
end if

ds_cuadrilla_det = create u_ds_base
ds_cuadrilla_det.DataObject = 'd_list_cuadrillas_det_tbl'
ds_cuadrilla_det.SetTransObject(SQLCA)
ds_cuadrilla_det.Retrieve(ls_cuadrilla, ld_fec_parte)

if ds_cuadrilla_det.RowCount() = 0 then
	MessageBox('Error', 'No existen trabajadores asignador a la cuadrilla ' + ls_cuadrilla + ', por favor verifique!')
	return
end if

if MessageBox('Aviso', 'Desea importar ' + string(ds_cuadrilla_det.RowCount()) + ' trabajadores al parte de jornal de campo', Information!, YesNo!, 2) = 2 then return

//OT_ADM
if trim(sle_ot_adm.text) = '' then
	ls_ot_adm  = "%%"
else
	ls_ot_adm  = trim(sle_ot_adm.text) + '%'
end if

//Recorro el datasurce de los trabajadores
for li_i=1 to ds_cuadrilla_det.RowCount()
	
	ls_trabajador = ds_cuadrilla_det.object.cod_trabajador [li_i]
	
	li_row = dw_master.event ue_insert()
	if li_row > 0 then
		dw_master.object.fecha 					[li_row] = ld_fec_parte
		dw_master.object.nro_doc_ident_rtps [li_row] = ds_cuadrilla_det.object.nro_doc_ident_rtps [li_i]
		dw_master.object.cod_trabajador 		[li_row] = ls_trabajador
		dw_master.object.nom_trabajador 		[li_row] = ds_cuadrilla_det.object.nom_trabajador 		[li_i]
		dw_master.object.tipo_trabajador		[li_row] = ds_cuadrilla_det.object.tipo_trabajador 	[li_i]
		dw_master.object.cod_cuadrilla 		[li_row] = ds_cuadrilla_det.object.cod_Cuadrilla	 	[li_i]
		dw_master.object.ot_adm 				[li_row] = sle_ot_adm.text
		dw_master.object.nro_item 				[li_row] = of_nro_item(dw_master)
		dw_master.object.nro_item 				[li_row] = of_nro_item( ld_fec_parte, ls_trabajador, li_row)
		
		
		SELECT la.cod_labor, la.desc_labor, la.und, ot.nro_orden, op.oper_sec
			into :ls_labor, :ls_desc_labor, :ls_und, :ls_nro_ot, :ls_oper_sec
		from 	orden_trabajo 		ot, 
				operaciones   		op, 
				labor         		la, 
				labor_trabajador 	lt 
		WHERE ot.nro_orden = op.nro_orden 
		  AND op.cod_labor = la.cod_labor 
		  AND la.cod_labor = lt.cod_labor 
		  AND lt.cod_trabajador = :ls_trabajador
		  AND op.flag_estado = '1' 
		  AND ot.ot_adm like :ls_ot_adm;
		  //AND to_char(op.fec_inicio, 'yyyy') <= to_char(:ld_fec_parte, 'yyyy');
			 
		dw_master.object.cod_labor		[li_row] = ls_labor
		dw_master.object.desc_labor	[li_row] = ls_desc_labor
		dw_master.object.und				[li_row] = ls_und
		dw_master.object.nro_orden		[li_row] = ls_nro_ot
		dw_master.object.oper_sec		[li_row] = ls_oper_sec
		dw_master.object.hrs_normales [li_row] = of_set_hrs_normales(ls_trabajador, ld_fec_parte, li_row)
	end if
next

destroy ds_cuadrilla_det

end event

type sle_desc_ot from singlelineedit within w_pr327_parte_jornal_campo
integer x = 2281
integer y = 300
integer width = 1422
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 67108864
end type

type sle_nro_ot from singlelineedit within w_pr327_parte_jornal_campo
event dobleclick pbm_lbuttondblclk
integer x = 1833
integer y = 300
integer width = 439
integer height = 72
integer taborder = 90
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "C:\SIGRE\resources\cur\taladro.cur"
long backcolor = 16777215
boolean autohscroll = false
textcase textcase = upper!
integer limit = 8
borderstyle borderstyle = stylelowered!
end type

event dobleclick;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql
Date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

ls_sql = "SELECT ot.nro_orden AS nro_ot, ot.descripcion AS Descripcion" &
		+ " FROM orden_trabajo ot " &
  		+ " WHERE ot.flag_estado = '1' and " &
		+ " ot.fec_inicio <= to_date('" + string(ld_fecha2, 'dd/mm/yyyy') + "', 'dd/mm/yyyy') " &
		 
lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

if isnull(ls_codigo) or trim(ls_data)  = '' then return

sle_nro_ot.text = ls_codigo
sle_desc_ot.text = ls_data

end event

event modified;String 	ls_codigo, ls_desc, ls_prim_dig
date		ld_fecha1, ld_fecha2

ld_fecha1 = uo_fechas.of_get_fecha1( )
ld_fecha2 = uo_fechas.of_get_fecha2( )

ls_codigo = this.text

if ls_codigo = '' or IsNull(ls_codigo) then
	sle_nom_tra.text = ''
	is_cod_trab = '%%'
	return
end if

if len(ls_codigo) < 8 then
	select substr(to_char(ult_nro), 1,1)
	  into :ls_prim_dig
	  from num_maestro
	 where origen = :gs_origen;
	
	ls_codigo = ls_prim_dig + string(integer(ls_codigo), '0000000')
	this.text = ls_codigo
end if

SELECT apel_paterno || ' ' || apel_materno || ', ' || nombre1 
	INTO :ls_desc
FROM maestro m,
	  tipo_trabajador_user ttu
WHERE m.tipo_trabajador = ttu.tipo_trabajador
  and (m.fec_cese >= :ld_fecha1 or m.fec_cese is null)
  and m.fec_ingreso <= :ld_fecha2
  and m.cod_trabajador =:ls_codigo
  and ttu.cod_usr = :gs_user
  and m.flag_estado = '1';

IF SQLCA.SQLCode = 100 THEN
	Messagebox('Aviso', "Codigo de Trabajador no accesible, posiblemente por las siguientes razones: "&
					+ "~r~n1.- Codigo de Trabajador no existe "&
					+ "~r~n2.- Codigo de Trabajador no está activo"&
					+ "~r~n3.- Codigo de Trabajador no ha ingresado en el periodo indicado "&
					+ "~r~n4.- Codigo de Trabaajdor ha cesado antes el periodo indicado "&
					+ "~r~n5.- Codigo de Trabajador pertenece a un tipo de trabajador al cual no tiene acceso."&
					+ "~r~nPor favor verifique con las area involucradas.....")
	sle_nom_tra.text = ''
	sle_cod_tra.text = ''
	return
end if

sle_nom_tra.text = ls_desc


end event

type st_5 from statictext within w_pr327_parte_jornal_campo
integer x = 1536
integer y = 300
integer width = 279
integer height = 72
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217730
long backcolor = 67108864
string text = "Nro OT"
alignment alignment = right!
boolean focusrectangle = false
end type

type st_registros from statictext within w_pr327_parte_jornal_campo
integer x = 3534
integer y = 476
integer width = 704
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
alignment alignment = right!
boolean focusrectangle = false
end type

type gb_2 from groupbox within w_pr327_parte_jornal_campo
integer width = 4283
integer height = 556
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 8388608
long backcolor = 67108864
string text = "Cargar Asistencia por Rango de fechas, Origen y OT_ADM."
end type

