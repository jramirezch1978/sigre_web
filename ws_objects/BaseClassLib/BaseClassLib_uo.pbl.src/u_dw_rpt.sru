$PBExportHeader$u_dw_rpt.sru
$PBExportComments$datawindow para impresion de reportes
forward
global type u_dw_rpt from datawindow
end type
end forward

global type u_dw_rpt from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_print ( )
event ue_saveas ( )
event ue_zoom ( integer ai_zoom )
event ue_column_sort ( )
event ue_filter ( )
event ue_sort ( )
end type
global u_dw_rpt u_dw_rpt

type variables
Integer   ii_zoom_actual = 80, ii_zi = 10, ii_sort = 1
String     is_dwform = 'tabular'
Long      il_row
end variables

forward prototypes
public function integer of_scrollrow (string as_value)
public subroutine of_color (long al_value)
public subroutine of_row_find (string as_expresion, ref long al_row[])
public function boolean isvaliddataobject ()
public function integer of_setfilter (string as_campo, string as_value)
public function boolean of_existecampo (string as_campo)
end prototypes

event ue_print();Double	ldb_rc

OpenWithParm(w_print_opt, THIS)

ldb_rc = Message.DoubleParm

IF Message.DoubleParm <> -1 Then THIS.Print(True)


end event

event ue_saveas;THIS.saveas()
end event

event ue_zoom;Integer	li_Zoom

li_Zoom = ai_zoom * ii_zi    //  Incremento del zoom

If li_Zoom = 0 Then
	OpenWithParm(w_zoom, ii_zoom_actual)
	If Message.DoubleParm > 0 Then
		ii_zoom_actual = Message.DoubleParm
	End if
	
Else
	ii_zoom_actual = ii_zoom_actual + li_Zoom
End If

If ii_zoom_actual < 10 Then ii_zoom_actual = 10

THIS.modify('datawindow.print.preview.zoom = ' + String(ii_zoom_actual))
This.title = "Reporte " + "(Zoom: " + String(ii_zoom_actual) + "%)"

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

public function integer of_scrollrow (string as_value);Long  ll_rc = 0

//IF is_dwform = 'form' THEN RETURN ll_rc


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

RETURN ll_rc
end function

public subroutine of_color (long al_value);THIS.Object.DataWindow.Color = al_value
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

public function integer of_setfilter (string as_campo, string as_value);string 	ls_data_type
integer 	li_d
as_campo=TRIM(as_campo)
as_value=TRIM(as_value)

setredraw(false)
ls_data_type = describe(as_campo+".ColType")

if pos(ls_data_type,"(") >0 then 
	ls_data_type=mid(ls_data_type,1,pos(ls_data_type,"(") - 1)
end if

if as_value<>"" then
	choose case lower(ls_data_type) 
		case "number","int","long","real","ulong", "decimal"
			if not IsNumber(as_value) then 
				gnvo_log.of_errorlog("as_value: " + as_value + ", campo: " + as_campo &
						+ " ingresado no es numérico")
				setredraw(true)
				return -1
			end if	
			setfilter(as_campo+"="+as_value)

		case "string", "char"
			li_d=setfilter("upper("+as_campo+")"+" like upper('%"+as_value+"%')")

		case "date", "datetime"
			if not IsDate(as_value) then 
				gnvo_log.of_errorlog("as_value: " + as_value + ", campo: " + as_campo &
									+ " ingresado no es Fecha")
				setredraw(true)				
				return -1
			end if	
			setfilter(as_campo +" = date('"+as_value+"')")		
			
		case "time"
			
		case "datetime"
			if not IsDate(as_value) then 
				gnvo_log.of_errorlog("as_value: " + as_value + ", campo: " + as_campo &
									+ " ingresado no es Fecha")
				setredraw(true)				
				return -1
			end if	
			setfilter("string("+as_campo +",'dd/mm/yy') like '"+as_value+"%'")		
	end choose
else
	setfilter("")	
end if

filter()
setredraw(true)
return 0
end function

public function boolean of_existecampo (string as_campo);IF this.Describe(as_campo + ".ColType") = '!' THEN return false

return true
end function

event doubleclicked;IF is_dwform = 'tabular' or is_dwform = 'grid' THEN THIS.Event ue_column_sort()

end event

event constructor;// is_dwform = 'form'  // tabular (default), form 

string ls_modify_string
string ls_error_string
long ll_x, ll_y
ll_x = (This.width - 1257 )/2
ll_y = (This.height - 157 )/2
ls_modify_string = 'create text(band=foreground alignment="0" ' &
 + 'text="¡¡ No Existen Datos !!" border="0" color="0" ' &
 + 'x="' + String(ll_x) + '" y="' + String(ll_y) + '" ' &
 + 'height="157" width="1357" name=no_rows_found ' &
 + 'font.face="Arial" font.height="-15" font.weight="1000" ' &
 + 'font.family="2" font.pitch="2" font.charset="0" ' &
 + 'background.mode="1" background.color="553648127" ' &
 + 'visible="1~tIF(RowCount()=0,1,0)")'
ls_error_string = Modify(ls_modify_string)



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

this.setRow(row)
f_select_current_row(this)
end event

event resize;long ll_x, ll_y
ll_x = (this.width - 1257)/2
ll_y = (this.height - 157)/2

this.Modify('no_rows_found.X=" ' + String(ll_x) &
 + ' " no_rows_found.Y=" ' + String(ll_y) + ' " ')
end event

on u_dw_rpt.create
end on

on u_dw_rpt.destroy
end on

