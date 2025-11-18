$PBExportHeader$u_dw_abc.sru
$PBExportComments$datawindow de mantenimiento abc
forward
global type u_dw_abc from datawindow
end type
end forward

global type u_dw_abc from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event dwnenter pbm_dwnprocessenter
event type long ue_delete ( )
event type long ue_insert ( )
event ue_print ( )
event ue_column_sort ( )
event ue_filter ( )
event ue_sort ( )
event ue_output ( long al_row )
event type integer ue_delete_all ( )
event ue_delete_pos ( )
event type integer ue_delete_pre ( )
event ue_detail_reset ( )
event ue_insert_pre ( long al_row )
event ue_selected_row ( )
event ue_selected_row_pos ( )
event ue_selected_row_pre ( )
event ue_selected_row_pro ( long al_row )
event ue_lbuttonup pbm_dwnlbuttonup
event ue_retrieve_det ( long al_row )
event ue_retrieve_det_pos ( any aa_id[] )
event ue_val_param ( )
event ue_conversion ( )
event ue_read_data ( )
event keydwn pbm_dwnkey
event ue_duplicar ( )
event ue_anular ( )
event ue_cancelar ( )
end type
global u_dw_abc u_dw_abc

type prototypes
function boolean GetKeyboardState( REF char lpKeyState[256] ) library 'user32.dll'
Function Boolean PeekMessageA( Ref blob lpMsg, long hWnd, UINT uMsgFilterMin, UINT uMsgFilterMax, UINT wRemoveMsg ) Library 'USER32.dll'
end prototypes

type variables
Integer  ii_update = 0, ii_protect = 0, ii_ss = 1,  ii_sort = 0
Integer  ii_ck[], ii_rk[], ii_dk[]
String   is_ck[],is_rk[],is_dk[] 
String   is_dwform = 'form', is_mastdet = 'm'
String   is_colname, is_coltype
Long     il_row, il_lastrow, il_totdel
boolean 	ib_action_on_buttonup = false, ib_insert_mode = false
boolean 	ib_delete_cascada = false
u_dw_abc idw_mst, idw_det
dwObject	idwo_clicked
end variables

forward prototypes
public subroutine of_enable (integer ai_value)
public subroutine of_column_protect (string as_colname)
public function integer of_setitem (datawindow adw_master, long al_m_row, integer ai_m_cn, long al_row, integer ai_cn)
public function any of_get_column_data (long al_row, integer ai_colnum)
public function integer of_scrollrow (string as_value)
public function integer of_set_shift_row (long al_row)
public function integer of_column_text_color (string as_field, long al_color)
public function integer of_get_column_end (string as_field)
public subroutine of_set_split (integer ai_x)
public subroutine of_row_find (string as_expresion, ref long al_row[])
public function boolean of_val_duplicado (string as_campo, string as_data)
public function boolean of_val_duplicado (string as_campo, decimal adc_data)
public subroutine of_get_col_list (str_col_pop astr_pop)
public subroutine of_color (long al_value)
public subroutine of_protect ()
public subroutine of_set_flag_replicacion ()
end prototypes

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
end event

event ue_delete;long ll_row = 1

ib_insert_mode = False

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre()  // solo si se tiene detalle

IF ll_row = 1 THEN
	ll_row = THIS.DeleteRow (0)
	IF ll_row = -1 then
		messagebox("Error en Eliminacion de Registro","No se ha procedido",exclamation!)
	ELSE
		il_totdel ++
		ii_update = 1								// indicador de actualizacion pendiente
		THIS.Event Post ue_delete_pos()
	END IF
END IF

RETURN ll_row


end event

event ue_insert;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF idw_mst.il_row = 0 THEN
		MessageBox("Error", "No ha seleccionado registro Maestro")
		RETURN - 1
	END IF
END IF

long ll_row

ll_row = THIS.InsertRow(0)				// insertar registro maestro

ib_insert_mode = True

IF ll_row = -1 then
	messagebox("Error en Ingreso","No se ha procedido",exclamation!)
