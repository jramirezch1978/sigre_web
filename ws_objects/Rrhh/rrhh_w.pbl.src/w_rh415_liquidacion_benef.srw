$PBExportHeader$w_rh415_liquidacion_benef.srw
forward
global type w_rh415_liquidacion_benef from w_abc_mastdet_smpl
end type
type dw_periodos from u_dw_abc within w_rh415_liquidacion_benef
end type
end forward

global type w_rh415_liquidacion_benef from w_abc_mastdet_smpl
integer width = 4745
integer height = 2432
string title = "[RH415] Liquidaciones de beneficio del Trabajador"
string menuname = "m_master_cl_anular"
windowanimationstyle openanimation = centeranimation!
windowanimationstyle closeanimation = fadeanimation!
windowdockstate windowdockstate = windowdockstatetabbedwindow!
event ue_generar_liquidacion ( long al_row )
event type decimal ue_remuneracion_computable ( long al_row )
event type decimal ue_gratificacion_trunca ( long al_row,  decimal adc_remuneracion )
event type decimal ue_cts_trunco ( long al_row,  decimal adc_remuneracion,  decimal adc_gratificacion )
event type decimal ue_vacaciones_truncas ( long al_row,  decimal adc_remuneracion )
event type decimal ue_descuentos_afp ( long al_row,  decimal adc_remuneracion,  decimal adc_gratificacion )
event type decimal ue_prom_ultima_gratificacion ( long al_row,  decimal adc_remuneracion )
event type decimal ue_bonificacion ( long al_row,  decimal adc_gratif_trunca )
event type decimal ue_descuentos_cta_cte ( long al_row )
event type decimal ue_descuento_quinta ( long al_row )
event ue_preview ( )
event type decimal ue_dev_quinta ( long al_row )
event type decimal ue_essalud ( long al_row,  decimal adc_remuneracion )
dw_periodos dw_periodos
end type
global w_rh415_liquidacion_benef w_rh415_liquidacion_benef

type variables
string 	is_emp = 'EMP', is_Jor = 'JOR', is_ejo = 'EJO', is_fun = 'FUN', is_des = 'DES', &
			is_essalud, is_grati_des = '1421', is_grp_var_lbs = '806'
string	is_cencos, is_cnta_prsp, is_prov_SUNAT, is_concepto_cts = '1407', is_ONP
decimal 	idc_remuneracion, idc_porc_bonif = 0.00, idc_total_dias_vacac, idc_dias_laborados

//COnceptos ESSALUD
String	is_essalud_gen, is_essalud_agr

n_cst_maestro	invo_maestro
end variables

forward prototypes
public subroutine of_set_confin (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row)
public function integer of_retrieve (string as_nro_liquidacion)
public function boolean usp_gen_cnta_pagar_lbs ()
public subroutine of_set_cnta_prsp (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row)
public subroutine of_modify_dws ()
public function boolean of_set_numera_str (ref string as_ult_nro)
public subroutine of_set_concepto_plame (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row)
end prototypes

event ue_generar_liquidacion(long al_row);decimal 	ldc_remuneracion, ldc_gratif_trunca, ldc_vacaciones, &
			ldc_cts_trunco, ldc_afp_onp, ldc_prom_ult_grati, ldc_bonif_extra, &
			ldc_desc_cta_cte, ldc_quinta_categ
integer 	li_i

String 	ls_tipo_trabaj, ls_flag_reg_laboral

//Obtengo el tipo de trabajador
ls_tipo_trabaj 		= dw_master.object.tipo_trabajador	[al_row]
ls_flag_reg_laboral	= dw_master.object.flag_reg_laboral	[al_row]

//Flag Regimen Laboral
/*
	1. Regimen General
	2. Regimen Publico
	3. Regimen Agricola
*/

if ls_flag_reg_laboral = '2' then
	MessageBox('Aviso', 'El Regimen del Trabajador es PUBLICO, no es ' &
							+ 'factible hacer Liquidaciones a un REGIMEN PUBLICO', StopSign!)
	return
end if

if ls_flag_reg_laboral = '3' then
	if MessageBox('Aviso', 'El Regimen del Trabajador es AGRICOLA, por lo que ' &
							+ 'unicamente se liquidarán las VACACIONES TRUNCAS. ¿Desea Continuar?', &
							Information!, YesNo!, 1) = 2 then
		return
	end if
end if

if ls_flag_reg_laboral = '1' then
	MessageBox('Aviso', 'El Regimen del Trabajador es REGIMEN GENERAL, por lo que ' &
							+ 'en esta Liquidacion se tomarán en cuenta GRATIFICACION TRUNCA, CTS TRUNCO Y VACACIONES TRUNCAS', Information!)
end if

//Elimino el detalle
do while dw_detail.RowCount() > 0
	dw_detail.DeleteRow( 0)
loop

if ls_flag_reg_laboral = '3' then
	idc_total_dias_vacac = 15
else
	idc_total_dias_vacac = 30
end if
 

//Primero calculo la remuneracion computable
ldc_remuneracion = this.event ue_remuneracion_computable(al_row)

if ldc_remuneracion < 0 then return

//Solo se calcula la gratificacion Trunca si esta en el Regimen General
if ls_flag_reg_laboral = '1' then
	ldc_prom_ult_grati = this.event ue_prom_ultima_gratificacion( al_row, ldc_remuneracion )
end if

//Solo para el Regimen General, se calcula la Gratificacion Trunca
if ls_flag_reg_laboral = '1' then
	ldc_gratif_trunca = this.event ue_gratificacion_trunca( al_row, ldc_remuneracion )
	if ldc_gratif_trunca > 0 then
		ldc_bonif_extra 	= this.event ue_bonificacion( al_row, ldc_gratif_trunca )
	end if
else
	ldc_gratif_trunca = 0
end if

//EL CTS TRUNCO solo se aplica al regimen General
if ls_flag_reg_laboral = '1' then
	ldc_cts_trunco = this.event ue_cts_trunco( al_row, ldc_remuneracion + ldc_prom_ult_grati , ldc_gratif_trunca)
end if

//VACACIONES TRUNCAS
ldc_vacaciones = this.event ue_vacaciones_truncas( al_row, ldc_remuneracion)

if ldc_vacaciones = -2 then return


//DESCUENTOS AFP/ONP
if ldc_vacaciones > 0 then
	ldc_afp_onp = this.event ue_descuentos_afp( al_row, ldc_vacaciones, ldc_gratif_trunca)
end if

//DESCUENTOS DE CNTA CTE
if ldc_gratif_trunca + ldc_cts_trunco + ldc_vacaciones > 0 then
	ldc_desc_cta_cte = this.event ue_descuentos_cta_cte( al_row )
end if

//RENTA DE QUINTA
ldc_quinta_categ = this.event ue_descuento_quinta( al_row )

//APORTACION ESSALUD
if ldc_vacaciones > 0 then
	this.event ue_essalud( al_row, ldc_vacaciones  )
end if


for li_i = 1 to dw_detail.RowCount()
	//Coloco los confines necesarios
	of_set_confin( string(dw_detail.object.flag_titulo_lbs[li_i]), ls_tipo_trabaj, li_i)
	
	//Coloco las cuentas presupuestales necesarias
	of_set_cnta_prsp( string(dw_detail.object.flag_titulo_lbs[li_i]), ls_tipo_trabaj, li_i)
	
	//Coloco los conceptos plame
	of_set_concepto_plame( string(dw_detail.object.flag_titulo_lbs[li_i]), ls_tipo_trabaj, li_i)
next

end event

event type decimal ue_remuneracion_computable(long al_row);string 	ls_codigo, ls_hb = '1001', ls_asig = '1003', ls_tipo_trabaj, &
			ls_desc_detalle, ls_flag = '0', ls_mensaje
decimal 	ldc_haber, ldc_remuneracion, ldc_imp_var, ldc_asig_fam, ldc_tot_haber, &
			ldc_total_var
long		ll_row
date		ld_fecha1, ld_fecha2, ld_fec_ult_dia_laborado, ld_first_date
Integer	li_count, li_mes, li_year, li_day

ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]

//Calculo la fecha menor y mayor para el calculo del promedio de las horas extras
ld_fecha1 = Date(dw_periodos.object.fec_inicio_periodo[1])
ld_fecha2 = Date(dw_periodos.object.fec_final_periodo	[1])

//Obtengo la primera fecha y la ultima, basada en los periodos

for ll_row = 1 to dw_periodos.RowCount()
	if Date(dw_periodos.object.fec_inicio_periodo[ll_row]) < ld_fecha1 then
		ld_fecha1 = Date(dw_periodos.object.fec_inicio_periodo[ll_row])
	end if
	
	if Date(dw_periodos.object.fec_final_periodo[ll_row]) > ld_fecha2 then
		ld_fecha2 = Date(dw_periodos.object.fec_final_periodo[ll_row])
	end if
	
	idc_dias_laborados += Dec(dw_periodos.object.dias_laborados[ll_row])
	
next

//Valido que tenga planillas cerradas antes de liquidar
select count(distinct hc.fec_calc_plan)
  into :li_count
  from historico_calculo hc
where hc.cod_trabajador = :ls_codigo
  and hc.concep			= '2399'
  and trunc(hc.fec_calc_plan) between :ld_fecha1 and :ld_fecha2
  and hc.imp_soles		> 0;

if li_count = 0 then
	MessageBox('Error', 'No hay registros de planillas en HISTORICO CALCULO para el trabajador ' + ls_codigo &
						 + ' entre las fechas del periodo(s) de liquidacion ' &
						 + '~r~nFecha Inicio: ' + string(ld_fecha1) &
						 + '~r~nFecha Fin: ' + string(ld_fecha2), StopSign!)
	return -1
end if

select max(hc.fec_calc_plan)
  into :ld_fec_ult_dia_laborado
  from historico_calculo hc
where hc.cod_trabajador = :ls_codigo
  and hc.concep			= '2399'
  and trunc(hc.fec_calc_plan) between :ld_fecha1 and :ld_fecha2
  and hc.imp_soles		> 0;
  

////Obtengo el ultima día laborado
//select pkg_rrhh.of_ult_dia_laborado(:ls_codigo)
//	into :ld_fec_ult_dia_laborado
//from dual;
//
//if SQLCA.SQLCode < 0 then
//	ls_mensaje = SQLCA.SQLErrText
//	ROLLBACK;
//	MessageBox('Error', 'Ha ocurrido un error al obtener el ultimo día ' &
//							+ 'de Trabajo. Mensaje: ' + ls_mensaje, StopSign!)
//	return -1
//end if


// Si es de SEAFROST y es un destajero entonces reviso 
ldc_haber = 0
ldc_imp_var = 0

