$PBExportHeader$w_al006_forma_embarque.srw
forward
global type w_al006_forma_embarque from w_abc_master_smpl
end type
end forward

global type w_al006_forma_embarque from w_abc_master_smpl
integer width = 2505
integer height = 2000
string title = "Formas de embarque"
string menuname = "m_mtto_smpl"
end type
global w_al006_forma_embarque w_al006_forma_embarque

on w_al006_forma_embarque.create
int iCurrent
call super::create
if this.MenuName = "m_mtto_smpl" then this.MenuID = create m_mtto_smpl
end on

on w_al006_forma_embarque.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.motivo_traslado.Protect)

IF li_protect = 0 THEN
   dw_master.Object.motivo_traslado.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;//f_centrar( this )
ii_pregunta_delete = 1 
ib_log = TRUE

uo_filter.of_set_dw( dw_master )
uo_filter.of_retrieve_fields( )
uo_h.of_set_title( this.title + ". Nro de Registros: " + string(dw_master.RowCount()))
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

type p_pie from w_abc_master_smpl`p_pie within w_al006_forma_embarque
end type

type ole_skin from w_abc_master_smpl`ole_skin within w_al006_forma_embarque
end type

type uo_h from w_abc_master_smpl`uo_h within w_al006_forma_embarque
end type

type st_box from w_abc_master_smpl`st_box within w_al006_forma_embarque
end type

type phl_logonps from w_abc_master_smpl`phl_logonps within w_al006_forma_embarque
end type

type p_mundi from w_abc_master_smpl`p_mundi within w_al006_forma_embarque
end type

type p_logo from w_abc_master_smpl`p_logo within w_al006_forma_embarque
end type

type st_filter from w_abc_master_smpl`st_filter within w_al006_forma_embarque
end type

type uo_filter from w_abc_master_smpl`uo_filter within w_al006_forma_embarque
end type

type dw_master from w_abc_master_smpl`dw_master within w_al006_forma_embarque
integer x = 498
integer y = 284
integer width = 1358
string dataobject = "d_abc_forma_embarque"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;dw_master.Modify("forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("desc_forma_pago.Protect='1~tIf(IsRowNew(),0,1)'")
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

