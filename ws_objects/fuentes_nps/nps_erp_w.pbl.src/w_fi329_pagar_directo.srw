$PBExportHeader$w_fi329_pagar_directo.srw
forward
global type w_fi329_pagar_directo from w_abc
end type
type cbx_3 from checkbox within w_fi329_pagar_directo
end type
type cb_2 from commandbutton within w_fi329_pagar_directo
end type
type cbx_2 from checkbox within w_fi329_pagar_directo
end type
type cbx_1 from checkbox within w_fi329_pagar_directo
end type
type tab_1 from tab within w_fi329_pagar_directo
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
type dw_referencia from u_dw_abc within tabpage_2
end type
type tabpage_2 from userobject within tab_1
dw_referencia dw_referencia
end type
type tab_1 from tab within w_fi329_pagar_directo
tabpage_1 tabpage_1
tabpage_2 tabpage_2
end type
type cb_1 from commandbutton within w_fi329_pagar_directo
end type
type rb_gen from radiobutton within w_fi329_pagar_directo
end type
type rb_esp from radiobutton within w_fi329_pagar_directo
end type
type dw_master from u_dw_abc within w_fi329_pagar_directo
end type
type gb_1 from groupbox within w_fi329_pagar_directo
end type
type gb_2 from groupbox within w_fi329_pagar_directo
end type
end forward

global type w_fi329_pagar_directo from w_abc
integer width = 3616
integer height = 1648
string title = "Documentos Pagar Directo (FI329)"
string menuname = "m_mantenimiento_cl_anular_dir"
event ue_find_exact ( )
event ue_anular ( )
event ue_anul_trans ( )
cbx_3 cbx_3
cb_2 cb_2
cbx_2 cbx_2
cbx_1 cbx_1
tab_1 tab_1
cb_1 cb_1
rb_gen rb_gen
rb_esp rb_esp
dw_master dw_master
gb_1 gb_1
gb_2 gb_2
end type
global w_fi329_pagar_directo w_fi329_pagar_directo

type variables
String is_accion,is_flag_valida_cbe
DatawindowChild idw_forma_pago
String      	  is_tabla, is_colname[], is_coltype[]
Boolean		 	  ib_log = FALSE
n_cst_log_diario in_log

//Comprobante de movilidad local
String		is_doc_cml, is_salir
Decimal		idec_monto_max_mov

// Datawindows

u_dw_abc  idw_detail
end variables

forward prototypes
public function boolean wf_asigna_registro ()
public function decimal wf_total ()
public subroutine wf_verifica_anticipos (string as_origen_ref, string as_tipo_ref, string as_nro_ref, ref decimal adc_saldo_sol, ref decimal adc_saldo_dol)
public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp)
public function string of_cbenef_origen (string as_origen)
public function integer of_get_param ()
public subroutine of_cambiar_dw (string as_tipo_doc)
public function integer of_monto_mov (date ad_fec_mov)
public function decimal of_conv_moneda_mov (decimal adec_monto_mov)
public function boolean of_verifica_documento ()
end prototypes

event ue_find_exact();//
String ls_cencos,ls_cnta_prsp,ls_cod_relacion,ls_tipo_doc,ls_nro_doc
str_parametros sl_param

TriggerEvent('ue_update_request')

