$PBExportHeader$w_ba106_puertas_ingreso_salida.srw
forward
global type w_ba106_puertas_ingreso_salida from w_abc_master_smpl
end type
end forward

global type w_ba106_puertas_ingreso_salida from w_abc_master_smpl
integer y = 360
integer width = 2757
integer height = 1661
string title = "(BA106) Puertas de Ingreso y Salida"
string menuname = "m_abc_master"
boolean maxbox = false
boolean resizable = false
end type
global w_ba106_puertas_ingreso_salida w_ba106_puertas_ingreso_salida

on w_ba106_puertas_ingreso_salida.create
call super::create
if this.MenuName = "m_abc_master" then this.MenuID = create m_abc_master
end on

on w_ba106_puertas_ingreso_salida.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect

ls_protect = dw_master.Describe("cod_puerta.protect")
If ls_protect = '0' then
	dw_master.of_column_protect('cod_puerta')
End If
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

ii_lec_mst = 0

post event ue_retrieve()
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = False	
// Verifica que campos son requeridos y tengan valores
if not gnvo_app.of_row_Processing( dw_master) then return
ib_update_check = true
end event

event ue_retrieve;call super::ue_retrieve;dw_master.Retrieve(gs_origen)
end event

type dw_master from w_abc_master_smpl`dw_master within w_ba106_puertas_ingreso_salida
integer x = 29
integer y = 26
integer width = 2695
integer height = 1488
string dataobject = "d_abc_puertas_ingreso_salida"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.cod_origen[al_row] = gs_origen
setcolumn('cod_puerta')
end event

