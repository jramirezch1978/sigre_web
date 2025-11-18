$PBExportHeader$w_ope305_parte_ot.srw
forward
global type w_ope305_parte_ot from w_abc
end type
type cb_1 from commandbutton within w_ope305_parte_ot
end type
type st_1 from statictext within w_ope305_parte_ot
end type
type sle_parte from singlelineedit within w_ope305_parte_ot
end type
type dw_operaciones from u_dw_abc within w_ope305_parte_ot
end type
type tab_1 from tab within w_ope305_parte_ot
end type
type tabpage_1 from userobject within tab_1
end type
type st_campo from statictext within tabpage_1
end type
type dw_find from datawindow within tabpage_1
end type
type dw_lista from u_dw_list_tbl within tabpage_1
end type
type dw_detart from u_dw_abc within tabpage_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
st_campo st_campo
dw_find dw_find
dw_lista dw_lista
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
type cb_2 from commandbutton within tabpage_3
end type
type dw_detasis from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
cb_2 cb_2
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
type tab_1 from tab within w_ope305_parte_ot
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type
type dw_master from u_dw_abc within w_ope305_parte_ot
end type
type r_1 from rectangle within w_ope305_parte_ot
end type
end forward

global type w_ope305_parte_ot from w_abc
integer width = 3570
integer height = 2232
string title = "Parte  Diario de Orden de Trabajo (OPE305)"
string menuname = "m_master_lista"
boolean resizable = false
cb_1 cb_1
st_1 st_1
sle_parte sle_parte
dw_operaciones dw_operaciones
tab_1 tab_1
dw_master dw_master
r_1 r_1
end type
global w_ope305_parte_ot w_ope305_parte_ot

type variables
String  is_accion,is_col,is_data_type
String  is_tabla_1    ,is_tabla_2    ,is_tabla_3    ,is_tabla_4    ,is_tabla_5    ,is_tabla_6    ,&
		  is_colname_1[],is_colname_2[],is_colname_3[],is_colname_4[],is_colname_5[],is_colname_6[],&
		  is_coltype_1[],is_coltype_2[],is_coltype_3[],is_coltype_4[],is_coltype_5[],is_coltype_6[]

n_cst_log_diario	in_log

end variables

forward prototypes
public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje)
public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, string as_oper_sec, long al_item)
public subroutine wf_retrieve_operaciones (string as_nro_doc, string as_cod_labor, string as_cod_ejecutor)
public subroutine wf_retrieve (string as_nro_parte)
public subroutine wf_filter_dws (long al_item)
public subroutine wf_act_cant_costo_labor ()
public subroutine wf_verifica_parte (string as_nro_parte, long al_nro_item, string as_oper_sec, ref string as_flag_estado)
public function string wf_insert_oper_sec (string as_nro_orden, string as_cod_labor, string as_cod_ejecutor, string as_proveedor, datetime adt_fec_inicio, datetime adt_fec_final, decimal adc_cant_avance, string as_und_avance, decimal adc_cant_labor, string as_obs, string as_desc_labor, decimal adc_costo_labor)
end prototypes

public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje);Boolean lb_retorno =TRUE
Long ll_nro_ot
String ls_lock_table

ls_lock_table = 'LOCK TABLE NUM_PD_OT IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;

SELECT ult_nro
  INTO :al_nro_ot
  FROM num_pd_ot
 WHERE (reckey = '1') ;

	
	
IF Isnull(al_nro_ot) OR al_nro_ot = 0 THEN
	lb_retorno = FALSE
	as_mensaje = 'Numerador Para Parte Diario de OT debe Empezar en 1 Verifique Tabla de Numeración NUM_PD_OT '
	GOTO SALIDA
END IF

//****************************//
//Actualiza Tabla num_doc_tipo//
//****************************//
	
UPDATE num_pd_ot
	SET ult_nro = :al_nro_ot + 1
 WHERE (reckey = '1') ;
	
IF SQLCA.SQLCode = -1 THEN 
	as_mensaje = 'No se Pudo Actualizar Tabla num_pd_ot , Verifique!'
	lb_retorno = FALSE
	GOTO SALIDA
END IF	


SALIDA:

Return lb_retorno

end function

public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, string as_oper_sec, long al_item);String      ls_cod_art,ls_nom_art,ls_und
Decimal {2} ldc_costo_ult_compra
Decimal {4} ldc_cantidad
Long			ll_row


/*limpiar dw*/
tab_1.tabpage_1.dw_detart.Reset()

/*Declaración de Cursor*/
DECLARE art_ope CURSOR FOR
  SELECT am.cod_art         ,
 			(NVL(am.cant_proyect,0) - NVL(am.cant_procesada,0) ) , 
			a.nom_articulo	    ,
			a.und				    ,
			a.costo_prom_dol
  	 FROM articulo_mov_proy am,	
			articulo          a
	WHERE  (am.cod_art  = a.cod_art    ) AND
			 (nvl(am.cant_proyect,0)>nvl(am.cant_procesada,0)) AND
			((am.tipo_doc = :as_tipo_doc ) AND
			 (am.nro_doc  = :as_nro_doc  ) AND
			 (am.oper_sec = :as_oper_sec )) ;
					

/*Abrir Cursor*/		  	
OPEN art_ope ;

	
	DO 				/*Recorro Cursor*/	
	 FETCH art_ope INTO :ls_cod_art, :ldc_cantidad, :ls_nom_art, :ls_und, :ldc_costo_ult_compra;
	 IF sqlca.sqlcode = 100 THEN EXIT
	 /**Inserción de Registros**/ 
	 ll_row = tab_1.tabpage_1.dw_detart.InsertRow(0)
	 
	 tab_1.tabpage_1.dw_detart.ii_update = 1
	 tab_1.tabpage_1.dw_detart.object.nro_item	  [ll_row] = al_item
	 tab_1.tabpage_1.dw_detart.object.cod_art      [ll_row] = ls_cod_art
	 tab_1.tabpage_1.dw_detart.object.cantidad     [ll_row] = ldc_cantidad
	 tab_1.tabpage_1.dw_detart.object.nom_articulo [ll_row] = ls_nom_art
	 tab_1.tabpage_1.dw_detart.object.costo_insumo [ll_row] = ldc_costo_ult_compra
	 tab_1.tabpage_1.dw_detart.object.und			  [ll_row] = ls_und
	 
	 
	LOOP WHILE TRUE
	
CLOSE art_ope ; /*Cierra Cursor*/
end subroutine

public subroutine wf_retrieve_operaciones (string as_nro_doc, string as_cod_labor, string as_cod_ejecutor);String ls_doc_ot

IF Isnull(as_cod_labor) OR Trim(as_cod_labor) = '' THEN
	IF Isnull(as_nro_doc) then 
		Setnull(as_cod_labor)
	ELSE
		as_cod_labor = '%'
	END IF
ELSE
	as_cod_labor = as_cod_labor + '%'
END IF

IF Isnull(as_cod_ejecutor) OR Trim(as_cod_ejecutor) = '' THEN
	IF Isnull(as_nro_doc) then 
		Setnull(as_cod_ejecutor)
	ELSE
		as_cod_ejecutor = '%'
	END IF

ELSE
	as_cod_ejecutor = as_cod_ejecutor + '%'
END IF

// Recupero operaciones
dw_operaciones.Retrieve(as_nro_doc, as_cod_labor, as_cod_ejecutor)

end subroutine

public subroutine wf_retrieve (string as_nro_parte);/*****************************************/
/*      Recuperacion de Información      */
/*****************************************/
Long   ll_item
String ls_tdoc,ls_ndoc,ls_labor,ls_ejecutor

dw_master.Retrieve(as_nro_parte)

tab_1.tabpage_1.dw_detail.Retrieve(as_nro_parte)
//
tab_1.tabpage_1.dw_detart.Retrieve(as_nro_parte)
tab_1.tabpage_2.dw_detinc.Retrieve(as_nro_parte)
tab_1.tabpage_3.dw_detasis.Retrieve(as_nro_parte)
tab_1.tabpage_4.dw_causas.Retrieve(as_nro_parte)
tab_1.tabpage_5.dw_riegos.Retrieve(as_nro_parte)
tab_1.tabpage_6.dw_maquina.Retrieve(as_nro_parte)

/**/
dw_master.il_row = 1

IF tab_1.tabpage_1.dw_detail.Rowcount() > 0 THEN
	/*Primer Registro*/
	
	ll_item  	= tab_1.tabpage_1.dw_detail.Object.nro_item     [1]
	ls_ndoc  	= tab_1.tabpage_1.dw_detail.Object.nro_orden		[1]
	ls_labor 	= tab_1.tabpage_1.dw_detail.Object.cod_labor		[1]
	ls_ejecutor = tab_1.tabpage_1.dw_detail.Object.cod_ejecutor [1]
	wf_filter_dws (ll_item)
	wf_retrieve_operaciones (ls_ndoc,ls_labor,ls_ejecutor)

	
END IF

dw_master.Setfocus()
end subroutine

public subroutine wf_filter_dws (long al_item);String ls_expresion
	

ls_expresion = 'nro_item = '+Trim(String(al_item))

IF Not(Isnull(ls_expresion) OR Trim(ls_expresion) = '') THEN
	tab_1.tabpage_1.dw_detart.Setfilter(ls_expresion)
	tab_1.tabpage_2.dw_detinc.Setfilter(ls_expresion)
	tab_1.tabpage_3.dw_detasis.Setfilter(ls_expresion)
	tab_1.tabpage_4.dw_causas.Setfilter(ls_expresion)
	tab_1.tabpage_5.dw_riegos.Setfilter(ls_expresion)
	tab_1.tabpage_6.dw_maquina.Setfilter(ls_expresion)
	
	
	tab_1.tabpage_1.dw_detart.filter  ()
	tab_1.tabpage_2.dw_detinc.filter  ()
	tab_1.tabpage_3.dw_detasis.filter ()
	tab_1.tabpage_4.dw_causas.filter  ()
	tab_1.tabpage_5.dw_riegos.filter  ()
	tab_1.tabpage_6.dw_maquina.filter ()
	
	
	tab_1.tabpage_1.dw_detail.il_row = tab_1.tabpage_1.dw_detail.getrow() 
END IF

end subroutine

public subroutine wf_act_cant_costo_labor ();Long 			ll_row_det,ll_inicio
Decimal {2} ldc_cant_labor,ldc_cant_tot_hor,ldc_cant_horas
String      ls_und_hr,ls_cod_labor,ls_cod_ejecutor,ls_und,ls_flag_maq_mo
Datetime    ldt_hora_inicio,ldt_hora_fin

//
tab_1.tabpage_1.dw_detail.accepttext()
tab_1.tabpage_3.dw_detasis.accepttext()



//calculo de acuerdo a labor
ll_row_det = tab_1.tabpage_1.dw_detail.Getrow ()

IF ll_row_det = 0 THEN RETURN
//PARAMETRO DE UNIDAD DE HRS
select und_hr into :ls_und_hr from prod_param where reckey = '1' ;
//


ls_cod_labor    = tab_1.tabpage_1.dw_detail.Object.cod_labor    [ll_row_det]
ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.Object.cod_ejecutor [ll_row_det]

SELECT und,flag_maq_mo INTO :ls_und ,:ls_flag_maq_mo FROM labor WHERE cod_labor = :ls_cod_labor ;


//actualizo detalle de item si ha cambiado
ldc_cant_labor  = tab_1.tabpage_1.dw_detail.object.cant_labor    [ll_row_det] //old cantidad

if Isnull(ldc_cant_labor ) then ldc_cant_labor  = 0.00

