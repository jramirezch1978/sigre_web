$PBExportHeader$u_dw_abc.sru
$PBExportComments$datawindow de mantenimiento abc
forward
global type u_dw_abc from datawindow
end type
end forward

global type u_dw_abc from datawindow
integer width = 2208
integer height = 1372
integer taborder = 10
boolean hscrollbar = true
boolean vscrollbar = true
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
event ue_display ( string as_columna,  long al_row )
event ue_filter_avanzado ( )
event ue_leftbuttonup pbm_dwnlbuttonup
event ue_keydown pbm_keydown
event ue_saveas ( )
event ue_saveas_pdf ( )
event ue_post_filter ( )
end type
global u_dw_abc u_dw_abc

type prototypes
function boolean GetKeyboardState( REF char lpKeyState[256] ) library 'user32.dll' alias for "GetKeyboardState;Ansi"
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

// Para la grabar en el log_diario
Public:
Boolean				ib_log = TRUE, ib_edit = false
m_rbutton_ancst	im_menu

Private:
String      		is_tabla, is_colname_a[], is_coltype_a[]
boolean				ib_filter = false
String				is_palabras[]

n_cst_utilitario	invo_utility
n_cst_log_diario	invo_log
u_ds_base			ids_log
n_cst_powerfilter iu_powerfilter


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
public function boolean of_save_log ()
public subroutine of_create_log ()
public function boolean of_existecampo (string as_campo)
public function integer of_nro_item ()
public function boolean of_search_text (string as_texto, integer ai_opcion)
public function boolean of_split_texto (string as_texto, string as_divisor)
public function string of_get_filter_text (string as_texto, integer ai_opcion)
public function boolean of_filtrar (string as_texto, integer ai_opcion)
public function boolean of_find (string as_texto, integer ai_opcion)
public function boolean is_protect (string as_campo, long al_row)
public function boolean is_row_new (long al_row)
public function boolean is_row_modified (long al_row)
public function string of_get_tabla () throws exception
public function boolean of_valid_property (string as_campo, string as_property)
public function string of_get_updatetable ()
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

event type long ue_insert();IF is_mastdet = 'dd' OR is_mastdet = 'd' THEN
	IF not Isnull(idw_mst) and IsValid(idw_mst) then
		if idw_mst.il_row = 0 THEN
			MessageBox("Error", "No ha seleccionado registro Maestro")
			RETURN - 1
		end if
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
	IF (is_mastdet = 'md' OR is_mastdet = 'dd') and (not ISNull(idw_det) and isValid(idw_det)) THEN idw_det.Reset() //borrar dw detalle
END IF

RETURN ll_row





end event

event ue_print;OpenWithParm(w_print_opt, THIS)

If Message.DoubleParm = -1 Then Return

THIS.Print(True)

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

//Recreamos los grupos, solamente si se ha hecho click en la cabecera
this.GroupCalc()
	


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

event type integer ue_delete_all();Long ll_rows_deleted

IF is_mastdet = 'dd' THEN 
	
	// solo si tiene detalle
	if THIS.Event ue_delete_pre() <> 1 then

		return -1
	end if
end if

il_totdel = 0

do while this.RowCount() > 0
	
	If THIS.event ue_delete() <> 1 Then
		messagebox("Error en Eliminacion detalle","No se ha procedido",exclamation!)
		return -1
	ELSE
		il_totdel ++
		this.ii_update = 1
	End If
loop

RETURN 1
end event

event ue_delete_pre;long ll_row = 1

IF ib_delete_cascada THEN ll_row = idw_det.Event ue_delete_all()

RETURN ll_row

end event

event ue_insert_pre(long al_row);IF (is_mastdet = 'dd' OR is_mastdet = 'd') and not isNull(idw_mst) and IsValid(idw_mst) THEN
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

event ue_read_data();//String	ls_mensaje
//
//
//IF idwo_clicked.Type = 'column' THEN
//	ls_mensaje = 'Estoy en ' + idwo_clicked.Name + ', ' + idwo_clicked.Primary[il_row]
//	MessageBox('Hola', ls_mensaje )
//END IF

