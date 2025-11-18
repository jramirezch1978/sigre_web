$PBExportHeader$w_cm005_forma_pago.srw
forward
global type w_cm005_forma_pago from w_abc_master_smpl
end type
end forward

global type w_cm005_forma_pago from w_abc_master_smpl
integer width = 2999
integer height = 1876
string title = "Formas de Pago [CM005]"
string menuname = "m_mtto_smpl"
end type
global w_cm005_forma_pago w_cm005_forma_pago

on w_cm005_forma_pago.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_cm005_forma_pago.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.forma_pago.Protect)

IF li_protect = 0 THEN
   dw_master.Object.forma_pago.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )
ii_pregunta_delete = 1 
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

type ole_skin from w_abc_master_smpl`ole_skin within w_cm005_forma_pago
end type

type uo_h from w_abc_master_smpl`uo_h within w_cm005_forma_pago
end type

type st_box from w_abc_master_smpl`st_box within w_cm005_forma_pago
end type

type st_filter from w_abc_master_smpl`st_filter within w_cm005_forma_pago
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_cm005_forma_pago
end type

type dw_master from w_abc_master_smpl`dw_master within w_cm005_forma_pago
integer x = 503
integer y = 304
integer width = 2551
integer height = 1240
string dataobject = "d_abc_forma_pago_tbl"
end type

event dw_master::ue_insert_pre(long al_row);call super::ue_insert_pre;//dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
//dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

