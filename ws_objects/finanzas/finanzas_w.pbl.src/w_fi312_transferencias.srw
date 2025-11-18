$PBExportHeader$w_fi312_transferencias.srw
forward
global type w_fi312_transferencias from w_abc
end type
type dw_rpt from u_dw_rpt within w_fi312_transferencias
end type
type tab_1 from tab within w_fi312_transferencias
end type
type tabpage_1 from userobject within tab_1
end type
type rb_v from radiobutton within tabpage_1
end type
type rb_cv from radiobutton within tabpage_1
end type
type st_1 from statictext within tabpage_1
end type
type dw_detail from u_dw_abc within tabpage_1
end type
type cb_1 from commandbutton within tabpage_1
end type
type dw_master from u_dw_abc within tabpage_1
end type
type gb_1 from groupbox within tabpage_1
end type
type tabpage_1 from userobject within tab_1
rb_v rb_v
rb_cv rb_cv
st_1 st_1
dw_detail dw_detail
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type
type tabpage_2 from userobject within tab_1
end type
type dw_pre_asiento_cab from u_dw_abc within tabpage_2
end type
type dw_pre_asiento_det from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_pre_asiento_cab dw_pre_asiento_cab
dw_pre_asiento_det dw_pre_asiento_det
end type
type tab_1 from tab within w_fi312_transferencias
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
end forward

global type w_fi312_transferencias from w_abc
integer width = 4375
integer height = 2104
string title = "[FI312] Transferencias"
string menuname = "m_mantenimiento_cl_anular"
event ue_anular ( )
event ue_find_exact ( )
dw_rpt dw_rpt
tab_1 tab_1
end type
global w_fi312_transferencias w_fi312_transferencias

type variables
String  is_accion 
Boolean ib_estado_preas = TRUE	//se genera nuevos asientos

Datastore 	ids_matriz_cntbl_det
u_dw_abc		idw_asiento_Det, idw_asiento_cab, idw_master, idw_detail

n_cst_asiento_contable invo_cntbl_asiento

end variables

forward prototypes
public function string wf_banco_cnta (string as_banco_cnta)
public function boolean wf_nro_registro ()
public function boolean wf_nro_libro (ref long al_nro_libro)
public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_cta_bco, string as_cencos, long al_row)
public subroutine wf_total ()
public subroutine of_asigna_dws ()
public function boolean of_generacion_asiento ()
end prototypes

event ue_anular();Long    ll_inicio
String  ls_flag_estado,ls_mensaje

idw_master.Accepttext()

IF idw_master.ii_update = 1 OR idw_detail.ii_update = 1 THEN
	Messagebox('Aviso','Debe Grabar los Cambios Antes de Anular el Documento')
	Return
END IF

ls_flag_estado = idw_master.object.flag_estado [1] 
IF ls_flag_estado = '0' THEN ls_mensaje = 'Documento ya Ha Sido anulado '
IF ls_flag_estado = '2' THEN ls_mensaje = 'Documento ya Ha Sido Contabilizado '
IF ls_flag_estado <> '1' THEN 
	Messagebox('Aviso',ls_mensaje)
	Return
END IF


FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 idw_detail.object.importe [ll_inicio] = 0.00
NEXT	

idw_master.object.flag_estado [1] = '0'
idw_master.object.imp_total   [1] = 0.00

idw_master.ii_update = 1
idw_detail.ii_update = 1

ib_estado_preas = TRUE
end event

event ue_find_exact();// Asigna valores a structura 
String ls_origen
Long   ll_row_master,ll_nro_doc,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento

str_parametros sl_param
	
TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1     = 'd_ext_caja_bancos_tbl'
sl_param.string1 = '1' //transferencias
sl_param.dw_m    = idw_master
sl_param.opcion  = 5 //caja bancos

OpenWithParm( w_help_datos, sl_param)


sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	ll_row_master   = idw_master.getrow()
	ls_origen	 	 = idw_master.object.origen		 [ll_row_master] //1
	ll_nro_doc   	 = idw_master.object.nro_registro [ll_row_master] //2
	ll_ano		 	 = idw_master.object.ano          [ll_row_master] //3
	ll_mes		 	 = idw_master.object.mes          [ll_row_master] //4
	ll_nro_libro 	 = idw_master.object.nro_libro    [ll_row_master] //5
	ll_nro_asiento  = idw_master.object.nro_asiento  [ll_row_master] //6
	
	idw_master.Retrieve(ls_origen,ll_nro_doc,'1')
	idw_detail.Retrieve(ls_origen,ll_nro_doc)
	idw_asiento_cab.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)
	idw_asiento_det.Retrieve(ls_origen,ll_ano,ll_mes,ll_nro_libro,ll_nro_asiento)

	
	ib_estado_preas = False   //asiento editado					
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE
	idw_master.Reset()
	idw_asiento_det.Reset()
	idw_asiento_cab.REset()
	
	ib_estado_preas = False   //asiento editado						
END IF
















end event

public function string wf_banco_cnta (string as_banco_cnta);String ls_cnta_ctbl


SELECT cnta_ctbl
  INTO :ls_cnta_ctbl
  FROM banco_cnta
 WHERE (cod_ctabco = :as_banco_cnta) ;
 
 

Return ls_cnta_ctbl
end function

public function boolean wf_nro_registro ();Long    ll_nro_reg
Boolean lb_retorno = TRUE


SELECT ult_nro
  INTO :ll_nro_reg
  FROM num_caja_bancos
 WHERE (origen = :gs_origen)
FOR UPDATE ;
	
IF Isnull(ll_nro_reg) OR ll_nro_reg = 0 THEN
	Return FALSE
	Rollback ;
END IF
	//*******************************//
	//Actualiza Tabla num_caja_bancos//
	//*******************************//
	
   UPDATE num_caja_bancos
	SET 	 ult_nro = :ll_nro_reg + 1
	WHERE  (origen = :gs_origen) ;
	
	IF SQLCA.SQLCode = -1 THEN 
		MessageBox("SQL error", SQLCA.SQLErrText)
		lb_retorno = FALSE
		Rollback ;
	ELSE
		idw_master.object.nro_registro [1] =  ll_nro_reg
	END IF	

Return lb_retorno


end function

public function boolean wf_nro_libro (ref long al_nro_libro);Boolean lb_retorno = TRUE

SELECT nro_libro_tranfer
  INTO :al_nro_libro
  FROM finparam 
 WHERE reckey = '1' ;
 
IF Isnull(al_nro_libro) OR al_nro_libro = 0 THEN
	lb_retorno = FALSE
	Rollback ;
END IF

Return lb_retorno
	
end function

public function boolean wf_verifica_flag_cntas (string as_cta_cntbl, string as_cta_bco, string as_cencos, long al_row);String  ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_tipo_doc,&
		  ls_nro_doc,ls_flag_cebef
Boolean lb_retorno = TRUE


IF f_cntbl_cnta(as_cta_cntbl,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,&
					 ls_flag_cod_rel,ls_flag_cebef)  THEN



