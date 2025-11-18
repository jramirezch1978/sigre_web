$PBExportHeader$w_com004_num_parte_costo.srw
forward
global type w_com004_num_parte_costo from w_abc_master_smpl
end type
end forward

global type w_com004_num_parte_costo from w_abc_master_smpl
integer width = 1326
integer height = 408
string title = "Numerador de Parte de Costo (COM004)"
string menuname = "m_mantto_smpl"
boolean minbox = false
boolean maxbox = false
boolean resizable = false
end type
global w_com004_num_parte_costo w_com004_num_parte_costo

on w_com004_num_parte_costo.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_com004_num_parte_costo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master


this.MenuId.item[1].item[1].item[3].enabled = false

this.MenuId.item[1].item[1].item[3].visible = false

this.MenuId.item[1].item[1].item[3].ToolbarItemvisible = false

dw_master.Retrieve(gs_origen)

end event

event ue_query_retrieve;// Ancestor Script has been Override
dw_master.Retrieve(gs_origen)
end event

event ue_insert;// Ancestor Script has been Override
Long  ll_row

if idw_1.RowCount() > 0 then
	MessageBox('Aviso', 'YA EXISTE NUMERADOR PARA ESTE ORIGEN', StopSign! )
	return
end if

ll_row = idw_1.Event ue_insert()

IF ll_row <> -1 THEN
	THIS.EVENT ue_insert_pos(ll_row)
end if
end event

type dw_master from w_abc_master_smpl`dw_master within w_com004_num_parte_costo
integer x = 0
integer y = 0
integer width = 1271
integer height = 192
string dataobject = "d_num_parte_costo_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
borderstyle borderstyle = styleraised!
end type

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
end event

event dw_master::getfocus;call super::getfocus;idw_1.BorderStyle = StyleRaised!
idw_1 = this
idw_1.BorderStyle = StyleLowered!
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.origen	[al_row] = gs_origen
this.object.ult_nro	[al_row] = 1
end event

