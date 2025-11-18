$PBExportHeader$w_ma303_parte_ot.srw
forward
global type w_ma303_parte_ot from w_abc
end type
type cb_2 from commandbutton within w_ma303_parte_ot
end type
type cb_1 from commandbutton within w_ma303_parte_ot
end type
type st_1 from statictext within w_ma303_parte_ot
end type
type sle_parte from singlelineedit within w_ma303_parte_ot
end type
type dw_operaciones from u_dw_abc within w_ma303_parte_ot
end type
type tab_1 from tab within w_ma303_parte_ot
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
type dw_detasis from u_dw_abc within tabpage_3
end type
type tabpage_3 from userobject within tab_1
dw_detasis dw_detasis
end type
type tabpage_4 from userobject within tab_1
end type
type dw_causas from u_dw_abc within tabpage_4
end type
type tabpage_4 from userobject within tab_1
dw_causas dw_causas
end type
type tab_1 from tab within w_ma303_parte_ot
tabpage_1 tabpage_1
tabpage_2 tabpage_2
tabpage_3 tabpage_3
tabpage_4 tabpage_4
end type
type dw_master from u_dw_abc within w_ma303_parte_ot
end type
type r_1 from rectangle within w_ma303_parte_ot
end type
end forward

global type w_ma303_parte_ot from w_abc
integer width = 3470
integer height = 2112
string title = "Parte  Diario de Orden de Trabajo (MA303)"
string menuname = "m_abc_master_list"
boolean resizable = false
cb_2 cb_2
cb_1 cb_1
st_1 st_1
sle_parte sle_parte
dw_operaciones dw_operaciones
tab_1 tab_1
dw_master dw_master
r_1 r_1
end type
global w_ma303_parte_ot w_ma303_parte_ot

type variables
String  is_accion,is_col,is_data_type
String  is_tabla_1    ,is_tabla_2    ,is_tabla_3    ,is_tabla_4    ,is_tabla_5    ,is_tabla_6    ,&
		  is_colname_1[],is_colname_2[],is_colname_3[],is_colname_4[],is_colname_5[],is_colname_6[],&
		  is_coltype_1[],is_coltype_2[],is_coltype_3[],is_coltype_4[],is_coltype_5[],is_coltype_6[]
Boolean ib_log = FALSE
n_cst_log_diario	in_log

end variables

forward prototypes
public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, long al_oper_sec, long al_item)
public function boolean wf_nro_doc (ref long al_nro_ot, ref string as_mensaje)
public subroutine wf_retrieve_operaciones (string as_tipo_doc, string as_nro_doc, string as_cod_labor, string as_cod_ejecutor)
public subroutine wf_retrieve (long al_nro_parte)
public subroutine wf_filter_dws (long al_item)
end prototypes

public subroutine wf_insert_art_mov (string as_tipo_doc, string as_nro_doc, long al_oper_sec, long al_item);String      ls_cod_art,ls_nom_art,ls_und
Decimal {2} ldc_costo_ult_compra
Decimal {4} ldc_cantidad
Long			ll_row

/*Declaración de Cursor*/
DECLARE art_ope CURSOR FOR
  SELECT am.cod_art         ,
 			am.cant_proyect    , 
			a.nom_articulo	    ,
			a.und				    ,
			a.costo_ult_compra
  	 FROM articulo_mov_proy am,	
			articulo          a
	WHERE  (am.cod_art  = a.cod_art    ) AND		
			((am.tipo_doc = :as_tipo_doc ) AND
			 (am.nro_doc  = :as_nro_doc  ) AND
			 (am.oper_sec = :al_oper_sec )) ;
					

/*Abrir Cursor*/		  	
OPEN art_ope ;

	
	DO 				/*Recorro Cursor*/	
	 FETCH art_ope INTO :ls_cod_art,:ldc_cantidad,:ls_nom_art,:ls_und,:ldc_costo_ult_compra;
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

public subroutine wf_retrieve_operaciones (string as_tipo_doc, string as_nro_doc, string as_cod_labor, string as_cod_ejecutor);
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


dw_operaciones.Retrieve(as_tipo_doc,as_nro_doc,as_cod_labor,as_cod_ejecutor)

end subroutine

public subroutine wf_retrieve (long al_nro_parte);/*****************************************/
/*      Recuperacion de Información      */
/*****************************************/
Long   ll_item
String ls_tdoc,ls_ndoc,ls_labor,ls_ejecutor

dw_master.Retrieve(al_nro_parte)

tab_1.tabpage_1.dw_detail.Retrieve(al_nro_parte)

tab_1.tabpage_1.dw_detart.Retrieve(al_nro_parte,1)
tab_1.tabpage_2.dw_detinc.Retrieve(al_nro_parte,1)
tab_1.tabpage_3.dw_detasis.Retrieve(al_nro_parte,1)
tab_1.tabpage_4.dw_causas.Retrieve(al_nro_parte)

/**/
dw_master.il_row = 1

