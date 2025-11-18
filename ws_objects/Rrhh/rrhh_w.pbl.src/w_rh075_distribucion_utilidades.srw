$PBExportHeader$w_rh075_distribucion_utilidades.srw
forward
global type w_rh075_distribucion_utilidades from w_abc_master_smpl
end type
end forward

global type w_rh075_distribucion_utilidades from w_abc_master_smpl
integer width = 3643
integer height = 1484
string title = "(RH075) Distribución de Utilidades"
string menuname = "m_master_simple"
end type
global w_rh075_distribucion_utilidades w_rh075_distribucion_utilidades

type variables

end variables

on w_rh075_distribucion_utilidades.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh075_distribucion_utilidades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;string ls_protect
ls_protect=dw_master.Describe("periodo.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('periodo')
END IF
end event

event ue_update_pre;call super::ue_update_pre;decimal 	ldc_utilidad_neta, ldc_porc_distribucion, ldc_porc_dias, ldc_porc_remun, ldc_total_remun
String	ls_flag_estado
integer  li_row, li_periodo

ib_update_check = false

for li_row = 1 to dw_master.RowCount()
	
	ls_flag_estado = dw_master.object.flag_estado[li_row]
	
	if ls_flag_estado = '1' then
	
		li_periodo = Integer(dw_master.object.periodo[li_row])
		
		If isnull(li_periodo) or li_periodo = 0 Then
			Messagebox("Aviso","Debe ingresar el periodo", StopSign!)
			dw_master.SetColumn("periodo")
			dw_master.SetFocus()
			return
		End if	
	
		ldc_utilidad_neta = Dec(dw_master.object.utilidad_neta [li_row])
		If isnull(ldc_utilidad_neta) or ldc_utilidad_neta = 0.00 Then
			Messagebox("Aviso","Debe ingresar la utilidad neta del periodo", StopSign!)
			dw_master.SetColumn("utilidad_neta")
			dw_master.SetFocus()
			return
		End if	
	
		ldc_porc_distribucion = Dec(dw_master.object.porc_distribucion[li_row])
		If isnull(ldc_porc_distribucion) or ldc_porc_distribucion = 0.00 Then
			Messagebox("Aviso","Debe ingresar porcentaje a distribuir de la renta neta", StopSign!)
			dw_master.SetColumn("porc_distribucion")
			dw_master.SetFocus()
			return
		End if	
	
		ldc_porc_dias = Dec(dw_master.object.porc_dias_laborados[li_row])
		If isnull(ldc_porc_dias) or ldc_porc_dias = 0.00 Then
			Messagebox("Aviso","Debe ingresar porcentaje a distribuir por los días efectivos", StopSign!)
			dw_master.SetColumn("porc_dias_laborados")
			dw_master.SetFocus()
			return
		End if	
	
		ldc_porc_remun = Dec(dw_master.object.porc_remuneracion[li_row])
		If isnull(ldc_porc_remun) or ldc_porc_remun = 0.00 Then
			Messagebox("Aviso","Debe ingresar porcentaje a distribuir por las remuneraciones", StopSign!)
			dw_master.SetColumn("porc_remuneracion")
			dw_master.SetFocus()
			return
		End if	
		
		//Obtengo el total de remuneraciones
		select nvl(sum(hc.imp_soles), 0)
			into :ldc_total_remun
		from historico_calculo hc,
			  grupo_calculo_det gcd
		where hc.concep = gcd.concepto_calc
		  and to_number(to_char(hc.fec_calc_plan, 'yyyy')) = :li_periodo
		  and gcd.grupo_calculo = :gnvo_app.rrhhparam.is_grp_utilidad;
		  
		
		dw_master.object.tot_remun_ejer [li_row] = ldc_total_remun
		
	end if

next

ib_update_check = true

dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh075_distribucion_utilidades
integer width = 3479
integer height = 1144
string dataobject = "d_distribucion_utilidades_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.Modify("periodo.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("renta_neta.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("porc_distribucion.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("porc_dias_laborados.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("porc_remuneracion.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("tot_remun_ejer.Protect='1~tIf(IsRowNew(),0,1)'")
this.Modify("tot_dias_ejer.Protect='1~tIf(IsRowNew(),0,1)'")

this.object.flag_estado				[al_row] = '1'
this.object.factor_asistencia		[al_row] = 0.00
this.object.factor_remuneracion	[al_row] = 0.00


end event

event dw_master::itemchanged;call super::itemchanged;String  		ls_null 
Decimal 		ldc_porc_renumeracion, ldc_porc_dias_laborados, ldc_porc_distribucion, ldc_utilidad_neta, &
				ldc_renta_neta
Date			ld_fecha_ini, ld_fecha_fin

IF this.ii_protect = 1 OR row = 0 THEN RETURN

this.AcceptText()

CHOOSE CASE lower(dwo.name)
	CASE 'porc_distribucion'
		ldc_porc_distribucion 	= Dec(this.object.porc_distribucion	[row])
		ldc_renta_neta				= Dec(this.object.renta_neta			[row])
		
		if IsNull(ldc_renta_neta) or ldc_renta_neta = 0 then
			this.object.utilidad_neta [row] = 0
			MessageBox('Error', 'Debe ingresar una renta neta, por favor verifique!', StopSign!)
			this.setColumn("renta_neta")
			return 1
		end if
		
		if IsNull(ldc_porc_distribucion) or ldc_porc_distribucion = 0 then
			this.object.porc_distribucion [row] = 0.00
			this.object.utilidad_neta 		[row] = 0.00
			MessageBox('Error', 'Debe ingresar el porcentaje de la renta neta, por favor verifique!', StopSign!)
			this.setColumn("porc_distribucion")
			return 1
		end if

		ldc_utilidad_neta = ldc_renta_neta * ldc_porc_distribucion / 100
		this.object.utilidad_neta [row] = ldc_utilidad_neta
		
		this.ii_update = 1

	CASE 'porc_remuneracion'
		ldc_porc_renumeracion = Dec(this.object.porc_remuneracion[row])
		ldc_porc_dias_laborados = 100 - ldc_porc_renumeracion 
		
		this.object.porc_dias_laborados[row] = ldc_porc_dias_laborados
		this.ii_update = 1

	CASE 'fecha_ini', 'fecha_fin'
		
		ld_fecha_ini = Date(this.object.fecha_ini [row])
		ld_fecha_fin = Date(this.object.fecha_fin [row])
		
		this.object.dias_periodo [row] = DaysAfter(ld_fecha_ini, ld_fecha_fin) + 1
		
		this.ii_update = 1
END CHOOSE

end event

event dw_master::buttonclicked;call super::buttonclicked;Long		ll_periodo, ll_item
String	ls_mensaje

if row = 0 then return

if lower(dwo.name) = 'b_procesar' then
	
	ll_periodo 	= Long(this.object.periodo [row])
	ll_item		= Long(this.object.item 	[row])
	
	DECLARE usp_calcula_utilidad PROCEDURE FOR 
		  pkg_rrhh.usp_calcula_utilidad(	:ll_periodo,
                                			:ll_item);
										  
	EXECUTE usp_calcula_utilidad ;
	
	IF SQLCA.SQLCode = -1 THEN 
		ls_mensaje = SQLCA.SQLErrText
		rollback ;
		MessageBox('Error', 'Ha ocurrido un error al ejecutar el procedimiento pkg_rrhh.usp_calcula_utilidad(). Mensaje: ' + ls_mensaje, StopSign!)
		return
	end if
	
	commit ;
	
	
	close usp_calcula_utilidad;
	
	MessageBox("Atención","Proceso ha Concluído Satisfactoriamente", Exclamation!)
	
end if
end event

