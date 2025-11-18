$PBExportHeader$u_dw_rpt.sru
$PBExportComments$datawindow para impresion de reportes
forward
global type u_dw_rpt from datawindow
end type
end forward

global type u_dw_rpt from datawindow
integer width = 1243
integer height = 1232
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
event ue_print ( )
event ue_saveas ( )
event ue_zoom ( integer ai_zoom )
event ue_column_sort ( )
event ue_filter ( )
event ue_sort ( )
event ue_saveas_excel ( )
event ue_leftbuttonup pbm_dwnlbuttonup
event ue_filter_avanzado ( )
event ue_preview ( )
event ue_post_filter ( )
end type
global u_dw_rpt u_dw_rpt

type variables
Integer   	ii_zoom_actual = 110, ii_zi = 5, ii_sort = 1
String     	is_dwform = 'tabular'
Long      	il_row
boolean		ib_preview = false
m_rbutton_ancst	im_menu

private:
n_cst_powerfilter iu_powerfilter
end variables

forward prototypes
public function integer of_scrollrow (string as_value)
public subroutine of_color (long al_value)
public subroutine of_row_find (string as_expresion, ref long al_row[])
public function boolean of_existecampo (string as_campo)
public function boolean of_existspicturename (string as_campo)
public function boolean of_existstext (string as_campo)
public function boolean of_set_subtitulo (integer ai_titulo, string as_texto)
public function boolean of_existepicture (string as_campo)
public subroutine of_preview (boolean ab_preview)
end prototypes

event ue_print();Double	ldb_rc

OpenWithParm(w_print_opt, THIS)

ldb_rc = Message.DoubleParm

IF Message.StringParm <> '0' Then THIS.Print(True)


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
THIS.GroupCalc()
	


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

event ue_leftbuttonup;//Click izquierdo del mouse
this.iu_powerfilter.post event ue_buttonclicked(dwo.type, dwo.name)
end event

event ue_filter_avanzado();this.iu_powerfilter.checked =  not iu_powerfilter.checked
this.iu_powerfilter.event ue_clicked()

end event

event ue_preview();setPointer(Hourglass!)

IF this.ib_preview THEN
	this.Modify("DataWindow.Print.Preview=No")
	this.Modify("datawindow.print.preview.zoom = " + String(this.ii_zoom_actual))
	this.title = "Reporte " + " (Zoom: " + String(this.ii_zoom_actual) + "%)"
	this.ib_preview = FALSE
ELSE
	this.Modify("DataWindow.Print.Preview=Yes")
	this.Modify("datawindow.print.preview.zoom = " + String(this.ii_zoom_actual))
	this.title = "Reporte " + " (Zoom: " + String(this.ii_zoom_actual) + "%)"
	this.ib_preview = TRUE
END IF

setPointer(arrow!)
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

public function boolean of_existecampo (string as_campo);IF this.Describe(as_campo + ".ColType") = '!' THEN return false

return true
end function

public function boolean of_existspicturename (string as_campo);IF this.Describe(as_campo + ".filename") = '!' THEN return false

return true
end function

public function boolean of_existstext (string as_campo);IF this.Describe(as_campo + ".text") = '!' THEN return false

return true
end function

public function boolean of_set_subtitulo (integer ai_titulo, string as_texto);string ls_Campo

ls_campo = "t_stitulo" + trim(String(ai_titulo))

if not this.of_existstext( ls_Campo ) then return false

this.Modify(ls_campo + ".Text = '" + as_texto + "'")

return true
end function

public function boolean of_existepicture (string as_campo);IF this.Describe(as_campo + ".filename") = '!' THEN return false

return true
end function

public subroutine of_preview (boolean ab_preview);setPointer(Hourglass!)

IF ab_preview THEN
	this.Modify("DataWindow.Print.Preview=Yes")
	this.Modify("datawindow.print.preview.zoom = " + String(this.ii_zoom_actual))
	this.title = "Reporte " + " (Zoom: " + String(this.ii_zoom_actual) + "%)"
	this.ib_preview = TRUE
ELSE
	this.Modify("DataWindow.Print.Preview=No")
	this.Modify("datawindow.print.preview.zoom = " + String(this.ii_zoom_actual))
	this.title = "Reporte " + " (Zoom: " + String(this.ii_zoom_actual) + "%)"
	this.ib_preview = FALSE
END IF

setPointer(arrow!)
end subroutine

event doubleclicked;IF is_dwform = 'tabular' or is_dwform = 'grid' THEN THIS.Event ue_column_sort()

end event

event constructor;try 
	// is_dwform = 'form'  // tabular (default), form 

	string ls_modify_string
	string ls_error_string
	long ll_x, ll_y
	ll_x = 1 //(This.width - 1357 )/2
	ll_y = 1 //(This.height - 157 )/2
	ls_modify_string = 'create text(band=foreground alignment="2" ' &
	 + 'text="¡¡ No Existen Datos !!" border="0" color="0" ' &
	 + 'x="' + String(ll_x) + '" y="' + String(ll_y) + '" ' &
	 + 'height="157" width="1000" name=no_rows_found ' &
	 + 'font.face="Arial" font.height="-15" font.weight="1000" ' &
	 + 'font.family="2" font.pitch="2" font.charset="0" ' &
	 + 'background.mode="1" background.color="553648127" ' &
	 + 'visible="1~tIF(RowCount()=0,1,0)")'
	
	ls_error_string = Modify(ls_modify_string)
	
	IF ls_error_string <> "" THEN
		gnvo_app.of_mensaje_error("Error al Crear Texto en u_dw_rpt: " + ls_error_string)
		RETURN
	END IF
	
	//Para el filtro avanzado
	this.iu_powerfilter = create n_cst_powerfilter
	this.iu_powerfilter.of_setdw(this)
	
	//Para el menu contextual
	im_menu = create m_rbutton_ancst
	im_menu.idw_rpt1 = this
	
	//Para el zoom por defecto
	ii_zoom_actual = Integer(gnvo_app.of_get_parametro( 'ZOOM_ACTUAL_RPT', '110'))
	
	
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una excepcion: ' + ex.getMessage(), StopSign!)
end try



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

event destructor;destroy iu_powerfilter
destroy im_menu
end event

event rbuttondown;String ls_name, ls_title

//if row = 0 then return
//ls_name = dwo.name
//ls_title = Right(ls_name, 2)
//IF ls_name = 'datawindow' or ls_title = '_t' THEN RETURN
//
//is_colname = dwo.name
//is_coltype = dwo.coltype
//il_row     = row

im_menu.PopMenu(parent.dynamic function PointerX(), parent.dynamic function PointerY() )
end event