IF (ls_flag_maq_mo = 'O' AND ls_und = ls_und_hr) THEN //mano de obra y calculado en hrs
	
	ldc_cant_tot_hor = 0.00 //cantidad de hrs
	 
	/*Asistencia x Item*/
 	FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_detasis.Rowcount()
		  /*Costo x hora*/
		  ldc_cant_horas   =	tab_1.tabpage_3.dw_detasis.object.nro_horas  [ll_inicio]
		  
		  IF Isnull(ldc_cant_horas)	 THEN ldc_cant_horas   = 0.00
		  
		  ldc_cant_tot_hor = ldc_cant_tot_hor + ldc_cant_horas
		  
		  IF Isnull(ldc_cant_tot_hor) THEN ldc_cant_tot_hor = 0.00
		  
	 NEXT
	 
	 
	 IF ldc_cant_tot_hor <> ldc_cant_labor THEN //cant total x hora
		 tab_1.tabpage_1.dw_detail.object.cant_labor [ll_row_det] = ldc_cant_tot_hor 
		 tab_1.tabpage_1.dw_detail.ii_update = 1		
	 END IF
	 
ELSEIF (ls_flag_maq_mo = 'M' AND ls_und = ls_und_hr) THEN //LABOR MECANIZADA Y UNIDAD SEA HRS	 
	 //detalle del item	
	 ldt_hora_inicio = tab_1.tabpage_1.dw_detail.object.hora_inicio [ll_row_det]
	 ldt_hora_fin    = tab_1.tabpage_1.dw_detail.object.hora_fin    [ll_row_det]
	 
	 //diferencias de labor
	 select usf_cam_diastime_a_horas(:ldt_hora_fin,:ldt_hora_inicio) into :ldc_cant_tot_hor from dual ;
	 
	 
	 if Isnull(ldc_cant_tot_hor) then ldc_cant_tot_hor = 0.00


	IF ldc_cant_labor <> ldc_cant_tot_hor THEN
		tab_1.tabpage_1.dw_detail.object.cant_labor [ll_row_det] = ldc_cant_tot_hor //new cantidad		
		tab_1.tabpage_1.dw_detail.ii_update = 1
	END IF	 
	
ELSEIF (ls_und <> ls_und_hr ) THEN //SI LA UNIDAD DE LA LABOR ES DIFERENTE LA HRS
	//no va ...	
END IF	


end subroutine

public subroutine wf_verifica_parte (string as_nro_parte, long al_nro_item, string as_oper_sec, ref string as_flag_estado);String ls_new_parte,ls_new_item


DECLARE PB_USP_OPE_VER_ESTADO_OPER_SEC PROCEDURE FOR USP_OPE_VER_ESTADO_OPER_SEC 
(:as_nro_parte,:al_nro_item,:as_oper_sec);
EXECUTE PB_USP_OPE_VER_ESTADO_OPER_SEC ;



IF SQLCA.SQLCode = -1 THEN 
	MessageBox("SQL error", SQLCA.SQLErrText)
END IF

FETCH PB_USP_OPE_VER_ESTADO_OPER_SEC INTO :ls_new_parte,:ls_new_item,:as_flag_estado ;
CLOSE PB_USP_OPE_VER_ESTADO_OPER_SEC ;


IF as_flag_estado = '1' THEN //OPER SEC YA FUE TERMINADO
	Messagebox('Aviso','Oper sec ya Fue Terminado ,Revise Nro de Parte '+Trim(as_nro_parte)+' Nro de Item '+Trim(ls_new_item))
END IF
end subroutine

public function string wf_insert_oper_sec (string as_nro_orden, string as_cod_labor, string as_cod_ejecutor, string as_proveedor, datetime adt_fec_inicio, datetime adt_fec_final, decimal adc_cant_avance, string as_und_avance, decimal adc_cant_labor, string as_obs, string as_desc_labor, decimal adc_costo_labor);Long   ll_nro_oper
String ls_doc_ot,ls_oper_sec,ls_msj_err,ls_flag_facturacion, ls_ejec_terc

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

select ejecutor_3ro into :ls_ejec_terc from prod_param where reckey='1' ;

if ( (not isnull(as_proveedor)) and (as_cod_ejecutor<>ls_ejec_terc) ) then
	ls_flag_facturacion='F'
else
	ls_flag_facturacion='N'
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
(nro_operacion  ,cod_labor       ,cod_ejecutor   ,proveedor  ,   
 flag_estado    ,desc_operacion  ,fec_inicio_est ,fec_inicio ,
 fec_fin			 ,cant_proyect    ,costo_unit     ,tipo_orden ,
 nro_orden      ,obs             ,avance_esperado,avance_und ,
 oper_sec		 ,flag_facturacion)  
values
(:ll_nro_oper   ,:as_cod_labor  ,:as_cod_ejecutor ,:as_proveedor  ,
 '3'            ,:as_desc_labor ,:adt_fec_inicio  ,:adt_fec_inicio,
 :adt_fec_final ,:adc_cant_labor,:adc_costo_labor ,:ls_doc_ot     ,
 :as_nro_orden  ,:as_obs        ,:adc_cant_avance ,:as_und_avance ,
 :ls_oper_sec	 ,:ls_flag_facturacion)   ;
 

//se dispara grabacion de oper sec
IF SQLCA.SQLCode = -1 THEN 
	ls_msj_err = SQLCA.SQLErrText
	Rollback ;
	SetNull(ls_oper_sec)
   MessageBox('SQL error', ls_msj_err)
ELSE
	Commit ;
END IF


//RECUPERO INFORMACION GRABADA
wf_retrieve_operaciones (as_nro_orden,as_cod_labor,as_cod_ejecutor)

DESTROY lnvo_numeradores_varios


Return ls_oper_sec
end function

on w_ope305_parte_ot.create
int iCurrent
call super::create
if this.MenuName = "m_master_lista" then this.MenuID = create m_master_lista
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_parte=create sle_parte
this.dw_operaciones=create dw_operaciones
this.tab_1=create tab_1
this.dw_master=create dw_master
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.st_1
this.Control[iCurrent+3]=this.sle_parte
this.Control[iCurrent+4]=this.dw_operaciones
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.dw_master
this.Control[iCurrent+7]=this.r_1
end on

on w_ope305_parte_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_parte)
destroy(this.dw_operaciones)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.r_1)
end on

event ue_open_pre;call super::ue_open_pre;Long ll_nro_parte

dw_master.SetTransObject(sqlca)
dw_operaciones.SetTransObject(sqlca)
tab_1.tabpage_1.dw_lista.SetTransObject(sqlca)
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_1.dw_detart.SetTransObject(sqlca)
tab_1.tabpage_2.dw_detinc.SetTransObject(sqlca)
tab_1.tabpage_3.dw_detasis.SetTransObject(sqlca)
tab_1.tabpage_4.dw_causas.SetTransObject(sqlca)
tab_1.tabpage_5.dw_riegos.SetTransObject(sqlca)
tab_1.tabpage_6.dw_maquina.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija

//TriggerEvent('ue_insert')

 
 
//ib_log = TRUE
ib_log = FALSE
is_tabla_1 = 'Cab_parte'
is_tabla_2 = 'Det_parte'
is_tabla_3 = 'Art_parte'
is_tabla_4 = 'Inc_parte'
is_tabla_5 = 'Tra_parte'
is_tabla_6 = 'Cau_parte'


sle_parte.SetFocus()
end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_lista.height   = newheight - tab_1.tabpage_1.dw_lista.y   - 600
tab_1.tabpage_1.dw_detail.width   = newwidth  - tab_1.tabpage_1.dw_detail.x  - 100
tab_1.tabpage_1.dw_detart.width   = newwidth  - tab_1.tabpage_1.dw_detart.x  - 100
tab_1.tabpage_1.dw_detart.height  = newheight - tab_1.tabpage_1.dw_detart.y  - 600
tab_1.tabpage_2.dw_detinc.height  = newheight - tab_1.tabpage_2.dw_detinc.y  - 600
tab_1.tabpage_3.dw_detasis.height = newheight - tab_1.tabpage_3.dw_detasis.y - 600
tab_1.tabpage_4.dw_causas.height  = newheight - tab_1.tabpage_4.dw_causas.y  - 600
tab_1.tabpage_5.dw_riegos.height  = newheight - tab_1.tabpage_5.dw_riegos.y  - 600
tab_1.tabpage_6.dw_maquina.height = newheight - tab_1.tabpage_6.dw_maquina.y - 600
dw_operaciones.width = newwidth - dw_operaciones.x - 10


end event

event ue_insert;Long   ll_row,ll_nro_item
String ls_nro_parte,ls_oper_sec,ls_flag_estado
dwItemStatus ldis_status

CHOOSE CASE idw_1
		 CASE dw_master
				TriggerEvent('ue_update_request')
				is_accion = 'new'
				dw_master.Reset()
				dw_operaciones.Reset()
				tab_1.tabpage_1.dw_detail.Reset()
				tab_1.tabpage_1.dw_detart.Reset()
				tab_1.tabpage_2.dw_detinc.Reset()
				tab_1.tabpage_3.dw_detasis.Reset()
				tab_1.tabpage_4.dw_causas.Reset()
				tab_1.tabpage_5.dw_riegos.Reset()
				
		CASE	tab_1.tabpage_1.dw_detail  //DETALLE DE OT
				
				IF dw_master.getrow() = 0 THEN 
					Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
					RETURN
				END IF	
				
				
		CASE	tab_1.tabpage_1.dw_detart	//DETALLE DE ARTICULOS
				
		CASE	dw_operaciones
				Return
		CASE  tab_1.tabpage_5.dw_riegos
				IF tab_1.tabpage_5.dw_riegos.Rowcount() > 0 THEN
					Messagebox('Aviso','Solamente es Permitido un Riego x Item , Verifique!')
					Return
				END IF
		CASE  tab_1.tabpage_3.dw_detasis
				//asignar nro de parte cuando registro sea nuevo
				ldis_status = tab_1.tabpage_1.dw_detail.GetItemStatus(tab_1.tabpage_1.dw_detail.Getrow(),0,Primary!)
				IF ldis_status <> NewModified! THEN
					ls_nro_parte = tab_1.tabpage_1.dw_detail.object.nro_parte [tab_1.tabpage_1.dw_detail.Getrow()]
					ls_oper_sec  = tab_1.tabpage_1.dw_detail.object.oper_sec  [tab_1.tabpage_1.dw_detail.Getrow()]
					ll_nro_item  = tab_1.tabpage_1.dw_detail.object.nro_item  [tab_1.tabpage_1.dw_detail.Getrow()]
					//control desactivado x lento arojas 26/08/2003
//					wf_verifica_parte (ls_nro_parte,ll_nro_item,ls_oper_sec,ls_flag_estado) 
//					IF ls_flag_estado = '1' THEN RETURN //oper sec fue cerrado
				END IF  
//		CASE  tab_1.tabpage_6.dw_maquina
//				IF tab_1.tabpage_6.dw_maquina.Rowcount() > 0 THEN
//					Messagebox('Aviso','Solamente es Permitido una Maquina x Item , Verifique!')
//					Return
//				END IF				
END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_dw_share();call super::ue_dw_share;tab_1.tabpage_1.dw_lista.of_share_lista(tab_1.tabpage_1.dw_detail)
end event

event ue_update_pre;Long   ll_row_master,ll_row_det_old,ll_item_old,ll_inicio_item,ll_item,ll_inicio,&
	    ll_tiempo    ,ll_i
String ls_mensaje    ,ls_hinicio_inc   ,ls_hfinal_inc ,ls_desc_inc    ,&
		 ls_cod_art    ,ls_cod_incidencia,ls_cod_trab   ,ls_cod_causa   ,&
		 ls_cierre     ,ls_nro_parte     ,ls_cod_labor  ,ls_cod_ejecutor,&
		 ls_nro_orden  ,ls_oper_sec		,ls_cod_maquina,ls_cod_maq_det ,&
		 ls_flag_maq_mo,ls_ejec				,ls_und_labor  ,ls_und_hr
