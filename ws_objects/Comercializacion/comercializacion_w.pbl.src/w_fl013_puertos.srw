$PBExportHeader$w_fl013_puertos.srw
forward
global type w_fl013_puertos from w_abc_master_smpl
end type
end forward

global type w_fl013_puertos from w_abc_master_smpl
integer x = 0
integer y = 0
integer width = 3465
integer height = 1340
string title = "Mantenimiento de puertos (FL013)"
string menuname = "m_mantenimiento_sl"
long backcolor = 67108864
integer ii_x = 0
boolean ib_update_check = false
end type
global w_fl013_puertos w_fl013_puertos

forward prototypes
public function string of_get_puerto ()
end prototypes

public function string of_get_puerto ();long 		ll_row, ll_number, ll_temp
string 	ls_puerto, ls_temp

ll_number = 0

for ll_row = 1 to dw_master.RowCount() 
	ls_temp = dw_master.object.puerto[ll_row]
	if left(ls_temp,2) = gs_origen then
		ll_temp = Long(mid(ls_temp,3) )
		if ll_temp > ll_number then
			ll_number = ll_temp
		end if
	end if
next

ll_number ++
ls_puerto = gs_origen + string(ll_number,'000000')

return ls_puerto

end function

on w_fl013_puertos.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_fl013_puertos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ib_update_check = TRUE
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl013_puertos
integer x = 0
integer y = 0
integer width = 3401
integer height = 1108
string dataobject = "d_puertos_grd"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_puerto

ls_puerto = of_get_puerto()

this.object.puerto		[al_row] = ls_puerto
this.object.profundidad [al_row] = 0
this.object.flag_estado	[al_row] = '1'
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_codigo
long		ll_find
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "descr_puerto"
		
		ls_codigo 	= trim(this.object.descr_puerto[row])
		ll_find 		= this.find("trim(descr_puerto) = '" + ls_codigo + "'", 1, this.RowCount())
		
		if ll_find > 0 and ll_find <> row then
			MessageBox('Aviso', 'NOMBRE DE PUERTO YA EXISTE, REGISTRO: ' + string(ll_find),StopSign!)
			SetNull(ls_codigo)
			this.object.descr_puerto [row] = ls_codigo
			SetColumn('descr_puerto')
			return 1
		end if

end choose

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

