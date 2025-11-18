$PBExportHeader$w_rh074_parametros_utilidades.srw
forward
global type w_rh074_parametros_utilidades from w_abc_master_smpl
end type
end forward

global type w_rh074_parametros_utilidades from w_abc_master_smpl
integer width = 2560
integer height = 1364
string title = "(RH074) Parámetros de Participación por Utilidades"
string menuname = "m_master_simple"
end type
global w_rh074_parametros_utilidades w_rh074_parametros_utilidades

on w_rh074_parametros_utilidades.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh074_parametros_utilidades.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_insert;call super::ue_insert;// La tabla de parámetros solo debe tener un registro

integer ln_contador
select count(reckey)
  into :ln_contador
  from utlparam ;

if ln_contador = 1 then 
 	dw_master.deleterow(0) 
	dw_master.ii_update=0
	messagebox("Aviso","Solo debe existir un registro en este mantenimiento")
end if 

end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;string  ls_grp_remun_anual, ls_grp_inasist_anual, ls_grp_dias_reintegro
string  ls_cncp_adel_util, ls_cncp_pago_util, ls_cncp_dscto_util
integer li_row, li_verifica, li_dias_util

li_row = dw_master.GetRow()

if li_row > 0 then 

	ls_grp_remun_anual = Trim(dw_master.GetItemString(li_row,"grp_remun_anual"))
	if not isnull(ls_grp_remun_anual) then
		li_verifica = 0
		select count(*) into :li_verifica from grupo_calculo
   	  where grupo_calculo = :ls_grp_remun_anual ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Grupo de conceptos para cálculo de utilidades no existe. Verifique")
			dw_master.SetColumn("grp_remun_anual")
			dw_master.SetFocus()
			return
		end if	
	end if

	ls_grp_inasist_anual = Trim(dw_master.GetItemString(li_row,"grp_inasist_anual"))
	if not isnull(ls_grp_inasist_anual) then
		li_verifica = 0
		select count(*) into :li_verifica from grupo_calculo
   	  where grupo_calculo = :ls_grp_inasist_anual ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Grupo de conceptos para descuentos por inasistencias no existe. Verifique")
			dw_master.SetColumn("grp_inasist_anual")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_grp_dias_reintegro = Trim(dw_master.GetItemString(li_row,"grp_dias_reintegro"))
	if not isnull(ls_grp_dias_reintegro) then
		li_verifica = 0
		select count(*) into :li_verifica from grupo_calculo
   	  where grupo_calculo = :ls_grp_dias_reintegro ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Grupo de conceptos para reintegro de días no existe. Verifique")
			dw_master.SetColumn("grp_dias_reintegro")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_cncp_adel_util = Trim(dw_master.GetItemString(li_row,"cncp_adelanto_util"))
	if not isnull(ls_cncp_adel_util) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_cncp_adel_util ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Concepto para pago por adelantos de utilidades no existe. Verifique")
			dw_master.SetColumn("cncp_adelanto_util")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_cncp_pago_util = Trim(dw_master.GetItemString(li_row,"cncp_pago_util"))
	if not isnull(ls_cncp_pago_util) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_cncp_pago_util ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Concepto para pago de utilidades no existe. Verifique")
			dw_master.SetColumn("cncp_pago_util")
			dw_master.SetFocus()
			return
		end if	
	end if

	ls_cncp_dscto_util = Trim(dw_master.GetItemString(li_row,"cncp_dscto_adel_util"))
	if not isnull(ls_cncp_dscto_util) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_cncp_dscto_util ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Concepto para descuento de adelanto de utilidades no existe. Verifique")
			dw_master.SetColumn("cncp_dscto_adel_util")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	li_dias_util = dw_master.GetItemNumber(li_row,"dias_tope_ano")
	if isnull(li_dias_util) or li_dias_util = 0 then
		dw_master.ii_update = 0
		messagebox("Validación","Registre días para cálculo de Utilidades")
		dw_master.SetColumn("dias_tope_ano")
		dw_master.SetFocus()
		return
	end if

end if	

dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh074_parametros_utilidades
integer x = 73
integer y = 48
integer width = 2395
integer height = 1076
string dataobject = "d_parametro_utilidades_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::clicked;// Override
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_reckey
choose case dwo.name 
	case 'reckey'
		ls_reckey = Trim(dw_master.GetText())
		if isnull(ls_reckey) or ls_reckey = ' ' then
			Messagebox("Advertencia","Debe ingresar información en esta columna, es obligatorio")
			dw_master.SetColumn("reckey")
			dw_master.SetFocus()
			return 1
		end if 
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("reckey.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_remun_anual.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_inasist_anual.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_dias_reintegro.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_adelanto_util.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_pago_util.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_dscto_adel_util.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("dias_tope_ano.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"reckey","1")

end event

event dw_master::doubleclicked;call super::doubleclicked;String  ls_null ,ls_docname , ls_named ,ls_return1 , ls_return2 ,ls_codigo ,ls_sql ,ls_cod_area
Integer li_file

if this.ii_protect = 1 or row = 0 then return


Setnull(ls_null)


choose case dwo.name
		 case 'grp_remun_anual'		
				ls_sql = "select grupo_calculo as grupo, desc_grupo as descripcion from grupo_calculo"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.grp_remun_anual	   		[row] = ls_return1
				this.object.grupo_calculo_desc_grupo 	[row] = ls_return2
				this.ii_update = 1
				
		 case 'grp_inasist_anual'
				ls_sql = "select grupo_calculo as grupo, desc_grupo as descripcion from grupo_calculo"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.grp_inasist_anual	   		[row] = ls_return1
				this.object.grupo_calculo_desc_grupo_1 [row] = ls_return2
				this.ii_update = 1
				
  	 case 'grp_dias_reintegro'				
				ls_sql = "select grupo_calculo as grupo, desc_grupo as descripcion from grupo_calculo"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.grp_dias_reintegro 			[row] = ls_return1
				this.object.grupo_calculo_desc_grupo_2 [row] = ls_return2
				this.ii_update = 1
				
		 case 'cncp_pago_util'
				ls_sql = "select concep as concepto, desc_concep as descripcion from concepto c where flag_estado="+"'1'"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.cncp_pago_util     		[row] = ls_return1
				this.object.concepto_desc_concep_1  [row] = ls_return2
				this.ii_update = 1
				
	    case 'cncp_dscto_adel_util'
				ls_sql = "select concep as concepto, desc_concep as descripcion from concepto c where flag_estado="+"'1'"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.cncp_dscto_adel_util		[row] = ls_return1
				this.object.concepto_desc_concep_2  [row] = ls_return2
				this.ii_update = 1
				
		case 'cncp_adelanto_util'
				ls_sql = "select concep as concepto, desc_concep as descripcion from concepto c where flag_estado="+"'1'"
				f_lista(ls_sql, ls_return1, ls_return2, '1')
				
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				
				this.object.cncp_adelanto_util  		[row] = ls_return1
				this.object.concepto_desc_concep    [row] = ls_return2
				this.ii_update = 1

end choose
end event

