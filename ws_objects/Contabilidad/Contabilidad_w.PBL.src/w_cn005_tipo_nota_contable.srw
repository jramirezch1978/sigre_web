$PBExportHeader$w_cn005_tipo_nota_contable.srw
forward
global type w_cn005_tipo_nota_contable from w_abc_master_smpl
end type
end forward

global type w_cn005_tipo_nota_contable from w_abc_master_smpl
integer width = 1143
integer height = 1268
string title = "Tipo de Operación (CN005)"
string menuname = "m_abc_master_smpl"
end type
global w_cn005_tipo_nota_contable w_cn005_tipo_nota_contable

on w_cn005_tipo_nota_contable.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn005_tipo_nota_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  	// Relacionar el dw con la base de datos
idw_1 = dw_master              		// asignar dw corriente

//ii_help = 101           				// help topic
idw_1.Retrieve()

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("tipo_nota.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("tipo_nota")
END IF
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn005_tipo_nota_contable
integer width = 1074
integer height = 1068
string dataobject = "d_tipo_nota_cntbl_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular' // tabular, form (default)
ii_ck[1] = 1			 // columnas de lectrua de este dw
ii_dk[1] = 1 	       // columnas que se pasan al detalle

end event

