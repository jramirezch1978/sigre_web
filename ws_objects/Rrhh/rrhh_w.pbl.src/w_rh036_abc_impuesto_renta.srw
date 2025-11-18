$PBExportHeader$w_rh036_abc_impuesto_renta.srw
forward
global type w_rh036_abc_impuesto_renta from w_abc_master_smpl
end type
end forward

global type w_rh036_abc_impuesto_renta from w_abc_master_smpl
integer width = 2400
integer height = 980
string title = "(RH036) Impuestos de Renta de 5ta. Categoría"
string menuname = "m_master_simple"
boolean resizable = false
boolean center = true
end type
global w_rh036_abc_impuesto_renta w_rh036_abc_impuesto_renta

on w_rh036_abc_impuesto_renta.create
call super::create
if this.MenuName = "m_master_simple" then this.MenuID = create m_master_simple
end on

on w_rh036_abc_impuesto_renta.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_modify;call super::ue_modify;String ls_protect
ls_protect=dw_master.Describe("secuencia.protect")
IF ls_protect='0' THEN
   dw_master.of_column_protect('secuencia')
END IF
end event

event ue_open_pre;call super::ue_open_pre;long ll_x,ll_y
ll_x = (w_main.WorkSpaceWidth() - this.WorkSpaceWidth()) / 2
ll_y = ((w_main.WorkSpaceHeight() - this.WorkSpaceHeight()) / 2) - 150
this.move(ll_x,ll_y)

end event

event ue_update_pre;call super::ue_update_pre;integer  li_secuencia, li_tasa
datetime ld_fecha_ini, ld_fecha_fin
integer  li_row 

li_row = dw_master.GetRow()

if li_row > 0 then 
	li_secuencia = dw_master.GetItemNumber(li_row,"secuencia")
	if li_secuencia = 0 or isnull(li_secuencia) then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar secuencia del registro")
		dw_master.SetColumn("secuencia")
		dw_master.SetFocus()
		return
	end if	
	li_tasa = dw_master.GetItemNumber(li_row,"tasa")
	if li_tasa = 0 or isnull(li_tasa) or li_tasa > 100.00 then
		dw_master.ii_update = 0
		Messagebox("Aviso","El porcentaje de retención no es el correcto, verifique")
		dw_master.SetColumn("tasa")
		dw_master.SetFocus()
		return
	end if	
	ld_fecha_ini = dw_master.GetItemDateTime(li_row,"fecha_vig_ini")
	if isnull(ld_fecha_ini) then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar fecha de inicio de vigencia de retención")
		dw_master.SetColumn("fecha_vig_ini")
		dw_master.SetFocus()
		return
	end if	
	ld_fecha_fin = dw_master.GetItemDateTime(li_row,"fecha_vig_fin")
	if isnull(ld_fecha_fin) then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe ingresar de fecha final de vigencia de retención")
		dw_master.SetColumn("fecha_vig_fin")
		dw_master.SetFocus()
		return
	end if	
 	if ld_fecha_ini > ld_fecha_fin then
		dw_master.ii_update = 0
		Messagebox("Aviso","Debe verificar fechas de vigencias de los topes de retención")
		dw_master.SetColumn("fecha_vig_ini")
		dw_master.SetFocus()
		return
	end if
end if	
dw_master.of_set_flag_replicacion( )

end event

type dw_master from w_abc_master_smpl`dw_master within w_rh036_abc_impuesto_renta
integer x = 0
integer y = 0
integer width = 2277
integer height = 724
string dataobject = "d_impuesto_renta_tbl"
end type

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;
dw_master.Modify("secuencia.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tasa.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tope_ini.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("tope_fin.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fecha_vig_ini.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("fecha_vig_fin.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("cod_usr.Protect='1~tIf(IsRowNew(),0,1)'")
dw_master.Modify("flag_replicacion.Protect='1~tIf(IsRowNew(),0,1)'")

this.setitem(al_row,"cod_usr",gs_user)

end event