IF tab_1.tabpage_1.dw_detail.Rowcount() > 0 THEN
	/*Primer Registro*/
	ll_item  	= tab_1.tabpage_1.dw_detail.Object.nro_item     [1]
	ls_tdoc  	= tab_1.tabpage_1.dw_detail.Object.tipo_doc		[1]
	ls_ndoc  	= tab_1.tabpage_1.dw_detail.Object.nro_orden		[1]
	ls_labor 	= tab_1.tabpage_1.dw_detail.Object.cod_labor		[1]
	ls_ejecutor = tab_1.tabpage_1.dw_detail.Object.cod_ejecutor [1]
	wf_filter_dws (ll_item)
	wf_retrieve_operaciones (ls_tdoc,ls_ndoc,ls_labor,ls_ejecutor)

	
END IF
end subroutine

public subroutine wf_filter_dws (long al_item);String ls_expresion
	

ls_expresion = 'nro_item = '+Trim(String(al_item))

IF Not(Isnull(ls_expresion) OR Trim(ls_expresion) = '') THEN
	tab_1.tabpage_1.dw_detart.Setfilter(ls_expresion)
	tab_1.tabpage_2.dw_detinc.Setfilter(ls_expresion)
	tab_1.tabpage_3.dw_detasis.Setfilter(ls_expresion)
	tab_1.tabpage_4.dw_causas.Setfilter(ls_expresion)
	
	tab_1.tabpage_1.dw_detart.filter ()
	tab_1.tabpage_2.dw_detinc.filter ()
	tab_1.tabpage_3.dw_detasis.filter()
	tab_1.tabpage_4.dw_causas.filter ()
END IF

end subroutine

on w_ma303_parte_ot.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master_list" then this.MenuID = create m_abc_master_list
this.cb_2=create cb_2
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_parte=create sle_parte
this.dw_operaciones=create dw_operaciones
this.tab_1=create tab_1
this.dw_master=create dw_master
this.r_1=create r_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_2
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.sle_parte
this.Control[iCurrent+5]=this.dw_operaciones
this.Control[iCurrent+6]=this.tab_1
this.Control[iCurrent+7]=this.dw_master
this.Control[iCurrent+8]=this.r_1
end on

on w_ma303_parte_ot.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_2)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_parte)
destroy(this.dw_operaciones)
destroy(this.tab_1)
destroy(this.dw_master)
destroy(this.r_1)
end on

event ue_open_pre();Long ll_nro_parte

dw_master.SetTransObject(sqlca)
dw_operaciones.SetTransObject(sqlca)
tab_1.tabpage_1.dw_lista.SetTransObject(sqlca)
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_1.dw_detart.SetTransObject(sqlca)
tab_1.tabpage_2.dw_detinc.SetTransObject(sqlca)
tab_1.tabpage_3.dw_detasis.SetTransObject(sqlca)
tab_1.tabpage_4.dw_causas.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija

/********************************/
/*Recuperacion de Ultimo Numero */
/********************************/
SELECT nro_parte
  INTO :ll_nro_parte
  FROM pd_ot
 WHERE rowid in (select max(rowid) from pd_ot);
 
IF Isnull(ll_nro_parte) THEN
	TriggerEvent('ue_insert')
ELSE
	wf_retrieve (ll_nro_parte)	
END IF
 
 
//ib_log = TRUE
ib_log = FALSE
is_tabla_1 = 'Cab_parte'
is_tabla_2 = 'Det_parte'
is_tabla_3 = 'Art_parte'
is_tabla_4 = 'Inc_parte'
is_tabla_5 = 'Tra_parte'
is_tabla_6 = 'Cau_parte'

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
dw_operaciones.width = newwidth - dw_operaciones.x - 10


end event

event ue_insert();Long  ll_row

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
		CASE	dw_operaciones
				Return
END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

end event

event ue_dw_share();call super::ue_dw_share;tab_1.tabpage_1.dw_lista.of_share_lista(tab_1.tabpage_1.dw_detail)
end event

event ue_update_pre();Long	 ll_nro_ot,ll_row_master,ll_inicio_item,ll_item,ll_inicio,ll_row_det_old,&
		 ll_item_old,ll_nro_parte_det

String ls_mensaje,ls_hinicio_inc,ls_hfinal_inc,ls_desc_inc,&
		 ls_cod_art,ls_cod_incidencia,ls_cod_trab,ls_cod_causa,ls_cierre

Decimal {2} ldc_horas_inc    = 0.00,ldc_total_hinc  = 0.00,ldc_costo_x_hora = 0.00, &
				ldc_total_x_hora = 0.00,ldc_costo_x_ins = 0.00,ldc_total_x_ins = 0.00

Datetime ldt_finicio,ldt_ffinal

Long ln_ano, ln_mes

Date ld_fecha

ll_row_master = dw_master.getrow()

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

ln_ano = year(ld_fecha)
ln_mes = month(ld_fecha)

SELECT USF_CNT_CIERRE_CNTBL(:ln_ano, :ln_mes, 'F') INTO :ls_cierre FROM dual ;

IF ls_cierre = '0' THEN
	MESSAGEBOX('Mes contable cerrado','No se puede actualizar datos')
   ib_update_check = False	
	return
END IF

