$PBExportHeader$w_ma020_color.srw
forward
global type w_ma020_color from w_abc_master_smpl
end type
end forward

global type w_ma020_color from w_abc_master_smpl
integer height = 1060
string title = "Maestro de Colores (MA020)"
string menuname = "m_mantto_smpl_ret"
end type
global w_ma020_color w_ma020_color

on w_ma020_color.create
call super::create
if this.MenuName = "m_mantto_smpl_ret" then this.MenuID = create m_mantto_smpl_ret
end on

on w_ma020_color.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_lec_mst = 0    //Hace que no se haga el retrieve de dw_master

idw_1.Retrieve()
end event

event ue_update_pre;call super::ue_update_pre;ib_update_check = TRUE

if f_row_Processing(dw_master, "tabular") <> true then	
	ib_update_check = False	
	return
end if
dw_master.of_set_flag_replicacion( )
end event

event ue_query_retrieve;//Ancestror Script Override
idw_1.Retrieve()
end event

type dw_master from w_abc_master_smpl`dw_master within w_ma020_color
string dataobject = "d_color_tbl"
end type

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

