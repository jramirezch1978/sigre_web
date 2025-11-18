$PBExportHeader$w_ho001_maestro_cuartos.srw
forward
global type w_ho001_maestro_cuartos from w_abc_master_smpl
end type
end forward

global type w_ho001_maestro_cuartos from w_abc_master_smpl
integer width = 3067
integer height = 1852
string title = "[HO001] Maestro de Cuartos"
string menuname = "m_mto_smpl"
end type
global w_ho001_maestro_cuartos w_ho001_maestro_cuartos

on w_ho001_maestro_cuartos.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_ho001_maestro_cuartos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_retrieve;call super::ue_retrieve;dw_master.Retrieve()

end event

type dw_master from w_abc_master_smpl`dw_master within w_ho001_maestro_cuartos
integer width = 2706
integer height = 1460
string dataobject = "d_abc_maestro_cuartos_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen 		[al_row] = gs_origen
this.object.flag_estado 	[al_row] = '1'
this.object.imp_hospedaje 	[al_row] = 0.00
end event

event dw_master::constructor;call super::constructor;//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

