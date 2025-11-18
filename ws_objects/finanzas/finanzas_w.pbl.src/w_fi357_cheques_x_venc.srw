$PBExportHeader$w_fi357_cheques_x_venc.srw
forward
global type w_fi357_cheques_x_venc from w_abc
end type
type cb_1 from commandbutton within w_fi357_cheques_x_venc
end type
type tab_1 from tab within w_fi357_cheques_x_venc
end type
type tabpage_1 from userobject within tab_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type tabpage_1 from userobject within tab_1
dw_detail dw_detail
end type
type tabpage_2 from userobject within tab_1
end type
type dw_asiento_det from u_dw_abc within tabpage_2
end type
type dw_asiento from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_asiento_det dw_asiento_det
dw_asiento dw_asiento
end type
type tab_1 from tab within w_fi357_cheques_x_venc
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type dw_master from u_dw_abc within w_fi357_cheques_x_venc
end type
end forward

global type w_fi357_cheques_x_venc from w_abc
integer width = 3758
integer height = 2028
string title = "Cheques Diferidos (FI357)"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
cb_1 cb_1
tab_1 tab_1
dw_master dw_master
n_cst_asiento_contable invo_cntbl_asiento
end type
global w_fi357_cheques_x_venc w_fi357_cheques_x_venc

type variables
String is_accion
Boolean ib_estado_preas = FALSE
DataStore ids_matriz_cntbl,ids_doc_pend_cta_cte,ids_doc_pend_adic_tbl
n_cst_asiento_contable invo_asiento_cntbl
end variables

forward prototypes
public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab)
public function decimal wf_calcular_total ()
public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio)
public subroutine wf_delete_doc_referencias ()
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row)
public function boolean wf_generacion_cntas ()
public function boolean wf_genera_letra (ref string as_mensaje)
end prototypes

event ue_anular();String  ls_flag_estado,ls_nro_certif
Long    ll_row        ,ll_inicio    ,ll_count
Integer li_opcion

dw_master.accepttext()

ll_row = dw_master.Getrow()


IF ll_row = 0 THEN 
	Messagebox('Aviso','No Existe Registro que Anular , Verifique!')
	RETURN
END IF	

ls_flag_estado = dw_master.object.flag_estado     [ll_row]


IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado Del Documento no Permitira Anular ')
	RETURN
END IF	

IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
    tab_1.tabpage_2.dw_asiento.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 ) THEN
	 Messagebox('Aviso','Grabe Los Cambios Antes de Anular el Documento')
	 RETURN
END IF	 

//------------------------------------------------
li_opcion = MessageBox('Anula Letras x Cobrar','Esta Seguro de Anular este Documento',Question!, Yesno!, 2)
IF li_opcion = 2 THEN RETURN
//------------------------------------------------


dw_master.deleterow(ll_row)


tab_1.tabpage_2.dw_asiento.object.flag_estado [1] = '0' //asiento anulado

FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movsol [ll_inicio] = 0.00
	 tab_1.tabpage_2.dw_asiento_det.object.imp_movdol [ll_inicio] = 0.00
NEXT

//eliminar el detalle
wf_delete_doc_referencias ()


dw_master.ii_update = 1
tab_1.tabpage_2.dw_asiento.ii_update     = 1
tab_1.tabpage_2.dw_asiento_det.ii_update = 1



is_accion = 'delete'

TriggerEvent('ue_modify')
/*No Generación Asientos*/
ib_estado_preas = FALSE
/**/		

end event

public subroutine wf_update_moneda_cab_det (string as_cod_moneda_cab);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.cod_moneda_cab [ll_inicio] = as_cod_moneda_cab
next


end subroutine

public function decimal wf_calcular_total ();String ls_cod_moneda,ls_soles,ls_dolares
Long   ll_inicio,ll_factor,ll_row_master
Decimal {2} ldc_monto_conv,ldc_importe_total
Decimal {3} ldc_tasa_cambio

dw_master.Accepttext()
tab_1.tabpage_1.dw_detail.Accepttext()


//Datos de Cabecera
ll_row_master = dw_master.Getrow()
ldc_tasa_cambio = dw_master.object.tasa_cambio [ll_row_master]
ls_cod_moneda   = dw_master.object.cod_moneda  [ll_row_master]


f_monedas(ls_soles,ls_dolares)

ldc_importe_total = 0.00

FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_monto_conv = tab_1.tabpage_1.dw_detail.object.monto_conv  [ll_inicio]	
	 ll_factor		 = tab_1.tabpage_1.dw_detail.object.factor      [ll_inicio]	
	 
	 
	 IF Isnull(ldc_monto_conv) THEN ldc_monto_conv = 0.00 
	 IF Isnull(ll_factor)      THEN ll_factor      = 0.00 

	 
	 ldc_importe_total = ldc_importe_total + (ldc_monto_conv * ll_factor)

	 
	 
NEXT				

Return ldc_importe_total
end function

public subroutine wf_update_tcambio_det (decimal adc_tasa_cambio);Long ll_inicio

for ll_inicio = 1 to tab_1.tabpage_1.dw_detail.Rowcount()

	 tab_1.tabpage_1.dw_detail.object.tasa_cambio [ll_inicio] = adc_tasa_cambio
	 tab_1.tabpage_1.dw_detail.ii_update = 1
next



end subroutine

public subroutine wf_delete_doc_referencias ();tab_1.tabpage_1.dw_detail.Accepttext()

DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.TriggerEvent('ue_delete')
LOOP