IF ls_flag_doc_ref = '1' THEN
	ls_tipo_doc = idw_asiento_det.object.tipo_docref1 [al_row]
	ls_nro_doc  = idw_asiento_det.object.nro_docref1  [al_row]
	
	IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
		Messagebox('Aviso','Debe Ingresar Tipo de Documento de Item ' +Trim(String(al_row))+' ,  Verifique!')
		idw_asiento_det.SetColumn('tipo_docref1')
		lb_retorno = FALSE
		GOTO SALIDA
	END IF
	
	IF Isnull(ls_nro_doc) OR Trim(ls_nro_doc) = '' THEN
		Messagebox('Aviso','Debe Ingresar Nro de Documento de Item '+Trim(String(al_row))+' ,  Verifique!')
		idw_asiento_det.SetColumn('nro_docref1')
		lb_retorno = FALSE
		GOTO SALIDA
	END IF
	
ELSE
	SetNull(ls_tipo_doc)
	SetNull(ls_nro_doc)
	idw_asiento_det.object.tipo_docref1 [al_row] = ls_tipo_doc
	idw_asiento_det.object.nro_docref1  [al_row] = ls_nro_doc
END IF

IF ls_flag_cencos = '1' THEN
	IF Isnull(as_cencos) OR Trim(as_cencos) = '' THEN
		Messagebox('Aviso','Debe Ingresar Centro de Costo de Item '+Trim(String(al_row))+' , Cuenta Contable Lo Requiere!')
	   lb_retorno = FALSE
		GOTO SALIDA
	END IF

END IF



ELSE
   lb_retorno = FALSE
	GOTO SALIDA
END IF

SALIDA:

Return lb_retorno
end function

public subroutine wf_total ();Decimal {2} ldc_imp_total = 0.00,ldc_imp_det
Long        ll_inicio
String      ls_signo

IF idw_master.Getrow() = 0 THEN RETURN

FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 ldc_imp_det = idw_detail.object.importe  [ll_inicio]

	 
	 IF Isnull(ldc_imp_det) THEN ldc_imp_det = 0.00

	 ldc_imp_total = ldc_imp_total + ldc_imp_det

	

	 
	 
NEXT

idw_master.object.imp_total [idw_master.getrow()] = ldc_imp_total
idw_master.ii_update = 1
end subroutine

public subroutine of_asigna_dws ();idw_master 			= tab_1.tabpage_1.dw_master
idw_detail			= tab_1.tabpage_1.dw_detail
idw_asiento_Det 	= tab_1.tabpage_2.dw_pre_asiento_det
idw_asiento_cab 	= tab_1.tabpage_2.dw_pre_asiento_cab


end subroutine

public function boolean of_generacion_asiento ();String 	ls_ctabco_ori ,ls_cod_ctabco_ori,ls_desctbco_ori,&
		 	ls_ctabco_des ,ls_cod_ctabco_des,ls_desctbco_des,&
		 	ls_soles      ,ls_dolares,ls_moneda,ls_flag_ctabco,&
		 	ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,&
		 	ls_flag_edit  ,ls_cta_bco     ,ls_tipo_doc   ,ls_nro_doc    ,ls_cod_relacion,&
		 	ls_confin     ,ls_matriz_cntbl,ls_cnta_ctbl  ,ls_desc_cnta  ,ls_flag_debhab ,&
		 	ls_expresion  ,ls_formula     ,ls_glosa_texto,ls_glosa_campo,ls_flag_cta_bco,&
		 	ls_flag_cebef
Long   	ll_row,ll_ins_det_ori,ll_ins_det_des,ll_inicio	,ll_inicio_matriz, ll_found
Decimal 	ldc_monto, ldc_monto_det, ldc_tasa_cambio
Boolean 	lb_retorno


DO WHILE idw_asiento_det.rowcount() > 0
	idw_asiento_det.deleterow(0)	
LOOP

ll_row = idw_master.Getrow()

IF ll_row = 0 THEN RETURN FALSE


f_monedas(ls_soles,ls_dolares)
ls_moneda 		 	= idw_master.object.cod_moneda [ll_row]
ldc_monto 		 	= idw_master.object.imp_total  [ll_row]
ldc_tasa_cambio 	= idw_master.object.tasa_cambio[ll_row]
ls_tipo_doc 	 		= idw_master.object.tipo_doc	  [ll_row]
ls_nro_doc		 	= idw_master.object.nro_doc	  [ll_row]

IF IsNull(ls_moneda) OR Trim(ls_moneda) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Moneda')
	Return False	
END IF


IF IsNull(ldc_tasa_cambio) OR ldc_tasa_cambio = 0 THEN
	Messagebox('Aviso','Debe Ingresar Tasa de Cambio')	
	Return False
END IF


//Insercion de Cuenta del Banco Origen 
ls_ctabco_ori		= idw_master.GetitemString(ll_row,'cta_b1')
ls_cod_ctabco_ori	= idw_master.GetitemString(ll_row,'cod_ctabco')
ls_desctbco_ori	= idw_master.GetitemString(ll_row,'desc_b1')

IF Isnull(ls_cod_ctabco_ori) OR Trim(ls_cod_ctabco_ori)= '' THEN 
	Messagebox('Aviso','Debe Seleccionar Cuenta de Banco Origen')
	Return False
END IF

idw_asiento_det.ii_protect = 1
idw_asiento_det.of_protect() // desprotege el dw

ll_ins_det_ori 	= idw_asiento_det.event ue_insert()	//Inserta Registro 	 

if ll_ins_det_ori < 0 then return false

idw_asiento_det.ii_update = 1
idw_asiento_det.object.item        [ll_ins_det_ori] = ll_ins_det_ori
idw_asiento_det.object.cnta_ctbl   [ll_ins_det_ori] = ls_ctabco_ori
idw_asiento_det.Object.flag_debhab [ll_ins_det_ori] = 'H'
idw_asiento_det.Object.det_glosa	[ll_ins_det_ori] = ls_desctbco_ori


IF ls_moneda = ls_soles THEN
	idw_asiento_det.Object.imp_movsol [ll_ins_det_ori] = Round(ldc_monto,2)						
	idw_asiento_det.Object.imp_movdol [ll_ins_det_ori] = Round(ldc_monto / ldc_tasa_cambio,2)
ELSEIF ls_moneda = ls_dolares THEN
	idw_asiento_det.Object.imp_movsol [ll_ins_det_ori] = Round(ldc_monto * ldc_tasa_cambio,2)
	idw_asiento_det.Object.imp_movdol [ll_ins_det_ori] = Round(ldc_monto,2)	
END IF
					

IF f_cntbl_cnta(ls_ctabco_ori,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef) = FALSE THEN Return FALSE

IF ls_flag_ctabco = '1' THEN
	idw_asiento_det.object.cod_ctabco [ll_ins_det_ori] = ls_cod_ctabco_ori
ELSE	
	idw_asiento_det.object.cod_ctabco [ll_ins_det_ori] = gnvo_app.is_null
END IF

IF	ls_flag_cencos = '1' THEN
	Messagebox('Aviso','Centro de Costo No Ha Sido Considerado Comuniquese Con la Oficina de Sistemas')
	Return  FALSE
ELSE
	idw_asiento_det.object.cencos [ll_ins_det_ori] =  gnvo_app.is_null
END IF

IF	ls_flag_doc_ref = '1' THEN
	SetNull(ls_flag_edit)
	idw_asiento_det.object.flag_doc_edit [ll_ins_det_ori] = ls_flag_edit
	idw_asiento_det.object.tipo_docref1  [ll_ins_det_ori] = ls_tipo_doc
	idw_asiento_det.object.nro_docref1   [ll_ins_det_ori] = ls_nro_doc
