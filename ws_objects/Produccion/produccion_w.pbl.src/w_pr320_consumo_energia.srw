$PBExportHeader$w_pr320_consumo_energia.srw
forward
global type w_pr320_consumo_energia from w_abc_master
end type
type st_nro from statictext within w_pr320_consumo_energia
end type
type sle_nro from singlelineedit within w_pr320_consumo_energia
end type
type cb_1 from commandbutton within w_pr320_consumo_energia
end type
type dw_detail from u_dw_abc within w_pr320_consumo_energia
end type
end forward

global type w_pr320_consumo_energia from w_abc_master
integer width = 4562
integer height = 1976
string title = "Consumo de Energía(PR320)"
string menuname = "m_mantto_consulta"
event ue_desviacion ( )
st_nro st_nro
sle_nro sle_nro
cb_1 cb_1
dw_detail dw_detail
end type
global w_pr320_consumo_energia w_pr320_consumo_energia

type variables
u_dw_abc		idw_detail

// Para el registro del Log
string 	is_tabla_d, is_colname_d[], is_coltype_d[], is_nro_parte

Integer	ii_ss

//Parametros de Energía

dec ll_potencia_contratada, ldc_tarifa_KWhr, lidc_sumas = 0


end variables

forward prototypes
public subroutine of_retrieve (string as_nro_parte)
public subroutine of_asigna_dws ()
public function integer of_set_numera ()
public function integer of_nro_item (datawindow adw_pr)
public function decimal of_mdg_hpfp_m47 ()
public function decimal of_factor_cliente ()
public function decimal of_factor_cliente_m ()
public function decimal of_ldc_valor_r48 ()
public function decimal of_calcula_ajuste_diario (decimal aldc_acometida_h, date ald_fecha_consumo, decimal aldc_distribucion_d)
end prototypes

event ue_desviacion();//Para Calcular El Porcentaje de la Desviacion De Energia Reactiva y demas Sumatorias..

Dec		ldc_resultado_resta, ldc_valor1, ldc_valor2, ldc_resultado_resta_2, &
			ldc_resultado_resta_1, ldc_valor1_1, ldc_valor2_1, ldc_result, &
			ldc_suma_1 = 0, ldc_suma_2 = 0, ldc_suma_3 = 0, ldc_suma_4 = 0, ldc_resultado_resta_3, &
			ldc_valor1_2, ldc_valor2_2, ldc_valor1_3, ldc_valor2_3, &
			ldc_prom_max_6

date 		ld_fecha_1, ld_fecha_2
	
integer	ll_2 = 2, ll_i, li_mes, li_year

String   ls_cod_origen, ls_cod_planta

		ls_cod_origen  = dw_master.object.cod_origen [dw_master.GetRow()]
		ls_cod_planta 	= dw_master.object.cod_planta[dw_master.GetRow()]
		li_mes     = dw_master.object.mes[dw_master.GetRow()]
		li_year    = dw_master.object.ano[dw_master.GetRow()]

		  FOR ll_i = 1 to dw_detail.rowcount() - 1
				
				ld_fecha_1 = date(dw_detail.object.fecha_consumo [ll_i])
				ld_fecha_2 = date(dw_detail.object.fecha_consumo [ll_2])
				
				ldc_valor1 					= dw_detail.object.lect_ener_activa [ll_i]
				ldc_valor2 					= dw_detail.object.lect_ener_activa [ll_2]
				
				ldc_resultado_resta 		= ldc_valor2 - ldc_valor1
				
				ldc_suma_1 					= ldc_resultado_resta + ldc_suma_1
					
				//Suma de La Lectura de Energia Activa en HP
				ldc_valor1_2 					= dw_detail.object.lect_ener_hp [ll_i]
				ldc_valor2_2 					= dw_detail.object.lect_ener_hp [ll_2]
				ldc_resultado_resta_2 		= ldc_valor2_2 - ldc_valor1_2
				ldc_suma_3 						= ldc_resultado_resta_2 + ldc_suma_3
				
				//Suma de La Lectura de Energia Activa en FHP
				ldc_valor1_3 					= dw_detail.object.lect_ener_fhp [ll_i]
				ldc_valor2_3 					= dw_detail.object.lect_ener_fhp [ll_2]
				ldc_resultado_resta_3 		= ldc_valor2_3 - ldc_valor1_3
				ldc_suma_4 						= ldc_resultado_resta_3 + ldc_suma_4
			
		   		IF ldc_resultado_resta 	= 0 THEN
					dw_detail.object.desviacion[ll_2] = ldc_resultado_resta
			
					ELSE
			
					ldc_valor1_1 				= dw_detail.object.lect_ener_react [ll_i]
					ldc_valor2_1 				= dw_detail.object.lect_ener_react [ll_2]
					ldc_resultado_resta_1 	= ldc_valor2_1 - ldc_valor1_1
					ldc_result = round(((ldc_resultado_resta_1 / ldc_resultado_resta)*100),2)
					
					ldc_suma_2 = ldc_resultado_resta_1 + ldc_suma_2
					dw_detail.object.desviacion[ll_2] = ldc_result

					END IF
							
					ll_2 = ll_2 + 1
		NEXT
		
		IF ldc_suma_1 = 0 THEN
			
			dw_detail.object.t_desviacion.text	 = '0'
			
		ELSE
			
			dw_detail.object.t_desviacion.text = string(round(dec(ldc_suma_2 / ldc_suma_1)*100,2))+' %'
	
		END IF
		
		ldc_prom_max_6 = f_prom_ultimos_meses(li_year, li_mes, ls_cod_origen, ls_cod_planta)
		
			
		dw_detail.object.t_suma1.text = string(round(dec(ldc_suma_1),2))
		dw_detail.object.t_suma4.text = string(round(dec(ldc_suma_2),2))
		dw_detail.object.t_suma2.text = string(round(dec(ldc_suma_3),2))
		dw_detail.object.t_suma3.text = string(round(dec(ldc_suma_4),2))
		dw_detail.object.t_promedio.text = string(round(dec(ldc_prom_max_6),3))
		

