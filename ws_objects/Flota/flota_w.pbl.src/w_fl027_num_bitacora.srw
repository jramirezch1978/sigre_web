$PBExportHeader$w_fl027_num_bitacora.srw
forward
global type w_fl027_num_bitacora from w_abc_master_smpl
end type
end forward

global type w_fl027_num_bitacora from w_abc_master_smpl
integer width = 1326
integer height = 408
string title = "Numerador de Bitacora (FL027)"
string menuname = "m_mto_smpl"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
end type
global w_fl027_num_bitacora w_fl027_num_bitacora

on w_fl027_num_bitacora.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl027_num_bitacora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master


this.MenuId.item[1].item[1].item[2].enabled = false
this.MenuId.item[1].item[1].item[3].enabled = false

this.MenuId.item[1].item[1].item[2].visible = false
this.MenuId.item[1].item[1].item[3].visible = false

this.MenuId.item[1].item[1].item[2].ToolbarItemvisible = false
this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = false



dw_master.Retrieve(gs_origen)

if dw_master.RowCount() = 0 then
	dw_master.event dynamic ue_insert()
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl027_num_bitacora
integer x = 0
integer y = 0
integer width = 1271
integer height = 192
string dataobject = "d_num_bitacora_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean border = false
boolean livescroll = false
end type

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen[al_row] = gs_origen
end event