Datetime ldt_finicio,ldt_ffinal
Long     ln_ano, ln_mes
Date     ld_fecha
Decimal {2} ldc_cant_neta, ldc_cant_labor
dwItemStatus ldis_status


//invocar objeto de numeracion de parte
nvo_numeradores_varios lnvo_numeradores_varios
lnvo_numeradores_varios    = CREATE nvo_numeradores_varios
//

select ejecutor_3ro, und_hr 
  into :ls_ejec, :ls_und_hr 
  from prod_param 
 where reckey = '1' ;

IF dw_master.GetRow()=0 THEN Return

ll_row_master = dw_master.GetRow()

if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if


if f_row_Processing( tab_1.tabpage_1.dw_detail, "form") <> true then	
	ib_update_check = False	
	return
else
	ib_update_check = True
end if

IF tab_1.tabpage_1.dw_detart.ii_update > 0 OR tab_1.tabpage_3.dw_detasis.ii_update > 0 THEN
	dw_master.ii_update = 1
END IF

ld_fecha = DATE(dw_master.Object.fecha [ll_row_master])
ln_ano   = year(ld_fecha)
ln_mes   = month(ld_fecha)


//verificacion de mes contable
SELECT USF_CNT_CIERRE_CNTBL(:ln_ano, :ln_mes, 'F') INTO :ls_cierre FROM dual ;

IF ls_cierre = '0' THEN
	Messagebox('Mes contable cerrado','No se puede actualizar datos')
   ib_update_check = False	
	return
END IF

//RECUPERO NRO DE PARTE
ls_nro_parte = dw_master.Object.nro_parte [ll_row_master]

IF is_accion = 'new' THEN
	IF lnvo_numeradores_varios.uf_num_parte(gs_origen,ls_nro_parte) = FALSE THEN
		ib_update_check = False	
		RETURN
//	ELSE
		
	END IF
END IF

dw_master.Object.nro_parte [ll_row_master] = ls_nro_parte
dw_master.ii_update = 1 


/*Fila Detalle old*/
ll_row_det_old = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row_det_old > 0 THEN
   ll_item_old = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row_det_old]
END IF
//

FOR ll_inicio_item = 1 TO tab_1.tabpage_1.dw_detail.Rowcount() //recorre dw detalle de pd_ot


	
	 //asignar nro de parte cuando registro sea nuevo
	 ldis_status = tab_1.tabpage_1.dw_detail.GetItemStatus(ll_inicio_item,0,Primary!)

	 IF ldis_status = NewModified! THEN
		 tab_1.tabpage_1.dw_detail.Object.nro_parte [ll_inicio_item] = ls_nro_parte
	 END IF
	 
	 ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [ll_inicio_item]
	 ldc_cant_labor = tab_1.tabpage_1.dw_detail.object.cant_labor [ll_inicio_item]


	 wf_filter_dws (ll_item)
	 
	 /*verificar que labor y ejecutor sea requerido*/
	 ls_cod_labor    = tab_1.tabpage_1.dw_detail.object.cod_labor    [ll_inicio_item]
	 ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor [ll_inicio_item]
	 ls_nro_orden	  = tab_1.tabpage_1.dw_detail.object.nro_orden    [ll_inicio_item]
	 ls_oper_sec	  = tab_1.tabpage_1.dw_detail.object.oper_sec     [ll_inicio_item]
	 ldc_cant_neta   = tab_1.tabpage_1.dw_detail.object.cant_neta    [ll_inicio_item]
	 ls_cod_maq_det  = tab_1.tabpage_1.dw_detail.object.cod_maquina  [ll_inicio_item]	
	 
	 IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Codigo de Labor')	
		 ib_update_check = False	
		 Return
	 END IF
	 
	 IF Isnull(ls_cod_ejecutor) OR Trim(ls_cod_ejecutor) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Codigo de Ejecutor')	
		 ib_update_check = False	
		 Return
	 END IF
	 
	 
	 IF Isnull(ls_nro_orden) OR Trim(ls_nro_orden) = '' THEN
		 Messagebox('Aviso','Debe Seleccionar Orden de Trabajo')	
		 ib_update_check = False	
		 Return
	 END IF
	 
	 IF Isnull(ls_oper_sec) OR Trim(ls_oper_sec) = '' THEN
		 Messagebox('Aviso','Debe Ingresar Un Oper Sec')	
		 ib_update_check = False	
		 Return
	 END IF
	 
	 //si labor es mecanizada obligar a ingresar codigo de maquina
	 select l.flag_maq_mo,l.und into :ls_flag_maq_mo,:ls_und_labor from labor l where l.cod_labor = :ls_cod_labor ;
	 
	 IF Trim(ls_flag_maq_mo) = 'M' AND ls_cod_ejecutor <> ls_ejec THEN
		 IF Isnull(ls_cod_maq_det) OR Trim(ls_cod_maq_det) = '' THEN
			 Messagebox('Aviso','Debe Ingresar Codigo de Maquina en Detalle del Item Nº'+Trim(String(ll_item))+' , Verifique!')	
			 ib_update_check = False	
			 Return
		 END IF
	 END IF
	 
	 
		 
	 
	 ll_tiempo = 2800

	 if isnull(ldc_cant_neta) then ldc_cant_neta = 0
	 
	 IF Trim(ls_und_labor) = Trim(ls_und_hr) THEN //SOLO CUANDO SEA HORA
		 IF ldc_cant_neta <= 0 THEN
			 openWITHPARM(w_aviso_err,TRIM(string(ll_item)))
		 
			 For ll_i = 1 to ll_tiempo 
				  this.SetMicrohelp( String( ll_i ))
			 End For 
		 
			 CLOSE(W_AVISO_ERR)
		 END IF
	 END IF 

	 /*Detalle de Articulos x Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detart.Rowcount()
		  //asignar nro de parte cuando registro sea nuevo
		  ldis_status = tab_1.tabpage_1.dw_detart.GetItemStatus(ll_inicio,0,Primary!)

	 	  IF ldis_status = NewModified! THEN
		     tab_1.tabpage_1.dw_detart.Object.nro_parte [ll_inicio] = ls_nro_parte
	     END IF
		  
		  ls_cod_art = tab_1.tabpage_1.dw_detart.object.cod_art [ll_inicio]
		  
		  IF Isnull(ls_cod_art) OR Trim(ls_cod_art) = '' THEN
			  
			  tab_1.SelectedTab = 1
  		 	  tab_1.tabpage_1.dw_detart.SetFocus()
		 	  tab_1.tabpage_1.dw_detart.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_1.dw_detart.Setrow(ll_inicio)
		 	  tab_1.tabpage_1.dw_detart.SetColumn('cod_art')
			  /*Posiciona Item en el Detalle*/
		  	  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
		  	  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
		  	  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
		  	  /**/	
			  Messagebox('Aviso','Debe Ingresar Codigo de Articulo')	  					
			  ib_update_check = False	
			  Return					
		  END IF
        
	 NEXT

	 /*Incidencias Por Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_detinc.Rowcount()
		  //asignar nro de parte cuando registro sea nuevo
		  ldis_status = tab_1.tabpage_2.dw_detinc.GetItemStatus(ll_inicio,0,Primary!)

	 	  IF ldis_status = NewModified! THEN
		     tab_1.tabpage_2.dw_detinc.Object.nro_parte [ll_inicio] = ls_nro_parte
	     END IF
		  
		  ls_cod_incidencia = tab_1.tabpage_2.dw_detinc.object.cod_incidencia [ll_inicio]
		  
	 	  ls_hinicio_inc 	  = Mid(Trim(String(tab_1.tabpage_2.dw_detinc.Object.fecha_inicio [ll_inicio] )),10,8)
	 	  ls_hfinal_inc  	  = Mid(Trim(String(tab_1.tabpage_2.dw_detinc.Object.fecha_fin	   [ll_inicio] )),10,8)
	 	  ls_desc_inc	  	  = Trim(tab_1.tabpage_2.dw_detinc.Object.descripcion	[ll_inicio])
	 
	 	  IF Isnull(ls_cod_incidencia) OR Trim(ls_cod_incidencia) = '' THEN
  		 	  tab_1.SelectedTab = 2
		 	  tab_1.tabpage_2.dw_detinc.SetFocus()
		 	  tab_1.tabpage_2.dw_detinc.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_2.dw_detinc.Setrow(ll_inicio)
		 	  tab_1.tabpage_2.dw_detinc.SetColumn('cod_incidencia')
				
			  /*Posiciona Item en el Detalle*/
			  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			  /**/
		 	  Messagebox('Aviso','Debe Ingresar Codigo de Incidencia ')			 			
	 		  ib_update_check = False	
	 	 	  Return		
		  END IF
		  
		  
	 	  IF Isnull(ls_hinicio_inc) OR ls_hinicio_inc = '00:00:00' THEN
			  		
		 	  tab_1.SelectedTab = 2
		 	  tab_1.tabpage_2.dw_detinc.SetFocus()
		 	  tab_1.tabpage_2.dw_detinc.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_2.dw_detinc.Setrow(ll_inicio)
		 	  tab_1.tabpage_2.dw_detinc.SetColumn('fecha_inicio')
			  /*Posiciona Item en el Detalle*/
			  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			  /**/
		 	  Messagebox('Aviso','Debe Ingresar Una Hora Inicial de la Incidencia '+ls_desc_inc)			 			
				
	 		  ib_update_check = False	
	 	 	  Return		
		  END IF
	 
		  IF Isnull(ls_hfinal_inc) OR ls_hfinal_inc = '00:00:00' THEN
		 	  tab_1.SelectedTab = 2
		 	  tab_1.tabpage_2.dw_detinc.SetFocus()
			  tab_1.tabpage_2.dw_detinc.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_2.dw_detinc.Setrow(ll_inicio)
			  tab_1.tabpage_2.dw_detinc.SetColumn('fecha_fin')
			  /*Posiciona Item en el Detalle*/
			  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			  /**/				  
			  Messagebox('Aviso','Debe Ingresar Una Hora Final de la Incidencia '+ls_desc_inc)			 	
			  ib_update_check = False	
			  Return	 
		  END IF
	 
	 NEXT

	 
	 /*Asistencia x Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_detasis.Rowcount()
		  //asignar nro de parte cuando registro sea nuevo
		  ldis_status = tab_1.tabpage_3.dw_detasis.GetItemStatus(ll_inicio,0,Primary!)

	 	  IF ldis_status = NewModified! THEN
		     tab_1.tabpage_3.dw_detasis.Object.no_parte [ll_inicio] = ls_nro_parte
	     END IF

		  ls_cod_trab = tab_1.tabpage_3.dw_detasis.object.cod_trabajador [ll_inicio]

		  IF Isnull(ls_cod_trab) OR Trim(ls_cod_trab) = '' THEN
  		 	  tab_1.SelectedTab = 3
		 	  tab_1.tabpage_3.dw_detasis.SetFocus()
			  tab_1.tabpage_3.dw_detasis.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_3.dw_detasis.Setrow(ll_inicio)
			  tab_1.tabpage_3.dw_detasis.SetColumn('cod_trabajador')
			  /*Posiciona Item en el Detalle*/
			  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			  /**/				  
			  Messagebox('Aviso','Debe Ingresar Un Codigo de Trabajador ')			 	
			  ib_update_check = False	
			  Return	 
		  END IF
					  
	 NEXT
	 

	
	 /*Causa de Fallas*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_4.dw_causas.Rowcount()
  		  //asignar nro de parte cuando registro sea nuevo
		  ldis_status = tab_1.tabpage_4.dw_causas.GetItemStatus(ll_inicio,0,Primary!)

	 	  IF ldis_status = NewModified! THEN
		     tab_1.tabpage_4.dw_causas.Object.nro_parte [ll_inicio] = ls_nro_parte
	     END IF

	
		  ls_cod_causa = tab_1.tabpage_4.dw_causas.Object.causa_falla [ll_inicio]	
		  
		  IF Isnull(ls_cod_causa) OR Trim(ls_cod_causa) = '' THEN
  		 	  tab_1.SelectedTab = 4
		 	  tab_1.tabpage_4.dw_causas.SetFocus()
			  tab_1.tabpage_4.dw_causas.Scrolltorow(ll_inicio)
		 	  tab_1.tabpage_4.dw_causas.Setrow(ll_inicio)
			  tab_1.tabpage_4.dw_causas.SetColumn('causa_falla')
			  /*Posiciona Item en el Detalle*/
			  tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			  tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			  /**/				  
			  Messagebox('Aviso','Debe Ingresar Un Codigo de Causa de Falla ')			 	
			  ib_update_check = False	
			  Return	 
		   END IF
	  NEXT
	  
	  //riego
	  FOR ll_inicio = 1 TO tab_1.tabpage_5.dw_riegos.Rowcount()
			//asignar nro de parte cuando registro sea nuevo
		   ldis_status = tab_1.tabpage_5.dw_riegos.GetItemStatus(ll_inicio,0,Primary!)

	 	   IF ldis_status = NewModified! THEN
		      tab_1.tabpage_5.dw_riegos.Object.nro_parte [ll_inicio] = ls_nro_parte
	      END IF
	  NEXT
		
	  //MAQUINA
	  FOR ll_inicio = 1 TO tab_1.tabpage_6.dw_maquina.Rowcount()
			ls_cod_maquina = tab_1.tabpage_6.dw_maquina.object.cod_maquina [ll_inicio]
			
			IF Isnull(ls_cod_maquina) OR Trim(ls_cod_maquina) = '' THEN
  		 	   tab_1.SelectedTab = 6
		 	   tab_1.tabpage_6.dw_maquina.SetFocus()
			   tab_1.tabpage_6.dw_maquina.Scrolltorow(ll_inicio)
		 	   tab_1.tabpage_6.dw_maquina.Setrow(ll_inicio)
			   tab_1.tabpage_6.dw_maquina.SetColumn('cod_maquina')
			   /*Posiciona Item en el Detalle*/
			   tab_1.tabpage_1.dw_detail.Scrolltorow(ll_inicio_item)
			   tab_1.tabpage_1.dw_lista.Scrolltorow(ll_inicio_item)
			   tab_1.tabpage_1.dw_lista.Setrow(ll_inicio_item)
			   /**/				  
			   Messagebox('Aviso','Debe Ingresar Un Codigo de Maquina ,Verifique! ')			 	
			   ib_update_check = False	
				Return
			END IF
			
			//asignar nro de parte cuando registro sea nuevo
			ldis_status = tab_1.tabpage_6.dw_maquina.GetItemStatus(ll_inicio,0,Primary!)

	 	   IF ldis_status = NewModified! THEN
		      tab_1.tabpage_6.dw_maquina.Object.nro_parte [ll_inicio] = ls_nro_parte
	      END IF
	  NEXT


	 