IF ib_update_check = FALSE THEN RETURN //FALLO ACTUALIZACION

	
sl_param.dw1    = 'd_ext_letras_x_pagar_tbl'
sl_param.dw_m   = dw_master
sl_param.opcion = 6 //comprobante de egreso
OpenWithParm( w_help_datos, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN		
	
	ls_cod_relacion = dw_master.object.cod_relacion [dw_master.getrow()]
	ls_tipo_doc 	 = dw_master.object.tipo_doc     [dw_master.getrow()]
	ls_nro_doc 		 = dw_master.object.nro_doc	   [dw_master.getrow()]
	
	tab_1.tabpage_1.dw_detail.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	tab_1.tabpage_2.dw_referencia.Retrieve(ls_cod_relacion,ls_tipo_doc,ls_nro_doc)
	
	dw_master.il_row = dw_master.getrow()

	TriggerEvent('ue_modify')
	is_accion = 'fileopen'
ELSE
	dw_master.Reset()
	tab_1.tabpage_1.dw_detail.Reset()
	tab_1.tabpage_2.dw_referencia.Reset()
END IF	
end event

event ue_anular;Long    ll_inicio,ll_row_master
Integer li_opcion
String ls_flag_estado,ls_flag_cbancos

ll_row_master = dw_master.getrow()
IF ll_row_master = 0.00 THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado 		 [ll_row_master] 
ls_flag_cbancos = dw_master.object.flag_caja_bancos [ll_row_master] 



li_opcion = MessageBox('Aviso','Seguro que desea eliminar registro', question!, yesno!, 2)

IF li_opcion = 2 THEN RETURN


IF ls_flag_cbancos = '1' THEN
	Messagebox('Aviso','Documento se encuentra Aplicado No se puede Anular ,Verifique!')
	Return
END IF

IF ls_flag_estado  <> '1' THEN 
   Messagebox('Aviso','No se Puede Anular Documento Revise En que estado se Encuentra')
	Return
END IF

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF

dw_master.object.flag_estado [ll_row_master] = '0' 
dw_master.object.importe_doc [ll_row_master] = 0.00
dw_master.object.importe_doc [ll_row_master] = 0.00
dw_master.object.saldo_sol   [ll_row_master] = 0.00
dw_master.object.saldo_dol   [ll_row_master] = 0.00


FOR ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.importe [ll_inicio] = 0.00
NEXT	

/*Elimino detalle de Cntas x pagar*/
DO WHILE tab_1.tabpage_2.dw_referencia.Rowcount() > 0
	tab_1.tabpage_2.dw_referencia.Deleterow(0)
LOOP

dw_master.ii_update = 1
tab_1.tabpage_1.dw_detail.ii_update = 1
tab_1.tabpage_2.dw_referencia.ii_update = 1
is_accion = 'delete'

end event

event ue_anul_trans();Long   ll_inicio,ll_row_master
Integer li_opcion
String ls_flag_estado,ls_flag_cbancos
Boolean lbo_ok = TRUE

ll_row_master = dw_master.getrow()


IF ll_row_master = 0.00 THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado 		 [ll_row_master] 
ls_flag_cbancos = dw_master.object.flag_caja_bancos [ll_row_master] 


li_opcion = MessageBox('Aviso','Seguro que desea eliminar registro', question!, yesno!, 2)

IF li_opcion = 2 THEN RETURN



IF ls_flag_cbancos = '1' THEN
	Messagebox('Aviso','Documento se encuentra Aplicado No se puede Anular ,Verifique!')
	Return
END IF

IF ls_flag_estado  <> '1' THEN 
   Messagebox('Aviso','No se Puede Anular Documento Revise En que estado se Encuentra')
	Return
END IF

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR &
	tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN 
	Messagebox('Aviso','Tiene Actualizaciones Pendientes Grabe Antes de Anular ,Verifique!')
	Return
END IF


//eliminar
/*Elimino detalle de Cntas x pagar*/
DO WHILE tab_1.tabpage_2.dw_referencia.Rowcount() > 0
	tab_1.tabpage_2.dw_referencia.Deleterow(0)
LOOP

/*Elimino referencias de Cntas Pagar*/
DO WHILE tab_1.tabpage_1.dw_detail.Rowcount() > 0
	tab_1.tabpage_1.dw_detail.Deleterow(0)
LOOP


/*elimino cabecera*/
dw_master.deleterow (dw_master.Getrow())


//grabacion alterna
IF	lbo_ok = TRUE THEN
	IF tab_1.tabpage_2.dw_referencia.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	lbo_ok = TRUE THEN
	IF tab_1.tabpage_1.dw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF	lbo_ok = TRUE THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
		lbo_ok = FALSE
		Messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_referencia.ii_update = 0
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

public function boolean wf_asigna_registro ();Long   ll_nro_ce = 0
String ls_lock_table,ls_tipo_doc


ls_tipo_doc = dw_master.object.tipo_doc [1]

ls_lock_table = 'LOCK TABLE NUM_DOC_TIPO IN EXCLUSIVE MODE'
EXECUTE IMMEDIATE :ls_lock_table ;


SELECT ultimo_numero
  INTO :ll_nro_ce
  FROM num_doc_tipo
 WHERE tipo_doc = :ls_tipo_doc ;

  
IF Isnull(ll_nro_ce) OR ll_nro_ce = 0 THEN
	Messagebox('Aviso','Verificar Información En Tabla NUM_DOC_TIPO, Comuniquese Con Sistemas')	
	Rollback ;
	Return FALSE
ELSE
	UPDATE num_doc_tipo
	   SET ultimo_numero = ultimo_numero + 1
	 WHERE tipo_doc = :ls_tipo_doc ;
	 
	IF SQLCA.SQLCode = -1 THEN 
		MessageBox("SQL error", SQLCA.SQLErrText)
		Rollback ;
		Return FALSE
	END IF	 
	 
END IF

dw_master.object.nro_doc [1] = gnvo_app.is_origen+f_llena_caracteres('0',Trim(String(ll_nro_ce)),8)

Return TRUE
end function

public function decimal wf_total ();Long    ll_inicio
Decimal {2} ldc_importe = 0.00,ldc_total_importe = 0.00

For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	 ldc_importe = tab_1.tabpage_1.dw_detail.object.importe [ll_inicio]
	 IF Isnull(ldc_importe) THEN ldc_importe = 0.00
	 ldc_total_importe = ldc_total_importe + ldc_importe 
Next	


Return ldc_total_importe
end function

public subroutine wf_verifica_anticipos (string as_origen_ref, string as_tipo_ref, string as_nro_ref, ref decimal adc_saldo_sol, ref decimal adc_saldo_dol);Boolean		lb_ret = TRUE


DECLARE PB_usp_fin_monto_anticipos_gen PROCEDURE FOR usp_fin_monto_anticipos_gen 
(:as_origen_ref,:as_tipo_ref,:as_nro_ref);
EXECUTE PB_usp_fin_monto_anticipos_gen ;



IF SQLCA.SQLCode = -1 THEN 
	lb_ret = FALSE
	MessageBox("SQL error", SQLCA.SQLErrText)
	
END IF

FETCH PB_usp_fin_monto_anticipos_gen INTO :adc_saldo_sol,:adc_saldo_dol ;
CLOSE PB_usp_fin_monto_anticipos_gen ;



end subroutine

public function long of_verif_partida (long al_ano, string as_cencos, string as_cnta_prsp);Long ll_count 

select Count(*) into :ll_count from presupuesto_partida pp,tipo_prtda_prsp_det ttd
 where (pp.tipo_prtda_prsp = ttd.tipo_prtda_prsp ) and
       (ttd.grp_prtda_prsp = (select ppa.grp_prtda_prsp_fondos from  presup_param ppa)) and
       (pp.ano             = :al_ano             ) and
       (pp.cencos          = :as_cencos          ) and
       (pp.cnta_prsp       = :as_cnta_prsp       ) ;
		 
		 
Return ll_count

end function

public function string of_cbenef_origen (string as_origen);
String ls_cen_ben

select cen_bef_gen_oc into :ls_cen_ben
  from origen where cod_origen = :as_origen ;
  

Return ls_cen_ben  
end function

public function integer of_get_param ();// Para obtener los parametos de comprobante de movilidad
// local

SELECT   NVL(A.DOC_MOVILIDAD, ''), NVL(A.MONTO_MAX_MOV, 0 )
 INTO		:is_doc_cml, :idec_monto_max_mov
FROM 		FINPARAM A
WHERE    RECKEY = '1';

IF sqlca.sqlcode = 100 THEN
	Messagebox( "Error", "No ha definido parametros " + &
					'~n~r' + 'de movilidad en FINPARAM')
	RETURN 0
END IF

IF ISNULL(is_doc_cml) OR is_doc_cml = '' THEN
	messagebox('Error', 'No ha definido tipo de comprobante' + &
				'~n~r' + 'de movilidad local en FINPARAM')
	RETURN 0
END IF

IF ISNULL(idec_monto_max_mov) OR idec_monto_max_mov = 0 THEN
	messagebox('Error', 'No ha definido el monto maximo por ' + &
				'~n~r' + 'concepto de movilidad local')
	RETURN 0
END IF

RETURN 1
end function

public subroutine of_cambiar_dw (string as_tipo_doc);integer 	li_count
String	ls_cod, ls_null

SetNull(ls_null)
// funcion para cambiar el dw si tipo_doc = comprobante movilidad

// primero verifico si la cabecera tiene registros
if dw_master.rowCount( ) = 0 then return

IF as_tipo_doc = TRIM(is_doc_cml) THEN
	// Verifico si el cod de relacion que ha ingresado sea
	// un trabajador
	ls_cod = dw_master.object.cod_relacion [dw_master.GetRow()]
	
	select count(*)
	  into :li_count
	  from maestro
	 where cod_trabajador = :ls_cod
	   and flag_estado = '1';
	 
	if li_count = 0 then
		MessageBox('Aviso', 'Para hacer un comprobante de movilidad debe seleccionar un trabajador de la empresa activo, por favor verifique')
		dw_master.object.tipo_doc [dw_master.getRow()] = ls_null
		dw_master.setfocus( )
		dw_master.setcolumn( "tipo_doc" )
		return
	end if
	
	idw_detail.dataobject = 'd_abc_comprobante_egreso_det_mov_tbl'
	idw_detail.SetTransObject( SQLCA)
ELSE
	idw_detail.dataobject = 'd_abc_comprobante_egreso_det_tbl'
	idw_detail.SetTransObject( SQLCA)
END IF

//Parent.Event resize()

end subroutine

public function integer of_monto_mov (date ad_fec_mov);// Función para calcular el monto diario en soles por movilidad
Long		ll_i
Decimal	ldec_monto_mov
String	ls_cod_soles, ls_moneda_cab

ls_cod_soles  = f_cod_moneda_soles()
ls_moneda_cab = dw_master.object.cod_moneda [dw_master.GetRow()]

idw_detail.SetSort('fec_movilidad A')

ldec_monto_mov = 0
FOR ll_i = 1 TO idw_detail.Rowcount( )
	IF ad_fec_mov = date(idw_detail.object.fec_movilidad [ll_i]) THEN
		ldec_monto_mov = ldec_monto_mov + &
						of_conv_moneda_mov(DEC(idw_detail.object.importe [ll_i]))
	END IF

NEXT

RETURN ldec_monto_mov
end function

public function decimal of_conv_moneda_mov (decimal adec_monto_mov);// Funcion para calcular el monto en Soles
Decimal	ldec_monto_mov, ldec_tasa_cambio
String	ls_cod_soles, ls_moneda_cab, ls_cod_dolares

ls_cod_soles  		= f_cod_moneda_soles()
ls_cod_dolares		= f_cod_moneda_dolares()

ls_moneda_cab 		= dw_master.object.cod_moneda  [dw_master.GetRow()]
ldec_tasa_cambio 	= dw_master.object.tasa_cambio [dw_master.GetRow()]

IF ls_moneda_cab = ls_cod_soles THEN
	ldec_monto_mov = adec_monto_mov
END IF

IF ls_moneda_cab = ls_cod_dolares THEN
	ldec_monto_mov = Round(adec_monto_mov * ldec_tasa_cambio,2)
END IF

RETURN ldec_monto_mov


end function

public function boolean of_verifica_documento ();String  ls_cod_relacion,ls_tipo_doc,ls_nro_doc
Long    ll_count

dw_master.Accepttext()

ls_cod_relacion = dw_master.object.cod_relacion [1]
ls_tipo_doc	 	 = dw_master.object.tipo_doc 	   [1]
ls_nro_doc	 	 = dw_master.object.nro_doc  	   [1]
					
// Antes de hacer la verificación al servidor de base de datos
// verifico que los datos no tengan valor nulo
if IsNull(ls_cod_relacion) or IsNull(ls_tipo_doc) or IsNull(ls_nro_doc) then 
	return true
end if
					
//VERIFIQUE SI EXISTE
select Count(*) 
  into :ll_count 
  from cntas_pagar
 where cod_relacion 	= :ls_cod_relacion  
   and tipo_doc		= :ls_tipo_doc      
	and nro_doc			= :ls_nro_doc;
			
if ll_count > 0 then
	Messagebox('Aviso','El Documento ' + ls_cod_relacion &
			+ ' ' + ls_tipo_doc + ' ' + ls_nro_doc &
			+ ' ya ha sido Registrado, por favor verifique')						
	return false
end if					

Return true
end function

on w_fi329_pagar_directo.create
int iCurrent
call super::create
if this.MenuName = "m_mantenimiento_cl_anular_dir" then this.MenuID = create m_mantenimiento_cl_anular_dir
this.cbx_3=create cbx_3
this.cb_2=create cb_2
this.cbx_2=create cbx_2
this.cbx_1=create cbx_1
this.tab_1=create tab_1
this.cb_1=create cb_1
this.rb_gen=create rb_gen
this.rb_esp=create rb_esp
this.dw_master=create dw_master
this.gb_1=create gb_1
this.gb_2=create gb_2
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cbx_3
this.Control[iCurrent+2]=this.cb_2
this.Control[iCurrent+3]=this.cbx_2
this.Control[iCurrent+4]=this.cbx_1
this.Control[iCurrent+5]=this.tab_1
this.Control[iCurrent+6]=this.cb_1
this.Control[iCurrent+7]=this.rb_gen
this.Control[iCurrent+8]=this.rb_esp
this.Control[iCurrent+9]=this.dw_master
this.Control[iCurrent+10]=this.gb_1
this.Control[iCurrent+11]=this.gb_2
end on

on w_fi329_pagar_directo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cbx_3)
destroy(this.cb_2)
destroy(this.cbx_2)
destroy(this.cbx_1)
destroy(this.tab_1)
destroy(this.cb_1)
destroy(this.rb_gen)
destroy(this.rb_esp)
destroy(this.dw_master)
destroy(this.gb_1)
destroy(this.gb_2)
end on

