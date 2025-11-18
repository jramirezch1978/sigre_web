$PBExportHeader$w_rh031_abc_concepto.srw
forward
global type w_rh031_abc_concepto from w_abc_master_smpl
end type
end forward

global type w_rh031_abc_concepto from w_abc_master_smpl
integer width = 3195
integer height = 1632
string title = "(RH031) Maestro de Conceptos de Cálculos"
string menuname = "m_master_simple"
end type
global w_rh031_abc_concepto w_rh031_abc_concepto

on w_rh031_abc_concepto.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh031_abc_concepto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("concep.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('concep')
END IF
end event

event ue_update_pre;call super::ue_update_pre;string ls_desc_concepto, ls_descripcion, ls_grupo
int li_row 
li_row = dw_master.GetRow()

If li_row > 0 Then 
	ls_desc_concepto = Trim(dw_master.GetItemString(li_row,"desc_concep"))
	If len(ls_desc_concepto) = 0 or isnull(ls_desc_concepto) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validación","Ingrese la descripción del concepto")
		dw_master.SetColumn("desc_concep")
		dw_master.SetFocus()
		return
	End if	
	ls_descripcion = Trim(dw_master.GetItemString(li_row,"desc_breve"))
	If len(ls_descripcion) = 0 or isnull(ls_descripcion) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validación","Ingrese la descripción breve del concepto")
		dw_master.SetColumn("desc_breve")
		dw_master.SetFocus()
		return
	End if	
	ls_grupo = Trim(dw_master.GetItemString(li_row,"grupo_calc"))
	If len(ls_grupo) = 0 or isnull(ls_grupo) Then
		dw_master.ii_update = 0
		Messagebox("Sistema de Validación","Ingrese el grupo del concepto")
		dw_master.SetColumn("grupo_calc")
		dw_master.SetFocus()
		return
	End if	
End if	
dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh031_abc_concepto
event ue_display ( string as_columna,  long al_row )
integer x = 5
integer y = 4
integer width = 3127
integer height = 1440
string dataobject = "d_concepto_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_codigo, ls_data, ls_sql, ls_nro_orden, &
			ls_oper_sec, ls_cencos, ls_desc_cencos, ls_cencos_r, ls_desc_cencos_r, &
			ls_dom
Long		ll_row_find

str_parametros sl_param

choose case upper(as_columna)
		
	case "CONCEP_RTPS"

		ls_sql = "SELECT COD_CONCEPTO_RTPS AS CODIGO, " &
				  + "DESC_CONCEPTO_RTPS AS DESCRIPCION " &
				  + "FROM rrhh_conceptos_rtps WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.concep_rtps		[al_row] = ls_codigo
			this.object.desc_concepto_rtps  [al_row] = ls_data
			this.ii_update = 1
		end if
end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemchanged;call super::itemchanged;string ls_concepto

choose case dwo.name
	case 'concep'
		ls_concepto = trim(dw_master.GetText())
		if len(ls_concepto) <> 4 THen
			Messagebox("Sistema de validación","El código del concepto debe ser "+&
			           " de 4 dígitos")
	    	dw_master.SetColumn("concep")
			dw_master.setfocus()
	      return 1	
	   End if	
End choose 		
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.setitem(al_row,"cod_usr",gs_user)

dw_master.Modify("concep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_concep.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_breve.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_estado.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fact_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("imp_tope_min.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("imp_tope_max.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("nro_horas.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("grupo_calc.Protect='1~tIf(IsRowNew(),0,1)'")


end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long		ll_row

this.Accepttext( )
IF This.describe(dwo.Name + ".Protect") = '1' Then RETURN
ll_row = row

If ll_row > 0 Then
	ls_columna = upper(dwo.name)
	This.event dynamic ue_display(ls_columna, ll_row)
end if
end event