NEXT

IF ll_item_old > 0 THEN
	wf_filter_dws (ll_item_old)
	tab_1.tabpage_1.dw_detail.Scrolltorow(ll_row_det_old)
	tab_1.tabpage_1.dw_detail.Setrow(ll_row_det_old)
END IF


dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detart.of_set_flag_replicacion()
tab_1.tabpage_2.dw_detinc.of_set_flag_replicacion()
tab_1.tabpage_3.dw_detasis.of_set_flag_replicacion()
tab_1.tabpage_4.dw_causas.of_set_flag_replicacion()
tab_1.tabpage_5.dw_riegos.of_set_flag_replicacion()
tab_1.tabpage_6.dw_maquina.of_set_flag_replicacion()

//ACTAULIZA CANTIDAD
wf_act_cant_costo_labor ()
end event

event ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 					   OR tab_1.tabpage_1.dw_detail.ii_update  = 1 OR &
	 tab_1.tabpage_1.dw_detart.ii_update  = 1 OR tab_1.tabpage_2.dw_detinc.ii_update  = 1 OR &
	 tab_1.tabpage_3.dw_detasis.ii_update = 1 OR tab_1.tabpage_4.dw_causas.ii_update  = 1 OR &
	 tab_1.tabpage_5.dw_riegos.ii_update  = 1 OR tab_1.tabpage_6.dw_maquina.ii_update = 1 ) THEN
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
	END IF
END IF
end event

event ue_update;call super::ue_update;string ls_nro_parte
Boolean lbo_ok = TRUE
Long    ll_row_det_old,ll_item_old

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_1.dw_detart.AcceptText()
tab_1.tabpage_2.dw_detinc.AcceptText()
tab_1.tabpage_3.dw_detasis.AcceptText()
tab_1.tabpage_4.dw_causas.AcceptText()
tab_1.tabpage_5.dw_riegos.AcceptText()
tab_1.tabpage_6.dw_maquina.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	Rollback;
	RETURN
END IF

tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_1.dw_detart.AcceptText()
tab_1.tabpage_2.dw_detinc.AcceptText()
tab_1.tabpage_3.dw_detasis.AcceptText()
tab_1.tabpage_4.dw_causas.AcceptText()
tab_1.tabpage_5.dw_riegos.AcceptText()
tab_1.tabpage_6.dw_maquina.AcceptText()



ll_row_det_old = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row_det_old > 0 THEN
   ll_item_old = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row_det_old]
END IF


IF ib_log THEN
	Datastore lds_log_1 ,lds_log_2 ,lds_log_3 ,lds_log_4 ,lds_log_5 ,lds_log_6
	lds_log_1 = Create DataStore
	lds_log_2 = Create DataStore
	lds_log_3 = Create DataStore
	lds_log_4 = Create DataStore
	lds_log_5 = Create DataStore
	lds_log_6 = Create DataStore
	lds_log_1.DataObject = 'd_log_diario_tbl'
	lds_log_2.DataObject = 'd_log_diario_tbl'
	lds_log_3.DataObject = 'd_log_diario_tbl'
	lds_log_4.DataObject = 'd_log_diario_tbl'
	lds_log_5.DataObject = 'd_log_diario_tbl'
	lds_log_6.DataObject = 'd_log_diario_tbl'
	lds_log_1.SetTransObject(SQLCA)
	lds_log_2.SetTransObject(SQLCA)
	lds_log_3.SetTransObject(SQLCA)
	lds_log_4.SetTransObject(SQLCA)
	lds_log_5.SetTransObject(SQLCA)
	lds_log_6.SetTransObject(SQLCA)
	
	in_log.of_create_log(dw_master, lds_log_1, is_colname_1, is_coltype_1, gs_user, is_tabla_1)
	in_log.of_create_log(tab_1.tabpage_1.dw_detail , lds_log_2, is_colname_2, is_coltype_2, gs_user, is_tabla_2)
	in_log.of_create_log(tab_1.tabpage_1.dw_detart , lds_log_3, is_colname_3, is_coltype_3, gs_user, is_tabla_3)
	in_log.of_create_log(tab_1.tabpage_2.dw_detinc , lds_log_4, is_colname_4, is_coltype_4, gs_user, is_tabla_4)
	in_log.of_create_log(tab_1.tabpage_3.dw_detasis, lds_log_5, is_colname_5, is_coltype_5, gs_user, is_tabla_5)
   in_log.of_create_log(tab_1.tabpage_4.dw_causas , lds_log_6, is_colname_6, is_coltype_6, gs_user, is_tabla_6)	
	
END IF

IF ll_item_old > 0 THEN
	wf_filter_dws (ll_item_old)
	tab_1.tabpage_1.dw_detail.Scrolltorow(ll_row_det_old)
	tab_1.tabpage_1.dw_detail.Setrow(ll_row_det_old)
	tab_1.tabpage_1.dw_detail.il_row = ll_row_det_old
END IF


IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

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
	is_accion = 'fileopen'

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
	wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)	
	
	tab_1.tabpage_1.dw_detail.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")	
	
ELSE 
	ROLLBACK USING SQLCA;
END IF

ll_row = tab_1.tabpage_1.dw_detail.GetRow()

ls_nro_parte = trim(tab_1.tabpage_1.dw_detail.object.nro_parte[ll_row])

tab_1.tabpage_1.dw_detail.Retrieve(ls_nro_parte)
tab_1.tabpage_1.dw_detail.ScrolltoRow(ll_row)
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_pd_ot_tbl'
sl_param.titulo = "Partes Diario de Orden de Trabajo"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = '1SQL'
sl_param.string1 =  ' WHERE ("VW_OPE_PT_X_ADM"."COD_USR" = '+"'"+gs_user+"'"+')    '&
						 +'ORDER BY "VW_OPE_PT_X_ADM"."NRO_PARTE" DESC  '





OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	wf_retrieve (sl_param.field_ret[1])	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
END IF

end event

event ue_modify;String ls_protect

dw_master.of_protect()
IF dw_master.getrow() > 0 THEN
	ls_protect=dw_master.Describe("fecha.protect")
	IF ls_protect='0' THEN
		dw_master.of_column_protect('fecha')
	END IF
END IF
tab_1.tabpage_1.dw_detail.of_protect()
tab_1.tabpage_1.dw_detart.of_protect()
tab_1.tabpage_2.dw_detinc.of_protect()
tab_1.tabpage_3.dw_detasis.of_protect()
tab_1.tabpage_4.dw_causas.of_protect()
tab_1.tabpage_5.dw_riegos.of_protect()
tab_1.tabpage_6.dw_maquina.of_protect()

tab_1.tabpage_1.dw_detail.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")


/*Bloquear detalle de parte y asistencia*/
//control de terminado desactivado por ser lento arojas //26/08/2003 
//tab_1.tabpage_1.dw_detail.Modify("nro_orden.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cod_labor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("desc_labor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cod_ejecutor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("proveedor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("confin.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cod_maquina.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("hora_inicio.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("hora_fin.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cant_avance.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("und_avance.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cant_labor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("cencos.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("ind_act_maq.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("flag_conformidad.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("flag_terminado.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_1.dw_detail.Modify("obs.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//
//
//
//
//tab_1.tabpage_3.dw_detasis.Modify("cod_trabajador.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_3.dw_detasis.Modify("nro_horas.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_3.dw_detasis.Modify("factor.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//tab_1.tabpage_3.dw_detasis.Modify("observacion.Protect='1~tIf(IsNull(flag_oper),0,1)'")
//
//
//
//
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

event ue_insert_pos;call super::ue_insert_pos;IF idw_1 = tab_1.tabpage_1.dw_detail THEN
	tab_1.tabpage_1.dw_detail.SetColumn('nro_orden')
END IF	
end event

event ue_delete_pos;call super::ue_delete_pos;wf_act_cant_costo_labor ()
end event

event open;//Override
IF this.of_access(gs_user, THIS.ClassName()) THEN
	THIS.EVENT ue_open_pre()
	THIS.EVENT ue_dw_share()
	THIS.EVENT ue_retrieve_dddw()
ELSE
	CLOSE(THIS)
END IF
//Abrir y recuperar (necesita parametros)
str_parametros sl_param
sl_param = Message.PowerObjectParm

String ls_nro_parte
Long ll_row, ll_item
If sl_param.opcion = 1 then
	ls_nro_parte = sl_param.string1
	ll_item = sl_param.long1

	
	wf_retrieve (ls_nro_parte)	
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')	
	
	//Recuperar info del opersec
	//Busco row del opersec
	ll_row = tab_1.tabpage_1.dw_detail.Find("nro_item="+String(ll_item),1,tab_1.tabpage_1.dw_detail.RowCount())
	tab_1.tabpage_1.dw_lista.SelectRow(0, FALSE)
	tab_1.tabpage_1.dw_lista.SelectRow(ll_row, TRUE)
	
	tab_1.tabpage_1.dw_detail.Setrow(ll_row)
	tab_1.tabpage_1.dw_detail.ScrollToRow(ll_row)
