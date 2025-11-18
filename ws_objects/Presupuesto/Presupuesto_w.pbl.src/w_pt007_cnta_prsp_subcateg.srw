$PBExportHeader$w_pt007_cnta_prsp_subcateg.srw
forward
global type w_pt007_cnta_prsp_subcateg from w_abc_master_smpl
end type
type st_campo from statictext within w_pt007_cnta_prsp_subcateg
end type
type dw_text from datawindow within w_pt007_cnta_prsp_subcateg
end type
end forward

global type w_pt007_cnta_prsp_subcateg from w_abc_master_smpl
integer width = 2638
integer height = 1600
string title = "Cnta Prsp Vs Sub Categ (PT007)"
string menuname = "m_save_modif_exit"
st_campo st_campo
dw_text dw_text
end type
global w_pt007_cnta_prsp_subcateg w_pt007_cnta_prsp_subcateg

type variables
string is_col, is_type

end variables

on w_pt007_cnta_prsp_subcateg.create
int iCurrent
call super::create
if this.MenuName = "m_save_modif_exit" then this.MenuID = create m_save_modif_exit
this.st_campo=create st_campo
this.dw_text=create dw_text
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_campo
this.Control[iCurrent+2]=this.dw_text
end on

on w_pt007_cnta_prsp_subcateg.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_campo)
destroy(this.dw_text)
end on

event ue_open_pre;call super::ue_open_pre;f_centrar( this )
ii_pregunta_delete = 1 
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

type dw_master from w_abc_master_smpl`dw_master within w_pt007_cnta_prsp_subcateg
event ue_display ( string as_columna,  long al_row )
integer x = 0
integer y = 104
integer width = 2551
integer height = 1240
string dataobject = "d_abc_cnta_prsp_subcateg"
end type

event dw_master::ue_display(string as_columna, long al_row);boolean lb_ret
string ls_codigo, ls_data, ls_sql

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
		
end choose

end event

event dw_master::ue_insert_pre;call super::ue_insert_pre;this.object.flag_estado[al_row] = '1'

end event

event dw_master::itemerror;call super::itemerror;Return 1
end event

event dw_master::rowfocuschanged;call super::rowfocuschanged;f_select_current_row(this)
end event

event dw_master::doubleclicked;call super::doubleclicked;string 	ls_columna

IF upper(right( dwo.name, 2 )) = '_T' THEN
	is_col 		= mid(dwo.name, 1, len(lower(dwo.name)) -2)
	st_campo.text = "Orden: " + is_col
	
	is_type = LEFT( this.Describe(is_col + ".ColType"),1)	
	dw_text.reset()
	dw_text.InsertRow(0)
	dw_text.SetFocus()
	return
END IF

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

type st_campo from statictext within w_pt007_cnta_prsp_subcateg
integer x = 9
integer y = 8
integer width = 713
integer height = 76
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_text from datawindow within w_pt007_cnta_prsp_subcateg
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 731
integer y = 4
integer width = 1449
integer height = 80
integer taborder = 10
boolean bringtotop = true
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;Long ll_row

if keydown(keyuparrow!) then		// Anterior
	dw_master.scrollpriorRow()
elseif keydown(keydownarrow!) then	// Siguiente
	dw_master.scrollnextrow()	
end if
ll_row = dw_text.Getrow()


end event

event constructor;// Adiciona registro en dw1
Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer li_longitud
string ls_item, ls_ordenado_por, ls_comando
Long ll_fila

SetPointer(hourglass!)

if TRIM( is_col ) <> '' THEN
	ls_item = upper( this.GetText() )

	li_longitud = len( ls_item )
	if li_longitud > 0 then		// si ha escrito algo
	   
		IF UPPER( is_type) = 'D' then
			ls_comando = "UPPER(LEFT(STRING(" + is_col +")," + String(li_longitud) + "))='" + ls_item + "'"
		ELSEIF UPPER( is_type) = 'C' then
		   ls_comando = "UPPER(LEFT(" + is_col +"," + String(li_longitud) + "))='" + ls_item + "'"
		END IF	

		ll_fila = dw_master.find(ls_comando, 1, dw_master.rowcount())
		if ll_fila <> 0 then		// la busqueda resulto exitosa
			dw_master.selectrow(0, false)
			dw_master.selectrow(ll_fila,true)
			dw_master.scrolltorow(ll_fila)
		end if
		this.setFocus()
	End if	
end if	
SetPointer(arrow!)
end event