IF is_accion = 'new' THEN
	/**Encuentro Nro de Parte Diario de OT**/
	IF wf_nro_doc (ll_nro_ot,ls_mensaje) = FALSE THEN
		Messagebox('Aviso',ls_mensaje)
		ib_update_check = False	
		Return
	ELSE
		dw_master.Object.nro_parte [ll_row_master] = ll_nro_ot
	END IF
ELSE
	ll_nro_ot = dw_master.Object.nro_parte [ll_row_master]
END IF

/*Fila Detalle old*/
ll_row_det_old = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row_det_old > 0 THEN
   ll_item_old = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row_det_old]
END IF


FOR ll_inicio_item = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ll_nro_parte_det = tab_1.tabpage_1.dw_detail.Object.nro_parte [ll_inicio_item]	
	 
	 IF Isnull(ll_nro_parte_det) THEN
		 tab_1.tabpage_1.dw_detail.Object.nro_parte [ll_inicio_item] = ll_nro_ot
	 ELSE
		 IF is_accion = 'new' THEN
			 tab_1.tabpage_1.dw_detail.Object.nro_parte [ll_inicio_item] = ll_nro_ot
		 END IF
	 END IF
	 
	 
	 
	 ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [ll_inicio_item]
	 ldc_total_hinc   = 0.00 //Inicialización
	 ldc_horas_inc    = 0.00  
	 ldc_costo_x_hora = 0.00
	 ldc_total_x_hora = 0.00
	 ldc_costo_x_ins  = 0.00
	 ldc_total_x_ins  = 0.00
	 
	 wf_filter_dws (ll_item)
	 
	 /*Detalle de Articulos x Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detart.Rowcount()
		  ll_nro_parte_det = tab_1.tabpage_1.dw_detart.Object.nro_parte [ll_inicio]	
		  
		  IF Isnull(ll_nro_parte_det) THEN
		     tab_1.tabpage_1.dw_detart.Object.nro_parte [ll_inicio] = ll_nro_ot
	     ELSE
		     IF is_accion = 'new' THEN
			     tab_1.tabpage_1.dw_detart.Object.nro_parte [ll_inicio] = ll_nro_ot
		     END IF
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
        
		  /*Costo x Insumos*/
		  ldc_costo_x_ins = tab_1.tabpage_1.dw_detart.object.total_x_ins [ll_inicio]
		  ldc_total_x_ins = ldc_total_x_ins + ldc_costo_x_ins 
		  IF Isnull(ldc_total_x_ins) THEN ldc_total_x_ins = 0.00
	 NEXT

	 /*Incidencias Por Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_detinc.Rowcount()
		  
  		  ll_nro_parte_det = tab_1.tabpage_2.dw_detinc.Object.nro_parte [ll_inicio]	
		  
		  IF Isnull(ll_nro_parte_det) THEN
		     tab_1.tabpage_2.dw_detinc.Object.nro_parte [ll_inicio] = ll_nro_ot
	     ELSE
		     IF is_accion = 'new' THEN
			     tab_1.tabpage_2.dw_detinc.Object.nro_parte [ll_inicio] = ll_nro_ot
		     END IF
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
	 
		  ldt_finicio = tab_1.tabpage_2.dw_detinc.object.fecha_inicio [ll_inicio]
		  ldt_ffinal  = tab_1.tabpage_2.dw_detinc.object.fecha_fin    [ll_inicio]
		  
		  /*Función de Resta de Fechas*/
		  DECLARE PB_USF_MTT_FECHA_HORA PROCEDURE FOR USF_MTT_FECHA_HORA 
		  (:ldt_finicio,:ldt_ffinal);
		  EXECUTE PB_USF_MTT_FECHA_HORA ;

		  IF SQLCA.SQLCode = -1 THEN 
			  MessageBox("SQL error", SQLCA.SQLErrText)
		  END IF

		  FETCH PB_USF_MTT_FECHA_HORA INTO :ldc_horas_inc ;
		  CLOSE PB_USF_MTT_FECHA_HORA ;			
        
		  
		  IF Isnull(ldc_total_hinc) THEN ldc_total_hinc = 0.00
		  IF Isnull(ldc_horas_inc)  THEN ldc_horas_inc  = 0.00
		  
		  
		  ldc_total_hinc = ldc_total_hinc + ldc_horas_inc  	
		  
		  IF Isnull(ldc_total_hinc)  THEN ldc_total_hinc  = 0.00
		  
	 NEXT

	 
	 /*Asistencia x Item*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_3.dw_detasis.Rowcount()
		
		  ll_nro_parte_det = tab_1.tabpage_3.dw_detasis.Object.no_parte [ll_inicio]	
		  
		  IF Isnull(ll_nro_parte_det) THEN
		     tab_1.tabpage_3.dw_detasis.Object.no_parte [ll_inicio] = ll_nro_ot
	     ELSE
		     IF is_accion = 'new' THEN
			     tab_1.tabpage_3.dw_detasis.Object.no_parte [ll_inicio] = ll_nro_ot
		     END IF
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
		  
		  /*Costo x hora*/
  		  ldc_costo_x_hora = tab_1.tabpage_3.dw_detasis.object.total_hora [ll_inicio]
		  IF Isnull(ldc_costo_x_hora)	 THEN ldc_costo_x_hora = 0.00
		  ldc_total_x_hora = ldc_total_x_hora + ldc_costo_x_hora
		  IF Isnull(ldc_total_x_hora)	 THEN ldc_total_x_hora = 0.00
					  
	 NEXT
	 

		 /*Costo x Item Labor*/
		 tab_1.tabpage_1.dw_detail.Object.costo_labor  [ll_inicio_item]  = ldc_total_x_ins + ldc_total_x_hora
		 /*Horas de Incidencia*/
		 tab_1.tabpage_1.dw_detail.Object.horas_inciden [ll_inicio_item] = ldc_total_hinc
	
	 /*Causa de Fallas*/
	 FOR ll_inicio = 1 TO tab_1.tabpage_4.dw_causas.Rowcount()
 		  ll_nro_parte_det = tab_1.tabpage_4.dw_causas.Object.nro_parte [ll_inicio]	
		  
		  IF Isnull(ll_nro_parte_det) THEN
		     tab_1.tabpage_4.dw_causas.Object.nro_parte [ll_inicio] = ll_nro_ot
	     ELSE
		     IF is_accion = 'new' THEN
			     tab_1.tabpage_4.dw_causas.Object.nro_parte [ll_inicio] = ll_nro_ot
		     END IF
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
	 
