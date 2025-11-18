$PBExportHeader$w_ope008_ot_parametros.srw
forward
global type w_ope008_ot_parametros from w_abc_master_smpl
end type
end forward

global type w_ope008_ot_parametros from w_abc_master_smpl
integer width = 2469
integer height = 1844
string title = "Parámetros de administradores de OT (OPE008)"
string menuname = "m_master_sin_lista"
end type
global w_ope008_ot_parametros w_ope008_ot_parametros

on w_ope008_ot_parametros.create
call super::create
if this.MenuName = "m_master_sin_lista" then this.MenuID = create m_master_sin_lista
end on

on w_ope008_ot_parametros.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

event ue_modify;call super::ue_modify;Int li_protect

li_protect = integer(dw_master.Object.ot_adm.Protect)

IF li_protect = 0 THEN
   dw_master.Object.ot_adm.Protect = 1
END IF 

end event

type dw_master from w_abc_master_smpl`dw_master within w_ope008_ot_parametros
integer width = 2395
integer height = 1640
string dataobject = "d_abc_ot_administracion_control_tbl"
end type

event dw_master::constructor;call super::constructor;//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

//ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;IF this.getrow() = 0 then return

this.object.flag_ctrl_aprt_ot[al_row]='2'
end event

