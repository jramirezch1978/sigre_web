$PBExportHeader$w_cn011_libro_contable.srw
forward
global type w_cn011_libro_contable from w_abc_master_smpl
end type
end forward

global type w_cn011_libro_contable from w_abc_master_smpl
integer width = 1934
integer height = 1868
string title = "Libro Contable (CN011)"
string menuname = "m_abc_master_smpl"
boolean center = true
end type
global w_cn011_libro_contable w_cn011_libro_contable

on w_cn011_libro_contable.create
call super::create
if this.MenuName = "m_abc_master_smpl" then this.MenuID = create m_abc_master_smpl
end on

on w_cn011_libro_contable.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;dw_master.SetTransObject(sqlca)  				// Relacionar el dw con la base de datos
idw_1 = dw_master              				// asignar dw corriente
//of_position_window(20,20)       			// Posicionar la ventana en forma fija
//ii_help = 101           					// help topic
idw_1.Retrieve()

end event

event ue_modify();call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("nro_libro.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect("nro_libro")
END IF

end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cn011_libro_contable
integer x = 0
integer y = 0
integer width = 1897
integer height = 1448
string dataobject = "d_cntbl_libro_tbl"
end type

event dw_master::constructor;call super::constructor;is_dwform = 'tabular'	// tabular, form (default)
//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear
ii_ck[1] = 1				// columnas de lectura de este dw


end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

