$PBExportHeader$w_ma019_agruphor.srw
forward
global type w_ma019_agruphor from w_abc_master_smpl
end type
end forward

global type w_ma019_agruphor from w_abc_master_smpl
string title = "Agruphores de Maquinas (MA019)"
string menuname = "m_mantto_smpl_ret"
end type
global w_ma019_agruphor w_ma019_agruphor

type variables
string 	is_und_hr
end variables

on w_ma019_agruphor.create
call super::create
if this.MenuName = "m_mantto_smpl_ret" then this.MenuID = create m_mantto_smpl_ret
end on

on w_ma019_agruphor.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

idw_1.Retrieve(gs_origen)

SetNull(is_und_hr)

select und_hr
	into :is_und_hr
from prod_param
where reckey = '1';

if is_und_hr = '' or IsNull(is_und_hr) then
	MessageBox('Aviso', 'No ha definido la unidad horas (und_hr) en prod_param', StopSign!)
	return
end if
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

if f_row_Processing(dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
end if
dw_master.of_set_flag_replicacion( )
end event

event ue_query_retrieve;//Ancestror Script Override
dw_master.Retrieve(gs_origen)
end event

event ue_modify;call super::ue_modify;dw_master.object.agruphor.protect = '1'
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma019_agruphor
event ue_display ( string as_columna,  long al_row )
string dataobject = "d_agruphor_tbl"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql
str_seleccionar lstr_seleccionar

choose case lower(as_columna)
		
	case "und"
		
		ls_sql = "SELECT UND AS CODIGO, " &
				  + "DESC_UNIDAD AS DESCRIPCION " &
				  + "FROM UNIDAD " 
				 
		lb_ret = f_lista(ls_sql, ls_codigo, &
					ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und			[al_row] = ls_codigo
			this.object.desc_unidad	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;string ls_desc_und

this.object.flag_estado	[al_row] = '1'
this.object.origen		[al_row] = gs_origen

if is_und_hr <> '' or not IsNull(is_und_hr) then

	select desc_unidad
		into :ls_desc_und
	from unidad
	where und = :is_und_hr;
	
	this.object.desc_unidad [al_row] = ls_desc_und
	this.object.und 			[al_row] = is_und_hr
	
end if
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

event dw_master::itemchanged;call super::itemchanged;string ls_codigo, ls_data
this.AcceptText()

if row <= 0 then
	return
end if

choose case lower(dwo.name)
	case "und"
		
		SetNull(ls_data)
		select desc_unidad
			into :ls_data
		from unidad
		where und = :data;
		
		if IsNull(ls_data) or ls_data = "" then
			Messagebox('Aviso', "Codigo de Unidad no existe", StopSign!)
			SetNull(ls_data)
			this.object.und			[row] = ls_data
			this.object.desc_unidad	[row] = ls_data
			return 1
		end if

		this.object.desc_unidad		[row] = ls_data
		
end choose

end event

