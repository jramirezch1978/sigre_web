$PBExportHeader$w_pt016_fondo_var_aut.srw
forward
global type w_pt016_fondo_var_aut from w_abc_master_smpl
end type
end forward

global type w_pt016_fondo_var_aut from w_abc_master_smpl
integer width = 2674
integer height = 1780
string title = "Fondo Variaciones Autmáticas (PT015)"
string menuname = "m_mantenimiento_sl"
end type
global w_pt016_fondo_var_aut w_pt016_fondo_var_aut

type variables
string is_col, is_type

end variables

on w_pt016_fondo_var_aut.create
call super::create
if this.MenuName = "m_mantenimiento_sl" then this.MenuID = create m_mantenimiento_sl
end on

on w_pt016_fondo_var_aut.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
ib_log = TRUE
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "tabular") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_pt016_fondo_var_aut
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2551
integer height = 1240
string dataobject = "d_abc_fondo_var_aut_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

STR_CNS_POP lstr_1

choose case lower(as_columna)
		
	case "cnta_prsp_egreso"
		ls_sql = "SELECT cnta_prsp AS CODIGO, " &
				  + "DESCripcion AS DESC_cnta_prsp " &
				  + "FROM presupuesto_cuenta " &
				  + "WHERE flag_estado = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_egreso			[al_row] = ls_codigo
			this.object.desc_cnta_prsp_egreso	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cnta_prsp_ingreso"
		ls_sql = "SELECT cnta_prsp AS CODIGO, " &
				  + "DESCripcion AS DESC_cnta_prsp " &
				  + "FROM presupuesto_cuenta " &
				  + "WHERE flag_estado = '1'"
				 
		f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cnta_prsp_ingreso			[al_row] = ls_codigo
			this.object.desc_cnta_prsp_ingreso	[al_row] = ls_data
			this.ii_update = 1
		end if
	case 'asignado'
		lstr_1.DataObject = 'd_oc_x_requerimiento_articulo_tbl'
		lstr_1.Width = 3800
		lstr_1.Height= 900
		lstr_1.Arg[1] = this.object.fondo_aut_var [al_row]
		lstr_1.Title = 'OC Asociadas a este Requerimiento'
		lstr_1.Tipo_Cascada = 'R'
		of_new_sheet(lstr_1)		
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'
this.object.asignado			[al_row] = 0
this.object.fondo				[al_row] = 0
this.object.ano_uso			[al_row] = year(Date(f_fecha_actual()))
this.object.fecha_creacion	[al_row] = f_fecha_actual()
this.object.cod_usr			[al_row] = gs_user
end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, row)
end if

end event

event dw_master::keydwn;call super::keydwn;string 	ls_columna, ls_cadena
integer 	li_column
long 		ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then
		return 0
	end if
	ls_cadena = "#" + string( li_column ) + ".Protect"
	If this.Describe(ls_cadena) = '1' then RETURN
	
	ls_cadena = "#" + string( li_column ) + ".Name"
	ls_columna = upper( this.Describe(ls_cadena) )
	
	ll_row = this.GetRow()
	if ls_columna <> "!" then
	 	this.event dynamic ue_display( ls_columna, ll_row )
	end if
end if
return 0
end event

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null
SetNull(ls_null)
this.AcceptText()

if row <= 0 then return

choose case lower(dwo.name)
	case "cnta_prsp_egreso"
		
		select descripcion
			into :ls_desc
		from presupuesto_cuenta
		where cnta_prsp = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no esta activo", StopSign!)
			this.object.cnta_prsp_egreso		[row] = ls_null
			this.object.desc_cnta_prsp_egreso[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp_egreso[row] = ls_desc

	case "cnta_prsp_ingreso"
		
		select descripcion
			into :ls_desc
		from presupuesto_cuenta
		where cnta_prsp = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('Error', "Cuenta Presupuestal no existe o no esta activo", StopSign!)
			this.object.cnta_prsp_ingreso			[row] = ls_null
			this.object.desc_cnta_prsp_ingreso	[row] = ls_null
			return 1
		end if

		this.object.desc_cnta_prsp_ingreso[row] = ls_desc
		
end choose

end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw

end event

