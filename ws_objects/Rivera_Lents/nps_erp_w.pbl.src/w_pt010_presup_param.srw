$PBExportHeader$w_pt010_presup_param.srw
forward
global type w_pt010_presup_param from w_abc_master_smpl
end type
end forward

global type w_pt010_presup_param from w_abc_master_smpl
integer width = 2176
integer height = 1308
string title = "Parametros de Presupuesto (PT010)"
string menuname = "m_save_exit"
boolean resizable = false
boolean center = true
end type
global w_pt010_presup_param w_pt010_presup_param

on w_pt010_presup_param.create
int iCurrent
call super::create
if this.MenuName = "m_save_exit" then this.MenuID = create m_save_exit
end on

on w_pt010_presup_param.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;idw_1.Retrieve()

if idw_1.RowCount() = 0 then
	idw_1.event ue_insert()
end if

ib_log = true
end event

event ue_delete;// Ancestor Script has been Override
MessageBox('Aviso', 'Opcion no disponible')

end event

type ole_skin from w_abc_master_smpl`ole_skin within w_pt010_presup_param
end type

type st_filter from w_abc_master_smpl`st_filter within w_pt010_presup_param
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_pt010_presup_param
end type

type st_box from w_abc_master_smpl`st_box within w_pt010_presup_param
end type

type uo_h from w_abc_master_smpl`uo_h within w_pt010_presup_param
end type

type dw_master from w_abc_master_smpl`dw_master within w_pt010_presup_param
integer x = 503
integer y = 276
integer height = 1120
string dataobject = "d_presup_param_ff"
boolean hscrollbar = false
boolean vscrollbar = false
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.llave[al_row] = '1'
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
ii_ck[1] = 1
end event

