$PBExportHeader$w_fl010_especie_familia.srw
forward
global type w_fl010_especie_familia from w_abc_master_smpl
end type
end forward

global type w_fl010_especie_familia from w_abc_master_smpl
integer width = 2021
integer height = 1072
string title = "Familias de Especies (FL010)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl010_especie_familia w_fl010_especie_familia

type variables

end variables

on w_fl010_especie_familia.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl010_especie_familia.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl010_especie_familia
integer x = 0
integer y = 0
integer width = 1920
integer height = 812
string dataobject = "d_familia_especie_grd"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_familia, ls_temp
long 		ll_row

ls_familia = '00'
for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.codigo_familia[ll_row]
	
	if ls_temp > ls_familia then
		ls_familia = ls_temp
	end if
	
next

ls_familia = string(integer(ls_familia) + 1, '00')

this.object.codigo_familia[al_row] = ls_familia
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo
long		ll_row_find

this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "desc_familia"
		
		ls_codigo = this.object.desc_familia[row]
		
		ll_row_find = this.Find("desc_familia = '" &
			+ ls_codigo + "'",1, this.RowCount() )
		
		if ll_row_find > 0 and ll_row_find <> row then
			MessageBox('Aviso', 'Descripcion de Familia ya existe', StopSign!)
			SetNull(ls_codigo)
			this.object.desc_familia[row] = ls_codigo
			this.SetColumn('desc_familia')
		end if
		
end choose

end event