end subroutine

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_tipo_doc, string as_nro_doc, string as_cod_relacion, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		  ls_tipo_doc_ref,ls_nro_doc_ref,ls_cod_relacion,ls_flag_cebef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref, &
					 ls_flag_cod_rel,ls_flag_cebef)  THEN


	IF ls_flag_doc_ref = '1' THEN
		ls_tipo_doc_ref =	tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row]
		ls_nro_doc_ref  = tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row]
		
		/*Verifico tipo de Documento*/
		IF Isnull(ls_tipo_doc_ref) OR Trim(ls_tipo_doc_ref) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row] = as_tipo_doc
		END IF			
		/*Verifico Nro de Documento*/
		IF Isnull(ls_nro_doc_ref) OR Trim(ls_nro_doc_ref) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row] = as_nro_doc
		END IF
	ELSE
		SetNull(ls_tipo_doc_ref)
		SetNull(ls_nro_doc_ref)
		tab_1.tabpage_2.dw_asiento_det.object.tipo_docref1 [al_row] = ls_tipo_doc_ref
		tab_1.tabpage_2.dw_asiento_det.object.nro_docref1  [al_row] = ls_nro_doc_ref
	END IF

	IF ls_flag_cod_rel = '1' THEN
		ls_cod_relacion = tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row]
		/*Verifico Codigo de Relacion*/	
		IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
			tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row] = as_cod_relacion
		END IF
	ELSE
		SetNull(ls_cod_relacion)
		tab_1.tabpage_2.dw_asiento_det.object.cod_relacion [al_row] = ls_cod_relacion
	END IF	

ELSE
   lb_retorno = FALSE
END IF

///**/
Return lb_retorno
end function

public function boolean wf_generacion_cntas ();Boolean lb_ret = FALSE
String  ls_mensaje,ls_moneda,ls_nro_certificado
Long    ll_row
Decimal {3} ldc_tasa_cambio

ll_row   = dw_master.Getrow()

IF ll_row = 0 THEN RETURN lb_ret
dw_master.Accepttext()
	
ls_moneda 		    = dw_master.object.cod_moneda      [ll_row]
ldc_tasa_cambio    = dw_master.object.tasa_cambio     [ll_row]


IF Isnull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Algun Tipo de Moneda')
	dw_master.SetFocus()
	dw_master.Setcolumn('cod_moneda')
	Return lb_ret
END IF
	
IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')
	dw_master.SetFocus()
	dw_master.Setcolumn('tasa_cambio')
	Return lb_ret
END IF

	
//*Limpia DataStore*//
ids_matriz_cntbl.Reset()
ids_doc_pend_cta_cte.Reset()   
ids_doc_pend_adic_tbl.Reset()  


lb_ret = f_generacion_ctas (dw_master         ,tab_1.tabpage_1.dw_detail,tab_1.tabpage_2.dw_asiento_det,&
								          ids_matriz_cntbl  ,ids_doc_pend_cta_cte     ,ids_doc_pend_adic_tbl	      ,&
								          ls_nro_certificado,'C'							  ,is_accion							,&
									       ls_mensaje)
											 
IF lb_ret = FALSE THEN
	Messagebox('Aviso',ls_mensaje)
ELSE
	tab_1.tabpage_2.dw_asiento_det.ii_update =1	
END IF
Return lb_ret
end function

public function boolean wf_genera_letra (ref string as_mensaje);Long    ll_nro_doc
String  ls_lock_table
Boolean lb_retorno = TRUE


ls_lock_table = 'LOCK TABLE NUM_LET_COB IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;


SELECT ult_nro
  INTO :ll_nro_doc
  FROM num_let_cob
 WHERE origen = :gs_origen ;

	
IF Isnull(ll_nro_doc) OR ll_nro_doc = 0 THEN
	lb_retorno = FALSE
	as_mensaje = 'Numerador de Letra x Cobrar esta Vacio, Verifique!'
	GOTO SALIDA
END IF
	//****************************//
	//Actualiza Tabla num_let_cob //
	//****************************//
	
   UPDATE num_let_cob
	SET 	 ult_nro = :ll_nro_doc + 1
	WHERE  origen = :gs_origen ;
	
	IF SQLCA.SQLCode = -1 THEN 
		as_mensaje = 'No se Pudo Actualizar Tabla num_let_cob , Verifique!'
		lb_retorno = FALSE
		GOTO SALIDA
	ELSE
		
		
		dw_master.object.nro_doc [1] =  Trim(gs_origen)+f_llena_caracteres('0',Trim(String(ll_nro_doc)),6)+'00'
	END IF	


SALIDA:

Return lb_retorno


end function

on w_fi357_cheques_x_venc.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.cb_1=create cb_1
this.tab_1=create tab_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.tab_1
this.Control[iCurrent+3]=this.dw_master
end on

on w_fi357_cheques_x_venc.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.tab_1)
destroy(this.dw_master)
end on

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10

tab_1.tabpage_1.dw_detail.height = newheight - tab_1.tabpage_1.dw_detail.y - 925
tab_1.tabpage_2.dw_asiento_det.width  = newwidth  - tab_1.tabpage_2.dw_asiento_det.x - 75
tab_1.tabpage_2.dw_asiento_det.height = newheight - tab_1.tabpage_2.dw_asiento_det.y - 925
end event

event ue_insert;call super::ue_insert;Long  ll_row

IF idw_1 = tab_1.tabpage_1.dw_detail AND dw_master.il_row = 0 THEN
	MessageBox("Error", "No ha seleccionado registro Maestro")
	RETURN
END IF


IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')
	IF ib_update_check = FALSE THEN RETURN
	is_accion = 'new'
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_asiento.Reset()
	tab_1.tabpage_2.dw_asiento_det.Reset()
	/*Generación Asientos*/
	ib_estado_preas = TRUE
ELSE
	Return
END IF

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)
end event

event ue_open_pre;call super::ue_open_pre;String  ls_doc_lp,ls_confin
Long    ll_nro_libro

dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento.SetTransObject(sqlca)
tab_1.tabpage_2.dw_asiento_det.SetTransObject(sqlca)

idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!			// indicar dw_detail como no activado


of_position_window(0,0)       			// Posicionar la ventana en forma fija



////** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl = Create Datastore
ids_matriz_cntbl.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl.SettransObject(sqlca)
//** **//
//** Datastore De Asientos Cta. Cte. **//
ids_doc_pend_cta_cte = Create Datastore
ids_doc_pend_cta_cte.DataObject = 'd_doc_pend_x_aplic_doc_tbl'
ids_doc_pend_cta_cte.SettransObject(sqlca)
//** **//

