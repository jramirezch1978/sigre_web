$PBExportHeader$w_rh002_param_ctacte_new.srw
forward
global type w_rh002_param_ctacte_new from w_abc_master
end type
end forward

global type w_rh002_param_ctacte_new from w_abc_master
integer width = 2286
integer height = 688
string title = "RH002 - Parametros de grupos de descuentos de cuenta corriente"
string menuname = "m_master_simple"
end type
global w_rh002_param_ctacte_new w_rh002_param_ctacte_new

on w_rh002_param_ctacte_new.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh002_param_ctacte_new.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve('1')
end event

type dw_master from w_abc_master`dw_master within w_rh002_param_ctacte_new
integer width = 2190
integer height = 468
string dataobject = "d_abc_param_ctacte_ff"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw
idw_mst  = dw_master

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.Object.Reckey[al_row]='1'
end event

event dw_master::doubleclicked;call super::doubleclicked;String  ls_null , ls_return1 , ls_return2, ls_sql, ls_codigo

Integer li_file

IF THIS.ii_protect = 1 OR row = 0 THEN RETURN

Setnull(ls_null)

CHOOSE CASE dwo.name
	CASE 'grp_ctacte_gratif'
			ls_codigo = this.Object.grp_ctacte_gratif[row]
			ls_sql = "SELECT grupo_calculo as grupo, desc_grupo as descripcion FROM grupo_calculo"
			f_lista(ls_sql, ls_return1, ls_return2, '1')
			
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			
			this.object.grp_ctacte_gratif[row] = ls_return1
			this.object.grupo_calculo_desc_grupo [row] = ls_return2
			this.ii_update = 1 
	CASE 'grp_ctacte_utilidad'
			ls_codigo = this.Object.grp_ctacte_utilidad[row]
			ls_sql = "SELECT grupo_calculo as grupo, desc_grupo as descripcion FROM grupo_calculo"
			f_lista(ls_sql, ls_return1, ls_return2, '1')
			
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			
			this.object.grp_ctacte_utilidad[row] = ls_return1
			this.object.grupo_calculo_desc_grupo_1 [row] = ls_return2
			this.ii_update = 1 
	CASE 'grp_ctacte_vacacion'
			ls_codigo = this.Object.grp_ctacte_vacacion[row]
			ls_sql = "SELECT grupo_calculo as grupo, desc_grupo as descripcion FROM grupo_calculo"
			f_lista(ls_sql, ls_return1, ls_return2, '1')
			
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			
			this.object.grp_ctacte_vacacion[row] = ls_return1
			this.object.grupo_calculo_desc_grupo_2 [row] = ls_return2
			this.ii_update = 1 
	CASE 'grp_ctacte_cts'
			ls_codigo = this.Object.grp_ctacte_cts[row]
			ls_sql = "SELECT grupo_calculo as grupo, desc_grupo as descripcion FROM grupo_calculo"
			f_lista(ls_sql, ls_return1, ls_return2, '1')
			
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			
			this.object.grp_ctacte_cts[row] = ls_return1
			this.object.grupo_calculo_desc_grupo_3 [row] = ls_return2
			this.ii_update = 1 
	CASE 'grp_ctacte_otros'
			ls_codigo = this.Object.grp_ctacte_otros[row]
			ls_sql = "SELECT grupo_calculo as grupo, desc_grupo as descripcion FROM grupo_calculo"
			f_lista(ls_sql, ls_return1, ls_return2, '1')
			
			if isnull(ls_return1) or trim(ls_return1) = '' then return
			
			this.object.grp_ctacte_otros[row] = ls_return1
			this.object.grupo_calculo_desc_grupo_4 [row] = ls_return2
			this.ii_update = 1 

END CHOOSE

end event

