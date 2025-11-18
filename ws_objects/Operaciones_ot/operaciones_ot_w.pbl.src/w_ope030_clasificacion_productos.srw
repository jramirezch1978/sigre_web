$PBExportHeader$w_ope030_clasificacion_productos.srw
forward
global type w_ope030_clasificacion_productos from w_abc_master_smpl
end type
end forward

global type w_ope030_clasificacion_productos from w_abc_master_smpl
integer x = 306
integer y = 108
integer width = 2816
integer height = 1576
string title = "Clasificacion de Productos (OPE030)"
string menuname = "m_master_sin_lista"
boolean minbox = false
boolean maxbox = false
end type
global w_ope030_clasificacion_productos w_ope030_clasificacion_productos

on w_ope030_clasificacion_productos.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope030_clasificacion_productos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;of_position_window(150,150)
ii_help = 3           					// help topic


end event

event resize;dw_master.width  = newwidth  - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

type dw_master from w_abc_master_smpl`dw_master within w_ope030_clasificacion_productos
integer x = 0
integer y = 0
integer width = 2743
integer height = 1296
string dataobject = "d_abc_prod_clasif_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()


end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
this.object.ind_distrib [al_row] = '1'
end event

