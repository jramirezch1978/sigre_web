$PBExportHeader$w_sig007_parametros.srw
forward
global type w_sig007_parametros from w_abc_master_smpl
end type
end forward

global type w_sig007_parametros from w_abc_master_smpl
integer width = 1353
integer height = 760
string title = "(SIG007) Mantenimiento Parametros"
string menuname = "m_abc_mantenimiento_ind_fuente"
boolean maxbox = false
boolean resizable = false
long backcolor = 15793151
boolean center = true
end type
global w_sig007_parametros w_sig007_parametros

on w_sig007_parametros.create
call super::create
if this.MenuName = "m_abc_mantenimiento_ind_fuente" then this.MenuID = create m_abc_mantenimiento_ind_fuente
end on

on w_sig007_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event resize;//Override
this.windowstate = Normal!
end event

type dw_master from w_abc_master_smpl`dw_master within w_sig007_parametros
integer x = 23
integer y = 20
integer width = 1294
integer height = 560
string dataobject = "d_parametros"
boolean vscrollbar = false
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return
end event

event dw_master::clicked;//Override
idw_1 = THIS
end event

