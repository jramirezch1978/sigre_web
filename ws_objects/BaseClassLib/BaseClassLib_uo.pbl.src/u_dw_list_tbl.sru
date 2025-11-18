$PBExportHeader$u_dw_list_tbl.sru
$PBExportComments$datawindows para listas de seleccion
forward
global type u_dw_list_tbl from datawindow
end type
end forward

global type u_dw_list_tbl from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_column_sort ( )
event ue_output ( long al_row )
event ue_constructor ( )
event ue_filter ( )
event ue_sort ( )
event ue_selected_row ( )
event ue_selected_row_pre ( )
event ue_selected_row_pos ( long al_row )
event ue_lbuttonup pbm_dwnlbuttonup
event ue_retrieve_det ( long al_row )
event ue_retrieve_det_pos ( any aa_id[] )
event ue_val_param ( )
event ue_conversion ( )
end type
global u_dw_list_tbl u_dw_list_tbl

type variables
Integer   ii_sort = 0, ii_ss = 1
Integer   ii_ck[], ii_dk[]
String     is_ck[],is_dk[]
Long      il_row, il_lastrow
boolean ib_action_on_buttonup = false

end variables

forward prototypes
public function integer of_selected_item_delete ()
public function long of_item_insert ()
public function integer of_share_lista (datawindow adw_1)
public subroutine of_protect ()
public function any of_get_column_data (long al_row, integer ai_colnum)
public function integer of_set_shift_row (long al_row)
public function integer of_sort_lista ()
public subroutine of_color (long al_value)
public function integer of_column_text_color (string as_field, long al_color)
public function integer of_column_end (string as_field)
public subroutine of_set_split (integer ai_x)
public subroutine of_row_find (string as_expresion, ref long al_row[])
public function boolean isvaliddataobject ()
end prototypes

event ue_column_sort;Integer li_pos, li_len
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
	


end event

event ue_output(long al_row);//THIS.EVENT ue_retrieve_det(al_row)
//dw_detaol.il_totdel = 0
//dw_detail.ScrollToRow(al_row)
//dw_detail.il_row = al_row

end event

event ue_filter;string	ls_filter

SetNull (ls_filter)
THIS.SetFilter (ls_filter)
THIS.Filter()
end event

event ue_sort;string	ls_sort

SetNull (ls_sort)
THIS.SetSort (ls_sort)
THIS.Sort()
end event

event ue_selected_row;Long	ll_row, ll_y

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.EVENT ue_selected_row_pos(ll_row)
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.SelectRow(0,False)
end event

event ue_lbuttonup;If ib_action_on_buttonup Then
	ib_action_on_buttonup = false
	If Keydown(KeyControl!) then
		this.selectrow(il_lastrow,FALSE)
	Else
		this.SelectRow(0,FALSE)
		this.SelectRow(il_lastrow,TRUE)
	End If
	il_lastrow = 0
End If

end event

event ue_retrieve_det;Any		la_id[]
Integer	li_x

FOR li_x = 1 TO UpperBound(ii_dk)
	la_id[li_x] = THIS.object.data.primary.current[al_row, ii_dk[li_x]]
NEXT

THIS.EVENT ue_retrieve_det_pos(la_id)
end event

event ue_retrieve_det_pos;//dw_detail.retrieve(aa_id[1],aa_id[2])
end event

event ue_val_param;IF UpperBound(ii_ck) < 1 THEN
	MessageBox('Error ' + THIS.ClassName(), 'ii_ck no tiene valor')
END IF


end event

event ue_conversion;Integer	li_x

FOR li_x = 1 to UpperBound(is_ck)
	ii_ck[li_x] = Integer(THIS.Describe(is_ck[li_x] + '.ID'))
	IF ii_ck[li_x] < 1 THEN MessageBox('Error', 'Llave is_ck[' + String(li_x) + '] = ' + is_ck[li_x]) 
NEXT


FOR li_x = 1 to UpperBound(is_dk)
	ii_dk[li_x] = Integer(THIS.Describe(is_dk[li_x] + '.ID'))
	IF ii_dk[li_x] < 1 THEN MessageBox('Error', 'Llave is_dk[' + String(li_x) + '] = ' + is_dk[li_x]) 
NEXT


end event

public function integer of_selected_item_delete ();Integer li_rc

li_rc = This.DeleteRow(0)

RETURN li_rc
end function

public function long of_item_insert ();Long ll_row

ll_row = THIS.InsertRow(0)		// insertar registro maestro

IF ll_row = -1 THEN
	messagebox("Error en Ingreso de Lista","No se ha procedido",exclamation!)
END IF

RETURN ll_row
end function

public function integer of_share_lista (datawindow adw_1);Integer li_rc
Datawindow ldw_master

SetPointer(hourglass!)				// cambiar cursor para lectura de lista

ldw_master = adw_1

li_rc = ldw_master.ShareData (THIS)
IF li_rc <> 1 THEN
	messagebox("Error en Sharedata","Error al compartir con dw",exclamation!)
END IF

SetNull(ldw_master)

RETURN li_rc
end function

public subroutine of_protect ();String ls_colname, ls_value
Integer li_totcol, li_x, li_pos

