$PBExportHeader$w_ba103_maestro_personas.srw
forward
global type w_ba103_maestro_personas from w_abc_master_smpl
end type
type uo_1 from n_cst_search within w_ba103_maestro_personas
end type
end forward

global type w_ba103_maestro_personas from w_abc_master_smpl
integer y = 360
integer width = 3068
integer height = 1706
string title = "(BA103) Maestro de Personas"
string menuname = "m_abc_master"
boolean maxbox = false
uo_1 uo_1
end type
global w_ba103_maestro_personas w_ba103_maestro_personas

on w_ba103_maestro_personas.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_ba103_maestro_personas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
end on

event ue_open_pre;call super::ue_open_pre;

uo_1.of_set_dw(dw_master)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_ba103_maestro_personas
integer x = 29
integer y = 128
integer width = 2959
integer height = 1411
string dataobject = "d_abc_maestro_personas"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert;//override
return 0
end event

type uo_1 from n_cst_search within w_ba103_maestro_personas
integer x = 29
integer y = 26
integer width = 2940
integer height = 83
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call n_cst_search::destroy
end on