event ue_open_pre;call super::ue_open_pre;
is_salir = ''

//Verifico que se cargen los parametros en variables de instancia
IF of_get_param() = 0 THEN
   is_salir = 'S'
	post event closequery()   
	RETURN
END IF

// Para activar el log diario
ib_log = TRUE
is_tabla = dw_master.Object.Datawindow.Table.UpdateTable


dw_master.SetTransObject(sqlca)  			         // Relacionar el dw con la base de datos
tab_1.tabpage_1.dw_detail.SetTransObject(sqlca)
tab_1.tabpage_2.dw_referencia.SetTransObject(sqlca)


idw_1 = dw_master              				// asignar dw corriente
tab_1.tabpage_1.dw_detail.BorderStyle = StyleRaised!		// indicar dw_detail como no activado

of_position_window(0,0)       			// Posicionar la ventana en forma fija


//** Insertamos GetChild de Forma de Pago **//
dw_master.Getchild('forma_pago',idw_forma_pago)
idw_forma_pago.settransobject(sqlca)
idw_forma_pago.Retrieve()
//** **//


select flag_centro_benef into :is_flag_valida_cbe from logparam where reckey = '1' ;
end event

event ue_update_pre;Long 	  ll_inicio,ll_count,ll_ano
String  ls_cod_relacion,ls_tipo_doc,ls_nro_doc    ,ls_nro_reg        ,ls_flag        ,&
		  ls_soles       ,ls_dolares ,ls_cod_moneda ,ls_flag_llave_num ,ls_flag_apresup,&
		  ls_cnta_prsp   ,ls_cencos  ,ls_item		  ,ls_fctrl_reg		,ls_doc_aoc		,&
		  ls_doc_aos	  ,ls_nro_ref ,ls_flag_estado,ls_origen_ref		,ls_tipo_ref	,&
		  ls_doc_ov		  ,ls_cebef
Decimal {2} ldc_importe_doc  ,ldc_saldo_sol		,ldc_saldo_dol		 ,ldc_monto_total	  ,&
				ldc_saldo_sol_ant,ldc_saldo_dol_ant ,ldc_saldo_sol_old ,ldc_saldo_dol_old
Decimal {3} ldc_tasa_cambio


if is_accion = 'delete' then return

IF dw_master.Rowcount() = 0  THEN
	ib_update_check = False	
	RETURN
END IF	

IF is_accion = 'new' THEN
	if of_verifica_documento () = false then
		ib_update_check = False	
		Return
	end if
END IF


//lee parametros
select doc_anticipo_oc,doc_anticipo_os into :ls_doc_aoc,:ls_doc_aos
  from finparam
 where (reckey = '1') ;

 select doc_ov into :ls_doc_ov
   from logparam
  where (reckey = '1') ;
  

f_monedas(ls_soles,ls_dolares)

//Verificación de Data en Cabecera de Documento
IF f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF


//Verificación de Data en Cabecera de Documento
IF f_row_Processing(tab_1.tabpage_1.dw_detail, "form") <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF

ls_cod_relacion = dw_master.Object.cod_relacion     [1] 
ls_tipo_doc     = dw_master.Object.tipo_doc		    [1] 
ls_nro_doc      = dw_master.Object.nro_doc  	       [1] 
ldc_importe_doc = dw_master.Object.importe_doc      [1] 
ls_cod_moneda	 = dw_master.Object.cod_moneda       [1] 
ldc_tasa_cambio = dw_master.Object.tasa_cambio      [1] 
ls_flag_apresup = dw_master.Object.flag_afecta_prsp [1] 
ls_fctrl_reg	 = dw_master.Object.flag_control_reg [1]
ls_flag_estado	 = dw_master.Object.flag_estado		 [1]



ll_ano = Long(String(dw_master.object.fecha_emision [1],'yyyy'))


IF is_accion = 'new' THEN 
	//asignar nro de documento de acuerado a flag
	ls_flag = f_tdoc_fnum(ls_tipo_doc)
	
	IF ls_flag = '1' THEN
		/*Asigna Nro de Doc*/
		IF wf_asigna_registro () = FALSE THEN
			ib_update_check = False	
			return		
		END IF	
	END IF

	ls_nro_doc = dw_master.Object.nro_doc [1] 
END IF

//nro de docuemnto no puede ser nulo
IF Isnull(ls_nro_doc) OR Trim(ls_nro_doc) = '' THEN
	Messagebox('Aviso','Nro de Documento No Puede Ser Nulo , Verifique')
	ib_update_check = False	
	Return
END IF


IF ls_cod_moneda = ls_soles THEN 
	ldc_saldo_sol = ldc_importe_doc
	ldc_saldo_dol = Round(ldc_importe_doc / ldc_tasa_cambio ,2)
ELSEIF ls_cod_moneda = ls_dolares THEN
	ldc_saldo_sol = Round(ldc_importe_doc *  ldc_tasa_cambio ,2)
	ldc_saldo_dol = ldc_importe_doc
END IF

//saldos
dw_master.object.saldo_sol [1] = ldc_saldo_sol 
dw_master.object.saldo_dol [1] = ldc_saldo_dol


For ll_inicio = 1  TO tab_1.tabpage_1.dw_detail.Rowcount()
	 tab_1.tabpage_1.dw_detail.object.cod_relacion [ll_inicio] = ls_cod_relacion 
	 tab_1.tabpage_1.dw_detail.object.tipo_doc     [ll_inicio] = ls_tipo_doc
	 tab_1.tabpage_1.dw_detail.object.nro_doc		  [ll_inicio] = ls_nro_doc
	 
    ls_cebef 	  = tab_1.tabpage_1.dw_detail.object.centro_benef [ll_inicio]
	 ls_item		  = Trim(String(tab_1.tabpage_1.dw_detail.object.item [ll_inicio]))
	 ls_cnta_prsp = tab_1.tabpage_1.dw_detail.object.cnta_prsp [ll_inicio]
	 ls_cencos	  = tab_1.tabpage_1.dw_detail.object.cencos    [ll_inicio]
	 
	 
	 if is_flag_valida_cbe = '1' then
		 IF Isnull(ls_cebef) OR Trim(ls_cebef) = '' THEN
			 Messagebox('Aviso','Centro de Beneficio No Puede Ser Nulo , Verifique!')
			 ib_update_check = False	
		    Return 			 	
			
		 END IF
	 end if
	 
	 //verifica presupuesto de acuerdo a flag de documento
	 if ls_flag_apresup = '1' then //validar partidas
	 	 select count(*) into :ll_count from presupuesto_partida 
		  where (cencos    = :ls_cencos    ) and
		  		  (cnta_prsp = :ls_cnta_prsp ) and
				  (ano		 = :ll_ano       );
		 
		 
		 
		 if ll_count = 0 then
			 Messagebox('Aviso','Partida Presupuestal de Item'+ ls_item +' No Existe ,Verifique!')
		 	 ib_update_check = False				 
			 RETURN
		 end if
		  
		
	 end if
		 
	 
	 
Next	

For ll_inicio = 1  TO tab_1.tabpage_2.dw_referencia.Rowcount()
	 tab_1.tabpage_2.dw_referencia.object.cod_relacion [ll_inicio] = ls_cod_relacion
	 tab_1.tabpage_2.dw_referencia.object.tipo_doc     [ll_inicio] = ls_tipo_doc
	 tab_1.tabpage_2.dw_referencia.object.nro_doc		[ll_inicio] = ls_nro_doc
	 
	
Next


if (trim(ls_doc_aoc) = trim(ls_tipo_doc) or trim(ls_doc_aos) = trim(ls_tipo_doc)) then
	if ls_fctrl_reg = '0' then //debe ser documento tipo cuenta corriente
		Messagebox('Aviso','Documento debe ser Tipo Cuenta Corriente')
		ib_update_check = False				 
		RETURN
	end if
end if






//datos de referencia
select flag_llave_num into :ls_flag_llave_num from doc_tipo where (tipo_doc = :ls_tipo_doc ) ;

IF ls_flag_llave_num = '0' AND tab_1.tabpage_2.dw_referencia.Rowcount() > 0 THEN
	
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	ib_update_check = False	
	Return
	
ELSEIF ls_flag_llave_num = '1' AND tab_1.tabpage_2.dw_referencia.Rowcount() = 0 THEN
	Messagebox('Aviso','Documento pide Referencia ,Verifique!')
	ib_update_check = False	
	return	