end event

event keydwn;blob {28} lbl_msg
string ls_columna, ls_cadena
integer li_column

// Para Pintar la Linea Seleccionada
long ll_row, ll_total

//Añadir con el Signo +
//IF ib_insert_mode AND Key = KeyAdd! THEN
//		THIS.EVENT ue_insert()
//		PeekMessageA(lbl_msg,0,256,264,1)
//   	message.processed=TRUE
//   	message.returnvalue=0
//   	return 0
//END IF

ll_row = this.getrow()
ll_total = this.rowcount()

if keydown(KeyUpArrow!) and ll_row > 1 then
	if is_dwform = 'tabular' then
		this.selectrow(0,false)
		this.selectrow(ll_row - 1, true)
	end if
	
elseif keydown(KeyDownArrow!) and ll_row < ll_total then
	if is_dwform = 'tabular' then
		this.selectrow(0,false)
		this.selectrow(ll_row + 1, true)
	end if
end if


// La tecla F2 despliega el cuadro de ayuda dependiendo de que columna estes ubicado
if key = KeyF2! then
	this.AcceptText()
	li_column = this.GetColumn()
	if li_column <= 0 then return 0
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

event ue_display(string as_columna, long al_row);//boolean lb_ret
//string ls_codigo, ls_data, ls_sql
//choose case lower(as_columna)
//	case "prov_almacen"
//		ls_sql = "SELECT proveedor AS CODIGO_proveedor, " &
//				  + "nom_proveedor AS nombre_proveedor " &
//				  + "FROM proveedor " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '1')
//
//		if ls_codigo <> '' then
//			this.object.prov_almacen	[al_row] = ls_codigo
//			this.object.nom_proveedor	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//	case "cencos"
//		ls_sql = "SELECT cencos AS CODIGO_cencos, " &
//				  + "desc_cencos AS descripcion_cencos " &
//				  + "FROM centros_costo " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cencos		[al_row] = ls_codigo
//			this.object.desc_cencos	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//		
//	case "cod_origen"
//		ls_sql = "SELECT cod_origen AS CODIGO_origen, " &
//				  + "nombre AS descripcion_origen " &
//				  + "FROM origen " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_origen	[al_row] = ls_codigo
//			this.object.nom_origen	[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//	case "cod_responsable"
//		ls_sql = "SELECT cod_usr AS CODIGO_usuario, " &
//				  + "NOMBRE AS nombre_usuario " &
//				  + "FROM usuario " &
//				  + "WHERE FLAG_ESTADO = '1'"
//
//		lb_ret = f_lista(ls_sql, ls_codigo, ls_data, '2')
//
//		if ls_codigo <> '' then
//			this.object.cod_responsable	[al_row] = ls_codigo
//			this.object.nom_usuario			[al_row] = ls_data
//			this.ii_update = 1
//		end if
//
//end choose
end event

event ue_filter_avanzado();this.iu_powerfilter.checked =  not iu_powerfilter.checked
this.iu_powerfilter.event ue_clicked()
ib_filter = not ib_filter

end event

event ue_saveas();THIS.saveas()
end event

event ue_saveas_pdf();string ls_path, ls_file
int li_rc
n_Cst_pdf	lnvo_pdf


ls_file = this.Object.DataWindow.Print.DocumentName

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "PDF", &
   "Archivos PDF (*.pdf),*.pdf" , "C:\", 32770)

IF li_rc = 1 Then
	lnvo_pdf = CREATE n_Cst_pdf
	try
		if not lnvo_pdf.of_create_pdf( this, ls_path) then return
		
		MessageBox('Confirmacion', 'Se ha creado el archivo ' + ls_path + ' satisfactoriamente.', Exclamation!)
		
	catch (Exception ex)
		MessageBox('Exception ' + ex.ClassName(), 'Ha ocurrido una excepción al momento de generar el archivo ' + ls_path + '.~r~nMensaje de la exception: ' + ex.getMessage(), StopSign!)
		
	finally
		Destroy lnvo_pdf
		
	end try
	
