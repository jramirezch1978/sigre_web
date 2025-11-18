$PBExportHeader$w_grf_pop.srw
$PBExportComments$Ventana para crear dinamicamente consultas en cascada
forward
global type w_grf_pop from w_cns
end type
type st_etiqueta from statictext within w_grf_pop
end type
type dw_master from u_dw_cns within w_grf_pop
end type
end forward

global type w_grf_pop from w_cns
integer width = 599
integer height = 644
string menuname = "m_grf_pop"
st_etiqueta st_etiqueta
dw_master dw_master
end type
global w_grf_pop w_grf_pop

type variables
str_cns_pop istr_1
String  		is_column, is_argname[], is_tipo_graf
Integer		ii_mousemove

end variables

forward prototypes
public function long of_retrieve ()
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3)
public subroutine of_set_column_pointer (string as_pointer)
public function integer of_get_next_str (string as_column)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4)
public subroutine of_cambio_grf (string as_direccion)
end prototypes

public function long of_retrieve ();Long	ll_row

ll_row = dw_master.Retrieve()

Return ll_row
end function

public function long of_retrieve (string as_arg1);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1)

Return ll_row
end function

public function long of_retrieve (string as_arg1, string as_arg2);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2)

Return ll_row
end function

public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3)

Return ll_row
end function

public subroutine of_set_column_pointer (string as_pointer);Integer	li_x

FOR li_x = 1 TO UPPERBOUND(is_argname)
	idw_1.Modify(is_argname[li_x] + ".Pointer = " + as_pointer)
NEXT

end subroutine

public function integer of_get_next_str (string as_column);String	ls_str, ls_args
Integer	li_p[8], li_len, li_rc = -1, li_len_args, li_pos, li_x, li_px[]

ls_str = idw_1.Describe(as_column + '.tag')

li_len = Len(ls_str)
IF li_len < 11 THEN GOTO SALIDA

li_p[1] = pos(ls_str, '|')						//ubicar separadores
li_p[2] = pos(ls_str, '|', li_p[1] + 1)
li_p[3] = pos(ls_str, '|', li_p[2] + 1)
li_p[4] = pos(ls_str, '|', li_p[3] + 1)
li_p[5] = pos(ls_str, '|', li_p[4] + 1)
li_p[6] = pos(ls_str, '|', li_p[5] + 1)

IF li_p[1] = 0 THEN
	MessageBox('Error', 'No se ha encontrado Separador |')
	GOTO SALIDA
END IF

is_column = Left(ls_str, li_p[1] - 1)		// extraer campos 
istr_1.DataObject = Mid(ls_str, li_p[1] + 1, li_p[2] - li_p[1] -1)
istr_1.Title	   = Mid(ls_str, li_p[2] + 1, li_p[3] - li_p[2] -1)
istr_1.Width		= Integer(Mid(ls_str, li_p[3] + 1, li_p[4] - li_p[3] -1))
istr_1.Height		= Integer(Mid(ls_str, li_p[4] + 1, li_p[5] - li_p[4] -1))
istr_1.NextCol		= Mid(ls_str, li_p[5] + 1, li_p[6] - li_p[5] -1)
ls_args				= Mid(ls_str, li_p[6] + 1)   // argumentos para el next column
li_rc = 1

li_len_args = Len(ls_args)
IF li_len_args <1 THEN GOTO SALIDA
li_x = 0

Do 										// ubicar separadores de argumentos del next column
	li_x ++
	IF li_x = 1 THEN 
		li_pos = pos(ls_args,'|')
	ELSE
		li_pos = pos(ls_args,'|', li_p[li_x - 1] + 1)
	END IF
	li_p[li_x] = li_pos
LOOP UNTIL li_pos = 0

