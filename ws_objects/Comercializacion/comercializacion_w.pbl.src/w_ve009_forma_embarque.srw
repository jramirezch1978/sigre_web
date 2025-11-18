$PBExportHeader$w_ve009_forma_embarque.srw
forward
global type w_ve009_forma_embarque from w_abc_master_smpl
end type
end forward

global type w_ve009_forma_embarque from w_abc_master_smpl
integer width = 1742
integer height = 1208
string title = "[VE009] Forma de Embarque"
string menuname = "m_mantenimiento_sl"
boolean maxbox = false
boolean resizable = false
end type
global w_ve009_forma_embarque w_ve009_forma_embarque

on w_ve009_forma_embarque.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_ve009_forma_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.motivo_traslado.Protect)

IF li_protect = 0 THEN
   dw_master.Object.motivo_traslado.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 

of_position_window(50,50)
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if

dw_master.of_set_flag_replicacion()
end event

event resize;//Override
end event

type dw_master from w_abc_master_smpl`dw_master within w_ve009_forma_embarque
integer x = 37
integer y = 32
integer width = 1646
integer height = 932
string dataobject = "d_abc_forma_embarque"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