ELSE
	idw_asiento_det.object.flag_doc_edit [ll_ins_det_ori] = 'E'
	idw_asiento_det.object.tipo_docref1  [ll_ins_det_ori] = gnvo_app.is_null
	idw_asiento_det.object.nro_docref1   [ll_ins_det_ori] = gnvo_app.is_null
END IF

IF	ls_flag_cod_rel = '1' THEN
	Messagebox('Aviso','Codigo de Relación No Ha Sido Considerado Comuniquese Con la Oficina de Sistemas')
	Return  FALSE
ELSE
	idw_asiento_det.object.cod_relacion [ll_ins_det_ori] = gnvo_app.is_null
END IF



//Insercion de Cuenta del Banco Origen y Destino
ls_ctabco_des		= idw_master.GetitemString(ll_row,'cta_b2')
ls_cod_ctabco_des	= idw_master.GetitemString(ll_row,'cod_ctabco_ref')
ls_desctbco_des	= idw_master.GetitemString(ll_row,'desc_b2')

IF Isnull(ls_cod_ctabco_des) OR Trim(ls_cod_ctabco_des)= '' THEN 
	Messagebox('Aviso','Debe Seleccionar Cuenta de Banco Destino')
	Return False
END IF


FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 //diferenciar x concepto financiero
	 ls_tipo_doc = idw_detail.object.tipo_doc [ll_inicio]
	 ls_nro_doc  = idw_detail.object.nro_doc  [ll_inicio]
	 
	ll_ins_det_des 	= idw_asiento_det.event ue_insert()	//Inserta Registro 	 	 	
	
	if ll_ins_det_des > 0 then
	    	idw_asiento_det.object.cnta_ctbl   	[ll_ins_det_des] = ls_ctabco_des
	    idw_asiento_det.Object.flag_debhab 	[ll_ins_det_des] = 'D'
   	 	idw_asiento_det.Object.det_glosa	 	[ll_ins_det_des] = ls_desctbco_des

		ldc_monto_det = idw_detail.object.importe [ll_inicio]
	 
		 IF Isnull(ldc_monto_det) THEN ldc_monto_det = 0.00 
	 
		 IF ls_moneda = ls_soles THEN
			idw_asiento_det.Object.imp_movsol [ll_ins_det_des] = Round(ldc_monto_det,2)						
			idw_asiento_det.Object.imp_movdol [ll_ins_det_des] = Round(ldc_monto_det / ldc_tasa_cambio,2)
		 ELSEIF ls_moneda = ls_dolares THEN
			idw_asiento_det.Object.imp_movsol [ll_ins_det_des] = Round(ldc_monto_det * ldc_tasa_cambio,2)
			idw_asiento_det.Object.imp_movdol [ll_ins_det_des] = Round(ldc_monto_det,2)	
		 END IF
	 
		 IF f_cntbl_cnta(ls_ctabco_des,ls_flag_ctabco,ls_flag_cencos,ls_flag_doc_ref,ls_flag_cod_rel,ls_flag_cebef) = FALSE THEN RETURN FALSE
	 
	 
		 IF ls_flag_ctabco = '1' THEN
			 idw_asiento_det.object.cod_ctabco [ll_ins_det_des] = ls_cod_ctabco_des
		 ELSE	
			 idw_asiento_det.object.cod_ctabco [ll_ins_det_des] = gnvo_app.is_null
		 END IF

		 IF ls_flag_cencos = '1' THEN
			 Messagebox('Aviso','Centro de Costo No Ha Sido Considerado Comuniquese Con la Oficina de Sistemas')
		 	 Return  FALSE
		 ELSE
			 idw_asiento_det.object.cencos [ll_ins_det_des] =  gnvo_app.is_null
		 END IF

		 IF ls_flag_doc_ref = '1' THEN
		 	 SetNull(ls_flag_edit)
			 idw_asiento_det.object.flag_doc_edit [ll_ins_det_des] = ls_flag_edit
			 idw_asiento_det.object.tipo_docref1  [ll_ins_det_des] = ls_tipo_doc
			 idw_asiento_det.object.nro_docref1   [ll_ins_det_des] = ls_nro_doc
		 ELSE
			 idw_asiento_det.object.flag_doc_edit [ll_ins_det_des] = 'E'
			 idw_asiento_det.object.tipo_docref1  [ll_ins_det_des] = gnvo_app.is_null
			 idw_asiento_det.object.nro_docref1   [ll_ins_det_des] = gnvo_app.is_null
		 END IF
	 
	 

	    IF ls_flag_cod_rel = '1' THEN
			 Messagebox('Aviso','Codigo de Relación No Ha Sido Considerado Comuniquese Con la Oficina de Sistemas')
			 Return  FALSE
		 ELSE
			 idw_asiento_det.object.cod_relacion [ll_ins_det_des] =  gnvo_app.is_null
		 END IF
	 END IF

NEXT	




Return TRUE
end function

on w_fi312_transferencias.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular" then this.MenuID = create m_mantenimiento_cl_anular
this.dw_rpt=create dw_rpt
this.tab_1=create tab_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_rpt
this.Control[iCurrent+2]=this.tab_1
end on

on w_fi312_transferencias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_rpt)
destroy(this.tab_1)
end on

event ue_open_pre;call super::ue_open_pre;of_asigna_dws()

idw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_detail.SetTransObject(sqlca)
idw_asiento_cab.SetTransObject(sqlca)
idw_asiento_det.SetTransObject(sqlca)

idw_1 = idw_master   	         				  // asignar dw corriente
idw_master.setFocus()

//idw_pre_asiento_det.BorderStyle = StyleRaised! // indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija



//TriggerEvent ('ue_insert')
idw_asiento_det.ii_protect = 0
idw_asiento_det.of_protect()


//** Datastore Detalle Matriz Contable **//
ids_matriz_cntbl_det = Create Datastore
ids_matriz_cntbl_det.DataObject = 'd_matriz_cntbl_financiera_det_tbl'
ids_matriz_cntbl_det.SettransObject(sqlca)
//** **//

//crea objeto
invo_cntbl_asiento = create n_cst_asiento_contable


end event

event resize;call super::resize;of_asigna_dws()

tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 10
idw_detail.height  = newheight  - idw_detail.y - 200
idw_asiento_det.width	= newwidth  - idw_asiento_det.x - 50
idw_asiento_det.height = newheight - idw_asiento_det.y - 200
end event

event ue_insert;call super::ue_insert;Long  ll_row,ll_ano,ll_mes
String ls_flag_estado,ls_result,ls_mensaje


CHOOSE CASE idw_1
		 CASE idw_master
				TriggerEvent('ue_update_request')
				is_accion = 'new'			
				idw_1.reset()
				tab_1.tabpage_2.dw_pre_asiento_cab.reset()
				idw_asiento_det.reset()
				
		 CASE idw_detail
				IF idw_master.getrow() = 0 THEN RETURN
				ls_flag_estado = idw_master.object.flag_estado [idw_master.getrow()]
				ll_ano 			= idw_master.object.ano 		  [idw_master.getrow()]
				ll_mes 			= idw_master.object.mes 		  [idw_master.getrow()]

				/*verifica cierre*/
				invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

		 		IF ls_flag_estado = '0' OR ls_result = '0' THEN
					Messagebox('Aviso','Transferencia No se Puede Modificar , Verifique! ')
					Return 
			   END IF
				
	    CASE ELSE
				RETURN