ls_value = '1'
li_totcol = Integer(THIS.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_colname = "#" + String(li_x) + ".dbName"
	ls_colname = THIS.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	ls_colname = Mid(ls_colname,li_pos + 1)
	ls_colname = ls_colname + ".Protect=" + ls_value
	ls_colname = THIS.Modify(ls_colname)
NEXT


end subroutine

public function any of_get_column_data (long al_row, integer ai_colnum);Any la_id

la_id = THIS.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
end function

public function integer of_set_shift_row (long al_row);integer	li_Idx

THIS.setredraw(false)   // deselecciona todo
THIS.selectrow(0,false)

If il_lastrow = 0 then				// selecciona fila si no existe seleccion anterior
	THIS.SelectRow(al_row,TRUE)
	THIS.setredraw(true)
	Return 1
end if

if il_lastrow > al_row then  
	For li_Idx = il_lastrow to al_row STEP -1		// seleccionar rango hacia atras
		THIS.selectrow(li_Idx,TRUE)	
	end for	
else
	For li_Idx = il_lastrow to al_row 				// seleccionar rango hacia adelante
		THIS.selectrow(li_Idx,TRUE)	
	next	
end if

THIS.setredraw(true)
Return 1

end function

public function integer of_sort_lista ();Integer	li_rc, li_x
String	ls_sort

ls_sort = "#" + String(ii_ck[1]) +" A"

FOR li_x = 2 TO UpperBound(ii_ck)
	 ls_sort = ls_sort + ", #" + String(ii_ck[li_x]) +" A"
NEXT
	
THIS.SetSort(ls_sort)
li_rc = THIS.Sort()

RETURN li_rc
end function

public subroutine of_color (long al_value);THIS.Object.DataWindow.Color = al_value
end subroutine

public function integer of_column_text_color (string as_field, long al_color);Integer 	li_rc
String	ls_rc

ls_rc = THIS.Modify(as_field + '.Color=' + String(al_color))

IF ls_rc = "" THEN
	li_rc = 1
ELSE
	li_rc = -1
END IF

RETURN li_rc       // -1 = error, 1 = ok
end function

public function integer of_column_end (string as_field);Integer li_x, li_width, li_end

li_x = Integer(THIS.Describe(as_field + '.x'))
li_width = Integer(THIS.Describe(as_field + '.width'))
li_end = li_x + li_width

RETURN li_end
end function

public subroutine of_set_split (integer ai_x);THIS.Object.datawindow.horizontalscrollsplit = ai_x
end subroutine

public subroutine of_row_find (string as_expresion, ref long al_row[]);Long	ll_x = 0, ll_start

ll_start = THIS.Find(as_expresion, 1, THIS.RowCount())

DO WHILE ll_start > 0
	ll_x ++
	al_row[ll_x] = ll_start
	ll_start = THIS.Find(as_expresion, ll_start + 1, THIS.RowCount())
LOOP
end subroutine

public function boolean isvaliddataobject ();TRY
	this.object.datawindow.readonly
CATCH (RuntimeError re)
	Return False
END TRY

Return True
end function

event clicked;IF row = 0 THEN RETURN

IF ii_ss = 1 THEN		// solo para seleccion individual			
	il_row = row                    // fila corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	THIS.Event ue_output(row)
	RETURN 
END IF


string	  ls_KeyDownType		//  solo para seleccion multiple

If Keydown(KeyShift!) then  // seleccionar multiples filas usando la tecla shift
	of_Set_Shift_row(row)	
Else
	If this.IsSelected(row) Then
		il_LastRow = row
		ib_action_on_buttonup = true
	Else
		If Keydown(KeyControl!) then  // mantiene las otras filas seleccionadas y selecciona
			il_LastRow = row				// o deselecciona a clicada
			this.SelectRow(row,TRUE)
		Else
			il_LastRow = row
			this.SelectRow(0,FALSE)
			this.SelectRow(row,TRUE)
		End If
	END IF
END IF

end event

event doubleclicked;THIS.Event ue_column_sort()
end event

event constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ii_ck[1] = 1          // columnas de lectrua de este dw
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

// en el ue_open_pre() del w_cns colocar
//dw_master.SetTransObject(SQLCA)
//dw_lista.of_share_lista(dw_master)
//dw_master.Retrieve()
//dw_lista.of_sort_lista()
end event

event dberror;String ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, ls_name
Integer li_pos_ini, li_pos_fin, li_pos_nc

if sqldbcode <= -20000 then
ls_msg = SQLErrText
ROLLBACK;
MessageBox('DBError ' + This.Classname(), ls_msg)
return
end if

ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1

ls_cadena = Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc = Pos(ls_cadena,'.',1) - 1 
ls_prop   = Mid(ls_cadena,1,li_pos_nc)
ls_const  = Mid(ls_cadena,li_pos_nc + 2)

CHOOSE CASE sqldbcode 
	CASE 02292                         
		// Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        INTO :ls_name
        FROM ALL_CONSTRAINTS
       WHERE ((OWNER          = :ls_prop  ) AND 
             (CONSTRAINT_NAME = :ls_const )) ;

		ROLLBACK;
      Messagebox('Error FK','Registro Tiene Movimientos en Tabla: '+ls_name)
      Return 1
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText + ls_crlf
		ls_msg += 'Linea: ' + String(row) + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID
		ROLLBACK;
		messagebox("dberror", ls_msg, StopSign!)
END CHOOSE

end event

on u_dw_list_tbl.create
end on

on u_dw_list_tbl.destroy
end on