ELSEIF ls_flag_llave_num = '1' AND tab_1.tabpage_2.dw_referencia.Rowcount() > 1 THEN
	Messagebox('Aviso','Documento solo debe pedir Una Referencia ,Verifique!')
	ib_update_check = False	
	return		
END IF


/*verificar monto*/
if ls_flag_llave_num = '1' and ls_flag_estado = '1' then
	ls_origen_ref = tab_1.tabpage_2.dw_referencia.object.origen_ref [1]
	ls_tipo_ref	  = tab_1.tabpage_2.dw_referencia.object.tipo_ref   [1]
	ls_nro_ref    = tab_1.tabpage_2.dw_referencia.object.nro_ref  	 [1]

	if ls_fctrl_reg = '0' then //debe ser documento tipo cuenta corriente
		Messagebox('Aviso','Documento debe ser Tipo Cuenta Corriente')
		ib_update_check = False				 
		RETURN
	end if


	if ls_tipo_ref = ls_doc_ov then
		GOTO SALIDA
		//CUANDO ES UNA PROFORMA ..NO VALIDA MONTOS
	end if
	
	if TRIM(ls_tipo_doc) = TRIM(ls_doc_aoc) then //orden compra
		select monto_total into :ldc_monto_total from orden_compra where nro_oc = :ls_nro_ref ;
	elseif TRIM(ls_tipo_doc) = TRIM(ls_doc_aos) then //orden servicio
		select monto_total into :ldc_monto_total from orden_servicio where nro_os = :ls_nro_ref ;
	end if

	if ldc_importe_doc > ldc_monto_total  and ls_flag_estado = '1' then
		Messagebox('Aviso','Monto de Anticipo no debe ser mayor al de la Orden')
		ib_update_check = False	
		return		
	end if
	
	


	
	wf_verifica_anticipos (ls_origen_ref,ls_tipo_ref,ls_nro_ref,ldc_saldo_sol_ant,ldc_saldo_dol_ant)
	
	//verifico control de anticipos
	if is_accion = 'new' then
		if ls_cod_moneda = ls_soles then
			ldc_saldo_sol = ldc_saldo_sol_ant + ldc_saldo_sol
		
			if ldc_saldo_sol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		elseif ls_cod_moneda = ls_dolares then
			
			ldc_saldo_dol = ldc_saldo_dol_ant + ldc_saldo_dol
		
			if ldc_saldo_dol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		end if		
		
	elseif is_accion = 'fileopen' then
		//busco saldo de documento actual
		select saldo_sol,saldo_dol into :ldc_saldo_sol_old,:ldc_saldo_dol_old
		  from cntas_pagar where (tipo_doc     = :ls_tipo_doc    ) and
   		                      (nro_doc      = :ls_nro_doc     ) and
										 (cod_relacion = :ls_cod_relacion) ;
												
		
		if ls_cod_moneda = ls_soles then
			ldc_saldo_sol = (ldc_saldo_sol_ant - ldc_saldo_sol_old) + ldc_saldo_sol
		
			if ldc_saldo_sol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		elseif ls_cod_moneda = ls_dolares then
			
			ldc_saldo_dol = (ldc_saldo_dol_ant - ldc_saldo_dol_old)+ ldc_saldo_dol
		
			if ldc_saldo_dol > ldc_monto_total  and ls_flag_estado = '1' then
				Messagebox('Aviso','Montos de Anticipos no debe ser mayor al de la Orden')
				ib_update_check = False	
				return		
			end if 
			
		end if		
		
	end if
	
	

end if



SALIDA:

/*Replicacion*/
dw_master.of_set_flag_replicacion()
tab_1.tabpage_1.dw_detail.of_set_flag_replicacion()
tab_1.tabpage_2.dw_referencia.of_set_flag_replicacion()

end event

event ue_insert;call super::ue_insert;Long   ll_row,ll_row_master
String ls_flag_estado


IF idw_1 = dw_master THEN
	TriggerEvent('ue_update_request')
	idw_1.Reset ()
	tab_1.tabpage_1.dw_detail.Reset ()
	tab_1.tabpage_2.dw_referencia.Reset ()
	is_accion = 'new'
ELSEIF idw_1 = tab_1.tabpage_1.dw_detail THEN
	ll_row_master  = dw_master.getrow()
	ls_flag_estado = dw_master.object.flag_estado [ll_row_master]
	
	IF ls_flag_estado <> '1' THEN
		Messagebox('Aviso','No se Pueden Ingresar Registros en el Detalle, Verifique Estado del Documento!')
		Return
	END IF
ELSEIF idw_1 = tab_1.tabpage_2.dw_referencia THEN
	RETURN
END IF	


ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN THIS.EVENT ue_insert_pos(ll_row)


end event

event ue_update_request;call super::ue_update_request;Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 OR tab_1.tabpage_2.dw_referencia.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		tab_1.tabpage_1.dw_detail.ii_update 	 = 0
		tab_1.tabpage_2.dw_referencia.ii_update = 0
	END IF
END IF
end event

event ue_update;call super::ue_update;Boolean lbo_ok = TRUE

dw_master.AcceptText()
tab_1.tabpage_1.dw_detail.AcceptText()
tab_1.tabpage_2.dw_referencia.AcceptText()


THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN 
	Rollback ;
	RETURN
END IF	

IF ib_log THEN
	Datastore		lds_log
	lds_log = Create DataStore
	lds_log.DataObject = 'd_log_diario_tbl'
	lds_log.SetTransObject(SQLCA)
	in_log.of_create_log(dw_master, lds_log, is_colname, is_coltype, gnvo_app.is_user, is_tabla, gnvo_app.invo_empresa.is_empresa)
END IF

if is_accion = 'delete' then

	IF tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN
		IF tab_1.tabpage_2.dw_referencia.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	
	IF tab_1.tabpage_1.dw_detail.ii_update = 1 THEN
		IF tab_1.tabpage_1.dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF



	
