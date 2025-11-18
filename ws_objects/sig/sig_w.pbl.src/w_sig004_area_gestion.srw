$PBExportHeader$w_sig004_area_gestion.srw
forward
global type w_sig004_area_gestion from w_abc_master_smpl
end type
end forward

global type w_sig004_area_gestion from w_abc_master_smpl
integer width = 1646
integer height = 1728
string title = "(SIG004) Mantenimiento Area Gestión"
string menuname = "m_abc_mantenimiento"
boolean maxbox = false
boolean resizable = false
long backcolor = 15793151
boolean center = true
end type
global w_sig004_area_gestion w_sig004_area_gestion

on w_sig004_area_gestion.create
call super::create
if this.MenuName = "m_abc_mantenimiento" then this.MenuID = create m_abc_mantenimiento
end on

on w_sig004_area_gestion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.area.Protect)

IF li_protect = 0 THEN
   dw_master.Object.area.Protect = 1
END IF 

end event

event resize;//Override
this.windowstate = Normal!
end event

type dw_master from w_abc_master_smpl`dw_master within w_sig004_area_gestion
integer x = 14
integer y = 12
integer width = 1582
integer height = 1528
string dataobject = "d_area_gestion"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	
ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
ii_ck[1] = 1				// columnas de lectura de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;if dw_master.GetRow() = 0 then return
end event

