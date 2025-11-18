$PBExportHeader$w_sg040_sistema_aplicativo.srw
forward
global type w_sg040_sistema_aplicativo from w_abc_master_smpl
end type
end forward

global type w_sg040_sistema_aplicativo from w_abc_master_smpl
integer width = 1957
integer height = 1140
string title = "[SG040] Sistemas aplicativos"
string menuname = "m_mtto_smpl"
end type
global w_sg040_sistema_aplicativo w_sg040_sistema_aplicativo

on w_sg040_sistema_aplicativo.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_sg040_sistema_aplicativo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;//f_centrar( this)

end event

type ole_skin from w_abc_master_smpl`ole_skin within w_sg040_sistema_aplicativo
end type

type st_filter from w_abc_master_smpl`st_filter within w_sg040_sistema_aplicativo
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_sg040_sistema_aplicativo
end type

type st_box from w_abc_master_smpl`st_box within w_sg040_sistema_aplicativo
end type

type uo_h from w_abc_master_smpl`uo_h within w_sg040_sistema_aplicativo
end type

type dw_master from w_abc_master_smpl`dw_master within w_sg040_sistema_aplicativo
integer width = 1787
integer height = 480
string title = "Registro de Sistemas Aplicativos"
string dataobject = "d_sistema_aplicativo_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

