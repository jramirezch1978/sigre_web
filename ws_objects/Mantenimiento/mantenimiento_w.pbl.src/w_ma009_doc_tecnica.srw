$PBExportHeader$w_ma009_doc_tecnica.srw
forward
global type w_ma009_doc_tecnica from w_abc_master_smpl
end type
end forward

global type w_ma009_doc_tecnica from w_abc_master_smpl
integer width = 1943
integer height = 1100
string title = "Tipo de documentación tecnica (MA009)"
string menuname = "m_abc_master_smpl"
end type
global w_ma009_doc_tecnica w_ma009_doc_tecnica

on w_ma009_doc_tecnica.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_ma009_doc_tecnica.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion( )
end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)    

//Help
ii_help = 13
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma009_doc_tecnica
integer x = 14
integer y = 0
integer width = 1865
integer height = 892
string dataobject = "d_abc_doc_tecnica_tbl"
end type

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::itemchanged;call super::itemchanged;Accepttext()
String ls_null
Setnull(ls_null)
CHOOSE CASE dwo.name
		 CASE 'doc_tec_tipo'
				IF of_val_duplicado('doc_tec_tipo',data) = FALSE THEN
					Messagebox('Aviso','Registro ya Ha sido Ingresado')
					This.Object.doc_tec_tipo[row] = ls_null
					
					Return 1
				END IF
				
END CHOOSE

end event