END CHOOSE

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)

//generacion de asientos automaticos
ib_estado_preas = TRUE

end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (idw_master.ii_update = 1 OR idw_detail.ii_update = 1  OR idw_asiento_cab.ii_update = 1 OR &
	 idw_asiento_det.ii_update = 1  ) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		idw_master.ii_update 			= 0
		idw_detail.ii_update 			= 0
		tab_1.tabpage_2.dw_pre_asiento_cab.ii_update = 0
		idw_asiento_det.ii_update = 0
		Rollback ;
	END IF
END IF

end event

event ue_delete;//OVERRIDE
Long  ll_row,ll_row_master,ll_ano,ll_mes
String ls_flag_estado,ls_result,ls_mensaje

CHOOSE CASE idw_1
		 CASE idw_detail
				ll_row_master = idw_master.getrow()
				IF ll_row_master = 0.00 THEN RETURN
				ls_flag_estado = idw_master.object.flag_estado [ll_row_master]
				ll_ano 			= idw_master.object.ano 		  [ll_row_master]
				ll_mes 			= idw_master.object.mes 		  [ll_row_master]

				/*verifica cierre*/
				invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

				
				IF ls_flag_estado <> '1' OR ls_result = '0' THEN RETURN
				//GENERACION DE ASIENTOS AUTOMATICOS
				ib_estado_preas = TRUE

		 CASE ELSE
				Return

END CHOOSE


ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event ue_update_pre;Long 	     ll_nro_libro,ll_nro_asiento,ll_nro_registro,ll_inicio,ll_ano,ll_mes
String     ls_cod_origen, ls_flag_estado,ls_periodo,ls_cta_cntbl,ls_cencos,ls_cta_bco,ls_result,ls_mensaje,&
			  ls_cta_bco_ori,ls_cta_bco_des
Decimal{2} ldc_importe_total ,ldc_totsoldeb = 0,ldc_totdoldeb = 0,ldc_totsolhab = 0,ldc_totdolhab = 0
Date       ld_last_day
Datetime	  ldt_fecha_doc


/*DATOS DE CABECERA */
IF idw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF

IF idw_detail.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Detalle de Transferencias')
	ib_update_check = False	
	Return
ELSE
	ib_update_check = True
END IF


