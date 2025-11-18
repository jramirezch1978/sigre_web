$PBExportHeader$w_rh072_parametros_liquidacion.srw
forward
global type w_rh072_parametros_liquidacion from w_abc_master_smpl
end type
end forward

global type w_rh072_parametros_liquidacion from w_abc_master_smpl
integer width = 3643
integer height = 2124
string title = "(RH072) Parámetros de Liquidación de Créditos Laborales"
string menuname = "m_master_simple"
end type
global w_rh072_parametros_liquidacion w_rh072_parametros_liquidacion

on w_rh072_parametros_liquidacion.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh072_parametros_liquidacion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;// Override
end event

event ue_insert;call super::ue_insert;// La tabla de parámetros solo debe tener un registro

integer ln_contador
select count(reckey)
  into :ln_contador
  from rh_liqparam ;

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

event ue_update_pre;call super::ue_update_pre;string  ls_tipo_doc, ls_fondo_retiro, ls_cts, ls_indemnizacion, ls_dscto_cta_cte
string  ls_remuneracion, ls_dscto_leyes, ls_dscto_remun, ls_aportacion
string  ls_adel_cts, ls_adel_bs, ls_indem_vac
integer li_row, li_verifica, li_dias_interes_cts

li_row = dw_master.GetRow()

if li_row > 0 then 

	ls_tipo_doc = Trim(dw_master.GetItemString(li_row,"tipo_doc"))
	if not isnull(ls_tipo_doc) then
		li_verifica = 0
		select count(*) into :li_verifica from doc_tipo
		  where tipo_doc = :ls_tipo_doc ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Tipo de documento de liquidación no existe. Verifique")
			dw_master.SetColumn("tipo_doc")
			dw_master.SetFocus()
			return
		end if	
	end if

	ls_fondo_retiro = Trim(dw_master.GetItemString(li_row,"grp_fondo_retiro"))
	if not isnull(ls_fondo_retiro) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_fondo_retiro ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para el fondo de retiro no existe. Verifique")
			dw_master.SetColumn("grp_fondo_retiro")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_cts = Trim(dw_master.GetItemString(li_row,"grp_cts"))
	if not isnull(ls_cts) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_cts ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para la C.T.S. no existe. Verifique")
			dw_master.SetColumn("grp_cts")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_indemnizacion = Trim(dw_master.GetItemString(li_row,"grp_indemnizacion"))
	if not isnull(ls_indemnizacion) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_indemnizacion ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para la indemnización no existe. Verifique")
			dw_master.SetColumn("grp_indemnizacion")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_dscto_cta_cte = Trim(dw_master.GetItemString(li_row,"grp_dscto_cta_cte"))
	if not isnull(ls_dscto_cta_cte) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_dscto_cta_cte ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para descuentos de cuenta corriente no existe. Verifique")
			dw_master.SetColumn("grp_dscto_cta_cte")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_remuneracion = Trim(dw_master.GetItemString(li_row,"grp_remuneracion"))
	if not isnull(ls_remuneracion) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_remuneracion ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para remuneraciones no existe. Verifique")
			dw_master.SetColumn("grp_remuneracion")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_dscto_leyes = Trim(dw_master.GetItemString(li_row,"grp_dscto_leyes"))
	if not isnull(ls_dscto_leyes) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_dscto_leyes ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para descuentos de leyes sociales no existe. Verifique")
			dw_master.SetColumn("grp_dscto_leyes")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_dscto_remun = Trim(dw_master.GetItemString(li_row,"grp_dscto_remun"))
	if not isnull(ls_dscto_remun) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_dscto_remun ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para descuentos de remuneraciones no existe. Verifique")
			dw_master.SetColumn("grp_dscto_remun")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_aportacion = Trim(dw_master.GetItemString(li_row,"grp_aportacion"))
	if not isnull(ls_aportacion) then
		li_verifica = 0
		select count(*) into :li_verifica from rh_liq_grupo
		  where cod_grupo = :ls_aportacion ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Código de grupo para las aportaciones no existe. Verifique")
			dw_master.SetColumn("grp_aportacion")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_adel_cts = Trim(dw_master.GetItemString(li_row,"cncp_adel_cts"))
	if not isnull(ls_adel_cts) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_adel_cts ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Conceptos para adelantos de C.T.S. no existe. Verifique")
			dw_master.SetColumn("cncp_adel_cts")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_adel_bs = Trim(dw_master.GetItemString(li_row,"cncp_adel_bs"))
	if not isnull(ls_adel_bs) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_adel_bs ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Conceptos para adelantos de beneficios sociales no existe. Verifique")
			dw_master.SetColumn("cncp_adel_bs")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	ls_indem_vac = Trim(dw_master.GetItemString(li_row,"cncp_indem_vac"))
	if not isnull(ls_indem_vac) then
		li_verifica = 0
		select count(*) into :li_verifica from concepto
		  where concep = :ls_indem_vac ;
		if li_verifica = 0 then
			dw_master.ii_update = 0
			messagebox("Validación","Conceptos para indemnización por vacaciones no existe. Verifique")
			dw_master.SetColumn("cncp_indem_vac")
			dw_master.SetFocus()
			return
		end if	
	end if
	
	li_dias_interes_cts = dw_master.GetItemNumber(li_row,"dias_interes_cts")
	if isnull(li_dias_interes_cts) then
		dw_master.ii_update = 0
		messagebox("Validación","Registre a cuantos días se va a empezar a calcular los intereses por C.T.S.")
		dw_master.SetColumn("dias_interes_cts")
		dw_master.SetFocus()
		return
	end if

end if	

dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh072_parametros_liquidacion
integer x = 46
integer y = 40
integer width = 3511
integer height = 1860
string dataobject = "d_parametros_liquidacion_ff"
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
dw_master.Modify("tipo_doc.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_fondo_retiro.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_cts.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_indemnizacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_dscto_cta_cte.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_remuneracion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_dscto_leyes.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_dscto_remun.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_aportacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_adel_cts.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_adel_bs.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_indem_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("dias_interes_cts.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_replicacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_int_cts.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_cnta_cobrar.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_reten_jud.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_reten_jud.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_asig_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_asig_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_grat_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_grat_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_grat_trunc.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_grat_trunc.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_racion_cocida.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_cts.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_vac_trunc.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_liq_cred_lab.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_comp_dic.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_adelanto.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_cnta_cobrar.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_cnta_cobrar.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_racion_cocida.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_racion_cocida.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_remun_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_remun_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_vacaciones.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_vac_truncas.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_vac_truncas.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grp_indem_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("sgrp_indem_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("prsp_pago_liq.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("prsp_pago_ext.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_fondo_ret.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_reten_jud.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_asig_vac.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_grat_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_remun_dev.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_gratificacion.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cncp_int_cts_abn.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cencos_liq.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"reckey","1")

end event

