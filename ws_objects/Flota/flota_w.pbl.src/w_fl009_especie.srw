$PBExportHeader$w_fl009_especie.srw
forward
global type w_fl009_especie from w_abc_master_smpl
end type
end forward

global type w_fl009_especie from w_abc_master_smpl
integer width = 2501
integer height = 1216
string title = "Mantenimiento de especies (FL009)"
string menuname = "m_mto_smpl"
boolean maxbox = false
long backcolor = 67108864
end type
global w_fl009_especie w_fl009_especie

on w_fl009_especie.create
call super::create
if this.MenuName = "m_mto_smpl" then this.MenuID = create m_mto_smpl
end on

on w_fl009_especie.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;string ls_codigo
ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

select especie
	into :ls_codigo
from (select * from tg_especies order by especie)
where rownum = 1;

dw_master.Retrieve(ls_codigo)
end event

event ue_update_pre;call super::ue_update_pre;dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_fl009_especie
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 0
integer width = 2437
integer height = 960
string dataobject = "d_especie_ff"
boolean hscrollbar = false
boolean vscrollbar = false
boolean livescroll = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
long ll_count
str_seleccionar lstr_seleccionar

choose case upper(as_columna)
		
	case "COD_ART"
		
		ls_sql = "SELECT COD_ART AS CODIGO, " &
				 + "NOM_ARTICULO AS DESCRIPCION " &
				 + "FROM ARTICULO " &
				 + "WHERE FLAG_ESTADO = '1'"
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.object.cod_art[al_row]   = ls_codigo
			this.object.nom_articulo[al_row] = ls_data
		
			this.ii_update = 1
		end if

	case "ESPECIE"
		
		parent.event dynamic ue_update_request()

		ls_sql = "SELECT ESPECIE AS CODIGO, " &
				 + "DESCR_ESPECIE AS DESCRIPCION " &
				 + "FROM TG_ESPECIES "
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '2')
		
		if ls_codigo <> '' then
			this.Retrieve(ls_codigo)
			this.ii_protect = 0
			this.of_protect()
			this.ii_update = 0
		end if
		
end choose
end event

event dw_master::constructor;call super::constructor;is_dwform =  'form'   // tabular,grid,form
end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_especie

declare lc_especie cursor for
	select max(substr(especie,3,8)) from tg_especies where substr(especie,1,2) = :gs_origen;

open lc_especie;
fetch lc_especie into :ls_especie;
close lc_especie;

if isnull(ls_especie) then
	ls_especie = gs_origen+'000001'
else
	ls_especie = gs_origen+right(string(integer(ls_especie)+1,'000000'),6)
end if

this.object.especie[this.rowcount()] = ls_especie
end event

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 
str_seleccionar lstr_seleccionar

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' &
	and upper(dwo.name) <> 'ESPECIE' then RETURN
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

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data, ls_estado

this.AcceptText()

if row <= 0 then
	return
end if

choose case upper(dwo.name)
	case "COD_ART"
		
		ls_codigo = this.object.cod_art[row]

		SetNull(ls_data)
		select nom_articulo
			into :ls_data
		from articulo
		where cod_art = :ls_codigo
		  and flag_estado = '1';
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('FLOTA', "CODIGO DE ARTICULO NO EXISTE O NO ESTA ACTIVO", StopSign!)
			SetNull(ls_codigo)
			this.object.cod_art[row] = ls_codigo
			this.object.nom_articulo[row] = ls_codigo
			return 1
		end if

		this.object.nom_articulo[row] = ls_data
end choose
end event