NEXT

IF ll_item_old > 0 THEN
	wf_filter_dws (ll_item_old)
	tab_1.tabpage_1.dw_detail.Scrolltorow(ll_row_det_old)
	tab_1.tabpage_1.dw_detail.Setrow(ll_row_det_old)
END IF
end event

event ue_update_request();Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 					   OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	 tab_1.tabpage_1.dw_detart.ii_update  = 1 OR tab_1.tabpage_2.dw_detinc.ii_update = 1 OR &
	 tab_1.tabpage_3.dw_detasis.ii_update = 1 OR tab_1.tabpage_4.dw_causas.ii_update = 1  ) THEN
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
	END IF
END IF
end event

event ue_update();call super::ue_update;Boolean lbo_ok = TRUE
Long    ll_row_det_old,ll_item_old

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_1.dw_detart.AcceptText()
tab_1.tabpage_2.dw_detinc.AcceptText()
tab_1.tabpage_3.dw_detasis.AcceptText()
tab_1.tabpage_4.dw_causas.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN
	Rollback;
	RETURN
END IF

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
	is_accion = 'fileopen'

	/***Recupero Operaciones Coincidentes***/
	String ls_cod_labor,ls_cod_ejecutor,ls_tipo_doc = 'OT',ls_nro_doc
	Long   ll_row
	IF tab_1.tabpage_1.dw_detail.Getrow() > 0 THEN
		ll_row = tab_1.tabpage_1.dw_detail.Getrow()
		ls_cod_labor	 = tab_1.tabpage_1.dw_detail.Object.cod_labor	 [ll_row]
		ls_cod_ejecutor = tab_1.tabpage_1.dw_detail.Object.cod_ejecutor [ll_row]
		ls_tipo_doc 	 = tab_1.tabpage_1.dw_detail.Object.tipo_doc 	 [ll_row]
		ls_nro_doc		 = tab_1.tabpage_1.dw_detail.Object.nro_orden 	 [ll_row]
	END IF
	/**************/
	wf_retrieve_operaciones (ls_tipo_doc,ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)	
	
	
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_retrieve_list();call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
sg_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = "d_abc_lista_pd_ot_tbl"
sl_param.titulo = "Partes Diario de Orden de Trabajo"
sl_param.field_ret_i[1] = 1