END IF
end event

type cb_1 from commandbutton within w_ope305_parte_ot
integer x = 727
integer y = 20
integer width = 343
integer height = 60
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Ubicar"
end type

event clicked;String ls_parte
Long ll_nro_parte

ls_parte = sle_parte.text


wf_retrieve (ls_parte)	

end event

type st_1 from statictext within w_ope305_parte_ot
integer x = 46
integer y = 20
integer width = 306
integer height = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte diario :"
alignment alignment = right!
boolean border = true
boolean focusrectangle = false
end type

type sle_parte from singlelineedit within w_ope305_parte_ot
event ue_tecla pbm_keydown
integer x = 361
integer y = 20
integer width = 343
integer height = 60
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
integer limit = 10
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;IF key = KeyEnter! THEN
	cb_1.triggerevent(clicked!)
END IF
end event

type dw_operaciones from u_dw_abc within w_ope305_parte_ot
integer x = 1513
integer y = 16
integer width = 1902
integer height = 420
integer taborder = 20
string dragicon = "DataPipeline!"
string dataobject = "d_abc_operaciones_orden_trabajo_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


IF row > 0 THEN
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

type tab_1 from tab within w_ope305_parte_ot
integer x = 9
integer y = 448
integer width = 3419
integer height = 1604
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long backcolor = 79741120
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
tabpage_5 tabpage_5
tabpage_6 tabpage_6
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.tabpage_5=create tabpage_5
this.tabpage_6=create tabpage_6
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4,&
this.tabpage_5,&
this.tabpage_6}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
destroy(this.tabpage_5)
destroy(this.tabpage_6)
end on

event selectionchanged;Long ll_row,ll_item
String ls_nro_parte

ll_row = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row = 0 THEN RETURN

ls_nro_parte = tab_1.tabpage_1.dw_detail.object.nro_parte [ll_row]
ll_item      = tab_1.tabpage_1.dw_detail.object.nro_item  [ll_row]



wf_filter_dws (ll_item)

//
CHOOSE CASE newindex
		 CASE 1
				if oldindex = 3 OR oldindex = 2 then
					wf_act_cant_costo_labor() //actualiza costo y cantidad de labor
			   end if

END CHOOSE



end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
st_campo st_campo
dw_find dw_find
dw_lista dw_lista
dw_detart dw_detart
dw_detail dw_detail
end type

on tabpage_1.create
this.st_campo=create st_campo
this.dw_find=create dw_find
this.dw_lista=create dw_lista
this.dw_detart=create dw_detart
this.dw_detail=create dw_detail
this.Control[]={this.st_campo,&
this.dw_find,&
this.dw_lista,&
this.dw_detart,&
this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.st_campo)
destroy(this.dw_find)
destroy(this.dw_lista)
destroy(this.dw_detart)
destroy(this.dw_detail)
end on

type st_campo from statictext within tabpage_1
integer x = 5
integer y = 44
integer width = 882
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por :"
boolean focusrectangle = false
end type

type dw_find from datawindow within tabpage_1
event dw_enter pbm_dwnprocessenter
event ue_tecla pbm_dwnkey
integer x = 5
integer y = 124
integer width = 882
integer height = 88
integer taborder = 30
string title = "none"
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event type long dw_enter();
tab_1.tabpage_1.dw_lista.triggerevent(doubleclicked!)
return 1
end event

event type long ue_tecla(keycode key, unsignedlong keyflags);Long ll_row

IF keydown(keyuparrow!) THEN		// Anterior
	tab_1.tabpage_1.dw_lista.scrollpriorRow()
ELSEIF keydown(keydownarrow!) THEN	// Siguiente
	tab_1.tabpage_1.dw_lista.scrollnextrow()	
END IF
ll_row = tab_1.tabpage_1.dw_lista.Getrow()

Return ll_row
end event

event constructor;Long ll_row

This.insertrow(0)
end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
String ls_item, ls_ordenado_por, ls_comando
Long ll_fila
//dwobject dwo_c

SetPointer(hourglass!)

IF TRIM( is_col) <> '' THEN
	ls_item = upper( this.GetText())

	li_longitud = len( ls_item)
	if li_longitud > 0 then		// si ha escrito algo

		if is_data_type = 'char' THEN 
			ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		else
			ls_comando = is_col+ " = " + ls_item 
		end if
		
		ll_fila = tab_1.tabpage_1.dw_lista.find(ls_comando, 1, tab_1.tabpage_1.dw_lista.rowcount())
		
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			tab_1.tabpage_1.dw_lista.selectrow(0, false)
			tab_1.tabpage_1.dw_lista.selectrow(ll_fila,true)
			tab_1.tabpage_1.dw_lista.scrolltorow(ll_fila)
		end if
	End if	
end if	
SetPointer(arrow!)
end event

type dw_lista from u_dw_list_tbl within tabpage_1
integer x = 5
integer y = 224
integer width = 882
integer height = 1196
integer taborder = 20
string dataobject = "d_abc_lista_pd_ot_det_tbl"
end type

event constructor;call super::constructor;ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1			// columnas de lectrua de este dw
ii_dk[2] = 2
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
///
tab_1.tabpage_1.dw_detail.Setrow(currentrow)
tab_1.tabpage_1.dw_detail.ScrollToRow(currentrow)
end event

event clicked;call super::clicked;tab_1.tabpage_1.dw_detail.Setrow(row)
tab_1.tabpage_1.dw_detail.ScrollToRow(row)


tab_1.tabpage_1.dw_detail.il_row = row

end event

event doubleclicked;call super::doubleclicked;Integer li_pos, li_col
String  ls_column , ls_report, ls_color,ls_data_type,ls_col_tipo
Long ll_row


li_col = tab_1.tabpage_1.dw_lista.GetColumn()
ls_column = THIS.GetObjectAtPointer()

li_pos = pos(upper(ls_column),'_T')
IF li_pos > 0 THEN
	is_col = UPPER( mid(ls_column,1,li_pos - 1) )	
	ls_column = mid(ls_column,1,li_pos - 1) + "_t.text"
	ls_color = mid(ls_column,1,li_pos - 1) + "_t.Background.Color = 255"
	ls_col_tipo = is_col+'.coltype' 
	ls_data_type = this.Describe(ls_col_tipo)
	is_data_type = Mid(ls_data_type,1,pos(ls_data_type,'(') - 1)

	st_campo.text = "Buscar por :" + Trim(is_col)
	dw_find.reset()
	dw_find.InsertRow(0)
	dw_find.SetFocus()
	This.SelectRow(0, False)
END IF
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
	CASE 1                        // Llave Duplicada
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

type dw_detart from u_dw_abc within tabpage_1
integer x = 896
integer y = 1100
integer width = 2487
integer height = 372
integer taborder = 50
string dataobject = "d_abc_pd_ot_insumos_tbl"
boolean vscrollbar = true
end type

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

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String      ls_nom_art,ls_und, ls_cod_art,ls_cod_labor
Decimal {2} ldc_costo

this.Accepttext()

CHOOSE CASE dwo.name
	CASE 'cod_art'
		ls_cod_labor = dw_detail.object.cod_labor [dw_detail.getrow()]
		ls_cod_art   = data

		SELECT a.desc_art, a.und,  a.costo_ult_compra
		  INTO :ls_nom_art, :ls_und, :ldc_costo
		  FROM articulo a,
				 labor_insumo l
		 WHERE a.cod_art     = l.cod_art     
			AND a.flag_estado = '1'           
			AND l.cod_labor   = :ls_cod_labor 
			AND a.cod_art	  	= :ls_cod_art;
	
		IF SQLCA.SQLCode = 100 THEN
			 
			SetNull(ls_cod_art)
			SetNull(ls_nom_art)
			SetNull(ls_und)
			SetNull(ldc_costo)
			
			This.Object.cod_art 		 [row] = ls_cod_art
			This.Object.nom_articulo [row] = ls_nom_art
			This.Object.und 			 [row] = ls_und
			This.Object.costo_insumo [row] = ldc_costo
			Messagebox('Aviso','Codigo de Artciulo No Existe, esta invalido o no corresponde a la labor , Verifique !')			
			Return 1					
			
		end if
		
		This.Object.nom_articulo [row] = ls_nom_art
		This.Object.und 			 [row] = ls_und
		This.Object.costo_insumo [row] = ldc_costo
			
END CHOOSE

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row, ll_nro_item, ll_nro_parte
Date ld_fecha
ll_row = dw_detail.GetRow()

IF ll_row > 0 THEN
	idw_mst.il_row = 1
ELSE
	return
END IF 


ll_nro_item = dw_detail.GetItemNumber(ll_row, 'nro_item')


this.SetItem(al_row, 'nro_item', ll_nro_item)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     	ls_cod_labor, ls_cod_art
Decimal {2} ld_costo_insumo
str_seleccionar lstr_seleccionar

if this.Describe( dwo.name + ".Protect") = '1' then return //protegido 

CHOOSE CASE dwo.name
	CASE	'cod_art'
			ls_cod_labor = dw_detail.object.cod_labor [dw_detail.getrow()]
			
			lstr_seleccionar.s_seleccion = 'S'
			lstr_seleccionar.s_sql = 'SELECT VW_MTT_ART_X_LABOR.COD_ART AS CODIGO, '&   
											 +'VW_MTT_ART_X_LABOR.DESC_ART AS DESCRIPCION, '&   
											 +'VW_MTT_ART_X_LABOR.UND AS UNIDAD '&
											 +'FROM  VW_MTT_ART_X_LABOR '&
											 +'WHERE VW_MTT_ART_X_LABOR.COD_LABOR = '+"'"+ls_cod_labor+"'"    
	
			OpenWithParm(w_seleccionar,lstr_seleccionar)											 
			
			IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
			IF lstr_seleccionar.s_action = "aceptar" THEN
				this.object.cod_art 		 [row] = lstr_seleccionar.param1[1]
				this.object.nom_articulo [row] = lstr_seleccionar.param2[1]
				this.object.und			 [row] = lstr_seleccionar.param3[1]
				
				ls_cod_art = lstr_seleccionar.param1[1]
				
				select nvl(costo_ult_compra,0) 
					into :ld_costo_insumo 
				from articulo 
				where cod_art = :ls_cod_art ;
				
				this.object.costo_insumo	[row] = ld_costo_insumo
				this.ii_update = 1
			END IF																 
		
			
END CHOOSE



end event

event dberror;// OVERRIDE
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

type dw_detail from u_dw_abc within tabpage_1
integer x = 896
integer y = 12
integer width = 2487
integer height = 1076
integer taborder = 20
string dragicon = "DosEdit5!"
string dataobject = "d_abc_ot_det_ff"
end type

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

event clicked;call super::clicked;Long   ll_row,ll_row_master,ll_row_det
String ls_nro_orden, ls_cod_labor, ls_cod_ejecutor, ls_proveedor, ls_und_avance, &
		 ls_obs, ls_desc_labor, ls_oper_sec, ls_ot_adm, ls_flag_oper, ls_ot_adm_campo
Datetime    ldt_hora_inicio,ldt_hora_fin
Decimal {2} ldc_cant_avance,ldc_cant_labor,ldc_costo_labor
Integer		li_opcion
dwItemStatus ldis_status

str_parametros sl_param
				
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


tab_1.tabpage_1.dw_lista.il_row = row  



dw_master.Accepttext()

