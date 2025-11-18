$PBExportHeader$w_cm026_marcas.srw
forward
global type w_cm026_marcas from w_abc_master_smpl
end type
end forward

global type w_cm026_marcas from w_abc_master_smpl
integer width = 2638
integer height = 1600
string title = "[CM026] Maestro de Marcas de Articulo"
string menuname = "m_mantto_smpl"
end type
global w_cm026_marcas w_cm026_marcas

on w_cm026_marcas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_cm026_marcas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;int li_protect

li_protect = integer(dw_master.Object.servicio.Protect)

IF li_protect = 0 THEN
   dw_master.Object.servicio.Protect = 1
END IF
end event

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm026_marcas
event ue_display ( string as_columna,  long al_row )
integer width = 2551
integer height = 1240
string dataobject = "d_abc_marcas_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

