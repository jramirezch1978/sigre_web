$PBExportHeader$w_rh021_abc_cargos_categorias.srw
forward
global type w_rh021_abc_cargos_categorias from w_abc_master_smpl
end type
end forward

global type w_rh021_abc_cargos_categorias from w_abc_master_smpl
integer width = 1344
integer height = 1452
string title = "(RH021) Cargos por Categorías"
string menuname = "m_master_simple"
end type
global w_rh021_abc_cargos_categorias w_rh021_abc_cargos_categorias

on w_rh021_abc_cargos_categorias.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh021_abc_cargos_categorias.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;
String ls_protect
ls_protect=dw_master.Describe("categoria.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('categoria')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_rh021_abc_cargos_categorias
integer x = 5
integer y = 4
integer width = 1294
integer height = 1260
string dataobject = "d_cargo_categoria_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

