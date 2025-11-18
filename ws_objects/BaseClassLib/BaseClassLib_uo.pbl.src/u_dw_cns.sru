$PBExportHeader$u_dw_cns.sru
$PBExportComments$datawindow para consultas
forward
global type u_dw_cns from datawindow
end type
end forward

global type u_dw_cns from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_column_sort ( )
event ue_filter ( )
event ue_output ( )
event ue_print ( )
event ue_sort ( )
event ue_retrieve_det ( long al_row )
event ue_retrieve_det_pos ( any aa_id[] )
event ue_val_param ( )
event ue_conversion ( )
end type
global u_dw_cns u_dw_cns

type variables
Integer   ii_ck[],  ii_dk[]
String     is_ck[], is_dk[]
Integer   ii_sort =  0
String     is_dwform = 'tabular', is_mastdet = 'd'
Long      il_row
end variables

forward prototypes
public function long of_find (string as_field, string as_data)
public function long of_find (string as_field, double adb_data)
public function any of_get_column_data (long al_row, integer ai_colnum)
public function long of_scrollrow (string as_value)
public subroutine of_color (long al_value)
public function integer of_column_text_color (string as_field, long al_color)
public subroutine of_set_split (integer ai_x)
public function integer of_get_column_end (string as_field)
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

event ue_filter();string	ls_filter

SetNull (ls_filter)
THIS.SetFilter (ls_filter)
THIS.Filter()

THIS.GROUPcalc( )
end event

event ue_output;//THIS.EVENT ue_retrieve_det(al_row)

//idw_det.ScrollToRow(al_row)

end event

event ue_print;OpenWithParm(w_print_opt, THIS)

If Message.DoubleParm = -1 Then Return

THIS.Print(True)

end event

event ue_sort();string	ls_sort

SetNull (ls_sort)
THIS.SetSort (ls_sort)
THIS.Sort()

THIS.GROUPcalc( )
end event

event ue_retrieve_det;Any		la_id[]
Integer	li_x

FOR li_x = 1 TO UpperBound(ii_dk)
	la_id[li_x] = THIS.object.data.primary.current[al_row, ii_dk[li_x]]
NEXT

THIS.EVENT ue_retrieve_det_pos(la_id)
end event

event ue_retrieve_det_pos;//idw_det.retrieve(la_id[1],la_id[2])
end event

event ue_val_param;IF UpperBound(ii_ck) < 1 THEN
	MessageBox('Error ' + THIS.ClassName(), 'ii_ck no tiene valor')
END IF

IF is_mastdet = 'md' OR is_mastdet = 'dd' THEN
	IF UpperBound(ii_dk) < 1 THEN
		MessageBox('Error ' + THIS.ClassName(), 'ii_dk no tiene valor')
	END IF
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

public function long of_find (string as_field, string as_data);Long	ll_row

ll_row = THIS.Find("Lower(" + as_field + ")>=~"" + as_data + "~"",1, 99999)

RETURN ll_row
end function

public function long of_find (string as_field, double adb_data);Long	ll_row
String ls_search 

//ls_search = "Lower(" + as_field + ")>=~"" + as_data + "~""

ls_search = as_field + " >= " + String(adb_data)

ll_row = THIS.Find(ls_search,1, 99999)

RETURN ll_row
end function

public function any of_get_column_data (long al_row, integer ai_colnum);Any la_id

la_id = THIS.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
end function

public function long of_scrollrow (string as_value);Long  ll_rc

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

public subroutine of_set_split (integer ai_x);

THIS.Object.datawindow.horizontalscrollsplit = ai_x
end subroutine

public function integer of_get_column_end (string as_field);Integer li_x, li_width, li_end

li_x = Integer(THIS.Describe(as_field + '.x'))
li_width = Integer(THIS.Describe(as_field + '.width'))
li_end = li_x + li_width

RETURN li_end
end function

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

event doubleclicked;IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
END IF

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

event constructor;THIS.EVENT Post ue_conversion()
THIS.EVENT POST ue_val_param()

// is_mastdet = 'm'     // 'm' = master sin detalle, 'd' =  detalle (default),
                        // 'md' = master con detalle, 'dd' = detalle con detalle a la vez
// is_dwform = 'form'  	// tabular(default), form

// ii_ck[1] = 1         // columnas de lectrua de este dw
// ii_dk[1] = 1 	      // columnas que se pasan al detalle
	
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

event clicked;il_row = row
end event

on u_dw_cns.create
end on

on u_dw_cns.destroy
end on