if upper(gs_empresa) = 'SEAFROST' then
	if ls_tipo_trabaj = 'DES' then
		
		if ld_fec_ult_dia_laborado < ld_fecha2 then
			ld_Fecha2 = ld_fec_ult_dia_laborado
		end if
		
		//Obtengo el primer día basado en los seis ultimos meses
		li_mes 	= month(ld_fecha2)
		li_year 	= year(ld_fecha2)
		li_day	= day(ld_fecha2)
		
		li_mes = li_mes - 6 + 1
		
		if li_mes <= 0 then
			li_year = li_year - 1
			li_mes = li_mes + 12
		end if
		
		ld_first_date = Date ( li_year, li_mes, li_day )
		
		if ld_first_date > ld_fecha1 then
			ld_fecha1 = ld_first_date
		end if
		
		//Encuentro los días laborados
		select pkg_rrhh.of_dias_laborados(:ls_codigo, :ld_fecha1, :ld_fecha2)
			into :idc_dias_laborados
 	 	from dual;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error al obtener los días Trabajados ' &
									+ 'para el codigo ' + ls_codigo + ', Rango: ' &
									+ string(ld_fecha1) + ' / ' + string(ld_Fecha2) &
									+ "~r~nMensaje: " + ls_mensaje, StopSign!)
			return -1
		end if
		
		//Sumo la cantidad de ingresos variables durante todo el periodo
		select NVL(sum(hc.imp_soles),0)
			into :ldc_tot_haber
		from historico_calculo hc,
			  concepto          c,
			  grupo_calculo_det gcd
		where hc.concep = c.concep
		  and hc.concep = gcd.concepto_calc
		  and gcd.grupo_calculo = :is_grp_var_lbs
		  and hc.cod_trabajador = :ls_codigo
		  and trunc(hc.fec_calc_plan) between :ld_Fecha1 and :ld_fecha2;
		  
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MessageBox('Error', 'Ha ocurrido un error el total de ingresos para DESTAJEROS ' &
									+ '~r~nCodigo: ' + ls_codigo &
									+ '~r~nRango: ' + string(ld_fecha1) + ' / ' + string(ld_Fecha2) &
									+ "~r~nMensaje: " + ls_mensaje, StopSign!)
			return -1
		end if
		
		//En caso que haya variables 
		If IsNull(ldc_tot_haber) then ldc_tot_haber = 0
		ldc_haber = round(ldc_tot_haber / idc_dias_laborados * 30,2)
  
	else
		ls_flag = '1'
	end if
else
	ls_flag = '1'
end if

if ls_flag = '1' then
	
	
	
	if idc_dias_laborados <= 0 then
		MessageBox('Error', 'Error en el periodo de liquidacion para el trabajador ' + ls_codigo &
							+ "~r~nNo hay dias laborados en el Periodo Indicado, por favor verifique!", StopSign!)
		return -1
	end if
	
		
	//Haber Basico
	if ls_tipo_trabaj = is_emp then
		
		select NVL(sum(imp_gan_desc),0)
			into :ldc_haber
			from gan_desct_fijo
		where cod_trabajador = :ls_codigo
		  and concep			= :ls_hb;
		
		If IsNull(ldc_haber) then ldc_haber = 0
		
		ls_desc_detalle = 'HABER BASICO'
		
	elseif ls_tipo_trabaj = is_jor or ls_tipo_trabaj = is_des or ls_tipo_trabaj = is_ejo then
		
		//Primero tengo que sacar las fechas desde el primer periodo al ultimo periodo
		if dw_periodos.RowCount() = 0 then
			MessageBox('Error', 'Debe especificar primero los periodos laborales', StopSign!)
			return 0.0
		end if
		
		//Si es EJO o JOR entonces saco el jornal que es la remuneración computable
		if ls_tipo_trabaj = is_jor or ls_tipo_Trabaj = is_ejo then
				select NVL(sum(imp_gan_desc),0)
					into :ldc_haber
					from gan_desct_fijo
				where cod_trabajador = :ls_codigo
				  and concep			= :ls_hb;
				
				ls_desc_detalle = 'HABER BASICO'
		else
			ldc_haber = 0;
		end if
		
		
		
		//Calculo el promedio de las horas extras
		select NVL(sum(hc.imp_soles),0)
			into :ldc_total_var
		from historico_calculo hc,
			  concepto          c,
			  grupo_calculo_det gcd
		where hc.concep = c.concep
		  and hc.concep = gcd.concepto_calc
		  and gcd.grupo_calculo = :is_grp_var_lbs
		  and hc.cod_trabajador = :ls_codigo
		  and trunc(hc.fec_calc_plan) between :ld_Fecha1 and :ld_fecha2;
		
		
	
		//En caso que haya variables 
		If IsNull(ldc_total_var) then ldc_total_var = 0
		ldc_imp_var = round(ldc_total_var / idc_dias_laborados * 30,2)
		
	end if

end if


if ldc_haber > 0 then

	ll_row = dw_detail.event ue_insert( )
	
	if ll_row = 0 then return -1
	
	if len(trim(ls_desc_detalle)) > 0 then
		ls_desc_detalle = 'HABER BASICO COMPUTABLE: ' + string(ldc_haber, '###,##0.00') 
	
		if ldc_tot_haber > 0 and idc_dias_laborados > 0 then
			ls_desc_detalle += " (" + string(ldc_tot_haber, '###,##0.00') + " / " &
								 + string(idc_dias_laborados, '###,##0.00') + " * 30)"
		end if
	end if
	
	dw_detail.object.flag_titulo_lbs	[ll_row] = '1'
	dw_detail.object.titulo				[ll_row] = 'REMUNERACION COMPUTABLE'
	dw_detail.object.DESC_detalle		[ll_row] = ls_desc_detalle
	dw_detail.object.importe			[ll_row] = ldc_haber

	ldc_remuneracion += ldc_haber
end if

if ldc_imp_var > 0 then
	ll_row = dw_detail.event ue_insert( )
	
	if ll_row = 0 then return -1
	
	ls_desc_detalle = 'PROMEDIO INGRESOS VARIABLES: ' + string(ldc_total_var, '###,##0.00') &
						 + " / " + string(idc_dias_laborados) + " * 30"
	
	dw_detail.object.flag_titulo_lbs	[ll_row] = '1'
	dw_detail.object.titulo				[ll_row] = 'REMUNERACION COMPUTABLE'
	dw_detail.object.DESC_detalle		[ll_row] = ls_desc_detalle
	dw_detail.object.importe			[ll_row] = ldc_imp_var

	ldc_remuneracion += ldc_imp_var
end if

//ASignacion Familiar
SELECT decode(G.IMP_GAN_DESC,0, (g.porcentaje*(select * from (select r.rmv from rmv_x_tipo_trabaj r where r.tipo_trabajador = :ls_tipo_trabaj order by r.fecha_desde desc) where rownum = 1))/100,g.imp_gan_desc)
	into :ldc_asig_fam
	from gan_desct_fijo g
where cod_trabajador = :ls_codigo
  and concep			= :ls_asig;

if SQLCA.SQLCode = 100 then ldc_asig_fam = 0

IF ldc_asig_fam > 0 then
	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return -1
	
	dw_detail.object.flag_titulo_lbs		[ll_row] = '1'
	dw_detail.object.titulo					[ll_row] = 'REMUNERACION COMPUTABLE'
	dw_detail.object.DESC_detalle			[ll_row] = 'ASIG. FAMILIAR'
	dw_detail.object.importe				[ll_row] = ldc_asig_fam
	
	ldc_remuneracion += ldc_asig_fam
end if

return ldc_remuneracion


end event

event type decimal ue_gratificacion_trunca(long al_row, decimal adc_remuneracion);string 	ls_tipo_trabaj, ls_codigo, ls_mensaje
integer	li_mes, li_year, li_i, li_dias, li_count
date		ld_fec_final, ld_fec_gratif, ld_fec_ingreso, ld_fec_cese, ld_fec_hist_gratif
long		ll_row
decimal	ldc_gratif_trunca = 0

ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]
ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ld_fec_ingreso = date(dw_master.object.fec_ingreso [al_row])
ld_fec_cese		= date(dw_master.object.fec_salida 	[al_row])

