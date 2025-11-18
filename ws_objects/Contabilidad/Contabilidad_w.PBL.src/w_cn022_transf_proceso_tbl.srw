$PBExportHeader$w_cn022_transf_proceso_tbl.srw
forward
global type w_cn022_transf_proceso_tbl from w_abc_master_smpl
end type
end forward

global type w_cn022_transf_proceso_tbl from w_abc_master_smpl
integer width = 2670
integer height = 1336
string title = "[CN022] Procesos Para Generar Asientos de Transferencias"
string menuname = "m_abc_master_smpl"
end type
global w_cn022_transf_proceso_tbl w_cn022_transf_proceso_tbl

on w_cn022_transf_proceso_tbl.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn022_transf_proceso_tbl.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("cod_proceso.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("cod_proceso")
END IF

end event

event ue_open_pre();call super::ue_open_pre;// Centra pantalla
long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - This.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - This.WorkSpaceHeight()) / 2) - 150
This.move(ll_x,ll_y)


//of_position_window(10,10)       			// Posicionar la ventana en forma fija
//ii_help = 101        
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn022_transf_proceso_tbl
integer x = 0
integer y = 0
integer width = 2633
integer height = 1100
string dataobject = "d_transf_proceso_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectura de este dw

//idw_mst  = 				// dw_master

end event