End If
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

public subroutine of_get_col_list (str_col_pop astr_pop);SetPointer(HourGlass!)

OpenWithParm(w_cns_col_pop, astr_pop)

end subroutine

public subroutine of_color (long al_value);THIS.Object.DataWindow.Color = al_value
end subroutine

public subroutine of_protect ();String ls_colname, ls_value, ls_property = "Protect"
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
	
	if li_pos > 0 then
		ls_colname = Mid(ls_colname,li_pos + 1)	
	end if
	
	if this.of_valid_property( ls_colname, ls_property) then
		ls_colname = ls_colname + "." + ls_property + "=" + ls_value
		ls_colname = THIS.Modify(ls_colname)
	end if
	
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

public function boolean of_save_log ();boolean lbo_ok = true

IF ib_log and UpperBound(ii_ck) > 0 THEN
		
	try 
		IF ids_log.Update(true, false) = -1 THEN
			lbo_ok = FALSE
			ROLLBACK USING SQLCA;
			MessageBox('Error en Datawindow ' + this.ClassName(), 'No se pudo grabar el Log Diario, por favor verifique')
		END IF
	
	catch ( Exception ex )
		
		lbo_ok = false
		MessageBox('Error en grabación de LogDiario: ' + this.ClassName(), 'Exception: ' + ex.getMessage() + ', por favor verifique')
	
	finally
		DESTROY ids_log
	end try		
	
END IF

return lbo_ok
end function

public subroutine of_create_log ();if this.ib_log and UpperBound(ii_ck) > 0 then
	//Nombre de tabla a grabar en el Log Diario
	
	if not isNull(this.Object.Datawindow.Table.UpdateTable) and trim(this.Object.Datawindow.Table.UpdateTable) <> '' then
		is_tabla = upper(this.Object.Datawindow.Table.UpdateTable)  
		
		invo_log = Create n_cst_log_diario
		invo_log.of_dw_map(this, is_colname_a, is_coltype_a)
	
		ids_log = Create u_ds_base
		ids_log.DataObject = 'd_log_diario_tbl'
		ids_log.SetTransObject(SQLCA)
		
		invo_log.of_create_log(this, ids_log, is_colname_a, is_coltype_a, gs_user, is_tabla)
	else
		MessageBox('Error', 'No se ha especificado Tabla de Actualizacion en DataWindow ' + this.ClassName(), StopSign!)
		return
	end if
	
end if

	
end subroutine

public function boolean of_existecampo (string as_campo);IF this.Describe(as_campo + ".ColType") = '!' THEN return false

return true
end function

public function integer of_nro_item ();// Genera numero de item para un dw
Integer ll_i, ll_mayor

if this.RowCount() <= 1 then
	ll_mayor = 1
else
	if this.of_Existecampo( "nro_item") then
		ll_mayor = Long(this.object.nro_item[1])
	elseif this.of_Existecampo( "item") then
		ll_mayor = Long(this.object.item[1])
	else
		MessageBox("Error", "No se ha especificado un campo NRO_ITEM o ITEM para autonumerar, por favor verificar!", StopSign!)
		return -1
	end if
	
	if isnull(ll_mayor) then
		ll_mayor = 0
	end if
	
	For ll_i = 1 to this.RowCount()
		if this.of_Existecampo( "nro_item") then
			if Long(this.object.nro_item[ll_i]) > ll_mayor then
				ll_mayor = Long(this.object.nro_item[ll_i])
			end if
		elseif this.of_Existecampo( "item") then
			if Long(this.object.item[ll_i]) > ll_mayor then
				ll_mayor = Long(this.object.item[ll_i])
			end if
		end if
	Next
	
	ll_mayor ++

end if

Return ll_mayor
end function

public function boolean of_search_text (string as_texto, integer ai_opcion);// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_cols, li_i, li_longitud
Long		ll_row
String	ls_columna, ls_coltype, ls_search, ls_comando

