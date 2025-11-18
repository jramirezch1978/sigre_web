$PBExportHeader$w_fl016_tipo_politica.srw
forward
global type w_fl016_tipo_politica from w_abc_master_smpl
end type
end forward

global type w_fl016_tipo_politica from w_abc_master_smpl
integer width = 2469
integer height = 1052
string title = "Tipos de Políticas de Pago (FL016)"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
end type
global w_fl016_tipo_politica w_fl016_tipo_politica

on w_fl016_tipo_politica.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl016_tipo_politica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl016_tipo_politica
integer width = 2423
integer height = 824
string dataobject = "d_tipo_politica_pago_grid"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'
this.object.fecha_vigencia[al_row] = Today()

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