ELSE
	ii_protect = 1
	of_protect() // desprotege el dw
	ii_update = 1
	il_row = ll_row
	THIS.Event ue_insert_pre(ll_row) // Asignaciones automaticas
	THIS.ScrollToRow(ll_row)			// ubicar el registro
	THIS.SetColumn(1)
	THIS.SetFocus()						// poner el focus en el primer campo
	IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

event ue_print;//OpenWithParm(w_print_opt, THIS)

//If Message.DoubleParm = -1 Then Return

//THIS.Print(True)

end event

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

event ue_filter();string	ls_filter

SetNull (ls_filter)
THIS.SetFilter (ls_filter)
THIS.Filter()

THIS.GROUPcalc( )
end event

event ue_sort();string	ls_sort

SetNull (ls_sort)
THIS.SetSort (ls_sort)
THIS.Sort()

THIS.GROUPcalc( )
end event

event ue_output;//THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)


end event

event type integer ue_delete_all();long ll_row = 1, ll_cnt, ll_total_rows, ll_deleted_row

IF is_mastdet = 'dd' THEN ll_row = THIS.Event ue_delete_pre() // solo si tiene detalle

IF ll_row = 1 THEN
	ll_total_rows = THIS.RowCount()
	For ll_cnt = 1 To ll_total_rows
		ll_deleted_row = THIS.DeleteRow (0)
		If ll_deleted_row <> 1 Then
			ll_row = -1
			messagebox("Error en Eliminacion detalle","No se ha procedido",exclamation!)
			EXIT
		ELSE
			il_totdel ++
			ll_row = 1
			ii_update = 1
		End If
	Next
END IF

RETURN ll_row
end event

event ue_delete_pre;long ll_row = 1

IF ib_delete_cascada THEN ll_row = idw_det.Event ue_delete_all()

RETURN ll_row

end event

event ue_insert_pre;IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	Any  la_id
	Integer li_x
	FOR li_x = 1 TO UpperBound(idw_mst.ii_dk)
		la_id = idw_mst.object.data.primary.current[idw_mst.il_row, idw_mst.ii_dk[li_x]]
		THIS.SetItem(al_row, ii_rk[li_x], la_id)
	NEXT
END IF


end event

event ue_selected_row;Long	ll_row, ll_y

THIS.EVENT ue_selected_row_pre()

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.EVENT ue_selected_row_pro(ll_row)
	ll_row = THIS.GetSelectedRow(ll_row)
Loop

THIS.EVENT ue_selected_row_pos()


end event

event ue_selected_row_pos;//Long	ll_row, ll_y
//
//ll_row = THIS.GetSelectedRow(0)
//
//Do While ll_row <> 0
//	THIS.DeleteRow(ll_row)
//	ll_row = THIS.GetSelectedRow(0)
//Loop

end event

event ue_selected_row_pro;//Long	ll_row, ll_rc
//Any	la_id
//Integer	li_x
//
//ll_row = idw_det.EVENT ue_insert()
//
//FOR li_x = 1 to UpperBound(ii_dk)
//	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
//	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
//NEXT
//
//idw_det.ScrollToRow(ll_row)



end event

event ue_lbuttonup;
If ib_action_on_buttonup Then
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

event ue_retrieve_det_pos;//idw_det.retrieve(aa_id[1],aa_id[2])
end event

event ue_val_param;IF UpperBound(ii_ck) < 1 THEN
	MessageBox('Error ' + THIS.ClassName(), 'ii_ck no tiene valor')
END IF

IF ii_ss = 0 AND is_dwform <> 'tabular' THEN
	MessageBox('Error ' + THIS.ClassName(), 'is_dwform tiene que ser tabular')
END IF

IF ib_delete_cascada THEN
	IF (is_mastdet <> 'md' AND is_mastdet = 'dd') THEN
		MessageBox('Error ' + THIS.ClassName(), 'is_mstdet tiene que ser md o dd')
	END IF
END IF

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN
	IF UpperBound(ii_dk) < 1 THEN
		MessageBox('Error ' + THIS.ClassName(), 'ii_dk no tiene valor')
	END IF
	IF IsNull(idw_det) THEN
		MessageBox('Error ' + THIS.ClassName(), 'idw_det no tiene valor')
	END IF
END IF

IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF UpperBound(ii_rk) < 1 THEN
		MessageBox('Error ' + THIS.ClassName(), 'ii_rk no tiene valor')
	END IF
	IF IsNull(idw_mst) THEN
		MessageBox('Error ' + THIS.ClassName(), 'idw_det no tiene valor')
	END IF
END IF

//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

//ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
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


FOR li_x = 1 to UpperBound(is_rk)
	ii_rk[li_x] = Integer(THIS.Describe(is_rk[li_x] + '.ID'))
	IF ii_rk[li_x] < 1 THEN MessageBox('Error', 'Llave is_rk[' + String(li_x) + '] = ' + is_rk[li_x]) 
NEXT

end event

event ue_read_data;//String	ls_mensaje
//
//
//IF idwo_clicked.Type = 'column' THEN
//	ls_mensaje = 'Estoy en ' + idwo_clicked.Name + ', ' + idwo_clicked.Primary[il_row]
//	MessageBox('Hola', ls_mensaje )
//END IF

end event

event keydwn;blob {28} lbl_msg

IF ib_insert_mode AND Key = KeyAdd! THEN
	THIS.EVENT ue_insert()
	PeekMessageA(lbl_msg,0,256,264,1)
   message.processed=TRUE
   message.returnvalue=0
   return 0
END IF

// Para Pintar la Linea Seleccionada
long ll_row, ll_total

ll_row = this.getrow()
ll_total = this.rowcount()
if keydown(KeyUpArrow!) and ll_row > 1 then
 this.selectrow(0,false)
 this.selectrow(ll_row - 1, true)
end if
if keydown(KeyDownArrow!) and ll_row < ll_total then
 this.selectrow(0,false)
 this.selectrow(ll_row + 1, true)
end if

end event

event ue_duplicar();IF Lower(is_dwform) <> 'tabular' THEN
	MessageBox('Error', 'Solo se puede duplicar en ventanas Tabulares')
	RETURN
END IF

Long	ll_row, ll_totcol, ll_source
Any  la_id
Integer li_x

IF IsNull(il_row) OR il_row < 1 THEN
	MessageBox('Error','Tiene que Seleccionar una Fila')
	RETURN
END IF

ll_source = il_row
ll_row = THIS.Event ue_insert()

ll_totcol = Long(THIS.Object.DataWindow.Column.Count)

FOR li_x = 1 TO ll_totcol
	la_id = THIS.object.data.primary.current[ll_source, li_x]
	THIS.SetItem(ll_row, li_x, la_id)
NEXT
end event

public subroutine of_enable (integer ai_value);IF ai_value = 1 THEN
	THIS.enabled = TRUE
ELSE
	THIS.enabled = False
END IF
end subroutine

public subroutine of_column_protect (string as_colname);String ls_comand, ls_value, ls_rc
Integer li_totcol, li_x, li_pos
Long ll_row

ll_row = THIS.GetRow()

ls_comand = as_colname + ".Protect"

IF THIS.Describe(ls_comand) = '0' THEN
	ls_comand = as_colname + ".Protect=1"
ELSE
	ls_comand = as_colname + ".Protect=0"
END IF

ls_rc = THIS.Modify(ls_comand)

IF ll_row > 0 AND is_dwform = 'tabular' THEN
	THIS.SetRow(ll_row)
END IF


	


end subroutine

public function integer of_setitem (datawindow adw_master, long al_m_row, integer ai_m_cn, long al_row, integer ai_cn);Any  			la_id
Integer		li_rc
u_dw_abc		ldw_1 

ldw_1 = adw_master   

la_id = ldw_1.object.data.primary.current[al_m_row, ai_m_cn]

li_rc = THIS.SetItem(al_row, ai_cn, la_id)

SetNull(ldw_1)

RETURN li_rc

end function

public function any of_get_column_data (long al_row, integer ai_colnum);Any la_id

la_id = THIS.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
end function

public function integer of_scrollrow (string as_value);Long  ll_rc

IF is_dwform = 'form' THEN
	CHOOSE CASE as_value
		CASE 'N'
			ll_rc = THIS.ScrollNextRow()
		CASE 'P'
			ll_rc = THIS.ScrollPriorRow()
		CASE 'L'
			ll_rc = THIS.ScrollToRow(THIS.RowCount())
		CASE ELSE
			ll_rc = THIS.ScrollToRow(0)
	END CHOOSE
