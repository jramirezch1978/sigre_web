$PBExportHeader$w_cn001_tipo_nota.srw
forward
global type w_cn001_tipo_nota from w_abc_master
end type
end forward

global type w_cn001_tipo_nota from w_abc_master
integer width = 1262
integer height = 1156
string title = "Tipos de Notas (CN001)"
string menuname = "m_abc_master_smpl"
end type
global w_cn001_tipo_nota w_cn001_tipo_nota

on w_cn001_tipo_nota.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn001_tipo_nota.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.Retrieve()

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_nota.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_nota")
END IF

end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master`dw_master within w_cn001_tipo_nota
integer width = 1225
integer height = 956
string title = "Tipo de Notas (CN001)"
string dataobject = "d_tipo_nota_cntbl_tbl"
boolean vscrollbar = true
end type

event dw_master::constructor;call super::constructor;is_mastdet = 'm'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

