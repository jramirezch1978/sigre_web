$PBExportHeader$w_pr021_prod_costos_titulos.srw
forward
global type w_pr021_prod_costos_titulos from w_abc_master_smpl
end type
end forward

global type w_pr021_prod_costos_titulos from w_abc_master_smpl
integer width = 2299
integer height = 1004
string title = "Costos Titulos(PR021)"
string menuname = "m_mantto_consulta"
end type
global w_pr021_prod_costos_titulos w_pr021_prod_costos_titulos

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
//is_tabla = 'COSTOS_TITULOS'

ib_update_check = true
end event

on w_pr021_prod_costos_titulos.create
call super::create
if this.MenuName = "m_mantto_consulta" then this.MenuID = create m_mantto_consulta
end on

on w_pr021_prod_costos_titulos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_pr021_prod_costos_titulos
integer width = 2203
string dataobject = "ds_abc_costos_titulos"
end type

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert;call super::ue_insert;this.object.flag_estado[this.GetRow()] = '1'
return 1
end event

event dw_master::constructor;call super::constructor;is_mastdet = 'm'
is_dwform = 'tabular'

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