//** Datastore Doc Pendientes Cta CTE **//
ids_doc_pend_adic_tbl = Create Datastore
ids_doc_pend_adic_tbl.DataObject = 'd_pre_asiento_x_doc_tbl'
ids_doc_pend_adic_tbl.SettransObject(sqlca)
//** **//





//objecto para verificar cierre de mes contable
invo_asiento_cntbl = create n_cst_asiento_contable
end event

event ue_delete;//override

Long  ll_row


IF idw_1 = dw_master THEN RETURN

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

event ue_delete_pos;call super::ue_delete_pos;Long ll_row

//Generación de Asientos
ib_estado_preas = TRUE

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN

dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
dw_master.ii_update = 1

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1                  OR tab_1.tabpage_1.dw_detail.ii_update      = 1 OR &
	 tab_1.tabpage_2.dw_asiento.ii_update = 1 OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 )  THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update = 0
		tab_1.tabpage_2.dw_asiento.ii_update = 0
		tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;Long   ll_row_master    ,ll_ano   ,ll_mes,ll_nro_libro,ll_nro_asiento,ll_count_doc_ref,&
		 ll_count_asientos,ll_inicio
String   ls_soles      ,ls_dolares   ,ls_cod_origen,ls_cod_relacion,ls_tipo_doc,ls_nro_doc,&
		   ls_flag_situacion,ls_flag_estado,ls_cod_moneda,ls_obs		   ,ls_cod_usr     ,ls_result  ,ls_mensaje,&
			ls_cod_banco     ,ls_cnta_cntbl
Datetime ldt_fecha_emision,ldt_fecha_registro		 
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_total_doc,ldc_saldo_sol,ldc_saldo_dol,ldc_totsoldeb,ldc_totdoldeb,ldc_totsolhab,&
				ldc_totdolhab
dwItemStatus ldis_status

Boolean	lb_retorno

/*REPLICACION*/
dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion()
tab_1.tabpage_2.dw_asiento.of_set_flag_replicacion()
tab_1.tabpage_2.dw_asiento_det.of_set_flag_replicacion()



if is_accion = 'delete' then return

ll_row_master = dw_master.Getrow()

IF ll_row_master = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

//Verificación de Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	RETURN
ELSE
	ib_update_check = True
END IF



f_monedas(ls_soles,ls_dolares)




//Datos de Cabecera
ls_cod_origen      = dw_master.object.origen             [ll_row_master]
ll_ano      		 = dw_master.object.ano                [ll_row_master]
ll_mes      		 = dw_master.object.mes                [ll_row_master]
ll_nro_libro		 = dw_master.object.nro_libro          [ll_row_master]
ll_nro_asiento		 = dw_master.object.nro_asiento        [ll_row_master]
ls_cod_relacion	 = dw_master.object.cod_relacion       [ll_row_master]
ls_tipo_doc			 = dw_master.object.tipo_doc           [ll_row_master]
ls_nro_doc			 = dw_master.object.nro_doc            [ll_row_master]
ls_flag_situacion  = dw_master.object.flag_situacion_ltr [ll_row_master]
ldt_fecha_emision	 = dw_master.object.fecha_documento    [ll_row_master]
ls_flag_estado     = dw_master.object.flag_estado    	   [ll_row_master]
ls_cod_moneda 		 = dw_master.object.cod_moneda  		   [ll_row_master]
ldc_tasa_cambio    = dw_master.object.tasa_cambio    	   [ll_row_master]
ls_obs				 = dw_master.object.observacion    	   [ll_row_master]
ldt_fecha_registro = dw_master.object.fecha_registro     [ll_row_master]
ldc_total_doc		 = dw_master.object.importe_doc			[ll_row_master]


