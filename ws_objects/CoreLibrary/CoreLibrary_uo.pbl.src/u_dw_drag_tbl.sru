$PBExportHeader$u_dw_drag_tbl.sru
$PBExportComments$datawindows para consultas con drag & drop
forward
global type u_dw_drag_tbl from datawindow
end type
end forward

global type u_dw_drag_tbl from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event dwnenter pbm_dwnprocessenter
event ue_column_sort ( )
event ue_filter ( )
event ue_sort ( )
end type
global u_dw_drag_tbl u_dw_drag_tbl

type variables
Integer    ii_update = 0, ii_sort =  1, ii_protect = 0
Integer    ii_ck[]
String      is_dwform = 'tabuar', is_mastdet = 'm'
Long       il_row
end variables

forward prototypes
public function integer of_scrollrow (string as_value)
public subroutine of_enable (integer ai_value)
public function any of_column_data (long al_row, integer ai_colnum)
public function any of_get_column_data (long al_row, integer ai_colnum)
public subroutine of_color (long al_value)
public function integer of_column_text_color (string as_field, long al_color)
public function integer of_column_end (string as_field)
public subroutine of_set_split (integer ai_x)
public subroutine of_set_flag_replicacion ()
end prototypes

event dwnenter;Send(Handle(this),256,9,Long(0,0))
return 1
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

public subroutine of_enable (integer ai_value);IF ai_value = 1 THEN
	THIS.enabled = TRUE
ELSE
	THIS.enabled = False
END IF
end subroutine

public function any of_column_data (long al_row, integer ai_colnum);Any la_id

la_id = THIS.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
end function

public function any of_get_column_data (long al_row, integer ai_colnum);Any la_id

la_id = THIS.object.data.primary.current[al_row, ai_colnum]

RETURN la_id
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

event clicked;IF row = 0 THEN RETURN

Any la_id

il_row = row                    // fila corriente
This.SelectRow(0, False)
This.SelectRow(row, True)
THIS.SetRow(row)

Drag(Begin!)


end event

event doubleclicked;
THIS.Event ue_column_sort()

end event

on u_dw_drag_tbl.create
end on

on u_dw_drag_tbl.destroy
end on

event itemchanged;ii_update = 1

IF THIS.Describe("flag_replicacion.ColType") <> '!' THEN 
    THIS.Object.flag_replicacion[row] = '1'
END IF

end event

