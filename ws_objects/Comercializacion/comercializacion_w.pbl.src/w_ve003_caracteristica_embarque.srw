$PBExportHeader$w_ve003_caracteristica_embarque.srw
forward
global type w_ve003_caracteristica_embarque from w_abc_master
end type
end forward

global type w_ve003_caracteristica_embarque from w_abc_master
integer width = 3008
integer height = 1336
string title = "[VE003] Caracteristicas de Embarque"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
end type
global w_ve003_caracteristica_embarque w_ve003_caracteristica_embarque

on w_ve003_caracteristica_embarque.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve003_caracteristica_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()

of_position_window(50,50)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event resize;//Override
end event

type dw_master from w_abc_master`dw_master within w_ve003_caracteristica_embarque
integer x = 37
integer y = 32
integer width = 2903
integer height = 1060
string dataobject = "d_ve_caracteristica_embarque_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;This.object.cod_usr[al_row] = gs_user
end event

