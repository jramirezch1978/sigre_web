$PBExportHeader$u_cst_quick_search.sru
$PBExportComments$busqueda intuitiva
forward
global type u_cst_quick_search from userobject
end type
type cb_ok from commandbutton within u_cst_quick_search
end type
type sle_1 from singlelineedit within u_cst_quick_search
end type
type dw_lista from datawindow within u_cst_quick_search
end type
end forward

global type u_cst_quick_search from userobject
integer width = 914
integer height = 1012
long backcolor = 79741120
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event ue_retorno ( any aa_id,  long al_row )
event resize pbm_size
cb_ok cb_ok
sle_1 sle_1
dw_lista dw_lista
end type
global u_cst_quick_search u_cst_quick_search

type variables
long   il_row = 0, ii_cn = 1
String is_field, is_texto
Any  ia_id
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
this.cb_ok=create cb_ok
this.sle_1=create sle_1
this.dw_lista=create dw_lista
this.Control[]={this.cb_ok,&
this.sle_1,&
this.dw_lista}
end on

on u_cst_quick_search.destroy
destroy(this.cb_ok)
destroy(this.sle_1)
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

type cb_ok from commandbutton within u_cst_quick_search
integer x = 722
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

event clicked;IF il_row < 1 THEN RETURN

//THIS.Default = False

ia_id = dw_lista.object.data.primary.current[il_row, ii_cn]  // determinar llave para leer dws

PARENT.Event ue_retorno(ia_id,il_row)



end event

type sle_1 from singlelineedit within u_cst_quick_search
event key_pressed pbm_keydown
integer x = 9
integer y = 8
integer width = 699
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

event key_pressed;string	ls_tecla
long		ll_row
int		li_longitud

ls_tecla = Char(message.wordparm)

IF message.wordparm = 13 THEN	cb_ok.Event Clicked()	// Tecla Enter

IF message.wordparm = 8 THEN		// Tecla de Retroceso
	li_longitud = Len(is_texto)
	IF li_longitud > 0 THEN is_texto = Left(is_texto, li_longitud -1)		
ELSE
	is_texto = is_texto + Lower(ls_tecla) 			// sumar a lo ya digitado
END IF

IF Len(is_texto) > 0 Then
	ll_row = dw_lista.Find("Lower(" + is_field + ")>=~"" + is_texto + "~"",1, 999999)
	IF ll_row > 0 THEN 
		dw_lista.SetRedraw(FALSE)
		dw_lista.ScrollToRow(ll_row)
		dw_lista.SelectRow(0, FALSE)
		dw_lista.SelectRow(ll_row, TRUE)
		dw_lista.SetRedraw(TRUE)
	ELSE
      Beep(1)							// is_texto no encontro fila
		li_longitud = Len(is_texto)
		IF li_longitud > 0 THEN is_texto = Left(is_texto, li_longitud -1)		
		//	message.processed = true		// Eliminar ultimo caracter
	End IF
ElSE
	dw_lista.SelectRow(0, FALSE)	// Longitud de is_texto = 0, deseleccionar fila
End IF

il_row = ll_row						// Conservar fila seleccionada
	
end event

type dw_lista from datawindow within u_cst_quick_search
integer x = 9
integer y = 116
integer width = 699
integer height = 724
integer taborder = 30
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event clicked;Any la_key

THIS.SelectRow(il_row, FALSE)	

il_row = row

if il_row > 0 Then
	THIS.SelectRow(0,False)
	THIS.SelectRow(il_row, TRUE)
End If


end event

event doubleclicked;IF row = 0 THEN RETURN

cb_ok.TriggerEvent(Clicked!)

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

