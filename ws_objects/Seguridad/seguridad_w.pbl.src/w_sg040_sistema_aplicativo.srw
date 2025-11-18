$PBExportHeader$w_sg040_sistema_aplicativo.srw
forward
global type w_sg040_sistema_aplicativo from w_abc_master_smpl
end type
end forward

global type w_sg040_sistema_aplicativo from w_abc_master_smpl
integer width = 1957
integer height = 1140
string title = "w_abc_sistema_aplicativo  (SG040)"
string menuname = "m_abc_master_smpl"
end type
global w_sg040_sistema_aplicativo w_sg040_sistema_aplicativo

on w_sg040_sistema_aplicativo.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_sg040_sistema_aplicativo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre();call super::ue_open_pre;f_centrar( this)

end event

type dw_master from w_abc_master_smpl`dw_master within w_sg040_sistema_aplicativo
integer width = 1787
integer height = 480
string title = "Registro de Sistemas Aplicativos"
string dataobject = "d_sistema_aplicativo_tbl"
end type

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

