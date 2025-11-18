$PBExportHeader$w_sig713_consulta_grf_pop.srw
$PBExportComments$Ventana para crear dinamicamente consultas en cascada
forward
global type w_sig713_consulta_grf_pop from w_cns
end type
type st_2 from statictext within w_sig713_consulta_grf_pop
end type
type sle_valor from singlelineedit within w_sig713_consulta_grf_pop
end type
type st_1 from statictext within w_sig713_consulta_grf_pop
end type
type dw_master from u_dw_cns within w_sig713_consulta_grf_pop
end type
end forward

global type w_sig713_consulta_grf_pop from w_cns
integer width = 809
integer height = 692
string menuname = "m_cns_pop"
st_2 st_2
sle_valor sle_valor
st_1 st_1
dw_master dw_master
end type
global w_sig713_consulta_grf_pop w_sig713_consulta_grf_pop

type variables
str_cns_pop istr_1
str_sig713_grf_pop istr_2
String  		is_column, is_argname[]
Integer		ii_grf_val_index
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
Integer	li_p[6], li_len, li_rc = -1, li_len_args, li_pos, li_x, li_px[]

ls_str = idw_1.Describe(as_column + '.tag')

li_len = Len(ls_str)
IF li_len < 11 THEN GOTO SALIDA

li_p[1] = pos(ls_str,'|')						//ubicar separadores
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

on w_sig713_consulta_grf_pop.create
int iCurrent
call super::create
if this.MenuName = "m_cns_pop" then this.MenuID = create m_cns_pop
this.st_2=create st_2
this.sle_valor=create sle_valor
this.st_1=create st_1
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_2
this.Control[iCurrent+2]=this.sle_valor
this.Control[iCurrent+3]=this.st_1
this.Control[iCurrent+4]=this.dw_master
end on

on w_sig713_consulta_grf_pop.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_2)
destroy(this.sle_valor)
destroy(this.st_1)
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
istr_2 = Message.PowerObjectParm				// lectura de parametros

idw_1.DataObject = istr_2.DataObject    	// asignar datawindow
THIS.title  = istr_2.title						// asignar titulo de la ventana
THIS.width  = istr_2.width						// asignar ancho y altura de ventana
THIS.height = istr_2.height
ii_grf_val_index = istr_2.grf_val_index

	
idw_1.SetTransObject(SQLCA)

ll_row = dw_master.Retrieve(istr_2.arg_s[1], istr_2.arg_S[2], istr_2.arg_dt[1], istr_2.arg_dt[2])


// ii_help = 101           					// help topic
//of_position_window(0,0)        			// Posicionar la ventana en forma fija





end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

type st_2 from statictext within w_sig713_consulta_grf_pop
integer x = 649
integer y = 20
integer width = 105
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "tm"
alignment alignment = center!
boolean focusrectangle = false
end type

type sle_valor from singlelineedit within w_sig713_consulta_grf_pop
integer x = 247
integer y = 12
integer width = 384
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_sig713_consulta_grf_pop
integer x = 32
integer y = 28
integer width = 224
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor:"
boolean focusrectangle = false
end type

type dw_master from u_dw_cns within w_sig713_consulta_grf_pop
integer x = 9
integer y = 96
integer width = 485
integer height = 328
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

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



end event

event constructor;call super::constructor;ii_ck[1] = 1         // columnas de lectrua de este dw
ii_dk[1] = 1 
end event

event clicked;call super::clicked;grObjectType	lgr_click_obj
string			ls_grgraphname="gr_1", ls_find, ls_category 
String			ls_dato, ls_work, ls_temp
int				li_series, li_category
Long				ll_rc, ll_row, ll_plantas
Decimal			ldc_total

// Ubicar en que lugar del grafico se Clicko
lgr_click_obj = this.ObjectAtPointer (ls_grgraphname, li_series, &
						li_category)
// Determinar que categoria se Clicko
If lgr_click_obj = TypeData!  or &
	lgr_click_obj = TypeCategory!  then
		ls_dato = this.CategoryName (ls_grgraphname, li_category)
		ls_category = THIS.Describe(ls_grgraphname + '.Category')
		ls_work = THIS.Describe(ls_grgraphname + '.Values')
		ls_dato = Trim(ls_dato)
		ls_find = ls_category + " = '" + ls_dato + "'"
		ll_row = THIS.Find(ls_find, 1, THIS.RowCount())
		IF ll_row < 1 THEN
			MessageBox('Error ' + ls_dato, 'No se pudo encontrar el dato')
		ELSE
			ldc_total = ROUND(THIS.object.data.primary.current[ll_row, ii_grf_val_index],2)
			sle_valor.Text = String(ldc_total)
		END IF
Else
	MessageBox (Parent.Title, "Haga Click en la Parte del Grafico que desee Consultar")
End If


end event