end event

public subroutine of_retrieve (string as_nro_parte);dw_master.Retrieve(as_nro_parte)
//idw_1.object.p_logo.filename 			= gs_logo

long li_control = 1, li_lectura = 1

idw_detail.retrieve(as_nro_parte)

this.event ue_desviacion()

idw_1.ii_protect = 0
idw_detail.ii_protect = 0



idw_1.of_protect( )
idw_detail.of_protect( )


idw_1.ii_update = 0
idw_detail.ii_update = 0


is_Action = 'open'

end subroutine

public subroutine of_asigna_dws ();idw_detail		 	 = dw_detail

end subroutine

public function integer of_set_numera ();// Numera documento
Long 		ll_count, ll_ult_nro, ll_i
String  	ls_next_nro, ls_lock_table, ls_mensaje

IF dw_master.getrow() = 0 THEN RETURN 0

IF is_action = 'new' THEN
	SELECT count(*)
		INTO :ll_count
	FROM NUM_PROD_CONSUMO
	WHERE cod_origen = :gs_origen;
	
	IF ll_count = 0 THEN
		ls_lock_table = 'LOCK TABLE NUM_PROD_CONSUMO IN EXCLUSIVE MODE'
		EXECUTE IMMEDIATE :ls_lock_table ;
		
		IF SQLCA.SQLCode < 0 THEN
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Aviso', ls_mensaje)
			RETURN 0
		END IF
		
		INSERT INTO NUM_PROD_CONSUMO(cod_origen, ult_nro)
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
	FROM NUM_PROD_CONSUMO
	WHERE cod_origen = :gs_origen FOR UPDATE;
	
	UPDATE NUM_PROD_CONSUMO
		SET ult_nro = ult_nro + 1
	WHERE cod_origen = :gs_origen;
	
	IF SQLCA.SQLCode < 0 THEN
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Aviso', ls_mensaje)
		RETURN 0
	END IF
	
	ls_next_nro = trim(gs_origen) + string(ll_ult_nro, '00000000')
	
	dw_master.object.nro_consumo[dw_master.getrow()] = ls_next_nro
	dw_master.ii_update = 1
	ELSE
	ls_next_nro = dw_master.object.nro_consumo[dw_master.getrow()] 
	END IF

// Asigna numero a detalle dw_detail (detalle de la instruccion)
FOR ll_i = 1 TO idw_detail.RowCount()
	idw_detail.object.nro_consumo[ll_i] = ls_next_nro
NEXT

RETURN 1
end function

public function integer of_nro_item (datawindow adw_pr);integer li_item, li_x

li_item = 0

For li_x 		= 1 to adw_pr.RowCount()
	IF li_item 	< adw_pr.object.nro_item[li_x] THEN
		li_item 	= adw_pr.object.nro_item[li_x]
	END IF
Next

Return li_item + 1
end function

public function decimal of_mdg_hpfp_m47 ();Dec 		max_lect_hp, max_lect_fhp, ldc_factor_cliente, lcd_precio_para_pagar, &
			ldc_resultado1_m47, ldc_mdg_fhp
			
string	ls_nro_consumo

ldc_factor_cliente = dw_master.object.factor_cliente[dw_master.GetRow()]
ls_nro_consumo     = dw_master.object.nro_consumo[dw_master.GetRow()]	

SELECT MAX(m.lect_ener_mxhp) 
	  into :max_lect_hp
	  FROM prod_consumo_ener_det m
    where nro_consumo = :ls_nro_consumo;
	  
SELECT MAX(m.lect_ener_mxfhp) 
	  into :max_lect_fhp
	  FROM prod_consumo_ener_det m
	  where nro_consumo = :ls_nro_consumo;
	  
	  	
	if 	ldc_factor_cliente >= 0.5 then
		
			lcd_precio_para_pagar = dw_master.object.factor_hp [dw_master.GetRow()]
	else
		
			lcd_precio_para_pagar = dw_master.object.factor_fhp [dw_master.GetRow()]
	
	end if
	
	if 	max_lect_hp > max_lect_fhp then

			ldc_resultado1_m47	= max_lect_hp * ll_potencia_contratada
			ldc_mdg_fhp 			= (ldc_resultado1_m47 * lcd_precio_para_pagar)
	else
	
			ldc_resultado1_m47    = max_lect_fhp * ll_potencia_contratada
			ldc_mdg_fhp 			 = (ldc_resultado1_m47 * lcd_precio_para_pagar)

	end if
		
return ldc_mdg_fhp
end function

public function decimal of_factor_cliente ();//Para Calcular el Factor Cliente.....

Dec		ldc_resultado_resta, ldc_valor1, ldc_valor2, ldc_acometida, &
			ldc_calculo1_e47, ldc_calculo2_b48, ldc_factor_cliente, &
			max_lect_hp, max_lect_fhp, max_lect_hp_r, max_lect_fhp_r, &
			ldc_dividendo
			
integer	ll_2, ll_i, li_dias_habiles, li_total_horas_punta, li_mes, li_ano

string	ls_cod_planta, ls_nro_consumo
			
