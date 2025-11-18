$PBExportHeader$w_ve008_flete_instruccion.srw
forward
global type w_ve008_flete_instruccion from w_abc_master
end type
end forward

global type w_ve008_flete_instruccion from w_abc_master
integer width = 2642
integer height = 1560
string title = "[VE008] Instrucciones de Flete"
string menuname = "m_mantenimiento"
boolean maxbox = false
boolean resizable = false
end type
global w_ve008_flete_instruccion w_ve008_flete_instruccion

on w_ve008_flete_instruccion.create
call super::create
if this.MenuName = "m_mantenimiento" then this.MenuID = create m_mantenimiento
end on

on w_ve008_flete_instruccion.destroy
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

type dw_master from w_abc_master`dw_master within w_ve008_flete_instruccion
integer x = 37
integer y = 32
integer width = 2551
integer height = 1284
string dataobject = "d_ve_flete_instruccion_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::itemerror;call super::itemerror;Return 1

end event

