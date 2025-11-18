$PBExportHeader$w_cam013_ubicacion_campo.srw
forward
global type w_cam013_ubicacion_campo from w_abc_master_smpl
end type
end forward

global type w_cam013_ubicacion_campo from w_abc_master_smpl
integer width = 2866
integer height = 1604
string title = "[CAM013] Ubicación Campo"
string menuname = "m_abc_master_smpl"
end type
global w_cam013_ubicacion_campo w_cam013_ubicacion_campo

on w_cam013_ubicacion_campo.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cam013_ubicacion_campo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_cam013_ubicacion_campo
integer width = 2706
integer height = 1200
string dataobject = "d_abc_ubicacion_campos_tbl"
end type

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