OpenWithParm( w_search, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	wf_retrieve (Long(sl_param.field_ret[1]))	
	is_accion = 'fileopen'

END IF

end event

event ue_modify();dw_master.of_protect()
tab_1.tabpage_1.dw_detail.of_protect()
tab_1.tabpage_1.dw_detart.of_protect()
tab_1.tabpage_2.dw_detinc.of_protect()
tab_1.tabpage_3.dw_detasis.of_protect()
tab_1.tabpage_4.dw_causas.of_protect()

tab_1.tabpage_1.dw_detail.Modify("cod_origen.Protect='1~tIf(IsRowNew(),0,1)'")
tab_1.tabpage_1.dw_detail.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event ue_delete();//OVERRIDE
Long  ll_row


IF idw_1 = dw_master OR Isnull(idw_1)THEN 
	Return
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

event ue_insert_pos(long al_row);call super::ue_insert_pos;IF idw_1 = tab_1.tabpage_1.dw_detail THEN
	tab_1.tabpage_1.dw_detail.SetColumn('cod_origen')
END IF	
end event

type cb_2 from commandbutton within w_ma303_parte_ot
integer x = 3013
integer y = 424
integer width = 302
integer height = 72
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Refresca"
end type

event clicked;Integer li_nro_parte, li_nro_item, li_row_lista

li_nro_parte = dw_master.GetItemNumber( dw_master.GetRow(), 'nro_parte' )
li_row_lista = tab_1.tabpage_1.dw_lista.GetRow()
tab_1.tabpage_1.dw_detail.Retrieve(li_nro_parte)

// Ubicandose en fila de la lista
tab_1.tabpage_1.dw_lista.SetRow(li_row_lista)
tab_1.tabpage_1.dw_detail.Setrow(li_row_lista)
tab_1.tabpage_1.dw_detail.ScrollToRow(li_row_lista)


end event

type cb_1 from commandbutton within w_ma303_parte_ot
integer x = 727
integer y = 28
integer width = 343
integer height = 76
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
ll_nro_parte = Long(ls_parte)

wf_retrieve (ll_nro_parte)	

end event

type st_1 from statictext within w_ma303_parte_ot
integer x = 46
integer y = 28
integer width = 302
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Parte diario:"
boolean border = true
boolean focusrectangle = false
end type

type sle_parte from singlelineedit within w_ma303_parte_ot
integer x = 361
integer y = 28
integer width = 343
integer height = 76
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 12632256
end type

type dw_operaciones from u_dw_abc within w_ma303_parte_ot
integer x = 1513
integer y = 16
integer width = 1902
integer height = 368
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

type tab_1 from tab within w_ma303_parte_ot
integer x = 9
integer y = 412
integer width = 3419
integer height = 1488
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
end type

on tab_1.create
this.tabpage_1=create tabpage_1
this.tabpage_2=create tabpage_2
this.tabpage_3=create tabpage_3
this.tabpage_4=create tabpage_4
this.Control[]={this.tabpage_1,&
this.tabpage_2,&
this.tabpage_3,&
this.tabpage_4}
end on

on tab_1.destroy
destroy(this.tabpage_1)
destroy(this.tabpage_2)
destroy(this.tabpage_3)
destroy(this.tabpage_4)
end on

event selectionchanged;Long ll_row, ll_nro_parte, ll_item

ll_row = tab_1.tabpage_1.dw_detail.Getrow()

IF ll_row = 0 THEN RETURN

ll_nro_parte = tab_1.tabpage_1.dw_detail.object.nro_parte [ll_row]
ll_item = tab_1.tabpage_1.dw_detail.object.nro_item [ll_row]

wf_filter_dws (ll_item)


CHOOSE CASE newindex
		 CASE 1
				if oldindex = 3 then
					setmicrohelp('tab1')	
			   end if
END CHOOSE


//tab_1.tabpage_2.dw_detinc.Retrieve( ll_nro_parte, ll_item )

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1368
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
integer height = 1124
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
integer y = 912
integer width = 2610
integer height = 432
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

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, FALSE)
This.SelectRow(currentrow, TRUE)
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_row, ll_nro_item, ll_nro_parte
Date ld_fecha
ll_row = dw_detail.GetRow()
IF ll_row > 0 THEN
	idw_mst.il_row = 1
ELSE
	return
END IF 

//messagebox('Fila', ll_row)
ll_nro_item = dw_detail.GetItemNumber(ll_row, 'nro_item')
ll_nro_parte = dw_detail.GetItemNumber(ll_row, 'nro_parte')
//messagebox('Item', ll_nro_item)
this.SetItem(al_row, 'nro_item', ll_nro_item)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot ,ls_cod_labor, ls_cod_art
Decimal {2} ld_costo_insumo
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


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
					Setitem(row,'cod_art',lstr_seleccionar.param1[1])
					Setitem(row,'nom_articulo',lstr_seleccionar.param2[1])
					Setitem(row,'und',lstr_seleccionar.param3[1])
					ls_cod_art = lstr_seleccionar.param1[1]
					
					select nvl(costo_ult_compra,0) into :ld_costo_insumo 
					from articulo where cod_art = ls_cod_art ;
					Setitem(row,'costo_insumo', ld_costo_insumo )
					ii_update = 1
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
integer x = 919
integer y = 12
integer width = 2610
integer height = 892
integer taborder = 20
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

event clicked;call super::clicked;Long   ll_row
String ls_cod_labor, ls_cod_ejecutor, ls_cod_origen, ls_nro_orden, ls_cod_maquina
sg_parametros sl_param
				
idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


CHOOSE CASE dwo.name
		 CASE 'b_ref'  //Busqueda de Ordenes de Trabajo
				sl_param.dw1    = 'd_abc_lista_orden_trabajo_tbl'
				sl_param.titulo = 'Orden de Trabajo'
				sl_param.field_ret_i[1] = 1
				sl_param.field_ret_i[2] = 2

				OpenWithParm( w_search, sl_param)

				sl_param = Message.PowerObjectParm
				IF sl_param.titulo <> 'n' THEN
					ls_cod_labor 	 = This.Object.cod_labor    [row]
					ls_cod_ejecutor = This.Object.cod_ejecutor [row]
					
					
					This.object.cod_origen [row] = sl_param.field_ret[1]
					This.object.tipo_doc   [row] = 'OT'
					This.object.nro_orden  [row] = sl_param.field_ret[2]
					
					//Recupero Operaciones
					wf_retrieve_operaciones ('OT',sl_param.field_ret[2],ls_cod_labor,ls_cod_ejecutor)
					
					ls_cod_origen = sl_param.field_ret[1]
					ls_nro_orden = sl_param.field_ret[2]
					
					SELECT cod_maquina
					  INTO :ls_cod_maquina
					  FROM orden_trabajo ot
					 WHERE ot.cod_origen = :ls_cod_origen AND
							 ot.nro_orden  = :ls_nro_orden ;
				
					tab_1.tabpage_1.dw_detail.SetItem(row, 'cod_maquina', ls_cod_maquina)
				
			END IF

