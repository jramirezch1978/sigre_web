$PBExportHeader$w_fl040_estruct_nave.srw
forward
global type w_fl040_estruct_nave from w_abc_master_smpl
end type
end forward

global type w_fl040_estruct_nave from w_abc_master_smpl
integer height = 1064
string title = "Asignar Estructuras a una Nave (FL040)"
string menuname = "m_mto_smpl"
end type
global w_fl040_estruct_nave w_fl040_estruct_nave

on w_fl040_estruct_nave.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl040_estruct_nave.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

type dw_master from w_abc_master_smpl`dw_master within w_fl040_estruct_nave
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
string dataobject = "d_abc_estruc_nave_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
choose case lower(as_columna)
		
	case "cod_maquina"
		
		ls_sql = "SELECT cod_maquina AS CODIGO_maquina, " &
				  + "DESC_maq AS DESCRIPCION_maquina " &
				  + "FROM maquina " &
				  + "WHERE FLAG_ESTADO = '1' " &
				  + "and FLAG_MAQ_EQUIPO = 'S' " &
				  + "and cod_origen = '" + gs_origen + "'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.cod_maquina	[al_row] = ls_codigo
			this.object.desc_maq		[al_row] = ls_data
			this.ii_update = 1
		end if

	case "nave"

		ls_sql = "SELECT nave AS CODIGO_nave, " &
				  + "nomb_nave AS descripcion_nave " &
				  + "FROM tg_naves " &
				  + "where flag_estado = '1' " &
				  + "and FLAG_TIPO_FLOTA = 'P'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.nave			[al_row] = ls_codigo
			this.object.nomb_nave	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_data, ls_null

SetNull(ls_null)
this.AcceptText()

choose case lower(dwo.name)
	case "maquina"
		
		select desc_maq
			into :ls_data
		from maquina
		where cod_maquina = :data
		  and flag_estado = '1';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE MÁQUINA NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.cod_maquina	[row] = ls_null
			this.object.desc_maq		[row] = ls_null
			return 1
		end if

		this.object.desc_maq	[row] = ls_data
		
	case "nave"
		
		select nomb_nave
			into :ls_data
		from tg_naves
		where nave = :data
		  and flag_estado = '1'
		  and flag_tipo_flota = 'P';
		
		if SQLCA.SQLCode = 100 then
			Messagebox('FLOTA', "CODIGO DE EMBARCACIÓN NO EXISTE O NO ESTA ACTIVO", StopSign!)
			this.object.nave			[row] = ls_null
			this.object.nomb_nave	[row] = ls_null
			return 1
		end if

		this.object.nomb_nave	[row] = ls_data		
end choose
end event

