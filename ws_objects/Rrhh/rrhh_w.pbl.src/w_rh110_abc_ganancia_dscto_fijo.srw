$PBExportHeader$w_rh110_abc_ganancia_dscto_fijo.srw
forward
global type w_rh110_abc_ganancia_dscto_fijo from w_abc_master
end type
type uo_cabecera from u_cst_quick_search within w_rh110_abc_ganancia_dscto_fijo
end type
end forward

global type w_rh110_abc_ganancia_dscto_fijo from w_abc_master
integer width = 2350
integer height = 2468
string title = "(RH110) Ganancias y Descuentos Fijos"
string menuname = "m_master_simple"
uo_cabecera uo_cabecera
end type
global w_rh110_abc_ganancia_dscto_fijo w_rh110_abc_ganancia_dscto_fijo

type variables
string is_codigo
end variables

on w_rh110_abc_ganancia_dscto_fijo.create
int iCurrent
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
this.uo_cabecera=create uo_cabecera
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_cabecera
end on

on w_rh110_abc_ganancia_dscto_fijo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_cabecera)
end on

event ue_open_pre;call super::ue_open_pre;uo_cabecera.of_set_dw('d_maestro_lista_tbl')
uo_cabecera.of_set_field('nombres')

uo_cabecera.of_retrieve_lista(gs_origen)
uo_cabecera.of_sort_lista()
uo_cabecera.of_protect()


end event

event resize;call super::resize;uo_cabecera.width  = newwidth  - uo_cabecera.x - 10
end event

type dw_master from w_abc_master`dw_master within w_rh110_abc_ganancia_dscto_fijo
integer y = 1136
integer width = 2295
integer height = 948
string dataobject = "d_ganancia_dscto_fijo_tbl"
end type

event dw_master::constructor;is_dwform = 'tabular'  // tabular, grid, form (default)
ii_ck[1] = 1				// columnas de lectura de este dw
ii_ck[2] = 2				// columnas de lectura de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_trabajador 	[al_row] = is_codigo
this.object.cod_usr				[al_row] = gs_user
this.object.flag_estado 		[al_row] = '1'
this.object.porcentaje 			[al_row] = 0.00
this.object.imp_gan_desc 		[al_row] = 0.00
this.object.imp_max_gan_desc	[al_row] = 0.00



end event

event dw_master::itemchanged;call super::itemchanged;Decimal 	ldc_imp_gan
String	ls_desc

choose case dwo.name 
	case 'imp_gan_desc'
		ldc_imp_gan = Dec(dw_master.Gettext())
		If ldc_imp_gan < 0 then
			Messagebox("Sistema de Validacion","El IMPORTE debe "+&
			           "ser MAYOR que CERO")
			dw_master.SetColumn("imp_gan_desc")
			dw_master.SetFocus()
			return 1
		End If
		
	case 'concep'
		select desc_concep
			into :ls_desc
		from concepto
		where concep = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			MessageBox('Error', 'No existe concepto de planilla ' + data + ' o no esta activo, por favor verifique!')
			return 1
		end if
		
		this.object.desc_concep [row] = ls_desc

end choose 	
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna, ls_string, ls_evaluate

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

event dw_master::ue_display;call super::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
	case "concep"
		ls_sql = "select concep as concepto, " &
				 + "desc_concep as descripcion_concepto " &
				 + "from concepto " &
				 + "where flag_estado = '1'"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')

		if ls_codigo <> '' then
			this.object.concep		[al_row] = ls_codigo
			this.object.desc_concep	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose
end event

type uo_cabecera from u_cst_quick_search within w_rh110_abc_ganancia_dscto_fijo
integer width = 2258
integer height = 1112
integer taborder = 10
boolean bringtotop = true
end type

on uo_cabecera.destroy
call u_cst_quick_search::destroy
end on

event ue_retorno;call super::ue_retorno;dw_master.Retrieve(aa_id)
is_codigo=aa_id
end event