/*
	ai_opcion = 1  comienza
	ai_opcion = 2 	contiene
*/

try 
	SetPointer(hourglass!)
	
	li_longitud = len(trim(as_texto))
	
	if li_longitud = 0 then return false
	
	li_cols=integer(this.describe('datawindow.column.count')) 
	
	ls_search = ''
	
	for li_i=1 to li_cols 
		ls_columna = this.describe('#' + string(li_i) + '.name') 
		ls_coltype = this.Describe(ls_columna + ".ColType")
		
		IF UPPER( LEFT(ls_coltype,4) ) = 'NUMB' OR UPPER( LEFT(ls_coltype,4) ) = "DECI" then
			if ai_opcion = 1 then
				//Busqueda comienza
				ls_comando = "LEFT(string(" + ls_columna + ")," + string(li_longitud) + ")=" + trim(as_texto) 
			else
				ls_comando = "POS(string(" + ls_columna + "), '" + as_texto + "') > 0"
			end if
			
		ELSEIF UPPER( LEFT(ls_coltype,4) ) = 'CHAR' then
			if ai_opcion = 1 then
				//Busqueda comienza
				ls_comando = "UPPER( LEFT(" + ls_columna +", " + String(li_longitud) + "))='" + trim(as_texto)  + "'"
			else
				ls_comando = "POS(upper(" + ls_columna + "), upper('" + as_texto + "')) > 0"
			end if

		   
		ELSEIF UPPER( LEFT(ls_coltype,4) ) = 'DATE' then
			if ai_opcion = 1 then
				//Busqueda comienza
				ls_comando = "LEFT( STRING(" + ls_columna +",'dd/mm/yyyy'), " + string(li_longitud) + ") = '" + as_texto + "'"
			else
				ls_comando = "POS(string(" + ls_columna + ", 'dd/mm/yyyy'), '" + as_texto + "') > 0"
			end if
		END IF		
		
		if ls_search = '' then
			ls_search = ls_comando
		else
			ls_search = ls_search + ' or ' + ls_comando
		end if
		
	next 
	
	ll_row = this.find(ls_search, 1, this.RowCount())	
		
		if ll_row > 0 then		// la busqueda resulto exitosa
			this.selectrow(0, false)
			this.selectrow(ll_row,true)
			this.scrolltorow(ll_row)
			
			this.expand(ll_row, 4)
			
			// ubica			
			this.Event ue_output(ll_row)	
			this.groupcalc( )
			
			
		elseif ll_row = -1 then
			
			MessageBox(This.ClassName(), "Error General, Comando: " &
					+ ls_search, Exclamation!)
					
		elseif ll_row = -5 then
			
			MessageBox(This.ClassName(), "Error en argumentos, Comando: " &
					+ ls_search, Exclamation!)
					
		elseif ll_row = 0 then
			
			this.SelectRow(0, false)
			
		end if

	return true
	
catch ( Exception ex )
	MessageBox('Error: ' + this.ClassName(), 'Ha ocurrido una excepcion: ' + ex.getMessage())
	return false
finally
	SetPointer(Arrow!)
end try




