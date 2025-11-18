$PBExportHeader$w_pr304_parte_diario.srw
forward
global type w_pr304_parte_diario from w_abc
end type
type st_4 from statictext within w_pr304_parte_diario
end type
type st_3 from statictext within w_pr304_parte_diario
end type
type dw_lista from u_dw_list_tbl within w_pr304_parte_diario
end type
type st_2 from statictext within w_pr304_parte_diario
end type
type uo_1 from u_ingreso_rango_fechas within w_pr304_parte_diario
end type
type st_1 from statictext within w_pr304_parte_diario
end type
type dw_operaciones from u_dw_abc within w_pr304_parte_diario
end type
type tab_1 from tab within w_pr304_parte_diario
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detart from u_dw_abc within tabpage_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detart dw_detart
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_detinc from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_detinc dw_detinc
end type
type tabpage_3 from userobject within tab_1
end type
type sle_search from editmask within tabpage_3
end type
type st_search from statictext within tabpage_3
end type
type dw_codrel from u_dw_abc within tabpage_3
end type
type pb_1 from picturebutton within tabpage_3
end type
type dw_detasis from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
sle_search sle_search
st_search st_search
dw_codrel dw_codrel
pb_1 pb_1
dw_detasis dw_detasis
end type
type tabpage_4 from userobject within tab_1
end type
type dw_causas from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_causas dw_causas
end type
type tabpage_5 from userobject within tab_1
end type
type dw_riegos from u_dw_abc within tabpage_5
end type
type tabpage_5 from userobject within tab_1
dw_riegos dw_riegos
end type
type tabpage_6 from userobject within tab_1
end type
type dw_maquina from u_dw_abc within tabpage_6
end type
type tabpage_6 from userobject within tab_1
dw_maquina dw_maquina
end type
type tabpage_7 from userobject within tab_1
end type
type dw_destajo from u_dw_abc within tabpage_7
end type
type tabpage_7 from userobject within tab_1
dw_destajo dw_destajo
end type
type tabpage_8 from userobject within tab_1
end type
type dw_atributos from u_dw_abc within tabpage_8
end type
type dw_atrdis from u_dw_abc within tabpage_8
end type
type dw_prodfin from u_dw_abc within tabpage_8
end type
type tabpage_8 from userobject within tab_1
dw_atributos dw_atributos
dw_atrdis dw_atrdis
dw_prodfin dw_prodfin
end type
type tab_1 from tab within w_pr304_parte_diario
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type
type dw_master from u_dw_abc within w_pr304_parte_diario
end type
type em_nro_parte from editmask within w_pr304_parte_diario
end type
end forward

global type w_pr304_parte_diario from w_abc
integer width = 3447
integer height = 1896
string title = "Parte Diario de Producción(PR304)"
string menuname = "m_mantto_consulta"
boolean maxbox = false
boolean resizable = false
boolean center = true
st_4 st_4
st_3 st_3
dw_lista dw_lista
st_2 st_2
uo_1 uo_1
st_1 st_1
dw_operaciones dw_operaciones
tab_1 tab_1
dw_master dw_master
em_nro_parte em_nro_parte
end type
global w_pr304_parte_diario w_pr304_parte_diario

type variables
String  	is_accion,is_col,is_data_type
String  	is_tabla_1    ,is_tabla_2    ,is_tabla_3    ,is_tabla_4    ,is_tabla_5    ,is_tabla_6    , &
			is_tabla_7    ,is_tabla_8    ,is_tabla_9    

String	is_colname_1[],is_colname_2[],is_colname_3[],is_colname_4[],is_colname_5[],is_colname_6[], &
		  	is_colname_7[],is_colname_8[],is_colname_9[]

String  	is_coltype_1[],is_coltype_2[],is_coltype_3[],is_coltype_4[],is_coltype_5[],is_coltype_6[], &
			is_coltype_7[],is_coltype_8[],is_coltype_9[]
			
string is_doc_ot, is_ot_adm
Boolean 	ib_detail_new
n_cst_log_diario	in_log

















































end variables

forward prototypes
public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje)
public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, string as_oper_sec, long al_item)
public subroutine wf_retrieve (string as_nro_parte)
public subroutine wf_verifica_parte (string as_nro_parte, long al_nro_item, string as_oper_sec, ref string as_flag_estado)
public subroutine wf_retrieve_articulos ()
public subroutine wf_retrieve_dws ()
public function integer wf_lect_atributo (string as_atributo)
public subroutine wf_costo_prom_maq (ref decimal adc_costo_prom, ref decimal adc_cant_hrs, ref decimal adc_costo_tot)
public function string wf_insert_oper_sec (string as_nro_orden, string as_cod_labor, string as_cod_ejecutor, string as_proveedor, datetime adt_fec_inicio, datetime adt_fec_final, decimal adc_cant_avance, string as_und_avance, decimal adc_cant_labor, string as_obs, string as_desc_labor, decimal adc_costo_labor)
public function integer of_carga_master (string as_nro_parte)
public function integer of_carga_lista (string as_nro_parte)
public function long of_carga_detail ()
public function long of_carga_detart ()
public function integer of_carga_operaciones ()
public function integer of_carga_detinc ()
public function integer of_carga_detasis ()
public function long of_carga_causas ()
public function long of_carga_maquina ()
public function long of_carga_destajo ()
public function long of_carga_prodfin ()
public function long of_carga_atrdis ()
public function long of_carga_atributos ()
public subroutine of_act_cant_costo_labor ()
public subroutine of_selecciona_operacion ()
public subroutine of_selecciona_labor ()
public subroutine miguel_caleron ()
end prototypes

public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje);//Boolean lb_retorno =TRUE
//Long ll_nro_ot
//String ls_lock_table
//
//ls_lock_table = 'LOCK TABLE NUM_PD_OT IN EXCLUSIVE MODE'
//EXECUTE IMMEDIATE :ls_lock_table ;
//
//SELECT ult_nro
//  INTO :al_nro_ot
//  FROM num_pd_ot
// WHERE (reckey = '1') ;
//
//	
//	
//IF Isnull(al_nro_ot) OR al_nro_ot = 0 THEN
//	lb_retorno = FALSE
//	as_mensaje = 'Numerador Para Parte Diario de OT debe Empezar en 1 Verifique Tabla de Numeración NUM_PD_OT '
//	GOTO SALIDA
//END IF
//
////****************************//
////Actualiza Tabla num_doc_tipo//
////****************************//
//	
//UPDATE num_pd_ot
//	SET ult_nro = :al_nro_ot + 1
// WHERE (reckey = '1') ;
//	
//IF SQLCA.SQLCode = -1 THEN 
//	as_mensaje = 'No se Pudo Actualizar Tabla num_pd_ot , Verifique!'
//	lb_retorno = FALSE
//	GOTO SALIDA
//END IF	
//
//
//SALIDA:
//
//Return lb_retorno
//
Return true
end function

public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, string as_oper_sec, long al_item);String      ls_cod_art,ls_nom_art,ls_und, ls_parte 
String		ls_mov_sal, ls_mov_ing, ls_cadena
Decimal {2} ldc_costo_ult_compra
Decimal {4} ldc_cantidad
Long			ll_row, ll_i, ll_found
u_dw_abc		ldw_1

ll_row = dw_master.GetRow()
if ll_row <= 0 then
	return
end if
ls_parte = dw_master.object.nro_parte[ll_row]

SetNull(ls_mov_sal)
SetNull(ls_mov_ing)
select oper_cons_interno, oper_ing_prod
	into :ls_mov_sal, :ls_mov_ing
from logparam
where reckey = '1';

if ls_mov_sal = '' or IsNull(ls_mov_sal) then
	MessageBox('PRODUCCION', 'NO SE HA DEFINIDO LOGPARAM.OPER_CONS_INTERNO',StopSign!)
	return 
end if

if ls_mov_ing = '' or IsNull(ls_mov_ing) then
	MessageBox('PRODUCCION', 'NO SE HA DEFINIDO LOGPARAM.OPER_ING_PROD',StopSign!)
	return 
end if

/*************** Insumos de Produccion ***************/
ldw_1  = tab_1.tabpage_1.dw_detart
ll_row = ldw_1.RowCount()
for ll_i = 1 to ll_row
	ldw_1.DeleteRow(0)
next

/*Declaración de Cursor*/
DECLARE art_ope CURSOR FOR
  SELECT am.cod_art         ,
 			am.cant_proyect    , 
			a.nom_articulo	    ,
			a.und				    ,
			a.costo_prom_dol
  	 FROM articulo_mov_proy am,	
			articulo          a
	WHERE am.cod_art  = a.cod_art    
	  AND am.oper_sec = :as_oper_sec 
	  AND am.tipo_mov = :ls_mov_sal;
					

/*Abrir Cursor*/		  	
OPEN art_ope ;

	
	DO 				/*Recorro Cursor*/	
	 FETCH art_ope INTO :ls_cod_art,:ldc_cantidad,:ls_nom_art,:ls_und,:ldc_costo_ult_compra;
	 IF sqlca.sqlcode = 100 THEN EXIT
	 /**Inserción de Registros**/ 
	 ll_row = tab_1.tabpage_1.dw_detart.InsertRow(0)
	 
	 ldw_1.ii_update = 1
	 ldw_1.object.nro_item	   [ll_row] = al_item
	 ldw_1.object.nro_parte	   [ll_row] = ls_parte
	 ldw_1.object.cod_art      [ll_row] = ls_cod_art
	 ldw_1.object.cantidad     [ll_row] = ldc_cantidad
	 ldw_1.object.nom_articulo [ll_row] = ls_nom_art
	 ldw_1.object.costo_insumo [ll_row] = ldc_costo_ult_compra
	 ldw_1.object.und			   [ll_row] = ls_und
	 
	 
	LOOP WHILE TRUE
	
CLOSE art_ope ; /*Cierra Cursor*/

/*************** Articulos Producidos ***************/
ldw_1  = tab_1.tabpage_8.dw_prodfin
ll_row = ldw_1.RowCount()
for ll_i = 1 to ll_row
	ldw_1.DeleteRow(0)
next

/*Declaración de Cursor*/
DECLARE art_prod CURSOR FOR
  SELECT am.cod_art         ,
 			am.cant_proyect    , 
			a.nom_articulo	    ,
			a.und				    ,
			a.costo_prom_dol
  	 FROM articulo_mov_proy am,	
			articulo          a,
			tg_producto_final b
	WHERE am.cod_art  = a.cod_art    
	  AND a.cod_art   = b.cod_art
	  AND am.oper_sec = :as_oper_sec 
	  AND am.tipo_mov = :ls_mov_ing;
					

/*Abrir Cursor*/		  	
OPEN art_prod ;

	
DO 				/*Recorro Cursor*/	
	FETCH art_prod INTO :ls_cod_art, :ldc_cantidad, :ls_nom_art, 
 			:ls_und,:ldc_costo_ult_compra;
			 
 	IF sqlca.sqlcode = 100 THEN EXIT
	 
 	/** Inserción de Registros **/ 
	/** Solo añado aquellos que no existen **/
 	ls_cadena = "cod_art = '" + ls_cod_art + "'"
 	ll_found = ldw_1.find( ls_cadena, 1, ldw_1.RowCount())
		if ll_found = 0 then
			ll_row = ldw_1.event ue_insert()
	 
			ldw_1.object.cod_art      [ll_row] = ls_cod_art
			ldw_1.object.cantidad     [ll_row] = ldc_cantidad
		 	ldw_1.object.nom_articulo [ll_row] = ls_nom_art
		 	ldw_1.object.und			   [ll_row] = ls_und
 		 	ldw_1.ii_update = 1
		end if
	 
LOOP WHILE TRUE
	
CLOSE art_prod ; /*Cierra Cursor*/
end subroutine

public subroutine wf_retrieve (string as_nro_parte);///*****************************************/
///*      Recuperacion de Información      */
///*****************************************/
//Long   	ll_item
//String 	ls_tdoc,ls_ndoc,ls_labor,ls_ejecutor
//u_dw_abc ldw_1
//
//dw_master.Retrieve(as_nro_parte)
//
//ldw_1 = tab_1.tabpage_1.dw_detail
//ldw_1.Retrieve(as_nro_parte)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
///**/
//dw_master.il_row = 1
//
//IF ldw_1.Rowcount() > 0 THEN
//	/*Primer Registro*/
//	
//	ll_item  	= ldw_1.Object.nro_item[1]
//	ls_ndoc  	= ldw_1.Object.nro_orden[1]
//	ls_labor 	= ldw_1.Object.cod_labor[1]
//	ls_ejecutor = ldw_1.Object.cod_ejecutor[1]
//	
//	wf_retrieve_articulos()
//	wf_retrieve_dws ()
//	wf_retrieve_operaciones (ls_ndoc,ls_labor,ls_ejecutor)
//	
//END IF
//
//dw_master.Setfocus()
end subroutine

public subroutine wf_verifica_parte (string as_nro_parte, long al_nro_item, string as_oper_sec, ref string as_flag_estado);//String ls_new_parte,ls_new_item
//
//
//DECLARE PB_USP_OPE_VER_ESTADO_OPER_SEC PROCEDURE FOR USP_OPE_VER_ESTADO_OPER_SEC 
//(:as_nro_parte,:al_nro_item,:as_oper_sec);
//EXECUTE PB_USP_OPE_VER_ESTADO_OPER_SEC ;
//
//
//
//IF SQLCA.SQLCode = -1 THEN 
//	MessageBox("SQL error", SQLCA.SQLErrText)
//END IF
//
//FETCH PB_USP_OPE_VER_ESTADO_OPER_SEC INTO :ls_new_parte,:ls_new_item,:as_flag_estado ;
//CLOSE PB_USP_OPE_VER_ESTADO_OPER_SEC ;
//
//
//IF as_flag_estado = '1' THEN //OPER SEC YA FUE TERMINADO
//	Messagebox('Aviso','Oper sec ya Fue Terminado ,Revise Nro de Parte '+Trim(as_nro_parte)+' Nro de Item '+Trim(ls_new_item))
//END IF
end subroutine

public subroutine wf_retrieve_articulos ();//long 		ll_row, ll_item
//string	ls_parte
//u_dw_abc ldw_1
//
//if ib_detail_new <> TRUE then
//	event ue_update_request()
//end if
//
//ldw_1 = tab_1.tabpage_1.dw_detail
//ll_row = ldw_1.GetRow()
//
//if ll_row <= 0 then
//	return
//end if
//
//ls_parte = ldw_1.object.nro_parte[ll_row]
//ll_item  = long(ldw_1.object.nro_item[ll_row])
//
//ldw_1 = tab_1.tabpage_1.dw_detart
//ldw_1.retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
end subroutine

public subroutine wf_retrieve_dws ();//String 	ls_expresion, ls_parte, ls_flag_terminado, ls_oper_sec
//long 		ll_row, ll_item, ll_x
//Decimal	ldc_precio_unit
//u_dw_abc ldw_1, ldw_destajo, ldw_detail
//
//ll_row = dw_master.GetRow()
//if ll_row <= 0 then return
//
//ls_parte = dw_master.object.nro_parte[ll_row]
//
//if ls_parte = '' or IsNull(ls_parte) then return
//
//ldw_1 = tab_1.tabpage_1.dw_detail
//ll_row = ldw_1.GetRow()
//if ll_row <= 0 then return
//ll_item = Long(ldw_1.object.nro_item[ll_row])
//
//ldw_1 = tab_1.tabpage_2.dw_detinc
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_1 = tab_1.tabpage_3.dw_detasis
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_1 = tab_1.tabpage_4.dw_causas
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_1 = tab_1.tabpage_5.dw_riegos
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_1 = tab_1.tabpage_6.dw_maquina
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_1 = tab_1.tabpage_7.dw_destajo
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//ldw_destajo = tab_1.tabpage_7.dw_destajo
//ldw_detail  = tab_1.tabpage_1.dw_detail
//		
//ls_flag_terminado = ldw_detail.object.flag_terminado[ll_row]
//		
//if ls_flag_terminado = '1' then
//	ls_oper_sec = ldw_detail.object.oper_sec[ll_row]
//	select costo_unit
//		into :ldc_precio_unit
//	from operaciones
//	where oper_sec = :ls_oper_sec;
//			
//	if IsNull(ldc_precio_unit) then ldc_precio_unit = 0
//		
//	for ll_x = 1 to ldw_destajo.RowCount()
//		ldw_destajo.object.precio_unit[ll_x] = ldc_precio_unit
//	next
//			
//end if
//
//
//ldw_1 = tab_1.tabpage_8.dw_prodfin
//ldw_1.Retrieve(ls_parte, ll_item)
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//if ldw_1.RowCount() > 0 then
//	ldw_1.event RowFocusChanged(1)
//else
//	tab_1.tabpage_8.dw_atrdis.Reset()
//	tab_1.tabpage_8.dw_atributos.Reset()
//end if
//
//ldw_1 = tab_1.tabpage_8.dw_atributos
//ldw_1.ii_update = 0
//ldw_1.ii_protect = 0
//ldw_1.of_protect()
//
//
//
end subroutine

public function integer wf_lect_atributo (string as_atributo);u_dw_abc ldw_1
integer  li_lectura, li_i, li_tmp
string   ls_tmp

ldw_1 = tab_1.tabpage_8.dw_atributos
li_lectura = 0

for li_i = 1 to ldw_1.RowCount()
	ls_tmp = ldw_1.object.atributo[li_i]
	li_tmp = Integer(ldw_1.object.nro_lectura[li_i])
	if ls_tmp = as_atributo then
		if li_lectura <= li_tmp then
			li_lectura = li_tmp
		end if
	end if
next

li_lectura ++
return li_lectura

end function

public subroutine wf_costo_prom_maq (ref decimal adc_costo_prom, ref decimal adc_cant_hrs, ref decimal adc_costo_tot);u_dw_abc 	ldw_maq
long			ll_x

ldw_maq 	= tab_1.tabpage_6.dw_maquina
adc_costo_tot = 0
adc_cant_hrs	= 0
for ll_x = 1 to ldw_maq.RowCount()
	adc_cant_hrs 	+= Dec(ldw_maq.object.cant_trabajada[ll_x])
	adc_costo_tot	+= Dec(ldw_maq.object.costo_horas[ll_x])
next

if adc_cant_hrs <> 0 then
	adc_costo_prom = adc_costo_tot/adc_cant_hrs
else
	adc_costo_prom = 0
end if
end subroutine

public function string wf_insert_oper_sec (string as_nro_orden, string as_cod_labor, string as_cod_ejecutor, string as_proveedor, datetime adt_fec_inicio, datetime adt_fec_final, decimal adc_cant_avance, string as_und_avance, decimal adc_cant_labor, string as_obs, string as_desc_labor, decimal adc_costo_labor);Long   ll_nro_oper
String ls_doc_ot,ls_oper_sec,ls_msj_err

//parametro de ot
select doc_ot into :ls_doc_ot from prod_param where reckey = '1' ;

//nro de operacion maxima
select max(nro_operacion) into :ll_nro_oper 
from operaciones where nro_orden = :as_nro_orden ;


if isnull(ll_nro_oper) or ll_nro_oper = 0 then
	ll_nro_oper = 10
else
	ll_nro_oper = ll_nro_oper + 10
end if


//numerador de operaciones
//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios

IF lnvo_numeradores_varios.uf_num_oper_sec (gs_origen,ls_oper_sec) = FALSE THEN
	SetNull(ls_oper_sec)
	Return ls_oper_sec

END IF			 

//override
insert into operaciones
(nro_operacion  , cod_labor       , cod_ejecutor   , proveedor  ,   
 flag_estado    , desc_operacion  , fec_inicio_est , fec_inicio ,
 fec_fin			 , cant_proyect    , costo_unit     , tipo_orden ,
 nro_orden      , obs             , avance_esperado, avance_und ,
 oper_sec)  
values
(:ll_nro_oper   , :as_cod_labor   , :as_cod_ejecutor , :as_proveedor  ,
 '3'            , :as_desc_labor  , :adt_fec_inicio  , :adt_fec_inicio,
 :adt_fec_final , :adc_cant_labor , :adc_costo_labor , :ls_doc_ot     ,
 :as_nro_orden  , :as_obs         , :adc_cant_avance , :as_und_avance ,
 :ls_oper_sec)   ;
 

//se dispara grabacion de oper sec
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	SetNull(ls_oper_sec)
   MessageBox('SQL error', ls_msj_err)
	Return ''
ELSE
	Commit ;
END IF


//RECUPERO INFORMACION GRABADA
//wf_retrieve_operaciones (as_nro_orden,as_cod_labor,as_cod_ejecutor)

DESTROY lnvo_numeradores_varios


Return ls_oper_sec
end function

public function integer of_carga_master (string as_nro_parte);long ll_cuenta
dw_master.retrieve(as_nro_parte, gs_user)
ll_cuenta = dw_master.rowcount()
dw_master.il_row = ll_cuenta
tab_1.selecttab(1)
return ll_cuenta
end function