ls_cod_planta  = dw_master.object.cod_planta[dw_master.GetRow()]
ls_nro_consumo = dw_master.object.nro_consumo[dw_master.GetRow()]
li_mes     		= dw_master.object.mes[dw_master.GetRow()]
li_ano    		= dw_master.object.ano[dw_master.GetRow()]

    
	  lidc_sumas 				= 0
	  ldc_resultado_resta 	= 0
	  
	  ll_2 = 2
	
	  FOR ll_i = 1 to dw_detail.rowcount() - 1
			
			ldc_valor1 				= dw_detail.object.lect_ener_hp [ll_i]
			ldc_valor2 				= dw_detail.object.lect_ener_hp [ll_2]
			ldc_resultado_resta 	= ldc_valor2 - ldc_valor1
			lidc_sumas 				= ldc_resultado_resta + lidc_sumas
			
			ll_2 = ll_2 + 1

		next

		li_dias_habiles = dw_master.object.nro_dias_habiles[dw_master.GetRow()]

		Select total_horas_punta
		  into :li_total_horas_punta
		 from  costo_param;
		 
	 	if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido el Total de Horas Punta', StopSign!)
			return 1
		end if

		 
		 ldc_calculo1_e47 	= lidc_sumas * ll_potencia_contratada
		 ldc_calculo2_b48 	= li_dias_habiles * li_total_horas_punta
		 
		 
		 SELECT nvl(MAX(m.ener_max_hp),0) 
	  into :max_lect_hp_r
	  FROM prod_consumo_ener_det m
    where nro_consumo = :ls_nro_consumo;
	 
	 max_lect_hp = round(max_lect_hp_r,4)
	  
		SELECT nvl(MAX(m.ener_max_fhp),0) 
	  into :max_lect_fhp_r
	  FROM prod_consumo_ener_det m
	  where nro_consumo = :ls_nro_consumo;
	  
	  max_lect_fhp = round(max_lect_fhp_r,4)
		 
		IF max_lect_hp > max_lect_fhp THEN
			
			ldc_dividendo = max_lect_hp

		ELSE
			
			ldc_dividendo = max_lect_fhp
			
		END IF
		 
		 ldc_factor_cliente 	= round(((ldc_calculo1_e47)/(ldc_calculo2_b48))/ldc_dividendo,4)
			
		Return ldc_factor_cliente
		 

end function

public function decimal of_factor_cliente_m ();//Para Calcular el Factor Cliente.....

Dec		ldc_resultado_resta, ldc_valor1, ldc_valor2, ldc_acometida, &
			ldc_calculo1_e47, ldc_calculo2_b48, ldc_factor_cliente, &
			max_lect_hp, max_lect_fhp, max_lect_hp_r, max_lect_fhp_r, &
			ldc_dividendo
			
integer	ll_2, ll_i, li_dias_habiles, li_total_horas_punta, li_ano, li_mes

string	ls_cod_planta, ls_nro_consumo

ls_nro_consumo = dw_master.object.nro_consumo[dw_master.GetRow()]
ls_cod_planta = dw_master.object.cod_planta[dw_master.GetRow()]
li_mes     		= dw_master.object.mes[dw_master.GetRow()]
li_ano    		= dw_master.object.ano[dw_master.GetRow()]

	select 		p.potencia_contratada
		  into 	:ll_potencia_contratada
		  from 	prod_ener_param p
		 where	P.cod_planta 	= :ls_cod_planta
		   and   p.ano = :li_ano
			and   p.mes = :li_mes;
  
	  lidc_sumas 				= 0
	  ldc_resultado_resta 	= 0
	  
	  ll_2 = 2
	
	  FOR ll_i = 1 to dw_detail.rowcount() - 1
			
			ldc_valor1 				= dw_detail.object.lect_ener_hp [ll_i]
			ldc_valor2 				= dw_detail.object.lect_ener_hp [ll_2]
			ldc_resultado_resta 	= ldc_valor2 - ldc_valor1
			lidc_sumas 				= ldc_resultado_resta + lidc_sumas
			
			ll_2 = ll_2 + 1

		next

		li_dias_habiles = dw_master.object.nro_dias_habiles[dw_master.GetRow()]

		Select total_horas_punta
		  into :li_total_horas_punta
		 from  costo_param;
		 
	 	if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido el Total de Horas Punta', StopSign!)
			return 1
		end if
		
select 	p.acometida
		  into 	:ldc_acometida
		  from 	prod_ener_param p
		 where	P.cod_planta 	= :ls_cod_planta
		   and   p.ano = :li_ano
			and   p.mes = :li_mes;
		 
		 ldc_calculo1_e47 	= lidc_sumas * ll_potencia_contratada
		 ldc_calculo2_b48 	= li_dias_habiles * li_total_horas_punta
		 
			SELECT nvl(MAX(m.ener_max_hp),0) 
			  into :max_lect_hp_r
			  FROM prod_consumo_ener_det m
			 where nro_consumo = :ls_nro_consumo;
			 
			 max_lect_hp = round(max_lect_hp_r,4)
			 
			  
			SELECT nvl(MAX(m.ener_max_fhp),0) 
			  into :max_lect_fhp_r
			  FROM prod_consumo_ener_det m
			  where nro_consumo = :ls_nro_consumo;
			  
			  max_lect_fhp = round(max_lect_fhp_r,4)
				 
				IF max_lect_hp > max_lect_fhp THEN
					
					ldc_dividendo = max_lect_hp
		
				ELSE
					
					ldc_dividendo = max_lect_fhp
					
				END IF
	  
		 
		 ldc_factor_cliente 	= round(((ldc_calculo1_e47)/(ldc_calculo2_b48))/ldc_dividendo,4)

		Return ldc_factor_cliente
		 

end function

public function decimal of_ldc_valor_r48 ();Integer		ll_c47, ll_i, ll_22
Dec			ldc_valor1c47, ldc_valor2c47, ldc_resultado_resta_erc47, ldc_suma_ldc_valor3_r16c47, &
				ldc_valor3_c47, ldc_valor3_i47, ldc_valor2i47, ldc_resultado_resta_er, ldc_suma_ldc_valor3_r16, &
				ldc_valor1i47, ldc_valor_r48
				
