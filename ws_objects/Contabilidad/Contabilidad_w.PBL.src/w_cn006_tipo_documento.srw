$PBExportHeader$w_cn006_tipo_documento.srw
forward
global type w_cn006_tipo_documento from w_abc_master_smpl
end type
end forward

global type w_cn006_tipo_documento from w_abc_master_smpl
integer width = 1431
integer height = 1588
string title = "Tipo de Documento (CN006)"
string menuname = "m_abc_master_smpl"
end type
global w_cn006_tipo_documento w_cn006_tipo_documento

on w_cn006_tipo_documento.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn006_tipo_documento.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_doc.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_doc")
END IF

end event

event resize;//  Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn006_tipo_documento
integer width = 1390
integer height = 1352
string dataobject = "d_doc_tipo_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)

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