CHOOSE CASE dwo.name
		 CASE	'b_lanz'
				ll_row_det = tab_1.tabpage_1.dw_detail.Getrow()
				
				li_opcion = MessageBox('Aviso','Esta Seguro de Lanzar Operación ', Question!, yesno!, 2)

				IF li_opcion = 2 THEN RETURN

				//inserta operaciones
				ls_nro_orden    = tab_1.tabpage_1.dw_detail.object.nro_orden    [ll_row_det]
				ls_cod_labor    = tab_1.tabpage_1.dw_detail.object.cod_labor    [ll_row_det]
				ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor [ll_row_det]
				ls_proveedor	 = tab_1.tabpage_1.dw_detail.object.proveedor    [ll_row_det]
				ldt_hora_inicio = tab_1.tabpage_1.dw_detail.object.hora_inicio  [ll_row_det]
				ldt_hora_fin    = tab_1.tabpage_1.dw_detail.object.hora_fin     [ll_row_det]
				ldc_cant_avance = tab_1.tabpage_1.dw_detail.object.cant_avance  [ll_row_det]
				ls_und_avance   = tab_1.tabpage_1.dw_detail.object.und_avance   [ll_row_det]
				ldc_cant_labor  = tab_1.tabpage_1.dw_detail.object.cant_labor   [ll_row_det]
				ls_obs          = tab_1.tabpage_1.dw_detail.object.obs          [ll_row_det]
				ls_desc_labor   = tab_1.tabpage_1.dw_detail.object.desc_labor   [ll_row_det]
				ldc_costo_labor = tab_1.tabpage_1.dw_detail.object.costo_labor  [ll_row_det]
				ls_oper_sec     = tab_1.tabpage_1.dw_detail.object.oper_sec     [ll_row_det]

				IF Not(Isnull(ls_oper_sec) OR Trim(ls_oper_sec) = '') THEN
					Messagebox('Aviso','Item ya Contiene Un Oper Sec Verifique')
					Return
				END IF

				IF Isnull(ls_nro_orden) or Trim(ls_nro_orden) = '' THEN
					Messagebox('Aviso','Debe Ingresar Nro de Orden de Trabajo')
					Return
				END IF
		
				IF Isnull(ls_cod_labor) or Trim(ls_cod_labor) = '' THEN
					Messagebox('Aviso','Debe Ingresar Codigo de Labor')
					Return
				END IF

				IF Isnull(ls_cod_ejecutor) or Trim(ls_cod_ejecutor) = '' THEN
					Messagebox('Aviso','Debe Ingresar Codigo de Ejecutor')
					Return
				END IF

				IF Isnull(ldc_cant_labor) or ldc_cant_labor = 0 THEN
					Messagebox('Aviso','Debe Ingresar Cantidad de Labor')
					Return
				END IF

				ls_oper_sec = wf_insert_oper_sec (ls_nro_orden,ls_cod_labor, &
															 ls_cod_ejecutor,ls_proveedor,&
															 ldt_hora_inicio,ldt_hora_fin,&
															 ldc_cant_avance,ls_und_avance,&
															 ldc_cant_labor,ls_obs,&
															 ls_desc_labor,ldc_costo_labor)


				tab_1.tabpage_1.dw_detail.object.oper_sec  [ll_row_det] = ls_oper_sec
				
		 CASE 'b_ref'  //Busqueda de Ordenes de Trabajo
				if row = 0 then return
				ldis_status = This.GetItemStatus(row,0,Primary!)
			   IF Not(ldis_status = NewModified!) THEN 
					Messagebox('Aviso','No Puede Cambiar de Orden de Trabajo')
					RETURN
				END IF	
				
				//buscar ot_adm de cabecera
				ll_row_master = dw_master.getrow()
				IF ll_row_master = 0 THEN RETURN
				ls_ot_adm    = dw_master.object.ot_adm [ll_row_master]

				
				IF Isnull(ls_ot_adm) OR trim(ls_ot_adm) = '' THEN
					Messagebox('Aviso','Debe Ingresar la Administracion de las OT ')
					Return
				END IF
				
				sl_param.dw1    = 'd_abc_lista_orden_trabajo_tbl'
				sl_param.titulo = 'Orden de Trabajo'
				
				sl_param.tipo    = '1SQL'                                                          

				IF ls_ot_adm <> 'CAMPO' THEN
					sl_param.string1 = 'WHERE ( "VW_OPE_OT_X_ADM"."OT_ADM" = '+"'"+ls_ot_adm+"'"+') AND  '&
											 +'     ( "VW_OPE_OT_X_ADM"."USUARIO"= '+"'"+gs_user  +"'"+')    '
				ELSE																	 
					sl_param.string1 = 'WHERE ( "VW_OPE_OT_X_ADM"."OT_ADM" = '+"'"+ls_ot_adm+"'"+') AND   '&
											 +'     ( "VW_OPE_OT_X_ADM"."FLAG_ESTADO" ='+"'"+'1'+"'"+') AND   '&
											 +'     ( "VW_OPE_OT_X_ADM"."USUARIO"= '+"'"+gs_user  +"'"+')    '
				END IF									 
				
				sl_param.field_ret_i[1] = 1
				
				sl_param.field_ret_i[2] = 2


				OpenWithParm( w_lista, sl_param)

				sl_param = Message.PowerObjectParm
				IF sl_param.titulo <> 'n' THEN
					ls_cod_labor 	 = This.Object.cod_labor    [row]
					ls_cod_ejecutor = This.Object.cod_ejecutor [row]
					
					This.object.nro_orden  [row] = sl_param.field_ret[2]
					//Recupero Operaciones
					wf_retrieve_operaciones (sl_param.field_ret[2],ls_cod_labor,ls_cod_ejecutor)
					
					This.ii_update = 1
				END IF

END CHOOSE


end event

event itemchanged;call super::itemchanged;Decimal {2} ldc_seg, ldc_hrs, ldc_cant_labor, ldc_costo_unitario, ldc_horomet_ini
Decimal {2} ldc_horomet_fin, ldc_horomet
Long			ll_count,ll_row_master
String      ls_descripcion,ls_codigo      ,ls_nro_doc ,&
		      ls_cod_labor  ,ls_cod_ejecutor,ls_desc_maq,&
				ls_und_hr	  ,ls_und			,ls_cencos  ,&
				ls_ot_adm     ,ls_nro_orden	
time        lt_hora_inicio,lt_hora_fin
Datetime    ldt_hor_final,ldt_hor_inicio,ldt_hor_final_old


ldt_hor_final_old = This.Object.hora_fin    [row]
/**/
Accepttext()
ii_update = 1

/*unidades hora*/
SELECT und_hr INTO :ls_und_hr FROM prod_param WHERE reckey = '1' ;

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
									
									
				SELECT Count(*) INTO :ll_count FROM orden_trabajo WHERE nro_orden = :data AND ot_adm = :ls_ot_adm ;
				
				IF ll_count = 0 THEN
					SetNull(ls_nro_orden)
					This.object.nro_orden [row] = ls_nro_orden
					Messagebox('Aviso','Nro de Orden No pertenece a OT ADM ,Verifique!')	
					Return 1
				END IF
			
									
				ls_cod_labor 	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
		
				
		
				//Recupero Operaciones
				wf_retrieve_operaciones (data,ls_cod_labor,ls_cod_ejecutor)
				
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
					
					SELECT desc_labor
					  INTO :ls_descripcion
					  FROM labor
					 WHERE (cod_labor = :data) ;
					 
					this.object.desc_labor   [row] = ls_descripcion
					this.object.cod_ejecutor [row] = ls_cod_ejecutor
				ELSE
					SetNull(ls_codigo)
					SetNull(ls_descripcion)
					setnull(ls_cod_ejecutor)
					
					This.Object.cod_labor  [row] = ls_codigo
					This.Object.desc_labor [row] = ls_descripcion
					this.object.cod_ejecutor [row] = ls_cod_ejecutor
					Messagebox('Aviso','Codigo de Labor No existe, Verifique!')
					Return 1
				END IF
				
				/*Recupero operaciones*/
				ls_nro_doc  	 = This.Object.nro_orden    [row]
				ls_cod_labor	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				
				wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
				/**/

				
				//actualizo costo labor....
				wf_act_cant_costo_labor ()
				
		 CASE 'cod_ejecutor'
				
				ls_cod_labor	 = This.Object.cod_labor    [row]
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM labor_ejecutor
				 WHERE ((cod_labor    = :ls_cod_labor ) AND
				 		  (cod_ejecutor = :data         )) ;

				IF ll_count > 0 THEN
					SELECT descripcion
					  INTO :ls_descripcion
					 FROM ejecutor
					WHERE (cod_ejecutor = :data) ;
					
					This.Object.ejecutor_descripcion [row] = ls_descripcion
				ELSE
					SetNull(ls_codigo)
					SetNull(ls_descripcion)
					
					This.Object.cod_ejecutor         [row] = ls_codigo
					This.Object.ejecutor_descripcion [row] = ls_descripcion
					
					Messagebox('Aviso','Codigo de Ejecutor No existe, Verifique!')
					Return 1
					
				END IF
				
				//actualizo costo labor....
				wf_act_cant_costo_labor ()
				
				/*Recupero operaciones*/
				ls_nro_doc  	 = This.Object.nro_orden    [row]
				ls_cod_labor	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				
				wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
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
			     lt_hora_inicio = Time(String(This.object.hora_inicio [row],'hh:mm:ss'))
			     lt_hora_fin	  = Time(String(This.object.hora_fin    [row],'hh:mm:ss'))
			  
  			     ldc_seg = Round(SecondsAfter ( lt_hora_inicio, lt_hora_fin ) / 60 ,2)
		        ldc_hrs = round(ldc_seg / 60,2)		

			  END IF
			
			  //cantidad y costo labor	
			  wf_act_cant_costo_labor ()	
			  
		CASE 'hora_fin'	
    		  ldt_hor_inicio = This.Object.hora_inicio [row]	
			  ldt_hor_final  = This.Object.hora_fin    [row]
			  
			  
			  IF Isnull( ldt_hor_final ) THEN
				  Messagebox('Aviso','Fecha final no puede ser nula ')
				  Return 1
			  END IF
			
			  
			  IF ldt_hor_final <= ldt_hor_inicio THEN
				  Messagebox('Aviso','Fecha final no puede ser menor o igual que Fecha inicio ')
				  This.Object.hora_fin [row] = ldt_hor_final_old
				  Return 1
			  END IF
			  
			  ls_und = This.object.labor_und [row]
			  
			  IF ls_und = ls_und_hr THEN	
			  	  lt_hora_inicio = Time(String(This.object.hora_inicio [row],'hh:mm:ss'))
			  	  lt_hora_fin	  = Time(String(This.object.hora_fin    [row],'hh:mm:ss'))
			  	  ldc_seg = Round(SecondsAfter ( lt_hora_inicio, lt_hora_fin ) / 60 ,2)
			  END IF
			  
			  //cantidad y costo labor	
			  wf_act_cant_costo_labor ()		
			  
		CASE 'cencos'					
			  SELECT Count(*)	
			    INTO :ll_count
				 FROM centros_costo
				WHERE (cencos      =  :data) and
						(flag_estado <> '0'	) ;
				
			  IF ll_count = 0 THEN
				  SetNull(ls_cencos)	
				  This.object.cencos [row] = ls_cencos
				  Messagebox('Aviso','Centro de Costo No Existe , Verifique!')
				  Return 1
				  
			  ELSE
				
			  END IF
			  
		CASE 'cant_labor','cant_avance'
				
				//parametros
				ls_cod_labor    = this.object.cod_labor    [row] 				
				ls_cod_ejecutor = this.object.cod_ejecutor [row] 				
				ldc_cant_labor  = this.object.cant_labor   [row] 				
				
				
				if isnull(ldc_cant_labor) then ldc_cant_labor = 0.00
				
				//unidad de la labor
				select und into :ls_und from labor where (cod_labor = :ls_cod_labor );
				
				IF (ls_und <> ls_und_hr ) THEN //SI LA UNIDAD DE LA LABOR ES DIFERENTE LA HRS
					select costo_unitario into :ldc_costo_unitario from labor_ejecutor where cod_labor = :ls_cod_labor and cod_ejecutor = :ls_cod_ejecutor ;
		
				
					if Isnull(ldc_costo_unitario) then ldc_costo_unitario = 0.00 	 
					ldc_costo_unitario = Round(ldc_cant_labor * ldc_costo_unitario,2)
		
					tab_1.tabpage_1.dw_detail.object.costo_labor [row] = ldc_costo_unitario
					
				END IF
				

				
		CASE 'ind_act_maq_fin'
				ldc_horomet_ini = this.object.ind_act_maq_ini[row]
				ldc_horomet_fin = this.object.ind_act_maq_fin[row] 
				ldc_horomet = ldc_horomet_fin - ldc_horomet_ini
				tab_1.tabpage_1.dw_detail.object.ind_act_maq [row] = ldc_horomet
			  