ll_c47 = 2
		FOR ll_i = 1 to dw_detail.rowcount() - 1
			ldc_valor1c47 					= dw_detail.object.lect_ener_activa [ll_i]
			ldc_valor2c47					= dw_detail.object.lect_ener_activa [ll_c47]
			ldc_resultado_resta_erc47 	= ldc_valor2c47 - ldc_valor1c47
			ldc_suma_ldc_valor3_r16c47 = ldc_resultado_resta_erc47 + ldc_suma_ldc_valor3_r16c47
			ll_c47 = ll_c47 + 1
		next
		ldc_valor3_c47 = ldc_suma_ldc_valor3_r16c47 * ll_potencia_contratada

ll_22 = 2
	  FOR ll_i = 1 to dw_detail.rowcount() - 1
			ldc_valor1i47 					= dw_detail.object.lect_ener_react [ll_i]
			ldc_valor2i47 					= dw_detail.object.lect_ener_react [ll_22]
			ldc_resultado_resta_er 	   = ldc_valor2i47 - ldc_valor1i47
			ldc_suma_ldc_valor3_r16    = ldc_resultado_resta_er + ldc_suma_ldc_valor3_r16
			ll_22 = ll_22 + 1
		next
		
		ldc_valor3_i47 = ldc_suma_ldc_valor3_r16 * ll_potencia_contratada
		
		ldc_valor_r48	= round((ldc_valor3_i47 - (ldc_valor3_c47*0.3))*ldc_tarifa_KWhr, 4)
		
return ldc_valor_r48
end function

public function decimal of_calcula_ajuste_diario (decimal aldc_acometida_h, date ald_fecha_consumo, decimal aldc_distribucion_d);
Dec ldc_result, ldc_monto_aco_cong

	select nvl(p.costo_diario_ener,0)
	  into :ldc_monto_aco_cong
	  from prod_consumo_ener_det p, prod_consumo_ener a
	 where a.cod_planta  = '2'
		and a.nro_consumo = p.nro_consumo
		and p.fecha_consumo = :ald_fecha_consumo;
		
ldc_result = Round(((aldc_acometida_h + ldc_monto_aco_cong) - aldc_distribucion_d),4)
					
Return  ldc_result
end function

on w_pr320_consumo_energia.create
int iCurrent
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
this.st_nro=create st_nro
this.sle_nro=create sle_nro
this.cb_1=create cb_1
this.dw_detail=create dw_detail
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_nro
this.Control[iCurrent+2]=this.sle_nro
this.Control[iCurrent+3]=this.cb_1
this.Control[iCurrent+4]=this.dw_detail
end on

on w_pr320_consumo_energia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_nro)
destroy(this.sle_nro)
destroy(this.cb_1)
destroy(this.dw_detail)
end on

event resize;//Override

dw_master.width  = newwidth  - dw_master.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_insert;//// Override
Long  ll_row


if idw_1 = dw_master THEN
    dw_master.Reset()
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if

end event

event ue_open_pre;call super::ue_open_pre;of_asigna_dws( )

ib_log 		= TRUE

is_tabla_d 	= 'PROD_CONSUMO_ENER_DET'

idw_detail.settransobject(sqlca)
idw_detail.ii_protect = 0
idw_detail.of_protect()

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
String   ls_cod_cert

