$PBExportHeader$w_ve001_incoterm.srw
forward
global type w_ve001_incoterm from w_abc_master
end type
end forward

global type w_ve001_incoterm from w_abc_master
integer width = 2217
integer height = 1336
string title = "[VE001] Terminos Internacionales de Comercializacion"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
end type
global w_ve001_incoterm w_ve001_incoterm

on w_ve001_incoterm.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve001_incoterm.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if
end event

event ue_open_pre;call super::ue_open_pre;dw_master.retrieve()

of_position_window(50,50)
end event

event resize;//Override

end event

type dw_master from w_abc_master`dw_master within w_ve001_incoterm
integer x = 37
integer y = 32
integer width = 2112
integer height = 1060
string dataobject = "d_ve_incoterm_tbl"
boolean vscrollbar = true
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

ii_ss = 1 				// indica si se usa seleccion: 1=individual (default), 0=multiple

//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
idw_mst  = 	dw_master

end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