END CHOOSE



end event

event itemerror;call super::itemerror;Return 1
end event

event dragdrop;Dragobject ldo_control
Long       ll_fila,ll_item,ll_count
Integer	  li_opcion	
DataWindow ldw_drag
String 	  ls_cod_labor,ls_cod_ejecutor,ls_desc_labor,ls_und     ,&
			  ls_desc_eje ,ls_nro_doc     ,ls_doc_ot    ,ls_oper_sec
dwItemStatus ldis_status			  
		

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_abc_operaciones_orden_trabajo_tbl' THEN
		ll_fila = ldw_drag.Getrow()
		IF ll_fila > 0 THEN
			select doc_ot into :ls_doc_ot from prod_param where reckey = '1' ;
			
			
			ls_oper_sec		 = ldw_drag.Object.oper_sec     [ll_fila]
			ls_cod_labor 	 = ldw_drag.Object.cod_labor    [ll_fila]
			ls_cod_ejecutor = ldw_drag.Object.cod_ejecutor [ll_fila]
			
			ldis_status = This.GetItemStatus(row,0,Primary!)
		   IF Not(ldis_status = NewModified!) THEN 
				Messagebox('Aviso','No Puede Cambiar de Oper Sec')
				RETURN
			END IF	
			
			ls_nro_doc		 = This.Object.nro_orden [row]
			ll_item			 = This.Object.nro_item  [row]
			
			
			This.object.cod_labor    [row] = ldw_drag.Object.cod_labor      [ll_fila]
			This.object.cod_ejecutor [row] = ldw_drag.Object.cod_ejecutor   [ll_fila]
			This.object.oper_sec		 [row] = ldw_drag.Object.oper_sec       [ll_fila]
			This.object.cod_maquina  [row] = ldw_drag.Object.cod_maquina    [ll_fila]
			This.object.proveedor    [row] = ldw_drag.Object.cliente        [ll_fila]
			This.object.und_avance   [row] = ldw_drag.Object.avance_und     [ll_fila]
			This.object.cencos       [row] = ldw_drag.Object.cencos_slc     [ll_fila]
			This.object.cod_campo    [row] = ldw_drag.Object.cod_campo      [ll_fila]
			This.object.desc_campo   [row] = ldw_drag.Object.desc_campo     [ll_fila]
			This.Object.desc_labor 	 [row] = ldw_drag.Object.desc_operacion [ll_fila]
			This.Object.labor_und 	 [row] = ldw_drag.Object.und            [ll_fila]
			
			/**Descripcion de Ejecutor */
			SELECT descripcion
			  INTO :ls_desc_eje
			  FROM ejecutor
			 WHERE (cod_ejecutor = :ls_cod_ejecutor) ;
			
			This.Object.ejecutor_descripcion [row] = ls_desc_eje
			
			//Inserción de Articulos
			 SELECT Count (*)
			 	INTO :ll_count
		   	FROM articulo_mov_proy am,	
					  articulo          a
		     WHERE (am.cod_art  = a.cod_art    ) AND		
					 ((am.tipo_doc = :ls_doc_ot   ) AND
			 		  (am.nro_doc  = :ls_nro_doc  ) AND
			 		  (am.oper_sec = :ls_oper_sec )) ;
					
			IF ll_count > 0 THEN
				wf_insert_art_mov (ls_doc_ot,ls_nro_doc,ls_oper_sec,ll_item)
			END IF
			
			this.ii_update = 1
		END IF
	END IF
END IF





end event

event ue_insert_pre;call super::ue_insert_pre;Long    ll_row
String  ls_doc_ot
Integer li_item
Datetime 	ldt_fecha


ll_row = This.RowCount()
IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,"nro_item")
END IF


SELECT doc_ot
  INTO :ls_doc_ot
  FROM prod_param
 WHERE (reckey = '1') ;
   
This.SetItem(al_row, "nro_item", li_item + 1)  

ldt_fecha = dw_master.GetItemDateTime(dw_master.GetRow(), 'fecha' )
This.object.hora_inicio      [al_row] = ldt_fecha
This.object.hora_fin         [al_row] = ldt_fecha
This.object.flag_terminado   [al_row] = '0' //Activo
This.object.flag_conformidad [al_row] = 'B' //Bueno
This.object.ind_act_maq		  [al_row] = 0
This.object.ind_act_maq_ini  [al_row] = 0
This.object.ind_act_maq_fin  [al_row] = 0

//filtrar item
wf_filter_dws ( li_item + 1)





This.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event rowfocuschanged;Long 	 ll_item
String ls_expresion,ls_nro_doc,ls_cod_labor,ls_cod_ejecutor

IF currentrow = 0 THEN RETURN

ll_item 			 = This.object.nro_item 	 [currentrow]
ls_nro_doc	    = This.object.nro_orden  	 [currentrow]
ls_cod_labor    = This.object.cod_labor    [currentrow]
ls_cod_ejecutor = This.object.cod_ejecutor [currentrow]


tab_1.tabpage_1.dw_lista.SetRow(currentrow)
tab_1.tabpage_1.dw_lista.ScrolltoRow(currentrow)

wf_filter_dws (ll_item)

wf_retrieve_operaciones (ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot , ls_cod_labor , ls_ejecutor ,&
			  ls_descripcion,ls_flag_oper,ls_nro_ot
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_maquina'

				
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO_MAQUINA ,'&
								      				 +'MAQUINA.DESC_MAQ AS DESCRIPCION_MAQUINA '&
									   				 +'FROM MAQUINA '
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
					Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF														 
				
		 CASE 'cod_labor'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR.COD_LABOR AS CODIGO_LABOR ,'&
								      				 +'LABOR.DESC_LABOR AS NOMBRES '&
									   				 +'FROM LABOR '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_labor',lstr_seleccionar.param1[1])
					Setitem(row,'desc_labor',lstr_seleccionar.param2[1])
					ii_update = 1
					
					Setnull(ls_ejecutor)
					this.object.cod_ejecutor [row] = ls_ejecutor
					
					ls_nro_ot	 = This.Object.nro_orden    [row]
					ls_cod_labor = This.Object.cod_labor    [row]

		
					//Recupero Operaciones
					wf_retrieve_operaciones (ls_nro_ot,ls_cod_labor,ls_ejecutor)
				END IF
				
		 CASE 'cod_ejecutor'						
				ls_cod_labor = This.object.cod_labor [row]
				
				IF Isnull(ls_cod_labor) OR Trim(ls_cod_labor) = '' THEN
					Messagebox('Aviso','Debe Ingresar Labor para poder Seleccionar el Ejecutor')
					Return
				END IF 
					
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT LABOR_EJECUTOR.COD_LABOR    AS CODIGO_LABOR    ,'&
								      				 +'LABOR_EJECUTOR.COD_EJECUTOR AS CODIGO_EJECUTOR  '&
									   				 +'FROM LABOR_EJECUTOR '&
														 +'WHERE LABOR_EJECUTOR.COD_LABOR = '+"'"+ls_cod_labor+"'"
														 
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					ls_ejecutor = lstr_seleccionar.param2[1]
					/*Busqueda de Descripción**/
					SELECT descripcion
					  INTO :ls_descripcion
					  FROM ejecutor
					 WHERE (cod_ejecutor = :ls_ejecutor ) ;
					/****/
					Setitem(row,'cod_ejecutor',ls_ejecutor)
					Setitem(row,'ejecutor_descripcion',ls_descripcion)
					ii_update = 1
					
					ls_nro_ot	 = This.Object.nro_orden    [row]
					ls_cod_labor = This.Object.cod_labor    [row]
					ls_ejecutor  = This.Object.cod_ejecutor [row]
		
					//Recupero Operaciones
					wf_retrieve_operaciones (ls_nro_ot,ls_cod_labor,ls_ejecutor)
				END IF
				
		 CASE	'proveedor'

				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql 		  = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO , '&
															    +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
																 +'FROM PROVEEDOR '
				OpenWithParm(w_seleccionar,lstr_seleccionar)											 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'proveedor',lstr_seleccionar.param1[1])
					Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF																 
				
		 CASE	'confin'
				
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql 		  = 'SELECT CONCEPTO_FINANCIERO.CONFIN      AS CODIGO , '&
															    +'CONCEPTO_FINANCIERO.DESCRIPCION AS NOMBRE '&
																 +'FROM CONCEPTO_FINANCIERO '
																 
				OpenWithParm(w_seleccionar,lstr_seleccionar)											 
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'confin',lstr_seleccionar.param1[1])
					ii_update = 1
				END IF																 
				
				
END CHOOSE



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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Incidencia"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
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
integer x = 27
integer y = 8
integer width = 3241
integer height = 920
integer taborder = 20
string dataobject = "d_abc_pd_ot_incidencias_tbl"
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
ii_ck[4] = 4
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = tab_1.tabpage_1.dw_detail				// dw_master
idw_det  = tab_1.tabpage_2.dw_detinc 				// dw_detail
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

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long    ll_row, ll_item
DateTime ldt_fecha
	
ll_row = This.Rowcount()

IF ll_row = 0 THEN RETURN

THIS.SetItem(al_row,'nro_incidencia', ll_row)  

ll_row = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row > 0 THEN
	idw_mst.il_row = 1
ELSE
	RETURN
END IF 
ll_item = tab_1.tabpage_1.dw_detail.GetItemNumber( ll_row, 'nro_item')
this.SetItem(al_row, 'nro_item', ll_item)

ldt_fecha = dw_master.GetItemDateTime(dw_master.GetRow(), 'fecha' )
This.object.fecha_inicio      [al_row] = ldt_fecha
This.object.fecha_fin         [al_row] = ldt_fecha

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
Long ll_nro_item_detail
String     ls_name ,ls_prot, ls_nro_orden, ls_ot_adm

str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

ll_nro_item_detail = tab_1.tabpage_1.dw_detail.object.nro_item[1]
ls_nro_orden = tab_1.tabpage_1.dw_detail.object.nro_orden[1]

select ot_adm into :ls_ot_adm 
from orden_trabajo where nro_orden=:ls_nro_orden ;

CHOOSE CASE dwo.name
		 CASE 'cod_incidencia'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT vw_ope_incidencias_grupo.COD_INCIDENCIA  AS CODIGO_INCIDENCIA ,'&
								      				 +'vw_ope_incidencias_grupo.DESC_INCIDENCIA AS DESCRIPCION ' &
									   				 +'FROM vw_ope_incidencias_grupo '&
														 +'WHERE vw_ope_incidencias_grupo.ot_adm = '+"'"+ls_ot_adm+"'"

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_incidencia',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
END CHOOSE

end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

type tabpage_3 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Trabajadores"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
cb_2 cb_2
dw_detasis dw_detasis
end type

