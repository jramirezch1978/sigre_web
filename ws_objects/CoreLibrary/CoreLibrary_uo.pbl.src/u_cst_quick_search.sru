$PBExportHeader$u_cst_quick_search.sru
$PBExportComments$busqueda intuitiva
forward
global type u_cst_quick_search from userobject
end type
type st_campo from statictext within u_cst_quick_search
end type
type cb_ok from commandbutton within u_cst_quick_search
end type
type sle_text from singlelineedit within u_cst_quick_search
end type
type dw_lista from datawindow within u_cst_quick_search
end type
end forward

global type u_cst_quick_search from userobject
integer width = 1678
integer height = 944
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_retorno ( any aa_id,  long al_row )
event resize pbm_size
event ue_aceptar ( )
st_campo st_campo
cb_ok cb_ok
sle_text sle_text
dw_lista dw_lista
end type
global u_cst_quick_search u_cst_quick_search

type variables
long   	il_row = 0, ii_cn = 1
integer	ii_sort
String 	is_field, is_texto, is_col, is_dataType
Any  		ia_id
end variables

forward prototypes
public subroutine of_resize (integer ai_newwidth, integer ai_newheight)
public function long of_set_dw (string as_dwname)
public function integer of_sort_lista ()
public subroutine of_set_field (string as_field)
public function integer of_share_lista (datawindow adw_1)
public function integer of_retrieve_lista ()
public subroutine of_protect ()
public subroutine of_set_colnum (integer ai_colnum)
public function integer of_retrieve_lista (any aa_id)
public function any of_get_column_data (long al_row, integer ai_colnum)
public function any of_get_id ()
public function long of_get_row ()
end prototypes

event ue_retorno(any aa_id, long al_row);//w_abc_mastdet.dw_master.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_1.dw_1.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_2.dw_2.ScrollToRow(al_row)
//w_abc_mastdet.tab_1.tabpage_3.dw_3.ScrollToRow(al_row)

//w_abc_mastdet.dw_detail.retrieve(aa_id)
//w_abc_mastdet.dw_detail.il_totdel = 0

end event

event resize;of_resize(newWidth,newHeight)
this.cb_ok.x = newwidth - this.cb_ok.width - 50
this.sle_text.width = newwidth * 0.60

this.sle_text.x = cb_ok.x - this.sle_text.width - 30

this.st_campo.width = this.sle_text.x -30 - this.st_campo.x

end event

event ue_aceptar();IF il_row < 1 THEN RETURN

ia_id = dw_lista.object.data.primary.current[il_row, ii_cn]  // determinar llave para leer dws

this.Event ue_retorno(ia_id, il_row)
end event

public subroutine of_resize (integer ai_newwidth, integer ai_newheight);dw_lista.width = ai_newwidth - dw_lista.x
dw_lista.height = ai_newheight - dw_lista.y

end subroutine

public function long of_set_dw (string as_dwname);Long ll_rc

dw_lista.DataObject = as_dwname

ll_rc = dw_lista.SetTransObject(sqlca)

RETURN ll_rc
end function

public function integer of_sort_lista ();Integer li_rc

dw_lista.SetSort(is_field +" A")
li_rc = dw_lista.Sort()

RETURN li_rc
end function

public subroutine of_set_field (string as_field);is_field = as_field
end subroutine

public function integer of_share_lista (datawindow adw_1);Integer li_rc
Datawindow ldw_master

SetPointer(hourglass!)				// cambiar cursor para lectura de lista

ldw_master = adw_1

li_rc = ldw_master.ShareData (dw_lista)
IF li_rc <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con dw",exclamation!)
END IF

SetNull(ldw_master)

RETURN li_rc
end function

public function integer of_retrieve_lista ();Long ll_rc

ll_rc = dw_lista.Retrieve()

RETURN ll_rc
end function

public subroutine of_protect ();String ls_colname, ls_value
Integer li_totcol, li_x, li_pos

