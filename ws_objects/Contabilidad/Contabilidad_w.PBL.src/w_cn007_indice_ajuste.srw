$PBExportHeader$w_cn007_indice_ajuste.srw
forward
global type w_cn007_indice_ajuste from w_abc_master_smpl
end type
end forward

global type w_cn007_indice_ajuste from w_abc_master_smpl
integer width = 1065
integer height = 1504
string title = "Indice de Ajuste (CN007)"
string menuname = "m_abc_master_smpl"
end type
global w_cn007_indice_ajuste w_cn007_indice_ajuste

on w_cn007_indice_ajuste.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn007_indice_ajuste.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("ano.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("ano")
END IF
ls_protect=dw_master.Describe("mes.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("mes")
END IF
end event

event resize;// Override
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_cn007_indice_ajuste
integer width = 1029
integer height = 1288
string dataobject = "d_indice_ajuste_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
ii_ck[1] = 1				// columnas de lectrua de este dw
ii_dk[1] = 1 	      // columnas que se pasan al detalle

end event

event dw_master::itemchanged;Integer ls_mes
this.accepttext()
CHOOSE CASE dwo.name
	CASE 'mes'
		/*
	   ls_mes = DATA
      IF ls_mes > '12' Then
			MessageBox("Aviso","Mes no debe de exceder a 12")
			return 1	
		End if		 
		*/
END CHOOSE		
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