dw_master.AcceptText( )
idw_detail.AcceptText( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

// Para el log diario
IF ib_log THEN
	dw_master.of_create_log()
	idw_detail.of_create_log()
END IF

IF	idw_detail.ii_update = 1 THEN
	IF idw_detail.Update() = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		MessageBox('Error en Base de Datos', 'No se pudo grabar Maestro')
	END IF
END IF


dec 		ldc_consumo_total_aprox = 0
string 	ls_nro_consumo
			ls_nro_consumo = dw_master.object.nro_consumo[1]
			
select sum(ajuste_diario)
  into :ldc_consumo_total_aprox
  from prod_consumo_ener_det
 where nro_consumo = :ls_nro_consumo;
 
		dw_master.object.imp_total_aprox [1] = ldc_consumo_total_aprox
		
		dw_master.ii_update = 1
		
IF	dw_master.ii_update = 1 THEN
	IF dw_master.Update() = -1 then		// Grabacion del Master
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
	END IF
END IF

IF lbo_ok THEN
	COMMIT using SQLCA;
	
	this.event ue_desviacion()
		
	dw_master.ii_update = 0
	idw_detail.ii_update = 0

	
	dw_master.ii_protect = 0
	//idw_detail.ii_protect = 0
	

	dw_master.of_protect( )
	//idw_detail.of_protect( )


	is_action = 'open'

	
END IF
end event

event ue_update_pre;call super::ue_update_pre;long 		ll_row, ll_master
Integer 	li_count

// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "form") <> true then return

// Verifica que campos son requeridos y tengan valores
if f_row_Processing( idw_detail, "tabular") <> true then return

//Para la replicacion de datos

dw_master.of_set_flag_replicacion()
idw_detail.of_set_flag_replicacion()

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

IF (dw_master.ii_update 	  = 1 or idw_detail.ii_update = 1 ) THEN
	
	li_msg_result = MessageBox("Actualizaciones Pendientes", &
	                           "Grabamos", Question!, YesNo!, 1)
	
	IF li_msg_result 			= 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update 			= 0
		idw_detail.ii_update 		= 0
	END IF
END IF

end event

event ue_modify;call super::ue_modify;idw_detail.of_protect( )
end event

event ue_retrieve_list;call super::ue_retrieve_list;// Asigna valores a structura 
Long ll_row
str_parametros sl_param

TriggerEvent ('ue_update_request')		

sl_param.dw1    = 'ds_consumo_ener_tbl'
sl_param.titulo = "Consumos de Energía"
sl_param.field_ret_i[1] = 1

sl_param.tipo    = '1SQL'
sl_param.string1 =  "AND SUBSTR(NRO_CONSUMO,1,2) = '"+ gs_origen + "'" 



OpenWithParm( w_lista, sl_param)

sl_param = Message.PowerObjectParm
IF sl_param.titulo <> 'n' THEN
	is_nro_parte = sl_param.field_ret[1]
	This.of_retrieve (is_nro_parte)	
END IF

end event

type dw_master from w_abc_master`dw_master within w_pr320_consumo_energia
event ue_display ( string as_columna,  long al_row )
integer y = 208
integer width = 3470
integer height = 756
string dataobject = "d_prod_consumo_energia"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, &
			ls_desc_cencos_r, ls_proveedor
			
Long		ll_row_find

//str_parametros sl_param

choose case upper(as_columna)
		
		case "COD_PLANTA"

		ls_sql = "SELECT COD_PLANTA AS CODIGO_PLANTA, " &
				  + "DESC_PLANTA AS DESCRIPCION " &
				  + "FROM TG_PLANTAS " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_planta		[al_row] = ls_codigo
			this.object.desc_planta		[al_row] = ls_data
			this.ii_update = 1
		end if
		
		case "COD_ORIGEN"

		ls_sql = "SELECT COD_ORIGEN AS CODIGO, " &
				  + "NOMBRE AS DESCRIPCION " &
				  + "FROM ORIGEN " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_origen		[al_row] = ls_codigo
			this.object.nombre		   [al_row] = ls_data
			this.ii_update = 1
		end if
		
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
					
end choose
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'form'	// tabular, form (default)

ii_ss = 1				// indica si se usa seleccion: 1=individual (default), 0=multiple

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_det  = idw_detail // dw_detail
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

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte
Long		ll_count, ll_cuenta, ll_detail
integer	li_item
dec		ldc_factor_cliente

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
			this.object.cod_planta	  	[row] = ls_codigo
			this.object.desc_planta		[row] = ls_codigo
			return 1
		end if

		this.object.desc_planta			[row] = ls_data
		
		case "cod_origen"

		select nombre
			into :ls_data
		from origen
		where cod_origen = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Origen no existe o no esta activa", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_origen	  	[row] = ls_codigo
			this.object.nombre		[row] = ls_codigo
			return 1
		end if

		this.object.nombre		[row] = ls_data
		
		case "nro_dias_habiles"
			
			ldc_factor_cliente = of_factor_cliente_m()
	
		if ldc_factor_cliente > 0.5 then
			Messagebox('Control de Energia','El factor Cliente a Superado la Cota de 0.5..~r~ Tome las Medidas Necesarias')
		end if

		this.object.factor_cliente [dw_master.GetRow()] = ldc_factor_cliente	
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

this.object.fecha_registro			[al_row] = f_fecha_actual()
this.object.cod_usr					[al_row] = gs_user
this.object.p_logo.filename 			   	= gs_logo

//Cargamos Datos iniciales de configuración

dw_master.Setitem(al_row,"ano",YEAR(date(f_fecha_actual())))
dw_master.Setitem(al_row,"mes",MONTH(date(f_fecha_actual())))
idw_detail.reset()



end event

type st_nro from statictext within w_pr320_consumo_energia
integer x = 9
integer y = 48
integer width = 425
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
string text = "Numero de Consumo:"
alignment alignment = center!
boolean border = true
boolean focusrectangle = false
end type

type sle_nro from singlelineedit within w_pr320_consumo_energia
integer x = 457
integer y = 68
integer width = 389
integer height = 92
integer taborder = 10
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

type cb_1 from commandbutton within w_pr320_consumo_energia
integer x = 864
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

event clicked;string ls_nro_certificado

EVENT ue_update_request()   // Verifica actualizaciones pendientes

ls_nro_certificado = Trim(sle_nro.text)

of_retrieve(ls_nro_certificado)

end event

type dw_detail from u_dw_abc within w_pr320_consumo_energia
event ue_update_max_dem ( )
integer x = 9
integer y = 996
integer width = 4425
integer height = 740
integer taborder = 30
boolean bringtotop = true
string dataobject = "d_prod_consumo_energia_det"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = false
end type

event ue_update_max_dem();Dec 		max_lect_hp, max_lect_fhp, ldc_factor_cliente, lcd_precio_para_pagar, &
			ldc_resultado1_m47, ldc_mdg_fhp, max_lect_hp_r, max_lect_fhp_r
			
string	ls_nro_consumo, ls_cod_planta, ls_cod_origen
Integer  li_mes, li_year, ln_count

ls_nro_consumo     = dw_master.object.nro_consumo[dw_master.GetRow()]
			
		li_mes     		= dw_master.object.mes[dw_master.GetRow()]
		li_year    		= dw_master.object.ano[dw_master.GetRow()]
		ls_cod_planta  = dw_master.object.cod_planta[dw_master.GetRow()]
		ls_cod_origen  = dw_master.object.cod_origen[dw_master.GetRow()]

SELECT count(*) 
  INTO :ln_count
  FROM historico_max_demanda H
 WHERE h.cod_planta = :ls_cod_planta
   AND h.cod_origen = :ls_cod_origen
	AND h.ano		  = :li_year
	AND h.mes		  = :li_mes;

SELECT nvl(MAX(m.ener_max_hp),0) 
	  into :max_lect_hp_r
	  FROM prod_consumo_ener_det m
    where nro_consumo = :ls_nro_consumo;
	 
	 max_lect_hp = round(max_lect_hp_r,4)
	  
SELECT nvl(MAX(m.ener_max_fhp),0) 
	  into :max_lect_fhp_r
	  FROM prod_consumo_ener_det m
	  where nro_consumo = :ls_nro_consumo;
	  
	   max_lect_fhp = round(max_lect_fhp_r,4)
  	
	  IF ln_count = 0 THEN
			
			IF max_lect_hp > max_lect_fhp then
			
				INSERT INTO historico_max_demanda VALUES
							(:ls_cod_origen, :li_year, :li_mes, :max_lect_hp, :ls_cod_planta);
							
				IF SQLCA.sqlcode 	<> 0 THEN
					Messagebox('Control de Energia','Error'+ SQLCA.SQLErrText)
					return
				else
				commit;
				end if
		
	
			ELSE
				
			INSERT INTO historico_max_demanda VALUES
							(:ls_cod_origen, :li_year, :li_mes, :max_lect_fhp, :ls_cod_planta);
			
				IF SQLCA.sqlcode 	<> 0 THEN
				Messagebox('Control de Energia', 'ss' + SQLCA.SQLErrText)
				return
				else
				commit;
				end if
			
			END IF
			
		ELSE

		IF max_lect_hp > max_lect_fhp then
			
		update historico_max_demanda
		   set historico_max_demanda.max_demanda = :max_lect_hp
		 where historico_max_demanda.ano =:li_year
		   and historico_max_demanda.mes =:li_mes
			and historico_max_demanda.cod_planta =: ls_cod_planta
			and historico_max_demanda.cod_origen =: ls_cod_origen;
			
			IF SQLCA.sqlcode 	<> 0 THEN
			Messagebox('Control de Energia', SQLCA.SQLErrText)
			return
			else
			commit;
			end if
			
		else
		
		update historico_max_demanda
		   set historico_max_demanda.max_demanda = :max_lect_fhp
		 where historico_max_demanda.ano =: li_year
		   and historico_max_demanda.mes =: li_mes
			and historico_max_demanda.cod_planta =: ls_cod_planta
			and historico_max_demanda.cod_origen =: ls_cod_origen;
			
			IF SQLCA.sqlcode 	<> 0 THEN
			Messagebox('Control de Energia', SQLCA.SQLErrText)
			return
			else
			commit;
			end if
	
		end if
	end if
end event

event constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
	                        //'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1			// columnas de lectrua de este dw
ii_ck[2] = 2			// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master


idw_mst  = 				dw_master

end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event ue_insert_pre;//Override

datetime f_new_fecha

this.object.nro_item	[al_row] = of_nro_item(this)

this.object.fecha_consumo[al_row] = date(f_fecha_actual())

//Inicializano todos los capos en Cero

IF al_row > 1 then

this.object.LECT_ENER_ACTIVA 	[al_row] = 0
this.object.ENER_ACTIVA   		[al_row] = 0            
this.object.LECT_ENER_HP 		[al_row] = 0            
this.object.ENER_ACTIVA_HP    [al_row] = 0
this.object.LECT_ENER_FHP     [al_row] = 0
this.object.ENER_ACTIVA_FHP   [al_row] = 0
this.object.LECT_ENER_REACT   [al_row] = 0
this.object.ENER_REACTIVA     [al_row] = 0
this.object.LECT_ENER_MXHP    [al_row] = 0
this.object.ENER_MAX_HP       [al_row] = 0
this.object.LECT_ENER_MXFHP   [al_row] = 0
this.object.ENER_MAX_FHP      [al_row] = 0 
this.object.PRECIO_ENOSA_HP   [al_row] = this.object.PRECIO_ENOSA_HP   [al_row - 1] 
this.object.PRECIO_ENOSA_FHP  [al_row] = this.object.PRECIO_ENOSA_FHP  [al_row - 1]  
this.object.PRECIO_ENOSA_EA   [al_row] = this.object.PRECIO_ENOSA_EA   [al_row - 1] 
this.object.PRECIO_OSINERG_HP [al_row] = 0 
this.object.PRECIO_OSINERG_FHP[al_row] = 0 
this.object.PRECIO_OSINERG_EA [al_row] = 0 
this.object.PURD_FHP          [al_row] = 0
this.object.MDG_FHP           [al_row] = 0 
this.object.COSTO_DIARIO_ENER [al_row] = 0
this.object.AJUSTE_DIARIO 		[al_row] = 0

else
	
this.object.LECT_ENER_ACTIVA 	[al_row] = 0
this.object.ENER_ACTIVA   		[al_row] = 0            
this.object.LECT_ENER_HP 		[al_row] = 0            
this.object.ENER_ACTIVA_HP    [al_row] = 0
this.object.LECT_ENER_FHP     [al_row] = 0
this.object.ENER_ACTIVA_FHP   [al_row] = 0
this.object.LECT_ENER_REACT   [al_row] = 0
this.object.ENER_REACTIVA     [al_row] = 0
this.object.LECT_ENER_MXHP    [al_row] = 0
this.object.ENER_MAX_HP       [al_row] = 0
this.object.LECT_ENER_MXFHP   [al_row] = 0
this.object.ENER_MAX_FHP      [al_row] = 0 
this.object.PRECIO_ENOSA_HP   [al_row] = 0 
this.object.PRECIO_ENOSA_FHP  [al_row] = 0 
this.object.PRECIO_ENOSA_EA   [al_row] = 0 
this.object.PRECIO_OSINERG_HP [al_row] = 0 
this.object.PRECIO_OSINERG_FHP[al_row] = 0 
this.object.PRECIO_OSINERG_EA [al_row] = 0 
this.object.PURD_FHP          [al_row] = 0
this.object.MDG_FHP           [al_row] = 0 
this.object.COSTO_DIARIO_ENER [al_row] = 0
this.object.AJUSTE_DIARIO 		[al_row] = 0

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

event itemchanged;call super::itemchanged;string 	ls_codigo, ls_data, ls_proveedor, ls_desc, ls_null, ls_nro_parte, ls_dia,&
			ls_nro_consumo, ls_cod_planta, ls_cod_origen
Long		ll_count, ll_cuenta, ll_detail
integer	li_ano_p, li_mes_p
integer	li_item, ll_i, ll_2, ll_ii, li_mes, li_year, lc_ia, &
			li_item_anterior, ll_c47, ll_c47i, ll_22, ll_ia, li_return
date		ld_ayer, ld_fecha_c
dec		ldc_ener_activa, ldc_ener_activa_ayer, &
										ldc_ener_hp, ldc_ener_hp_ayer, max_lect_hp, max_lect_fhp, &
										ldc_ener_fhp, ldc_ener_fhp_ayer, &
										ldc_ener_react, ldc_ener_react_ayer, &
										ldc_ener_mxhp, ldc_ener_mxfhp, ldc_prueba, &
										ldc_prom_max_6, ldc_precio_osinerg_fhp, ldc_purd_fhp, &
										ldc_ener_reactiva_total, ldc_ener_activa_total, &
										ldc_resultado1_m47, ldc_resta, ldc_resultado_resta, &
										ldc_acometida, ldc_factor_cliente, lcd_precio_para_pagar, &
										ldc_mdg_fhp, ldc_valor1_o16, ldc_valor2_p16, &
										ldc_valor3_q16, ldc_valor3_r16, ldc_valor3_s16,&
										ldc_costo_total_diario, ldc_valor3_r16_2, &
										ldc_suma_ldc_valor3_r16, ldc_consumo_total_aprox, &
										ldc_resultado_resta_er, ldc_valor3_i47, ldc_valor1c47, &
										ldc_valor2c47, ldc_resultado_resta_erc47, ldc_suma_ldc_valor3_r16c47, &
										ldc_valor3_c47, ldc_valor_r48, ldc_valor1i47, ldc_valor2i47, &
										ldc_monto_aco_cong, ldc_monto_distribuido, ldc_monto_distribuido_d, &
										ldc_ajuste_diario, ldc_costo_diario
									
										
this.AcceptText()

if row <= 0 then return

		ls_nro_consumo = dw_master.object.nro_consumo [dw_master.GetRow()]
		ls_cod_origen  = dw_master.object.cod_origen [dw_master.GetRow()]
		ls_cod_planta 	= dw_master.object.cod_planta[dw_master.GetRow()]
		li_ano_p		 	= dw_master.object.ano[dw_master.GetRow()]
		li_mes_p		 	= dw_master.object.mes[dw_master.GetRow()]

		select 	p.potencia_contratada
		  into 	:ll_potencia_contratada
		  from 	prod_ener_param p
		 where	P.cod_planta 	= :ls_cod_planta
		   and   p.ano = :li_ano_p
			and   p.mes = :li_mes_p;
			
		li_mes     = dw_master.object.mes[dw_master.GetRow()]
		li_year    = dw_master.object.ano[dw_master.GetRow()]
		
choose case lower(dwo.name)
	
case "lect_ener_activa"
		
		if row = 1 then
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			return
		else
		 
		 if row > 1 then
			
			li_item_anterior 		= row - 1
			
			select lect_ener_activa
		  	  into :ldc_ener_activa_ayer
		  	  from prod_consumo_ener_det
		 	 where nro_item = :li_item_anterior and nro_consumo = :ls_nro_consumo;
		 
		 ld_ayer = date(this.object.fecha_consumo [li_item_anterior])
		 
		  if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido Lectura de Energía Activa para la Fecha' + space(3) + string(ld_ayer), StopSign!)
			this.object.ener_activa [row] = 0
			return
		  end if
		
			ldc_ener_activa 					= Round(dec(data),4)
			ldc_resultado_resta 				= ldc_ener_activa - ldc_ener_activa_ayer
		this.object.ener_activa [row] = Round((ldc_resultado_resta * ll_potencia_contratada),4)
		
   	end if
	end if
	
Parent.Event ue_update()
			
 case "lect_ener_hp"

	//Factor Cliente.....
	
		ldc_factor_cliente = of_factor_cliente()
		if ldc_factor_cliente > 0.5 then
			Messagebox('Control de Energia','El factor Cliente a Superado la Cota de 0.5..~r~ Tome las Medidas Necesarias')
		end if

		dw_master.object.factor_cliente [dw_master.GetRow()] = ldc_factor_cliente
		
		li_item_anterior 		= 0
		ldc_resultado_resta 	= 0
		li_item_anterior 		= row - 1
		
		if row 	<= 1 then
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			return
		else
			
			if row > 1 then
		
		select lect_ener_hp
		  into :ldc_ener_hp_ayer
		  from prod_consumo_ener_det
		 where nro_item = :li_item_anterior and nro_consumo = :ls_nro_consumo;
		 
		 ld_ayer = date(this.object.fecha_consumo [li_item_anterior])
		 
		 if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido Lectura de Energía Activa HP para la Fecha' + space(3) + string(ld_ayer), StopSign!)
			this.object.ener_activa_hp [row] = 0
			return
		end if
		
		ldc_ener_hp = dec(data)
		ldc_resultado_resta = ldc_ener_hp - ldc_ener_hp_ayer
		this.object.ener_activa_hp [row] = ldc_resultado_resta * ll_potencia_contratada
		
	end if
 end if
 
 Parent.Event ue_update()
		
	case "lect_ener_fhp"
		
		li_item_anterior 		= 0
		ldc_resultado_resta 	= 0
		li_item_anterior 		= row - 1
		
		if row = 1 then
			
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			Return
	
		else
			
			if row > 1 then
		
		select lect_ener_fhp
		  into :ldc_ener_fhp_ayer
		  from prod_consumo_ener_det
		 where nro_item = :li_item_anterior and nro_consumo = :ls_nro_consumo;
		 
		 ld_ayer = date(this.object.fecha_consumo [li_item_anterior])
		 
		 if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido Lectura de Energía Activa FHP para la Fecha' + space(3) + string(ld_ayer), StopSign!)
			this.object.ener_activa_fhp [row] = 0
			return
		end if
		
		ldc_ener_fhp 								= dec(data)
		ldc_resultado_resta 						= ldc_ener_fhp - ldc_ener_fhp_ayer
		this.object.ener_activa_fhp [row] 	= ldc_resultado_resta * ll_potencia_contratada
		
	end if	
end if

Parent.Event ue_update()

	case "lect_ener_react"
		
		li_item_anterior 		= 	0
		ldc_resultado_resta 	= 	0
		li_item_anterior 		= 	row - 1
		
		if row = 1 then
			
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			
		else
		 
		 	if row > 1 then
		select lect_ener_react
		  into :ldc_ener_react_ayer
		  from prod_consumo_ener_det
		 where nro_item = :li_item_anterior and nro_consumo = :ls_nro_consumo;
		 
		 ld_ayer = date(this.object.fecha_consumo [li_item_anterior])
		 
		 if SQLCA.SQLCode = 100 then
			Messagebox('Error', 'No a Definido Lectura de Energía Reactiva para la Fecha' + space(3) + string(ld_ayer), StopSign!)
			this.object.ener_reactiva [row] = 0
			return
		end if
		
		ldc_ener_react 						= dec(data)
		ldc_resultado_resta 					= ldc_ener_react - ldc_ener_react_ayer
		this.object.ener_reactiva [row] 	= ldc_resultado_resta * ll_potencia_contratada
		
	end if
end if

Parent.Event ue_update()
		
	case "lect_ener_mxhp"
		
		if row = 1 then
			
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			this.object.ener_max_hp [row] = 0
			
		else
			
			if row > 1 then
		 
		ldc_ener_mxhp = dec(data)

		this.object.ener_max_hp [row] = ldc_ener_mxhp*ll_potencia_contratada
		
   	end if
	end if
	
	Parent.Event ue_update()
	This.Event ue_update_max_dem()
	
	case "lect_ener_mxfhp"
		
		if row = 1 then
			
			messagebox('Control de Energía', 'Recuerde que Esta Fila es La Linea Base')
			this.object.ener_max_fhp [row] = 0
			
		else
			
			if row > 1 then
		 
		ldc_ener_mxfhp = dec(data)

		this.object.ener_max_fhp [row] = ldc_ener_mxfhp*ll_potencia_contratada
		
   	end if
	end if
	
	Parent.Event ue_update()
	This.Event ue_update_max_dem()
	
	case	"precio_osinerg_fhp"
	
		//Promedio de las 2 MAximas demandas de los 6 ultimos meses
		This.Event ue_update_max_dem()
		ldc_prom_max_6 = f_prom_ultimos_meses(li_year, li_mes, ls_cod_origen, ls_cod_planta)
		li_return = f_numero_dias( li_year, li_mes)
   	ldc_precio_osinerg_fhp 		= this.object.precio_osinerg_fhp [row]
		ldc_purd_fhp 					= (ldc_prom_max_6 * ldc_precio_osinerg_fhp)/li_return
				
		FOR ll_ia = 2 to dw_detail.rowcount()
			
		this.object.purd_fhp [ll_ia] = ldc_purd_fhp
		
		next

		//mdg_fhp
		ldc_mdg_fhp = 0
	
		ldc_mdg_fhp = of_mdg_hpfp_m47()/li_return
				
   	FOR ll_ia = 2 to dw_detail.rowcount()
			
		this.object.mdg_fhp [ll_ia] = ldc_mdg_fhp
		
		next
	
case "precio_osinerg_ea"
	
		ldc_tarifa_KWhr 	= dec(data)
		li_return 			= f_numero_dias( li_year, li_mes)
		ldc_valor_r48		= of_ldc_valor_r48()
		
		Select nvl(p.mnt_calculado,0)
		  into :ldc_monto_distribuido
		  from prod_ener_distribucion p
		 where p.nro_consumo = :ls_nro_consumo;
		 
		ldc_monto_distribuido_d = round((ldc_monto_distribuido / li_return),4)
		
   	FOR lc_ia = 2 to this.rowcount( )
		
		ldc_valor1_o16 = (this.object.ener_activa_hp[lc_ia])*(this.object.precio_enosa_hp[lc_ia])
		ldc_valor2_p16 = (this.object.ener_activa_fhp[lc_ia])*(this.object.precio_enosa_fhp[lc_ia])
		ldc_valor3_q16 = this.object.purd_fhp[lc_ia]
		ldc_valor3_r16 = ((this.object.ener_reactiva[lc_ia] - (this.object.ener_activa[lc_ia]*0.3))*ldc_tarifa_KWhr)
		ldc_valor3_s16 = this.object.mdg_fhp[lc_ia]
		
		ldc_costo_total_diario = (ldc_valor1_o16 + ldc_valor2_p16 + &
										  ldc_valor3_q16 + ldc_valor3_r16 + &
										  ldc_valor3_s16)
											  
		ldc_costo_diario = (ldc_costo_total_diario - (ldc_valor_r48/li_return)) 
		
		If trim(ls_cod_planta) = '1' then
			
			ld_fecha_c = date(this.object.fecha_consumo [lc_ia])
		
		ldc_ajuste_diario = of_calcula_ajuste_diario(ldc_costo_diario, ld_fecha_c, ldc_monto_distribuido_d)
								
		this.object.costo_diario_ener [lc_ia]	= 	ldc_costo_diario
		this.object.ajuste_diario 		[lc_ia] 	=  ldc_ajuste_diario
		
		else
		
		this.object.costo_diario_ener [lc_ia]	= 	ldc_costo_diario
		this.object.ajuste_diario 		[lc_ia] 	=  ldc_costo_diario
		
   	end if
		
	next
	
	Parent.Event ue_update() 
	
end choose
end event

