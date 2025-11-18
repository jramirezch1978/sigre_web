$PBExportHeader$w_ma005_incidencias_mant.srw
forward
global type w_ma005_incidencias_mant from w_abc_master_smpl
end type
end forward

global type w_ma005_incidencias_mant from w_abc_master_smpl
integer width = 2917
integer height = 1504
string title = "[MA005] Tipos de Incidecias de Mantenimiento"
string menuname = "m_abc_master_smpl"
end type
global w_ma005_incidencias_mant w_ma005_incidencias_mant

on w_ma005_incidencias_mant.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_ma005_incidencias_mant.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;of_position_window(0,0)

//Help
ii_help = 7
ib_log = true
end event

event ue_update_pre;call super::ue_update_pre;IF gnvo_app.of_row_Processing( dw_master ) <> true then	
	ib_update_check = False	
	return
ELSE
	ib_update_check = True
END IF
dw_master.of_set_flag_replicacion( )
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma005_incidencias_mant
integer width = 2866
integer height = 1224
string dataobject = "d_abc_inicidencias_dma"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado 	[al_row] = '1'
this.object.fec_registro	[al_row] = gnvo_app.of_fecha_actual()
this.object.cod_usr			[al_row] = gs_user


end event