//Solo debo calcular gratificacion trunca para aquellos que lo tengan
if ls_tipo_trabaj = is_emp or ls_tipo_trabaj = is_fun or ls_tipo_trabaj = is_des or &
	ls_tipo_trabaj = is_jor or ls_tipo_trabaj = is_ejo then
	
	//Obtengo la ultima fecha de gratificacion
	select count(*)
	  into :li_count
  	from historico_calculo hc
 	where hc.cod_trabajador = :ls_codigo
     and hc.concep in (select * 
	  							 from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTOS_ONLY_GRATIF', '1421,1461,1462,1475'))));
									
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Ha ocurrido un error al contar los registros en historico_calculo' &
								 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
		return -1
	end if
	
	if li_count > 0 then
		
		select trunc(max(hc.fec_calc_plan))
		  into :ld_fec_hist_gratif
		from historico_calculo hc
		where hc.cod_trabajador = :ls_codigo
		  and hc.concep in (select * 
	  							 	from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTOS_ONLY_GRATIF', '1421,1461,1462,1475'))));
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Error', 'Ha ocurrido un error al obtener la fecha de Proceso en historico_calculo, con los conceptos de GRATIFICACION' &
									 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
			return -1
		end if
			
		//Si la fecha es de noviembre entonces la fecha debe ser el 01 del mes
		li_mes = integer(string(ld_fec_hist_gratif, 'mm'))
		
		if li_mes = 12 or li_mes = 07 then
			
			li_year = integer(string(ld_fec_hist_gratif, 'yyyy'))
		
			
			ld_fec_gratif = date(li_year, li_mes, 01)
			
		else
			
			select :ld_fec_gratif + 1
				into :ld_fec_gratif
			from dual;
			
			if SQLCA.SQLCode < 0 then
				ls_mensaje = SQLCA.SQLErrText
				ROLLBACK;
				MEssageBox('Error', 'Error al incrementar la fecha de ultima gratificacion.' &
										 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
				return -1
			end if
			
		end if
		
	else
		//En caso de que no tengra gratificacion tomo la fecha de ingreso
		ld_fec_gratif = ld_fec_ingreso
		
	end if

	//Ahora recorro todos los periodos para actualizar 
	ld_fec_final = ld_fec_ingreso
	
	for li_i = 1 to dw_periodos.RowCount()
		if ld_fec_final < date(dw_periodos.object.fec_final_periodo	[li_i]) then
			ld_fec_final  = date(dw_periodos.object.fec_final_periodo	[li_i])
		end if
	next
	
	//Si la fecha de gratificacion es mayor o igual al periodo entonces no procede
	if (ld_fec_gratif >= ld_fec_final) then 
		MessageBox('Error', 'La ultima fecha de gratificacion es mayor a la fecha final de todos los periodos laborables seleccionados' &
								 + "~r~nFecha Ult Gratif: " + string(ld_fec_hist_gratif) &
								 + "~r~nUlt. Fecha Periodo: " + string(ld_fec_final) &
								 + "~r~nPor favor corrija!", StopSign!)
		return -1
	end if
	
	//Si la fecha de cese esta antes del periodo tampoco tener en cuenta
	if (not IsNull(ld_fec_cese) and ld_fec_cese < ld_fec_final) then
		MessageBox('Error', 'La fecha de cese del trabajador es menor a la fecha final ' &
								 + 'de los periodos laborables seleccionados, se tomará como fecha Final ' &
								 + 'la fecha de cese. ' &
								 + "~r~nFecha Cese: " + string(ld_fec_cese) &
								 + "~r~nUlt. Fecha Periodo: " + string(ld_fec_final), StopSign!)
		ld_fec_final = ld_fec_cese
	end if
	
		
	//Obtengo los días del periodo
	select :ld_fec_final - :ld_fec_gratif + 1
		into :li_dias
	from dual;
	
	
	
	ldc_gratif_trunca = round(adc_remuneracion / 180 * li_dias, 2)
	
	if li_dias > 0 and ldc_gratif_trunca > 0 then
		
		ll_row = dw_detail.event ue_insert( )
		if ll_row = 0 then return -1

		dw_detail.object.flag_titulo_lbs	[ll_row] = '2'
		dw_detail.object.titulo				[ll_row] = 'GRATIFICACION TRUNCA'
		dw_detail.object.DESC_detalle		[ll_row] = 'Del ' + string(ld_fec_gratif, 'dd/mm/yyyy') + ' al ' + string(ld_fec_final, 'dd/mm/yyyy') &
																+ ": " + string(li_dias) + " dias. " + string(adc_remuneracion, "###,##0.00") &
																+ "/180 * " + string(li_dias)
																
		
		dw_detail.object.importe			[ll_row] = ldc_gratif_trunca
	end if
	
else
	ldc_gratif_trunca = 0
end if



return ldc_gratif_trunca
end event

event type decimal ue_cts_trunco(long al_row, decimal adc_remuneracion, decimal adc_gratificacion);string 	ls_tipo_trabaj, ls_codigo, ls_mensaje
integer	li_mes, li_year, li_i, li_dias, li_count
date		ld_fecha1, ld_fecha2, ld_fec_ult_cts, ld_fec_ingreso, ld_fec_cese
long		ll_row
decimal	ldc_cts_trunco = 0, ldc_importe

ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]
ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ld_fec_ingreso = date(dw_master.object.fec_ingreso [al_row])
ld_fec_cese		= date(dw_master.object.fec_salida 	[al_row])

//Solo debo calcular gratificacion trunca para aquellos que lo tengan
if ls_tipo_trabaj = is_emp or ls_tipo_trabaj = is_fun or ls_tipo_trabaj = is_jor or &
	ls_tipo_trabaj = is_EJO or ls_tipo_trabaj = is_des then 
	
	select count(*)
	  into :li_count
	from cts_decreto_urgencia g
	where g.cod_trabajador = :ls_codigo;
	
	if SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MEssageBox('Error', 'Error al consultar tabla cts_decreto_urgencia.' &
								 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
		return -1
	end if
	
	if li_count = 0 then
		//En caso de que no tengra gratificacion tomo la fecha de ingreso
		ld_fec_ult_cts = ld_fec_ingreso
	else
		select max(fec_proceso)
		  into :ld_fec_ult_cts
		from cts_decreto_urgencia g
		where g.cod_trabajador = :ls_codigo;
		
		if SQLCA.SQLCode < 0 then
			ls_mensaje = SQLCA.SQLErrText
			ROLLBACK;
			MEssageBox('Error', 'Error al consultar la ultima fecha de proceso de tabla cts_decreto_urgencia.' &
									 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
			return -1
		end if
		
		//obtengo ls siguiente fecha
		li_mes = integer(string(ld_fec_ult_cts, 'mm'))
		li_year = integer(string(ld_fec_ult_cts, 'yyyy'))
		
	
		ld_fec_ult_cts = date(string(li_year, '0000') + "/" + string(li_mes, '00') + "/01")
		
	end if
	
	
	//Ahora recorro los periodos para sumar los dias
	ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[1])
	ld_fecha2 = date(dw_periodos.object.fec_final_periodo	[1])
		
	for li_i = 1 to dw_periodos.RowCount()
		if ld_fecha1 > date(dw_periodos.object.fec_inicio_periodo[li_i]) then
			ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[li_i])
		end if
		
		if ld_fecha2 < date(dw_periodos.object.fec_final_periodo[li_i]) then
			ld_fecha2 = date(dw_periodos.object.fec_final_periodo	[li_i])
		end if
	next
	
		
	//Si la fecha es mayor a la fecha de ultima CTS
	if (ld_fec_ult_cts > ld_fecha2) then 
		MessageBox('Error', 'La Ultima Fecha del CTS es mayor a la fecha de fin de todos los periodos, ' &
								+ 'por favor verifique!' &
								+ '~r~nFecha Ult CTS: ' + string(ld_fec_ult_cts) &
								+ '~r~nFecha Fin Periodo: ' + string(ld_fecha2),StopSign!)
		return -1
	end if
		
	//Si la fecha de cese esta antes del periodo tampoco tener en cuenta
	if (not IsNull(ld_fec_cese) and ld_fec_cese < ld_fecha1) then 
		MessageBox('Error', 'La fecha de cese es menor a la fecha de inicio de todos los periodos, ' &
								+ 'por favor verifique!' &
								+ '~r~nFecha Cese: ' + string(ld_fec_cese) &
								+ '~r~nFecha Inicio: ' + string(ld_fecha1),StopSign!)
		return -1
	end if
		
	if (ld_fec_ult_cts < ld_fecha1) or (ld_fecha1 <= ld_fec_ult_cts and ld_fec_ult_cts <= ld_fecha2) then
		
		if ld_fec_ult_cts > ld_fecha1 then ld_fecha1 = ld_fec_ult_cts
		
		if not IsNull(ld_fec_cese) and ld_fec_cese < ld_fecha2 then ld_fecha2 = ld_fec_cese
		
		SELECT :ld_fecha2 - :ld_fecha1 + 1
		 INTO :li_dias 
		 FROM dual; 
		 
		ll_row = dw_detail.event ue_insert( )
		if ll_row = 0 then return -1

		dw_detail.object.flag_titulo_lbs	[ll_row] = '3'
		dw_detail.object.titulo				[ll_row] = 'CTS TRUNCO'
		dw_detail.object.DESC_detalle		[ll_row] = 'Del ' + string(ld_fec_ult_cts, 'dd/mm/yyyy') + ' al ' + string(ld_fecha2, 'dd/mm/yyyy') &
																+ ": " + string(li_dias) + " dias. " + string(adc_remuneracion + adc_gratificacion / 6, "###,##0.00") &
																+ "/360 * " + string(li_dias)
																
		ldc_importe = round((adc_remuneracion + adc_gratificacion / 6) / 360 * li_dias,2)
		dw_detail.object.importe			[ll_row] = ldc_importe
		
		ldc_cts_trunco += ldc_importe
	end if

//elseif ls_tipo_trabaj = is_des then
//	
//	if dw_detail.RowCount() = 0 then return 0
//	
//	//Ahora recorro los periodos para sumar los dias
//	ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[1])
//	ld_fecha2 = date(dw_periodos.object.fec_final_periodo	[1])
//	
//	for li_i = 1 to dw_periodos.RowCount()
//		ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[li_i])
//		ld_fecha2 = date(dw_periodos.object.fec_final_periodo	[li_i])
//		
//		//Si la fecha es mayor que el periodo entonces no procede
//		if ld_fecha1 > date(dw_periodos.object.fec_inicio_periodo[li_i]) then 
//			ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[li_i])
//		end if
//			
//		if ld_fecha2 < date(dw_periodos.object.fec_final_periodo[li_i]) then 
//			ld_fecha2 = date(dw_periodos.object.fec_final_periodo[li_i])
//		end if
//	next
//	
//	ll_row = dw_detail.event ue_insert( )
//	if ll_row = 0 then return -1
//	
//	dw_detail.object.flag_titulo_lbs	[ll_row] = '3'
//	dw_detail.object.titulo				[ll_row] = 'CTS TRUNCO' 
//	dw_detail.object.DESC_detalle		[ll_row] = 'Del ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' + string(ld_fecha2, 'dd/mm/yyyy') &
//															+ ": " + string(idc_dias_laborados) + " dias. " + string(adc_remuneracion, "###,##0.00") &
//															+ "/ 12 / 30  * " + string(idc_dias_laborados) + " DIAS."
//															
//	ldc_cts_trunco = round(adc_remuneracion / 360 * idc_dias_laborados,2)
//	dw_detail.object.importe			[ll_row] = ldc_cts_trunco

end if

return ldc_cts_trunco
end event

event type decimal ue_vacaciones_truncas(long al_row, decimal adc_remuneracion);string 	ls_tipo_trabaj, ls_codigo
integer	li_mes, li_year, li_i
date		ld_fecha1, ld_fecha2, ld_fec_cese
long		ll_row
decimal	ldc_vacac_truncas = 0, ldc_vacac_gozadas, &
			ldc_vacac_totales, ldc_dias, ldc_vacac_pendientes, ldc_dias_laborados

ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]
ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ld_fec_cese		= date(dw_master.object.fec_salida 	[al_row])

if upper(gs_empresa) <> 'SEAFROST' then
	if ls_tipo_trabaj = is_des then return 0
end if

//Valido que hayan vacaciones
ldc_vacac_pendientes = 0
ldc_dias	= 0

for li_i = 1 to dw_periodos.RowCount()
	
	ld_fecha1 = date(dw_periodos.object.fec_inicio_periodo[li_i])
	ld_fecha2 = date(dw_periodos.object.fec_final_periodo	[li_i])
	
	ldc_vacac_gozadas 	= dec(dw_periodos.object.vacaciones_gozadas	[li_i])
	ldc_dias_laborados 	= dec(dw_periodos.object.dias_laborados		[li_i])
	
	//Obtengo los días de vacaciones correspondiente
	//ldc_vacac_totales 	= idc_total_dias_vacac / 360 * ldc_dias_laborados
	ldc_vacac_totales = dec(dw_periodos.object.nro_dias_vacac		[li_i])
	
	//Si la fecha de cese esta antes del periodo tampoco tener en cuenta
	if IsNull(ldc_vacac_gozadas) then ldc_vacac_gozadas = 0
	if IsNull(ldc_vacac_totales) then ldc_vacac_totales = 0
	
	if ldc_vacac_totales > ldc_vacac_gozadas then
		ldc_vacac_pendientes += (ldc_vacac_totales - ldc_vacac_gozadas)
		ldc_dias = ldc_vacac_totales - ldc_vacac_gozadas
	end if

next

if ldc_vacac_pendientes = 0 then
	if MessageBox('Error', "No se ha especificado ningun días de vacaciones en los periodos " &
								+ "laborales, por lo que no se va procesar vacaciones truncas, " &
								+ "debe coregirlo. " &
								+ "~r~n¿Desea continuar con el procedimiento de Liquidacion de Beneficios Sociales?", &
								Information!, Yesno!, 1) = 2 then 
		return -2
	else
		return -1
	end if
end if

//Ahora recorro los periodos para sumar los dias
ll_row = dw_detail.event ue_insert( )
if ll_row = 0 then return -1


dw_detail.object.flag_titulo_lbs	[ll_row] = '4'
dw_detail.object.titulo				[ll_row] = 'VACACIONES TRUNCAS'
dw_detail.object.DESC_detalle		[ll_row] = 'Del ' + string(ld_fecha1, 'dd/mm/yyyy') + ' al ' + string(ld_fecha2, 'dd/mm/yyyy') &
														+ ": " + string(ldc_dias, "###,##0.00") + " dias. "

dw_detail.object.DESC_detalle		[ll_row] = dw_detail.object.DESC_detalle[ll_row] + string(adc_remuneracion, "###,##0.00") + "/30 * " + string(ldc_dias)

ldc_vacac_truncas = round(adc_remuneracion / 30 * ldc_dias,2)

dw_detail.object.importe			[ll_row] = ldc_vacac_truncas

return ldc_vacac_truncas
end event

event type decimal ue_descuentos_afp(long al_row, decimal adc_remuneracion, decimal adc_gratificacion);string 	ls_tipo_trabaj, ls_codigo, ls_desc_afp, ls_cod_relacion, &
			ls_nom_proveedor, ls_grp_snp, ls_cod_afp, ls_flag_comision_afp
long		ll_row
decimal	ldc_afp = 0, ldc_importe, ldc_porc_invalidez, ldc_porc_jubilac, &
			ldc_porc_comision, ldc_factor, ldc_tope_minimo

ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]
ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]