ELSE
	CHOOSE CASE as_value
		CASE 'N'
			ll_rc = THIS.ScrollNextPage()
		CASE 'P'
			ll_rc = THIS.ScrollPriorPage()
		CASE 'L'
			ll_rc = THIS.ScrollToRow(THIS.RowCount())
		CASE ELSE
			ll_rc = THIS.ScrollToRow(0)
	END CHOOSE	
END IF
	
RETURN ll_rc
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

public function integer of_get_column_end (string as_field);Integer li_x, li_width, li_end

li_x = Integer(THIS.Describe(as_field + '.x'))
li_width = Integer(THIS.Describe(as_field + '.width'))
li_end = li_x + li_width

RETURN li_end
end function

public subroutine of_set_split (integer ai_x);THIS.Object.datawindow.horizontalscrollsplit = ai_x
end subroutine

public subroutine of_row_find (string as_expresion, ref long al_row[]);Long		ll_x = 0, ll_start, ll_total

ll_total = THIS.RowCount() + 1   // + 1 para evitar el loop cuando la ultima fila coincide
ll_start = THIS.Find(as_expresion, 1, ll_total)

DO WHILE (ll_start > 0)
	ll_x ++
	al_row[ll_x] = ll_start
	ll_start = THIS.Find(as_expresion, ll_start + 1, ll_total)
LOOP

end subroutine

public function boolean of_val_duplicado (string as_campo, string as_data);String	ls_expresion
Long		ll_row[]
Boolean	lb_rc

ls_expresion = as_campo + " = '" + as_data + "'"

of_row_find(ls_expresion, ll_row[])

IF UpperBound(ll_row) > 1 THEN
	lb_rc = FALSE
ELSE
	lb_rc = TRUE
END IF

RETURN lb_rc		// True = No hay duplicados, False = Si
end function

public function boolean of_val_duplicado (string as_campo, decimal adc_data);String	ls_expresion
Long		ll_row[]
Boolean	lb_rc

ls_expresion = as_campo + " = " + String(adc_data)

of_row_find(ls_expresion, ll_row[])

IF UpperBound(ll_row) > 1 THEN
	lb_rc = True
ELSE
	lb_rc = False
END IF

RETURN lb_rc		// True = hay duplicados, False = No
end function

public subroutine of_color (long al_value);THIS.Object.DataWindow.Color = al_value
end subroutine

public subroutine of_protect ();String ls_colname, ls_value
Integer li_totcol, li_x, li_pos
Long ll_row

ll_row = THIS.GetRow()

IF ii_protect = 0 THEN
	ii_protect = 1
ELSE
	ii_protect = 0
END IF

ls_value = String(ii_protect)
li_totcol = Integer(THIS.Describe("DataWindow.Column.Count"))

FOR li_x = 1 TO li_totcol
	ls_colname = "#" + String(li_x) + ".Name"
	ls_colname = THIS.Describe(ls_colname)
	li_pos = Pos(ls_colname,".")
	ls_colname = Mid(ls_colname,li_pos + 1)
	ls_colname = ls_colname + ".Protect=" + ls_value
	ls_colname = THIS.Modify(ls_colname)
NEXT

IF ll_row > 0 THEN     //AND is_dwform = 'tabular' THEN
	THIS.SetRow(ll_row)
END IF


	


end subroutine

public subroutine of_set_flag_replicacion ();// Verificar si este DW tiene FLAG_REPLICACION
IF this.Describe("flag_replicacion.ColType") = '!' THEN return

Long ll_nro_regs, ll_row = 0, ll_count = 0

THIS.AcceptText()

ll_nro_regs = this.RowCount()

DO WHILE ll_row <= ll_nro_regs
   ll_row = this.GetNextModified(ll_row, Primary!)
   IF ll_row <= 0 THEN EXIT
   THIS.object.flag_replicacion[ll_row]='1'
//   ll_count = ll_count + 1
LOOP

//MessageBox("Modified Count", String(ll_count) + " rows were modified.")
end subroutine