END CHOOSE
end event

event itemchanged;call super::itemchanged;Decimal {2} ldc_seg,ldc_hrs
Long			ll_count
String      ls_descripcion,ls_codigo      , ls_nro_doc    , ls_tipo_doc, &
		      ls_cod_labor  ,ls_cod_ejecutor, ls_desc_maq   , ls_cod_origen,&
				ls_und_hr	  ,ls_und			, ls_cod_maquina
time        lt_hora_inicio,lt_hora_fin
Accepttext()

/*unidades hora*/
SELECT und_hr INTO :ls_und_hr FROM prod_param WHERE reckey = '1' ;

CHOOSE CASE dwo.name
		 CASE	'cod_origen'
				ls_cod_labor 	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				ls_cod_origen	 = This.Object.cod_origen   [row]
				ls_tipo_doc	    = This.Object.tipo_doc     [row]
				ls_nro_doc		 = This.Object.nro_orden    [row] 				
				
				//Recupero Operaciones
				wf_retrieve_operaciones (ls_tipo_doc,data,ls_cod_labor,ls_cod_ejecutor)
			
		 CASE	'nro_orden'
				ls_cod_labor 	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				ls_cod_origen	 = This.Object.cod_origen   [row]
				ls_tipo_doc	    = This.Object.tipo_doc    [row]
				
				//Recupero Operaciones
				wf_retrieve_operaciones (ls_tipo_doc,data,ls_cod_labor,ls_cod_ejecutor)

				SELECT cod_maquina
				INTO :ls_cod_maquina
				FROM orden_trabajo ot
				WHERE ot.cod_origen = :ls_cod_origen AND
						ot.nro_orden  = :data ;
				
				THIS.SetItem(row, 'cod_maquina', ls_cod_maquina)
				
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
				/*Recupero operaciones*/
				ls_nro_doc  	 = This.Object.nro_orden    [row]
				ls_tipo_doc 	 = This.Object.tipo_doc     [row]
				ls_cod_labor	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				
				wf_retrieve_operaciones ('OT',ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
				/**/
				SELECT Count(*)
				  INTO :ll_count
				  FROM labor
				 WHERE (cod_labor = :data) ;
				 
				IF ll_count > 0 THEN
					SELECT desc_labor
					  INTO :ls_descripcion
					  FROM labor
					 WHERE (cod_labor = :data) ;
					 
					This.object.desc_labor [row] = ls_descripcion
				ELSE
					SetNull(ls_codigo)
					SetNull(ls_descripcion)
					
					This.Object.cod_labor  [row] = ls_codigo
					This.Object.desc_labor [row] = ls_descripcion
					
					Messagebox('Aviso','Codigo de Labor No existe, Verifique!')
					Return 1
					
				END IF
		 CASE 'cod_ejecutor'
				/*Recupero operaciones*/
				ls_nro_doc  	 = This.Object.nro_orden    [row]
				ls_tipo_doc 	 = This.Object.tipo_doc     [row]
				ls_cod_labor	 = This.Object.cod_labor    [row]
				ls_cod_ejecutor = This.Object.cod_ejecutor [row]
				wf_retrieve_operaciones ('OT',ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
				/**/

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
 		  	  		//This.object.cant_labor [row] = ldc_hrs			  
			  END IF
			
		CASE 'hora_fin'	
			  
			  ls_und = This.object.labor_und [row]
			  
			  IF ls_und = ls_und_hr THEN	
			  	  lt_hora_inicio = Time(String(This.object.hora_inicio [row],'hh:mm:ss'))
			  	  lt_hora_fin	  = Time(String(This.object.hora_fin    [row],'hh:mm:ss'))
			  
			  	  ldc_seg = Round(SecondsAfter ( lt_hora_inicio, lt_hora_fin ) / 60 ,2)
			     // This.object.cant_labor [row] = ldc_hrs
					
				END IF
END CHOOSE



end event

event itemerror;call super::itemerror;Return 1
end event

event dragdrop;Dragobject ldo_control
Long       ll_fila,ll_oper_sec,ll_item,ll_count
Integer	  li_opcion	
DataWindow ldw_drag
String 	  ls_cod_labor,ls_cod_ejecutor,ls_desc_labor,ls_und,&
			  ls_desc_eje,ls_tipo_doc,ls_nro_doc	
		

ldo_control = DraggedObject()

IF ldo_control.typeof() = Datawindow! THEN
	ldw_drag = ldo_control
	IF ldw_drag.dataobject = 'd_abc_operaciones_orden_trabajo_tbl' THEN
		ll_fila = ldw_drag.Getrow()
		IF ll_fila > 0 THEN
			ll_oper_sec		 = ldw_drag.Object.oper_sec     [ll_fila]
			ls_cod_labor 	 = ldw_drag.Object.cod_labor    [ll_fila]
			ls_cod_ejecutor = ldw_drag.Object.cod_ejecutor [ll_fila]
			ls_tipo_doc		 = This.Object.tipo_doc  [row]
			ls_nro_doc		 = This.Object.nro_orden [row]
			ll_item			 = This.Object.nro_item  [row]
			
			This.object.cod_labor    [row] = ldw_drag.Object.cod_labor    [ll_fila]
			This.object.cod_ejecutor [row] = ldw_drag.Object.cod_ejecutor [ll_fila]
			This.object.proveedor    [row] = ldw_drag.Object.proveedor    [ll_fila]
			This.object.oper_sec		 [row] = ldw_drag.Object.oper_sec     [ll_fila]
			
			/**Descripcion de Labor    */
			SELECT desc_labor,und
			  INTO :ls_desc_labor,:ls_und
			  FROM labor
			 WHERE (cod_labor = :ls_cod_labor) ;
			 
			/**Descripcion de Ejecutor */
			SELECT descripcion
			  INTO :ls_desc_eje
			  FROM ejecutor
			 WHERE (cod_ejecutor = :ls_cod_ejecutor) ;
			
			This.Object.desc_labor 				[row] = ls_desc_labor
			This.Object.labor_und				[row] = ls_und
			This.Object.ejecutor_descripcion [row] = ls_desc_eje
			
			//Inserción de Articulos
			 SELECT Count (*)
			 	INTO :ll_count
		   	FROM articulo_mov_proy am,	
					  articulo          a
		     WHERE (am.cod_art  = a.cod_art    ) AND		
					 ((am.tipo_doc = :ls_tipo_doc ) AND
			 		  (am.nro_doc  = :ls_nro_doc  ) AND
			 		  (am.oper_sec = :ll_oper_sec )) ;
					
			IF ll_count > 0 THEN
				wf_insert_art_mov (ls_tipo_doc,ls_nro_doc,ll_oper_sec,ll_item)
			END IF
			
		END IF
	END IF
END IF





end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long    ll_row
String  ls_doc_ot
Integer li_item
Datetime 	ldt_fecha



ll_row = This.RowCount()
IF ll_row = 1 THEN 
	li_item = 0
ELSE
	li_item = Getitemnumber(ll_row - 1,"nro_item")
END IF
// Cambio porque al ingresar articulo se guardaba en el primer item de pd. ( vmori )
//ll_row = tab_1.tabpage_1.dw_detail.Getrow()
//li_item = tab_1.tabpage_1.dw_detail.GetItemNumber( ll_row, 'nro_item')
//this.SetItem(al_row, 'nro_item', li_item)


SELECT doc_ot
  INTO :ls_doc_ot
  FROM prod_param
 WHERE (reckey = '1') ;
   
This.SetItem(al_row, "nro_item", li_item + 1)  
ldt_fecha = dw_master.GetItemDateTime(dw_master.GetRow(), 'fecha' )
This.object.hora_inicio      [al_row] = ldt_fecha
This.object.hora_fin         [al_row] = ldt_fecha
This.object.tipo_doc         [al_row] = ls_doc_ot
This.object.flag_terminado   [al_row] = '0' //Activo
This.object.cant_labor   	  [al_row] = 0 
This.object.flag_conformidad [al_row] = 'B' //Bueno				
THIS.SetColumn('cod_origen')


This.Modify("cod_origen.Protect='1~tIf(IsRowNew(),0,1)'")
This.Modify("nro_orden.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event rowfocuschanged;Long 	 ll_item
String ls_expresion,ls_nro_doc,ls_cod_labor,ls_cod_ejecutor

IF currentrow = 0 THEN RETURN
ll_item 			 = This.object.nro_item 	 [currentrow]
ls_nro_doc	    = This.object.nro_orden	 [currentrow]
ls_cod_labor    = This.object.cod_labor    [currentrow]
ls_cod_ejecutor = This.object.cod_ejecutor [currentrow]


tab_1.tabpage_1.dw_lista.SetRow(currentrow)
tab_1.tabpage_1.dw_lista.ScrolltoRow(currentrow)

wf_filter_dws (ll_item)

wf_retrieve_operaciones ('OT',ls_nro_doc,ls_cod_labor,ls_cod_ejecutor)
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String     ls_name ,ls_prot , ls_cod_labor , ls_ejecutor ,&
			  ls_descripcion
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

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1368
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
integer width = 3072
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
String     ls_name ,ls_prot 
str_seleccionar lstr_seleccionar
Datawindow		 ldw	
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_incidencia'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT INCIDENCIAS_DMA.COD_INCIDENCIA  AS CODIGO_INCIDENCIA ,'&
								      				 +'INCIDENCIAS_DMA.DESC_INCIDENCIA AS DESCRIPCION, '&
														 +'INCIDENCIAS_DMA.TIPO_INCIDENCIA AS TIPO '&
									   				 +'FROM INCIDENCIAS_DMA '

				
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
integer height = 1368
long backcolor = 79741120
string text = "Trabajadores"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_detasis dw_detasis
end type

on tabpage_3.create
this.dw_detasis=create dw_detasis
this.Control[]={this.dw_detasis}
end on

on tabpage_3.destroy
destroy(this.dw_detasis)
end on

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

event itemchanged;call super::itemchanged;Long 	 ll_count
String ls_nombre,ls_codigo
Decimal {2} ldc_gan_fija,ldc_horas,ldc_min

Accepttext()
	

CHOOSE CASE dwo.name
		 CASE	'nro_horas' 
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				
		 CASE 'factor'
			   /*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				IF Dec(data) < 0 THEN
					This.Object.factor [row] = 0.00
					Return 2
				END IF
		 CASE 'cod_trabajador'
				/*Actualizar detalle de item */
				tab_1.tabpage_1.dw_detail.ii_update = 1
				
				SELECT Count(*)
				  INTO :ll_count
				  FROM proveedor
				 WHERE (proveedor = :data) ;
				
				IF ll_count > 0 THEN
					
					SELECT nom_proveedor
					  INTO :ls_nombre
					  FROM proveedor
					 WHERE (proveedor = :data) ;
					 
					This.Object.nom_trabajador [row] = ls_nombre
				
					SELECT Count(*)
				  	  INTO :ll_count
				  	  FROM maestro
				 	 WHERE (cod_trabajador = :data) ;
			 		
					
					IF ll_count > 0 THEN
						
						/** Sueldo de Trabajador **/
						SELECT Sum(Round(imp_gan_desc / 240 ,2))  
				     	  INTO :ldc_gan_fija  
				     	  FROM gan_desct_fijo  
				    	WHERE  ( cod_trabajador     = :data ) AND  
         				 	(( Substr(concep,1,1) = '1'   ) AND  
         				  	( flag_estado        = '1'   ) AND  
        					  	( flag_trabaj        = '1'   ))   
					   GROUP BY cod_trabajador  ;
					
						This.object.costo_horas [row] = ldc_gan_fija
						This.object.factor [row] = 1
					ELSE
						This.object.costo_horas [row] = 0
						This.object.factor [row] = 0
					END IF
					
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

String     ls_name ,ls_prot ,ls_nombre
str_seleccionar lstr_seleccionar
Decimal {2} ldc_gan_fija
Long ll_count
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_trabajador'
				lstr_seleccionar.s_seleccion = 'S'
			/*	lstr_seleccionar.s_sql = 'SELECT MAESTRO.COD_TRABAJADOR AS CODIGO_TRABAJADOR ,'&
								      				 +'MAESTRO.NOMBRE1 AS NOMBRES       ,'&
														 +'MAESTRO.APEL_PATERNO AS APELLIDO_PATERNO  ,'&
														 +'MAESTRO.APEL_MATERNO	AS APELLIDO_MATERNO  '&
									   				 +'FROM MAESTRO ' */

				lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO ,'&
								      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRE '&
									   				 +'FROM PROVEEDOR ' 
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					//ls_nombre = Trim(lstr_seleccionar.param2[1])+' '+Trim(lstr_seleccionar.param3[1])+' '+Trim(lstr_seleccionar.param4[1])
					ls_nombre = lstr_seleccionar.param2[1]
					Setitem(row,'cod_trabajador',lstr_seleccionar.param1[1])
					Setitem(row,'nom_trabajador',ls_nombre)
				
					SELECT count(*)
					  INTO :ll_count
					  FROM maestro
					 WHERE cod_trabajador = :lstr_seleccionar.param1[1] ;
					
					IF ll_count > 0 THEN
						/** Sueldo de Trabajador **/
						SELECT Sum(Round(imp_gan_desc / 240 ,2))  
				     	 INTO :ldc_gan_fija  
				     	 FROM gan_desct_fijo  
				    	 WHERE ( cod_trabajador     = :lstr_seleccionar.param1[1] ) AND  
         				 	(( Substr(concep,1,1) = '1'   ) AND  
         				  	( flag_estado        = '1'   ) AND  
        					  	( flag_trabaj        = '1'   ))   
					   GROUP BY cod_trabajador  ;
						
						This.object.costo_horas [row] = ldc_gan_fija	
						This.object.factor [row] = 1
					ELSE
						This.object.costo_horas [row] = 0
						This.object.factor [row] = 0
					END IF
					
					//actualiza cambios
					ii_update = 1
					
				END IF
			
				
END CHOOSE



end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)
end event

event ue_insert_pre(long al_row);call super::ue_insert_pre;Long ll_row
Integer li_item
ll_row = tab_1.tabpage_1.dw_detail.Getrow()
li_item = tab_1.tabpage_1.dw_detail.GetItemNumber( ll_row, 'nro_item')
this.SetItem(al_row, 'nro_item', li_item)
this.SetItem(al_row, 'nro_horas', 0)
this.SetItem(al_row, 'factor', 1)
end event

type tabpage_4 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3383
integer height = 1368
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

type dw_master from u_dw_abc within w_ma303_parte_ot
integer x = 18
integer y = 152
integer width = 1467
integer height = 244
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
String ls_codigo,ls_descripcion
Accepttext()


CHOOSE CASE dwo.name
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

type r_1 from rectangle within w_ma303_parte_ot
integer linethickness = 1
long fillcolor = 12632256
integer x = 23
integer y = 12
integer width = 1079
integer height = 120
end type

