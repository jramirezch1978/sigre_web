$PBExportHeader$w_sg001_configuracion.srw
forward
global type w_sg001_configuracion from w_abc_master_smpl
end type
end forward

global type w_sg001_configuracion from w_abc_master_smpl
integer width = 2775
integer height = 1540
string title = "[SG001] Tabla de configuración"
string menuname = "m_abc_master_smpl"
end type
global w_sg001_configuracion w_sg001_configuracion

on w_sg001_configuracion.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_sg001_configuracion.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_sg001_configuracion
integer width = 2610
integer height = 1256
string dataobject = "d_abc_configuracion_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.fec_registro [al_row] = gnvo_app.of_fecha_actual( )
end event