//--VERIFICACION Y ASIGNACION 
IF f_row_Processing( idw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

IF f_row_Processing( idw_detail, "tabular") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

/* Validación de Importe and Datos de Cabecera*/
ldc_importe_total = idw_master.Object.imp_total     [1]
ls_flag_estado		= idw_master.Object.flag_estado   [1]
ll_nro_libro      = idw_master.object.nro_libro     [1]
ll_nro_asiento    = idw_master.object.nro_asiento   [1]
ll_nro_registro	= idw_master.object.nro_registro  [1]
ls_cod_origen		= idw_master.object.origen 		 [1]
ll_ano				= idw_master.object.ano		 		 [1]
ll_mes				= idw_master.object.mes		 		 [1]
ldt_fecha_doc		= idw_master.object.fecha_emision [1]
ls_cta_bco_ori    = idw_master.Object.cod_ctabco    [1]
ls_cta_bco_des    = idw_master.Object.cod_ctabco_ref[1]

IF Isnull(ls_cta_bco_ori) OR Trim(ls_cta_bco_ori) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Cuenta de Banco Origen Verifique!')
	ib_update_check = False	
	Return	
END IF

IF Isnull(ls_cta_bco_des) OR Trim(ls_cta_bco_des) = '' THEN
	Messagebox('Aviso','Debe Ingresar Una Cuenta de Banco Destino Verifique!')
	ib_update_check = False	
	Return	
END IF

/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	ib_update_check = False	
	Return
END IF

IF ls_flag_estado = '1' THEN 
	IF Isnull(ldc_importe_total)	OR  ldc_importe_total = 0 THEN
		Messagebox('Aviso','Importe No Debe Ser Cero')
		idw_master.SetFocus()
		idw_master.SetColumn('imp_total')
		ib_update_check = False	
		Return
	END IF
END IF	
/**/


IF ib_estado_preas THEN //Generacion de Asientos Automaticos
	IF of_generacion_asiento () = FALSE THEN
		ib_update_check = False	
		Return
	END IF
END IF


IF is_accion = 'new' THEN
	IF wf_nro_registro () = FALSE THEN
		ib_update_check = False	
		Messagebox('Aviso','Verifique Tabla de Numeración "NUM_CAJA_BANCOS" ')
		Return
	ELSE
		ll_nro_registro	= idw_master.object.nro_registro [1]
	END IF
	
	IF wf_nro_libro(ll_nro_libro) = FALSE THEN
		ib_update_check = False	
		Messagebox('Aviso','Libro de Transferencia No Existe , Verifique!')
		Return
	ELSE
		idw_master.object.nro_libro [1]	= ll_nro_libro	
	END IF
	
	
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
	
	IF invo_cntbl_asiento.of_get_nro_asiento(ls_cod_origen, ll_ano, ll_mes, ll_nro_libro, ll_nro_asiento)  = FALSE THEN
		ib_update_check = False	
		Return
	ELSE
		idw_master.object.nro_asiento [1] = ll_nro_asiento 
	END IF	
	
	
	
	//Cabecera de Asiento
	idw_asiento_cab.Object.mes [1] = ll_ano
	idw_asiento_cab.Object.ano [1] = ll_mes
	
END IF



///Cabecera de pre asiento
IF is_accion = 'new' THEN
	idw_asiento_cab.Object.origen     	[1] = ls_cod_origen
	idw_asiento_cab.Object.ano	     	[1] = ll_ano
	idw_asiento_cab.Object.mes	     	[1] = ll_mes
	idw_asiento_cab.Object.nro_libro 	[1] = ll_nro_libro
	idw_asiento_cab.Object.nro_asiento [1] = ll_nro_asiento
END IF	


FOR ll_inicio = 1 TO idw_detail.Rowcount()
	 idw_detail.object.origen		  [ll_inicio] = ls_cod_origen	
	 idw_detail.object.nro_registro [ll_inicio] = ll_nro_registro
NEXT



///Detalle de asiento
FOR ll_inicio = 1 TO idw_asiento_det.Rowcount()
	 ls_cta_cntbl = idw_asiento_det.object.cnta_ctbl [ll_inicio]
	 ls_cencos	  = idw_asiento_det.object.cencos    [ll_inicio]
	 idw_asiento_det.object.origen   	 [ll_inicio] = ls_cod_origen
	 idw_asiento_det.object.ano   	 	 [ll_inicio] = ll_ano
	 idw_asiento_det.object.mes	   	 [ll_inicio] = ll_mes
	 idw_asiento_det.object.nro_libro	 [ll_inicio] = ll_nro_libro
	 idw_asiento_det.object.nro_asiento [ll_inicio] = ll_nro_asiento
	 idw_asiento_det.object.fec_cntbl   [ll_inicio] = ldt_fecha_doc
	 
	 wf_verifica_flag_cntas (ls_cta_cntbl,ls_cta_bco,ls_cencos,ll_inicio)
	 
NEXT

ldc_totsoldeb  = idw_asiento_det.object.monto_soles_cargo   [1]
ldc_totdoldeb  = idw_asiento_det.object.monto_dolares_cargo [1]
ldc_totsolhab  = idw_asiento_det.object.monto_soles_abono	 [1]
ldc_totdolhab  = idw_asiento_det.object.monto_dolares_abono [1]

//Cabecera de Pre Asiento Detalles Adicionales
idw_asiento_cab.Object.cod_moneda	 [1] = idw_master.object.cod_moneda    [1]
idw_asiento_cab.Object.tasa_cambio	 [1] = idw_master.object.tasa_cambio   [1]
idw_asiento_cab.Object.fec_registro [1] = idw_master.object.fecha_emision [1]
idw_asiento_cab.Object.fecha_cntbl  [1] = ldt_fecha_doc
idw_asiento_cab.Object.cod_usr		 [1] = idw_master.object.cod_usr 	   [1]
idw_asiento_cab.Object.flag_estado	 [1] = idw_master.object.flag_estado   [1]
idw_asiento_cab.Object.tot_solhab	 [1] = ldc_totsolhab
idw_asiento_cab.Object.tot_dolhab	 [1] = ldc_totdolhab
idw_asiento_cab.Object.tot_soldeb	 [1] = ldc_totsoldeb
idw_asiento_cab.Object.tot_doldeb	 [1] = ldc_totdoldeb


IF idw_master.ii_update = 1  OR idw_asiento_det.ii_update = 1 THEN idw_asiento_cab.ii_update = 1	



/*Replicacion*/
idw_master.of_set_flag_replicacion ()
idw_detail.of_set_flag_replicacion ()
idw_asiento_cab.of_set_flag_replicacion ()
idw_asiento_det.of_set_flag_replicacion ()
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

idw_master.AcceptText()
idw_detail.AcceptText()
idw_asiento_cab.AcceptText()
idw_asiento_det.AcceptText()

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	ROLLBACK USING SQLCA;	
	RETURN
END IF



IF idw_asiento_cab.ii_update = 1 THEN         
	IF idw_asiento_cab.Update(true, false) = -1 then		// Grabacion Pre - Asiento Cabecera
		lbo_ok = FALSE
		messagebox("Error en Grabacion Asiento Cabecera","Se ha procedido al rollback",exclamation!)
	END IF
END IF


IF idw_asiento_det.ii_update = 1 THEN
	IF idw_asiento_det.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Asiento Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_master.ii_update = 1  THEN
	IF idw_master.Update(true, false) = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	idw_detail.ii_update = 1  THEN
	IF idw_detail.Update(true, false) = -1 then		// Grabacion del Detalle
		lbo_ok = FALSE
		messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	idw_master.ii_update			= 0
	idw_detail.ii_update			= 0
	idw_asiento_cab.ii_update	= 0
	idw_asiento_det.ii_update	= 0
	
	idw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()
	
	ib_estado_preas = FALSE
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
	
	f_mensaje("Transacion guardada satisfactoriamente", "")
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_insert_pos(long al_row);call super::ue_insert_pos;IF idw_1 = idw_master THEN
	tab_1.tabpage_2.dw_pre_asiento_cab.TriggerEvent('ue_insert')
END IF
end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row,ll_found
String ls_periodo,ls_expresion,ls_cta_ctbl_bco,ls_flag_edit,ls_bco_cnta,&
		 ls_bco_cnta_ref 
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1     = 'd_abc_caja_bancos_x_arg_tbl'
sl_param.titulo  = 'Transferencias'
sl_param.tipo 	  = '1S'
sl_param.string1 = '1'
sl_param.field_ret_i[1] = 1 //origen
sl_param.field_ret_i[2] = 2 //registro	
sl_param.field_ret_i[3] = 5 //ano
sl_param.field_ret_i[4] = 6 //mes
sl_param.field_ret_i[5] = 7 //nro libro
sl_param.field_ret_i[6] = 8 //nro asiento

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	
	idw_master.ResetUpdate()
	idw_detail.ResetUpdate()
	idw_asiento_cab.ResetUpdate()
	idw_asiento_det.ResetUpdate()
	
	idw_master.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]),'1')
	idw_detail.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[2]))
	idw_asiento_cab.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	idw_asiento_det.Retrieve(sl_param.field_ret[1],Long(sl_param.field_ret[3]),Long(sl_param.field_ret[4]),Long(sl_param.field_ret[5]),Long(sl_param.field_ret[6]))
	//no generacion de asientos automaticos
	ib_estado_preas = FALSE
	
	ls_bco_cnta     = idw_master.object.cod_ctabco [1]
	ls_bco_cnta_ref = idw_master.object.cod_ctabco [1]
	
	/*Busco Cuenta Contable de Banco*/
	ls_cta_ctbl_bco = idw_master.object.cta_b1 [1]
	ls_expresion    = 'cnta_ctbl = '+"'"+ls_cta_ctbl_bco+"'"
	ll_found        = idw_asiento_det.Find(ls_expresion,1,idw_asiento_det.Rowcount())
	
	IF ll_found > 0 THEN
		SetNull(ls_flag_edit)
		idw_asiento_det.Object.flag_doc_edit [ll_found] = ls_flag_edit
	END IF
	/***/					

	/*Busco Cuenta Contable de Banco Transf*/
	ls_cta_ctbl_bco = idw_master.object.cta_b2 [1]
	ls_expresion    = 'cnta_ctbl = '+"'"+ls_cta_ctbl_bco+"'"
	ll_found        = idw_asiento_det.Find(ls_expresion,1,idw_asiento_det.Rowcount())
	
	IF ll_found > 0 THEN
		SetNull(ls_flag_edit)
		idw_asiento_det.Object.flag_doc_edit [ll_found] = ls_flag_edit
	END IF
	/***/					
					
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
END IF



end event

event ue_modify;String ls_flag_estado,ls_result,ls_mensaje
Long   ll_ano,ll_mes

IF idw_master.GetRow()=0 then return


ls_flag_estado = idw_master.Object.flag_estado[1]
ll_ano 			= idw_master.object.ano 		 [1]
ll_mes 			= idw_master.object.mes 		 [1]

/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario


IF ls_flag_estado <> '1' OR ls_result = '0' THEN
	idw_master.ii_protect = 0
	idw_detail.ii_protect = 0
	idw_asiento_det.ii_protect = 0
	idw_master.of_protect()
	idw_detail.of_protect()
	idw_asiento_det.of_protect()