public function integer of_carga_lista (string as_nro_parte);long ll_cuenta
dw_lista.reset()
dw_lista.retrieve(as_nro_parte)
ll_cuenta = dw_lista.rowcount()
if ll_cuenta >=1 then
	dw_lista.setrow(1)
	dw_lista.scrolltorow(1)
	dw_lista.selectrow(1, true)
end if
return ll_cuenta
end function

public function long of_carga_detail ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_1.dw_detail.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_1.dw_detail.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_1.dw_detail.rowcount( )
tab_1.tabpage_1.dw_detail.il_row = ll_cuenta
return ll_cuenta
end function

public function long of_carga_detart ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )
tab_1.tabpage_1.dw_detart.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_1.dw_detart.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_1.dw_detart.rowcount( )
return ll_cuenta
end function

public function integer of_carga_operaciones ();string ls_cod_labor, ls_cod_ejecutor, ls_nro_orden
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

if ll_row >= 1 then
	dw_operaciones.reset()
	ls_nro_orden = dw_lista.object.nro_orden[ll_row]
//	ls_cod_labor = dw_lista.object.cod_labor[ll_row]
//	ls_cod_ejecutor = dw_lista.object.cod_ejecutor[ll_row]
	dw_operaciones.retrieve(is_doc_ot, ls_nro_orden, ls_cod_labor, ls_cod_ejecutor)
end if
ll_cuenta = dw_operaciones.rowcount( )
return ll_cuenta
end function

public function integer of_carga_detinc ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_2.dw_detinc.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_2.dw_detinc.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_2.dw_detinc.rowcount( )
return ll_cuenta
end function

public function integer of_carga_detasis ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_3.dw_detasis.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_3.dw_detasis.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_3.dw_detasis.rowcount( )
return ll_cuenta
end function

public function long of_carga_causas ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_4.dw_causas.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_4.dw_causas.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_4.dw_causas.rowcount( )
return ll_cuenta
end function

public function long of_carga_maquina ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_6.dw_maquina.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_6.dw_maquina.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_6.dw_maquina.rowcount( )
return ll_cuenta
end function

public function long of_carga_destajo ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_7.dw_destajo.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_7.dw_destajo.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_7.dw_destajo.rowcount( )
return ll_cuenta
end function

public function long of_carga_prodfin ();integer li_nro_item
string ls_nro_parte
long ll_row, ll_cuenta

ll_row = dw_lista.getrow( )

tab_1.tabpage_8.dw_prodfin.reset( )

if ll_row >= 1 then
	ls_nro_parte = dw_lista.object.nro_parte[ll_row]
	li_nro_item = dw_lista.object.nro_item[ll_row]
	tab_1.tabpage_8.dw_prodfin.retrieve(ls_nro_parte, li_nro_item)
end if

ll_cuenta = tab_1.tabpage_8.dw_prodfin.rowcount( )
return ll_cuenta
end function

public function long of_carga_atrdis ();string ls_cod_art
long ll_row, ll_cuenta
ll_row = tab_1.tabpage_8.dw_prodfin.getrow( )
tab_1.tabpage_8.dw_atrdis.reset( )
if ll_row >= 1 then
	ls_cod_art = tab_1.tabpage_8.dw_prodfin.object.cod_art[ll_row]
	tab_1.tabpage_8.dw_atrdis.retrieve(ls_cod_art)
end if
ll_cuenta = tab_1.tabpage_8.dw_atrdis.rowcount( )
return ll_cuenta
end function

public function long of_carga_atributos ();integer li_item
string ls_cod_art, ls_parte
long ll_lista, ll_prodfin, ll_cuenta

tab_1.tabpage_8.dw_atributos.reset( )

ll_lista = dw_lista.getrow()
ll_prodfin = tab_1.tabpage_8.dw_prodfin.getrow( )


if ll_lista >= 1 and ll_prodfin >= 1 then
	
	ls_parte = dw_lista.object.nro_parte[ll_lista]
	li_item = dw_lista.object.nro_item[ll_lista]
	ls_cod_art = tab_1.tabpage_8.dw_prodfin.object.cod_art[ll_prodfin]
	
	tab_1.tabpage_8.dw_atributos.retrieve(ls_parte, li_item, ls_cod_art)
	
end if
ll_cuenta = tab_1.tabpage_8.dw_atributos.rowcount( )
return ll_cuenta
end function

public subroutine of_act_cant_costo_labor ();Decimal {4} ldc_costo_x_hora, ldc_total_x_hora, ldc_costo_labor_old   , &
				ldc_cant_horas  , ldc_cant_tot_hor, ldc_cant_labor_old    , &
				ldc_cant_inc	 , ldc_total_inc   ,	ldc_costo_unitario, &
				ldc_tot_inc_old , ldc_cant_dest   , ldc_total_destajo , &
				ldc_cost_unit_dest, ldc_cant_avance, ldc_hrs_maq, ldc_costo_maq, &
				ldc_costo_prom_maq
				
Long        ll_row_det,ll_inicio

String 		ls_cod_labor, ls_und, ls_flag_maq_mo, ls_und_hr, &
				ls_cod_ejecutor, ls_oper_sec, ls_unid_avance,    &
				ls_unid_dest
				
Datetime    ldt_hora_inicio, ldt_hora_fin, ldt_inc_inicio, &
				ldt_inc_fin

u_dw_abc		ldw_1, ldw_detail, ldw_destajo, ldw_maq

// Esta funcion actualiza el Costo de la Labor en el detalle del Parte Diario

ldw_detail 	= tab_1.tabpage_1.dw_detail
ldw_destajo = tab_1.tabpage_7.dw_destajo
ldw_maq		= tab_1.tabpage_6.dw_maquina
//
ldw_detail.accepttext()
tab_1.tabpage_2.dw_detinc.accepttext()
tab_1.tabpage_3.dw_detasis.accepttext()
ldw_destajo.AcceptText()

//inicialización de variable
ldc_total_inc = 0.00

//calculo de acuerdo a labor
ll_row_det = ldw_detail.Getrow ()

IF ll_row_det = 0 THEN RETURN

//PARAMETRO DE UNIDAD DE HRS
select und_hr 
	into :ls_und_hr 
from prod_param 
where reckey = '1' ;
//

ls_cod_labor    = ldw_detail.Object.cod_labor    [ll_row_det]
ls_cod_ejecutor = ldw_detail.Object.cod_ejecutor [ll_row_det]

SELECT und, flag_maq_mo 
	INTO :ls_und ,:ls_flag_maq_mo 
FROM labor 
WHERE cod_labor = :ls_cod_labor ;


//Acumular Horas de incidencias  x item 
ldw_1 = tab_1.tabpage_2.dw_detinc
For ll_inicio = 1 TO ldw_1.Rowcount()
	ldt_inc_inicio = DateTime(ldw_1.object.fecha_inicio [ll_inicio])
   ldt_inc_fin	 	= DateTime(ldw_1.object.fecha_fin    [ll_inicio])
		  
   //diferencias de labor
	ldc_cant_inc 	= f_rango_horas( ldt_inc_inicio, ldt_inc_fin)
   IF Isnull(ldc_cant_inc) THEN ldc_cant_inc = 0.00
   ldc_total_inc += ldc_cant_inc

Next

//actualizo detalle de item si ha cambiado
ldc_tot_inc_old 		= ldw_detail.object.horas_inciden [ll_row_det] //old incidencia
ldc_costo_labor_old 		= ldw_detail.object.costo_labor   [ll_row_det] //old costo
ldc_cant_labor_old  	= ldw_detail.object.cant_labor    [ll_row_det] //old cantidad
	

if Isnull(ldc_tot_inc_old) 		then ldc_tot_inc_old = 0.00
if Isnull(ldc_costo_labor_old) 		then ldc_costo_labor_old = 0.00
if Isnull(ldc_cant_labor_old ) 	then ldc_cant_labor_old  = 0.00

IF ldc_tot_inc_old <> ldc_total_inc THEN
	ldw_detail.object.horas_inciden [ll_row_det] = ldc_total_inc
	ldw_detail.ii_update = 1
END IF

IF (ls_flag_maq_mo = 'O' AND ls_und = ls_und_hr) THEN 
	//mano de obra y calculado en hrs
	
	ldc_total_x_hora = 0.00 //costo de hrs
	ldc_cant_tot_hor = 0.00 //cantidad de hrs
	 
	/*Asistencia x Item*/
	ldw_1 = tab_1.tabpage_3.dw_detasis
 	FOR ll_inicio = 1 TO ldw_1.Rowcount()
		/*Costo x hora*/
  		ldc_costo_x_hora = ldw_1.object.total_hora [ll_inicio]
		ldc_cant_horas   = ldw_1.object.nro_horas  [ll_inicio]
		  
		IF Isnull(ldc_costo_x_hora) THEN ldc_costo_x_hora = 0.00
		IF Isnull(ldc_cant_horas)	 THEN ldc_cant_horas   = 0.00
		  
		ldc_total_x_hora += ldc_costo_x_hora
		ldc_cant_tot_hor += ldc_cant_horas
		  
		IF Isnull(ldc_total_x_hora) THEN ldc_total_x_hora = 0.00
		IF Isnull(ldc_cant_tot_hor) THEN ldc_cant_tot_hor = 0.00
		  
	NEXT
	 
	// Costo Maquinaria
	wf_costo_prom_maq( ldc_costo_prom_maq, ldc_hrs_maq, ldc_costo_maq )
	
	// Actualizo el Costo Unit de la tabla Operaciones
	ls_oper_sec = ldw_detail.object.oper_sec[ll_row_det]
	update operaciones
		set costo_unit = :ldc_costo_prom_maq
	where oper_sec = :ls_oper_sec;
	
	// Sumo Todo el Costo (Mano de Obra mas maquinaria)
	ldc_total_x_hora += ldc_costo_maq
	
	//Verifico que hayan habido cambios para actualizar
   IF ldc_total_x_hora <> ldc_costo_labor_old THEN  //costo total x hora 
   	ldw_detail.object.costo_labor [ll_row_det] = ldc_total_x_hora  //costo
		ldw_detail.ii_update = 1
   END IF			  
	 
	IF ldc_cant_tot_hor <> ldc_cant_labor_old THEN //cant total x hora
	 	ldw_detail.object.cant_labor [ll_row_det] = ldc_cant_tot_hor 
		ldw_detail.ii_update = 1		
	END IF

ELSEIF (ls_flag_maq_mo = 'M' AND ls_und = ls_und_hr) THEN 
	//LABOR MECANIZADA Y UNIDAD SEA HRS	 
	//detalle del item	
	ldt_hora_inicio = ldw_detail.object.hora_inicio [ll_row_det]
	ldt_hora_fin    = ldw_detail.object.hora_fin    [ll_row_det]
	 
	//diferencias de labor
	ldc_cant_tot_hor = f_rango_horas( ldt_hora_inicio, ldt_hora_fin)
	 
	if Isnull(ldc_cant_tot_hor) then ldc_cant_tot_hor = 0.00

	IF ldc_cant_labor_old <> ldc_cant_tot_hor THEN
		ldw_detail.object.cant_labor [ll_row_det] = ldc_cant_tot_hor //new cantidad		
		ldw_detail.ii_update = 1
	END IF	 
	
	select costo_unitario 
		into :ldc_costo_unitario 
	from labor_ejecutor 
	where cod_labor 	 = :ls_cod_labor 
	  and cod_ejecutor = :ls_cod_ejecutor ;
	  
	if Isnull(ldc_costo_unitario) then ldc_costo_unitario = 0.00 
	
	ldc_costo_unitario = Round((ldc_cant_labor_old - ldc_total_inc ) * ldc_costo_unitario ,2)		
	
	// Costo Maquinaria
	wf_costo_prom_maq( ldc_costo_prom_maq, ldc_hrs_maq, ldc_costo_maq )
	
	// Actualizo el Costo Unit de la tabla Operaciones
	ls_oper_sec = ldw_detail.object.oper_sec[ll_row_det]
	update operaciones
		set costo_unit = :ldc_costo_prom_maq
	where oper_sec = :ls_oper_sec;
	
	// Sumo Todo el Costo (Mano de Obra mas maquinaria)
	ldc_costo_unitario += ldc_costo_maq
	
	IF ldc_costo_labor_old <> ldc_costo_unitario THEN
		ldw_detail.object.costo_labor [ll_row_det] = ldc_costo_unitario //new costo
		ldw_detail.ii_update = 1
	END IF
	
ELSEIF ls_und <> ls_und_hr AND ldw_destajo.RowCount() > 0 and ls_flag_maq_mo = 'O' THEN 
	// SI LA UNIDAD DE LA LABOR ES DIFERENTE LA HRS y ademas existe
	// Personal de Destajo
	
	ldc_total_destajo = 0
	for ll_inicio = 1 to ldw_destajo.RowCount()
		ldc_cant_dest 		+= Dec(ldw_destajo.object.cant_destajada[ll_inicio])
		ldc_total_destajo += Dec(ldw_destajo.object.total[ll_inicio])
	next
	
   IF ldc_total_destajo <> ldc_costo_labor_old THEN  //costo Total Detajo
   	ldw_detail.object.costo_labor [ll_row_det] = ldc_total_destajo  //costo
		ldw_detail.ii_update = 1
   END IF			  
	 
	IF ldc_cant_dest <> ldc_cant_labor_old THEN //cant total Destajo
	 	ldw_detail.object.cant_labor [ll_row_det] = ldc_cant_dest
		ldw_detail.ii_update = 1		
	END IF
	
	ldc_cant_avance = ldw_detail.object.cant_avance[ll_row_det]
	ls_unid_avance	 = ldw_detail.object.und_avance[ll_row_det]
	ls_unid_dest = ldw_destajo.object.unidad_destajo[1]
	
	if ls_unid_avance <> ls_unid_dest then
	 	ldw_detail.object.und_avance [ll_row_det] = ls_unid_dest
		ldw_detail.ii_update = 1		
	end if
	
	if ldc_cant_avance <> ldc_cant_dest then
	 	ldw_detail.object.cant_avance [ll_row_det] = ldc_cant_dest
		ldw_detail.ii_update = 1		
	end if

	IF ldc_cant_dest > 0 then
		
		ls_oper_sec = ldw_detail.object.oper_sec[ll_row_det]
		
		ldc_cost_unit_dest = ldc_total_destajo / ldc_cant_dest
		
		update operaciones
			set costo_unit = :ldc_cost_unit_dest
		where oper_sec = :ls_oper_sec;
		
	end if
	
ELSEIF (ls_und <> ls_und_hr ) THEN 
	//SI LA UNIDAD DE LA LABOR ES DIFERENTE LA HRS
	
	select costo_unitario 
		into :ldc_costo_unitario 
	from labor_ejecutor 
	where cod_labor 	 = :ls_cod_labor 
	  and cod_ejecutor = :ls_cod_ejecutor ;
	
	if Isnull(ldc_costo_unitario) then ldc_costo_unitario = 0.00 	 
	ldc_costo_unitario = Round(ldc_cant_labor_old * ldc_costo_unitario,2)
	
	IF ldc_costo_unitario <> ldc_costo_labor_old THEN
		ldw_detail.object.costo_labor [ll_row_det] = ldc_costo_unitario
		ldw_detail.ii_update = 1
	END IF
	
END IF	


end subroutine

public subroutine of_selecciona_operacion ();integer li_cuenta
long ll_operacion, ll_detail
string ls_cod_labor, ls_desc_labor, ls_und, ls_flag_maq_mo, ls_cod_ejecutor, ls_descripcion, ls_oper_sec, ls_cod_maquina, ls_proveedor, ls_avance_und, ls_cencos_slc, ls_cod_campo, ls_desc_campo, ls_nro_orden

ll_operacion = dw_operaciones.getrow()
ll_detail = tab_1.tabpage_1.dw_detail.getrow()

if ll_operacion <= 0 or ll_detail <= 0 then return	

ls_oper_sec = dw_operaciones.Object.oper_sec[ll_operacion]
declare usp_carga_det procedure for 
	usp_pr_carga_pd_ot_det(:ls_oper_sec);

execute usp_carga_det;
fetch usp_carga_det into :li_cuenta, :ls_cod_labor, :ls_desc_labor, :ls_und, :ls_flag_maq_mo, :ls_cod_ejecutor, :ls_descripcion, :ls_oper_sec, :ls_cod_maquina, :ls_proveedor, :ls_avance_und, :ls_cencos_slc, :ls_cod_campo, :ls_desc_campo, :ls_nro_orden;
close usp_carga_det;

if li_cuenta <> 1 then
	messagebox(this.title,'Error al seleccionar llenar el detalle del parte diario',stopsign!)
	return
end if

tab_1.tabpage_1.dw_detart.reset( )
tab_1.tabpage_1.dw_detail.object.cod_labor[ll_detail] = ls_cod_labor
tab_1.tabpage_1.dw_detail.Object.desc_labor[ll_detail] = ls_desc_labor
tab_1.tabpage_1.dw_detail.Object.labor_und[ll_detail] = ls_und 
tab_1.tabpage_1.dw_detail.object.flag_maq_mo[ll_detail] = ls_flag_maq_mo
tab_1.tabpage_1.dw_detail.object.cod_ejecutor[ll_detail] = ls_cod_ejecutor 
tab_1.tabpage_1.dw_detail.Object.ejecutor_descripcion[ll_detail] = ls_descripcion
tab_1.tabpage_1.dw_detail.object.oper_sec[ll_detail] = ls_oper_sec
tab_1.tabpage_1.dw_detail.object.cod_maquina[ll_detail] = ls_cod_maquina
tab_1.tabpage_1.dw_detail.object.proveedor[ll_detail] = ls_proveedor
tab_1.tabpage_1.dw_detail.object.und_avance[ll_detail] = ls_avance_und
tab_1.tabpage_1.dw_detail.object.cencos[ll_detail] = ls_cencos_slc
tab_1.tabpage_1.dw_detail.object.cod_campo[ll_detail] = ls_cod_campo
tab_1.tabpage_1.dw_detail.object.desc_campo[ll_detail] = ls_desc_campo
tab_1.tabpage_1.dw_detail.object.nro_orden[ll_detail] = ls_nro_orden
end subroutine

public subroutine of_selecciona_labor ();long ll_detail
String ls_column, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_return7, ls_return8, ls_return9, ls_return10, ls_return11, ls_nro_orden

ll_detail = tab_1.tabpage_1.dw_detail.getrow()

ls_nro_orden = trim(tab_1.tabpage_1.dw_detail.object.nro_orden[ll_detail])

if trim(ls_nro_orden) = '' or IsNull(ls_nro_orden) then
	messagebox('Error','Debe seleccionar primero ~r un número de parte',stopsign!)
	return
end if

tab_1.tabpage_1.dw_detart.reset( )
tab_1.tabpage_1.dw_detart.ii_update = 1

