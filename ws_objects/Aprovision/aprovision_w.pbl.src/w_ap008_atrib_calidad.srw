$PBExportHeader$w_ap008_atrib_calidad.srw
forward
global type w_ap008_atrib_calidad from w_abc_master_smpl
end type
end forward

global type w_ap008_atrib_calidad from w_abc_master_smpl
integer width = 2080
integer height = 1424
string title = "Atributos de Calidad (AP008)"
string menuname = "m_mantto_smpl"
boolean resizable = false
end type
global w_ap008_atrib_calidad w_ap008_atrib_calidad

on w_ap008_atrib_calidad.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_ap008_atrib_calidad.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1   // 1 = si pregunta, 0 = no pregunta (default)



//Desactiva la opcion buscar del menu de tablas  //
this.MenuId.item[1].item[1].item[1].enabled = false
this.MenuId.item[1].item[1].item[1].visible = false
this.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = true

if f_row_processing( dw_master, 'tabular') = false then
	ib_update_check = false
	return
end if


end event

type dw_master from w_abc_master_smpl`dw_master within w_ap008_atrib_calidad
event ue_display ( string as_columna,  long al_row )
integer y = 4
integer width = 2053
integer height = 1252
string dataobject = "d_calidad_atributo_tbl"
boolean hscrollbar = false
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

choose case lower(as_columna)
	case "und"
		ls_sql = "Select und as codigo, " &
					+ " desc_unidad as descripcion " &
					+ "from unidad"

		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
		
		if ls_codigo <> '' then
			this.object.und			[al_row] = ls_codigo
			this.object.desc_unidad	[al_row] = ls_data
			this.ii_update = 1
		end if
		
end choose



end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;//long ll_rows, ll_i, ll_atrib, ll_tmp
//
//ll_rows = this.RowCount()
//
//ll_atrib = 0
//for ll_i = 1 to ll_rows
//	ll_tmp = long( this.object.atributo[ll_i] )
//	if ll_tmp >= ll_atrib then
//		ll_atrib = ll_tmp
//	end if
//next
//
//ll_atrib ++
//
//this.object.atributo[al_row] = string(ll_atrib, '0000')
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

event dw_master::doubleclicked;call super::doubleclicked;string ls_columna
long ll_row 

this.AcceptText()
If this.Describe(dwo.Name + ".Protect") = '1' then RETURN
ll_row = row

if row > 0 then
	ls_columna = upper(dwo.name)
	this.event dynamic ue_display(ls_columna, ll_row)
end if

end event

event dw_master::itemerror;call super::itemerror;return 1
end event

event dw_master::itemchanged;call super::itemchanged;string ls_desc, ls_null
SetNull(ls_null)

this.AcceptText()

choose case lower(dwo.name)
	case "und"
		select desc_unidad
			into :ls_desc
		from unidad
		where und = :data;
		
		if sqlca.sqlcode = 100 then
			messagebox(parent.title, 'Codigo de unidad no existe')
			this.object.und			[row] = ls_null
			this.object.desc_unidad	[row] = ls_null
			return 1
		end if
		
		this.object.desc_unidad[row] = ls_desc
end choose
end event

event dw_master::getfocus;call super::getfocus;parent.MenuId.item[1].item[1].item[1].enabled = false

parent.MenuId.item[1].item[1].item[1].visible = false

parent.MenuId.item[1].item[1].item[1].ToolbarItemvisible = false

end event