ELSE
	idw_master.of_protect()
	idw_detail.of_protect()
	idw_asiento_det.of_protect()

	IF is_accion <> 'new' THEN
		idw_master.object.ano.Protect = 1
		idw_master.object.mes.Protect = 1
	END IF 
	
	idw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
	idw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	
	idw_asiento_det.Modify("cencos.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	

END IF


end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_print;Long   ll_nro_registro,ll_row_master
String ls_origen


ll_row_master = idw_master.Getrow()

IF ll_row_master = 0 THEN RETURN

IF idw_master.ii_update = 1 OR tab_1.tabpage_2.dw_pre_asiento_cab.ii_update = 1 OR &
   idw_asiento_det.ii_update = 1 THEN 
	Messagebox('Aviso','Debe Grabar Los Cambios Verifique! ')	
	Return
END IF	

ls_origen		 = idw_master.object.origen       [ll_row_master]	
ll_nro_registro = idw_master.object.nro_registro [ll_row_master]	

/*******************/
IF tab_1.tabpage_1.rb_cv.checked THEN
	/*asignacion de dw*/
	dw_rpt.dataobject = 'd_rpt_fomato_chq_voucher_tbl'
//	IF f_imp_cheque_voucher () = FALSE THEN RETURN
ELSEIF tab_1.tabpage_1.rb_v.checked THEN
	/*asignacion de dw*/
	dw_rpt.dataobject = 'd_rpt_fomato_chq_voucher_tbl_solo'
//	IF f_imp_f_general      () = FALSE THEN RETURN
ELSE
	Messagebox('Aviso','Debe Seleccionar Un Tipo de Impresion')
	Return
END IF

dw_rpt.Settransobject(sqlca)

dw_rpt.Retrieve(ls_origen,ll_nro_registro,gs_empresa)

OpenWithParm(w_print_opt, dw_rpt)
If Message.DoubleParm = -1 Then Return
dw_rpt.Print(True)

end event

event ue_delete_pos(long al_row);call super::ue_delete_pos;wf_total()
end event

event closequery;call super::closequery;Destroy invo_cntbl_asiento
end event

event open;call super::open;of_asigna_dws()
end event

type dw_rpt from u_dw_rpt within w_fi312_transferencias
boolean visible = false
integer x = 3653
integer y = 700
string dataobject = "d_rpt_fomato_chq_voucher_tbl"
end type

type tab_1 from tab within w_fi312_transferencias
event ue_find_exact ( )
integer width = 4261
integer height = 1564
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
boolean boldselectedtext = true
integer selectedtab = 1
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type

event ue_find_exact();Parent.TriggerEvent('ue_find_exact')
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

event selectionchanged;CHOOSE CASE newindex
		 CASE 2
				IF ib_estado_preas = FALSE THEN RETURN //No Generacion de Asientos Automaticos
				of_generacion_asiento ()
				idw_asiento_det.Modify("tipo_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")
				idw_asiento_det.Modify("nro_docref1.Protect='1~tIf(IsNull(flag_doc_edit),0,1)'")	

END CHOOSE

end event

event key;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

end event

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4224
integer height = 1444
long backcolor = 79741120
string text = "Transferencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
rb_v rb_v
rb_cv rb_cv
st_1 st_1
dw_detail dw_detail
cb_1 cb_1
dw_master dw_master
gb_1 gb_1
end type

on tabpage_1.create
this.rb_v=create rb_v
this.rb_cv=create rb_cv
this.st_1=create st_1
this.dw_detail=create dw_detail
this.cb_1=create cb_1
this.dw_master=create dw_master
this.gb_1=create gb_1
this.Control[]={this.rb_v,&
this.rb_cv,&
this.st_1,&
this.dw_detail,&
this.cb_1,&
this.dw_master,&
this.gb_1}
end on

on tabpage_1.destroy
destroy(this.rb_v)
destroy(this.rb_cv)
destroy(this.st_1)
destroy(this.dw_detail)
destroy(this.cb_1)
destroy(this.dw_master)
destroy(this.gb_1)
end on

type rb_v from radiobutton within tabpage_1
integer x = 3653
integer y = 400
integer width = 539
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Voucher"
end type

type rb_cv from radiobutton within tabpage_1
integer x = 3653
integer y = 296
integer width = 539
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Cheque / Voucher"
end type

type st_1 from statictext within tabpage_1
integer y = 748
integer width = 233
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean italic = true
boolean underline = true
long textcolor = 8388608
long backcolor = 67108864
string text = "Detalle"
boolean focusrectangle = false
end type

type dw_detail from u_dw_abc within tabpage_1
integer y = 820
integer width = 3566
integer height = 596
integer taborder = 20
string dataobject = "d_abc_transfer_det_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			
ii_rk[1] = 1 	      // columnas que recibimos del master
ii_rk[2] = 2 	      

idw_master 				= tab_1.tabpage_1.dw_master
idw_mst = idw_master	// dw_master

end event

event itemchanged;call super::itemchanged;String ls_matriz_cntbl

Accepttext()

//generacion de asientos automaticos

ib_estado_preas = TRUE


CHOOSE CASE dwo.name
		 
		 CASE 'importe'
				wf_total()
		 CASE 'flag_cxp'
				wf_total()		
		 CASE 'confin'
			   SELECT matriz_cntbl
			     INTO :ls_matriz_cntbl  
			     FROM concepto_financiero
			    WHERE confin = :data    ;
				
				IF Isnull(ls_matriz_cntbl) OR Trim(ls_matriz_cntbl) = '' THEN
					Messagebox('Aviso','Ingrese Un Concepto Financiero Valido')
					Setnull(ls_matriz_cntbl)
					This.Object.confin [row] = ls_matriz_cntbl
					Return 1
				ELSE
					This.object.matriz_cntbl [row] = ls_matriz_cntbl
				END IF 
				
				wf_total()				
END CHOOSE

end event

event itemerror;call super::itemerror;RETURN 1
end event

event ue_insert_pre;call super::ue_insert_pre;This.object.item 		[al_row] = al_row

end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String 		  ls_name,ls_prot
str_parametros    sl_param
str_seleccionar lstr_seleccionar

ls_name = dwo.name
ls_prot = dw_detail.Describe( ls_name + ".Protect")


if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
		 CASE 'confin'

				sl_param.tipo			= ''
				sl_param.opcion		= 3
				sl_param.titulo 		= 'Selección de Concepto Financiero'
				sl_param.dw_master	= 'd_lista_grupo_financiero_grd' //Filtrado para cierto grupo
				sl_param.dw1			= 'd_lista_concepto_financiero_grd'
				sl_param.dw_m			=  This
				OpenWithParm( w_abc_seleccion_md, sl_param)
				IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
				IF sl_param.titulo = 's' THEN
					This.ii_update = 1
					/*Datos del Registro Modificado*/
					ib_estado_preas = TRUE
					/**/
				END IF
END CHOOSE



end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type cb_1 from commandbutton within tabpage_1
integer x = 3707
integer y = 76
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Genera Cheque"
end type

event clicked;str_parametros lstr_param
String        ls_flag_estado ,ls_flag_pago ,ls_codctabco ,ls_afav,ls_result,ls_mensaje
Long          ll_reg_cheque ,ll_row ,ll_nro_cheque,ll_ano,ll_mes
Decimal {2}   ldc_imp_total

idw_master.Accepttext()
ll_row = idw_master.Getrow ()

ll_reg_cheque  = idw_master.object.reg_cheque  [ll_row]
ls_flag_estado = idw_master.object.flag_estado [ll_row]
ls_codctabco	= idw_master.object.cod_ctabco  [ll_row]
ldc_imp_total	= idw_master.object.imp_total	  [ll_row]
ll_ano 			= idw_master.object.ano 		  [ll_row]
ll_mes 			= idw_master.object.mes 		  [ll_row]

/*verifica cierre*/
invo_cntbl_asiento.of_val_mes_cntbl(ll_ano,ll_mes,'B',ls_result,ls_mensaje) //movimiento bancario

IF ls_result = '0' THEN
	Messagebox('Aviso',ls_mensaje)
	
	Return 
END IF

IF is_accion = 'new' THEN
	Messagebox('Aviso','No se Puede Generar Cheque ,Grabe Cambios! ')
	Return 
END IF	

IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','No se Puede Generar Cheque ,Documento Ha sido Anulado')
	Return 
END IF	

IF Isnull(ls_codctabco) OR Trim(ls_codctabco) = '' THEN
	Messagebox('Aviso','No se Puede Generar Cheque ,Verifique Cuenta de banco')
	Return 
END IF


IF Not (Isnull(ll_reg_cheque) ) THEN
	Messagebox('Aviso','No se Puede Generar , Cheque ya Ha Sido Generado!')
	Return 
END IF



//* Open de Ventana de Ayuda*//
lstr_param.string1 = ls_afav

OpenWithParm(w_pop_cheque_afavor,lstr_param)
//* Check text returned in Message object//
IF isvalid(message.PowerObjectParm) THEN
	lstr_param = message.PowerObjectParm
	ls_afav = lstr_param.string1
END IF
//**//

DECLARE PB_USP_FIN_GENER_CHEQUE_X_DOC PROCEDURE FOR USP_FIN_GENER_CHEQUE_X_DOC
(:ls_codctabco , :gs_user ,:ldc_imp_total ,:ls_afav );
EXECUTE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Fallo Store Procedure','Store Procedure USP_FIN_GENER_CHEQUE_X_DOC , Comunicar en Area de Sistemas' )
	Rollback ;
	RETURN
END IF

FETCH PB_USP_FIN_GENER_CHEQUE_X_DOC INTO :ll_reg_cheque,:ll_nro_cheque ;

CLOSE PB_USP_FIN_GENER_CHEQUE_X_DOC ;

IF Isnull(ll_nro_cheque) OR ll_nro_cheque = 0 THEN
	Rollback ;
	Messagebox('Aviso','Coloque Correlativo de Cheque de Cuenta de BANCO ,Verifique!')
	RETURN
END IF

idw_master.object.reg_cheque [ll_row] = ll_reg_cheque
idw_master.object.nro_cheque [ll_row] = ll_nro_cheque

idw_master.ii_update = 1

end event

type dw_master from u_dw_abc within tabpage_1
integer width = 3602
integer height = 740
integer taborder = 30
string dataobject = "d_abc_caja_bancos_transferencias_tbl"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event itemchanged;call super::itemchanged;Accepttext()
String     ls_ctabco_origen,ls_ctabco_destino,ls_cod_moneda,ls_mes,&
			  ls_ctabco,ls_descripcion,ls_cta_cntbl	
Date       ld_fecha_emision
Decimal{3} ldc_tasa_cambio
Long       ll_count
					
					

//generacion de asientos automaticos

ib_estado_preas = TRUE


CHOOSE CASE dwo.name
		 CASE 'cod_ctabco'
				/*validar que cuenta de banco exista*/
				select count(*)
				  into :ll_count
              from banco_cnta
				 where (cod_ctabco = :data) ;
				
				if ll_count = 0 then
					Setnull(ls_ctabco)
					Setnull(ls_descripcion)
					Setnull(ls_cta_cntbl)
					Setnull(ls_cod_moneda)
					
					this.object.cod_ctabco [row] = ls_ctabco
				   this.object.desc_b1    [row] = ls_descripcion
				   this.object.cta_b1	  [row] = ls_cta_cntbl
				   this.object.moneda_b1  [row] = ls_cod_moneda	
			
			
				   /*actualizo moneda de transacion*/
				   This.object.cod_moneda  [row]	= ls_cod_moneda
					
					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				else
					select cod_ctabco,descripcion,cnta_ctbl,cod_moneda
				     into :ls_ctabco,:ls_descripcion,:ls_cta_cntbl,:ls_cod_moneda
                 from banco_cnta
				    where (cod_ctabco = :data) ;
				
	
				   this.object.cod_ctabco [row] = ls_ctabco
				   this.object.desc_b1    [row] = ls_descripcion
				   this.object.cta_b1	  [row] = ls_cta_cntbl
				   this.object.moneda_b1  [row] = ls_cod_moneda	
			
				   /*actualizo moneda de transacion*/
				   This.object.cod_moneda  [row]	= ls_cod_moneda
				
				end if
				/**/
				 
				ls_ctabco_destino = This.object.cod_ctabco_ref[row]
				
				IF data = ls_ctabco_destino THEN
					Messagebox('Aviso','Cuenta Origen no debe ser igual a Cuenta Destino, Verifique!')
					Setnull(ls_ctabco)
					Setnull(ls_descripcion)
					Setnull(ls_cta_cntbl)
					Setnull(ls_cod_moneda)
					
					this.object.cod_ctabco [row] = ls_ctabco
				   this.object.desc_b1     [row] = ls_descripcion
				   this.object.cta_b1	  [row] = ls_cta_cntbl
				   this.object.moneda_b1  [row] = ls_cod_moneda						
					
				   /*actualizo moneda de transacion*/
				   This.object.cod_moneda  [row]	= ls_cod_moneda

					Return 1
					
				END IF
				
				
		 CASE 'cod_ctabco_ref'
				/*validar que cuenta de banco exista*/
				select count(*)
				  into :ll_count
              from banco_cnta
				 where (cod_ctabco = :data) ;
				
				if ll_count = 0 then
					Setnull(ls_ctabco)
					Setnull(ls_descripcion)
					Setnull(ls_cta_cntbl)
					
					this.object.cod_ctabco_ref [row] = ls_ctabco
				   this.object.desc_b2         [row] = ls_descripcion
				   this.object.cta_b2	      [row] = ls_cta_cntbl
					
					Messagebox('Aviso','Cuenta de Banco No Existe Verifique!')
					Return 1
				else
					select cod_ctabco,descripcion,cnta_ctbl
				     into :ls_ctabco,:ls_descripcion,:ls_cta_cntbl
                 from banco_cnta
				    where (cod_ctabco = :data) ;
				
	
				   this.object.cod_ctabco_ref [row] = ls_ctabco
				   this.object.desc_b2         [row] = ls_descripcion
				   this.object.cta_b2	      [row] = ls_cta_cntbl
				
				end if
				/**/

				ls_ctabco_origen = This.object.cod_ctabco[row]	
				
				IF data = ls_ctabco_origen THEN
					Messagebox('Aviso','Cuenta Destino no debe ser igual a Cuenta Origen, Verifique!')
					Setnull(ls_ctabco)
					Setnull(ls_descripcion)
					Setnull(ls_cta_cntbl)
					
					this.object.cod_ctabco_ref [row] = ls_ctabco
				   this.object.desc_b2         [row] = ls_descripcion
				   this.object.cta_b2	      [row] = ls_cta_cntbl

					Return 1
				END IF
		CASE 'fecha_emision'
				ld_fecha_emision     = Date(This.Object.fecha_emision [row])	
				This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)
				This.object.ano [row] = Long(String(ld_fecha_emision,'yyyy'))
				This.object.mes [row] = Long(String(ld_fecha_emision,'mm'))
		CASE 'periodo'
			  ls_mes = Mid(data,1,2)
			
			  IF Isnull(ls_mes) THEN
				  Messagebox('Aviso','Debe Ingresar Un Periodo Valido, Verifique!')
				  This.Object.periodo [row] = ''
				  Return 1
			  ELSEIF Integer(ls_mes) <= 0 OR Integer(ls_mes) > 12 THEN
				  Messagebox('Aviso','Debe Ingresar Un Periodo Valido, Verifique!')
				  This.Object.periodo [row] = ''
				  Return 1
			  END IF					