CHOOSE CASE li_x						// EXTRAER nombre de columnas para el next
	CASE 1
		is_argname[1] = ls_args
	CASE 2
		is_argname[1] = Left(ls_args, li_p[1] - 1)
		is_argname[2] = Mid(ls_args, li_p[1] + 1)
	CASE 3
		is_argname[1] = Left(ls_args, li_p[1] - 1)
		is_argname[2] = Mid(ls_args, li_p[1] + 1, li_p[2] - li_p[1] - 1)
		is_argname[3] = Mid(ls_args, li_p[2] + 1)
	CASE 4
		is_argname[1] = Left(ls_args, li_p[1] - 1)
		is_argname[2] = Mid(ls_args, li_p[1] + 1, li_p[2] - li_p[1] - 1)
		is_argname[3] = Mid(ls_args, li_p[2] + 1, li_p[3] - li_p[2] - 1)
		is_argname[4] = Mid(ls_args, li_p[3] + 1)
END CHOOSE


SALIDA:
RETURN li_rc			// Return -1 = error, 1 = ok

end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5, as_arg6)

Return ll_row
end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5)

Return ll_row
end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4)

Return ll_row
end function

public subroutine of_cambio_grf (string as_direccion);Integer	li_tipo_grf

li_tipo_grf = Integer(idw_1.Object.gr_1.GraphType)


IF UPPER(as_direccion) = 'P' THEN
	li_tipo_grf --
	IF li_tipo_grf <1 THEN li_tipo_grf = 17
ELSE
	li_tipo_grf ++
	IF li_tipo_grf > 17 THEN li_tipo_grf = 1
END IF

idw_1.Object.gr_1.GraphType = li_tipo_grf


end subroutine

on w_grf_pop.create
int iCurrent
call super::create
if this.MenuName = "m_grf_pop" then this.MenuID = create m_grf_pop
this.st_etiqueta=create st_etiqueta
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_etiqueta
this.Control[iCurrent+2]=this.dw_master
end on

on w_grf_pop.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_etiqueta)
destroy(this.dw_master)
end on

event open;// override

THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre;call super::ue_open_pre;Long		ll_row
String	ls_rc, ls_modify
Integer	li_rc
Long		ll_total
Menu		lm_1, lm_menu

lm_1 = THIS.MenuID
idw_1 = dw_master              				// asignar dw corriente
istr_1 = Message.PowerObjectParm				// lectura de parametros

idw_1.DataObject = istr_1.DataObject    	// asignar datawindow
THIS.title  = istr_1.title						// asignar titulo de la ventana
THIS.width  = istr_1.width						// asignar ancho y altura de ventana
THIS.height = istr_1.height
ii_mousemove = istr_1.grf_val_index

//IF istr_1.flag_impresion THEN
//	lm_menu = lm_1.item[1]
//	lm_menu.visible = True
//	lm_menu.enabled = True
//	lm_menu.toolbaritemvisible = True
//END IF
	
idw_1.SetTransObject(SQLCA)

IF IsValid(istr_1.dw) THEN
	IF istr_1.flag_share THEN
		istr_1.dw.ShareData(idw_1)
	ELSE
		ll_total = istr_1.dw.RowCount()
		istr_1.dw.RowsCopy(1, ll_total, Primary!, idw_1, 1, Primary!)
	END IF
ELSE
	ll_row = of_retrieve(istr_1.arg[1], istr_1.arg[2], istr_1.arg[3], istr_1.arg[4], istr_1.arg[5], istr_1.arg[6])
end if

IF istr_1.nextcol <> '' THEN
	li_rc = of_get_next_str(istr_1.nextcol)
	ls_modify = is_column + ".Pointer = '" + "\source\cur\taladro.cur'"
	ls_rc = idw_1.Modify( ls_modify )
END IF

// ii_help = 101           					// help topic
//of_position_window(0,0)        			// Posicionar la ventana en forma fija


//Long		ll_numitems
//Menu		lm_1
//Integer	li_rc
//
//lm_1 = THIS.MenuID
//
//ll_numitems = Upperbound(lm_1.item)
//
//IF ll_numitems > 1 THEN
//	of_display_items(lm_1, ll_numitems, 1)
//END IF
//



end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

