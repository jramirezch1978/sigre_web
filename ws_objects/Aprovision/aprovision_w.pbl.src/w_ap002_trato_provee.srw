$PBExportHeader$w_ap002_trato_provee.srw
forward
global type w_ap002_trato_provee from w_abc_master_smpl
end type
end forward

global type w_ap002_trato_provee from w_abc_master_smpl
integer width = 2048
integer height = 1540
string title = "Trato Proveedores (AP002)"
string menuname = "m_mantto_smpl"
boolean resizable = false
boolean center = true
end type
global w_ap002_trato_provee w_ap002_trato_provee

type variables

end variables

on w_ap002_trato_provee.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap002_trato_provee.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

end event

event ue_open_pre;call super::ue_open_pre;//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

type dw_master from w_abc_master_smpl`dw_master within w_ap002_trato_provee
integer width = 2002
integer height = 1232
string dataobject = "d_trato_provee_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.trato_provee_alta[al_row] = datetime(today(),time('00:00:00'))
this.object.trato_provee_baja[al_row] = datetime(date('31/12/'+trim(string(year(today())))),time('23:59:59'))
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

