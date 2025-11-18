$PBExportHeader$w_fl036_ratios_bonif_tripul.srw
forward
global type w_fl036_ratios_bonif_tripul from w_abc_master_smpl
end type
end forward

global type w_fl036_ratios_bonif_tripul from w_abc_master_smpl
integer height = 1064
string title = "Ratios Bonificación Especialidad (FL036)"
string menuname = "m_mto_smpl"
end type
global w_fl036_ratios_bonif_tripul w_fl036_ratios_bonif_tripul

type variables
string is_dolares, is_salir
end variables

forward prototypes
public function integer of_get_param ()
end prototypes

public function integer of_get_param ();// Evalua parametros
string 	ls_mensaje

// busca Parametros iniciales en LOGPARAM
SELECT 	cod_dolares
	INTO 	:is_dolares
FROM logparam
where reckey = '1';

if sqlca.sqlcode = 100 then
	Messagebox( "Error en LOGPARAM", "no ha definido parametros en LOGPARAM")
	return 0
end if

if sqlca.sqlcode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	Messagebox( "Error en LOGPARAM", ls_mensaje)
	return 0
end if

// busca LOGPARAM
if ISNULL( is_dolares ) or TRIM( is_dolares ) = '' then
	Messagebox("Error", "Defina COD_DOLARES en LOGPARAM")
	return 0
end if


return 1
end function

on w_fl036_ratios_bonif_tripul.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl036_ratios_bonif_tripul.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event closequery;call super::closequery;if is_salir = 'S' then
	close (this)
end if
end event

event ue_open_pre;call super::ue_open_pre;ib_log = TRUE

if of_get_param() = 0 then 
   is_salir = 'S'
	post event closequery()   
	return
end if
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if

dw_master.of_set_flag_replicacion()
end event

type dw_master from w_abc_master_smpl`dw_master within w_fl036_ratios_bonif_tripul
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_abc_ratios_bonif_tripul_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "nave"
		
		ls_sql = "SELECT nave AS codigo_nave, " &
				  + "nomb_nave AS nombre_nave " &
				  + "FROM tg_naves " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "and flag_tipo_flota = 'P'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.nave		[al_row] = ls_codigo
			this.object.nomb_nave[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cargo_tripulante"

		ls_sql = "SELECT CARGO_TRIPULANTE AS cod_cargo, " &
				  + "DESCR_CARGO AS descripcion_cargo " &
				  + "FROM fl_cargo_tripulantes " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cargo_tripulante	[al_row] = ls_codigo
			this.object.descr_cargo			[al_row] = ls_data
			this.ii_update = 1
		end if

	case "cod_moneda"

		ls_sql = "SELECT COD_MONEDA AS codigo_moneda, " &
				  + "DESCRIPCION AS descripcion_moneda " &
				  + "FROM moneda " &
				  + "where flag_estado = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_moneda[al_row] = ls_codigo
			this.ii_update = 1
		end if		
		
end choose

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
	case "nave"
		
		select nomb_nave
			into :ls_data1
		from tg_naves
		where nave = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE NAVE NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.nave		[row] = ls_null
			this.object.nom_nave	[row] = ls_null
			return 1
		end if

		this.object.nomb_nave	[row] = ls_data1
		
	case "cargo_tripulante"
		
		select descr_cargo
			into :ls_data1
		from fl_cargo_tripulantes
		where cargo_tripulante = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CARGO DE TRIPULANTE NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cargo_tripulante	[row] = ls_null
			this.object.descr_cargo			[row] = ls_null
			return 1
		end if

		this.object.descr_cargo	[row] = ls_data1

	case "cod_moneda"
		
		select descripcion
			into :ls_data1
		from moneda
		where cod_moneda = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE MONEDA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_moneda	[row] = ls_null
			return 1
		end if
end choose
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.nro_item	 [al_row] = f_numera_item(dw_master)
this.object.rango_ini [al_row] = 0
this.object.rango_fin [al_row] = 0
this.object.ratio		 [al_row] = 0
this.object.cod_moneda[al_row] = is_dolares
end event

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
ii_ck[2] = 3
ii_ck[3] = 5

end event