END CHOOSE

end event

event itemerror;call super::itemerror;Return 1
end event

event constructor;call super::constructor;idw_detail				= tab_1.tabpage_1.dw_detail

is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
                    	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2
ii_dk[1] = 1 	      // columnas que se pasan al detalle
ii_dk[2] = 2

idw_det  = idw_detail


end event

event ue_insert_pre;call super::ue_insert_pre;DateTime ldt_now

ldt_now = gnvo_app.of_fecha_actual()

This.Object.origen  	     		[al_row] = gs_origen
This.Object.cod_usr 	     		[al_row] = gs_user
This.Object.fecha_emision 		[al_row] = Date(ldt_now)
This.Object.fec_registro 		[al_row] = gnvo_app.of_fecha_actual()
This.Object.ano			  		[al_row] = Long(String(ldt_now,'YYYY'))
This.Object.mes				   [al_row] = Long(String(ldt_now,'MM'))
This.Object.tasa_cambio       [al_row] = gnvo_app.of_tasa_cambio()
This.Object.flag_estado       [al_row] = '1'
This.Object.flag_tiptran      [al_row] = '1' 
This.Object.flag_conciliacion [al_row] = '1'  //falta conciliar
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String 	  ls_name,ls_prot
Datawindow ldw
Str_seleccionar lStr_seleccionar
Date        ld_fecha_emision
Decimal 		ldc_tasa_cambio

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
				
	   CASE  'fecha_emision'
				ld_fecha_emision = Date(This.Object.fecha_emision [row])				
				ldw = This
				f_call_calendar(ldw,dwo.name,dwo.coltype, row)
				
				IF ld_fecha_emision <> Date(This.Object.fecha_emision [row]) THEN
					ld_fecha_emision     = Date(This.Object.fecha_emision [row])				
					This.Object.tasa_cambio [row] = gnvo_app.of_tasa_cambio(ld_fecha_emision)	
					//generacion de asientos automaticos
					ib_estado_preas = TRUE
					
					This.ii_update = 1
			   END IF



		 CASE 'cod_ctabco'
			   lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
												       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
												       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
											 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
												       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN '&
												       +'FROM BANCO_CNTA '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ctabco',lstr_seleccionar.param1[1])
					Setitem(row,'desc_b1',lstr_seleccionar.param2[1])
					Setitem(row,'cta_b1',lstr_seleccionar.param3[1])
					Setitem(row,'moneda_b1',lstr_seleccionar.param4[1])
					Setitem(row,'cod_moneda',lstr_seleccionar.param4[1])
					
					ii_update = 1
					/*Generación de Pre Asientos*/
					ib_estado_preas = TRUE
					/**/
				END IF	
				
		 CASE 'cod_ctabco_ref'
			   lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT BANCO_CNTA.COD_CTABCO AS CUENTA_BANCO ,'&
												       +'BANCO_CNTA.DESCRIPCION AS DESCRIPCION ,'&
												       +'BANCO_CNTA.CNTA_CTBL AS CUENTA_CONTABLE,'&      
											 	       +'BANCO_CNTA.COD_MONEDA AS MONEDA,'&
												       +'BANCO_CNTA.COD_ORIGEN  CODIGO_ORIGEN '&
												       +'FROM BANCO_CNTA '
				
				OpenWithParm(w_seleccionar,lstr_seleccionar)
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = "aceptar" THEN
					Setitem(row,'cod_ctabco_ref',lstr_seleccionar.param1[1])
					Setitem(row,'desc_b2',lstr_seleccionar.param2[1])
					Setitem(row,'cta_b2',lstr_seleccionar.param3[1])
					
					ii_update = 1
					/*Generación de Pre Asientos*/
					ib_estado_preas = TRUE
					/**/
				END IF	
				
				