ls_sql = "select oper_sec as secuencia, cod_labor as labor_id, desc_labor as labor, cod_ejecutor as ejecutor_id, descripcion as ejecutor, cod_maquina as maquina_id, desc_maquina as maquina, proveedor as cliente_id, nombre as cliente, avance_und as unidad_id , desc_unidad as unidad from vw_pr_ot_labor where nro_orden = '"+ls_nro_orden+"'"
f_lista_11ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_return7, ls_return8, ls_return9, ls_return10, ls_return11, '1')
if isnull(ls_return1) or trim(ls_return1) = '' then return
tab_1.tabpage_1.dw_detail.object.oper_sec[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.cod_labor[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.desc_labor[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.cod_ejecutor[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.ejecutor_descripcion[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.proveedor[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.nom_proveedor[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.cod_maquina[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.desc_maq[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.und_avance[ll_detail] = ''
tab_1.tabpage_1.dw_detail.object.desc_unidad[ll_detail] = ''

tab_1.tabpage_1.dw_detail.object.oper_sec[ll_detail] = ls_return1
tab_1.tabpage_1.dw_detail.object.cod_labor[ll_detail] = ls_return2
tab_1.tabpage_1.dw_detail.object.desc_labor[ll_detail] = ls_return3
tab_1.tabpage_1.dw_detail.object.cod_ejecutor[ll_detail] = ls_return4
tab_1.tabpage_1.dw_detail.object.ejecutor_descripcion[ll_detail] = ls_return5
tab_1.tabpage_1.dw_detail.object.cod_maquina[ll_detail] = ls_return6
tab_1.tabpage_1.dw_detail.object.desc_maq[ll_detail] = ls_return7
tab_1.tabpage_1.dw_detail.object.proveedor[ll_detail] = ls_return8
tab_1.tabpage_1.dw_detail.object.nom_proveedor[ll_detail] = ls_return9
tab_1.tabpage_1.dw_detail.object.und_avance[ll_detail] = ls_return10
tab_1.tabpage_1.dw_detail.object.desc_unidad[ll_detail] = ls_return11
end subroutine

public subroutine miguel_caleron ();
end subroutine

on w_pr304_parte_diario.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_4=create st_4
this.st_3=create st_3
this.dw_lista=create dw_lista
this.st_2=create st_2
this.uo_1=create uo_1
this.st_1=create st_1
this.dw_operaciones=create dw_operaciones
this.tab_1=create tab_1
this.dw_master=create dw_master
this.em_nro_parte=create em_nro_parte
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_4
this.Control[iCurrent+2]=this.st_3
this.Control[iCurrent+3]=this.dw_lista
this.Control[iCurrent+4]=this.st_2
this.Control[iCurrent+5]=this.uo_1
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.dw_operaciones
this.Control[iCurrent+8]=this.tab_1
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.em_nro_parte
end on

on w_pr304_parte_diario.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.dw_lista)
destroy(this.st_2)
destroy(this.uo_1)
destroy(this.st_1)
destroy(this.dw_operaciones)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.em_nro_parte)
end on

event ue_open_pre;call super::ue_open_pre;integer li_error
long ll_cuenta

idw_1 = dw_master
dw_master.settransobject( sqlca )
dw_lista.settransobject( sqlca )
dw_operaciones.settransobject( sqlca )
tab_1.tabpage_1.dw_detail.settransobject( sqlca )
tab_1.tabpage_1.dw_detart.settransobject( sqlca )
tab_1.tabpage_2.dw_detinc.settransobject( sqlca )
tab_1.tabpage_3.dw_detasis.settransobject( sqlca )
tab_1.tabpage_3.dw_codrel.settransobject( sqlca )
tab_1.tabpage_4.dw_causas.settransobject( sqlca )
tab_1.tabpage_6.dw_maquina.settransobject( sqlca )
tab_1.tabpage_7.dw_destajo.settransobject( sqlca )
tab_1.tabpage_8.dw_atrdis.settransobject( sqlca )
tab_1.tabpage_8.dw_atributos.settransobject( sqlca )
tab_1.tabpage_8.dw_prodfin.settransobject( sqlca )

declare usp_param procedure for 
	usp_pr_ot_param(:gs_user);

execute usp_param;

fetch usp_param into :ll_cuenta, :is_doc_ot, :is_ot_adm, :li_error;

close usp_param;
//Long ll_nro_parte
//
//dw_master.SetTransObject(sqlca)
//dw_operaciones.SetTransObject(sqlca)
//tab_1.tabpage_1.dw_lista.SetTransObject(sqlca)
//tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
//tab_1.tabpage_1.dw_detart.SetTransObject(sqlca)
//tab_1.tabpage_2.dw_detinc.SetTransObject(sqlca)
//tab_1.tabpage_3.dw_detasis.SetTransObject(sqlca)
//tab_1.tabpage_4.dw_causas.SetTransObject(sqlca)
//tab_1.tabpage_5.dw_riegos.SetTransObject(sqlca)
//tab_1.tabpage_6.dw_maquina.SetTransObject(sqlca)
//tab_1.tabpage_7.dw_destajo.SetTransObject(sqlca)
//tab_1.tabpage_8.dw_prodfin.SetTransObject(sqlca)
//tab_1.tabpage_8.dw_atrdis.SetTransObject(sqlca)
//tab_1.tabpage_8.dw_atributos.SetTransObject(sqlca)
//
//idw_1 = dw_master              				// asignar dw corriente
//idw_1.SetFocus()
//
////tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado
//
//of_position_window(0,0)       			// Posicionar la ventana en forma fija
//
////ib_log = TRUE
//ib_log = FALSE
//is_tabla_1 = 'Cab_parte'
//is_tabla_2 = 'Det_parte'
//is_tabla_3 = 'Art_parte'
//is_tabla_4 = 'Inc_parte'
//is_tabla_5 = 'Tra_parte'
//is_tabla_6 = 'Cau_parte'
//is_tabla_7 = 'Dest_parte'
//is_tabla_8 = 'ProdFin_parte'
//is_tabla_9 = 'Atrib_parte'
//
//em_nro_parte.SetFocus()
end event

event resize;call super::resize;//u_dw_abc ldw_1
//
//tab_1.width  = newwidth  - tab_1.x - 10
//tab_1.height = newheight - tab_1.y - 10
//
//tab_1.tabpage_1.dw_lista.height  = tab_1.height - tab_1.tabpage_1.dw_lista.y  - 120
//
//ldw_1 = tab_1.tabpage_1.dw_detail
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_1.dw_detart
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_2.dw_detinc
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_3.dw_detasis
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_4.dw_causas
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_5.dw_riegos
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_6.dw_maquina
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_7.dw_destajo
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_8.dw_atrdis
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//ldw_1.width   = tab_1.width - ldw_1.x  - 40
//
//ldw_1 = tab_1.tabpage_8.dw_atributos
//ldw_1.height  = tab_1.height - ldw_1.y  - 120
//
//
//dw_operaciones.width = newwidth - dw_operaciones.x - 10
//
//
end event

event ue_insert;Long   	ll_row, ll_row_det
String 	ls_parte, ls_cod_labor, ls_und_hr, ls_und_labor, &
			ls_flag_maq_mo
u_dw_abc	ldw_detail

CHOOSE CASE idw_1
	CASE dw_master
		TriggerEvent('ue_update_request')
		is_accion = 'new'
		dw_master.Reset()
		dw_operaciones.Reset()
		tab_1.tabpage_1.dw_detail.Reset()
		tab_1.tabpage_1.dw_detail.ii_update = 0
		
		tab_1.tabpage_1.dw_detart.Reset()
		tab_1.tabpage_1.dw_detart.ii_update = 0
		
		tab_1.tabpage_2.dw_detinc.Reset()
		tab_1.tabpage_2.dw_detinc.ii_update = 0
		
		tab_1.tabpage_3.dw_detasis.Reset()
		tab_1.tabpage_3.dw_detasis.ii_update = 0
		
		tab_1.tabpage_4.dw_causas.Reset()
		tab_1.tabpage_4.dw_causas.ii_update = 0
		
		tab_1.tabpage_5.dw_riegos.Reset()
		tab_1.tabpage_5.dw_riegos.ii_update = 0

		tab_1.tabpage_6.dw_maquina.Reset()
		tab_1.tabpage_6.dw_maquina.ii_update = 0
		
		tab_1.tabpage_7.dw_destajo.Reset()
		tab_1.tabpage_7.dw_destajo.ii_update = 0
		
		tab_1.tabpage_8.dw_prodfin.Reset()
		tab_1.tabpage_8.dw_prodfin.ii_update = 0
		
		tab_1.tabpage_8.dw_atributos.Reset()
		tab_1.tabpage_8.dw_atributos.ii_update = 0
		
	CASE tab_1.tabpage_1.dw_detail
		
		ll_row = dw_master.GetRow()
		
		if ll_row <= 0 then
			MessageBox('PRODUCCION', 'NO EXISTE CABECERA DEL PARTE DIARIO, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ls_parte = Trim(dw_master.object.nro_parte[ll_row])
		if ls_parte = '' or IsNull(ls_parte) then
			MessageBox('PRODUCCION', 'NO ESTA DEFINIDO NUMERO DEL PARTE DIARIO, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if

		TriggerEvent('ue_update_request')
		
		tab_1.tabpage_1.dw_detart.Reset()
		tab_1.tabpage_1.dw_detart.ii_update = 0
		
		tab_1.tabpage_2.dw_detinc.Reset()
		tab_1.tabpage_2.dw_detinc.ii_update = 0
		
		tab_1.tabpage_3.dw_detasis.Reset()
		tab_1.tabpage_3.dw_detasis.ii_update = 0
		
		tab_1.tabpage_4.dw_causas.Reset()
		tab_1.tabpage_4.dw_causas.ii_update = 0
		
		tab_1.tabpage_5.dw_riegos.Reset()
		tab_1.tabpage_5.dw_riegos.ii_update = 0

		tab_1.tabpage_6.dw_maquina.Reset()
		tab_1.tabpage_6.dw_maquina.ii_update = 0
		
		tab_1.tabpage_7.dw_destajo.Reset()
		tab_1.tabpage_7.dw_destajo.ii_update = 0
		
		tab_1.tabpage_8.dw_prodfin.Reset()
		tab_1.tabpage_8.dw_prodfin.ii_update = 0
		
		tab_1.tabpage_8.dw_atributos.Reset()
		tab_1.tabpage_8.dw_atributos.ii_update = 0
		
	CASE ELSE
		
		ll_row = dw_master.GetRow()
		
		if ll_row <= 0 then
			MessageBox('PRODUCCION', 'NO EXISTE CABECERA DEL PARTE DIARIO, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if
		
		ls_parte = Trim(dw_master.object.nro_parte[ll_row])
		if ls_parte = '' or IsNull(ls_parte) then
			MessageBox('PRODUCCION', 'NO ESTA DEFINIDO NUMERO DEL PARTE DIARIO, POR FAVOR VERIFIQUE',StopSign!)
			return
		end if

END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_dw_share;call super::ue_dw_share;//tab_1.tabpage_1.dw_lista.of_share_lista(tab_1.tabpage_1.dw_detail)
end event

event ue_update_pre;//Long   	ll_row_master , ll_row_det_old    , ll_item_old   ,ll_inicio_item , &
//			ll_item       , ll_inicio
//			
//String 	ls_mensaje     , ls_hinicio_inc  , ls_cod_art    , ls_cod_incidencia , &
//			ls_cod_trab    , ls_cod_causa    , ls_cierre     , ls_nro_parte      , &
//			ls_cod_labor   , ls_cod_ejecutor , ls_nro_orden  , ls_oper_sec	 	 , &
//			ls_cod_maquina , ls_desc_inc     , ls_cod_linea
//			 
//Datetime ldt_finicio,ldt_ffinal
//Long     ln_ano, ln_mes
//Date     ld_fecha
//
//u_dw_abc		ldw_detail, ldw_detart, ldw_detasis, ldw_detinc, ldw_maquina, ldw_riegos, &
//				ldw_causas, ldw_destajo, ldw_prodfin, ldw_atributos
//Datawindow 	ldw_lista
//
//dwItemStatus ldis_status
//
//ldw_detail  	= tab_1.tabpage_1.dw_detail
//ldw_detart  	= tab_1.tabpage_1.dw_detart
//ldw_lista 		= tab_1.tabpage_1.dw_lista
//ldw_detinc		= tab_1.tabpage_2.dw_detinc
//ldw_detasis 	= tab_1.tabpage_3.dw_detasis
//ldw_causas		= tab_1.tabpage_4.dw_causas
//ldw_riegos		= tab_1.tabpage_5.dw_riegos
//ldw_maquina		= tab_1.tabpage_6.dw_maquina
//ldw_destajo		= tab_1.tabpage_7.dw_destajo
//ldw_prodfin		= tab_1.tabpage_8.dw_prodfin
//ldw_atributos	= tab_1.tabpage_8.dw_atributos
//
//
////invocar objeto de numeracion de parte
//nvo_numeradores_varios lnvo_numeradores_varios
//lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
////
//
//
//
//ll_row_master = dw_master.getrow()
//ib_update_check = True
//
//if f_row_Processing( dw_master, "form") <> true then	
//	ib_update_check = False	
//	return
//end if
//
////DETALLES DEL PD_OT
//if f_row_Processing( ldw_detail, "form") <> true then	
//	tab_1.SelectedTab = 1
//	ib_update_check = False	
//	return
//end if
//
//// ARTICULOS
//if f_row_Processing( ldw_detart, "form") <> true then	
//	tab_1.SelectedTab = 1
//	ib_update_check = False	
//	return
//end if
//
////MAQUINA
//if f_row_Processing( ldw_maquina, "tabular") <> true then	
//	tab_1.SelectedTab = 6
//	ib_update_check = False	
//	return
//end if
//
////DESTAJO
//if f_row_Processing( ldw_destajo, "tabular") <> true then	
//	tab_1.SelectedTab = 7
//	ib_update_check = False	
//	return
//end if
//
////PRODUCTO FINAL
//if f_row_Processing( ldw_prodfin, "tabular") <> true then	
//	tab_1.SelectedTab = 8
//	ib_update_check = False	
//	return
//end if
//
////ATRIBUTOS DE PRODUCTO FINAL
//if f_row_Processing( ldw_atributos, "tabular") <> true then	
//	tab_1.SelectedTab = 8
//	ib_update_check = False	
//	return
//end if
//
//IF ldw_detart.ii_update > 0 OR ldw_detasis.ii_update > 0 THEN
//	
//	dw_master.ii_update = 1
//	
//END IF
//
//ld_fecha = DATE(dw_master.Object.fecha [ll_row_master])
//ln_ano   = year(ld_fecha)
//ln_mes   = month(ld_fecha)
//
//
////verificacion de mes contable
//SELECT USF_CNT_CIERRE_CNTBL(:ln_ano, :ln_mes, 'F') 
//	INTO :ls_cierre 
//FROM dual ;
//
//IF ls_cierre = '0' THEN
//	Messagebox('Mes contable cerrado','No se puede actualizar datos')
//   ib_update_check = False	
//	return
//END IF
//
////RECUPERO NRO DE PARTE
//ls_nro_parte = dw_master.Object.nro_parte [ll_row_master]
//
//IF is_accion = 'new' THEN
//	IF lnvo_numeradores_varios.uf_num_parte(gs_origen,ls_nro_parte) = FALSE THEN
//		ib_update_check = False	
//		RETURN
//	ELSE
//		dw_master.Object.nro_parte [ll_row_master] = ls_nro_parte
//	END IF
//
//END IF
//
///*Fila Detalle old*/
//ll_row_det_old = ldw_detail.Getrow()
//
//IF ll_row_det_old > 0 THEN
//   ll_item_old = ldw_detail.object.nro_item [ll_row_det_old]
//END IF
//
//// Detalle del Parte Diario
//FOR ll_inicio_item = 1 TO ldw_detail.Rowcount() //recorre dw detalle de pd_ot
//	
//	 //asignar nro de parte cuando registro sea nuevo
//	 ldis_status = ldw_detail.GetItemStatus(ll_inicio_item,0,Primary!)
//
//	 IF ldis_status = NewModified! THEN
//		 ldw_detail.Object.nro_parte [ll_inicio_item] = ls_nro_parte
//	 END IF
//	 
//	 ll_item = ldw_detail.object.nro_item [ll_inicio_item]
//	 
//
//	 /*verificar que labor y ejecutor sea requerido*/
//	 ls_cod_labor    = ldw_detail.object.cod_labor    [ll_inicio_item]
//	 ls_cod_ejecutor = ldw_detail.object.cod_ejecutor [ll_inicio_item]
//	 ls_nro_orden	  = ldw_detail.object.nro_orden    [ll_inicio_item]
//	 ls_oper_sec	  = ldw_detail.object.oper_sec     [ll_inicio_item]
//	 
//	 IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
//		 Messagebox('Aviso','Debe Ingresar Codigo de Labor')	
//		 ib_update_check = False	
//		 Return
//	 END IF
//	 
//	 IF Isnull(ls_cod_ejecutor) OR Trim(ls_cod_ejecutor) = '' THEN
//		 Messagebox('Aviso','Debe Ingresar Codigo de Ejecutor')	
//		 ib_update_check = False	
//		 Return
//	 END IF
//	 
//	 
//	 IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
//		 Messagebox('Aviso','Debe Seleccionar Orden de Trabajo')	
//		 ib_update_check = False	
//		 Return
//	 END IF
//	 
//	 IF Isnull(ls_oper_sec) OR Trim(ls_oper_sec) = '' THEN
//		 Messagebox('Aviso','Debe Ingresar Un Oper Sec')	
//		 ib_update_check = False	
//		 Return
//	 END IF
//NEXT
//
////Detalle de Articulos x Item
//FOR ll_inicio = 1 TO ldw_detart.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status = ldw_detart.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_detart.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//		  
//	ls_cod_art = ldw_detart.object.cod_art [ll_inicio]
//		  
//	IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
//			  
//		tab_1.SelectedTab = 1
//  		ldw_detart.SetFocus()
//		ldw_detart.Scrolltorow(ll_inicio)
//		ldw_detart.Setrow(ll_inicio)
//		ldw_detart.SetColumn('cod_art')
//
//		/**/	
//		Messagebox('Aviso','Debe Ingresar Codigo de Articulo')	  					
//		ib_update_check = False	
//		Return					
//	END IF
//        
//NEXT
//
////Incidencias
//FOR ll_inicio = 1 TO ldw_detinc.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status = ldw_detinc.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_detinc.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//		  
//	ls_cod_incidencia = ldw_detinc.object.cod_incidencia [ll_inicio]
//		  
//	ls_desc_inc	  	  	= Trim(ldw_detinc.Object.descripcion	[ll_inicio])
//	 
//  	IF Isnull(ls_cod_incidencia) OR Trim(ls_cod_incidencia) = '' THEN
//  		tab_1.SelectedTab = 2
//		ldw_detinc.SetFocus()
//		ldw_detinc.Scrolltorow(ll_inicio)
//		ldw_detinc.Setrow(ll_inicio)
//		ldw_detinc.SetColumn('cod_incidencia')
//			
//		/**/
//		
// 	  	Messagebox('Aviso','Debe Ingresar Codigo de Incidencia ')			 			
//	 	ib_update_check = False	
//	 	Return		
//	END IF
//NEXT
//
////Asistencia 
//FOR ll_inicio = 1 TO ldw_detasis.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status = ldw_detasis.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_detasis.Object.no_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//	ls_cod_trab = ldw_detasis.object.cod_trabajador [ll_inicio]
//
//  	IF Isnull(ls_cod_trab) OR Trim(ls_cod_trab) = '' THEN
//  		tab_1.SelectedTab = 3
//		ldw_detasis.SetFocus()
//		ldw_detasis.Scrolltorow(ll_inicio)
//		ldw_detasis.Setrow(ll_inicio)
//		ldw_detasis.SetColumn('cod_trabajador')
//		
//		/**/				  
//		Messagebox('Aviso','Debe Ingresar Un Codigo de Trabajador ')			 	
//		ib_update_check = False	
//		Return	 
//	END IF
//					  
//NEXT
//	 
////Causa de Fallas
//FOR ll_inicio = 1 TO ldw_causas.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status = ldw_causas.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_causas.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//  	ls_cod_causa = ldw_causas.Object.causa_falla [ll_inicio]	
//		  
//	IF Isnull(ls_cod_causa) OR Trim(ls_cod_causa) = '' THEN
//  		tab_1.SelectedTab = 4
//		ldw_causas.SetFocus()
//		ldw_causas.Scrolltorow(ll_inicio)
//		ldw_causas.Setrow(ll_inicio)
//		ldw_causas.SetColumn('causa_falla')
//		
//		/**/				  
//		Messagebox('Aviso','Debe Ingresar Un Codigo de Causa de Falla ')			 	
//		ib_update_check = False	
//		Return	 
//	END IF
//NEXT
//	  
////riego
//FOR ll_inicio = 1 TO ldw_riegos.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status = ldw_riegos.GetItemStatus(ll_inicio,0,Primary!)
//   IF ldis_status = NewModified! THEN
//      ldw_riegos.Object.nro_parte [ll_inicio] = ls_nro_parte
//   END IF
//NEXT
//		
////MAQUINA
//FOR ll_inicio = 1 TO ldw_maquina.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status =ldw_maquina.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_maquina.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//	ls_cod_maquina =ldw_maquina.object.cod_maquina [ll_inicio]
//			
//	IF Isnull(ls_cod_maquina) OR Trim(ls_cod_maquina) = '' THEN
//  		tab_1.SelectedTab = 6
//	  	ldw_maquina.SetFocus()
//	  	ldw_maquina.Scrolltorow(ll_inicio)
//	  	ldw_maquina.Setrow(ll_inicio)
//	  	ldw_maquina.SetColumn('cod_maquina')
//				  
//   	/**/				  
//		Messagebox('Aviso','Debe Ingresar Un Codigo de Maquina ,Verifique! ')			 	
//		ib_update_check = False	
//		Return
//	END IF
//			
//
//NEXT
//	 
////DESTAJO
//FOR ll_inicio = 1 TO ldw_destajo.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status =ldw_destajo.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_destajo.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//NEXT
//
////PRODUCTO FINAL
//FOR ll_inicio = 1 TO ldw_prodfin.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status =ldw_prodfin.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_prodfin.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//NEXT
//
////ATRIBUTOS DE PRODUCTO FINAL
//FOR ll_inicio = 1 TO ldw_atributos.Rowcount()
//	//asignar nro de parte cuando registro sea nuevo
//	ldis_status =ldw_atributos.GetItemStatus(ll_inicio,0,Primary!)
//
//	IF ldis_status = NewModified! THEN
//		ldw_atributos.Object.nro_parte [ll_inicio] = ls_nro_parte
//	END IF
//
//NEXT
//
//
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 					   &
	OR tab_1.tabpage_1.dw_detail.ii_update  = 1 &
	OR tab_1.tabpage_1.dw_detart.ii_update  = 1 &
	OR tab_1.tabpage_2.dw_detinc.ii_update  = 1 &
	OR tab_1.tabpage_3.dw_detasis.ii_update = 1 &
	OR tab_1.tabpage_4.dw_causas.ii_update  = 1 &
	OR tab_1.tabpage_5.dw_riegos.ii_update  = 1 &
	OR tab_1.tabpage_6.dw_maquina.ii_update = 1 &
	OR tab_1.tabpage_7.dw_destajo.ii_update = 1 &
	OR tab_1.tabpage_8.dw_prodfin.ii_update = 1 &
	OR tab_1.tabpage_8.dw_atributos.ii_update  = 1) THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update  = 0
		tab_1.tabpage_1.dw_detart.ii_update  = 0
		tab_1.tabpage_2.dw_detinc.ii_update  = 0
		tab_1.tabpage_3.dw_detasis.ii_update = 0
		tab_1.tabpage_4.dw_causas.ii_update  = 0
		tab_1.tabpage_5.dw_riegos.ii_update  = 0
		tab_1.tabpage_6.dw_maquina.ii_update = 0
		tab_1.tabpage_7.dw_destajo.ii_update = 0
		tab_1.tabpage_8.dw_prodfin.ii_update = 0
		tab_1.tabpage_8.dw_atributos.ii_update = 0
	END IF
END IF
end event

event ue_update;call super::ue_update;Boolean 	lbo_ok = TRUE
Long    	ll_row_det_old,ll_item_old
string  	ls_nro_parte
u_dw_abc ldw_1

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_1.dw_detart.AcceptText()
tab_1.tabpage_2.dw_detinc.AcceptText()
tab_1.tabpage_3.dw_detasis.AcceptText()
tab_1.tabpage_4.dw_causas.AcceptText()
tab_1.tabpage_5.dw_riegos.AcceptText()
tab_1.tabpage_6.dw_maquina.AcceptText()
tab_1.tabpage_7.dw_destajo.AcceptText()
tab_1.tabpage_8.dw_atributos.AcceptText()
tab_1.tabpage_8.dw_prodfin.AcceptText()
tab_1.tabpage_8.dw_atributos.AcceptText()

ib_update_check = TRUE
THIS.EVENT ue_update_pre()

IF ib_update_check = FALSE THEN
	Rollback;
	if ib_detail_new = TRUE and tab_1.SelectedTab <> 1 then
		Tab_1.SelectedTab = 1 // Me ubico en el tab de Operaciones
	end if
	RETURN
END IF

ll_row_det_old = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row_det_old > 0 THEN
   ll_item_old = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row_det_old]
END IF

if tab_1.SelectedTab <> 1 then
	THIS.of_act_cant_costo_labor( )
end if

IF ib_log THEN
	DataStore lds_log_1, lds_log_2, lds_log_3, lds_log_4, &
				 lds_log_5, lds_log_6, lds_log_7, lds_log_8, &
				 lds_log_9
				 
	lds_log_1 = Create DataStore
	lds_log_2 = Create DataStore
	lds_log_3 = Create DataStore
	lds_log_4 = Create DataStore
	lds_log_5 = Create DataStore
	lds_log_6 = Create DataStore
	lds_log_7 = Create DataStore
	lds_log_8 = Create DataStore
	lds_log_9 = Create DataStore
	
	lds_log_1.DataObject = 'd_log_diario_tbl'
	lds_log_2.DataObject = 'd_log_diario_tbl'
	lds_log_3.DataObject = 'd_log_diario_tbl'
	lds_log_4.DataObject = 'd_log_diario_tbl'
	lds_log_5.DataObject = 'd_log_diario_tbl'
	lds_log_6.DataObject = 'd_log_diario_tbl'
	lds_log_7.DataObject = 'd_log_diario_tbl'
	lds_log_8.DataObject = 'd_log_diario_tbl'
	lds_log_9.DataObject = 'd_log_diario_tbl'
	
	lds_log_1.SetTransObject(SQLCA)
	lds_log_2.SetTransObject(SQLCA)
	lds_log_3.SetTransObject(SQLCA)
	lds_log_4.SetTransObject(SQLCA)
	lds_log_5.SetTransObject(SQLCA)
	lds_log_6.SetTransObject(SQLCA)
	lds_log_7.SetTransObject(SQLCA)
	lds_log_8.SetTransObject(SQLCA)
	lds_log_9.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_1, is_colname_1, is_coltype_1, gs_user, is_tabla_1)
	in_log.of_create_log(tab_1.tabpage_1.dw_detail , lds_log_2, is_colname_2, is_coltype_2, gs_user, is_tabla_2)
	in_log.of_create_log(tab_1.tabpage_1.dw_detart , lds_log_3, is_colname_3, is_coltype_3, gs_user, is_tabla_3)
	in_log.of_create_log(tab_1.tabpage_2.dw_detinc , lds_log_4, is_colname_4, is_coltype_4, gs_user, is_tabla_4)
	in_log.of_create_log(tab_1.tabpage_3.dw_detasis, lds_log_5, is_colname_5, is_coltype_5, gs_user, is_tabla_5)
   in_log.of_create_log(tab_1.tabpage_4.dw_causas , lds_log_6, is_colname_6, is_coltype_6, gs_user, is_tabla_6)	
   in_log.of_create_log(tab_1.tabpage_7.dw_destajo, lds_log_7, is_colname_7, is_coltype_7, gs_user, is_tabla_7)	
   in_log.of_create_log(tab_1.tabpage_8.dw_prodfin , lds_log_8, is_colname_8, is_coltype_8, gs_user, is_tabla_8)		
   in_log.of_create_log(tab_1.tabpage_8.dw_atributos , lds_log_9, is_colname_9, is_coltype_9, gs_user, is_tabla_9)	
	
END IF

IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF
lbo_ok = true
IF tab_1.tabpage_1.dw_detail.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then //Grabación de Detalle de Pd_ot
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de OT","Se ha procedido al rollback",exclamation!)		 
	END IF
END IF

IF tab_1.tabpage_1.dw_detart.ii_update = 1 THEN
	IF tab_1.tabpage_1.dw_detart.Update() = -1 then // Grabación de Articulo
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Articulos","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_2.dw_detinc.ii_update = 1 THEN
	IF tab_1.tabpage_2.dw_detinc.Update() = -1 then // Grabación de Incidencias
		lbo_ok = FALSE
		Messagebox("Error en Grabación Detalle de Incidencias","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_3.dw_detasis.ii_update = 1 THEN
	IF tab_1.tabpage_3.dw_detasis.Update() = -1 then		// Grabación de Asistencia
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Asistencia","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_4.dw_causas.ii_update = 1 THEN
	IF tab_1.tabpage_4.dw_causas.Update() = -1 then		// Grabación de Causas de Fallas
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Causas de Fallas","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF tab_1.tabpage_5.dw_riegos.ii_update = 1 THEN
	IF tab_1.tabpage_5.dw_riegos.Update() = -1 THEN
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Riego","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_6.dw_maquina.ii_update = 1 THEN
	IF tab_1.tabpage_6.dw_maquina.Update () = -1 THEN
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Maquina","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF tab_1.tabpage_7.dw_destajo.ii_update = 1 THEN
	IF tab_1.tabpage_7.dw_destajo.Update () = -1 THEN
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle de Destajo","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF tab_1.tabpage_8.dw_prodfin.ii_update = 1 THEN
	IF tab_1.tabpage_8.dw_prodfin.Update () = -1 THEN
		lbo_ok = FALSE
		Messagebox("Error en Grabacion en Producto Final","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

ldw_1 = tab_1.tabpage_8.dw_atributos
IF ldw_1.ii_update = 1 THEN
	IF ldw_1.Update () = -1 THEN
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Atributos de Producto Final","Se ha procedido al rollback",exclamation!)
	END IF
END IF	


IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log_1.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 1')
		END IF
		IF lds_log_2.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 2')
		END IF
		IF lds_log_3.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 3')
		END IF
		IF lds_log_4.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 4')
		END IF
		IF lds_log_5.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 5')
		END IF
		IF lds_log_6.Update() = -1 THEN
			lbo_ok = FALSE
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario 6')
		END IF
	END IF
	DESTROY lds_log_1
	DESTROY lds_log_2
	DESTROY lds_log_3
	DESTROY lds_log_4
	DESTROY lds_log_5
	DESTROY lds_log_6
	DESTROY lds_log_7
	DESTROY lds_log_8
	DESTROY lds_log_9
END IF


IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update  = 0
	tab_1.tabpage_1.dw_detart.ii_update  = 0
	tab_1.tabpage_2.dw_detinc.ii_update  = 0
	tab_1.tabpage_3.dw_detasis.ii_update = 0
	tab_1.tabpage_4.dw_causas.ii_update  = 0
	tab_1.tabpage_5.dw_riegos.ii_update  = 0
	tab_1.tabpage_6.dw_maquina.ii_update = 0
	tab_1.tabpage_7.dw_destajo.ii_update = 0
	tab_1.tabpage_8.dw_prodfin.ii_update = 0
	tab_1.tabpage_8.dw_atributos.ii_update = 0
	
	is_accion = 'fileopen'

	if ib_detail_new = TRUE then
		ib_detail_new = FALSE
		if Tab_1.SelectedTab <> 1 then
			tab_1.SelectedTab = 1 
		end if
		ls_nro_parte = dw_master.object.nro_parte[dw_master.GetRow()]
		Tab_1.tabpage_1.dw_detail.Retrieve(ls_nro_parte)
	end if

	/***Recupero Operaciones Coincidentes***/
	String ls_cod_labor,ls_cod_ejecutor,ls_nro_doc
	Long   ll_row
	IF tab_1.tabpage_1.dw_detail.Getrow() > 0 THEN
		ll_row = tab_1.tabpage_1.dw_detail.Getrow()
		ls_cod_labor	 = tab_1.tabpage_1.dw_detail.Object.cod_labor	 [ll_row]
		ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.Object.cod_ejecutor [ll_row]
		ls_nro_doc		 = tab_1.tabpage_1.dw_detail.Object.nro_orden    [ll_row]
	END IF
	/**************/
//	wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)	

ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list;call super::ue_retrieve_list;long ll_cuenta, ll_master, ll_lista
string ls_sql, ls_retrun1, ls_return2, ls_return3, ls_fecha1, ls_fecha2, ls_nro_parte, ls_cod_labor, ls_cod_ejecutor
date ld_fecha1, ld_fecha2

ld_fecha1 = uo_1.of_get_fecha1()
ld_fecha2 = uo_1.of_get_fecha2()

ls_fecha1 = string(ld_fecha1, 'dd/mm/yyyy')
ls_fecha2 = string(ld_fecha2, 'dd/mm/yyyy')

declare usp_ot_adm procedure for 
	usp_pr_pd_ot_adm (:gs_user, :ls_fecha1, :ls_fecha2);

execute usp_ot_adm;
fetch usp_ot_adm into :ll_cuenta;
close usp_ot_adm;

if ll_cuenta >= 1 then
	ls_sql = "select nro_parte as parte, ot_adm as adminsitracion, fecha_texto as fecha from tt_pr_pd_ot_adm"
	f_lista_3ret(ls_sql, ls_retrun1, ls_return2, ls_return3, '1')
	if trim(ls_retrun1) = '' or isnull(ls_retrun1) then
		return
	else
		dw_master.reset( )
		dw_lista.reset( )
		dw_operaciones.reset( )
		tab_1.tabpage_1.dw_detail.reset( )
		tab_1.tabpage_1.dw_detart.reset( )
		tab_1.tabpage_2.dw_detinc.reset( )
		tab_1.tabpage_3.dw_detasis.reset( )
		tab_1.tabpage_4.dw_causas.reset( )
		tab_1.tabpage_5.dw_riegos.reset( )
		tab_1.tabpage_6.dw_maquina.reset( )
		tab_1.tabpage_7.dw_destajo.reset( )
		tab_1.tabpage_8.dw_atributos.reset( )
		tab_1.tabpage_8.dw_prodfin.reset( )
		tab_1.tabpage_8.dw_atributos.reset( )
	end if
	em_nro_parte.text = trim(ls_retrun1)
	ls_nro_parte = trim(em_nro_parte.text)
	if of_carga_master(ls_nro_parte) = 1 then
		of_carga_lista(ls_nro_parte)
	else
		messagebox(this.title,'No se ha podido cargar la orden de trabajo',StopSign!)
	end if
else
	messagebox(this.title,'No se han encontrado partes de piso, ~r Ingrese un rango de fechas mayor',stopsign!)
end if
end event

event ue_modify;idw_1.of_protect()
tab_1.tabpage_1.dw_detail.Modify("nro_ot.Protect='1~tIf(IsRowNew(),0,1)'")

end event

event ue_delete;//OVERRIDE
String ls_nro_parte,ls_oper_sec,ls_flag_estado
Long   ll_row,ll_nro_item
dwItemStatus ldis_status


IF idw_1 = dw_master OR Isnull(idw_1)THEN 
	Return
END IF

IF idw_1 = tab_1.tabpage_1.dw_detail OR idw_1 = tab_1.tabpage_3.dw_detasis THEN //DETALLE DEL ITEM ,ASISTENCIA
	IF tab_1.tabpage_1.dw_detail.Getrow () = 0 THEN RETURN
	
	//asignar nro de parte cuando registro sea nuevo
	ldis_status = tab_1.tabpage_1.dw_detail.GetItemStatus(tab_1.tabpage_1.dw_detail.Getrow(),0,Primary!)

	IF ldis_status <> NewModified! THEN
		ls_nro_parte = tab_1.tabpage_1.dw_detail.object.nro_parte [tab_1.tabpage_1.dw_detail.Getrow()]
		ls_oper_sec  = tab_1.tabpage_1.dw_detail.object.oper_sec  [tab_1.tabpage_1.dw_detail.Getrow()]
		ll_nro_item  = tab_1.tabpage_1.dw_detail.object.nro_item  [tab_1.tabpage_1.dw_detail.Getrow()]
		
//		control desactivado x ser lento arojas 26/08/2003
//		wf_verifica_parte (ls_nro_parte,ll_nro_item,ls_oper_sec,ls_flag_estado) 
		
//		IF ls_flag_estado = '1' THEN RETURN //oper sec fue cerrado
		
	END IF
	 
END IF


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_open_pos();call super::ue_open_pos;IF ib_log THEN											
	in_log = Create n_cst_log_diario
	in_log.of_dw_map(dw_master, is_colname_1, is_coltype_1)
	in_log.of_dw_map(tab_1.tabpage_1.dw_detail , is_colname_2, is_coltype_2)
	in_log.of_dw_map(tab_1.tabpage_1.dw_detart , is_colname_3, is_coltype_3)
	in_log.of_dw_map(tab_1.tabpage_2.dw_detinc , is_colname_4, is_coltype_4)
	in_log.of_dw_map(tab_1.tabpage_3.dw_detasis, is_colname_5, is_coltype_5)
	in_log.of_dw_map(tab_1.tabpage_4.dw_causas , is_colname_6, is_coltype_6)
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;//IF idw_1 = tab_1.tabpage_1.dw_detail THEN
//	tab_1.tabpage_1.dw_detail.SetColumn('nro_orden')
//END IF	
end event

event ue_query_retrieve;String ls_parte
Long ll_nro_parte
MessageBox('','Query retrieve')
ls_parte = em_nro_parte.text


wf_retrieve (ls_parte)	

//long 		ll_row
//string 	ls_parte
//
//ll_row = dw_master.GetRow()
//if ll_row <= 0 then return
//
//ls_parte = dw_master.object.nro_parte[ll_row]
//
//if ls_parte = '' or IsNull(ls_parte) then return
//
//wf_retrieve (ls_parte)	
end event

event closequery;THIS.Event ue_close_pre()
THIS.EVENT ue_update_request()

Destroy	im_1

of_close_sheet()

end event

type st_4 from statictext within w_pr304_parte_diario
integer x = 1719
integer y = 320
integer width = 1701
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Operaciones contenidas dentro de la Orden de Trabajo referenciada"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_3 from statictext within w_pr304_parte_diario
integer x = 14
integer y = 320
integer width = 1701
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 134217752
long backcolor = 8388608
string text = "Labores (Ver especificaiones en el detalle)"
boolean border = true
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type dw_lista from u_dw_list_tbl within w_pr304_parte_diario
integer x = 14
integer y = 392
integer width = 1701
integer height = 472
integer taborder = 30
string dataobject = "d_pr_ot_labor_tbl"
boolean hscrollbar = false
end type

event constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1			// columnas de lectrua de este dw
ii_dk[2] = 2
end event

event rowfocuschanged;call super::rowfocuschanged;string ls_nro_parte
long ll_lista
ll_lista = this.getrow()
if ll_lista >= 1 then
	of_carga_detail()
	of_carga_detart()
	of_carga_operaciones()
end if
end event

type st_2 from statictext within w_pr304_parte_diario
integer x = 37
integer y = 8
integer width = 480
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtrar para búsqueda"
boolean focusrectangle = false
end type

type uo_1 from u_ingreso_rango_fechas within w_pr304_parte_diario
integer x = 544
integer width = 1303
integer height = 80
integer taborder = 60
end type

event constructor;call super::constructor;of_set_label('Desde:','Hasta:') //para setear la fecha inicial
of_set_fecha(date('01/01/2003'), today()) // para seatear el titulo del boton
//of_set_fecha(relativedate(today(), -30 ), today()) // para seatear el titulo del boton
of_set_rango_inicio(date('01/01/1900')) // rango inicial
of_set_rango_fin(date('31/12/9999')) // rango final
// of_get_fecha1(), of_get_fecha2()  para leer las fechas

end event

on uo_1.destroy
call u_ingreso_rango_fechas::destroy
end on

type st_1 from statictext within w_pr304_parte_diario
integer x = 2478
integer y = 12
integer width = 526
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Número de Parte Diario:"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_operaciones from u_dw_abc within w_pr304_parte_diario
integer x = 1719
integer y = 392
integer width = 1701
integer height = 472
integer taborder = 20
string dragicon = "H:\Source\ICO\row.ico"
string dataobject = "d_pr_operaciones_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;IF row > 0 THEN
	This.setrow(row)
	This.drag(begin!)
	This.selectrow(0,false)
	This.selectrow(row,true)
END IF
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple


ii_ck[1] = 1				// columnas de lectrua de este dw



idw_mst  = 	dw_operaciones			// dw_master

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event dragenter;call super::dragenter;if source = this then
	source.DragIcon = "\Source\ICO\row.ico"
end if

end event

event dragleave;call super::dragleave;source.DragIcon = "Error!"

end event

type tab_1 from tab within w_pr304_parte_diario
integer y = 864
integer width = 3415
integer height = 868
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean focusonbuttondown = true
boolean powertips = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
tabpage_7 tabpage_7
tabpage_8 tabpage_8
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.tabpage_7=create tabpage_7
this.tabpage_8=create tabpage_8
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6,&
this.tabpage_7,&
this.tabpage_8}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
destroy(this.tabpage_7)
destroy(this.tabpage_8)
end on

event selectionchanged;integer li_Tab

if dw_lista.rowcount( ) <= 0 then return

li_tab = tab_1.SelectedTab
choose case li_tab
	case 1 //Detalle
		of_carga_detail()
		of_carga_detart()
		if oldindex = 2 OR oldindex = 3  or oldindex = 7 then //si venimos de incidencias, trabajadores y destajo
			of_act_cant_costo_labor() //actualiza costo y cantidad de labor
		end if
	case 2 //Incidencias
		of_carga_detinc()
	case 3 //Trabajadores
		of_carga_detasis()
	case 4 //Causas de Fallas
		of_carga_causas()
	case 6 //Máquinas
		of_carga_maquina()
	case 7 //Destajo
		of_carga_destajo()
	case 8 //Productos Terminados
		if of_carga_prodfin() >= 1 then
			tab_1.tabpage_8.dw_prodfin.setrow(1)
			tab_1.tabpage_8.dw_prodfin.scrolltorow(1)
			tab_1.tabpage_8.dw_prodfin.selectrow(1,true)
			if of_carga_atrdis() >=1 then
				tab_1.tabpage_8.dw_atrdis.setrow(1)
				tab_1.tabpage_8.dw_atrdis.scrolltorow(1)
				tab_1.tabpage_8.dw_atrdis.selectrow(1,true)
				of_carga_atributos()
			end if
		end if
end choose

//Long 		ll_row, ll_item, ll_x
//String 	ls_nro_parte, ls_flag_terminado, ls_oper_sec
//Decimal	ldc_precio_unit
//u_dw_abc ldw_detail, ldw_destajo
//
//ldw_detail  = tab_1.tabpage_1.dw_detail
//ll_row = ldw_detail.Getrow()
//
//IF ll_row = 0 THEN RETURN
//
//ls_nro_parte = ldw_detail.object.nro_parte [ll_row]
//ll_item      = Long(ldw_detail.object.nro_item  [ll_row])
//
//if ls_nro_parte = '' or IsNull(ls_nro_parte) &
//	or ll_item = 0 or IsNull(ll_item) THEN RETURN
//
//event ue_update_request()
//
//This.SetRedraw(false)
//
//CHOOSE CASE newindex
//	CASE 1
////		if oldindex = 3 OR oldindex = 2  or oldindex = 7 then
//			wf_act_cant_costo_labor() //actualiza costo y cantidad de labor
////		end if
//	CASE 2 
//		tab_1.tabpage_2.dw_detinc.Retrieve(ls_nro_parte, ll_item)
//	CASE 3 
//		tab_1.tabpage_3.dw_detasis.Retrieve(ls_nro_parte, ll_item)
//	CASE 4 
//		tab_1.tabpage_4.dw_causas.Retrieve(ls_nro_parte, ll_item)
//	CASE 5 
//		tab_1.tabpage_5.dw_riegos.Retrieve(ls_nro_parte, ll_item)
//	CASE 6 
//		tab_1.tabpage_6.dw_maquina.Retrieve(ls_nro_parte, ll_item)
//	CASE 7
//		ldw_destajo = tab_1.tabpage_7.dw_destajo
//		ldw_destajo.Retrieve(ls_nro_parte, ll_item)
//		
//		ls_flag_terminado = ldw_detail.object.flag_terminado[ll_row]
//		
//		if ls_flag_terminado = '1' then
//			ls_oper_sec = ldw_detail.object.oper_sec[ll_row]
//			select costo_unit
//				into :ldc_precio_unit
//			from operaciones
//			where oper_sec = :ls_oper_sec;
//			
//			if IsNull(ldc_precio_unit) then ldc_precio_unit = 0
//			
//			for ll_x = 1 to ldw_destajo.RowCount()
//				ldw_destajo.object.precio_unit[ll_x] = ldc_precio_unit
//			next
//			
//		end if
//
//		
//	CASE 8
//		tab_1.tabpage_8.dw_prodfin.Retrieve(ls_nro_parte, ll_item)
//
//END CHOOSE
//
//This.SetRedraw(true)
//
//
end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "AddWatch!"
long picturemaskcolor = 536870912
string powertiptext = "Detalle del Parte Diario"
dw_detart dw_detart
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detart=create dw_detart
this.dw_detail=create dw_detail
this.Control[]={this.dw_detart,&
this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detart)
destroy(this.dw_detail)
end on

type dw_detart from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer x = 9
integer y = 440
integer width = 3369
integer height = 264
integer taborder = 50
string dataobject = "d_pr_pd_ot_insumos_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);//boolean 	lb_ret
//string 	ls_codigo, ls_data, ls_sql, ls_und, ls_tmp
//String   ls_name ,ls_prot ,ls_cod_labor, ls_cod_art, ls_where
//Decimal 	ld_costo_insumo
//long		ll_row, ll_i
//str_seleccionar lstr_seleccionar
//
//choose case lower(as_columna)
//		
//	case "cod_art"
//		
//		ll_row = dw_detail.GetRow()
//		if ll_row <= 0 then return
//		
//		ls_cod_labor  = dw_detail.object.cod_labor[ll_row]
//		
//		if ls_cod_labor = '' or IsNull(ls_cod_labor ) then return
//		
//		ls_sql = 'SELECT COD_ART AS CODIGO, '&   
//				 + 'DESC_ART AS DESCRIPCION, '&
//				 + 'UND AS UNIDAD '&
//				 + 'FROM  VW_MTT_ART_X_LABOR '
//		
//		if this.RowCount() > 0 then
//			ls_where = "where "
//			for ll_i = 1 to this.RowCount()
//				ls_tmp = this.object.cod_art[ll_i]
//				if ls_tmp = '' or IsNull(ls_tmp) then continue
//				ls_where = ls_where + " cod_art <> '" + ls_tmp + "'"
//				
//				if this.RowCount() > 1 then
//					ls_where = ls_where + " and "
//				end if
//			next
//		end if
//		
//		if ls_where <> '' then
//			ls_where = ls_where + "COD_LABOR = "+"'"+ls_cod_labor+"'"    
//		else 
//			ls_where = "WHERE COD_LABOR = "+"'"+ls_cod_labor+"'"    
//		end if
//		ls_sql = ls_sql + ls_where
//
//		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
//					ls_data, ls_und, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_art[al_row] = ls_codigo
//			this.object.nom_articulo[al_row] = ls_data
//			this.object.und[al_row] = ls_und
//
//			select nvl(costo_ult_compra,0) 
//				into :ld_costo_insumo 
//			from articulo 
//			where cod_art = :ls_codigo ;
//			
//			this.object.costo_insumo[al_row] = ld_costo_insumo
//			this.ii_update = 1
//
//		end if
//		
//end choose
//
end event

event constructor;call super::constructor;is_mastdet = 'd'			// 'm' = master sin detalle (default), 'd' =  detalle,
	            			// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2



idw_mst  = 	tab_1.tabpage_1.dw_detail		// dw_master
idw_det  =  tab_1.tabpage_1.dw_detart		// dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_art,ls_und, ls_cod_art,ls_cod_labor
Decimal {2} ldc_costo
Long    		ll_count

Accepttext()

CHOOSE CASE dwo.name
		 CASE 'cod_art'
				ls_cod_labor = dw_detail.object.cod_labor [dw_detail.getrow()]
				ls_cod_art   = data

				SELECT Count(*)
				  INTO :ll_count
				  FROM articulo a, labor_insumo l
				 WHERE ((a.cod_art     = l.cod_art     )) AND
					     (a.flag_estado = '1'           )  AND
					     (l.cod_labor   = :ls_cod_labor )  AND
						  (a.cod_art	  = :ls_cod_art   ) ;
			
				IF ll_count > 0 THEN
					SELECT a.desc_art ,
							 a.und		
					  INTO :ls_nom_art,:ls_und
					  FROM articulo a,labor_insumo l
					 WHERE ((a.cod_art     = l.cod_art     )) AND
						     (a.flag_estado = '1'           )  AND
					   	  (l.cod_labor   = :ls_cod_labor )  AND
						     (a.cod_art	  = :ls_cod_art   ) ;
					 
					 
					This.Object.nom_articulo [row] = ls_nom_art
					This.Object.und 			 [row] = ls_und
					This.Object.costo_insumo [row] = ldc_costo
					
				ELSE
					SetNull(ls_cod_art)
					SetNull(ls_nom_art)
					SetNull(ls_und)
					SetNull(ldc_costo)
					This.Object.cod_art [row] =  ls_cod_art
					This.Object.nom_articulo [row] = ls_nom_art
					This.Object.und 			 [row] = ls_und
					This.Object.costo_insumo [row] = ldc_costo
					Messagebox('Aviso','Codigo de Artciulo No Existe , Verifique !')			
					Return 1					
				END IF
				
END CHOOSE

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

event ue_insert_pre;Long 		ll_row, ll_nro_item
string 	ls_nro_parte

ll_row = dw_detail.GetRow()

if ll_row <= 0 then return

ll_nro_item = long(dw_detail.object.nro_item[ll_row])
ls_nro_parte = dw_detail.object.nro_parte[ll_row]

this.object.nro_parte[al_row] = ls_nro_parte
this.object.nro_item[al_row] = ll_nro_item

end event

event doubleclicked;call super::doubleclicked;string ls_column, ls_oper_sec, ls_sql, ls_return1, ls_return2, ls_return3, ls_cod_art, ls_where
decimal ld_return4
long ll_detail, ll_rows, ll_count, ll_reco
str_seleccionar lstr_seleccionar

ls_column = lower(trim(string(dwo.name)))

if ls_column <> 'cod_art' then return

this.AcceptText()

If this.Describe(dwo.Name + ".Protect") = '1' then RETURN

ll_detail = tab_1.tabpage_1.dw_detail.getrow( )

if ll_detail <= 0 then
	messagebox('Error','No se pueden mostrar los artículo si ~r es que usted no ha seleccionado una ~r secuencia de operacion (Oper_Sec)',stopsign!)
	return
end if

ls_oper_sec = tab_1.tabpage_1.dw_detail.object.oper_sec[ll_detail]

if trim(ls_oper_sec) = '' or isnull(ls_oper_sec) then
	messagebox('Error','No se pueden mostrar los artículo si ~r es que usted no ha seleccionado una ~r secuencia de operacion (Oper_Sec)',stopsign!)
	return
end if 

ll_rows = tab_1.tabpage_1.dw_detart.rowcount( )

ls_sql = "select cod_art as articulo_id, desc_art as articulo, und as unidad, precio_unit as precio from vw_pr_articulo_opersec where oper_sec = '"+ls_oper_sec+"'"

if ll_rows >= 1 then
	for ll_reco = 1 to ll_rows step 1
		ls_cod_art = trim(tab_1.tabpage_1.dw_detart.object.cod_art[ll_reco])
		if trim(ls_cod_art) = '' or isnull(ls_cod_art) then
		else
			ls_where = ls_where + ' and cod_art <> ' + ls_cod_art
		end if
	next
	ls_sql = ls_sql + ls_where
end if 

f_lista_4ret4n(ls_sql, ls_return1, ls_return2, ls_return3, ld_return4, '2')

if trim(ls_return1) = '' or isnull(ls_return1) then
	return
end if

this.object.cod_art[row] = ''
this.object.nom_articulo[row] = ''
this.object.und[row] = ''
this.object.costo_insumo[row] = 0.00

this.object.cod_art[row] = ls_return1
this.object.nom_articulo[row] = ls_return2
this.object.und[row] = ls_return3
this.object.costo_insumo[row] = ld_return4
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dberror;
String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
	CASE 1                        // Llave Duplicada
//        Messagebox('Error PK: ' + this.ClassName(),'Llave Duplicada, Linea: ' + String(row))
//		  Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK: ' + this.ClassName(),'Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox('dberror: ' + this.ClassName(), ls_msg, StopSign!)
END CHOOSE





end event

event ue_insert;long ll_row

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

type dw_detail from u_dw_abc within tabpage_1
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer width = 3369
integer height = 432
integer taborder = 20
string dataobject = "d_pr_pd_ot_det_ff"
end type

event ue_display(string as_columna, long al_row);//boolean 	lb_ret
//string 	ls_codigo, ls_data, ls_sql, ls_ejecutor, ls_cod_ejecutor
//String	ls_nro_ot, ls_cod_lab, ls_ot_adm, ls_cod_labor, ls_flag_maq_mo, ls_test
//Long		ll_row
//Decimal	ldc_costo_unitario
//ls_test = ''
//str_seleccionar lstr_seleccionar
//sg_parametros   sl_param
//
//CHOOSE CASE lower(as_columna)
//	CASE 'cod_maquina'
//		
//		ls_sql = "SELECT COD_MAQUINA AS CODIGO ,"&
//  				 + "DESC_MAQ AS DESCRIPCION "&
// 				 + "FROM MAQUINA " &
//				 + "WHERE FLAG_ESTADO = '1'"
//				 
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.cod_maquina[al_row] = ls_codigo
//			this.object.desc_maq[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//	CASE 'cod_labor'
//		ls_sql = "SELECT COD_LABOR AS CODIGO_LABOR ," &
//				 + "DESC_LABOR AS NOMBRES, " &
//				 + "FLAG_MAQ_MO AS FLAG_MAQUINARIA_MO " &
//				 + "FROM LABOR " &
//				 + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
//					ls_data, ls_flag_maq_mo, '1')
//		
//		if ls_codigo <> '' then
//			this.object.cod_labor[al_row] 	 = ls_codigo
//			this.object.desc_labor[al_row] 	 =	ls_data
//			this.object.flag_maq_mo[al_row]	 = ls_flag_maq_mo
//			Setnull(ls_ejecutor)
//			this.object.cod_ejecutor [al_row] = ls_ejecutor
//
//			ls_nro_ot  = This.Object.nro_orden [al_row]
//			ls_cod_lab = This.Object.cod_labor [al_row]
//
//			//Recupero Operaciones
////			wf_retrieve_operaciones (ls_nro_ot, ls_cod_lab, ls_ejecutor)
//
//			this.ii_update = 1
//		end if
//
//	CASE 'cod_ejecutor'						
//		ls_cod_lab = This.object.cod_labor [al_row]
//
//				
//		IF Isnull(ls_cod_lab) OR Trim(ls_cod_lab) = '' THEN
//			Messagebox('Aviso','Debe Ingresar Labor para poder Seleccionar el Ejecutor')
//			Return
//		END IF 
//		
//		ls_sql = "SELECT COD_EJECUTOR AS CODIGO_EJECUTOR,  " &
// 				 + "DESC_EJECUTOR AS DESCRIPCION_EJECUTOR " &
//				 + "FROM vw_pr_labor_ejecutor " &
//				 + "WHERE COD_LABOR = '" + ls_cod_lab + "'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.cod_ejecutor			[al_row] = ls_codigo
//			this.object.ejecutor_descripcion [al_row] = ls_data
//			
//			SetNull(ldc_costo_unitario)
//			
//			select costo_unitario
//				into :ldc_costo_unitario
//			from labor_ejecutor
//			where cod_labor    = :ls_cod_labor
//			  and cod_ejecutor = :ls_codigo;
//			  
//			If IsNull(ldc_costo_unitario) then ldc_costo_unitario = 0
//			
//			this.Object.lab_ejecut[al_row] = ldc_costo_unitario
//
//			ls_nro_ot	 = This.Object.nro_orden    [al_row]
//			ls_cod_lab   = This.Object.cod_labor    [al_row]
//			ls_ejecutor  = This.Object.cod_ejecutor [al_row]
//
//			//Recupero Operaciones
////			wf_retrieve_operaciones (ls_nro_ot, ls_cod_lab, ls_ejecutor)
//
//			this.ii_update = 1
//		end if
//
//	CASE 'proveedor'
//		
//		ls_sql = "SELECT PROVEEDOR AS CODIGO , " &
//				 + "NOM_PROVEEDOR AS NOMBRE " &
//				 + "FROM PROVEEDOR " &
//				 + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.proveedor[al_row] 	 = ls_codigo
//			this.object.nom_proveedor[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//
//	CASE 'confin'
//	
//		ls_sql = 'SELECT CONFIN AS CODIGO , ' &
//			    + 'DESCRIPCION AS NOMBRE ' &
//			    + 'FROM CONCEPTO_FINANCIERO '
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//		
//		if ls_codigo <> '' then
//			this.object.confin[al_row] 	 = ls_codigo
//			this.ii_update = 1
//		end if
//
//	CASE 'nro_orden'  //Busqueda de Ordenes de Trabajo
//		
//		//buscar ot_adm de cabecera
//		ll_row = dw_master.getrow()
//		IF ll_row = 0 THEN RETURN
//
//		ls_ot_adm    = dw_master.object.ot_adm [ll_row]
//				
//		IF Isnull(ls_ot_adm) OR trim(ls_ot_adm) = '' THEN
//			Messagebox('Aviso','Debe Ingresar la Administracion de las OT ')
//			Return
//		END IF
//				
//		sl_param.dw1    = 'd_abc_lista_orden_trabajo_tbl'
//		sl_param.titulo = 'Orden de Trabajo'
//				
//		sl_param.tipo    = '1SQL'                                                          
//		sl_param.string1 = 'WHERE ( "VW_OPE_OT_X_ADM"."OT_ADM" = '+"'"+ls_ot_adm+"'"+') AND   '&
//										 +'     ( "VW_OPE_OT_X_ADM"."USUARIO"= '+"'"+gs_user  +"'"+')    '
//		sl_param.field_ret_i[1] = 1
//		sl_param.field_ret_i[2] = 2
//
//
//		OpenWithParm( w_lista, sl_param)
//
//		sl_param = Message.PowerObjectParm
//		IF sl_param.titulo <> 'n' THEN
//			ls_cod_labor 	 = This.Object.cod_labor   [al_row]
//			ls_cod_ejecutor = This.Object.cod_ejecutor[al_row]
//				
//			This.object.nro_orden  [al_row] = sl_param.field_ret[2]
//			//Recupero Operaciones
////			wf_retrieve_operaciones (sl_param.field_ret[2], ls_cod_labor, ls_cod_ejecutor)
//			
//			This.ii_update = 1
//		END IF
//
//
//end choose
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1			// columnas de lectrua de este dw
ii_dk[2] = 2

ii_rk[1] = 1 	      // columnas que recibimos del master

idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
end event

event itemchanged;call super::itemchanged;Decimal {2} ldc_seg,ldc_hrs
Long			ll_count,ll_row_master
String      ls_descripcion,ls_codigo      , ls_nro_doc ,&
		      ls_cod_labor  ,ls_cod_ejecutor, ls_desc_maq,&
				ls_und_hr	  ,ls_und			, ls_cencos  ,&
				ls_ot_adm     ,ls_nro_orden	, ls_flag_maq_mo
Datetime    ldt_hora_inicio, ldt_hora_fin
Decimal		ldc_costo_unitario

This.Accepttext()

/*unidades hora*/
SELECT und_hr 
	INTO :ls_und_hr 
FROM prod_param 
WHERE reckey = '1' ;

CHOOSE CASE dwo.name

	CASE	'nro_orden'
		/*VERIFICAR ORDEN DE TRABAJO BAJO OT_ADM*/
		ll_row_master = dw_master.getrow()
				
		ls_ot_adm = dw_master.object.ot_adm [ll_row_master]
				
		IF Isnull(ls_ot_adm) OR Trim(ls_ot_adm) = '' THEN
			SetNull(ls_nro_orden)
			This.object.nro_orden [row] = ls_nro_orden
			Messagebox('Aviso','Debe Ingresar OT ADM ,Verifique!')	
			Return 1
		END IF
									
		SELECT Count(*) 
			INTO :ll_count 
		FROM orden_trabajo 
		WHERE nro_orden = :data 
		  AND ot_adm = :ls_ot_adm ;
				
		IF ll_count = 0 THEN
			SetNull(ls_nro_orden)
			This.object.nro_orden [row] = ls_nro_orden
			Messagebox('Aviso','Nro de Orden No pertenece a OT ADM ,Verifique!')	
			Return 1
		END IF
			
									
		ls_cod_labor 	 = This.Object.cod_labor    [row]
		ls_cod_ejecutor = This.Object.cod_ejecutor [row]
		
		//Recupero Operaciones
//		wf_retrieve_operaciones (data,ls_cod_labor,ls_cod_ejecutor)
				
	CASE 'cod_maquina'
		SELECT Count(*)
			INTO :ll_count
		FROM maquina
		WHERE (cod_maquina = :data) ;
				
		IF ll_count > 0 THEN
			SELECT desc_maq
		     INTO :ls_desc_maq
		   FROM maquina
		   WHERE (cod_maquina = :data) ;
					 
			This.Object.desc_maq    [row] = ls_desc_maq
					
		ELSE
		
			SetNull(ls_codigo)
			SetNull(ls_desc_maq)
					
			Messagebox('Aviso','Debe Ingresar Codigo de Maquina Valido , Verirfique!')
			This.Object.cod_maquina [row] = ls_codigo
			This.Object.desc_maq    [row] = ls_desc_maq
			Return 2
		END IF
				
	CASE 'cod_labor'
		SELECT Count(*)
			INTO :ll_count
		FROM labor
		WHERE (cod_labor = :data) ;
				 
		IF ll_count > 0 THEN
			setnull(ls_cod_ejecutor)
					
			SELECT desc_labor, flag_maq_mo
				INTO :ls_descripcion, :ls_flag_maq_mo
			FROM labor
			WHERE (cod_labor = :data) ;
					 
			this.object.desc_labor   [row] = ls_descripcion
			this.object.flag_maq_mo  [row] = ls_flag_maq_mo
			this.object.cod_ejecutor [row] = ls_cod_ejecutor
		ELSE
		
			SetNull(ls_codigo)
			SetNull(ls_descripcion)
			setnull(ls_cod_ejecutor)
					
			This.Object.cod_labor  [row] = ls_codigo
			This.Object.flag_maq_mo[row] = ls_codigo
			This.Object.desc_labor [row] = ls_descripcion
			this.object.cod_ejecutor [row] = ls_cod_ejecutor
			Messagebox('Aviso','Codigo de Labor No existe, Verifique!')
			Return 1
		END IF
				
		/*Recupero operaciones*/
		ls_nro_doc  	 = This.Object.nro_orden    [row]
		ls_cod_labor	 = This.Object.cod_labor    [row]
		ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				
//		wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
		/**/

				
		//actualizo costo labor....
		of_act_cant_costo_labor ()
				
	CASE 'cod_ejecutor'
				
		ls_cod_labor	 = This.Object.cod_labor    [row]
				
		SELECT Count(*)
			INTO :ll_count
		FROM labor_ejecutor
		WHERE cod_labor    = :ls_cod_labor 
		  AND cod_ejecutor = :data         ;

		IF ll_count > 0 THEN
			SELECT descripcion
				INTO :ls_descripcion
			FROM ejecutor
			WHERE (cod_ejecutor = :data) ;
			
			SELECT costo_unitario
				INTO :ldc_costo_unitario
			FROM labor_ejecutor
			WHERE cod_labor    = :ls_cod_labor 
			  AND cod_ejecutor = :data         ;
					
			This.Object.ejecutor_descripcion [row] = ls_descripcion
			this.Object.lab_ejecut				[row] = ldc_costo_unitario
		ELSE
		
			SetNull(ls_codigo)
			SetNull(ls_descripcion)
					
			This.Object.cod_ejecutor         [row] = ls_codigo
			This.Object.ejecutor_descripcion [row] = ls_descripcion
					
			Messagebox('Aviso','Codigo de Ejecutor No existe o No esta relacionado, Verifique!')
			Return 1
					
		END IF
				
		//actualizo costo labor....
		of_act_cant_costo_labor ()
				
		/*Recupero operaciones*/
		ls_nro_doc  	 = This.Object.nro_orden    [row]
		ls_cod_labor	 = This.Object.cod_labor    [row]
		ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				
//		wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
		/**/
				
	CASE 'proveedor'
		SELECT Count(*)
			INTO :ll_count
		FROM proveedor
		WHERE (proveedor = :data) ;

		IF ll_count = 0 THEN
			SetNull(ls_codigo)
			This.Object.proveedor [row] = ls_codigo
			Messagebox('Aviso','Codigo de Proveedor No existe, Verifique!')
			Return 2
		END IF
			
			
	CASE 'confin'
		SELECT Count(*)
		  INTO :ll_count
		FROM concepto_financiero
		WHERE (confin = :data) ;
			
		IF ll_count = 0 THEN
			SetNull(ls_codigo)
			This.Object.confin [row] = ls_codigo
			Messagebox('Aviso','Concepto Financiero No existe, Verifique!')
			Return 1
		END IF
	
	CASE 'hora_inicio'
			
		ls_und = This.object.labor_und [row]
	  	IF ls_und = ls_und_hr THEN
	  		ldt_hora_inicio 	= DateTime(This.object.hora_inicio [row])
		  	ldt_hora_fin	 	= DateTime(This.object.hora_fin    [row])
			  
  			ldc_hrs 				= Round(f_rango_horas( ldt_hora_inicio, ldt_hora_fin), 2)

		END IF
			
		//cantidad y costo labor	
		of_act_cant_costo_labor ()	
			  
	CASE 'hora_fin'	
			  
	  	ls_und = This.object.labor_und [row]
			  
		IF ls_und = ls_und_hr THEN	
			ldt_hora_inicio 	= DateTime(This.object.hora_inicio [row])
			ldt_hora_fin	 	= DateTime(This.object.hora_fin    [row])
			
			ldc_hrs 				= Round(f_rango_horas( ldt_hora_inicio, ldt_hora_fin), 2)
		END IF
			  
	  	//cantidad y costo labor	
	  	of_act_cant_costo_labor ()		

	CASE 'cant_labor'	
			  
	  	//cantidad y costo labor	
	  	of_act_cant_costo_labor ()		
			  
	CASE 'cencos'					
		SELECT Count(*)	
			INTO :ll_count
		FROM centros_costo
		WHERE (cencos = :data) ;
				
		IF ll_count = 0 THEN
			SetNull(ls_cencos)	
			This.object.cencos [row] = ls_cencos
			Messagebox('Aviso','Centro de Costo No Existe , Verifique!')
			Return 1
		END IF

END CHOOSE



end event

event itemerror;call super::itemerror;Return 1
end event

event dragdrop;long ll_operacion
integer li_cuenta

of_selecciona_operacion()
end event

event ue_insert_pre;Long    ll_row
String  ls_doc_ot, ls_parte
Integer li_item
Datetime 	ldt_fecha

ll_row = This.RowCount()
IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,"nro_item")
END IF

ib_detail_new = TRUE

This.SetItem(al_row, "nro_item", li_item + 1)  

ldt_fecha = dw_master.GetItemDateTime(dw_master.GetRow(), 'fecha' )
this.object.nro_parte[al_row] = dw_master.object.nro_parte[dw_master.getrow()]
this.object.tipo_doc[al_row] = is_doc_ot
This.object.hora_inicio[al_row] = ldt_fecha
This.object.hora_fin[al_row] = ldt_fecha
This.object.flag_terminado[al_row] = '0' //Activo
This.object.flag_conformidad[al_row] = 'B' //Bueno				

This.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event rowfocuschanged;//Long 	 ll_item
//String ls_expresion,ls_nro_doc,ls_cod_labor,ls_cod_ejecutor
//String ls_parte
//
//IF currentrow = 0 THEN RETURN
//
//ll_item 			 = This.object.nro_item 	 [currentrow]
//ls_nro_doc	    = This.object.nro_orden  	 [currentrow]
//ls_cod_labor    = This.object.cod_labor    [currentrow]
//ls_cod_ejecutor = This.object.cod_ejecutor [currentrow]
//ls_parte			 = This.object.nro_parte	 [CurrentRow]
//
//tab_1.tabpage_1.dw_lista.SetRow(currentrow)
//tab_1.tabpage_1.dw_lista.ScrolltoRow(currentrow)
//
//wf_retrieve_operaciones (ls_nro_doc, ls_cod_labor, &
//		ls_cod_ejecutor)
end event

event doubleclicked;call super::doubleclicked;String ls_column, ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_return7, ls_return8, ls_return9, ls_nro_orden

if this.ii_protect = 1 then return

ls_column = string(dwo.name)

choose case ls_column
	case 'nro_orden'
		if messagebox('Parte Diario de Producción','Cambiar de parte diario ~r provocará que pierda los ~r datos de este detalle. ~r  ~r ¿Desea borrar estos datos?',Question!, YesNo!, 2) = 2 then return
		if trim(is_ot_adm) = '' or isnull(is_ot_adm) then
			messagebox(this.title,'El usuario no ha sido identificado con ninguna admisntración. ~r No se pueden mostrar órdenes de trabajo.',stopsign!)
			return
		else
			tab_1.tabpage_1.dw_detart.reset( )
			tab_1.tabpage_1.dw_detart.ii_update = 1
			this.object.nro_orden[row] = ''
			this.object.oper_sec[row] = ''
			this.object.cod_labor[row] = ''
			this.object.desc_labor[row] = ''
			this.object.flag_maq_mo[row] = 'M'
			this.object.cod_ejecutor[row] = ''
			this.object.ejecutor_descripcion[row] = ''
			this.object.proveedor[row] = ''
			this.object.nom_proveedor[row] = ''
			this.object.cod_maquina[row] = ''
			this.object.desc_maq[row] = ''
			this.object.ind_act_maq[row] = 0.00
			this.object.hora_inicio[row] = datetime(today(),now())
			this.object.hora_fin[row] = datetime(today(),now())
			this.object.horas_inciden[row] = 0.00
			this.object.cant_avance[row] = 0.00
			this.object.und_avance[row] = ''
			this.object.desc_unidad[row] = ''
			this.object.costo_unitario[row] = 0.00
			this.object.cant_labor[row] = 0.00
			this.object.labor_und[row] = ''
			this.object.costo_labor[row] = 0.00
			this.object.cencos[row] = ''
			this.object.confin[row] = ''
			this.object.obs[row] = ''
			this.object.flag_conformidad[row] = 'B'
			this.object.flag_terminado[row] = '0'
			
						
			ls_sql = "select nro_orden as numero, desc_orden as descripcion, flag_estado as estado, desc_ot_adm as adminsitracion, desc_cencos_s as solicitante, desc_cencos_r as respondable,  f_solicitud as solicitud, f_estimado as estimado, f_inicio as inicio from vw_pr_pd_ot_adm where ot_adm in ("+is_ot_adm+")"
			
			f_lista_9ret(ls_sql, ls_return1, ls_return2, ls_return3, ls_return4, ls_return5, ls_return6, ls_return7, ls_return8, ls_return9, '1')
			
			dw_lista.object.nro_orden[dw_lista.getrow()] = ls_return1
			
			this.object.nro_orden[row] = ls_return1
			
			if of_carga_operaciones() <= 0 then return

			dw_operaciones.scrolltorow(1)
			dw_operaciones.setrow(1)
			dw_operaciones.selectrow(1,true)
			
			of_selecciona_operacion()
			
		end if
		
	case 'cod_labor'
		of_selecciona_labor()
	case 'cod_ejecutor'
		of_selecciona_labor()
	case 'proveedor'
		of_selecciona_labor()
	case 'cod_maquina'
		of_selecciona_labor()
	case 'und_avance'
		of_selecciona_labor()
	case 'cencos'
		ls_sql = "select cencos as codigo, desc_cencos as descripcion from centros_costo where flag_estado = '1'"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if trim(ls_return1) = '' or isnull(ls_return1) then
		else
			this.object.cencos[row] = ls_return1
		end if
	case 'confin'
		ls_sql = "select confin as confin_id, descripcion as confin_desc from concepto_financiero"
		f_lista(ls_sql, ls_return1, ls_return2, '2')
		if trim(ls_return1) = '' or isnull(ls_return1) then
		else
			this.object.confin[row] = ls_return1
		end if
end choose
this.ii_update = 1
//string ls_columna
//long ll_row 
//str_seleccionar lstr_seleccionar
//
//this.AcceptText()
//If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
//ll_row = row
//
//if row > 0 then
//	ls_columna = upper(dwo.name)
//	this.event dynamic ue_display(ls_columna, ll_row)
//end if
end event

event dberror;// OVERIDE
String	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer	li_pos_ini, li_pos_fin, li_pos_nc

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode
	//CASE 1                        // Llave Duplicada
//        Messagebox('Error PK','Llave Duplicada, Linea: ' + String(row))
 //       Return 1
	CASE 02292                         // Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;
        Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
        Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		//ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
		//ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE





end event

event buttonclicked;call super::buttonclicked;//Long   	ll_row_master, ll_row_det
//String 	ls_cod_labor, ls_cod_ejecutor, ls_ot_adm   , &
//			ls_flag_oper, ls_nro_orden   , ls_proveedor, &
//			ls_oper_sec , ls_und_avance  , ls_obs      , &
//			ls_desc_labor
//			
//Decimal	ldc_cant_avance, ldc_und_avance, ldc_cant_labor, &
//			ldc_costo_labor
//
//DateTime	ldt_hora_inicio, ldt_hora_fin
//u_dw_abc	ldw_detail
//sg_parametros sl_param
//				
//tab_1.tabpage_1.dw_lista.il_row = row  
//dw_master.Accepttext()
//ldw_detail = tab_1.tabpage_1.dw_detail
//ldw_detail.AcceptText()
//
//CHOOSE CASE lower(dwo.name)
//	CASE 'b_lanz'
//		ll_row_det = ldw_detail.Getrow()
//				
//		if MessageBox('Aviso','Esta Seguro de Lanzar Operación ', &
//			Question!, yesno!, 2) = 2 then
//			RETURN
//		end if
//
//		//inserta operaciones
//		ls_nro_orden    = tab_1.tabpage_1.dw_detail.object.nro_orden    [ll_row_det]
//		ls_cod_labor    = tab_1.tabpage_1.dw_detail.object.cod_labor    [ll_row_det]
//		ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor [ll_row_det]
//		ls_proveedor	 = tab_1.tabpage_1.dw_detail.object.proveedor    [ll_row_det]
//		ldt_hora_inicio = tab_1.tabpage_1.dw_detail.object.hora_inicio  [ll_row_det]
//		ldt_hora_fin    = tab_1.tabpage_1.dw_detail.object.hora_fin     [ll_row_det]
//		ldc_cant_avance = tab_1.tabpage_1.dw_detail.object.cant_avance  [ll_row_det]
//		ls_und_avance   = tab_1.tabpage_1.dw_detail.object.und_avance   [ll_row_det]
//		ldc_cant_labor  = tab_1.tabpage_1.dw_detail.object.cant_labor   [ll_row_det]
//		ls_obs          = tab_1.tabpage_1.dw_detail.object.obs          [ll_row_det]
//		ls_desc_labor   = tab_1.tabpage_1.dw_detail.object.desc_labor   [ll_row_det]
//		ldc_costo_labor = tab_1.tabpage_1.dw_detail.object.costo_labor  [ll_row_det]
//		ls_oper_sec     = tab_1.tabpage_1.dw_detail.object.oper_sec     [ll_row_det]
//
//		IF Not(Isnull(ls_oper_sec) OR Trim(ls_oper_sec) = '') THEN
//			Messagebox('Aviso','Item ya Contiene Un Oper Sec Verifique')
//			Return
//		END IF
//
//		IF Isnull(ls_nro_orden) or Trim(ls_nro_orden) = '' THEN
//			Messagebox('Aviso','Debe Ingresar Nro de Orden de Trabajo')
//			Return
//		END IF
//		
//		IF Isnull(ls_cod_labor) or Trim(ls_cod_labor) = '' THEN
//			Messagebox('Aviso','Debe Ingresar Codigo de Labor')
//			Return
//		END IF
//
//		IF Isnull(ls_cod_ejecutor) or Trim(ls_cod_ejecutor) = '' THEN
//			Messagebox('Aviso','Debe Ingresar Codigo de Ejecutor')
//			Return
//		END IF
//
//		IF Isnull(ldc_cant_labor) or ldc_cant_labor = 0 THEN
//			Messagebox('Aviso','Debe Ingresar Cantidad de Labor')
//			Return
//		END IF
//
//		ls_oper_sec = wf_insert_oper_sec (ls_nro_orden, &
//						ls_cod_labor , ls_cod_ejecutor, &
//						ls_proveedor , ldt_hora_inicio, &
//						ldt_hora_fin , ldc_cant_avance, &
//						ls_und_avance, ldc_cant_labor , &
//						ls_obs       , ls_desc_labor  , &
//						ldc_costo_labor)
//		
//		if ls_oper_sec <> '' then
//			ldw_detail.object.oper_sec  [ll_row_det] = ls_oper_sec
//		end if
//
//END CHOOSE
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
//
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
	source.DragIcon = "\Source\ICO\row.ico"
end if
end event

event dragleave;call super::dragleave;source.DragIcon = "Error!"

end event

event ue_insert;//IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
//	IF idw_mst.il_row = 0 THEN
//		MessageBox("Error", "No ha seleccionado registro Maestro")
//		RETURN - 1
//	END IF
//END IF
//
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Incidencia"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
string powertiptext = "Incidencias del Parte Diario"
dw_detinc dw_detinc
end type

on tabpage_2.create
this.dw_detinc=create dw_detinc
this.Control[]={this.dw_detinc}
end on

on tabpage_2.destroy
destroy(this.dw_detinc)
end on

type dw_detinc from u_dw_abc within tabpage_2
event ue_display ( string as_columna,  long al_row )
integer y = 8
integer width = 3374
integer height = 732
integer taborder = 20
string dataobject = "d_pd_ot_incidencias_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_tmp, &
			ls_where
long		ll_row, ll_i
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	CASE 'cod_incidencia'
		
		ls_sql = 'SELECT COD_INCIDENCIA  AS CODIGO,' &
  				 + 'DESC_INCIDENCIA AS DESCRIPCION, ' &
				 + 'TIPO_INCIDENCIA AS TIPO '&
  				 + 'FROM INCIDENCIAS_DMA '
		
		if this.RowCount() > 0 then
			ls_where = "where "
			for ll_i = 1 to this.RowCount()
				ls_tmp = this.object.cod_incidencia[ll_i]
				if ls_tmp = '' or IsNull(ls_tmp) then continue
				ls_where = ls_where + " COD_INCIDENCIA <> '" + ls_tmp + "'"
				
				if this.RowCount() > 1 then
					ls_where = ls_where + " and "
				end if
			next
		end if
		
		if ls_where <> '' then
			ls_where = ls_where + "FLAG_ESTADO = '1'"    
		else 
			ls_where = "WHERE FLAG_ESTADO = '1'"    
		end if
		ls_sql = ls_sql + ls_where

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')

		if ls_codigo <> '' then
			this.object.cod_incidencia[al_row] 	= ls_codigo
			this.object.descripcion[al_row] 		= ls_data
			this.ii_update = 1

		end if
		
end choose




end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2

end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_descripcion
Long   ll_count

Accepttext()


CHOOSE CASE dwo.name
		 CASE 'cod_incidencia'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM incidencias_dma
				 WHERE (cod_incidencia = :data );
				 
				IF ll_count > 0 THEN
					SELECT desc_incidencia
					  INTO :ls_descripcion
					  FROM incidencias_dma
					 WHERE (cod_incidencia = :data) ;
					
					This.Object.descripcion [row] = ls_descripcion
					
				ELSE
					SetNull(ls_descripcion)
					This.Object.descripcion [row] = ls_descripcion
					Messagebox('Aviso','Codigo de Incidencia No Existe , Verifique!')
					Return 1
				END IF
		
END CHOOSE

end event

event ue_insert_pre;Long    	ll_row, ll_item
string	ls_parte
DateTime ldt_fecha
u_dw_abc ldw_1
	
ll_row = This.Rowcount()

IF ll_row = 0 THEN RETURN

THIS.SetItem(al_row,'nro_incidencia', ll_row)  

ll_row = dw_master.GetRow()
if ll_row <= 0 then return
ldt_fecha = DateTime( dw_master.object.fecha[ll_row] )

ldw_1 = tab_1.tabpage_1.dw_detail
ll_row = ldw_1.Getrow()
if ll_row <= 0 then return

ll_item   = Long(ldw_1.object.nro_item[ll_row])
ls_parte  = ldw_1.object.nro_parte[ll_row]


this.object.nro_parte[al_row]		= ls_parte
this.object.nro_item[al_row] 		= ll_item
This.object.fecha_inicio[al_row] = ldt_fecha
This.object.fecha_fin[al_row] 	= ldt_fecha

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

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
	THIS.Event ue_output(CurrentRow)
	RETURN
END IF
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Trabajadores"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "ArrangeIcons!"
long picturemaskcolor = 536870912
sle_search sle_search
st_search st_search
dw_codrel dw_codrel
pb_1 pb_1
dw_detasis dw_detasis
end type

on tabpage_3.create
this.sle_search=create sle_search
this.st_search=create st_search
this.dw_codrel=create dw_codrel
this.pb_1=create pb_1
this.dw_detasis=create dw_detasis
this.Control[]={this.sle_search,&
this.st_search,&
this.dw_codrel,&
this.pb_1,&
this.dw_detasis}
end on

on tabpage_3.destroy
destroy(this.sle_search)
destroy(this.st_search)
destroy(this.dw_codrel)
destroy(this.pb_1)
destroy(this.dw_detasis)
end on

type sle_search from editmask within tabpage_3
integer x = 210
integer y = 32
integer width = 800
integer height = 80
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
end type

type st_search from statictext within tabpage_3
integer y = 44
integer width = 201
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre"
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_codrel from u_dw_abc within tabpage_3
integer y = 128
integer width = 1120
integer height = 588
integer taborder = 20
string dataobject = "d_pr_codre_ot_adm_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event ue_column_sort;Integer li_pos, li_len
String  ls_column , ls_setsort, ls_name

ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'~t')
ls_name = mid(ls_column, 1, li_pos - 1)

IF Lower(Right(ls_name, 2)) <> '_t' THEN RETURN

li_len = len(ls_name) - 2
ls_setsort = mid(ls_column, 1, li_len )

st_search.text = Wordcap(ls_setsort)

IF ii_sort = 0 THEN
	ii_sort = 1
	ls_setsort = trim(ls_setsort) + ' A'
ELSE
	ii_sort = 0
	ls_setsort = trim(ls_setsort) + ' D'
END IF

THIS.setsort(ls_setsort)
THIS.sort()
end event

event dragleave;call super::dragleave;
source.DragIcon = "Error!"

end event

event dragenter;call super::dragenter;if source = this then
	source.DragIcon = "\Source\ICO\row.ico"
end if

end event

event clicked;call super::clicked;This.drag(begin!)

end event

type pb_1 from picturebutton within tabpage_3
integer x = 1010
integer y = 28
integer width = 101
integer height = 88
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean originalsize = true
string picturename = "Retrieve!"
alignment htextalign = left!
end type

event clicked;string ls_sql, ls_search, ls_ot_adms, ls_where

if dw_master.getrow() <> 1 then
	messagebox('Error','Primero debe seleccionar un parte diario',stopsign!)
	return
end if
declare usp_ot_adm_usr procedure for
	usp_pr_ot_adm_usr (:gs_user);

execute usp_ot_adm_usr;
fetch usp_ot_adm_usr into :ls_ot_adms;
close usp_ot_adm_usr;

ls_search = trim(tab_1.tabpage_3.sle_search.text)
if trim(ls_search) = '' or isnull(ls_search) then
	ls_sql = "SELECT cr.cod_relacion, cr.nombre, cra.grupo  FROM cod_rel_agrupamiento cra, codigo_relacion cr WHERE cra.cod_relacion = cr.cod_relacion ORDER BY cr.nombre"
else
	ls_where = lower(trim(tab_1.tabpage_3.st_search.text))

	choose case ls_where
		case 'codigo'
			ls_where = 'cr.cod_relacion'
		case 'grupo'
			ls_where = 'cra.grupo'
		case 'nombre'
			ls_where = 'cr.nombre'
	end choose

	ls_sql = "SELECT cr.cod_relacion, cr.nombre, cra.grupo  FROM cod_rel_agrupamiento cra, codigo_relacion cr WHERE cra.cod_relacion = cr.cod_relacion  AND " + ls_where + " LIKE '%" + ls_search + "%' ORDER BY cr.nombre"
	
end if

dw_codrel.setsqlselect(ls_sql)

dw_codrel.retrieve()
end event

type dw_detasis from u_dw_abc within tabpage_3
event ue_display ( string as_columna,  long al_row )
integer x = 1120
integer width = 2258
integer height = 716
integer taborder = 20
string dataobject = "d_pd_ot_asistencia_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_ot_adm
String 	ls_flag_oper
long 		ll_row
decimal	ldc_gan_fija
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_TRABAJADOR"
		
		dw_master.Accepttext()
				
		ll_row = dw_master.Getrow()	
		if ll_row <= 0 then return
		ls_ot_adm = dw_master.object.ot_adm [ll_row]
		IF Isnull(ls_ot_adm) OR Trim(ls_ot_adm) = '' THEN
			Messagebox('Aviso','Ingrese OT ADM en la cabecera de Parte ')
			Return
		END IF

		ls_sql = "SELECT GRUPO AS COD_GRUPO ," &
				 + "COD_RELACION AS CODIGO_TRABAJADOR ," &
  				 + "NOMBRE AS NOMBRES " &
 				 + "FROM VW_OPE_CRELACION_X_GRUPO "&
				 + "WHERE OT_ADM = '" + ls_ot_adm + "'" 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador[al_row] = ls_codigo
			this.object.nom_trabaajdor[al_row] = ls_data
			this.ii_update = 1

			/** Sueldo de Trabajador **/
			SELECT Sum(Round(imp_gan_desc / 240 ,2))  
				INTO :ldc_gan_fija  
			FROM gan_desct_fijo  
			WHERE cod_trabajador     = :ls_codigo 
			  AND Substr(concep,1,1) = '1'   
			  AND flag_estado        = '1'   
			  AND flag_trabaj        = '1'      
			GROUP BY cod_trabajador  ;
					
					
			IF Isnull(ldc_gan_fija) THEN ldc_gan_fija = 0.00
					
			This.object.costo_horas [al_row] = ldc_gan_fija	
					

		end if
		
end choose


end event

event clicked;IF tab_1.tabpage_1.dw_detail.GetRow() > 0 THEN
	idw_mst.il_row = 1
END IF

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3

idw_mst  = tab_1.tabpage_1.dw_detail		// dw_master
idw_det  = tab_1.tabpage_3.dw_detasis 		// dw_detail
end event

event itemchanged;call super::itemchanged;Long 	 ll_count,ll_row_master
String ls_nombre,ls_codigo,ls_ot_adm
Decimal {2} ldc_gan_fija,ldc_horas,ldc_min

Accepttext()


CHOOSE CASE dwo.name
		 CASE	'nro_horas' 
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				
				
		 CASE 'factor'
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				IF Dec(data) < 1 THEN
					This.Object.factor [row] = 1.00
					Return 2
				END IF
		 CASE 'cod_trabajador'
				ll_row_master = dw_master.getrow()
				ls_ot_adm = dw_master.object.ot_adm [ll_row_master]
				
				/*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1			
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM vw_ope_crelacion_x_grupo
				 WHERE (cod_relacion = :data      ) AND
				 		 (ot_adm			= :ls_ot_adm );
				
				IF ll_count > 0 THEN
					/** Nombre de Trabajador ***/
					
					SELECT nombre
					  INTO :ls_nombre
					  FROM vw_ope_crelacion_x_grupo
					 WHERE (cod_relacion = :data      ) AND
					 		 (ot_adm			= :ls_ot_adm ) ;
					
					This.Object.nom_trabajador [row] = ls_nombre
					
					/** Sueldo de Trabajador **/
					SELECT Sum(Round(imp_gan_desc / 240 ,2))  
				     INTO :ldc_gan_fija  
				     FROM gan_desct_fijo  
				    WHERE  ( cod_trabajador     = :data ) AND  
         				 (( Substr(concep,1,1) = '1'   ) AND  
         				  ( flag_estado        = '1'   ) AND  
        					  ( flag_trabaj        = '1'   ))   
					GROUP BY cod_trabajador  ;
					
					IF Isnull(ldc_gan_fija) THEN ldc_gan_fija = 0.00
					
					This.object.costo_horas [row] = ldc_gan_fija
					
					
					
				ELSE
					SetNull(ls_codigo)
					SetNull(ls_nombre)
					
					This.Object.cod_trabajador [row] = ls_codigo
					This.Object.nom_trabajador [row] = ls_nombre
					Messagebox('Aviso','Codigo de Trabajador No existe , Verifique!')
					Return 1
				END IF
		 	

END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_row
Integer li_item
ll_row = tab_1.tabpage_1.dw_detail.Getrow()
li_item = tab_1.tabpage_1.dw_detail.GetItemNumber( ll_row, 'nro_item')
this.SetItem(al_row, 'nro_item', li_item)
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

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dragenter;call super::dragenter;if source = dw_codrel then
	source.DragIcon = "\Source\ICO\row.ico"
end if
end event

event dragdrop;call super::dragdrop;string ls_cod_rel, ls_nombre
long ll_marca, ll_codrel, ll_reco, ll_detasis, ll_find, ll_endfind
decimal ldc_gan_fija
ll_codrel =  dw_codrel.rowcount()

if ll_codrel <= 0 then return

for ll_reco = 1 to ll_codrel
	ll_marca = tab_1.tabpage_3.dw_codrel.GetSelectedRow(ll_reco - 1)
	if ll_marca = ll_reco then
			
		ls_cod_rel = trim(tab_1.tabpage_3.dw_codrel.object.codigo[ll_reco])
		ls_nombre = trim(tab_1.tabpage_3.dw_codrel.object.nombre[ll_reco])
		ll_endfind = tab_1.tabpage_3.dw_detasis.rowcount()
		ll_find = tab_1.tabpage_3.dw_detasis.find("cod_trabajador = '" + ls_cod_rel + "'", 1, ll_endfind)

		if ll_find <= 0 then
			this.event ue_insert()
			ll_detasis = tab_1.tabpage_3.dw_detasis.rowcount()
			tab_1.tabpage_3.dw_detasis.object.cod_trabajador[ll_detasis] = ls_cod_rel
			tab_1.tabpage_3.dw_detasis.object.nom_trabajador[ll_detasis] = ls_nombre
			SELECT Sum(Round(imp_gan_desc / 240 ,2))  
				     INTO :ldc_gan_fija  
				     FROM gan_desct_fijo  
				    WHERE  ( cod_trabajador     = :ls_cod_rel ) AND  
         				 (( Substr(concep,1,1) = '1'   ) AND  
         				  ( flag_estado        = '1'   ) AND  
        					  ( flag_trabaj        = '1'   ))   
					GROUP BY cod_trabajador  ;

			tab_1.tabpage_3.dw_detasis.object.costo_horas[ll_detasis] = ldc_gan_fija
					
		end if
	end if
next

end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Causas de Fallas"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Custom014!"
long picturemaskcolor = 536870912
dw_causas dw_causas
end type

on tabpage_4.create
this.dw_causas=create dw_causas
this.Control[]={this.dw_causas}
end on

on tabpage_4.destroy
destroy(this.dw_causas)
end on

type dw_causas from u_dw_abc within tabpage_4
integer x = 5
integer y = 12
integer width = 3374
integer height = 376
integer taborder = 20
string dataobject = "d_pr_causas_fallas_x_ot_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

IF tab_1.tabpage_1.dw_detail.GetRow() > 0 THEN
	idw_mst.il_row = 1
END IF

end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				
ii_ck[3] = 3				

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = tab_1.tabpage_1.dw_detail // dw_master
idw_det  = tab_1.tabpage_4.dw_causas // dw_detail
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_causa_falla,ls_desc_causa
Accepttext()

CHOOSE CASE dwo.name
		 CASE 'causa_falla'
				
				SELECT causa_falla,
						 desc_causa 
				  INTO :ls_causa_falla,:ls_desc_causa
				  FROM causa_fallas
				 WHERE (causa_falla = :data) ;

				IF Isnull(ls_causa_falla) OR Trim(ls_causa_falla) = '' THEN
					Setnull(ls_causa_falla)
					Setnull(ls_desc_causa)
					Messagebox('Aviso','Causa No Existe , Verifique!')
					Setitem(row,'causa_falla',ls_causa_falla)
					Setitem(row,'desc_causa',ls_desc_causa)
					Return 1
				ELSE
					Setitem(row,'desc_causa',ls_desc_causa)
				END IF
					
				
				
END CHOOSE

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot 
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'causa_falla'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT CAUSA_FALLAS.CAUSA_FALLA AS CODIGO_CAUSA ,'&
								      				 +'CAUSA_FALLAS.DESC_CAUSA AS DESCRIPCION_CAUSA '&
									   				 +'FROM CAUSA_FALLAS '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'causa_falla',lstr_seleccionar.param1[1])
					Setitem(row,'desc_causa',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
			
				
END CHOOSE



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

type tabpage_5 from userobject within tab_1
boolean visible = false
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
boolean enabled = false
long backcolor = 79741120
string text = "Riegos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "Destination5!"
long picturemaskcolor = 536870912
dw_riegos dw_riegos
end type

on tabpage_5.create
this.dw_riegos=create dw_riegos
this.Control[]={this.dw_riegos}
end on

on tabpage_5.destroy
destroy(this.dw_riegos)
end on

type dw_riegos from u_dw_abc within tabpage_5
integer x = 5
integer y = 12
integer width = 2706
integer height = 924
integer taborder = 20
string dataobject = "d_pd_ot_riego_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				
		

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = tab_1.tabpage_1.dw_detail // dw_master
idw_det  = tab_1.tabpage_5.dw_riegos // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;String ls_descripcion

accepttext()

CHOOSE CASE dwo.name
		 CASE 'cod_forma'
				SELECT desc_forma
				  INTO :ls_descripcion
				  FROM forma_aplicacion 
				 WHERE (cod_forma = :data ) ;
				 
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					This.Object.cod_forma  [row] = ls_descripcion
					This.Object.desc_forma [row] = ls_descripcion
		
					Messagebox('Aviso','No Existe Forma Aplicación , Verifique!')
					Return 1
				ELSE
					This.Object.desc_forma  [row] = ls_descripcion
				END IF
				 
		 CASE 'cod_fuente'
				SELECT descripcion
				  INTO :ls_descripcion
				  FROM fuente_agua
				 WHERE (cod_fuente = :data) ;
				 
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					This.object.descripcion [row] = ls_descripcion
					This.object.cod_fuente  [row] = ls_descripcion
					Messagebox('Aviso','No Existe Forma Aplicación , Verifique!')
					Return 1
				ELSE
					This.Object.descripcion [row] = ls_descripcion
				END IF

		 CASE 'motobomba'
			
				SELECT desc_maq
				  INTO :ls_descripcion
				  FROM maquina
				 WHERE (cod_maquina = :data) ;
				
				IF Isnull(ls_descripcion) OR Trim(ls_descripcion) = '' THEN
					SetNull(ls_descripcion)
					This.object.desc_maq  [row] = ls_descripcion
					This.object.motobomba [row] = ls_descripcion
					Messagebox('Aviso','No Existe Maquina , Verifique!')
					Return 1
				ELSE
					This.Object.desc_maq [row] = ls_descripcion
				END IF
				
				 
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_item

IF tab_1.tabpage_1.dw_detail.GetRow() > 0 THEN
	ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [idw_mst.il_row]
	This.object.nro_item [al_row]	 = ll_item
END IF

end event

event doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot 
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_forma'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT FORMA_APLICACION.COD_FORMA AS CODIGO_FORMA ,'&
								      				 +'FORMA_APLICACION.DESC_FORMA AS DESCRIPCION_FORMA '&
									   				 +'FROM FORMA_APLICACION '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_forma',lstr_seleccionar.param1[1])
					Setitem(row,'desc_forma',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
				
		 CASE 'cod_fuente'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT FUENTE_AGUA.COD_FUENTE AS CODIGO_FUENTE ,'&
								      				 +'FUENTE_AGUA.DESCRIPCION AS DESCRIPCION_FUENTE '&
									   				 +'FROM FUENTE_AGUA '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_fuente',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF				
				
		 CASE 'motobomba'
			
		
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO_MAQ ,'&
								      				 +'MAQUINA.DESC_MAQ    AS DESCRIPCION_MAQUINA '&
									   				 +'FROM MAQUINA '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'motobomba',lstr_seleccionar.param1[1])
					Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF			
				
END CHOOSE
end event

type tabpage_6 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Maquina"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "WebPBWizard!"
long picturemaskcolor = 536870912
dw_maquina dw_maquina
end type

on tabpage_6.create
this.dw_maquina=create dw_maquina
this.Control[]={this.dw_maquina}
end on

on tabpage_6.destroy
destroy(this.dw_maquina)
end on

type dw_maquina from u_dw_abc within tabpage_6
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer width = 3369
integer height = 436
integer taborder = 20
string dataobject = "d_pd_ot_det_maq_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_where, ls_tmp
Long 		ll_i
decimal	ldc_costo_hora
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cod_maquina"
		
		ls_sql = "SELECT COD_MAQUINA AS CODIGO ,"&
  				 + "DESC_MAQ AS DESCRIPCION " &
  				 + "FROM MAQUINA "
				 
				 
		if this.RowCount() > 0 then
			ls_where = "where "
			for ll_i = 1 to this.RowCount()
				
				ls_tmp = this.object.cod_maquina[ll_i]
				
				if ls_tmp = '' or IsNull(ls_tmp) then continue
				ls_where = ls_where + " cod_art <> '" + ls_tmp + "'"
				
				if this.RowCount() > 1 then
					ls_where = ls_where + " and "
				end if
			next
		end if
		
		if ls_where <> '' then
			ls_where = ls_where + "FLAG_ESTADO = '1'"    
		else 
			ls_where = "WHERE FLAG_ESTADO = '1'"    
		end if
		ls_sql = ls_sql + ls_where

		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_maquina[al_row] = ls_codigo
			this.object.desc_maq[al_row] = ls_data
			
			this.ii_update = 1
			
			select costo_X_und
				into :ldc_costo_hora
			from maquina 
			where cod_maquina = :ls_codigo;
			
			if IsNUll(ldc_costo_hora) then ldc_costo_hora = 0
			
			this.object.costo_unit[al_row] = ldc_costo_hora
		end if
		
end choose



end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2		
ii_ck[3] = 3		

idw_mst  = tab_1.tabpage_1.dw_detail  // dw_master
idw_det  = tab_1.tabpage_6.dw_maquina // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long 		ll_count
String 	ls_codigo,ls_desc
Decimal	ldc_costo_hora

This.Accepttext()

choose case lower(dwo.name)
	case 'cod_maquina'
		ls_codigo = this.object.cod_maquina[row]
		
		select count(*) 
			into :ll_count 
		from maquina 
		where cod_maquina = :ls_codigo ;
				
		IF ll_count = 0 THEN
			SetNull(ls_codigo)
			SetNull(ldc_costo_hora)
			This.object.cod_maquina [row] = ls_codigo
			This.object.desc_maq    [row] = ls_codigo
			This.object.costo_unit	[row]	= ldc_costo_hora
			
			Messagebox('Aviso','Codigo de Maquina No Existe ,Verifique!')
			Return 1
		ELSE
			select desc_maq, costo_x_und 
				into :ls_desc, :ldc_costo_hora
			from maquina 
			where cod_maquina = :data ;
					
			if IsNUll(ldc_costo_hora) then ldc_costo_hora = 0
			
			this.object.costo_unit[row] 	= ldc_costo_hora
			This.object.desc_maq [row] 	= ls_desc
		END IF
end choose

end event

event itemerror;call super::itemerror;Return 1
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

event ue_insert_pre;Long 		ll_item
Long 		ll_row
string 	ls_parte

ll_row = idw_mst.GetRow()

if ll_row <= 0 then return

ls_parte = idw_mst.object.nro_parte[ll_row]
ll_item  = Long(idw_mst.object.nro_item[ll_row])

This.object.nro_item [al_row]	 = ll_item
This.object.nro_parte[al_row]  = ls_parte

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

type tabpage_7 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Trab. Destajo"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "CreateLibrary!"
long picturemaskcolor = 536870912
dw_destajo dw_destajo
end type

on tabpage_7.create
this.dw_destajo=create dw_destajo
this.Control[]={this.dw_destajo}
end on

on tabpage_7.destroy
destroy(this.dw_destajo)
end on

type dw_destajo from u_dw_abc within tabpage_7
event ue_display ( string as_columna,  long al_row )
integer width = 3360
integer height = 696
integer taborder = 20
string dataobject = "d_pr_pd_ot_asis_dstjo"
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_unid, ls_flag_terminado, ls_oper_sec
String	ls_cod_soles, ls_cod_moneda, ls_cod_labor
Decimal	ldc_precio_unit
DateTime	ldt_fecha
Long		ll_row_det
u_dw_abc	ldw_detail
str_seleccionar lstr_seleccionar

ldw_detail = tab_1.tabpage_1.dw_detail

choose case upper(as_columna)
		
	case "COD_TRABAJADOR"
		
		ls_sql = "SELECT COD_TRABAJADOR AS CODIGO, " &
				  + "NOM_TRABAJADOR AS DESCRIPCION " &
				  + "FROM vw_pr_trabajador " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador[al_row] = ls_codigo
			this.object.nom_trabajador[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "LINEA_DESTAJO"
		
		ll_row_det 		= ldw_detail.GetRow()
		if ll_row_det 	= 0 then return
		ls_cod_labor 	= ldw_detail.object.cod_labor[ll_row_det]
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('PRODUCCION', 'CODIGO DE LABOR NO ESTA DEFINIDO',StopSign!)
			return 
		end if
		
		ls_sql = "SELECT LINEA_DESTAJO AS CODIGO, " &
				  + "DESCR_LINEA AS DESCRIPCION , " &
				  + "UNIDAD_DESTAJO AS UNIDAD " &
				  + "FROM DE_LINEAS " &
				  + "WHERE FLAG_ESTADO = '1'" &
				  + "AND COD_LABOR = '" + ls_cod_labor + "'"
				 
		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
					ls_data, ls_unid, '2')
		
		if ls_codigo <> '' then
			this.object.linea_destajo[al_row]   = ls_codigo
			this.object.desc_linea[al_row] 		= ls_data
			this.object.unidad_destajo[al_row]  = ls_unid
			this.ii_update = 1
			
			
			ls_flag_terminado = ldw_detail.object.flag_terminado[ll_row_det]
			ls_oper_sec			= ldw_detail.object.oper_sec[ll_row_det]
			if IsNull(ls_flag_terminado) then 
				ls_flag_terminado = '0'
				ldw_detail.object.flag_terminado[ll_row_det] = '0'
				ldw_detail.ii_update = 1
			end if
			
			
			if ls_flag_terminado = '0' then
				
				// El precio siempre esta en soles
				select cod_soles
					into :ls_cod_soles
				from logparam
				where reckey = '1';
				
				select precio_unit, cod_moneda
					into :ldc_precio_unit, :ls_cod_moneda
				from de_lineas
				where linea_destajo = :ls_codigo;
				
				if IsNull(ldc_precio_unit) then 
					ldc_precio_unit = 0
				else
					ldt_fecha = DateTime( Today(), Now() )
					
					select usf_fl_conv_mon( :ldc_precio_unit, 
							:ls_cod_moneda, :ls_cod_soles, :ldt_fecha)
						into :ldc_precio_unit
					from dual;
					
				end if
				
				If IsNull(ldc_precio_unit) then ldc_precio_unit = 0
				
				this.object.precio_unit[al_row] = ldc_precio_unit
				
			else
				
				select costo_unit
					into :ldc_precio_unit
				from operaciones
				where oper_sec = :ls_codigo;
				
				if IsNull(ldc_precio_unit) then ldc_precio_unit = 0
				
				this.object.precio_unit[al_row] = ldc_precio_unit

			end if

		end if

end choose
end event

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event ue_insert_pre;call super::ue_insert_pre;string 	ls_parte, ls_desc_linea, ls_cod_linea, ls_unidad
long 		ll_item, ll_row
decimal	ldc_precio_unit
u_dw_abc	ldw_detail

ldw_detail 	= tab_1.tabpage_1.dw_detail
ll_row 		= ldw_detail.GetRow()
if ll_row <= 0 then return

ls_parte = ldw_detail.object.nro_parte[ll_row]
ll_item	= Long(ldw_detail.object.nro_item[ll_row])

this.object.cant_destajada[al_row] = 0.00
this.object.nro_parte[al_row]		  = ls_parte
this.object.nro_item[al_row]		  = ll_item

if al_row > 1 then
	ldc_precio_unit = this.object.precio_unit[al_row - 1]
	ls_unidad		 = this.object.unidad_destajo[al_row - 1]
	ls_cod_linea	 = this.object.linea_destajo[al_row - 1]
	ls_desc_linea	 = this.object.desc_linea[al_row - 1]
	
	this.object.desc_linea[al_row] 		= ls_desc_linea
	this.object.linea_destajo[al_row] 	= ls_cod_linea
	this.object.unidad_destajo[al_row] 	= ls_unidad
	this.object.precio_unit[al_row]		= ldc_precio_unit
	
end if
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event itemerror;call super::itemerror;return 1
end event

event itemchanged;call super::itemchanged;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_unid, ls_flag_terminado, ls_oper_sec
String	ls_cod_soles, ls_cod_moneda, ls_cod_labor
Decimal	ldc_precio_unit
DateTime	ldt_fecha
Long		ll_row_det
u_dw_abc	ldw_detail
this.AcceptText()

if row <= 0 then
	return
end if

ldw_detail = tab_1.tabpage_1.dw_detail

choose case upper(dwo.name)
		
	case "COD_TRABAJADOR"
		ls_codigo = this.object.cod_trabajador[row]

		SetNull(ls_data)
		SELECT NOM_TRABAJADOR
			INTO :ls_data
	  	FROM vw_pr_trabajador
		WHERE cod_trabajador = :ls_codigo;
		
		if ls_data = '' or IsNull(ls_data) then
			MessageBox('PRODUCCION', 'CODIGO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO',StopSign!)
			SetNull(ls_data)
			this.object.cod_trabajador[row] = ls_data
			this.object.nom_trabajador[row] = ls_data
			Return 1
		end if
		
		this.object.nom_trabajador[row]	= ls_data
				 
	case "LINEA_DESTAJO"
		
		ll_row_det 		= ldw_detail.GetRow()
		if ll_row_det 	= 0 then return
		ls_cod_labor 	= ldw_detail.object.cod_labor[ll_row_det]
		if ls_cod_labor = '' or IsNull(ls_cod_labor) then
			MessageBox('PRODUCCION', 'CODIGO DE LABOR NO ESTA DEFINIDO',StopSign!)
			return 
		end if

		ls_codigo = this.object.linea_destajo[row]

		SetNull(ls_data)
		SELECT DESCR_LINEA, UNIDAD_DESTAJO
			into :ls_data, :ls_unid
		FROM DE_LINEAS 
	  	WHERE linea_destajo 	= :ls_codigo
		  AND FLAG_ESTADO 	= '1'
		  AND COD_LABOR 		= :ls_cod_labor ;

		if ls_data = '' or IsNull(ls_data) then
			MessageBox('PRODUCCION', "LINEA DE DESTAJO NO EXISTE, NO ESTA ACTIVA O NO CORRESPONDE A LA LABOR: '"&
				+ ls_cod_labor + "'",StopSign!)
			SetNull(ls_data)
			this.object.linea_destajo[row] 	= ls_data
			this.object.desc_linea[row] 		= ls_data
			this.object.unidad_destajo[row] 	= ls_data
	
			SetNull(ldc_precio_unit)
			this.object.precio_unit[row] 		= ldc_precio_unit
			
			return 1
		end if
				 
		
		this.object.desc_linea[row] 		= ls_data
		this.object.unidad_destajo[row]  = ls_unid
			
		ls_flag_terminado = ldw_detail.object.flag_terminado[ll_row_det]
		ls_oper_sec			= ldw_detail.object.oper_sec[ll_row_det]
		
		if IsNull(ls_flag_terminado) then 
			ls_flag_terminado = '0'
			ldw_detail.object.flag_terminado[ll_row_det] = '0'
			ldw_detail.ii_update = 1
		end if
			
			
		if ls_flag_terminado = '0' then
				
			select cod_dolares
				into :ls_cod_soles
			from logparam
			where reckey = '1';
				
			select precio_unit, cod_moneda
				into :ldc_precio_unit, :ls_cod_moneda
			from de_lineas
			where linea_destajo = :ls_codigo;
				
			if IsNull(ldc_precio_unit) then 
				ldc_precio_unit = 0
			else
				ldt_fecha = DateTime( Today(), Now() )
				
				select usf_fl_conv_mon( :ldc_precio_unit, :ls_cod_moneda, 
						:ls_cod_soles, :ldt_fecha)
					into :ldc_precio_unit
				from dual;
					
			end if
				
			If IsNull(ldc_precio_unit) then ldc_precio_unit = 0
				
			this.object.precio_unit[row] = ldc_precio_unit
				
		else
				
			select costo_unit
				into :ldc_precio_unit
			from operaciones
			where oper_sec = :ls_codigo;
				
			if IsNull(ldc_precio_unit) then ldc_precio_unit = 0
				
			this.object.precio_unit[row] = ldc_precio_unit

		end if

end choose
end event

type tabpage_8 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3378
integer height = 740
long backcolor = 79741120
string text = "Producto "
long tabtextcolor = 8388608
long tabbackcolor = 79741120
string picturename = "CrossTab!"
long picturemaskcolor = 536870912
dw_atributos dw_atributos
dw_atrdis dw_atrdis
dw_prodfin dw_prodfin
end type

on tabpage_8.create
this.dw_atributos=create dw_atributos
this.dw_atrdis=create dw_atrdis
this.dw_prodfin=create dw_prodfin
this.Control[]={this.dw_atributos,&
this.dw_atrdis,&
this.dw_prodfin}
end on

on tabpage_8.destroy
destroy(this.dw_atributos)
destroy(this.dw_atrdis)
destroy(this.dw_prodfin)
end on

type dw_atributos from u_dw_abc within tabpage_8
event ue_display ( string as_columna,  long al_row )
integer x = 2505
integer y = 324
integer width = 850
integer height = 416
integer taborder = 20
string dataobject = "d_pd_ot_prod_final_atrib_lbl"
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_tmp
String   ls_name ,ls_prot , ls_cod_art, ls_where
Decimal 	ld_costo_insumo
long		ll_row, ll_i
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "atributo"
		
		ls_cod_art = this.object.cod_art[al_row]
		
		ls_sql = "SELECT ATRIBUTO AS CODIGO, " &
				  + "DESCRIPCION AS DESCR_ATRIBUTO, " &
				  + "UND AS UNIDAD " &
				  + "FROM vw_pr_atrib_articulo "
				  
		if this.RowCount() > 0 then
			ls_where = "where "
			for ll_i = 1 to this.RowCount()
				ls_tmp = this.object.atributo[ll_i]
				if ls_tmp = '' or IsNull(ls_tmp) then continue
				ls_where = ls_where + " atributo <> '" + ls_tmp + "'"
				
				if this.RowCount() > 1 then
					ls_where = ls_where + " and "
				end if
			next
		end if
		
		if ls_where <> '' then
			ls_where = ls_where + "COD_ART = '" + ls_cod_art + "'"    
		else 
			ls_where = "WHERE COD_ART = '" + ls_cod_art + "'"    
		end if
		ls_sql = ls_sql + ls_where

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
					ls_data, ls_und, '2')
		
		if ls_codigo <> '' then
			this.object.atributo[al_row] 		 = ls_codigo
			this.object.desc_atributo[al_row] = ls_data
			this.object.und[al_row] 			 = ls_und
			this.object.nro_lectura[al_row]   = wf_lect_atributo(ls_codigo)
			this.Setcolumn('lectura')
			this.ii_update = 1
		end if		

end choose
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event itemerror;call super::itemerror;return 1
end event

event ue_insert_pre;call super::ue_insert_pre;long ll_row
string ls_parte, ls_articulo
long	 ll_item

ll_row = dw_prodfin.GetRow()

ls_parte 	= dw_prodfin.object.nro_parte[ll_row]
ls_articulo = dw_prodfin.object.cod_art[ll_row]
ll_item     = long(dw_prodfin.object.nro_item[ll_row])

this.object.nro_parte[al_row] = ls_parte
this.object.nro_item[al_row]	= ll_item
this.object.cod_art[al_row]	= ls_articulo
this.object.lectura[al_row]   = 0.00

end event

event ue_insert;long ll_row

ll_row = dw_prodfin.GetRow()

if ll_row <= 0 then
	MessageBox('PRODUCCION', 'NO EXISTE REGISTRO DE PRODUCTO FINAL, POR FAVOR VERIFIQUE',StopSign!)
	return -1
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

event itemchanged;call super::itemchanged;string  ls_codigo, ls_data, ls_articulo, ls_und
decimal ldc_lectura
integer li_nro_lect 

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "ATRIBUTO"
		
		ls_codigo = this.object.atributo[row]
		ls_articulo = this.object.cod_art[row]

		SetNull(ls_data)
		select descripcion, und
			into :ls_data, :ls_und
		from vw_pr_atrib_articulo
		where atributo = :ls_codigo
		  and cod_art = :ls_articulo;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('PRODUCCION', "ATRIBUTO NO CORRESPONE AL ARTICULO", StopSign!)
			SetNull(ls_codigo)
			SetNull(ldc_lectura)
			SetNull(li_nro_lect)
			this.object.atributo[row]      = ls_codigo
			this.object.desc_atributo[row] = ls_codigo
			this.object.und[row] 			 = ls_codigo
			this.object.nro_lectura[row]   = li_nro_lect
			this.object.lectura[row]       = ldc_lectura
			return 1
		end if

		this.object.desc_atributo[row] = ls_data
		this.object.und[row] 			 = ls_und
		this.object.nro_lectura        = wf_lect_atributo(ls_codigo)
		
end choose
end event

event dragleave;call super::dragleave;if source = dw_atrdis then
	source.DragIcon = "Error!"
end if
end event

event dragenter;call super::dragenter;if source = dw_atrdis then
	source.DragIcon = "Menu5!"
end if
end event

event dragdrop;call super::dragdrop;Long 		ll_i, ll_row
string 	ls_atributo, ls_und, ls_desc
u_dw_abc ldw_1

ll_row = dw_prodfin.GetRow()

if ll_row <= 0 then 
	MessageBox('PRODUCCION', 'NO EXISTE REGISTRO DE PRODUCTO FINAL, VERIFIQUE',StopSign!)
	return
end if

if source = dw_atrdis then
	
	ldw_1 = source
	this.SetRedraw(false)
	
	for ll_i = 1 to ldw_1.RowCount()
		If ldw_1.IsSelected(ll_i) then

			ls_atributo	= ldw_1.object.atributo[ll_i]
			ls_desc		= ldw_1.object.desc_atributo[ll_i]
			ls_und		= ldw_1.object.und[ll_i]
			
			
			if ls_atributo = ''  or IsNull(ls_atributo) then
				exit
			end if
			if ls_desc = ''  or IsNull(ls_desc) then
				exit
			end if
			if ls_und = ''  or IsNull(ls_und) then
				exit
			end if
			
			ll_row = this.event ue_insert()
			if ll_row <> -1 then
				this.object.atributo[ll_row] 		 = ls_atributo
				this.object.desc_atributo[ll_row] = ls_desc
				this.object.und[ll_row] 			 = ls_und
				this.object.nro_lectura[ll_row]  = wf_lect_atributo(ls_atributo)
			end if
		end if
	next
	this.SetRedraw(true)
	this.ii_update = 1
end if
end event

type dw_atrdis from u_dw_abc within tabpage_8
integer x = 9
integer y = 324
integer width = 2487
integer height = 416
integer taborder = 20
string dragicon = "Menu5!"
string dataobject = "d_atrib_articulo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event clicked;call super::clicked;if this.RowCount() > 0 then
	this.Drag(begin!)
else
	this.Drag(Cancel!)
end if
end event

event dragleave;call super::dragleave;if source = dw_atrdis then
	source.DragIcon = "Error!"
end if
end event

event dragenter;call super::dragenter;if source = dw_atrdis then
	source.DragIcon = "Menu5!"
end if
end event

type dw_prodfin from u_dw_abc within tabpage_8
event ue_display ( string as_columna,  long al_row )
integer width = 3355
integer height = 324
integer taborder = 20
string dataobject = "d_pd_ot_prod_final_tbl"
boolean vscrollbar = true
end type

event ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_und, ls_tmp
String   ls_name ,ls_prot ,ls_cod_labor, ls_cod_art, ls_where
Decimal 	ld_costo_insumo
long		ll_row, ll_i
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "cod_art"
		
		ls_sql = "SELECT COD_ART AS CODIGO, " &
				 + "NOM_ARTICULO AS DESCRIPCION, " &
				 + "UND AS UNIDAD " &
				 + "FROM vw_pr_prod_fin " 
				 
		if this.RowCount() > 0 then
			ls_where = "where "
			for ll_i = 1 to this.RowCount()
				ls_tmp = this.object.cod_art[ll_i]
				if ls_tmp = '' or IsNull(ls_tmp) then continue
				ls_where = ls_where + " cod_art <> '" + ls_tmp + "'"
				
				if this.RowCount() > 1 then
					ls_where = ls_where + " and "
				end if
			next
		end if
		
		if ls_where <> '' then
			ls_where = ls_where + "FLAG_ESTADO = '1'"
		else 
			ls_where = "WHERE FLAG_ESTADO = '1'"
		end if
		ls_sql = ls_sql + ls_where

		lb_ret = f_lista_3ret(ls_sql, ls_codigo, &
					ls_data, ls_und, '2')

		if ls_codigo <> '' then
			this.object.cod_art[al_row] = ls_codigo
			this.object.nom_articulo[al_row] = ls_data
			this.object.und[al_row] = ls_und
			This.SetSort("und A, cod_art A")
			This.Sort()
			this.ii_update = 1
		end if
		
end choose
end event

event itemerror;call super::itemerror;return 1
end event

event getfocus;call super::getfocus;//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;call super::ue_insert_pre;string ls_parte
long ll_item, ll_row

ll_row = tab_1.tabpage_1.dw_detail.GetRow()
if ll_row <= 0 then return

ls_parte = tab_1.tabpage_1.dw_detail.object.nro_parte[ll_row]
ll_item	= Long(tab_1.tabpage_1.dw_detail.object.nro_item[ll_row])

this.object.cantidad[al_row] 	= 0.00
this.object.nro_parte[al_row]	= ls_parte
this.object.nro_item[al_row]	= ll_item
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

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event rowfocuschanged;call super::rowfocuschanged;IF ii_ss = 1 THEN		        // solo para seleccion individual			
	il_row = Currentrow              // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(CurrentRow, True)
	THIS.SetRow(CurrentRow)
//	THIS.Event ue_output(CurrentRow)
//	RETURN
END IF
end event

event ue_output;call super::ue_output;if al_row <= 0 then return

string ls_articulo
long   ll_item
string ls_parte

ls_articulo = this.object.cod_art[al_row]
ls_parte    = this.object.nro_parte[al_row]
ll_item	   = long(this.object.nro_item[al_row])

dw_atrdis.Retrieve(ls_articulo)
dw_atributos.Retrieve(ls_parte, ll_item, ls_articulo)
end event

event ue_delete;long ll_row 

ib_insert_mode = False

dw_atributos.event ue_delete_all()

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

type dw_master from u_dw_abc within w_pr304_parte_diario
event ue_display ( string as_columna,  long al_row )
integer x = 18
integer y = 84
integer width = 3401
integer height = 232
string dataobject = "d_pr_ot_ff"
end type

event ue_display(string as_columna, long al_row);//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//str_seleccionar lstr_seleccionar
//DataWindow ldw_1
//
//choose case lower(as_columna)
//	CASE 'ot_adm'
//		
//		ls_sql = 'SELECT OT_ADM AS CODIGO, '&   
//				 + 'DESCRIPCION  AS DESCR_OT_ADM  '&   
//				 + 'FROM  VW_CAM_USR_ADM '&
//				 + 'WHERE COD_USR = '+"'"+gs_user+"'"    	
//		
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.ot_adm[al_row]	 	  = ls_codigo
//			this.object.descripcion[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	CASE 'turno'
//		
//		ls_sql = 'SELECT TURNO AS CODIGO, '&   
//				 + 'DESCRIPCION  AS DESCR_TURNO  '&   
//				 + 'FROM  TURNO '&
//				 + "WHERE FLAG_ESTADO = '1'"
//		
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.turno[al_row]	 	 = ls_codigo
//			this.object.desc_turno[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	CASE 'cod_supervisor'
//		ls_sql = 'SELECT COD_TRABAJADOR AS CODIGO ,'&
//				 + 'NOM_TRABAJADOR AS NOMBRE '&
//				 + 'FROM vw_pr_trabajador '
//		
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.cod_supervisor[al_row] = ls_codigo
//			this.object.nom_supervisor[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	CASE 'cod_administrador'
//		ls_sql = 'SELECT COD_TRABAJADOR AS CODIGO ,'&
//				 + 'NOM_TRABAJADOR AS NOMBRE '&
//				 + 'FROM vw_pr_trabajador '
//		
//		lb_ret = f_lista(ls_sql, ls_codigo, &
//					ls_data, '2')
//		
//		if ls_codigo <> '' then
//			this.object.cod_administrador[al_row] = ls_codigo
//			this.object.nom_administrador[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	CASE 'fecha'
//				
//		ldw_1 = This
//		f_call_calendar(ldw_1, as_columna, &
//				this.object.fecha.coltype, al_row)
//		ii_update =1
//		
//end choose
//
//
end event

event constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo,ls_descripcion
Accepttext()


CHOOSE CASE dwo.name
		 CASE	'ot_adm'
				SELECT Count(*)
				  INTO :ll_count
				  FROM ot_adm_usuario
				 WHERE (ot_adm  = :data    ) AND
				 		 (cod_usr = :gs_user ) ;
				 
			   IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.ot_adm      [row] = ls_codigo
					This.object.descripcion [row] = ls_codigo
					Messagebox('Aviso','No Existe esa Administracion para este Usuario')
					Return 1
				ELSE
					SELECT descripcion INTO :ls_descripcion FROM ot_administracion WHERE (ot_adm = :data);
					
					This.object.descripcion [row] = ls_descripcion
				END IF
				 
				 
		 CASE 'cod_supervisor'
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM maestro
				 WHERE (cod_trabajador = :data) ;
				 
				 IF ll_count = 0 THEN
					 SetNull(ls_codigo)
					 SetNull(ls_descripcion)
					 Messagebox('Aviso','Codigo de Supervisor No Existe ,Verifique !')			
 					 //Asignación de Valores
					 This.Object.cod_supervisor [row] = ls_codigo
				 	 This.Object.nom_supervisor [row] = ls_descripcion	


					 Return 1
				 ELSE
					 ls_codigo = data 
					 
					 SELECT rtrim(ltrim(NOMBRE1))||' '||rtrim(ltrim(APEL_PATERNO))||' '||rtrim(ltrim(APEL_MATERNO))
					   INTO :ls_descripcion
						FROM maestro
					  WHERE (cod_trabajador = :data) ;
					  
					 //Asignación de Valores
					 This.Object.cod_supervisor [row] = ls_codigo
				 	 This.Object.nom_supervisor [row] = ls_descripcion	

					 Return 2 
				 END IF
	 				 
				 
		 CASE 'cod_administrador'		
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM maestro
				 WHERE (cod_trabajador = :data) ;
				 
				 IF ll_count = 0 THEN
					 SetNull(ls_codigo)
					 SetNull(ls_descripcion)
					 Messagebox('Aviso','Codigo de Supervisor No Existe ,Verifique !')			
 					 //Asignación de Valores
					 This.Object.cod_administrador [row] = ls_codigo
				 	 This.Object.nom_administrador [row] = ls_descripcion	
					 Return 1
				 ELSE
					 ls_codigo = data 
					 
					 SELECT rtrim(ltrim(NOMBRE1))||' '||rtrim(ltrim(APEL_PATERNO))||' '||rtrim(ltrim(APEL_MATERNO))
					   INTO :ls_descripcion
						FROM maestro
					  WHERE (cod_trabajador = :data) ;
					  
					 //Asignación de Valores
					 This.Object.cod_administrador [row] = ls_codigo
				 	 This.Object.nom_administrador [row] = ls_descripcion	

					 Return 2 
				 END IF
	 				 
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event ue_insert_pre;call super::ue_insert_pre;//This.Object.fecha [al_row] = today()
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
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

event doubleclicked;call super::doubleclicked;//string ls_columna
//long ll_row 
//str_seleccionar lstr_seleccionar
//
//this.AcceptText()
//If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
//ll_row = row
//
//if row > 0 then
//	ls_columna = upper(dwo.name)
//	this.event dynamic ue_display(ls_columna, ll_row)
//end if
end event

type em_nro_parte from editmask within w_pr304_parte_diario
event ue_keydown pbm_keydown
integer x = 3013
integer width = 393
integer height = 76
integer taborder = 50
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
alignment alignment = center!
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "!!##########"
end type

event ue_keydown;IF key = KeyEnter! THEN
	parent.event ue_query_retrieve()
END IF
end event