select cod_afp, nvl(flag_comision_afp, '0')
  into :ls_cod_afp, :ls_flag_comision_afp
  from maestro
 where cod_trabajador = :ls_codigo;
 
//ls_cod_afp 		= dw_master.object.cod_afp 			[al_row]

if IsNull(ls_cod_afp) or ls_cod_afp = '' then
	//ONP
	
	//Dscripcion de SUNAT
	select	p.nom_proveedor
		into 	:ls_nom_proveedor
	from 	proveedor p
	where	p.proveedor = :is_ONP;
	
	select nvl(c.fact_pago,0), nvl(c.imp_tope_min,0)
     into :ldc_factor, :ldc_tope_minimo
     from grupo_calculo g, 
          concepto      c
     where g.concepto_gen = c.concep 
       and g.grupo_calculo = (select c.snp from rrhhparam_cconcep c where c.reckey = '1' );
	
	ldc_importe = round(adc_remuneracion * ldc_factor,2)
	if IsNull(ldc_importe) then ldc_importe = 0
	if ldc_importe = 0 then return 0
	
	if ldc_importe < ldc_tope_minimo then
		ldc_importe = ldc_tope_minimo
	end if
	
	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return 0

	dw_detail.object.flag_titulo_lbs	[ll_row] = '5'
	dw_detail.object.titulo				[ll_row] = 'DESCUENTO ONP/SNP ' 
	dw_detail.object.DESC_detalle		[ll_row] = 'JUBILACION ' + string(ldc_factor * 100, '###,##0.00') + "% de " &
															+ string(adc_remuneracion, '###,##0.00') 
	dw_detail.object.importe			[ll_row] = ldc_importe * -1
	dw_detail.object.proveedor			[ll_row] = is_ONP
	dw_detail.object.nom_proveedor	[ll_row] = ls_nom_proveedor
	
	ldc_afp = ldc_importe
	
else
	
	//AFP
	select	a.desc_afp, a.porc_jubilac, a.porc_invalidez, 
				decode(:ls_flag_comision_afp, '1', a.porc_comision1, a.porc_comision2), 
				a.cod_relacion, p.nom_proveedor
		into 	:ls_desc_afp, :ldc_porc_jubilac, :ldc_porc_invalidez,
				:ldc_porc_comision, :ls_cod_relacion, :ls_nom_proveedor
	from 	admin_afp a,
			proveedor p
	where a.cod_relacion = p.proveedor 
  	  and a.cod_afp 		= :ls_cod_afp;

	//Calculo primero el porcentaje de Jubilacion
	ldc_importe = round(adc_remuneracion * ldc_porc_jubilac/100,2)
	if IsNull(ldc_importe) then ldc_importe = 0
	if ldc_importe = 0 then return 0

	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return 0

	dw_detail.object.flag_titulo_lbs	[ll_row] = '5'
	dw_detail.object.titulo				[ll_row] = 'DESCUENTO AFP: ' + ls_desc_afp
	dw_detail.object.DESC_detalle		[ll_row] = 'JUBILACION ' + string(ldc_porc_jubilac, '###,##0.00') + "% de " &
															+ string(adc_remuneracion, '###,##0.00')
	dw_detail.object.importe			[ll_row] = ldc_importe * -1
	dw_detail.object.proveedor			[ll_row] = ls_cod_relacion
	dw_detail.object.nom_proveedor	[ll_row] = ls_nom_proveedor

	ldc_afp += ldc_importe

	//Calculo primero el porcentaje de Invalidez
	ldc_importe = round(adc_remuneracion * ldc_porc_invalidez/100,2)

	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return 0

	dw_detail.object.flag_titulo_lbs	[ll_row] = '5'
	dw_detail.object.titulo				[ll_row] = 'DESCUENTO AFP: ' + ls_desc_afp
	dw_detail.object.DESC_detalle		[ll_row] = 'INVALIDEZ ' + string(ldc_porc_invalidez, '###,##0.00') + "% de " &
															+ string(adc_remuneracion, '###,##0.00')
	dw_detail.object.importe			[ll_row] = ldc_importe * -1
	dw_detail.object.proveedor			[ll_row] = ls_cod_relacion
	dw_detail.object.nom_proveedor	[ll_row] = ls_nom_proveedor

	ldc_afp += ldc_importe

	//Calculo primero el porcentaje de Comision
	ldc_importe = round(adc_remuneracion * ldc_porc_comision/100,2)

	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return 0

	dw_detail.object.flag_titulo_lbs	[ll_row] = '5'
	dw_detail.object.titulo				[ll_row] = 'DESCUENTO AFP: ' + ls_desc_afp
	dw_detail.object.DESC_detalle		[ll_row] = 'COMISION ' + string(ldc_porc_comision, '###,##0.00') + "% de " &
															+ string(adc_remuneracion, '###,##0.00')
	dw_detail.object.importe			[ll_row] = ldc_importe * -1
	dw_detail.object.proveedor			[ll_row] = ls_cod_relacion
	dw_detail.object.nom_proveedor	[ll_row] = ls_nom_proveedor

	ldc_afp += ldc_importe

	
end if

return ldc_afp


end event

event type decimal ue_prom_ultima_gratificacion(long al_row, decimal adc_remuneracion);string 	ls_codigo, ls_tipo_trabaj, ls_mensaje
decimal 	ldc_importe
date		ld_fecha, ld_fecha1, ld_fecha2, ld_fec_ult_gratif
long		ll_row, ll_count
Integer	li_dias

ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ls_tipo_trabaj = dw_master.object.tipo_trabajador 	[al_row]

