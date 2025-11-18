$PBExportHeader$w_fl037_sueldos_fijos.srw
forward
global type w_fl037_sueldos_fijos from w_abc_master_smpl
end type
end forward

global type w_fl037_sueldos_fijos from w_abc_master_smpl
integer width = 2469
integer height = 1052
string title = "Sueldos Fijos de Tripulantes (FL037)"
string menuname = "m_mto_smpl"
boolean maxbox = false
boolean resizable = false
long backcolor = 67108864
end type
global w_fl037_sueldos_fijos w_fl037_sueldos_fijos

on w_fl037_sueldos_fijos.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl037_sueldos_fijos.destroy
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

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl037_sueldos_fijos
event ue_display ( string as_columna,  long al_row )
integer width = 2423
integer height = 824
string dataobject = "d_abc_sueldos_fijos_tbl"
end type

event dw_master::ue_display;boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "concepto"
		
		ls_sql = "SELECT CONCEP AS CODIGO, " &
				  + "DESC_CONCEP AS DESCRIPCION " &
				  + "FROM CONCEPTO " &
				  + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.concepto			[al_row] = ls_codigo
			this.object.desc_concepto	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_trabajador"

		ls_sql = "SELECT cod_trabajador AS CODIGO_trabajador, " &
				  + "nom_trabajador AS nombre_trabajador, " &
				  + "DNI as documento_identidad " &
				  + "FROM vw_pr_trabajador " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_trabajador	[al_row] = ls_codigo
			this.object.nom_tripulante	[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_moneda"

		ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
				  + "descripcion AS descripcion_motorista " &
				  + "FROM moneda " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda	[al_row] = ls_codigo
			this.ii_update = 1
		end if

	case "moneda_tf"

		ls_sql = "SELECT cod_moneda AS CODIGO_moneda, " &
				  + "descripcion AS descripcion_motorista " &
				  + "FROM moneda " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.moneda_tf	[al_row] = ls_codigo
			this.ii_update = 1
		end if

end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'
this.object.cod_usr			[al_row] = gs_user
this.object.salario_mensual[al_row] = 0
this.object.salario_tf		[al_row] = 0
this.object.flag_tf_tt		[al_row] = '0'

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if
end event

event dw_master::keydwn;call super::keydwn;string ls_columna, ls_cadena
integer li_column
long ll_row

// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0

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

event dw_master::itemchanged;call super::itemchanged;string ls_data1, ls_data2, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "cod_trabajador"
		
		select nom_trabajador
			into :ls_data1
		from vw_pr_trabajador
		where cod_trabajador = :data
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE TRABAJADOR NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_trabajador	[row] = ls_null
			this.object.nom_tripulante	[row] = ls_null
			return 1
		end if

		this.object.nom_tripulante		[row] = ls_data1

	case "concepto"
		
		select desc_concep
			into :ls_data1
		from concepto
		where concep = :data
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CONCEPTO DE PLANILLA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.concepto		 [row] = ls_null
			this.object.desc_concepto[row] = ls_null
			return 1
		end if

		this.object.desc_concepto	[row] = ls_data1
		
	case "cod_moneda"
		
		select descripcion
			into :ls_data1
		from moneda
		where cod_moneda = :data
		  and flag_estado 	= '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE MONEDA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_moneda		 [row] = ls_null
			return 1
		end if

end choose
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 2				// columnas de lectrua de este dw
end event

