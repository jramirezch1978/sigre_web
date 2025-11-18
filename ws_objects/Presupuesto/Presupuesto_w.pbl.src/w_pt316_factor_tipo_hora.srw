$PBExportHeader$w_pt316_factor_tipo_hora.srw
forward
global type w_pt316_factor_tipo_hora from w_abc_master_smpl
end type
end forward

global type w_pt316_factor_tipo_hora from w_abc_master_smpl
integer height = 1064
string title = "Tipos de Hora (PT316)"
string menuname = "m_mantenimiento_sl"
end type
global w_pt316_factor_tipo_hora w_pt316_factor_tipo_hora

on w_pt316_factor_tipo_hora.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_pt316_factor_tipo_hora.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
ib_update_check = False
if f_row_Processing( dw_master, "tabular") <> true then		
	return
end if
ib_update_check = True

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_pt316_factor_tipo_hora
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_abc_prsp_factor_tipo_hora_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean 	lb_ret
string 	ls_data, ls_sql, ls_codigo

this.AcceptText()

choose case lower(as_columna)
		
	case "cnta_prsp"
		ls_sql = "SELECT cnta_prsp AS cuenta_presupuestal, " &
				  + "descripcion AS desc_cuenta_presupuestal " &
				  + "FROM presupuesto_cuenta " &
				  + "where flag_estado = '1' " 
					 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp		[al_row] = ls_codigo
			this.object.desc_cnta_prsp	[al_row] = ls_data
			this.ii_update = 1
		end if
		
		return
end choose
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna
long 		ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::itemchanged;call super::itemchanged;string 	ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cnta_prsp"
		
		select descripcion
			into :ls_data
		from presupuesto_cuenta
		where cnta_prsp = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Aviso', "Cuenta presupuestal no existe o no está activo", StopSign!)
			this.object.cnta_prsp		[row] = ls_null
			this.object.desc_cnta_prsp	[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp	[row] = ls_data
		
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado [al_row] = '1'
end event

event dw_master::itemerror;call super::itemerror;return 1
end event