END CHOOSE







end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

type gb_1 from groupbox within tabpage_1
integer x = 3634
integer y = 220
integer width = 576
integer height = 272
integer taborder = 40
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Impresion"
end type

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 4224
integer height = 1444
long backcolor = 79741120
string text = "Asiento"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_pre_asiento_cab dw_pre_asiento_cab
dw_pre_asiento_det dw_pre_asiento_det
end type

on tabpage_2.create
this.dw_pre_asiento_cab=create dw_pre_asiento_cab
this.dw_pre_asiento_det=create dw_pre_asiento_det
this.Control[]={this.dw_pre_asiento_cab,&
this.dw_pre_asiento_det}
end on

on tabpage_2.destroy
destroy(this.dw_pre_asiento_cab)
destroy(this.dw_pre_asiento_det)
end on

type dw_pre_asiento_cab from u_dw_abc within tabpage_2
boolean visible = false
integer y = 744
integer width = 3570
integer height = 684
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_cab_tbl"
end type

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!


end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
ii_ck[5] = 5				// columnas de lectrua de este dw

idw_mst  = tab_1.tabpage_2.dw_pre_asiento_cab				// dw_master

end event

type dw_pre_asiento_det from u_dw_abc within tabpage_2
integer width = 3570
integer height = 732
integer taborder = 20
string dataobject = "d_abc_cnta_cntbl_pre_asiento_det_bak"
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw
ii_ck[4] = 4				// columnas de lectrua de este dw
ii_ck[5] = 5				// columnas de lectrua de este dw
ii_ck[6] = 6				// columnas de lectrua de este dw

idw_mst  = idw_asiento_det				// dw_master

end event

event itemchanged;call super::itemchanged;String ls_codigo
Long   ll_count
Accepttext()

//no generacion de asientos automaticos
ib_estado_preas = FALSE


CHOOSE CASE dwo.name
		 CASE 'tipo_docref1'
				SELECT Count(*)
              INTO :ll_count
              FROM doc_tipo
				 WHERE (tipo_doc = :data );
				
				IF ll_count = 0 THEN
					SetNull(ls_codigo)
					Messagebox('Aviso','Tipo de Documento No Existe Verifique!')
					This.Object.tipo_docref1 [row] = ls_codigo
					Return 2
				END IF
				
END CHOOSE

end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event doubleclicked;IF Getrow() = 0 THEN Return

String     ls_name ,ls_prot ,ls_flag_doc_edit
str_seleccionar lstr_seleccionar
ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if



CHOOSE CASE dwo.name
		 CASE 'tipo_docref1'
				ls_flag_doc_edit = This.object.flag_doc_edit [row]
				
				IF ls_flag_doc_edit = '1' THEN
					Return
				END IF	
				
				lstr_seleccionar.s_seleccion = 'S'
   			lstr_seleccionar.s_sql = 'SELECT DOC_TIPO.TIPO_DOC AS TIPO , '&
										      		 +'DOC_TIPO.DESC_TIPO_DOC AS DESCRIPCION '&
								  				       +'FROM DOC_TIPO '

				OpenWithParm(w_seleccionar,lstr_seleccionar)
				
				IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
				IF lstr_seleccionar.s_action = 'aceptar' THEN
					Setitem(row,'tipo_docref1',lstr_seleccionar.param1[1])
					ii_update = 1
					ib_estado_preas = FALSE
				END IF		
				
END CHOOSE
end event

event ue_insert_pre;call super::ue_insert_pre;this.object.item [al_row] = this.of_nro_item()
end event