IF ls_cod_moneda = ls_soles THEN 
	ldc_saldo_sol = ldc_total_doc
	ldc_saldo_dol = Round(ldc_total_doc / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = ls_dolares THEN
	ldc_saldo_sol = Round(ldc_total_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_total_doc
END IF

//saldos
dw_master.object.saldo_sol [ll_row_master] = ldc_saldo_sol 
dw_master.object.saldo_dol [ll_row_master] = ldc_saldo_dol

/*verifica cierre de mes contable*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_result)
	ib_update_check = False	
	Return
END IF


IF ls_flag_situacion <> '1' THEN
	ls_cod_banco = dw_master.object.banco_ltr [ll_row_master]
	IF Isnull(ls_cod_banco) OR Trim(ls_cod_banco) = '' THEN
		Messagebox('Aviso','Debe Ingresar codigo de Banco , Verifique!')
		dw_master.SetFocus()
		dw_master.SetColumn('cod_banco')
		ib_update_check = FALSE
		RETURN
	END IF
END IF


//Asignación de Nro Libro
IF is_accion = 'new' THEN
	
	if Isnull(ls_nro_doc) or Trim(ls_nro_doc) = '' then
		Messagebox('Aviso','Debe Ingresar un Nro de Cheque , Verifique!')
		ib_update_check = FALSE
		RETURN
	end if
	
	/******/
	ll_nro_libro = f_nro_libro(ls_tipo_doc)	 
	
	IF Isnull(ll_nro_libro)  OR ll_nro_libro = 0 THEN
		ib_update_check = FALSE
		RETURN
	END IF
	/******/
	
	//verificacion de año y mes	
	IF Isnull(ll_ano) OR ll_ano = 0 THEN
		ib_update_check = False	
		Messagebox('Aviso','Ingrese Año Contable , Verifique!')
		Return
	END IF
	
	IF Isnull(ll_mes) OR ll_mes = 0 THEN
		ib_update_check = False	
		Messagebox('Aviso','Ingrese Mes Contable , Verifique!')
		Return
	END IF
	
	IF invo_cntbl_asiento.of_get_nro_asiento(ls_cod_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)  = FALSE THEN
		ib_update_check = False	
		Return
	ELSE
		dw_master.object.nro_asiento [1] = ll_nro_asiento 
		dw_master.object.nro_libro   [1] = ll_nro_libro
	END IF	
	
	//asignación de año y mes cab contable
	tab_1.tabpage_2.dw_asiento.Object.ano [1] = ll_ano
	tab_1.tabpage_2.dw_asiento.Object.mes [1] = ll_mes

END IF



/*Generación Pre-Asientos*/
IF ib_estado_preas THEN
	IF wf_generacion_cntas() = FALSE THEN
		ib_update_check = False	
		RETURN
	END IF
END IF

//Acumulador de Registro de doc Referencias
ll_count_doc_ref  = tab_1.tabpage_1.dw_detail.Rowcount()
//Acumulador de Registro de Pre Asientos
ll_count_asientos = tab_1.tabpage_2.dw_asiento_det.Rowcount()

//Documento de Referencia

IF ls_flag_estado = '1'  THEN
	IF ll_count_doc_ref = 0 THEN
		Messagebox('Aviso','Debe Ingresar Algun Tipo de Documento de Referencia')
		ib_update_check = FALSE
		RETURN
	END IF
	
END IF

//Asiento Detalle
IF ll_count_asientos = 0 THEN
	Messagebox('Aviso','Debe Revisar Concepto Financiero y Matriz Contable Ingresadas')	
	ib_update_check = FALSE
	RETURN
END IF


//Documento de Referencia
FOR ll_inicio = 1 TO ll_count_doc_ref
	 //REGISTRO NUEVOS ACTUALIZAR PK
    ldis_status = tab_1.tabpage_1.dw_detail.GetItemStatus(ll_inicio,0,Primary!)
    IF ldis_status = NewModified! THEN
	     tab_1.tabpage_1.dw_detail.Object.cod_relacion [ll_inicio] = ls_cod_relacion	
		  tab_1.tabpage_1.dw_detail.Object.tipo_doc     [ll_inicio] = ls_tipo_doc
		  tab_1.tabpage_1.dw_detail.Object.nro_doc      [ll_inicio] = ls_nro_doc
    END IF	 
NEXT

//Asigancion de Datos en Cabecera de Asiento
IF is_accion = 'new' THEN
	tab_1.tabpage_2.dw_asiento.Object.origen		 [1] = ls_cod_origen
	tab_1.tabpage_2.dw_asiento.Object.ano			 [1] = ll_ano
	tab_1.tabpage_2.dw_asiento.Object.mes			 [1] = ll_mes
	tab_1.tabpage_2.dw_asiento.Object.nro_libro	 [1] = ll_nro_libro
	tab_1.tabpage_2.dw_asiento.Object.nro_asiento [1] = ll_nro_asiento
END IF

//Asignacion de Datos En Asiento Detalle
FOR ll_inicio = 1 TO tab_1.tabpage_2.dw_asiento_det.Rowcount()
 	 ls_cnta_cntbl = tab_1.tabpage_2.dw_asiento_det.object.cnta_ctbl [ll_inicio]
	 
	 //REGISTRO NUEVOS ACTUALIZAR PK
    ldis_status = tab_1.tabpage_2.dw_asiento_det.GetItemStatus(ll_inicio,0,Primary!)
    IF ldis_status = NewModified! THEN
		 tab_1.tabpage_2.dw_asiento_det.object.origen		[ll_inicio] = ls_cod_origen
		 tab_1.tabpage_2.dw_asiento_det.object.ano			[ll_inicio] = ll_ano
		 tab_1.tabpage_2.dw_asiento_det.object.mes			[ll_inicio] = ll_mes
		 tab_1.tabpage_2.dw_asiento_det.object.nro_libro	[ll_inicio] = ll_nro_libro
		 tab_1.tabpage_2.dw_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 END IF
	
	 tab_1.tabpage_2.dw_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_emision
    IF wf_verifica_flag_cntas(ls_cnta_cntbl,ls_tipo_doc,ls_nro_doc,ls_cod_relacion,ll_inicio) = FALSE THEN
		 ib_update_check = FALSE
		 RETURN
	 END IF

NEXT

//Obtencion de Acumualdores en Pre Asiento Detalle
ldc_totsoldeb = tab_1.tabpage_2.dw_asiento_det.object.monto_soles_cargo	  [1]
ldc_totdoldeb = tab_1.tabpage_2.dw_asiento_det.object.monto_dolares_cargo [1]
ldc_totsolhab = tab_1.tabpage_2.dw_asiento_det.object.monto_soles_abono   [1]
ldc_totdolhab = tab_1.tabpage_2.dw_asiento_det.object.monto_dolares_abono [1]


//Datos Adicionales de Cabecera en Asiento
tab_1.tabpage_2.dw_asiento.Object.cod_moneda	  [1] = ls_cod_moneda
tab_1.tabpage_2.dw_asiento.Object.tasa_cambio  [1] = ldc_tasa_cambio
tab_1.tabpage_2.dw_asiento.Object.desc_glosa	  [1] = ls_obs
tab_1.tabpage_2.dw_asiento.Object.fec_registro [1] = ldt_fecha_registro
tab_1.tabpage_2.dw_asiento.Object.fecha_cntbl  [1] = ldt_fecha_emision
tab_1.tabpage_2.dw_asiento.Object.cod_usr		  [1] = ls_cod_usr
tab_1.tabpage_2.dw_asiento.Object.flag_estado  [1] = ls_flag_estado
tab_1.tabpage_2.dw_asiento.Object.tot_solhab	  [1] = ldc_totsolhab
tab_1.tabpage_2.dw_asiento.Object.tot_dolhab	  [1] = ldc_totdolhab
tab_1.tabpage_2.dw_asiento.Object.tot_soldeb	  [1] = ldc_totsoldeb
tab_1.tabpage_2.dw_asiento.Object.tot_doldeb	  [1] = ldc_totdoldeb

IF tab_1.tabpage_1.dw_detail.ii_update = 1  OR tab_1.tabpage_2.dw_asiento_det.ii_update = 1 THEN dw_master.ii_update = 1	
IF dw_master.ii_update = 1 THEN tab_1.tabpage_2.dw_asiento.ii_update = 1	


// valida asientos descuadrados
lb_retorno  = invo_asiento_cntbl.of_validar_asiento(tab_1.tabpage_2.dw_asiento_det)

IF lb_retorno = FALSE THEN
	ib_update_check = False	
	Return
END IF

end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE
String  ls_origen
Long    ll_row_det,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_2.dw_asiento.AcceptText()
tab_1.tabpage_2.dw_asiento_det.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

//ejecuta procedimiento de actualizacion de tabla temporal
IF tab_1.tabpage_2.dw_asiento_det.ii_update = 1 and is_accion <> 'new' THEN
	ll_row_det     = tab_1.tabpage_2.dw_asiento.Getrow()
	ls_origen      = tab_1.tabpage_2.dw_asiento.Object.origen      [ll_row_det]
	ll_ano         = tab_1.tabpage_2.dw_asiento.Object.ano         [ll_row_det]
	ll_mes         = tab_1.tabpage_2.dw_asiento.Object.mes         [ll_row_det]
	ll_nro_libro   = tab_1.tabpage_2.dw_asiento.Object.nro_libro   [ll_row_det]
	ll_nro_asiento = tab_1.tabpage_2.dw_asiento.Object.nro_asiento [ll_row_det]
	
	if f_insert_tmp_asiento(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento) = FALSE then
		Rollback ;
		Return
	end if	
END IF	


IF tab_1.tabpage_2.dw_asiento.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF tab_1.tabpage_2.dw_asiento.Update () = -1 THEN // Cabecera de Asiento
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Cabecera de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF	

IF tab_1.tabpage_2.dw_asiento_det.ii_update = 1 AND lbo_ok = TRUE THEN 
	IF tab_1.tabpage_2.dw_asiento_det.Update () = -1 THEN 
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle de Asiento","Se ha procedido al rollback",exclamation!)
	END IF
END IF
	
IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
      Rollback ;
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF tab_1.tabpage_1.dw_detail.ii_update = 1 AND lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
	   Rollback ;
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF	







IF lbo_ok THEN
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_asiento.ii_update = 0
	tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE
	Rollback ;
END IF
end event

event ue_insert_pos;call super::ue_insert_pos;tab_1.tabpage_2.dw_asiento.TriggerEvent('ue_insert')
dw_master.SetFocus ()
dw_master.SetColumn('nro_doc')

end event

event ue_retrieve_list;call super::ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio
String ls_tipo_doc
str_parametros sl_param

TriggerEvent ('ue_update_request')		

//recuepra cheques diferidos en parametros
select doc_cheque_dif into :ls_tipo_doc from finparam where reckey = '1' ;


sl_param.dw1    = 'd_abc_lista_letras_x_cobrar_tbl'
sl_param.titulo = 'Cheques con Vencimiento'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc
sl_param.field_ret_i[4] = 6	//Origen
sl_param.field_ret_i[5] = 7	//Año
sl_param.field_ret_i[6] = 8	//Mes
sl_param.field_ret_i[7] = 9	//Nro Libro
sl_param.field_ret_i[8] = 10	//Nro Asiento
sl_param.tipo    = '1SQL'
sl_param.string1 =  ' AND ("CNTAS_COBRAR"."TIPO_DOC" =  '+"'"+ls_tipo_doc+"'"+')    '&
						 +' AND ("CNTAS_COBRAR"."FLAG_ESTADO"   IN '+'('+"'"+'0'+"','"+'1'+"',"+"'"+'2'+"','"+'3'+"')"+')   '&
						 +' ORDER BY "CNTAS_COBRAR"."FECHA_DOCUMENTO" ASC  '

OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve('C',sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_1.dw_detail.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3],'C')
	tab_1.tabpage_2.dw_asiento.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))
	tab_1.tabpage_2.dw_asiento_det.Retrieve(sl_param.field_ret[4],Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]),Long(sl_param.field_ret[7]),Long(sl_param.field_ret[8]))

	ib_estado_preas = False   //pre-asiento editado					
	is_accion = 'fileopen'	
	TriggerEvent('ue_modify')

	
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_asiento.ii_update = 0
	tab_1.tabpage_2.dw_asiento_det.ii_update = 0
	