on tabpage_3.create
this.cb_2=create cb_2
this.dw_detasis=create dw_detasis
this.Control[]={this.cb_2,&
this.dw_detasis}
end on

on tabpage_3.destroy
destroy(this.cb_2)
destroy(this.dw_detasis)
end on

type cb_2 from commandbutton within tabpage_3
integer x = 2729
integer y = 36
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Trabajadores"
end type

event clicked;String ls_nro_parte, ls_cod_labor, ls_cod_ejecutor, ls_nro_orden
Long ll_nro_item
Date ld_fecha
sg_parametros_est lstr_rep
datawindow	ls_dw


ll_nro_item = tab_1.tabpage_1.dw_detail.object.nro_item[tab_1.tabpage_1.dw_detail.GetRow()]

IF ll_nro_item = 0 THEN 
	MessageBox('Aviso','No existe item seleccionado')
	RETURN 
END IF

// Captura datos para abrir ventana
ls_cod_labor 	 = tab_1.tabpage_1.dw_detail.object.cod_labor[tab_1.tabpage_1.dw_detail.GetRow()]
ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor[tab_1.tabpage_1.dw_detail.GetRow()]
ls_nro_parte 	 = tab_1.tabpage_1.dw_detail.object.nro_parte[tab_1.tabpage_1.dw_detail.GetRow()]
ls_nro_orden 	 = tab_1.tabpage_1.dw_detail.object.nro_orden[tab_1.tabpage_1.dw_detail.GetRow()]
ld_fecha 		 = DATE(dw_master.object.fecha[dw_master.GetRow()])

lstr_rep.string1 = ls_cod_labor
lstr_rep.string2 = ls_cod_ejecutor
lstr_rep.string3 = ls_nro_parte
lstr_rep.string4 = ls_nro_orden
lstr_rep.long1   = ll_nro_item 
lstr_rep.date1   = ld_fecha
lstr_rep.dw_m    = tab_1.tabpage_3.dw_detasis

// Abre ventana
OpenSheetWithParm(w_ope305_lista_trabaj, lstr_rep, w_main, 2, original!)	


end event

type dw_detasis from u_dw_abc within tabpage_3
integer x = 5
integer y = 12
integer width = 2638
integer height = 924
integer taborder = 20
string dataobject = "d_abc_pd_ot_asistencia_tbl"
boolean vscrollbar = true
end type

event clicked;idw_1.BorderStyle = StyleRaised!
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
ii_rk[3] = 3

idw_mst  = tab_1.tabpage_1.dw_detail		// dw_master
idw_det  = tab_1.tabpage_3.dw_detasis 				// dw_detail
end event

event itemchanged;call super::itemchanged;Long 	 ll_count, ll_row_master, ll_row_detail
String ls_nombre, ls_codigo, ls_ot_adm, ls_cod_labor, ls_cod_ejecutor
Date   ld_fecha
Decimal {2} ldc_gan_fija,ldc_horas,ldc_min

Accepttext()


CHOOSE CASE dwo.name
		 CASE	'nro_horas' 
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				
				wf_act_cant_costo_labor ()
		 CASE 'factor'
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
//				IF Dec(data) < 1 THEN
//					This.Object.factor [row] = 1.00
//					Return 2
//				END IF
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
					ll_row_detail = tab_1.tabpage_1.dw_detail.GetRow()
					
					ld_fecha = DATE(dw_master.object.fecha[ll_row_master])
					ls_cod_labor = tab_1.tabpage_1.dw_detail.object.cod_labor[ll_row_detail]
					ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor[ll_row_detail]
					
					/* Costo horario del trabajador */
					SELECT usf_ope_costo_hora_personal(:data, :ls_cod_labor, 
																  :ls_cod_ejecutor, :ld_fecha)
					  INTO :ldc_gan_fija
					  FROM dual ;


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

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return

String      ls_name, ls_prot , ls_nombre, ls_ot_adm, ls_flag_oper, &
				ls_cod_trabajador, ls_cod_labor, ls_cod_ejecutor
Decimal {2} ldc_gan_fija
Decimal {4} ldc_factor_costo_hr
Long        ll_row_master, ll_row_detail, ll_dias_trab_hab_fijo, ll_count
Date			ld_fecha
str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_trabajador'
				dw_master.Accepttext()
				
				ll_row_master = dw_master.Getrow()	
				
				ls_ot_adm = dw_master.object.ot_adm [ll_row_master]
				
				
				IF Isnull(ls_ot_adm) OR Trim(ls_ot_adm) = '' THEN
					Messagebox('Aviso','Ingrese OT ADM en la cabecera de Parte ')
					Return
				END IF
				
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_OPE_CRELACION_X_GRUPO.GRUPO        AS COD_GRUPO ,'&
														 +'VW_OPE_CRELACION_X_GRUPO.COD_RELACION AS CODIGO_TRABAJADOR ,'&
								      				 +'VW_OPE_CRELACION_X_GRUPO.NOMBRE       AS NOMBRES '&
									   				 +'FROM VW_OPE_CRELACION_X_GRUPO '&
														 +'WHERE VW_OPE_CRELACION_X_GRUPO.OT_ADM ='+"'"+ls_ot_adm+"'"&
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_trabajador',lstr_seleccionar.param2[1])
					Setitem(row,'nom_trabajador',lstr_seleccionar.param3[1])
					
					ll_row_detail = tab_1.tabpage_1.dw_detail.GetRow()
					
					ls_cod_trabajador = lstr_seleccionar.param2[1]
					ld_fecha = DATE(dw_master.object.fecha[ll_row_master])
					ls_cod_labor = tab_1.tabpage_1.dw_detail.object.cod_labor[ll_row_detail]
					ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.object.cod_ejecutor[ll_row_detail]
					
					SELECT usf_ope_costo_hora_personal(:ls_cod_trabajador, :ls_cod_labor, 
																  :ls_cod_ejecutor, :ld_fecha)
					  INTO :ldc_gan_fija
					  FROM dual ;
					
					IF Isnull(ldc_gan_fija) THEN ldc_gan_fija = 0.00
					
					This.object.costo_horas [row] = ldc_gan_fija	
					
					//actualiza cambios
					ii_update = 1
					
				END IF
			
				
END CHOOSE



end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row
Integer li_item
ll_row = tab_1.tabpage_1.dw_detail.Getrow()
li_item = tab_1.tabpage_1.dw_detail.GetItemNumber( ll_row, 'nro_item')
this.SetItem(al_row, 'nro_item', li_item)
this.SetItem(al_row, 'cod_trabajador', '1000')
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Causas de Fallas"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
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
integer width = 2706
integer height = 924
integer taborder = 20
string dataobject = "d_abc_causas_fallas_x_ot_tbl"
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

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_row, ll_nro_item

ll_row = tab_1.tabpage_1.dw_detail.GetRow()

IF ll_row = 0 THEN RETURN

ll_nro_item = tab_1.tabpage_1.dw_detail.object.nro_item[ll_row]

this.object.nro_item[al_row] = ll_nro_item




end event

type tabpage_5 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Riegos"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
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
string dataobject = "d_abc_riego_x_ot_tbl"
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
integer y = 104
integer width = 3383
integer height = 1484
long backcolor = 79741120
string text = "Maq./Herramienta"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
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
integer x = 5
integer y = 44
integer width = 1755
integer height = 948
integer taborder = 20
string dataobject = "d_abc_pd_ot_det_maq_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2		
ii_ck[3] = 3		
		

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2


idw_mst  = tab_1.tabpage_1.dw_detail  // dw_master
idw_det  = tab_1.tabpage_6.dw_maquina // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long ll_count
String ls_codigo,ls_desc

Accepttext()

choose case dwo.name
		 case 'cod_maquina'
				select count(*) into :ll_count from maquina where cod_maquina = :data ;
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					This.object.cod_maquina [row] = ls_codigo
					This.object.desc_maq    [row] = ls_codigo
					Messagebox('Aviso','Codigo de Maquina No Existe ,Verifique!')
					Return 1
				ELSE
					select desc_maq into :ls_desc from maquina where cod_maquina = :data ;
					
					This.object.desc_maq [row] = ls_desc
					
				END IF
				
		
end choose

end event

event itemerror;call super::itemerror;Return 1
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
		 CASE 'cod_maquina'
			
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAQUINA.COD_MAQUINA AS CODIGO_MAQ ,'&
								      				 +'MAQUINA.DESC_MAQ    AS DESCRIPCION_MAQUINA '&
									   				 +'FROM MAQUINA '

				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_maquina',lstr_seleccionar.param1[1])
					Setitem(row,'desc_maq',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF			
				
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;Long ll_item

IF tab_1.tabpage_1.dw_detail.GetRow() > 0 THEN

	ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [idw_mst.il_row]
	This.object.nro_item [al_row]	 = ll_item
END IF

end event

type dw_master from u_dw_abc within w_ope305_parte_ot
integer x = 18
integer y = 92
integer width = 1467
integer height = 352
string dataobject = "d_abc_ot_cab_ff"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      	// columnas que se pasan al detalle

idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long   ll_count
String ls_codigo, ls_descripcion, ls_nro_parte
DateTime ldt_fecha
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
		 CASE	'fecha'
				This.object.nro_parte [row] = ls_nro_parte
	 		   IF NOT ISNULL(ls_nro_parte) THEN
					MessageBox('Aviso','No puede modificar fecha')
					RETURN
				END IF
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String ls_name,ls_prot
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if

CHOOSE CASE dwo.name
		 CASE 'ot_adm'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT VW_CAM_USR_ADM.OT_ADM AS CODIGO, '&   
												 +'VW_CAM_USR_ADM.DESCRIPCION  AS DESCRIPCION  '&   
												 +'FROM  VW_CAM_USR_ADM '&
												 +'WHERE VW_CAM_USR_ADM.COD_USR = '+"'"+gs_user+"'"    	

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'ot_adm',lstr_seleccionar.param1[1])
					Setitem(row,'descripcion',lstr_seleccionar.param2[1])
					ii_update = 1
				END IF
		 CASE 'cod_supervisor'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAESTRO.COD_TRABAJADOR AS CODIGO_TRABAJADOR ,'&   
					  	 								 +'MAESTRO.NOMBRE1	     AS NOMBRE ,'&
						 								 +'MAESTRO.APEL_PATERNO   AS AP_PATERNO,'&
						 								 +'MAESTRO.APEL_MATERNO   AS AP_MATERNO '&
				  		 								 +'FROM MAESTRO '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_supervisor',lstr_seleccionar.param1[1])
					This.object.nom_supervisor [row] = Trim(lstr_seleccionar.param2[1])+' '+Trim(lstr_seleccionar.param3[1])+' '+Trim(lstr_seleccionar.param4[1])
					ii_update =1
				END IF
		CASE 'cod_administrador'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT MAESTRO.COD_TRABAJADOR AS CODIGO_TRABAJADOR ,'&   
					  	 								 +'MAESTRO.NOMBRE1	     AS NOMBRE ,'&
						 								 +'MAESTRO.APEL_PATERNO   AS AP_PATERNO,'&
						 								 +'MAESTRO.APEL_MATERNO   AS AP_MATERNO '&
				  		 								 +'FROM MAESTRO '
										  
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_administrador',lstr_seleccionar.param1[1])
					This.object.nom_administrador [row] = Trim(lstr_seleccionar.param2[1])+' '+Trim(lstr_seleccionar.param3[1])+' '+Trim(lstr_seleccionar.param4[1])
					ii_update =1					
				END IF
		CASE 'fecha'
				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				ii_update =1
END CHOOSE


end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;This.Object.fecha [al_row] = today()
end event

type r_1 from rectangle within w_ope305_parte_ot
integer linethickness = 1
long fillcolor = 12632256
integer x = 23
integer y = 8
integer width = 1079
integer height = 84
end type

