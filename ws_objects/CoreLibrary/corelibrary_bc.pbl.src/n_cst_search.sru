$PBExportHeader$n_cst_search.sru
forward
global type n_cst_search from userobject
end type
type st_campo from statictext within n_cst_search
end type
type dw_search from datawindow within n_cst_search
end type
type cb_buscar from commandbutton within n_cst_search
end type
type ddlb_opcion from dropdownlistbox within n_cst_search
end type
end forward

global type n_cst_search from userobject
integer width = 2939
integer height = 84
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_buscar ( )
event ue_resize pbm_size
event ue_post_editchanged ( )
st_campo st_campo
dw_search dw_search
cb_buscar cb_buscar
ddlb_opcion ddlb_opcion
end type
global n_cst_search n_cst_search

type variables
u_dw_abc 			idw_master, idw_detail
u_dw_cns				idw_cns_master, idw_cns_detail
u_dw_list_tbl		idw_lista
n_cst_utilitario	invo_util
String				is_busqueda_x_palabras, is_filter_or_find = '0'  //0= Filtro, 1= Find
String				is_parametro = "SELECTION_UO_SEARCH", is_selection
end variables

forward prototypes
public subroutine of_set_dw (u_dw_abc adw_master)
public subroutine of_set_dw (u_dw_cns adw_master)
public subroutine of_set_dw_cns (u_dw_cns adw_master, u_dw_cns adw_detail)
public subroutine of_set_dw (u_dw_abc adw_master, u_dw_abc adw_detail)
public function string of_get_filtro ()
public subroutine set_focus_buscar ()
public subroutine set_focus_dw ()
public subroutine of_set_dw_cns (u_dw_cns adw_master)
public subroutine of_set_filter_or_find (string as_valor)
public subroutine of_clear_filtro ()
public subroutine of_set_filtro (string as_texto, integer ii_opcion)
public subroutine of_set_dw (u_dw_list_tbl adw_lista)
end prototypes

event ue_resize;cb_buscar.x = newWidth - cb_buscar.width
dw_search.width = cb_buscar.x - dw_search.x
end event

public subroutine of_set_dw (u_dw_abc adw_master);this.idw_master = adw_master
end subroutine

public subroutine of_set_dw (u_dw_cns adw_master);
end subroutine

public subroutine of_set_dw_cns (u_dw_cns adw_master, u_dw_cns adw_detail);this.idw_cns_master = adw_master
this.idw_cns_detail = adw_detail
end subroutine

public subroutine of_set_dw (u_dw_abc adw_master, u_dw_abc adw_detail);this.idw_master = adw_master
this.idw_detail = adw_detail
end subroutine

public function string of_get_filtro ();String 	ls_dato
Integer	li_opcion

if upper(ddlb_opcion.Text) = 'COMIENZA' then
	li_opcion = 1
else
	li_opcion = 2
end if


dw_search.AcceptText()
ls_dato = trim(dw_search.object.campo [1]) 

if IsNull(ls_dato) then 
	ls_Dato = '%'
	li_opcion = 1
end if

if li_opcion = 1 then
	ls_dato = ls_dato + '%'
else
	ls_dato = '%' + ls_dato + '%'
end if

return ls_dato


end function

public subroutine set_focus_buscar ();cb_buscar.setFocus( )
end subroutine

public subroutine set_focus_dw ();dw_search.setFocus( )
dw_search.setColumn("campo")
end subroutine

public subroutine of_set_dw_cns (u_dw_cns adw_master);this.idw_cns_master = adw_master

end subroutine

public subroutine of_set_filter_or_find (string as_valor);is_filter_or_find = as_valor
end subroutine

public subroutine of_clear_filtro ();dw_search.object.campo [1] = ''
end subroutine

public subroutine of_set_filtro (string as_texto, integer ii_opcion);if not IsNull(idw_master) and IsValid(idw_master) then
	if is_filter_or_find = '0' then
		idw_master.of_filtrar(as_texto, ii_opcion)
	else
		idw_master.of_find(as_texto, ii_opcion)
	end if
	
	if not IsNull(idw_detail) and IsValid(idw_detail) then
		idw_detail.Reset()
	end if
	
	if idw_master.RowCount() > 0 then
		if is_filter_or_find = '0' then
			idw_master.setRow(1)
			idw_master.SelectRow(0, false)
			idw_master.SelectRow(1, true)
		
			idw_master.post event ue_output(1)
		elseif idw_master.getRow() > 0 then
			idw_master.post event ue_output(idw_master.getRow())
		end if
	end if
end if


if not IsNull(idw_cns_master) and IsValid(idw_cns_master) then
	
	if is_filter_or_find = '0' then
		idw_cns_master.of_filtrar(as_texto, ii_opcion)
	else
		idw_cns_master.of_find(as_texto, ii_opcion)
	end if
	
	
	if not IsNull(idw_cns_detail) and IsValid(idw_cns_detail) then
		idw_cns_detail.Reset()
	end if
	
	if idw_cns_master.RowCount() > 0 then
		if is_filter_or_find = '0' then
			idw_cns_master.setRow(1)
			idw_cns_master.SelectRow(0, false)
			idw_cns_master.SelectRow(1, true)
		
			idw_cns_master.post event ue_output(1)
		elseif idw_cns_master.getRow() > 0 then
			idw_cns_master.post event ue_output(idw_cns_master.getRow())
		end if
		
	end if