END IF

end event

event ue_modify;call super::ue_modify;Long    ll_row,ll_ano,ll_mes
String  ls_result,ls_mensaje,ls_flag_estado
Integer li_protect

ll_row = dw_master.Getrow()

IF ll_row = 0 THEN RETURN
//bloqueo
dw_master.of_protect()
tab_1.tabpage_1.dw_detail.of_protect()
tab_1.tabpage_2.dw_asiento_det.of_protect()



ls_flag_estado = dw_master.object.flag_estado [ll_row]
ll_ano         = dw_master.object.ano         [ll_row]
ll_mes         = dw_master.object.mes         [ll_row]


/*verifica cierre*/
invo_asiento_cntbl.of_val_mes_cntbl(ll_ano,ll_mes,'R',ls_result,ls_mensaje) 

IF ls_flag_estado = '1' THEN //ACTIVO Y NO TENGA RETENCIONES
   IF (ls_result = '1') THEN //MES CONTABLE ABIERTO
		IF is_accion <> 'new' THEN
		   li_protect = integer(dw_master.Object.nro_doc.Protect)
	   	IF li_protect = 0 THEN
				dw_master.Object.cod_relacion.Protect	  = 1
				dw_master.Object.tipo_doc.Protect		  = 1
		      dw_master.Object.nro_doc.Protect		     = 1
				dw_master.Object.ano.Protect			     = 1
				dw_master.Object.mes.Protect			     = 1
				//dw_master.Object.dias_a_cancelar.Protect = 1
		   END IF 
		END IF
	END IF
ELSE
	dw_master.ii_protect = 0
	tab_1.tabpage_1.dw_detail.ii_protect = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	
	//SI MES CONTABLE ESTA CERRADO O LETRA YA PASO A OTRO ESTADO DIFERENTE A GENERADO BLOQUEAR ASIENTO
	IF ls_flag_estado <> '1' OR ls_result = '0' THEN
		tab_1.tabpage_2.dw_asiento_det.ii_protect = 0
		tab_1.tabpage_2.dw_asiento_det.of_protect()
	END IF
END IF
end event

