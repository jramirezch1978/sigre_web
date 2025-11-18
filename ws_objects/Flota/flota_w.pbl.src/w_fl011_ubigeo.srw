$PBExportHeader$w_fl011_ubigeo.srw
forward
global type w_fl011_ubigeo from w_abc_master_smpl
end type
end forward

global type w_fl011_ubigeo from w_abc_master_smpl
integer width = 1472
integer height = 1400
string title = "Mantenimiento de Zonas Geogràficas en Tierra (FL011)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl011_ubigeo w_fl011_ubigeo

on w_fl011_ubigeo.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl011_ubigeo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl011_ubigeo
integer width = 1413
integer height = 1124
string dataobject = "d_ubigeo_grd"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_ubigeo, ls_tmp
Long 		ll_row

ls_ubigeo = '000000'

for ll_row = 1 to this.RowCount()
	ls_tmp = this.object.ubigeo_codigo[ll_row]
	if ls_tmp > ls_ubigeo then
		ls_ubigeo = ls_tmp
	end if
next

ls_ubigeo = string(long(ls_ubigeo)+1, '000000' )

this.object.ubigeo_codigo[al_row] = ls_ubigeo
end event

event dw_master::itemerror;call super::itemerror;RETURN 1
end event