if ls_tipo_trabaj = is_des or ls_tipo_trabaj = is_emp or ls_tipo_trabaj = is_fun or &
	ls_tipo_trabaj = is_ejo or ls_tipo_trabaj = is_jor then
	
	//Primero tengo que sacar las fechas desde el primer periodo al ultimo periodo
	if dw_periodos.RowCount() = 0 then
		MessageBox('Error', 'Debe especificar primero los periodos laborales')
		return 0.0
	end if
	
	ld_fecha1 = Date(dw_periodos.object.fec_inicio_periodo[1])
	ld_fecha2 = Date(dw_periodos.object.fec_final_periodo[1])
	
	for ll_row = 1 to dw_periodos.RowCount()
		if Date(dw_periodos.object.fec_inicio_periodo[ll_row]) < ld_fecha1 then
			ld_fecha1 = Date(dw_periodos.object.fec_inicio_periodo[ll_row])
		end if
		
		if Date(dw_periodos.object.fec_final_periodo[ll_row]) > ld_fecha2 then
			ld_fecha2 = Date(dw_periodos.object.fec_final_periodo[ll_row])
		end if
	next


	//Obteniendo la ultima gratificacion, la cual debe estar dentro del periodo
	select count(*)
		into :ll_count
	from historico_calculo hc
	where hc.cod_trabajador = :ls_codigo
	  and trunc(hc.fec_calc_plan) between :ld_Fecha1 and :ld_fecha2
	  and hc.concep in (select * 
	  							 from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTO_GRATI', '1483,1461,1462,1421,1471,1475'))));
	
	if ll_count = 100 then return 0
	
	select max(hc.fec_calc_plan) 
		into :ld_fec_ult_gratif
	from historico_calculo hc
	where hc.cod_trabajador = :ls_codigo
	  and trunc(hc.fec_calc_plan) between :ld_Fecha1 and :ld_fecha2
	  and hc.concep in (select * 
	  							 from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTO_GRATI', '1483,1461,1462,1421,1471,1475'))));
	
	
	
	
	select nvl(sum(hc.imp_soles),0)
		into :ldc_importe
	from historico_calculo hc
	where hc.cod_trabajador = :ls_codigo
	  and to_char(hc.fec_calc_plan, 'yyyymm') = to_char(:ld_fec_ult_gratif, 'yyyymm')
	  and hc.concep in (select * 
	  							 from table(split(PKG_CONFIG.USF_GET_PARAMETER('RRHH_CONCEPTO_GRATI', '1483,1461,1462,1421,1471,1475'))));
	
	
	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return -1
	
	dw_detail.object.flag_titulo_lbs	[ll_row] = '1'
	dw_detail.object.titulo				[ll_row] = 'REMUNERACION COMPUTABLE'
	dw_detail.object.DESC_detalle		[ll_row] = "PROMEDIO GRATIFICACION: " + string(ldc_importe, '###,##0.00') + " / 6 "
	
	ldc_importe = ldc_importe / 6
	dw_detail.object.importe			[ll_row] = ldc_importe 
	
end if

If IsNull(ldc_importe) or ldc_importe < 0 then ldc_importe = 0

return ldc_importe


end event

event type decimal ue_bonificacion(long al_row, decimal adc_gratif_trunca);string 	ls_tipo_trabaj, ls_codigo, ls_flag_reg_laboral
integer	li_mes, li_year, li_i, li_dias
date		ld_fecha1, ld_fecha2, ld_fecha, ld_fec_ingreso, ld_fec_cese
long		ll_row
decimal	ldc_importe

ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 		[al_row]
ls_codigo 				= dw_master.object.cod_trabajador 		[al_row]
ls_flag_reg_laboral	= dw_master.object.flag_reg_laboral 	[al_row]
ld_fec_cese				= date(dw_master.object.fec_salida 		[al_row])

if ls_flag_reg_laboral = '1' then
		
	select NVL(fact_pago, 0) * 100
	  into :idc_porc_bonif
	from concepto t
	where t.concep = :is_essalud_gen;
	
elseif ls_flag_reg_laboral = '3' then
	
	select NVL(fact_pago, 0) * 100
	  into :idc_porc_bonif
	from concepto t
	where t.concep = :is_essalud_agr;

else
	
	idc_porc_bonif = 0.00
	
end if
	

//Solo debo calcular gratificacion trunca para aquellos que lo tengan
//if ls_tipo_trabaj <> is_emp and ls_tipo_trabaj <> is_fun then return 0

//si no es 2009 o 2010 entonces retorno 0 porque no tiene bonificacion
//if Integer(string(ld_fec_cese, 'yyyy')) > 2014 then return 0

//calculo la bonificacion
ldc_importe = round(adc_gratif_trunca * idc_porc_bonif/100, 2)
if ldc_importe = 0 then return 0

ll_row = dw_detail.event ue_insert( )

if ll_row = 0 then return 0

dw_detail.object.flag_titulo_lbs	[ll_row] = '2'
dw_detail.object.titulo				[ll_row] = 'GRATIFICACION TRUNCA'
dw_detail.object.DESC_detalle		[ll_row] = 'BONIF. EXTRA. ' + string(idc_porc_bonif, '###,##0.00') + "% de " &
														+ string(adc_gratif_trunca, '###,##0.00')
														
dw_detail.object.importe			[ll_row] = ldc_importe

return ldc_importe
end event

event type decimal ue_descuentos_cta_cte(long al_row);string		ls_codigo
decimal		ldc_descuentos = 0, ldc_importe
integer		li_i
long			ll_row
u_ds_base  	lds_datos


ls_codigo = dw_master.object.cod_trabajador [al_row]
lds_datos = create u_ds_base
lds_datos.DataObject = 'd_cnta_crrte_tbl'
lds_datos.SetTransObject( SQLCA )
lds_datos.Retrieve(ls_codigo)

for li_i = 1 to lds_datos.RowCount()
	ldc_importe = Dec(lds_datos.object.sldo_prestamo[li_i])
	ll_row = dw_detail.event ue_insert( )
	if ll_row = 0 then return 0
	
	dw_detail.object.flag_titulo_lbs	[ll_row] = '6'
	dw_detail.object.titulo				[ll_row] = 'DESCUENTOS CNTA CORRIENTE'
	dw_detail.object.DESC_detalle		[ll_row] = lds_datos.object.desc_concepto[li_i]
	dw_detail.object.importe			[ll_row] = ldc_importe * -1
	dw_detail.object.proveedor			[ll_row] = lds_datos.object.cod_trabajador	[li_i]
	dw_detail.object.nom_proveedor	[ll_row] = lds_datos.object.nom_proveedor	[li_i]
	dw_detail.object.tipo_doc_cta_cte[ll_row] = lds_datos.object.tipo_doc			[li_i]
	dw_detail.object.nro_doc_cta_cte	[ll_row] = lds_datos.object.nro_doc			[li_i]

	ldc_descuentos += ldc_importe
next


destroy lds_datos

return ldc_descuentos
end event

event type decimal ue_descuento_quinta(long al_row);decimal 	ldc_uit, ldc_base_imponible, ldc_acu_externa, &
			ldc_acu_imprecisa, ldc_acu_retencion, ldc_acu_sueldo, ldc_ingresos, &
			ldc_imp_calculo, ldc_importe, ldc_retencion, ldc_tope_ini, ldc_tope_fin, &
			ldc_tasa

String 	ls_codigo, ls_grp_quinta_categ, ls_grp_ganan_imprec, &
			ls_grp_gratif_jul, ls_grp_gratif_dic, ls_flag_estado, &
			ls_cnc_ret_quinta, ls_tipo_trabaj
			
date		ld_fec_cese

Integer 	li_i
Long		ll_row

u_ds_base lds_datos


ls_codigo 		= dw_master.object.cod_trabajador	[al_row]
ld_fec_cese 	= date(dw_master.object.fec_salida	[al_row])


//Obtengo la UIT
SELECT importe
 INTO :ldc_uit
 FROM (SELECT t.importe
			FROM UIT T
		  WHERE TRUNC(FEC_INI_VIGEN) <= TRUNC(:ld_fec_cese)
		  ORDER BY t.ano DESC, t.fec_ini_vigen DESC)
WHERE ROWNUM = 1;

IF SQLCA.SQLCode = 100 then return 0


// Calculo de la base imponible, que vendría a ser 7 veces la UIT
ldc_base_imponible = ldc_UIT * 7

// Obtengo los parámetros necesarios para trabajar
select c.quinta_cat_proyecta, c.quinta_cat_imprecisa, c.grati_medio_ano, c.grati_fin_ano
 into :ls_grp_quinta_categ, :ls_grp_ganan_imprec, :ls_grp_gratif_jul, :ls_grp_gratif_dic
 from rrhhparam_cconcep c
 where c.reckey = '1' ;

// Obtengo el estado del concepto de Retención de Quinta Categoría
select con.flag_estado, con.concep
 into :ls_flag_estado, :ls_cnc_ret_quinta
 from concepto con
where con.concep in ( select g.concepto_gen
								from grupo_calculo g
							  where g.grupo_calculo = :ls_grp_quinta_categ) ;

if SQLCA.SQLCode = 100 then return 0

// Si el concepto está anulado entonces no tengo nada mas que hacer
if ls_flag_estado = '0'  then return 0

// Acumula importes a la fecha en el periodo
select NVL(SUM(q.rem_externa),0), NVL(SUM(q.rem_imprecisa),0), NVL(SUM(q.rem_retencion),0), 
		 NVL(SUM(q.sueldo),0)
  into :ldc_acu_externa, :ldc_acu_imprecisa, :ldc_acu_retencion, :ldc_acu_sueldo
  from quinta_categoria q
 where q.cod_trabajador = :ls_codigo
	and to_char(q.fec_proceso,'yyyy') = to_char(:ld_fec_cese,'yyyy') 
	AND trunc(q.fec_proceso) <= trunc(:ld_fec_cese);

ldc_ingresos = 0
//Sumo todas las ganancias de la liquidacion de beneficios
for li_i = 1 to dw_detail.RowCount( )
	if dw_detail.object.flag_titulo_lbs[li_i] = '2' or &
		dw_detail.object.flag_titulo_lbs[li_i] = '4' then
		
		ldc_ingresos += Dec(dw_detail.object.importe[li_i])
		
	end if
next

//Ahora calculo la retencion
ldc_imp_calculo = ldc_acu_externa + ldc_acu_imprecisa + ldc_acu_sueldo &
					 + ldc_ingresos
      
ldc_imp_calculo = ldc_imp_calculo - ldc_base_imponible 
      
if ldc_imp_calculo > 0 then
	ldc_importe = 0 
	ldc_retencion = 0 
	
	//DataStore para los topes de Renta de Quinta
	lds_datos = create u_ds_base
	lds_datos.Dataobject= 'd_topes_rta_quinta_tbl'
	lds_datos.SetTransobject( SQLCA )
	lds_datos.Retrieve( ld_Fec_cese )

	//  Calcula porcentaje a retener
	for li_i = 1 to lds_datos.RowCount()
		ldc_tope_ini = Dec(lds_datos.object.tope_ini	[li_i])
		ldc_tope_fin = Dec(lds_datos.object.tope_fin	[li_i])
		ldc_tasa 	 = Dec(lds_datos.object.tasa		[li_i])
		
		if ldc_imp_calculo <= ldc_tope_fin then
			  ldc_importe = ldc_imp_calculo - ldc_tope_ini
			  if ldc_importe > 0 then
				  ldc_importe   = ldc_importe * (ldc_tasa/100)  ;
				  ldc_retencion += ldc_importe
			  end if ;
		else
			  ldc_importe   = ldc_tope_fin - ldc_tope_ini
			  ldc_importe   = ldc_importe * (ldc_tasa / 100)  ;
			  ldc_retencion += ldc_importe
		end if 
	next 
	
	Destroy lds_datos

	//  Realiza retencion de quinta categoria del mes de proceso
	ldc_retencion = ldc_retencion - ldc_acu_retencion
	 
	if ldc_retencion > 0 then
		//  Inserta registros de descuento en la liquidacion
		ll_row = dw_detail.event ue_insert( )
		if ll_row = 0 then return 0

		dw_detail.object.flag_titulo_lbs	[ll_row] = '7'
		dw_detail.object.titulo				[ll_row] = 'DESCUENTO RENTA QUINTA ' 
		dw_detail.object.DESC_detalle		[ll_row] = 'BASE IMPONIBLE: ' &
																+ string(ldc_imp_calculo, '###,##0.00')
		dw_detail.object.importe			[ll_row] = ldc_retencion * -1
	
	 end if 
 end if 

return ldc_retencion
end event

event ue_preview();
//d_rpt_liquidacion_benef_tbl

// vista previa de mov. almacen
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

lstr_rep.dw1 		= 'd_rpt_liquidacion_benef_tbl'
lstr_rep.titulo 	= 'LIQUIDACION DE BENEFICIOS'
lstr_rep.string1 	= dw_master.object.NRO_OTR[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

event type decimal ue_dev_quinta(long al_row);string 	ls_codigo, ls_q = '2007', ls_tipo_trabaj
decimal 	ldc_importe, ldc_remuneracion
long		ll_row

ls_codigo 		= dw_master.object.cod_trabajador 	[al_row]
ls_tipo_trabaj 	= dw_master.object.tipo_trabajador 	[al_row]

//Haber Basico
if ls_tipo_trabaj = is_emp then
	
	//Obtengo los días laborados
		select sum(hc.imp_soles)
		into :ldc_importe
		from historico_calculo hc
		where hc.cod_trabajador = :ls_codigo
		 and hc.concep = :ls_q;

end if

ll_row = dw_detail.event ue_insert( )

if ll_row = 0 then return -1

dw_detail.object.flag_titulo_lbs	[ll_row] = '1'
dw_detail.object.titulo				[ll_row] = 'QUINTA CATEG'
dw_detail.object.DESC_detalle		[ll_row] = 'DEVOLUCIÓN DE QUINTA CATEGORIA'
dw_detail.object.importe			[ll_row] = ldc_importe

ldc_remuneracion += ldc_importe

return ldc_remuneracion
end event

event type decimal ue_essalud(long al_row, decimal adc_remuneracion);string 	ls_tipo_trabaj, ls_codigo, ls_flag_reg_laboral
integer	li_mes, li_year, li_i
long		ll_row
decimal	ldc_monto_essalud, ldc_porcentaje

ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 		[al_row]
ls_codigo 				= dw_master.object.cod_trabajador 		[al_row]
ls_flag_reg_laboral 	= dw_master.object.flag_reg_laboral 	[al_row]

if upper(gs_empresa) <> 'SEAFROST' then
	if ls_tipo_trabaj = is_des then return 0
end if

if adc_remuneracion > 0 then
	if ls_flag_reg_laboral = '1' then
		
		select NVL(fact_pago, 0)
		  into :ldc_porcentaje
		from concepto t
		where t.concep = :is_essalud_gen;
		
	elseif ls_flag_reg_laboral = '3' then
		
		select NVL(fact_pago, 0)
		  into :ldc_porcentaje
		from concepto t
		where t.concep = :is_essalud_agr;

	else
		
		ldc_porcentaje = 0.00
		
	end if
	
	ldc_monto_essalud = adc_remuneracion * ldc_porcentaje
else
	ldc_monto_essalud = 0
end if


ll_row = dw_detail.event ue_insert( )
if ll_row = 0 then return -1

dw_detail.object.flag_titulo_lbs	[ll_row] = '9'
dw_detail.object.titulo				[ll_row] = 'APORTACION ESSALUD'
dw_detail.object.DESC_detalle		[ll_row] = "ESSALUD"

dw_detail.object.importe			[ll_row] = ldc_monto_essalud

return ldc_monto_essalud
end event

public subroutine of_set_confin (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row);string ls_confin, ls_desc_confin

select cf.confin, cf.descripcion
	into :ls_confin, :ls_desc_confin
from confin_tipo_trabaj ctt,
     concepto_financiero  cf
where ctt.confin 					= cf.confin    
  and ctt.flag_concepto_lbs 	= :as_flag_concepto_lbs
  and ctt.tipo_trabajador 		= :as_tipo_trabajador
  and cf.flag_estado 			= '1';

if SQLCA.SQLCode = 100 then return

dw_detail.object.confin			[al_row] = ls_confin
dw_detail.object.desc_confin	[al_row] = ls_desc_confin
end subroutine

public function integer of_retrieve (string as_nro_liquidacion);event ue_update_request( )

dw_master.retrieve( as_nro_liquidacion )
dw_master.ResetUpdate()
dw_master.ii_update = 0

dw_detail.retrieve( as_nro_liquidacion )
dw_detail.ResetUpdate()
dw_detail.ii_update = 0

dw_periodos.retrieve( as_nro_liquidacion )
dw_periodos.ResetUpdate()
dw_periodos.ii_update = 0

is_action = 'open'
return 1
end function

public function boolean usp_gen_cnta_pagar_lbs ();String ls_nro_liquidacion, ls_mensaje

if dw_master.GetRow() = 0 then return true

ls_nro_liquidacion = dw_master.object.nro_liquidacion[dw_master.GetRow()]

//create or replace procedure USP_GEN_CNTA_PAGAR_LBS(
//       asi_nro_liquidacion    in liquidacion_benef.nro_liquidacion%TYPE,
//       asi_user               in usuario.cod_usr%TYPE
//) is

DECLARE USP_GEN_CNTA_PAGAR_LBS PROCEDURE FOR 
	USP_GEN_CNTA_PAGAR_LBS( :ls_nro_liquidacion, 
									:gs_user) ;
EXECUTE USP_GEN_CNTA_PAGAR_LBS ;

IF SQLCA.SQLCode = -1 THEN 
  ls_mensaje = SQLCA.SQLErrText

  rollback;
  MessageBox("Error en USP USP_GEN_CNTA_PAGAR_LBS", ls_mensaje, StopSign!)
  return false
end if

CLOSE USP_GEN_CNTA_PAGAR_LBS;

return true
end function

public subroutine of_set_cnta_prsp (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row);string ls_cnta_prsp

if not (as_flag_concepto_lbs = '2' or as_flag_concepto_lbs = '3' or &
	as_flag_concepto_lbs = '4' or as_flag_concepto_lbs = '9') then return

/****************************
// Solo deben Afectar Presupuesto
// 2 = Gratificacion
// 3 = CTS
// 4 = Vacaciones Truncas
*****************************/
select pc.cnta_prsp
	into :ls_cnta_prsp
from lbs_cnta_prsp_tipo_trabaj l,
     presupuesto_cuenta pc
where l.cnta_prsp 			= pc.cnta_prsp
  and l.flag_concepto_lbs 	= :as_flag_concepto_lbs
  and l.tipo_trabajador 	= :as_tipo_trabajador
  and pc.flag_estado 		= '1';

if SQLCA.SQLCode = 100 then 
	SetNull(ls_cnta_prsp)
end if

dw_detail.object.cnta_prsp		[al_row] = ls_cnta_prsp

end subroutine

public subroutine of_modify_dws ();String ls_mensaje
ls_mensaje = dw_detail.Modify("confin.protect='1~tif(flag_titulo_lbs=~~'1~~', 1, 0)'")

IF ls_mensaje <> "" THEN
        MessageBox("Status", &
            "Fallo Modify en dw_detail, mensaje de Error: " + ls_mensaje)
        RETURN
END IF
end subroutine

public function boolean of_set_numera_str (ref string as_ult_nro);Long 		ll_ult_nro, ll_count


SELECT count(*)
  INTO :ll_count
  FROM num_liquidacion_benef
 WHERE (origen = :gs_origen);


if ll_count = 0 then
	insert into num_liquidacion_benef(origen, ult_nro)
	values(:gs_origen, 1);
	
	if gnvo_app.of_existserror( SQLCA, 'Insert num_liquidacion_benef') then return false
end if

SELECT ult_nro
  INTO :ll_ult_nro
  FROM num_liquidacion_benef
 WHERE (origen = :gs_origen) for update;

  
UPDATE num_liquidacion_benef
	SET ult_nro = :ll_ult_nro + 1
 WHERE (origen = :gs_origen);
 
if gnvo_app.of_existserror(SQLCA, 'UPDATE num_liquidacion_benef') then return false
 
as_ult_nro  = gs_origen + string(ll_ult_nro, '00000000')

Return true
end function

public subroutine of_set_concepto_plame (string as_flag_concepto_lbs, string as_tipo_trabajador, long al_row);string ls_concepto


/****************************
// Solo deben Afectar Presupuesto
// 2 = Gratificacion
// 3 = CTS
// 4 = Vacaciones Truncas
*****************************/
select l.cod_concepto_rtps
	into :ls_concepto
from lbs_cnta_prsp_tipo_trabaj l
where l.flag_concepto_lbs 	= :as_flag_concepto_lbs
  and l.tipo_trabajador 	= :as_tipo_trabajador;

if SQLCA.SQLCode = 100 then 
	SetNull(ls_concepto)
end if

dw_detail.object.concepto_rtps		[al_row] = ls_concepto

end subroutine

on w_rh415_liquidacion_benef.create
int iCurrent
call super::create
if this.MenuName = "m_master_cl_anular" then this.MenuID = create m_master_cl_anular
this.dw_periodos=create dw_periodos
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_periodos
end on

on w_rh415_liquidacion_benef.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_periodos)
end on

event resize;//Overriding
dw_periodos.width  = newwidth  - dw_periodos.x - 10
dw_detail.width  = newwidth  - dw_detail.x - 10
dw_detail.height = newheight - dw_detail.y - 10
end event

event ue_open_pre;call super::ue_open_pre;

try 

	ii_lec_mst = 0   //hace que no se haga el retrieve del dw_master
	
	dw_periodos.SetTransObject(sqlca)
	
	//Parametros de prov_SUNAT
	select r.prov_sunat
		into :is_prov_SUNAT
	from rrhhparam_cconcep r
	where reckey = '1';
	
	select fact_pago * 100
	  into :idc_porc_bonif
	 from concepto c
	 where c.concep = (select cnc_essalud from asistparam);
	
	is_ONP 			= gnvo_app.of_get_parametro("CODIGO_ONP", "E0002220")
	is_essalud_gen = gnvo_app.of_get_parametro("RRHH_CNC_ESSALUD_REG_GENERAL", "3001")
	is_essalud_agr = gnvo_app.of_get_parametro("RRHH_CNC_ESSALUD_REG_AGRICO", "3012")
	is_grp_var_lbs = gnvo_app.of_get_parametro("RRHH_GRUPO_REMUN_COMPUTABLE", "806")
	
	invo_maestro = create n_cst_maestro
	
	

catch ( exception ex )
	gnvo_app.of_catch_exception(ex, '')
end try
end event

event ue_insert;//Overriding
Long  ll_row
String ls_flag_titulo_lbs, ls_titulo
str_parametros lstr_parametros

IF idw_1 = dw_periodos THEN
	MessageBox("Error", "No esta permitido adiciones en este panel")
	RETURN
END IF

if idw_1 = dw_master then
	this.event ue_update_request( )
	
	dw_detail.Reset()
	dw_periodos.Reset()
	dw_master.Reset()
	
elseif idw_1 = dw_detail then
	
	lstr_parametros.titulo = 'Seleccione el item para la Liquidacion de Beneficios'
	lstr_parametros.String1 = '8'
	lstr_parametros.String2 = '8 - OTROS INGRESOS / DESCUENTOS'
	
	OpenWithParm(w_prompt_lbs, lstr_parametros)
	lstr_parametros = Message.PowerObjectParm
	if lstr_parametros.i_return < 0 then return 
	
	ls_flag_titulo_lbs = left(lstr_parametros.string1,1)
	ls_titulo		 	 = trim(lstr_parametros.string2)


end if


ll_row = idw_1.Event ue_insert()
IF ll_row <> -1 THEN
	if idw_1 = dw_detail then
		idw_1.object.flag_titulo_lbs	[ll_row] = ls_flag_titulo_lbs
		idw_1.object.titulo				[ll_row] = ls_titulo
		
		idw_1.Sort()
		idw_1.GroupCalc()

	end if
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

event ue_update_request;//Overriding
Integer li_msg_result

// Revisa si hay actualizaciones pendientes y pregunta si se quiere actualizar
IF (dw_master.ii_update = 1 OR dw_detail.ii_update = 1 OR dw_periodos.ii_update = 1) THEN
	li_msg_result = MessageBox("Actualizaciones Pendientes", "Grabamos", Question!, YesNo!, 1)
	IF li_msg_result = 1 THEN
 		this.TriggerEvent("ue_update")
	ELSE
		dw_master.ii_update = 0
		dw_detail.ii_update = 0
		dw_periodos.ii_update = 0
	END IF
END IF

end event

event ue_update_pre;call super::ue_update_pre;String 	ls_nro_lbs
long		ll_i

ib_update_check = False	

IF dw_master.Rowcount() = 0 THEN
	Messagebox('Aviso','Debe Ingresar Registro en la Cabecera')
	Return
END IF

IF dw_detail.Rowcount() = 0 THEN
	Messagebox('Aviso','Documento de Liquidacion debe tener detalle')
	Return
END IF

IF dw_periodos.Rowcount() = 0 THEN
	Messagebox('Aviso','Liquidacion debe tener periodos')
	Return
END IF


IF gnvo_app.of_row_Processing( dw_master ) <> true then return
IF gnvo_app.of_row_Processing( dw_detail ) <> true then return
IF gnvo_app.of_row_Processing( dw_periodos ) <> true then return

//Validando los conceptos financieros
for ll_i = 1 to dw_detail.Rowcount( )
	if dw_detail.object.flag_titulo_lbs[ll_i] <> '1' then
		
		//Valido si tiene el concepto Financiero
		if IsNull(dw_detail.object.confin[ll_i]) or (dw_detail.object.confin[ll_i]) = '' then
			f_mensaje("No ha indicado un confin para el registro en la Liquidacion de Beneficios Sociales,por favor verifique", '')
			dw_detail.SetFocus()
			dw_detail.SetColumn("confin")
			return 
		end if
		
		//Valido si tiene el concepto PLAME
		if IsNull(dw_detail.object.concepto_rtps[ll_i]) or (dw_detail.object.concepto_rtps[ll_i]) = '' then
			f_mensaje("No ha indicado un CONCEPTO DE PLAME en la Liquidacion de Beneficios Sociales,por favor verifique", '')
			dw_detail.SetFocus()
			dw_detail.SetColumn("concepto_rtps")
			return 
		end if
	end if
	
	
	
next


ls_nro_lbs = dw_master.object.nro_liquidacion [dw_master.GetRow()]

if is_action = 'new' or ISNull(ls_nro_lbs) or ls_nro_lbs = '' then
	if not this.of_set_numera_str( ls_nro_lbs ) then return
	
	dw_master.object.nro_liquidacion [dw_master.GetRow()]= ls_nro_lbs
	
else
	ls_nro_lbs = dw_master.object.nro_liquidacion [dw_master.GetRow()]
end if


for ll_i = 1 to dw_periodos.Rowcount( )
	dw_periodos.object.nro_liquidacion[ll_i] = ls_nro_lbs
next

for ll_i = 1 to dw_detail.Rowcount( )
	dw_detail.object.nro_liquidacion[ll_i] = ls_nro_lbs
next


ib_update_check = True

end event

event ue_modify;//Overriding

if dw_master.object.flag_estado[dw_master.getRow()] = '2' then
	MessageBox('Error', 'No se puede modificar esta liquidación porque ya ha generado asiento contable')
	dw_detail.ii_protect = 0
	dw_detail.of_protect()
	
	dw_master.ii_protect = 0
	dw_master.of_protect()
	return
end if

if is_action = 'open' then
	is_action = 'edit'
end if

dw_master.of_protect()
dw_detail.of_protect()

if dw_detail.ii_protect = 0 then
	of_modify_dws()
end if
end event

event ue_update;//Overriding
Boolean lbo_ok = TRUE
String	ls_msg, ls_crlf, ls_nro_liquidacion

if dw_master.ii_update = 0 and dw_detail.ii_update = 0 and dw_periodos.ii_update = 0 then return

if dw_master.GetRow() = 0 then return

ls_crlf = char(13) + char(10)
dw_master.AcceptText()
dw_detail.AcceptText()
dw_periodos.AcceptText( )

THIS.EVENT ue_update_pre()
IF ib_update_check = FALSE THEN RETURN

IF ib_log THEN
	dw_master.of_create_log()
	dw_detail.of_create_log()
	dw_periodos.of_create_log()
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

IF dw_periodos.ii_update = 1 AND lbo_ok = TRUE THEN
	IF dw_periodos.Update(true, false) = -1 then		// Grabacion del detalle
		lbo_ok = FALSE
		ROLLBACK USING SQLCA;
		ls_msg = "Se ha procedido al rollback"
		messagebox("Error en Grabacion dw_periodos", ls_msg, StopSign!)
	END IF
END IF

IF ib_log THEN
	IF lbo_ok THEN
		lbo_ok = dw_master.of_save_log()
		lbo_ok = dw_detail.of_save_log()
		lbo_ok = dw_periodos.of_save_log()
	END IF
END IF

IF lbo_ok THEN
	if not this.USP_GEN_CNTA_PAGAR_LBS( ) then 
		ROLLBACK;
		return
	end if
	
	COMMIT using SQLCA;
	dw_master.ii_update = 0
	dw_detail.ii_update = 0
	dw_master.il_totdel = 0
	dw_detail.il_totdel = 0
	
	dw_periodos.ii_update = 0
	dw_periodos.il_totdel = 0
	
	dw_master.ResetUpdate()
	dw_detail.ResetUpdate()
	dw_periodos.ResetUpdate()
	
	ls_nro_liquidacion = dw_master.object.nro_liquidacion[dw_master.GetRow()]
	
	of_retrieve( ls_nro_liquidacion )
	
	f_mensaje("Grabación realizada satisfactoriamente", "")
END IF

end event

event ue_open_pos;//Overriding

end event

event ue_retrieve_list;// Abre ventana pop
str_parametros sl_param
String ls_tipo_mov

sl_param.dw1    = 'd_list_liquidacion_benef_tbl'
sl_param.titulo = 'Liquidación de Beneficios Sociales'
sl_param.field_ret_i[1] = 1

OpenWithParm( w_lista, sl_param)
sl_param = MESSAGE.POWEROBJECTPARM
if sl_param.titulo <> 'n' then
	of_retrieve(sl_param.field_ret[1])
END IF
end event

event ue_anular;call super::ue_anular;integer li_i
if dw_master.GetRow() = 0 then return

if is_action <> 'open' then
	MessageBox('Error', 'no se puede Anular documento, ya que esta en proceso de ingreso, en tal caso cierre sin grabar')
	return
end if

if dw_master.object.flag_estado[dw_master.GetRow()] <> '1' then 
	MessageBox('Error', 'no se puede Anular documento, ya que no se encuentra activo')
	return
end if

if messageBox('Informacion', 'Desea anular el documento?', Information!, Yesno!, 2) = 2 then return

dw_master.object.flag_estado [dw_master.GetRow()] = '0'
dw_master.ii_update = 1

for li_i = 1 to dw_detail.RowCount()
	dw_detail.object.flag_estado[li_i] = '0'
	dw_detail.ii_update = 1
next

is_action = 'anular'
end event

event ue_print;call super::ue_print;//d_rpt_liquidacion_benef_tbl

// vista previa de mov. almacen
str_parametros lstr_rep

if dw_master.rowcount() = 0 then return

if gs_empresa = 'ARCOPA' then
	lstr_rep.dw1 		= 'd_rpt_liquidacion_benef_arcopa_tbl'
elseif gs_empresa = 'SEAFROST' then
	lstr_rep.dw1 		= 'd_rpt_liquidacion_benef_seafrost_tbl'	
else
	lstr_rep.dw1 		= 'd_rpt_liquidacion_benef_tbl'
end if

lstr_rep.titulo 	= 'LIQUIDACION DE BENEFICIOS'
lstr_rep.string1 	= dw_master.object.nro_liquidacion[dw_master.getrow()]
lstr_rep.tipo		= '1S'

OpenSheetWithParm(w_rpt_preview, lstr_rep, w_main, 0, Layered!)
end event

event close;call super::close;destroy invo_maestro
end event

type dw_master from w_abc_mastdet_smpl`dw_master within w_rh415_liquidacion_benef
integer x = 0
integer y = 0
integer width = 2958
integer height = 1068
string dataobject = "d_abc_lbs_cab_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen 		[al_row] = gs_origen
this.object.flag_estado		[al_row] = '1'
this.object.fec_salida		[al_row] = date(gnvo_app.of_fecha_actual())
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_actual()
this.object.fec_proceso		[al_row] = Date(gnvo_app.of_fecha_actual())
this.object.cod_usr			[al_row] = gs_user

is_action = 'new'
end event

event dw_master::constructor;call super::constructor;is_dwform = 'form'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_display;call super::ue_display;string 	ls_codigo, ls_data, ls_sql, ls_data2, ls_cargo, &
			ls_desc_cargo, ls_tipo_trabaj, ls_cod_afp, ls_flag_reg_laboral

choose case lower(as_columna)
	case "cod_trabajador"
		if dw_detail.RowCount() > 0 then
			MessageBox('Error', 'No puede elegir un trabajador si la liquidacion tiene detalle')
			return
		end if
		
		ls_sql = "select distinct m.cod_trabajador as codigo_trabajador, " &
				 + "       m.nom_trabajador as nombre_trabajador, " &
				 + "       to_char(m.fec_ingreso, 'yyyy/mm/dd') as fec_ingreso " &
				 + "from vw_pr_trabajador m, " &
				 + "     rrhh_periodos_laborales_rtps r " &
				 + "where r.cod_trabajador = m.cod_trabajador " &
				 + "  and m.flag_estado = '1' " &
				 + "  and m.flag_cal_plnlla = '1' " &
				 + "  and r.flag_liquidacion = '0' " &
				 + "order by m.cod_trabajador "

		if gnvo_App.of_lista(ls_sql, ls_codigo, ls_data, ls_data2, '2') then
			
			//Obtengo el cargo
			select 	m.cod_cargo, c.desc_cargo, m.tipo_trabajador, m.cod_afp, 
						m.cencos, m.flag_reg_laboral
				into 	:ls_cargo, :ls_desc_cargo, :ls_tipo_trabaj, :ls_cod_afp, 
						:is_cencos, :ls_flag_reg_laboral
			from maestro m,
				  cargo c
			where m.cod_cargo = c.cod_cargo
			  and m.cod_trabajador = :ls_codigo;
			
			this.object.cod_trabajador		[al_row] = ls_codigo
			this.object.nom_trabajador		[al_row] = ls_data
			this.object.fec_ingreso			[al_row] = date(ls_data2)
			this.object.cod_afp				[al_row] = ls_cod_afp
			this.object.flag_reg_laboral	[al_row] = ls_flag_reg_laboral
			
			//Adiciones necesarias
			this.object.tipo_trabajador[al_row] = ls_tipo_trabaj
			this.object.cod_cargo		[al_row] = ls_cargo
			this.object.desc_cargo		[al_row] = ls_desc_cargo
			
			//Obtengo la cnta prsp del tipo de trabajador
			select cnta_prsp_lbs
			  into :is_cnta_prsp
			  from tipo_trabajador
			 where tipo_trabajador = :ls_tipo_trabaj;
			
			this.ii_update = 1
		end if
		
	case "cod_tipo_extincion"
		ls_sql = "select t.cod_tipo_extincion as tipo_extincion, " &
				 + "t.descripcion as descripcion_tipo_extincion " &
				 + "from rrhh_tipo_ext_cont_rtps t " &
				 + "where t.flag_estado = '1'" 

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.cod_tipo_extincion		[al_row] = ls_codigo
			this.object.desc_tipo_extincion		[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "tipo_renuncia"
		ls_sql = "select tipo_renuncia as tipo_renuncia, " &
				 + "desc_tipo_renuncia as descripcion_tipo_renuncia " &
				 + "from lbs_tipo_renuncia " &
				 + "where flag_estado = '1'"

		if gnvo_app.of_lista(ls_sql, ls_codigo, ls_data, '2') then
			this.object.tipo_renuncia			[al_row] = ls_codigo
			this.object.desc_tipo_renuncia	[al_row] = ls_data
			this.ii_update = 1
		end if

end choose
end event

event dw_master::buttonclicked;call super::buttonclicked;boolean lb_ret
string ls_codigo
str_parametros	lstr_param

this.AcceptText()

choose case lower(dwo.name)
	case "b_periodos"
		if is_action <> 'new' then
			MessageBox('Error', 'Solo se puede seleccionar periodos a una nueva liquidación')
			return
		end if
		
		ls_codigo = this.object.cod_trabajador[row]
		
		if IsNull(ls_codigo) or ls_codigo = '' then
			MessageBox('Error', 'debe ingresar un codigo de trabajador')
			this.SetColumn('cod_trabajador')
			return
		end if
		
		
		lstr_param.tipo	 = '1S'
		lstr_param.opcion	 = 1         //Ordenes de Compra
		lstr_param.titulo  = 'Periodos Laborales'
		lstr_param.dw1		 = 'd_list_periodos_laborales_tbl'
		lstr_param.dw_m	 = dw_master
		lstr_param.dw_d	 = dw_periodos
		lstr_param.string1 = ls_codigo

		OpenWithParm( w_abc_seleccion, lstr_param)

	case "b_generar"
		if dw_periodos.RowCount() = 0 then
			MessageBox('Error', 'Debe seleccionar primero algun periodo laboral')
			return
		end if
		
		if is_action <> 'new' then
			MessageBox('Error', 'Solo se puede generar una nueva liquidación')
			return
		end if
		
		if not gnvo_app.of_row_processing(dw_master) then 
			dw_master.setFocus( )
			return
		end if
		
		parent.event ue_generar_liquidacion( row )
		
end choose
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

type dw_detail from w_abc_mastdet_smpl`dw_detail within w_rh415_liquidacion_benef
integer x = 0
integer y = 1084
integer width = 3877
integer height = 960
string dataobject = "d_abc_lbs_det_tbl"
end type

event dw_detail::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_detail::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item 			[al_row] = f_numera_item(this)
//this.object.flag_titulo_lbs	[al_row] = '8'
//this.object.titulo				[al_row] = 'OTROS INGRESOS / DESCUENTOS'
this.object.flag_estado			[al_row] = '1'

//Presupuestal
this.object.cencos				[al_row] = is_cencos
//this.object.cnta_prsp			[al_row] = is_cnta_prsp

of_modify_dws()


end event

event dw_detail::getfocus;call super::getfocus;if not f_row_processing(dw_master, dw_master.is_dwform) then dw_master.setFocus( )

idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

event dw_detail::ue_display;call super::ue_display;boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_flag_concepto_lbs, &
			ls_tipo_trabaj, ls_cencos

date 		ld_fec_cese
integer 	li_year
str_parametros	lstr_parametros

choose case lower(as_columna)
	case "nro_item"
		
		lstr_parametros.titulo = 'Seleccione el item para la Liquidacion de Beneficios'
		lstr_parametros.String1 = this.object.flag_titulo_lbs [al_row]
		lstr_parametros.String2 = this.object.titulo 			[al_row]
	
		OpenWithParm(w_prompt_lbs, lstr_parametros)
		lstr_parametros = Message.PowerObjectParm
		if lstr_parametros.i_return < 0 then return 
	
		this.object.flag_titulo_lbs	[al_row] = left(lstr_parametros.string1,1)
		this.object.titulo 				[al_row] = trim(lstr_parametros.string2)
		
		this.ii_update = 1
		this.Sort()
		this.GroupCalc()

	case "proveedor"
		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
				  + "nom_proveedor AS nombre_proveedor, " &
				  + "RUC as RUC_PROVEEDOR " &
				  + "FROM proveedor " &
				  + "WHERE FLAG_ESTADO = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.proveedor		[al_row] = ls_codigo
			this.object.nom_proveedor	[al_row] = ls_data
			this.ii_update = 1
		end if
		
	case "concepto_rtps"
		ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 	[dw_master.GetRow()]
		ls_flag_concepto_lbs = this.object.flag_titulo_lbs			[al_row]
		
		if IsNull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then
			MessageBox("Error", "Debe Seleccionar un tipo de trabajador valido, por favor corrija", StopSign!)
			return
		end if
		
		ls_sql = "select distinct " &
				 + "       r.cod_concepto_rtps as codigo_concepto, " &
				 + "		  r.desc_concepto_rtps as descripcion_concepto " &
				 + "from lbs_cnta_prsp_tipo_trabaj t, " &
				 + "     rrhh_conceptos_rtps       r " &
				 + "where t.cod_concepto_rtps = r.cod_concepto_rtps " &
				 + "  and t.tipo_trabajador   = '" + ls_tipo_trabaj + "' " &
				 + "  and t.flag_concepto_lbs = '" + ls_flag_concepto_lbs + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.concepto_rtps		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "confin"
		
		ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 	[dw_master.GetRow()]
		ls_flag_concepto_lbs = this.object.flag_titulo_lbs			[al_row]
		
		if IsNull(ls_tipo_trabaj) or trim(ls_tipo_trabaj) = '' then
			MessageBox("Error", "Debe Seleccionar un tipo de trabajador valido, por favor corrija", StopSign!)
			return
		end if
		
		ls_sql = "select cf.confin as confin, " &
				 + "       cf.descripcion as desc_confin " &
				 + "from confin_tipo_trabaj  ctt, " &
				 + "     tipo_trabajador     tt, " &
				 + "     concepto_financiero cf " &
				 + "where ctt.tipo_trabajador = tt.tipo_trabajador " &
				 + "  and ctt.confin          = cf.confin "&
				 + "  and cf.flag_estado 		= '1' " &
				 + "  and ctt.tipo_trabajador = '" + ls_tipo_trabaj + "' " &
				 + "  and ctt.flag_concepto_lbs = '" + ls_flag_concepto_lbs + "'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.confin		[al_row] = ls_codigo
			this.object.desc_confin	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cencos"
		
		ld_fec_cese = Date(dw_master.Object.fec_salida[dw_master.GetRow()])
		li_year = year(ld_fec_cese)
		
		ls_sql = "select distinct cc.cencos as codigo_Cencos, " &
				  + "cc.desc_cencos as descripcion_cencos " &
				  + "from centros_costo cc, " &
				  + "     presupuesto_partida pp " &
				  + "where cc.cencos = pp.cencos " &
				  + "  and pp.flag_estado <> '0' " &
				  + "  and pp.ano = " + string(li_year) &
				  + " order by 2"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cencos		[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "cnta_prsp"
		
		ld_fec_cese 			= Date(dw_master.Object.fec_salida[dw_master.GetRow()])
		li_year 					= year(ld_fec_cese)
		ls_cencos 				= this.object.cencos[al_row]
		ls_tipo_trabaj 		= dw_master.object.tipo_trabajador 	[dw_master.GetRow()]
		ls_flag_concepto_lbs = this.object.flag_titulo_lbs			[al_row]

		
		if ls_cencos = '' or IsNull(ls_cencos) then
			MessageBox('Error', 'Debe ingresar un centro de costos')
			this.SetColumn('cencos')
			return
		end if
		
		ls_sql = "select distinct pc.cnta_prsp as cnta_prsp, " &
				 + "pc.descripcion as descripcion_cnta_prsp " &
				 + "from presupuesto_cuenta pc, " &
				 + "     presupuesto_partida pp, " &
				 + "     lbs_cnta_prsp_tipo_trabaj l " & 
				 + "where pc.cnta_prsp = pp.cnta_prsp " &
				 + "  and l.cnta_prsp  = pc.cnta_prsp " &
				 + "  and l.tipo_trabajador = '" + ls_tipo_trabaj + "' " &
				 + "  and l.flag_concepto_lbs = '" + ls_flag_concepto_lbs + "' " &
				 + "  and pp.flag_estado <> '0' " &
				 + "  and pp.cencos = '" + ls_cencos + "' " &
				 + "  and pp.ano = " + string(li_year) & 
				  + " order by 2"
		
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')

		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose
end event

event dw_detail::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

THIS.AcceptText()

ls_string = this.Describe(lower(dwo.name) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return
else
 	if ls_string = '1' then return
end if

IF row > 0 THEN
	ls_columna = upper(dwo.name)
	THIS.event dynamic ue_display(ls_columna, row)
END IF
end event

event dw_detail::ue_delete_pos;call super::ue_delete_pos;this.Sort()
this.GroupCalc()
end event

type dw_periodos from u_dw_abc within w_rh415_liquidacion_benef
integer x = 2971
integer width = 1705
integer height = 1068
integer taborder = 20
boolean bringtotop = true
string dataobject = "d_abc_lbs_periodos_tbl"
borderstyle borderstyle = styleraised!
end type

event constructor;call super::constructor;is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
ii_ck[3] = 3				// columnas de lectrua de este dw

ii_rk[1] = 1 	      // columnas que recibimos del master

//ii_dk[1] = 1 	      // columnas que se pasan al detalle

idw_mst  = 	dw_master
//idw_det  =  				// dw_detail
end event

event getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = THIS
idw_1.BorderStyle = StyleLowered!
end event