type st_etiqueta from statictext within w_grf_pop
integer x = 955
integer y = 76
integer width = 110
integer height = 64
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 65535
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_grf_pop
event ue_mousemove pbm_mousemove
integer width = 485
integer height = 328
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_mousemove;IF ii_mousemove > 0 THEN
	Int  li_Rtn, li_Series, li_Category 
	String  ls_serie, ls_categ, ls_cantidad, ls_mensaje 
	Long ll_row 
	grObjectType MouseMoveObject 
	MouseMoveObject = THIS.ObjectAtPointer('gr_1', li_Series, li_category)
	IF MouseMoveObject = TypeData! OR MouseMoveObject = TypeCategory! THEN 
 		ls_categ = this.CategoryName('gr_1', li_Category)   //la etiqueta de las categorías 
 		ls_serie = this.SeriesName('gr_1', li_Series)       //la etiqueta de lo de abajo 
 		ls_cantidad = string(this.GetData('gr_1', li_series, li_category), '###,##0.00') //la etiqueta de los valores
 		ls_mensaje = trim(ls_cantidad) + ' ('+trim(ls_serie)+' | '+trim(ls_categ)+')'
 		st_etiqueta.BringToTop = TRUE 
 		st_etiqueta.x = xpos 
 		st_etiqueta.y = ypos - 70
 		st_etiqueta.text = ls_mensaje 
 		st_etiqueta.width = len(ls_mensaje) * 30 
 		st_etiqueta.visible = true 
	ELSE 
 		st_etiqueta.visible = false 
	END IF
END IF


end event

event doubleclicked;call super::doubleclicked;grObjectType	lgr_click_obj
string			ls_grgraphname="gr_1", ls_find, ls_category 
String			ls_dato, ls_work, ls_temp
int				li_series, li_category
Long				ll_rc, ll_row, ll_plantas
Decimal			ldc_total

// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)
// Determinar que categoria se Clicko
IF lgr_click_obj = TypeData!  or lgr_click_obj = TypeCategory!  then
	IF istr_1.nextcol <> '' THEN
		ls_dato = this.CategoryName (ls_grgraphname, li_category)
		ls_category = THIS.Describe(ls_grgraphname + '.Category')
		ls_work = THIS.Describe(ls_grgraphname + '.Values')
		ls_dato = Trim(ls_dato)
		ls_find = ls_category + " = '" + ls_dato + "'"
		ll_row = THIS.Find(ls_find, 1, THIS.RowCount())
		IF ll_row < 1 THEN
			MessageBox('Error ' + ls_dato, 'No se pudo encontrar el dato')
		ELSE
			istr_1.Arg[1] = ls_dato
			of_new_sheet(istr_1)
		END IF
	END IF
End If

//IF row = 0 THEN RETURN
//
//Integer	li_x
//String	ls_type, ls_width
//
//IF dwo.Name = is_column  THEN
//	FOR li_x = 1 TO UPPERBOUND(is_argname)
//		ls_type = THIS.Describe(is_argname[li_x] + ".ColType")
////		MessageBox(is_argname[li_x], ls_type)
//		CHOOSE CASE ls_type
//			CASE 'Date'
//				istr_1.Arg[li_x] = String(GetItemDate(row,is_argname[li_x]), 'dd/mm/yyyy')
//			CASE 'DateTime'
//				istr_1.Arg[li_x] = String(GetItemDateTime(row,is_argname[li_x]), 'dd/mm/yyyy hh:mm:ss')
//			CASE Else
//				IF Left(ls_type,4) = 'char' THEN
//					istr_1.Arg[li_x] = GetItemString(row,is_argname[li_x])
////					MessageBox(is_argname[li_x], istr_1.Arg[li_x])
//				ELSE
//					istr_1.Arg[li_x] = String(GetItemNumber(row,is_argname[li_x]))
//				END IF
// 		END CHOOSE
//	NEXT
//	of_new_sheet(istr_1)
//END IF


end event

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
ii_dk[1] = 1 
end event

