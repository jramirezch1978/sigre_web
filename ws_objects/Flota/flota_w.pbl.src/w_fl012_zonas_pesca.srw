$PBExportHeader$w_fl012_zonas_pesca.srw
forward
global type w_fl012_zonas_pesca from w_abc_master_smpl
end type
end forward

global type w_fl012_zonas_pesca from w_abc_master_smpl
integer width = 2414
integer height = 1100
string title = "Zonas de Pesca (FL012)"
string menuname = "m_mto_smpl"
long backcolor = 67108864
end type
global w_fl012_zonas_pesca w_fl012_zonas_pesca

forward prototypes
public function string of_get_cod_zona ()
end prototypes

public function string of_get_cod_zona ();long 		ll_row, ll_number, ll_temp
string 	ls_codigo, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.zona_pesca[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long( mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_codigo = gs_origen + string(ll_number,'000000')

return ls_codigo
end function

on w_fl012_zonas_pesca.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl012_zonas_pesca.destroy
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

type dw_master from w_abc_master_smpl`dw_master within w_fl012_zonas_pesca
integer x = 0
integer y = 0
integer width = 2181
integer height = 824
string dataobject = "d_zonas_pesca_grid"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string 	ls_zona_pesca

ls_zona_pesca = of_get_cod_zona()

this.object.zona_pesca	[al_row] = ls_zona_pesca
this.object.flag_estado	[al_row] = '1'

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
	case "desc_zona"
		
		ls_codigo = this.object.desc_zona[row]
		
		ll_row_find = this.Find("desc_zona = '" &
			+ ls_codigo + "'",1, this.RowCount() )
		
		if ll_row_find > 0 and ll_row_find <> row then
			MessageBox('Aviso', 'Descripcion de Zona de Pesca ya existe', StopSign!)
			SetNull(ls_codigo)
			this.object.desc_zona[row] = ls_codigo
			this.SetColumn('desc_zona')
			return 1
		end if
		
end choose

end event