ELSE
	IF	dw_master.ii_update = 1 AND lbo_ok = TRUE THEN
		IF dw_master.Update(true, false) = -1 then		// Grabacion del Master
			lbo_ok = FALSE
			messagebox("Error en Grabacion Master","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF tab_1.tabpage_1.dw_detail.ii_update = 1 THEN
		IF tab_1.tabpage_1.dw_detail.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF

	IF tab_1.tabpage_2.dw_referencia.ii_update = 1 THEN
		IF tab_1.tabpage_2.dw_referencia.Update(true, false) = -1 then		// Grabacion del detalle
			lbo_ok = FALSE
			messagebox("Error en Grabacion Detalle","Se ha procedido al rollback",exclamation!)
		END IF
	END IF	
END IF

IF ib_log THEN
	IF lbo_ok THEN
		IF lds_log.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Base de Datos', 'No se pudo grabar el Log Diario')
		END IF
	END IF
	DESTROY lds_log
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	tab_1.tabpage_1.dw_detail.ii_update = 0
	tab_1.tabpage_2.dw_referencia.ii_update = 0
	is_accion = 'fileopen'
	TriggerEvent('ue_modify')
ELSE 
	ROLLBACK USING SQLCA;
END IF

end event

event ue_delete;//override
Long   ll_row
String ls_flag_estado,ls_flag_cbancos

IF ii_pregunta_delete = 1 THEN
	IF MessageBox("Eliminacion de Registro", "Esta Seguro ?", Question!, YesNo!, 2) <> 1 THEN
		RETURN
	END IF
END IF

IF idw_1 = dw_master THEN RETURN

ls_flag_estado  = dw_master.object.flag_estado      [dw_master.Getrow()]
ls_flag_cbancos = dw_master.object.flag_caja_bancos [dw_master.Getrow()]

IF ls_flag_estado <> '1' OR ls_flag_cbancos <> '0' THEN RETURN
	

ll_row = idw_1.Event ue_delete()

IF ll_row = 1 THEN
	THIS.Event ue_delete_list()
	THIS.Event ue_delete_pos(ll_row)
END IF

end event

event resize;call super::resize;tab_1.width  = newwidth  - tab_1.x - 10
tab_1.height = newheight - tab_1.y - 30

//dw_master.width  = newwidth  - dw_master.x - 10
tab_1.tabpage_1.dw_detail.width 	 	 = tab_1.width  - tab_1.tabpage_1.dw_detail.x     - 70
tab_1.tabpage_1.dw_detail.height 	 = tab_1.height - tab_1.tabpage_1.dw_detail.y     - 140
tab_1.tabpage_2.dw_referencia.height = tab_1.height - tab_1.tabpage_2.dw_referencia.y - 140
end event

event ue_modify;call super::ue_modify;Long    ll_row_master
Integer li_protect
String  ls_flag_estado,ls_tipo_doc,ls_flag,ls_flag_cbancos

ll_row_master = dw_master.Getrow()

ls_flag_estado  = dw_master.Object.flag_estado      [ll_row_master] 
ls_tipo_doc     = dw_master.Object.tipo_doc         [ll_row_master]
ls_flag_cbancos = dw_master.Object.flag_caja_bancos [ll_row_master]


dw_master.of_protect()
tab_1.tabpage_1.dw_detail.of_protect()

IF ls_flag_estado <> '1' OR ls_flag_cbancos = '1' THEN
	dw_master.ii_protect  = 0
	tab_1.tabpage_1.dw_detail.ii_protect	 = 0
	tab_1.tabpage_2.dw_referencia.ii_protect	 = 0
	dw_master.of_protect()
	tab_1.tabpage_1.dw_detail.of_protect()
	tab_1.tabpage_2.dw_referencia.of_protect()
	
	
ELSE
	IF is_accion = 'fileopen' THEN
		// Protejo tipo de cambio
		IF idw_detail.Rowcount( ) > 0 THEN
			dw_master.object.cod_moneda.Protect = 1
		END IF
		li_protect = integer(dw_master.Object.tipo_doc.Protect)
		IF li_protect = 0	THEN
			dw_master.object.tipo_doc.Protect 	  = 1
			dw_master.object.cod_relacion.Protect = 1
			dw_master.object.nro_doc.Protect      = 1
			tab_1.tabpage_1.dw_detail.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")
		END IF
		
	END IF		
END IF	
end event

event ue_retrieve_list;//override
// Asigna valores a structura 
Long   ll_row , ll_inicio ,ll_ano ,ll_count
String ls_cencos,ls_cnta_prsp ,ls_origen ,ls_null ,ls_cebef
str_parametros sl_param

SetNull(ls_null)
TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'd_abc_lista_doc_pagar_dir_tbl'
sl_param.titulo = 'Cuentas x Pagar'
sl_param.field_ret_i[1] = 1	//Codigo de Relación
sl_param.field_ret_i[2] = 2	//Tipo Doc
sl_param.field_ret_i[3] = 3	//Nro Doc

//OpenWithParm( w_search_datos, sl_param)
OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	dw_master.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
   of_cambiar_dw(Trim(sl_param.field_ret[2]))
	idw_detail.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	tab_1.tabpage_2.dw_referencia.Retrieve(sl_param.field_ret[1],sl_param.field_ret[2],sl_param.field_ret[3])
	
	For ll_inicio = 1 TO tab_1.tabpage_1.dw_detail.Rowcount()
	    if is_flag_valida_cbe = '1' then //valida centro de beneficio
	   	 ls_cencos    = tab_1.tabpage_1.dw_detail.object.cencos	  [ll_inicio]
			 ls_cnta_prsp = tab_1.tabpage_1.dw_detail.object.cnta_prsp [ll_inicio]
			 ll_ano		  = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
			 ls_origen	  = dw_master.object.origen 		  [1]	
			 
			 //VERIFICAR SIEMPRE Y CUANDO CUMPLA CONDICIONES DE PARTIDA FONDO
			 ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

			 if ll_count > 0 then
				 tab_1.tabpage_1.dw_detail.object.flag_cebef   [ll_inicio] = ls_null	//no editable tipo fondo
				 ls_cebef = tab_1.tabpage_1.dw_detail.object.centro_benef [ll_inicio]
				 
				 if Isnull(ls_cebef) or Trim(ls_cebef) = '' then
					 tab_1.tabpage_1.dw_detail.object.centro_benef [ll_inicio] = of_cbenef_origen(ls_origen)
					 tab_1.tabpage_1.dw_detail.ii_update = 1
					 dw_master.ii_update = 1
				 end if
			 else
			    tab_1.tabpage_1.dw_detail.object.flag_cebef   [ll_inicio] = '1'     //editable		
			 end if
		 end if	 
	Next
	
	dw_master.il_row = dw_master.getrow()
	
	TriggerEvent('ue_modify')
	is_accion = 'fileopen'	
END IF


end event

event ue_print;call super::ue_print;String  ls_tip_doc, ls_cod_relacion,ls_nro_ce,ls_flag_rep
Str_cns_pop lstr_cns_pop
Long ll_row_master

ll_row_master = dw_master.Getrow ()
IF ll_row_master = 0 THEN RETURN

IF dw_master.ii_update = 1 OR tab_1.tabpage_1.dw_detail.ii_update = 1 THEN 
	Messagebox('Aviso','Debe Grabar el Documento , Tiene Modificaciones , Verifique!')
	Return
END IF	

IF rb_gen.checked THEN
	ls_flag_rep = 'G'
ELSEIF rb_esp.checked THEN
	ls_flag_rep = 'E'	
END IF

//Verificacion de comprobante de Egreso
ls_tip_doc      = dw_master.object.tipo_doc		[ll_row_master]
ls_nro_ce       = dw_master.object.nro_doc		[ll_row_master]
ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]

lstr_cns_pop.arg[1] = trim(ls_cod_relacion)
lstr_cns_pop.arg[2] = trim(ls_tip_doc)
lstr_cns_pop.arg[3] = trim(ls_nro_ce)
lstr_cns_pop.arg[4] = trim(ls_flag_rep)
lstr_cns_pop.arg[5] = trim(is_doc_cml)
lstr_cns_pop.arg[6] = String(idec_monto_max_mov, '###,##0.00')

	

//IF f_imp_f_general () = FALSE THEN RETURN
	

OpenSheetWithParm(w_rpt_comprobante_egreso, lstr_cns_pop, this, 2, Original!)

end event

event key;call super::key;IF key = KeyF4! THEN
	TriggerEvent('ue_find_exact')
END IF
end event

event ue_delete_pos;call super::ue_delete_pos;/*actualizar cabecera*/
dw_master.object.importe_doc [dw_master.getrow()] = wf_total ()
dw_master.ii_update = 1 

IF idw_detail.rowcount( ) = 0 THEN
	dw_master.object.cod_moneda.Protect = 0
END IF
	
end event

event ue_open_pos;call super::ue_open_pos;IF ib_log THEN							
	in_log = Create n_cst_log_diario
   in_log.of_dw_map(idw_1, is_colname, is_coltype)
END IF
end event

event open;call super::open;//ib_log = TRUE
//is_tabla = dw_master.Object.Datawindow.Table.UpdateTable

idw_detail = tab_1.tabpage_1.dw_detail
idw_detail.SetTransObject( SQLCA)
end event

event closequery;// Ancester Override

CHOOSE CASE is_salir
	CASE 'S'
		CLOSE (THIS)
	
	CASE ELSE
		THIS.Event ue_close_pre()
		THIS.EVENT ue_update_request()
		
		IF ib_update_check = False THEN
			ib_update_check = TRUE
			RETURN 1
		END IF
		
		Destroy	im_1
		
		of_close_sheet()
		
END CHOOSE
end event