//
//
//if TRIM( is_col ) <> '' THEN
//
//	ls_item = upper( this.GetText() )
//
//	li_longitud = len( ls_item )
//
//	if li_longitud > 0 then		// si ha escrito algo
//
//	   IF UPPER( LEFT(is_type,4) ) = 'NUMB' OR UPPER( LEFT(is_type,4) ) = "DECI" then
//			ls_comando = is_col + "=" + ls_item 
//		ELSEIF UPPER( LEFT(is_type,4) ) = 'CHAR' then
//		   ls_comando = "UPPER( LEFT(" + is_col +", " + String(li_longitud) + "))='" + ls_item + "'"
//		ELSEIF UPPER( LEFT(is_type,4) ) = 'DATE' then
//		   ls_comando = "LEFT( STRING(" + is_col +",'dd/mm/yyyy'), " + string(li_longitud) + ") = '" + ls_item + "'"
//		END IF		
//		
//		ll_fila = dw_master.find(ls_comando, 1, dw_master.RowCount())	
//		
//		if ll_fila > 0 then		// la busqueda resulto exitosa
//			dw_master.selectrow(0, false)
//			dw_master.selectrow(ll_fila,true)
//			dw_master.scrolltorow(ll_fila)
//			// ubica			
//			dw_master.Event ue_output(ll_fila)			
//		elseif ll_fila = -1 then
//			MessageBox(This.ClassName(), "Error General, Comando: " &
//					+ ls_comando, Exclamation!)
//		elseif ll_fila = -5 then
//			MessageBox(This.ClassName(), "Error en argumentos, Comando: " &
//					+ ls_comando, Exclamation!)
//		elseif ll_fila = 0 then
//			dw_master.SelectRow(0, false)
//		end if
//	End if	
//else
//	Messagebox( "Aviso", "Seleccione el orden haciendo doble click en el titulo")
//	dw_1.reset()
//	this.insertrow(0)
//end if	
//
//SetPointer(arrow!)
end function

public function boolean of_split_texto (string as_texto, string as_divisor);is_palabras = invo_utility.of_split(as_texto, as_divisor).str_array

return true

end function

public function string of_get_filter_text (string as_texto, integer ai_opcion);// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

Integer 	li_cols, li_i, li_longitud, ll_index
Long		ll_row
String	ls_columna, ls_coltype, ls_filter, ls_comando

/*
	ai_opcion = 1  comienza
	ai_opcion = 2 	contiene
	ai_opcion = 3	Buscar por palabras
*/

try 
	SetPointer(hourglass!)
	
	li_longitud = len(trim(as_texto))
	
	if li_longitud = 0 then 
		
		ls_filter = ''
		
	else
				
		li_cols=integer(this.describe('datawindow.column.count')) 
		
		ls_filter = ''
		
		for li_i=1 to li_cols 
			ls_columna = this.describe('#' + string(li_i) + '.name') 
			ls_coltype = this.Describe(ls_columna + ".ColType")
			
			IF UPPER( LEFT(ls_coltype,4) ) = 'NUMB' OR UPPER( LEFT(ls_coltype,4) ) = "DECI" then
				if ai_opcion = 1 then
					//Busqueda comienza
					ls_comando = "LEFT(string(" + ls_columna + ")," + string(li_longitud) + ")='" + trim(as_texto) + "'"
				elseif ai_opcion = 2 then
					ls_comando = "POS(string(" + ls_columna + "), '" + as_texto + "') > 0"
				else
					this.of_split_texto(as_texto, ' ')
					ls_comando = ''
					
					for ll_index = 1 to UpperBound(is_palabras)
						ls_comando += "POS(string(" + ls_columna + "), '" + is_palabras[ll_index] + "') > 0"
						
						if UpperBound(is_palabras) > 0 and ll_index < UpperBound(is_palabras) then
							ls_comando += " AND "
						end if
					next
					
					ls_comando = trim(ls_comando)
				end if
				
			ELSEIF UPPER( LEFT(ls_coltype,4) ) = 'CHAR' then
				if ai_opcion = 1 then
					//Busqueda comienza
					ls_comando = "UPPER( LEFT(" + ls_columna +", " + String(li_longitud) + "))='" + trim(as_texto)  + "'"
				elseif ai_opcion = 2 then
					ls_comando = "POS(upper(" + ls_columna + "), upper('" + as_texto + "')) > 0"
				else
					this.of_split_texto(as_texto, ' ')
					ls_comando = ''
					
					for ll_index = 1 to UpperBound(is_palabras)
						ls_comando += "POS(upper(" + ls_columna + "), upper('" + is_palabras[ll_index] + "')) > 0"
						
						if UpperBound(is_palabras) > 0 and ll_index < UpperBound(is_palabras) then
							ls_comando += " AND "
						end if
					next
					
					ls_comando = trim(ls_comando)
				end if
	
				
			ELSEIF UPPER( LEFT(ls_coltype,4) ) = 'DATE' then
				if ai_opcion = 1 then
					//Busqueda comienza
					ls_comando = "LEFT( STRING(" + ls_columna +",'dd/mm/yyyy'), " + string(li_longitud) + ") = '" + as_texto + "'"
				elseif ai_opcion = 2 then
					ls_comando = "POS(string(" + ls_columna + ", 'dd/mm/yyyy'), '" + as_texto + "') > 0"
				else
					this.of_split_texto(as_texto, ' ')
					ls_comando = ''
					
					for ll_index = 1 to UpperBound(is_palabras)
						ls_comando += "POS(string(" + ls_columna + ", 'dd/mm/yyyy'), '" + is_palabras[ll_index] + "') > 0"
						
						if UpperBound(is_palabras) > 0 and ll_index < UpperBound(is_palabras) then
							ls_comando += " AND "
						end if
					next
					
					ls_comando = trim(ls_comando)
				end if
			END IF		
			
			ls_comando = "(" + ls_comando + ")"
			
			if ls_filter = '' then
				ls_filter = ls_comando
			else
				ls_filter = ls_filter + ' or ' + ls_comando
			end if
			
		next 
		
	end if
	
	return ls_filter
	