ls_value = '1'
li_totcol = Integer(dw_lista.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_colname = "#" + String(li_x) + ".dbName"
	ls_colname = dw_lista.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	ls_colname = Mid(ls_colname,li_pos + 1)
	ls_colname = ls_colname + ".Protect=" + ls_value
	ls_colname = dw_lista.Modify(ls_colname)
NEXT


end subroutine

public subroutine of_set_colnum (integer ai_colnum);ii_cn = ai_colnum
end subroutine

public function integer of_retrieve_lista (any aa_id);Long ll_rc

dw_lista.SetTransObject(sqlca)
ll_rc = dw_lista.Retrieve(aa_id)

RETURN ll_rc
end function

public function any of_get_column_data (long al_row, integer ai_colnum);Any la_id

la_id = dw_lista.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
end function

public function any of_get_id ();RETURN ia_id
end function

public function long of_get_row ();RETURN il_row
end function

on u_cst_quick_search.create
this.st_campo=create st_campo
this.cb_ok=create cb_ok
this.sle_text=create sle_text
this.dw_lista=create dw_lista
this.Control[]={this.st_campo,&
this.cb_ok,&
this.sle_text,&
this.dw_lista}
end on

on u_cst_quick_search.destroy
destroy(this.st_campo)
destroy(this.cb_ok)
destroy(this.sle_text)
destroy(this.dw_lista)
end on

event constructor;of_resize(THIS.width,THIS.height)

//uo_1.of_set_dw('d_product_name_tbl')
//uo_1.of_set_field('name')
//dw_master.SetTransObject(SQLCA)
//uo_1.of_share_lista(dw_master)
//dw_master.Retrieve()
//uo_1.of_sort_lista()

end event

type st_campo from statictext within u_cst_quick_search
integer x = 14
integer y = 8
integer width = 553
integer height = 96
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Buscar por:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within u_cst_quick_search
integer x = 1463
integer y = 8
integer width = 187
integer height = 96
integer taborder = 20
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
end type

event clicked;parent.event ue_aceptar( )
end event

type sle_text from singlelineedit within u_cst_quick_search
event key_up pbm_keyup
integer x = 603
integer y = 8
integer width = 850
integer height = 96
integer taborder = 10
integer textsize = -9
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string pointer = "arrow!"
long textcolor = 33554432
boolean autohscroll = false
borderstyle borderstyle = stylelowered!
end type

event key_up;string	ls_ordenado_por, ls_comando
long		ll_row, ll_fila
Integer 	li_longitud

SetPointer(hourglass!)

if is_col = '' or is_dataType = '' then
	MessageBox('Error', 'Debe seleccionar una columna primero')
	this.text = ''
	return
end if

IF key = KeyEnter! THEN	return //cb_ok.Event Clicked()	// Tecla Enter

//si presiona la tecla hacia abajo entonces recorro los resultados
if key = KeyDownArrow!  or key = KeyUpArrow! then
	
	if dw_lista.RowCount() = 0 then return
	
	il_row = dw_lista.GetRow()
	
	if key = KeyDownArrow! then
		if il_row < dw_lista.RowCount() then il_row++
	else
		if il_row > 0 then il_row --
	end if
	
	dw_lista.setRow(il_row)
	dw_lista.scrolltorow( il_row )
	dw_lista.selectrow( 0, false )
	dw_lista.Selectrow( il_row, true)

	return
end if

is_texto = this.text 			

//MessageBox('', is_texto)

IF TRIM(is_col) <> '' and len(is_texto) > 0 THEN
	li_longitud = len( is_texto )
	
	if left(is_dataType,4) = 'char' THEN 
		ls_comando = "lower(LEFT(" + is_col +"," + String(li_longitud) + "))='" + lower(is_texto) + "'"
	elseif left(is_dataType,4) = 'date' then
		ls_comando = "string(" + is_col +",'dd/mm/yyyy')='" + is_texto + "'"
	else
		ls_comando = is_col+ " = " + is_texto 
	end if
	
	ll_fila = dw_lista.find(ls_comando, 1, dw_lista.rowcount())
	
	if ll_fila <> 0 then		// la busqueda resulto exitosa
		dw_lista.selectrow(0, false)
		dw_lista.selectrow(ll_fila,true)
		dw_lista.scrolltorow(ll_fila)
		dw_lista.setRow(ll_fila)
		il_Row = ll_fila
	ELSE
		Beep(1)							// is_texto no encontro fila
	end if
end if	

SetPointer(arrow!)

il_row = ll_row						// Conservar fila seleccionada
	
end event

type dw_lista from datawindow within u_cst_quick_search
event ue_column_sort ( )
integer x = 9
integer y = 116
integer width = 1385
integer height = 724
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event ue_column_sort();Integer li_pos, li_len
String  ls_column , ls_setsort, ls_name

ls_column = THIS.GetObjectAtPointer()
li_pos = pos(upper(ls_column),'~t')
ls_name = mid(ls_column, 1, li_pos - 1)

IF Lower(Right(ls_name, 2)) <> '_t' THEN RETURN

li_len = len(ls_name) - 2
ls_setsort = mid(ls_column, 1, li_len )

IF ii_sort = 0 THEN
	ii_sort = 1
	ls_setsort = trim(ls_setsort) + ' A'
ELSE
	ii_sort = 0
	ls_setsort = trim(ls_setsort) + ' D'
END IF

THIS.setsort(ls_setsort)
THIS.sort()

//Recreamos los grupos, solamente si se ha hecho click en la cabecera
this.GroupCalc()
	


end event

event clicked;Any la_key

THIS.SelectRow(il_row, FALSE)	

il_row = row

if il_row > 0 Then
	THIS.SelectRow(0,False)
	THIS.SelectRow(il_row, TRUE)
	parent.event ue_aceptar( )
End If


end event

event doubleclicked;Integer li_pos, li_col
String  ls_column , ls_report, ls_color, ls_col_tipo
Long ll_row


li_col = this.GetColumn()
ls_column = lower(dwo.name)

IF right(ls_column,2) = "_t" THEN
	is_col = UPPER( left(ls_column, len(ls_column) - 2) )	
	
	ls_column = is_col + "_t.text"
	ls_color = is_col + "_t.Background.Color = 255"
	ls_col_tipo = is_col+'.coltype' 
	is_dataType = this.Describe(ls_col_tipo)
	
	if is_dataType = '!' then
		MessageBox('Error', 'Error en tipo de dato. Comando: ' + ls_col_tipo)
		return
	end if

	st_campo.text = "Buscar por: " + Trim(is_col)
	
	This.SelectRow(0, False)
	parent.sle_text.text = ""
	parent.sle_text.setfocus( )
	
END IF

if row = 0 then
	THIS.Event ue_column_sort()
else
	parent.event ue_aceptar( )
end if
end event

event dberror;String	ls_msg, ls_crlf

ls_crlf = char(13) + char(10)

ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
ls_msg += 'SQLDBCode: ' + String(SQLCA.SQLDBCode) + ls_crlf
ls_msg += 'SQLErrText: ' + SQLCA.SQLErrText + ls_crlf
ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
ls_msg += 'UserID: ' + SQLCA.UserID

messagebox("dberror", ls_msg, StopSign!)
end event

event rowfocuschanged;this.Selectrow( 0, false)
this.SelectRow( currentRow, true)
il_row = currentRow

parent.event ue_aceptar( )
end event

