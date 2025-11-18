$PBExportHeader$w_ba104_maestro_vehiculos.srw
forward
global type w_ba104_maestro_vehiculos from w_abc_master_smpl
end type
type uo_1 from n_cst_search within w_ba104_maestro_vehiculos
end type
end forward

global type w_ba104_maestro_vehiculos from w_abc_master_smpl
integer y = 360
integer width = 3068
integer height = 1706
string title = "(BA104) Maestro de Vehiculos"
string menuname = "m_abc_master"
boolean maxbox = false
uo_1 uo_1
end type
global w_ba104_maestro_vehiculos w_ba104_maestro_vehiculos

on w_ba104_maestro_vehiculos.create
int iCurrent
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
this.uo_1=create uo_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.uo_1
end on

on w_ba104_maestro_vehiculos.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.uo_1)
end on

event ue_open_pre;call super::ue_open_pre;

uo_1.of_set_dw(dw_master)
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
ib_update_check = true
end event

type dw_master from w_abc_master_smpl`dw_master within w_ba104_maestro_vehiculos
integer x = 29
integer y = 128
integer width = 2959
integer height = 1411
string dataobject = "d_abc_maestro_vehiculos"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert;//override
return 0
end event

event dw_master::doubleclicked;call super::doubleclicked;if row > 0 then
	string ls_sql, ls_return1, ls_return2
	if dwo.name = 'tipo_remolque' then
		ls_sql = "select tipo_remolque as codigo, desc_remolque as descripcion from seg_tipo_semiremolque where flag_estado = '1' order by 2" 
		 		f_lista(ls_sql, ls_return1, ls_return2, '2')
				if isnull(ls_return1) or trim(ls_return1) = '' then return
				this.object.tipo_remolque [row] = ls_return1
				this.ii_update = 1
	end if
end if
end event

type uo_1 from n_cst_search within w_ba104_maestro_vehiculos
integer x = 29
integer y = 26
integer width = 2940
integer height = 83
integer taborder = 30
boolean bringtotop = true
end type

on uo_1.destroy
call n_cst_search::destroy
end on