end if

if not IsNull(idw_lista) and IsValid(idw_lista) then
	if is_filter_or_find = '0' then
		idw_lista.of_filtrar(as_texto, ii_opcion)
	else
		idw_lista.of_find(as_texto, ii_opcion)
	end if
	
	if idw_lista.RowCount() > 0 then
		if is_filter_or_find = '0' then
			idw_lista.setRow(1)
			idw_lista.SelectRow(0, false)
			idw_lista.SelectRow(1, true)
		
			idw_lista.post event ue_output(1)
		elseif idw_lista.getRow() > 0 then
			idw_lista.post event ue_output(idw_lista.getRow())
		end if
	end if
end if

end subroutine

public subroutine of_set_dw (u_dw_list_tbl adw_lista);this.idw_lista = adw_lista
end subroutine

on n_cst_search.create
this.st_campo=create st_campo
this.dw_search=create dw_search
this.cb_buscar=create cb_buscar
this.ddlb_opcion=create ddlb_opcion
this.Control[]={this.st_campo,&
this.dw_search,&
this.cb_buscar,&
this.ddlb_opcion}
end on

on n_cst_search.destroy
destroy(this.st_campo)
destroy(this.dw_search)
destroy(this.cb_buscar)
destroy(this.ddlb_opcion)
end on

event constructor;
try 
	
	is_selection = invo_util.of_get_config(is_parametro, "-1")
	
	IF is_selection = "-1" then
		
		is_busqueda_x_palabras = gnvo_app.of_get_parametro("BUSQUEDA_X_PALABRA", "0")
	
		if is_busqueda_x_palabras = "1" then
			ddlb_opcion.selectitem(3)
		else
			ddlb_opcion.selectitem(1)
		end if
		
	else
		
		ddlb_opcion.selectitem(Long(is_selection))
		
	end if

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, "Error para obtener parametro")
end try


end event

type st_campo from statictext within n_cst_search
integer y = 4
integer width = 251
integer height = 76
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
string text = "Buscar: "
alignment alignment = right!
boolean focusrectangle = false
end type

type dw_search from datawindow within n_cst_search
event ue_tecla pbm_dwnkey
event dwnenter pbm_dwnprocessenter
integer x = 832
integer y = 4
integer width = 1815
integer height = 76
integer taborder = 20
string dataobject = "d_campo"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event ue_tecla;//Long 	ll_row
//
//if key = KeyUpArrow! then		// Anterior
//	if dw_master.RowCount() > 0 then
//		dw_master.scrollpriorRow()
//	end if
//elseif key = KeyDownArrow! then	// Siguiente
//	if dw_master.RowCount() > 0 then
//		dw_master.scrollnextrow()	
//	end if
//end if
//ll_row = dw_master.Getrow()
//
//dw_master.SetRow(ll_row)
//f_select_current_row(dw_master)
//
//if key = KeyUpArrow! or key = KeyDownArrow! then
//
//	IF UPPER( LEFT(is_type,4) ) = 'NUMB' OR UPPER( LEFT(is_type,4) ) = "DECI" then
//		dw_1.object.campo[1] = String( dw_master.GetItemNumber(ll_row, is_col) )
//	ELSEIF UPPER( LEFT(is_type,4) ) = 'CHAR' then
//		dw_1.object.campo[1] = dw_master.GetItemString(ll_row, is_col)
//	ELSEIF UPPER( is_type ) = 'DATE' then
//		dw_1.object.campo[1] = String( dw_master.GetItemDate(ll_row, is_col), 'dd/mm/yyyy' )
//	ELSEIF UPPER( is_type ) = 'DATETIME' then
//		dw_1.object.campo[1] = String( dw_master.GetItemDateTime(ll_row, is_col), 'dd/mm/yyyy' )
//	END IF		
//end if


end event

event dwnenter;//Send(Handle(this),256,9,Long(0,0))
//dw_master.triggerevent(doubleclicked!)
parent.post event ue_buscar()
return 1
end event

event constructor;Long ll_reg

ll_reg = this.insertrow(0)


end event

event editchanged;// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

string 	ls_texto
Integer	li_opcion

//ls_item = upper( this.GetText() )
ls_texto = upper(trim(data))

if upper(ddlb_opcion.Text) = 'COMIENZA' then
	li_opcion = 1
elseif upper(ddlb_opcion.Text) = 'CONTIENE' then
	li_opcion = 2
else
	li_opcion = 3	//Busqueda por palabras
end if

of_set_filtro(ls_texto, li_opcion)


parent.post event ue_post_editchanged()
this.setFocus()
end event

type cb_buscar from commandbutton within n_cst_search
integer x = 2651
integer y = 4
integer width = 283
integer height = 76
integer taborder = 10
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Buscar"
end type

event clicked;Parent.event ue_buscar()

end event

type ddlb_opcion from dropdownlistbox within n_cst_search
integer x = 265
integer width = 562
integer height = 352
integer taborder = 10
integer textsize = -7
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean sorted = false
string item[] = {"Comienza","Contiene","Buscar x palabra"}
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;try 
	is_selection = string(index)

	invo_util.of_set_config(is_parametro, is_selection)
	
catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Exception al seleccionar la opción')
end try

end event