catch ( Exception ex )
	MessageBox('Error: ' + this.ClassName(), 'Ha ocurrido una excepcion: ' + ex.getMessage())
	return gnvo_app.is_null
	
finally
	SetPointer(Arrow!)
	
end try





end function

public function boolean of_filtrar (string as_texto, integer ai_opcion);// Si el usuario comienza a editar una columna, entonces reordenar el dw superior segun
// la columna que se este editando, y luego hacer scroll hasta el valor que se ha ingresado para 
// esta columna, tecla por tecla.

String	ls_filter

/*
	ai_opcion = 1  comienza
	ai_opcion = 2 	contiene
	ai_opcion = 3	Buscar por palabras
*/

try 
	SetPointer(hourglass!)
	
	ls_filter = this.of_get_filter_text(as_texto, ai_opcion)
	
	this.setFilter(ls_filter)
	this.Filter()
	
	return true
	
catch ( Exception ex )
	MessageBox('Error: ' + this.ClassName(), 'Ha ocurrido una excepcion: ' + ex.getMessage())
	return false
	
finally
	SetPointer(Arrow!)
	
end try





end function

public function boolean of_find (string as_texto, integer ai_opcion);String	ls_find
Long		ll_find

/*
	ai_opcion = 1  comienza
	ai_opcion = 2 	contiene
	ai_opcion = 3	Buscar por palabras
*/

try 
	SetPointer(hourglass!)
	
	ls_find = this.of_get_filter_text(as_texto, ai_opcion)
	
	if this.RowCount() > 0 then
		ll_find = this.Find(ls_find, 1, this.RowCount())
		
		if ll_find > 0 then
			this.SetRow(ll_find)
			this.SelectRow(0, false)
			this.SelectRow(ll_find, true)
			this.ScrollToRow(ll_find)
		else
			this.SetRow(1)
			this.ScrollToRow(1)
			this.SelectRow(0, false)
		end if
		
	end if
	
	return true
	
catch ( Exception ex )
	MessageBox('Error: ' + this.ClassName(), 'Ha ocurrido una excepcion: ' + ex.getMessage())
	return false
	
finally
	SetPointer(Arrow!)
	
end try





end function

public function boolean is_protect (string as_campo, long al_row);String ls_string, ls_evaluate

if al_row = 0 then return true

ls_string = this.Describe(lower(as_campo) + '.Protect' )
if len(ls_string) > 1 then
 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(al_row) + ")"
 
 	if this.Describe(ls_evaluate) = '1' then return true
else
 	if ls_string = '1' then return true
end if

return false
end function

public function boolean is_row_new (long al_row);dwItemStatus l_status
l_status = this.GetItemStatus(al_Row, 0, Primary!)

IF l_status = New! OR l_status = NewModified! THEN
	return true
ELSE
	return false
END IF
end function