event dberror;String 	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, &
			ls_name, ls_pos
Integer 	li_pos_ini, li_pos_fin, li_pos_nc, li_len
 
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

	case 20000 to 29999
		// Encontrar el error
		
		li_pos_ini = POS( sqlerrtext, ':')
	
		ls_cadena = MID( sqlerrtext, li_pos_ini + 2, len(sqlerrtext) )			
		li_pos_fin = pos( ls_cadena, 'ORA')
		ls_cadena = MID( sqlerrtext, li_pos_ini + 2, li_pos_fin - 1)
		ROLLBACK;
		Messagebox( 'DBError ' + This.Classname(), ls_cadena, stopsign!)
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
		messagebox("dberror " + this.ClassName(), ls_msg, StopSign!)
END CHOOSE


end event

event itemchanged;ii_update = 1

IF THIS.Describe("flag_replicacion.ColType") <> '!' THEN 
    THIS.Object.flag_replicacion[row] = '1'
END IF

end event

event clicked;IF row = 0 OR is_dwform = 'form' THEN RETURN

il_row = row              // fila corriente

IF ii_ss = 1 THEN		        // solo para seleccion individual			
	idwo_clicked = dwo        // dwo corriente
	This.SelectRow(0, False)
	This.SelectRow(row, True)
	THIS.SetRow(row)
	THIS.Event ue_output(row)
	RETURN
END IF


string	  ls_KeyDownType	 //  solo para seleccion multiple

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

//idw_1.BorderStyle = StyleRaised!
//idw_1 = THIS
//idw_1.BorderStyle = StyleLowered!
//is_tabla = 'CLIENTES'						// nombre de tabla para el Log

end event

event constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

//is_mastdet = 'd'		// 'm' = master sin detalle (default), 'd' =  detalle,
                       	// 'md' = master con detalle, 'dd' = detalle con detalle a la vez
//is_dwform = 'tabular'	// tabular, form (default)

//ii_ss = 0 				// indica si se usa seleccion: 1=individual (default), 0=multiple
//ib_delete_cascada = true // indica si hace cascada con el detalle, al deletear

//ii_ck[1] = 1				// columnas de lectrua de este dw
//ii_rk[1] = 1 	      // columnas que recibimos del master
//ii_dk[1] = 1 	      // columnas que se pasan al detalle

//idw_mst  = 				// dw_master
//idw_det  =  				// dw_detail
end event

event doubleclicked;IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
ELSE
	IF row = 0 THEN RETURN
	il_row = row                    // fila corriente
	THIS.SetRow(row)
	THIS.Event ue_output(row)
END IF

this.GroupCalc()

//// USAR SOLO PARA CONSULTAS EN CASCADA
//IF row = 0 THEN RETURN
//
//STR_CNS_POP lstr_1
//
//CHOOSE CASE dwo.Name
//	CASE "id"  
//		lstr_1.DataObject = 'd_sales_order_items'
//		lstr_1.Width = 1500
//		lstr_1.Height= 1300
//		lstr_1.Name = 'Lista de Items'
//		lstr_1.Argument1 = String(GetItemNumber(row,'id'))
//		of_new_sheet(lstr_1)
//	CASE 'cust_id'
//		lstr_1.DataObject = 'd_customer2_ff'
//		lstr_1.Width = 1500
//		lstr_1.Height= 1300
//		lstr_1.Name = 'Datos del Cliente'
//		lstr_1.Argument1 = String(GetItemNumber(row,'cust_id'))
//		of_new_sheet(lstr_1)
//END CHOOSE
end event

event losefocus;THIS.AcceptText()
end event

event rbuttondown;String ls_name, ls_title

ls_name = dwo.name
ls_title = Right(ls_name, 2)
IF ls_name = 'datawindow' or ls_title = '_t' THEN RETURN

is_colname = dwo.name
is_coltype = dwo.coltype
il_row     = row

Parent.EVENT Post Dynamic ue_PopM(w_login.PointerX(), w_login.PointerY())
end event

on u_dw_abc.create
end on

on u_dw_abc.destroy
end on

event updateend;ib_insert_mode = False
end event

