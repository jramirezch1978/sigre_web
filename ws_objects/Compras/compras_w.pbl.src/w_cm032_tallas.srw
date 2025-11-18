$PBExportHeader$w_cm032_tallas.srw
forward
global type w_cm032_tallas from w_abc_master_smpl
end type
end forward

global type w_cm032_tallas from w_abc_master_smpl
integer width = 2638
integer height = 1600
string title = "[CM032] Maestro de Tallas de Artículos"
string menuname = "m_mantto_smpl"
end type
global w_cm032_tallas w_cm032_tallas

on w_cm032_tallas.create
call super::create
if this.MenuName = "m_mantto_smpl" then this.MenuID = create m_mantto_smpl
end on

on w_cm032_tallas.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event ue_open_pre;call super::ue_open_pre;ii_pregunta_delete = 1 
end event

event ue_update_pre;call super::ue_update_pre;// Verifica que campos son requeridos y tengan valores
if f_row_Processing( dw_master, "form") <> true then	
	ib_update_check = False
	return
else
	ib_update_check = True
end if
dw_master.of_set_flag_replicacion()

end event

type dw_master from w_abc_master_smpl`dw_master within w_cm032_tallas
event ue_display ( string as_columna,  long al_row )
integer width = 2551
integer height = 1240
string dataobject = "d_abc_articulo_talla_tbl"
end type

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado		[al_row] = '1'

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
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

event dw_master::constructor;call super::constructor;ii_ck[1] = 1				// columnas de lectrua de este dw
end event