public function boolean is_row_modified (long al_row);dwItemStatus l_status
l_status = this.GetItemStatus(al_Row, 0, Primary!)

IF l_status <> NotModified! THEN
	return true
ELSE
	return false
END IF
end function

public function string of_get_tabla () throws exception;String ls_tabla
Exception ex

if this.DataObject = '' or IsNull(this.DataObject) then
	ex = create Exception
	ex.setMessage("No se ha indicado el Objeto DataWindows para el control " + this.ClassName())
	throw ex
	return ls_tabla
end if

ls_tabla = upper(this.Object.Datawindow.Table.UpdateTable)  

return ls_tabla
end function

public function boolean of_valid_property (string as_campo, string as_property);IF this.Describe(as_campo + "." + as_property) = '!' THEN return false

return true
end function

public function string of_get_updatetable ();return this.Object.Datawindow.Table.UpdateTable
end function

event dberror;String 	ls_msg, ls_crlf, ls_prop, ls_const, ls_cadena, &
			ls_name, ls_pos, ls_cab_msg
Integer 	li_pos_ini, li_pos_fin, li_pos_nc, li_len
 
ls_crlf = char(13) + char(10)
li_pos_ini = Pos(sqlerrtext,'(',1) + 1
li_pos_fin = Pos(sqlerrtext,')',li_pos_ini) - 1
 
ls_cadena 	= Mid(sqlerrtext,li_pos_ini,li_pos_fin - (li_pos_ini - 1) )
li_pos_nc 	= Pos(ls_cadena,'.',1) - 1 
ls_prop   	= Mid(ls_cadena,1,li_pos_nc)
ls_const  	= Mid(ls_cadena,li_pos_nc + 2)

ls_cab_msg = 'DBError en objeto: ' + This.Classname() + ". Clase (u_dw_abc)"
 
CHOOSE CASE sqldbcode 
	CASE 02292                         
  		// Eliminar y Existen registros en tablas dependientes
		SELECT TABLE_NAME
        		INTO :ls_name
        	FROM ALL_CONSTRAINTS
       	WHERE OWNER          = :ls_prop  
		      AND CONSTRAINT_NAME = :ls_const;
 
  		ROLLBACK;
      	Messagebox(ls_cab_msg,'Error en Llave Foránea ' + ls_const + ', Registro tiene Movimientos en Tabla: '+ls_name)
      	Return 1

	case 20000 to 29999
		// Encontrar el error
		
		li_pos_ini = POS( sqlerrtext, ':')
	
		ls_cadena = MID( sqlerrtext, li_pos_ini + 2, len(sqlerrtext) )			
		li_pos_fin = pos( ls_cadena, 'ORA')
		ls_cadena = MID( sqlerrtext, li_pos_ini + 2, li_pos_fin - 1)
		ROLLBACK;
		Messagebox( ls_cab_msg, ls_cadena, stopsign!)
      Return 1	
		
	CASE ELSE
		ls_msg  = 'Database: ' + SQLCA.Database + ls_crlf
		ls_msg += 'DBMS: ' + SQLCA.DBMS + ls_crlf
		ls_msg += 'Lock: ' + SQLCA.Lock + ls_crlf
		ls_msg += 'ServerName: ' + SQLCA.ServerName + ls_crlf
		ls_msg += 'SQLCode: ' + String(SQLCA.SQLCode) + ls_crlf
		ls_msg += 'SQLDBCode: ' + String(SQLDBCode) + ls_crlf
		ls_msg += 'Registro en Datawindow: ' + String(row) + ls_crlf
		ls_msg += 'SQLNRows: ' + String(SQLCA.SQLNRows) + ls_crlf
		ls_msg += 'SQLReturnData: ' + SQLCA.SQLReturnData + ls_crlf
		ls_msg += 'UserID: ' + SQLCA.UserID + ls_crlf
		ls_msg += 'SQLErrText: ' + SQLErrText 
		ROLLBACK;
		messagebox(ls_cab_msg, ls_msg, StopSign!)
END CHOOSE


end event

event itemchanged;ii_update = 1