type ole_skin from w_abc`ole_skin within w_fi329_pagar_directo
end type

type cbx_3 from checkbox within w_fi329_pagar_directo
integer x = 2619
integer y = 336
integer width = 512
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Venta"
end type

type cb_2 from commandbutton within w_fi329_pagar_directo
integer x = 2587
integer y = 436
integer width = 343
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Asociar a OT"
end type

event clicked;Long  ll_row_master 

str_parametros sl_param


ll_row_master = dw_master.Getrow()

IF ll_row_master = 0  THEN RETURN

IF dw_master.ii_update = 1  OR tab_1.tabpage_1.dw_detail.ii_update = 1  & 
   OR tab_1.tabpage_2.dw_referencia.ii_update = 1   THEN
	Messagebox('Aviso','Tiene Actualizaciones Pendientes , Verifique!')
	Return
END IF

//datos del documento/
sl_param.string1     = dw_master.object.cod_relacion  [ll_row_master]
sl_param.string2		 = dw_master.object.tipo_doc     [ll_row_master]
sl_param.string3		 = dw_master.object.nro_doc      [ll_row_master]

OpenWithParm(w_abc_relacionar_ot, sl_param)

end event

type cbx_2 from checkbox within w_fi329_pagar_directo
integer x = 2619
integer y = 268
integer width = 512
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Servicio"
end type

type cbx_1 from checkbox within w_fi329_pagar_directo
integer x = 2619
integer y = 196
integer width = 503
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Orden de Compra"
end type

type tab_1 from tab within w_fi329_pagar_directo
integer y = 796
integer width = 3538
integer height = 624
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

type tabpage_1 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3502
integer height = 504
long backcolor = 79741120
string text = "Detalle"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
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
integer width = 3470
integer height = 464
integer taborder = 30
string dataobject = "d_abc_comprobante_egreso_det_tbl"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1	// columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_rk[1] = 1 	// columnas que recibimos del master
ii_rk[2] = 2
ii_rk[3] = 3


idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event doubleclicked;call super::doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot ,ls_flag_cebef
Str_seleccionar lstr_seleccionar
Datawindow		 ldw	
dwobject   dwo_1

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then    //protegido 
	return
end if


CHOOSE CASE dwo.name
 		 CASE	'cencos'
			    lstr_seleccionar.s_seleccion = 'S'
			    lstr_seleccionar.s_sql = 'SELECT CENTROS_COSTO.CENCOS   AS CENT_COSTO ,'&
				     	      				 +'CENTROS_COSTO.DESC_CENCOS  AS DESCRIPCION_CENT_COSTO '&
			   		      				 +'FROM CENTROS_COSTO ' &
							   				 +'WHERE FLAG_ESTADO IN '+'(1)'
			    OpenWithParm(w_seleccionar,lstr_seleccionar)
				 
			    IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			 IF lstr_seleccionar.s_action = "aceptar" THEN
		   		 Setitem(row,'cencos',lstr_seleccionar.param1[1])
					 //de acuerdo a parametros 
					 //ejecuta itemchanged
					 dwo_1 = this.object.cencos
		
					 this.Event itemchanged(row,dwo_1,lstr_seleccionar.param1[1])
					 
			    	 ii_update = 1
			    END IF

		 CASE 'cnta_prsp'
				lstr_seleccionar.s_seleccion = 'S'
				lstr_seleccionar.s_sql = 'SELECT PRESUPUESTO_CUENTA.CNTA_PRSP AS CUENTA_PRESUP ,'&
												+'PRESUPUESTO_CUENTA.DESCRIPCION		  AS DESCRIPCION	 '&
												+'FROM PRESUPUESTO_CUENTA '
												
		      OpenWithParm(w_seleccionar,lstr_seleccionar)
			   IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			IF lstr_seleccionar.s_action = "aceptar" THEN
		   		Setitem(row,'cnta_prsp',lstr_seleccionar.param1[1])
					//de acuerdo a parametros 
					 //ejecuta itemchanged
					 dwo_1 = this.object.cnta_prsp
		
					 this.Event itemchanged(row,dwo_1,lstr_seleccionar.param1[1])
			    	ii_update = 1
			   END IF
				
		CASE 'centro_benef'
			  ls_flag_cebef = This.object.flag_cebef   [row]
		
				IF ls_flag_cebef = '1' THEN
				   lstr_seleccionar.s_seleccion = 'S'
			  		lstr_seleccionar.s_sql =	 'SELECT C.CENTRO_BENEF AS CODIGO, '&
			  										       +'B.DESC_CENTRO AS DESCRIPCION '&       
									  					    +'  FROM CENTRO_BENEF_USUARIO C,CENTRO_BENEFICIO B '&
															 +'WHERE C.CENTRO_BENEF = B.CENTRO_BENEF AND '&
															 +'C.COD_USR = '+"'"+gnvo_app.is_user+"'"

				  
			     OpenWithParm(w_seleccionar,lstr_seleccionar)
				  IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
    			  IF lstr_seleccionar.s_action = "aceptar" THEN
			   	  Setitem(row,'centro_benef',lstr_seleccionar.param1[1])
				     ii_update = 1
				  END IF
				END IF			       

		
END CHOOSE


end event

event itemchanged;call super::itemchanged;Long   	ll_count,ll_ano,ll_mes
String 	ls_codigo,ls_cencos,ls_cnta_prsp,ls_null,ls_origen
Decimal	ldec_monto_mov


SetNull(ls_null)

Accepttext()

CHOOSE CASE dwo.name
	 	 CASE 'fec_movilidad'
				
				IF TRIM(dw_master.object.tipo_doc[1]) = TRIM(is_doc_cml) THEN
					
					ldec_monto_mov = of_monto_mov(DATE(this.object.fec_movilidad[row]))
					
					IF ldec_monto_mov > idec_monto_max_mov THEN
						messagebox('Aviso', 'El limite por movilidad ha sido excedido')
						This.object.importe [row] = 0
						RETURN 1
					END IF
				END IF
				
		 CASE	'importe'
				IF TRIM(dw_master.object.tipo_doc[1]) = TRIM(is_doc_cml) THEN
					
					ldec_monto_mov = of_monto_mov(DATE(this.object.fec_movilidad[row]))
					
					IF ldec_monto_mov > idec_monto_max_mov THEN
						messagebox('Aviso', 'El limite por movilidad ha sido excedido')
						This.object.importe [row] = 0
						RETURN 1
					END IF
				END IF
				
				dw_master.object.importe_doc [1] = wf_total ()
				dw_master.ii_update = 1
				
		 CASE 'cencos'			
				ls_origen	 = dw_master.object.origen [1]
				ll_ano		 = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
				ls_cencos	 = this.object.cencos    [row]
				ls_cnta_prsp = this.object.cnta_prsp [row]
								
				SELECT Count(*)
				  INTO :ll_count
				  FROM centros_costo
			    WHERE (flag_estado = '1'   ) AND
				 		 (cencos		  = :data ) ;
						  
				IF ll_count = 0 THEN
					Messagebox('Aviso','Centro de Costo '+data+' No Existe , Verifique!')
					Setnull(ls_codigo)
					This.Object.cencos [row] = ls_codigo
					Return 1 
				END IF		
				
				if is_flag_valida_cbe = '1' then //valida centro de beneficio
					//de acuerdo a parametros 
					ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

					if ll_count > 0 then
						This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
						This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
					else
						This.object.flag_cebef [row] = '1'     //editable		
					end if
				
					this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	
				end if
				
				
		 CASE 'cnta_prsp'
			
				ls_origen	 = dw_master.object.origen [1]
				ll_ano		 = Long(String(dw_master.object.fecha_emision [1],'yyyy'))
				ls_cencos	 = this.object.cencos    [row]
				ls_cnta_prsp = this.object.cnta_prsp [row]
				
			
				SELECT Count(*)
				  INTO :ll_count
				  FROM presupuesto_cuenta
				 WHERE (cnta_prsp = :data) ;
				 
				IF ll_count = 0 THEN
					Messagebox('Aviso','Cuenta Preuspuestal No Existe , Verifique!')
					Setnull(ls_codigo)
					This.Object.cnta_prsp [row] = ls_codigo
					Return 1
				END IF				
				
				if is_flag_valida_cbe = '1' then //valida centro de beneficio
					//de acuerdo a parametros 
					ll_count = of_verif_partida(ll_ano,ls_cencos,ls_cnta_prsp)

					if ll_count > 0 then
						This.object.flag_cebef   [row] = ls_null	//no editable tipo fondo
						This.object.centro_benef [row] = of_cbenef_origen(ls_origen)
					else
						This.object.flag_cebef [row] = '1'     //editable		
					end if
				
					this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")	
				end if
				
				
		 CASE 'centro_benef'
				select Count(*) into :ll_count from centro_benef_usuario 
				 Where cod_usr      = :gnvo_app.is_user and
				 		 centro_benef = :data	;
				 
				IF ll_count = 0  THEN
					Messagebox('Aviso','Centro de Beneficio No esta Asignado al Usuario Verifique')
					Setnull(ls_codigo)
					This.Object.centro_benef [row] = ls_codigo
					Return 1
				END IF
				
END CHOOSE
end event

event itemerror;call super::itemerror;Return 1
end event

event keydwn;call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event rowfocuschanged;call super::rowfocuschanged;This.SelectRow(0, False)
This.SelectRow(currentrow, True)	
end event

event ue_insert_pre;call super::ue_insert_pre;This.Object.item      [al_row] = al_row
This.Object.cantidad  [al_row] = 1

this.Modify("centro_benef.Protect='1~tIf(IsNull(flag_cebef),1,0)'")

dw_master.object.cod_moneda.Protect = 1


end event

type tabpage_2 from userobject within tab_1
integer x = 18
integer y = 104
integer width = 3502
integer height = 504
long backcolor = 79741120
string text = "Referencias"
long tabtextcolor = 8388608
long tabbackcolor = 79741120
long picturemaskcolor = 536870912
dw_referencia dw_referencia
end type

on tabpage_2.create
this.dw_referencia=create dw_referencia
this.Control[]={this.dw_referencia}
end on

on tabpage_2.destroy
destroy(this.dw_referencia)
end on

type dw_referencia from u_dw_abc within tabpage_2
integer x = 14
integer y = 16
integer width = 1627
integer height = 464
integer taborder = 20
string dataobject = "d_abc_referencias_x_cobrar_directo_tbl"
boolean vscrollbar = true
end type

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event itemchanged;call super::itemchanged;Accepttext()
end event

event itemerror;call super::itemerror;RETURN 1
end event

event constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)


ii_ck[1] = 1		// columnas de lectrua de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_ck[4] = 4
ii_ck[5] = 5
ii_ck[6] = 6
ii_ck[7] = 7


idw_mst = tab_1.tabpage_2.dw_referencia
//idw_det  =  				// dw_detail
end event

type cb_1 from commandbutton within w_fi329_pagar_directo
integer x = 2606
integer y = 80
integer width = 347
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Referencias"
end type

event clicked;
Long    ll_row_master
String  ls_cod_relacion,ls_flag_estado,ls_tipo_doc,ls_flag_llave_num
str_parametros sl_param

ll_row_master = dw_master.Getrow()

dw_master.Accepttext()

IF ll_row_master = 0 THEN Return

IF cbx_1.checked = FALSE AND cbx_2.checked = FALSE AND cbx_3.checked = FALSE THEN
	Messagebox('Aviso','Debe Seleccionar Algun tipo de Referencia ,Verifique!')
	RETURN
END IF

ls_cod_relacion = dw_master.object.cod_relacion [ll_row_master]
ls_flag_estado  = dw_master.object.flag_estado  [ll_row_master]
ls_tipo_doc		 = dw_master.object.tipo_doc	   [ll_row_master]




IF tab_1.tabpage_2.dw_referencia.Rowcount() > 1 THEN
	Messagebox('Aviso','Ya Existe Referencia..Verifique!')
END IF

IF Isnull(ls_cod_relacion) OR Trim(ls_cod_relacion) = '' THEN
	Messagebox('Aviso','Debe Ingresar Codigo de Relacion ,Verifique!')
	Return
END IF

IF Isnull(ls_tipo_doc) OR Trim(ls_tipo_doc) = '' THEN
	Messagebox('Aviso','Debe Ingresar Tipo de Documento ,Verifique!')
	Return
END IF



IF ls_flag_estado = '0' THEN
	Messagebox('Aviso','Documento se encuentra Anulado ,Verifique!')
	Return
END IF

select flag_llave_num into :ls_flag_llave_num from doc_tipo where (tipo_doc = :ls_tipo_doc ) ;

IF ls_flag_llave_num = '0' THEN
	Messagebox('Aviso','Documento no pide Referencia ,Verifique!')
	Return
END IF


sl_param.string1 = ls_cod_relacion

IF cbx_1.checked THEN //ORDEN DE COMPRA
	sl_param.dw1		= 'd_abc_lista_oc_pendientes_directas_tbl'
	sl_param.titulo	= 'Ordenes de Compras Pendientes x Proveedor '
	sl_param.tipo 		= '1OC'
	sl_param.opcion   = 20  //ORDENES DE COMPRA
ELSEIF cbx_2.checked THEN
	sl_param.dw1		= 'd_abc_lista_os_pendientes_directas_tbl'
	sl_param.titulo	= 'Ordenes de Servicio Pendientes x Proveedor '
	sl_param.tipo 		= '1OS'
	sl_param.opcion   = 21  //ORDENES DE SERVICIO
ELSEIF cbx_3.checked THEN
	sl_param.dw1		= 'd_abc_lista_ov_directas_tbl'
	sl_param.titulo	= 'Ordenes de Ventas x Agente de Aduana'
	sl_param.tipo 		= '1OV'
	sl_param.opcion   = 26  //ORDENES DE VENTA
	
END IF

sl_param.db1 		= 1350
sl_param.dw_m		= tab_1.tabpage_2.dw_referencia


OpenWithParm( w_abc_seleccion_lista, sl_param)

IF isvalid(message.PowerObjectParm) THEN sl_param = message.PowerObjectParm			
IF sl_param.bret  THEN
	tab_1.tabpage_2.dw_referencia.ii_update = 1
END IF

end event

type rb_gen from radiobutton within w_fi329_pagar_directo
integer x = 2610
integer y = 592
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato GENERAL"
boolean checked = true
end type

type rb_esp from radiobutton within w_fi329_pagar_directo
integer x = 2610
integer y = 664
integer width = 530
integer height = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Formato Especial"
end type

type dw_master from u_dw_abc within w_fi329_pagar_directo
integer width = 2514
integer height = 780
string dataobject = "d_abc_comprobante_egreso_cab_tbl"
boolean border = false
borderstyle borderstyle = stylebox!
end type

event itemchanged;call super::itemchanged;String      ls_nom_proveedor, ls_forma_pago, ls_codigo, ls_flag, &
				ls_flag_afecta_prsp, ls_null
Date        ld_fecha_emision, ld_fecha_vencimiento,ld_fecha_emision_old
Decimal {3} ldc_tasa_cambio
Integer		li_dias_venc , li_opcion
Long        ll_count,ll_inicio


ld_fecha_emision_old = Date(This.Object.fecha_emision [row])			
Accepttext()
SetNull(ls_null)

tab_1.tabpage_1.dw_detail.ii_update = 1

CHOOSE CASE dwo.name
	CASE 'tipo_doc'
		select Count(*) 
		  into :ll_count
		  from doc_grupo 				dg, 
		  		 doc_grupo_relacion 	dgr, 
				 finparam 				fp ,
				 doc_tipo 				dt
		 where (dg.grupo     = dgr.grupo             ) and
				 (dg.grupo     = fp.doc_grp_pag_directo) and
				 (dgr.tipo_doc	= dt.tipo_doc			   ) and
				 (dt.factor		= -1							) and
				 (dgr.tipo_doc = :data     				) ;
				 
		if ll_count = 0 then
			SetNull(ls_flag)
			This.object.tipo_doc [row] = ls_flag
			Messagebox('Aviso','Documento No Existe en Grupo de Documento x Pagar , Verifique!')
			Return 1
		end if

		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.tipo_doc[row] = ls_null
			this.setcolumn( "tipo_doc" )
			This.setFocus( )
			return 1
		end if
		
		ls_flag = f_tdoc_fnum(data)
		
		IF ls_flag = '1' THEN
			dw_master.object.nro_doc.Protect      = 1	
			dw_master.object.nro_doc.Background.Color = rgb(255,255,220)
		ELSE
			dw_master.object.nro_doc.Protect      = 0		
			dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
		END IF
		
		//setear a nulo nro de doc
		setnull(ls_flag)
		This.Object.nro_doc [row] = ls_flag
		
		//busco flag de afectacion presupuestal
		select flag_afecta_prsp 
		  into :ls_flag_afecta_prsp 
		  from doc_tipo 
		 where (tipo_doc = :data) ;
		
		this.object.flag_afecta_prsp [row] = ls_flag_afecta_prsp
		

		// Cambiar DW si tipo_doc = comprobante movilidad
		of_cambiar_dw (TRIM(this.object.tipo_doc [row]))
		
	
	CASE 'cod_relacion'
		SELECT pr.nom_proveedor
		  INTO :ls_nom_proveedor
		  FROM proveedor pr
		 WHERE (pr.proveedor   = :data ) and
				 (pr.flag_estado = '1'   ) ; 
				 
		
		IF Isnull(ls_nom_proveedor) OR Trim(ls_nom_proveedor) = '' THEN
			Messagebox('Aviso','Proveedor No Existe o no está activo, Verifique!')
			setnull(ls_flag)
			This.Object.cod_relacion [row] = ls_flag
			Return 1
		end if
		
		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.cod_relacion[row] = ls_null
			this.setcolumn( "cod_relacion" )
			This.setFocus( )
			return 1
		end if

		This.Object.nom_proveedor [row] = ls_nom_proveedor

	CASE 'nro_doc'
		// Verifico si ya existe el documento
		if of_verifica_documento( ) = false then
			this.object.nro_doc[row] = ls_null
			this.setcolumn( "nro_doc" )
			This.setFocus( )
			return 1
		end if


		
	CASE	'fecha_emision'
		ld_fecha_emision      = Date(This.Object.fecha_emision [row])			
		this.object.fecha_presentacion [row] = Date(This.Object.fecha_emision [row])			
		ld_fecha_vencimiento	 = Date(This.Object.vencimiento   [row])			
		ls_forma_pago			 = This.Object.forma_pago [row]	
		
		IF ld_fecha_emision > ld_fecha_vencimiento THEN
			This.Object.fecha_emision [row] = ld_fecha_emision_old
			Messagebox('Aviso','Fecha de Emisión del Documento No '&
									+'Puede Ser Mayor a la Fecha de Vencimiento')
			Return 1
		END IF
	
	
		This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)
		
		IF Not (Isnull(ls_forma_pago) OR Trim(ls_forma_pago) = '') THEN
			
			li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
			IF li_dias_venc > 0 THEN
				li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
				
				IF li_opcion = 1 THEN
					ld_fecha_emision = Date(This.object.fecha_emision[row])
					ld_fecha_vencimiento = Relativedate(ld_fecha_emision,li_dias_venc)
					This.Object.vencimiento [row] = ld_fecha_vencimiento
				END IF
			END IF	
		END IF
	
	CASE 'vencimiento'	
		ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
		ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
		
		IF ld_fecha_vencimiento < ld_fecha_emision THEN
			This.Object.fecha_vencimiento [row] = ld_fecha_emision
			Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
									+'Puede Ser Menor a la Fecha de Emisión')
			Return 1
		END IF
	
	CASE	'forma_pago'
		li_dias_venc = idw_forma_pago.Getitemnumber(idw_forma_pago.getrow(),'dias_vencimiento')
		
		IF li_dias_venc > 0 THEN
			
			li_opcion = MessageBox('Aviso','Desea Generar Fecha de Vencimiento Dependiendo de la Forma de Pago', question!, YesNo!, 2)
			IF li_opcion = 1 THEN
				ld_fecha_vencimiento = Relativedate(Date(This.object.fecha_emision[row]),li_dias_venc)
				This.Object.vencimiento [row] = ld_fecha_vencimiento
			END IF
		ELSE
			This.Object.vencimiento [row] = This.object.fecha_emision[row]
		END IF
				
END CHOOSE

				
end event

event itemerror;call super::itemerror;Return 1
end event

event clicked;call super::clicked;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event constructor;call super::constructor;is_mastdet = 'md'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                  // 'md' = master con detalle, 'dd' = detalle con detalle a la vez


ii_ck[1] = 1 // columnas de lectura de este dw
ii_ck[2] = 2
ii_ck[3] = 3
ii_dk[1] = 1 // columnas que se pasan al detalle
ii_dk[2] = 2 
ii_dk[3] = 3

idw_mst = dw_master
idw_det = tab_1.tabpage_1.dw_detail
end event

event ue_insert_pre;call super::ue_insert_pre;String ls_comp_egr

SELECT comprobante_egr INTO :ls_comp_egr FROM finparam WHERE reckey = '1' ;


IF Isnull(ls_comp_egr) OR Trim(ls_comp_egr) = '' THEN 
	Messagebox('Aviso','Debe Ingresar Tipo Comprobante De Egreso en Finparam ')
END IF	


This.object.flag_estado       [al_row] = '1'
This.object.flag_provisionado [al_row] = 'D'
This.object.cod_usr           [al_row] = gnvo_app.is_user
This.object.origen            [al_row] = gnvo_app.is_origen
This.object.fecha_registro    [al_row] = DateTime(gnvo_app.id_fecha, now())
This.object.fecha_emision     [al_row] = DateTime(gnvo_app.id_fecha, now())
this.object.fecha_presentacion[al_row] = DateTime(gnvo_app.id_fecha, now())
This.object.tasa_cambio       [al_row] = f_tasa_cambio()
This.object.flag_control_reg  [al_row] = '0'
This.object.flag_caja_bancos  [al_row] = '0'

//BLOQUEAR NRO DE DOCUMENTO...SE HABILITARA DE ACUERDO A DOCUMENTO
dw_master.object.nro_doc.Protect = 1
dw_master.object.nro_doc.Background.Color = rgb(155,155,155)
end event

event doubleclicked;IF Getrow() = 0 THEN Return
String      ls_name ,ls_prot ,ls_flag,ls_flag_afecta_prsp, ls_null
Date		   ld_fecha_emision ,ld_fecha_vencimiento	
Decimal {3} ldc_tasa_cambio

Str_seleccionar lstr_seleccionar
Datawindow		 ldw	

ls_name = dwo.name
ls_prot = this.Describe( ls_name + ".Protect")

if ls_prot = '1' then return   //protegido 
SetNull(ls_null)

CHOOSE CASE dwo.name
		
	CASE 'tipo_doc'
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT VW_FIN_DOC_X_GRUPO_PAGAR.TIPO_DOC AS CODIGO_DOC,'&
												+'VW_FIN_DOC_X_GRUPO_PAGAR.DESC_TIPO_DOC AS DESCRIPCION '&
												+'FROM VW_FIN_DOC_X_GRUPO_PAGAR '  
												
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.tipo_doc[row] = lstr_seleccionar.param1[1]

			// Verifico si ya existe el documento
			if of_verifica_documento( ) = false then
				this.object.tipo_doc[row] = ls_null
				this.setcolumn( "tipo_doc" )
				This.setFocus( )
				return 1
			end if			
			
			//NUMERADORES
			ls_flag = f_tdoc_fnum(lstr_seleccionar.param1[1])
		
			IF ls_flag = '1' THEN
				dw_master.object.nro_doc.Protect      = 1	
				dw_master.object.nro_doc.Background.Color = rgb(255,255,220)
			ELSE
				dw_master.object.nro_doc.Protect      = 0		
				dw_master.object.nro_doc.Background.Color = rgb(255,255,255)
			END IF
		
			//setear a nulo nro de doc
			setnull(ls_flag)
			This.Object.nro_doc [row] = ls_flag					
			
			//busco flag de afectacion presupuestal
			select flag_afecta_prsp 
			  into :ls_flag_afecta_prsp 
			  from doc_tipo 
			  where (tipo_doc = :lstr_seleccionar.param1[1]) ;
		
			this.object.flag_afecta_prsp [row] = ls_flag_afecta_prsp
			
			// Cambiar DW si tipo_doc = comprobante movilidad
			of_cambiar_dw (TRIM(this.object.tipo_doc [row]))
			
			//
			ii_update = 1
		
		END IF	
	
	CASE 'cod_relacion'
	
		lstr_seleccionar.s_seleccion = 'S'
		lstr_seleccionar.s_sql = 'SELECT PROVEEDOR.PROVEEDOR AS CODIGO , '&
												 +'PROVEEDOR.NOM_PROVEEDOR AS DESCRIPCION,'&
												 +'RUC AS NRO_RUC '				   &
												 +'FROM PROVEEDOR '&
												 +'WHERE PROVEEDOR.FLAG_ESTADO = '+"'"+'1'+"'"
		
		
		OpenWithParm(w_seleccionar,lstr_seleccionar)
		
		IF isvalid(message.PowerObjectParm) THEN lstr_seleccionar = message.PowerObjectParm
		IF lstr_seleccionar.s_action = "aceptar" THEN
			this.object.cod_relacion[row] = lstr_seleccionar.param1[1]
			this.object.nom_proveedor[row] = lstr_seleccionar.param2[1]

			// Verifico si ya existe el documento
			if of_verifica_documento( ) = false then
				this.object.tipo_doc[row] = ls_null
				this.setcolumn( "tipo_doc" )
				This.setFocus( )
				return 1
			end if				
			ii_update = 1
		END IF
	
	CASE	'fecha_emision'
		ld_fecha_emision = Date(This.Object.fecha_emision [row])				
		
		ldw = This
		
		f_call_calendar(ldw,dwo.name,dwo.coltype, row)
		
		IF ld_fecha_emision <> Date(This.Object.fecha_emision [row]) THEN
		
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])				
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
			
			dw_master.object.fecha_presentacion [row] = ld_fecha_emision
			
			
			IF ld_fecha_emision > ld_fecha_vencimiento THEN
				This.Object.fecha_emision [row] = ld_fecha_vencimiento
				
				Messagebox('Aviso','Fecha de Emisión del Documento No '&
										+'Puede Ser Mayor a la Fecha de Vencimiento')
			END IF
			
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])									
			This.Object.tasa_cambio [row] = f_tasa_cambio_x_arg(ld_fecha_emision)	
			
			This.ii_update = 1
		END IF			
	
	CASE 'vencimiento'	
		ld_fecha_vencimiento = Date(This.Object.vencimiento [row])				
		
		ldw = This
		
		f_call_calendar(ldw,dwo.name,dwo.coltype, row)
		
		IF ld_fecha_vencimiento <> Date(This.Object.vencimiento [row])	THEN
			ld_fecha_emision     = Date(This.Object.fecha_emision [row])			
			ld_fecha_vencimiento	= Date(This.Object.vencimiento   [row])			
		
			IF ld_fecha_vencimiento < ld_fecha_emision THEN
				This.Object.vencimiento [row] = ld_fecha_emision
				
				Messagebox('Aviso','Fecha de Vencimiento del Documento No '&
										+'Puede Ser Menor a la Fecha de Emisión')
										
			END IF					
			This.ii_update = 1
		END IF		
			
END CHOOSE


end event

event type long keydwn(keycode key, unsignedlong keyflags);call super::keydwn;IF Key = keyF4! THEN
	Parent.TriggerEvent('ue_find_exact')
END IF

Return 0
end event

event buttonclicked;call super::buttonclicked;string ls_data1, ls_data2, ls_null
SetNull(ls_null)
this.AcceptText()
choose case lower(dwo.name)
	case "b_1"
		if is_accion = 'new' then
			if of_verifica_documento () = false then
				Return
			end if
		end if
end choose
end event

type gb_1 from groupbox within w_fi329_pagar_directo
integer x = 2583
integer y = 544
integer width = 649
integer height = 212
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Impresión"
end type

type gb_2 from groupbox within w_fi329_pagar_directo
integer x = 2583
integer y = 16
integer width = 649
integer height = 404
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Referencia"
end type