type cb_1 from commandbutton within w_fi357_cheques_x_venc
integer x = 3218
integer y = 32
integer width = 462
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Referencias"
end type

event clicked;str_parametros sl_param
String ls_cod_relacion,ls_cod_moneda,ls_flag_estado,ls_confin
Long   ll_row,ll_inicio
Decimal {3} ldc_tasa_cambio
Decimal {2} ldc_imp_total

ll_row = dw_master.Getrow ()

IF ll_row = 0 THEN 
	Messagebox('Aviso','Debe Ingresar Registro Algun Registro , Verifique!')
	RETURN
END IF

select confin_pago_masivo into :ls_confin from finparam where reckey = '1' ;


//recupero datos de la cabecera
ls_cod_relacion = dw_master.object.cod_relacion [ll_row]	
ls_cod_moneda	 = dw_master.object.cod_moneda   [ll_row]	
ldc_tasa_cambio = dw_master.object.tasa_cambio  [ll_row]	
ls_flag_estado	 = dw_master.object.flag_estado  [ll_row]	


//VERIFICAR ESTADO 
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso','Estado de la Letra no esta Disponible para realizar Modificaciones , Verifique!')
	Return
END IF	

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Relacion , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_relacion')
	Return
END IF

IF Isnull(ls_cod_moneda) OR Trim(ls_cod_moneda) = '' THEN
	Messagebox('Aviso','Deb Ingresar Un Codigo de Moneda , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('cod_moneda')
	Return
END IF

IF Isnull(ldc_tasa_cambio) OR ldc_tasa_cambio <= 0 THEN
	Messagebox('Aviso','Debe Ingresar Una Tasa de Cambio Valida , Verifique!')
	dw_master.SetFocus()
	dw_master.SetColumn('tasa_cambio')
	Return
END IF

sl_param.dw1		= 'd_abc_lista_doc_x_cobrar_tbl'
sl_param.titulo	= 'Documentos Pendientes x Proveedor '
sl_param.string1	= ls_cod_relacion
sl_param.string2	= ls_cod_moneda
sl_param.db2		= ldc_tasa_cambio
sl_param.tipo 		= '1CC'
sl_param.opcion   = 2 //canje de letras x Cobrar
sl_param.db1 		= 1600
sl_param.dw_m		= tab_1.tabpage_1.dw_detail


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_1.dw_detail.ii_update = 1
	dw_master.object.importe_doc [ll_row] = wf_calcular_total ()
	dw_master.ii_update = 1
	/*GENERACION DE ASIENTOS*/
	ib_estado_preas = TRUE
	
	FOR ll_inicio = 1 to tab_1.tabpage_1.dw_detail.rowcount()
		 tab_1.tabpage_1.dw_detail.object.confin [ll_inicio] = ls_confin
	NEXT
END IF
end event

type tab_1 from tab within w_fi357_cheques_x_venc
integer x = 37
integer y = 748
integer width = 3547
integer height = 1056
integer taborder = 20
integer textsize = -8
integer weight = 400
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

event selectionchanged;

CHOOSE CASE newindex
		 CASE 2
				IF ib_estado_preas = FALSE THEN RETURN
		 		wf_generacion_cntas()
END CHOOSE

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3511
integer height = 928
long backcolor = 79741120
string text = "  Documentos de Referencia"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "CreateRuntime!"
long picturemaskcolor = 536870912
dw_detail dw_detail
end type

on tabpage_1.create
this.dw_detail=create dw_detail
this.Control[]={this.dw_detail}
end on

on tabpage_1.destroy
destroy(this.dw_detail)
end on

type dw_detail from u_dw_abc within tabpage_1
integer x = 18
integer y = 16
integer width = 3246
integer height = 512
integer taborder = 20
string dataobject = "d_abc_doc_ref_cheques_x_venc_tbl"
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		
is_dwform = 'tabular'	// tabular, form (default)

ii_rk[1] = 1  // columnas que recibimos del master
ii_rk[2] = 2 	      
ii_rk[3] = 3 	      

ii_ck[1] = 1 // columnas de lectrua de este dw
ii_ck[2] = 2				
ii_ck[3] = 3				
ii_ck[4] = 4				
ii_ck[5] = 5				
ii_ck[6] = 6				
ii_ck[7] = 7				




idw_mst  = dw_master				
idw_det  = tab_1.tabpage_1.dw_detail

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;String ls_moneda_cab ,ls_cod_relacion ,ls_tipo_doc ,ls_nro_doc    ,ls_origen_ref,&
       ls_tipo_ref   ,ls_nro_ref      ,ls_accion   ,ls_flag_estado,ls_soles     ,&
		 ls_dolares    ,ls_moneda_det
		 
Decimal {2} ldc_importe,ldc_porc_ret_igv,ldc_imp_retencion
Decimal {3} ldc_tasa_cambio
Long   ll_row_master
dwItemStatus ldis_status


Accepttext()
//Generacion de Asientos Automaticos
ib_estado_preas = TRUE




choose case dwo.name
		 case 'importe'
						
				ll_row_master = dw_master.Getrow()
				
				/*Datos de cabecera*/
				ls_moneda_cab   = This.Object.cod_moneda_cab [row]
				ldc_tasa_cambio = This.Object.tasa_cambio	  [row]
				
				/**/
				ls_cod_relacion   = This.object.cod_relacion [row]
				ls_tipo_doc			= This.object.tipo_doc     [row]
				ls_nro_doc			= This.object.nro_doc      [row]
				ls_origen_ref		= This.object.origen_ref   [row]
				ls_tipo_ref			= This.object.tipo_ref     [row]
				ls_nro_ref			= This.object.nro_ref      [row]
				ldc_importe			= This.object.importe		[row]
				
				/*determinar estado del registro*/
				ldis_status = This.Getitemstatus( row,0,Primary!)
				IF ldis_status = NewModified! THEN
					ls_accion = 'new'
				ELSE
					ls_accion = 'fileopen'
				END IF
				
				f_verifica_monto_ref(ls_cod_relacion,ls_tipo_doc,ls_nro_doc,ls_origen_ref,ls_tipo_ref,ls_nro_ref,ls_accion,ldc_importe,ls_flag_estado)				
				
				
//				IF Trim(ls_flag_estado) = '1' THEN
//					Messagebox('Aviso','Se esta Excediendo en el monto establecido')
//					This.object.importe [row] = 0.00
//					Return 1
//				END IF
				
				//recalcular 
				dw_master.object.importe_doc [ll_row_master] = wf_calcular_total ()
				dw_master.ii_update = 1
				
				
				
end choose

end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 112
integer width = 3511
integer height = 928
long backcolor = 79741120
string text = " Asientos Contables"
long tabtextcolor = 33554432
long tabbackcolor = 79741120
string picturename = "Cursor!"
long picturemaskcolor = 536870912
dw_asiento_det dw_asiento_det
dw_asiento dw_asiento
end type

on tabpage_2.create
this.dw_asiento_det=create dw_asiento_det
this.dw_asiento=create dw_asiento
this.Control[]={this.dw_asiento_det,&
this.dw_asiento}
end on

on tabpage_2.destroy
destroy(this.dw_asiento_det)
destroy(this.dw_asiento)
end on

type dw_asiento_det from u_dw_abc within tabpage_2
integer x = 18
integer y = 16
integer width = 3474
integer height = 384
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7

ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3
ii_rk[4] = 4
ii_rk[5] = 5
ii_rk[6] = 6



idw_mst = tab_1.tabpage_2.dw_asiento
idw_det = tab_1.tabpage_2.dw_asiento_det
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemerror;call super::itemerror;Return 1
end event

event itemchanged;call super::itemchanged;accepttext()
ib_estado_preas = FALSE
end event

type dw_asiento from u_dw_abc within tabpage_2
integer x = 18
integer y = 464
integer width = 3474
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  //      'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)



ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3
ii_dk[4] = 4
ii_dk[5] = 5
ii_dk[6] = 6

idw_mst  = tab_1.tabpage_2.dw_asiento
idw_det  = tab_1.tabpage_2.dw_asiento_det
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!

end event

event itemchanged;call super::itemchanged;accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

type dw_master from u_dw_abc within w_fi357_cheques_x_venc
integer x = 37
integer y = 28
integer width = 3035
integer height = 684
string dataobject = "d_abc_cheque_x_vencimiento_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event constructor;call super::constructor;is_mastdet = 'md'		

is_dwform = 'form'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			

ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2
ii_dk[3] = 3



//idw_mst  = dw_master						 // dw_master
idw_det  = tab_1.tabpage_1.dw_detail // dw_detail

end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Long   ll_count 
String ls_prov,ls_nom,ls_prov_old,ls_flag_situacion,ls_codigo
Decimal {3} ldc_tasa_cambio
Decimal {2} ld_dias_a_canc
Date        ld_fecha_emision,ld_fecha_vencimiento,ld_fecha_emision_old

ls_prov_old          = This.object.cod_relacion  [row]
ld_fecha_emision_old = Date(This.Object.fecha_documento [row])

This.Accepttext()

//Generación de Asientos Automaticos
ib_estado_preas = TRUE

choose case dwo.name
		 case 'cod_moneda'
				/*Actualiza moneda de la cabecera en el detalle*/
			   wf_update_moneda_cab_det (data)
				dw_master.Object.importe_doc [row] = wf_calcular_total ()
		 case	'tasa_cambio'
				ldc_tasa_cambio = This.object.tasa_cambio [row]
				/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
				wf_update_tcambio_det(ldc_tasa_cambio)					
				dw_master.Object.importe_doc [row] = wf_calcular_total ()
				
		 case 'cod_relacion'

				IF tab_1.tabpage_1.dw_detail.rowcount() > 0 THEN
					IF ls_prov_old <> data THEN
						wf_delete_doc_referencias ()
						dw_master.Object.importe_doc [row] = wf_calcular_total ()
						dw_master.ii_update = 1
					END IF
				END IF
						
				select count(*) into :ll_count from proveedor where (proveedor = :data) and flag_estado = '1' ;
				
				IF ll_count = 0 THEN
					SetNull(ls_prov)
					This.object.cod_relacion  [row] = ls_prov
					This.object.nom_proveedor [row] = ls_prov
					Messagebox('Aviso','Debe Ingresar Un Proveedor Valido , Verifique!')
					Return 1
				ELSE
					
					
					select nom_proveedor into :ls_nom from proveedor where (proveedor = :data);					
					
					This.object.nom_proveedor [row] = ls_nom
				END IF
		 case 'fecha_documento'
				ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
				ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
				
				IF ld_fecha_emision > ld_fecha_vencimiento THEN
					This.Object.fecha_documento [row] = ld_fecha_emision_old
					Messagebox('Aviso','Fecha de Emisión del Documento No '&
											+'Puede Ser Mayor a la Fecha de Vencimiento')
					Return 1
				END IF
								
				ld_dias_a_canc   		= This.Object.dias_a_cancelar [row]
				IF Not(Isnull(ld_dias_a_canc) OR ld_dias_a_canc = 0) THEN //SI ES MAYOR QUE 0
					ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
					This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento				
				END IF	

				
				//Si es nuevo modifico el año y el mes
				if is_accion = 'new' THEN
					This.Object.ano [row] = Long(String(ld_fecha_emision,'YYYY'))
					This.Object.mes [row] = Long(String(ld_fecha_emision,'MM'))
				end if

				
			   This.Object.tasa_cambio	   [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
				
				ldc_tasa_cambio = This.Object.tasa_cambio	   [row]
				
				
				/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
				wf_update_tcambio_det(ldc_tasa_cambio)					
				dw_master.Object.importe_doc [row] = wf_calcular_total ()
				
				
       CASE 'dias_a_cancelar'   
				ld_fecha_emision = Date(This.Object.fecha_documento   [row])
				ld_dias_a_canc   = This.Object.dias_a_cancelar [row]
				ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
				This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento				
				
		 CASE 'fecha_vencimiento'	
		 		ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
				ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
				IF ld_fecha_vencimiento < ld_fecha_emision THEN
					This.Object.fecha_vencimiento [row] = ld_fecha_emision
					Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
											+'Puede Ser Menor a la Fecha de Emisión')
					Return 1
				END IF
		CASE 'banco_ltr'
			  ls_flag_situacion = This.Object.flag_situacion_ltr [row]
			  IF ls_flag_situacion = '1' THEN
				  SetNull(ls_codigo)
				  This.Object.banco_ltr [row] = ls_codigo
				  Messagebox('Aviso','Si ubicacion de la letra esta en cartera no se debe ingresar codigo de banco ')
				  Return 1
			  END IF
		CASE 'flag_situacion_ltr'
			  IF data = '1' THEN
				  SetNull(ls_codigo)
				  This.Object.banco_ltr [row] = ls_codigo
				  Return 1
			  END IF				
end choose
end event

event itemerror;call super::itemerror;Return 1
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
Datawindow ldw
Date        ld_fecha_emision,ld_fecha_vencimiento
Decimal {3} ldc_tasa_cambio
Decimal		ld_dias_a_canc
str_seleccionar lstr_seleccionar
String          ls_cod_relacion,ls_name,ls_prot

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'cod_relacion'
			
				if is_accion = 'new' then
					lstr_seleccionar.s_seleccion = 'S'
					lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR     AS CODIGO_PROVEEDOR ,'&
									      				 +'PROVEEDOR.NOM_PROVEEDOR AS NOMBRES ,'&
									   					 +'PROVEEDOR.EMAIL			  AS EMAIL '&
										   				 +'FROM PROVEEDOR '&
															 +'WHERE FLAG_ESTADO = '+"'"+'1'+"'"

				
					OpenWithParm(w_seleccionar,lstr_seleccionar)
				
					IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
					IF lstr_seleccionar.s_action = "aceptar" THEN
						IF tab_1.tabpage_1.dw_detail.Rowcount() > 0 THEN
							ls_cod_relacion = This.object.cod_relacion [row]
							IF ls_cod_relacion <> lstr_seleccionar.param1[1] THEN
								wf_delete_doc_referencias()	
								dw_master.Object.importe_doc [row] = wf_calcular_total ()
								dw_master.ii_update = 1
							END IF
						
						END IF
					
						Setitem(row,'cod_relacion',lstr_seleccionar.param1[1])
						Setitem(row,'nom_proveedor',lstr_seleccionar.param2[1])
						ii_update = 1
						/*Generación Pre-Asientos*/
						ib_estado_preas = TRUE
						/**/
					END IF
				END IF				
				
	   CASE  'fecha_documento'
				ld_fecha_emision = Date(This.Object.fecha_documento [row])				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_emision <> Date(This.Object.fecha_documento [row]) THEN
					ld_fecha_emision     = Date(This.Object.fecha_documento   [row])				
					ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
					
					IF ld_fecha_emision > ld_fecha_vencimiento THEN
						This.Object.fecha_documento [row] = ld_fecha_vencimiento
						Messagebox('Aviso','Fecha de Emisión del Documento No '&
												+'Puede Ser Mayor a la Fecha de Vencimiento')
													
					END IF					
					
					ld_dias_a_canc   		= This.Object.dias_a_cancelar [row]
					IF Not(Isnull(ld_dias_a_canc) OR ld_dias_a_canc = 0) THEN //SI ES MAYOR QUE 0
						ld_fecha_vencimiento = RelativeDate (ld_fecha_emision, ld_dias_a_canc )
						This.Object.fecha_vencimiento [row] = ld_fecha_vencimiento				
					END IF	
					
					ld_fecha_emision     = Date(This.Object.fecha_documento [row])				
					This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)	
					ldc_tasa_cambio = This.Object.tasa_cambio [row]
					/*ACTUALIZAR TASA DE CAMBIO DE DETALLE*/
					wf_update_tcambio_det(ldc_tasa_cambio)					
					
					
					dw_master.Object.importe_doc [row] = wf_calcular_total ()

					ii_update = 1
					/*Generación Pre-Asientos*/
					ib_estado_preas = TRUE
					/**/
			   END IF
				
		CASE	'fecha_vencimiento'		
			
				ld_fecha_vencimiento = Date(This.Object.fecha_vencimiento [row])				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_vencimiento <> Date(This.Object.fecha_vencimiento [row])	THEN
					ld_fecha_emision     = Date(This.Object.fecha_documento   [row])			
					ld_fecha_vencimiento	= Date(This.Object.fecha_vencimiento [row])			
					
					IF ld_fecha_vencimiento < ld_fecha_emision THEN
						This.Object.fecha_vencimiento [row] = ld_fecha_emision
						Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
												+'Puede Ser Menor a la Fecha de Emisión')

					END IF					
					ii_update = 1
					/*Generación Pre-Asientos*/
					ib_estado_preas = TRUE
					/**/
				END IF