IF THIS.Describe("flag_replicacion.ColType") <> '!' THEN 
    THIS.Object.flag_replicacion[row] = '1'
END IF

//String ls_data
//
//this.Accepttext()
//
//CHOOSE CASE dwo.name
//	CASE 'cod_art'
//		
//		// Verifica que codigo ingresado exista			
//		Select desc_art
//	     into :ls_data
//		  from articulo
//		 Where cod_art = :data 
//		   and flag_estado = '1';
//			
//		// Verifica que articulo solo sea de reposicion		
//		if SQLCA.SQLCode = 100 then
//			this.object.cod_art	[row] = gnvo_app.is_null
//			this.object.desc_art	[row] = gnvo_app.is_null
//			MessageBox('Error', 'Codigo de Artículo no existe o no esta activo, por favor verifique')
//			return 1
//		end if
//
//		this.object.desc_art			[row] = ls_data
//
//	CASE 'almacen'
//		
//		// Verifica que codigo ingresado exista			
//		Select desc_almacen
//	     into :ls_data
//		  from almacen
//		 Where almacen = :data 
//		   and flag_estado = '1';
//			
//		// Verifica que articulo solo sea de reposicion		
//		if SQLCA.SQLCode = 100 then
//			this.object.almacen	[row] = gnvo_app.is_null
//			MessageBox('Error', 'Código de Almacen no existe o no esta activo, por favor verifique')
//			return 1
//		end if
//
//END CHOOSE
end event

event clicked;if is_dwform = 'form' then return

IF row = 0 THEN 
	if ib_filter then
		//Click izquierdo del mouse
		this.iu_powerfilter.post event ue_buttonclicked(dwo.type, dwo.name)
	end if
	RETURN
end if

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

this.setTransObject(SQLCA)



this.is_tabla = ''

//Para el filtro avanzado
this.iu_powerfilter = create n_cst_powerfilter
this.iu_powerfilter.of_setdw(this)

//Para el menu contextual
im_menu = create m_rbutton_ancst
im_menu.idw_1 = this
end event

event doubleclicked;IF is_dwform = 'tabular' THEN
	THIS.Event ue_column_sort()
ELSE
	IF row = 0 THEN RETURN
	il_row = row                    // fila corriente
	THIS.SetRow(row)
	THIS.Event ue_output(row)
END IF

//string ls_columna
//if not this.is_protect(dwo.name, row) and row > 0 then
//	ls_columna = upper(dwo.name)
//	THIS.event dynamic ue_display(ls_columna, row)
//end if

//string ls_columna, ls_string, ls_evaluate
//
//THIS.AcceptText()
//
//ls_string = this.Describe(lower(dwo.name) + '.Protect' )
//if len(ls_string) > 1 then
// 	ls_string = Mid(ls_string, Pos(ls_string, '~t') + 1)
// 	ls_string = Mid(ls_string,1, len(ls_string) - 1 )
// 	ls_evaluate = "Evaluate('" + ls_string + "', " + string(row) + ")"
// 
// 	if this.Describe(ls_evaluate) = '1' then return
//else
// 	if ls_string = '1' then return
//end if
//
//IF row > 0 THEN
//	ls_columna = upper(dwo.name)
//	THIS.event dynamic ue_display(ls_columna, row)
//END IF



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


//
end event

event losefocus;THIS.AcceptText()
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

on u_dw_abc.create
end on

on u_dw_abc.destroy
end on

event updateend;ib_insert_mode = False
end event

event itemerror;return 1
end event

event destructor;destroy invo_log
destroy ids_log
destroy iu_powerfilter
destroy im_menu
end event

event rowfocuschanged;if currentrow <= 0 then return

if currentrow = il_Row then return

il_row = currentrow              // fila corriente

IF this.is_dwform <> 'form' and ii_ss = 1 THEN		        // solo para seleccion individual			
	This.SelectRow(0, False)
	This.SelectRow(currentrow, True)
	THIS.SetRow(currentrow)
	this.event ue_output(currentrow)
	RETURN
END IF
end event