END CHOOSE

end event

event ue_insert_pre;call super::ue_insert_pre;String ls_tipo_doc

/*recupero doc.cheuqe diferido*/
select doc_cheque_dif into :ls_tipo_doc from finparam where reckey = '1' ;


This.Object.origen		       [al_row] = gs_origen
This.Object.tipo_doc		       [al_row] = ls_tipo_doc
This.Object.cod_usr		       [al_row] = gs_user
This.Object.fecha_registro     [al_row] = f_fecha_actual()
This.Object.fecha_documento    [al_row] = f_fecha_actual()
This.Object.tasa_cambio        [al_row] = gnvo_app.of_tasa_cambio()
This.Object.ano				    [al_row] = Long(String(f_fecha_actual(),'YYYY'))
This.Object.mes				    [al_row] = Long(String(f_fecha_actual(),'MM'))
This.Object.flag_estado		    [al_row] = '1'
This.Object.nro_ren_ltr  	    [al_row] = 0
This.Object.flag_situacion_ltr [al_row] = '1'
This.Object.flag_tipo_ltr		 [al_row] = 'C' //CANJE DE LETRAS
This.Object.flag_provisionado	 [al_row] = 'R' //Provisionado Manualmente
This.Object.nro_libro	       [al_row] = f_nro_libro(ls_tipo_doc)

end event

