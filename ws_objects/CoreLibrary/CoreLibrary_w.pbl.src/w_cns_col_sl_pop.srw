$PBExportHeader$w_cns_col_sl_pop.srw
$PBExportComments$Consulta, que muestra una lista, en la imputacion de datos
forward
global type w_cns_col_sl_pop from w_cns
end type
type pb_1 from picturebutton within w_cns_col_sl_pop
end type
type ddlb_operador from dropdownlistbox within w_cns_col_sl_pop
end type
type st_2 from statictext within w_cns_col_sl_pop
end type
type st_1 from statictext within w_cns_col_sl_pop
end type
type sle_valor from singlelineedit within w_cns_col_sl_pop
end type
type ddlb_filtro from dropdownlistbox within w_cns_col_sl_pop
end type
type dw_master from u_dw_cns within w_cns_col_sl_pop
end type
end forward

global type w_cns_col_sl_pop from w_cns
integer width = 1541
integer height = 764
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
event ue_load_filter ( )
pb_1 pb_1
ddlb_operador ddlb_operador
st_2 st_2
st_1 st_1
sle_valor sle_valor
ddlb_filtro ddlb_filtro
dw_master dw_master
end type
global w_cns_col_sl_pop w_cns_col_sl_pop

type variables
str_col_pop  istr_1
String  is_column, is_argname[], is_original
String  is_colname[], is_coltype[], is_coltitle[]
Integer	ii_index
end variables

forward prototypes
public function long of_retrieve ()
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4)
public subroutine of_set_column_pointer (string as_pointer)
public function string of_get_where (datawindow adw_object, string as_campo, string as_argumento)
end prototypes

event ue_load_filter();Integer			li_x, li_totcol
Long				ll_row, ll_rc

li_totcol = Integer(dw_master.Object.DataWindow.Column.Count)
ddlb_operador.text = '>='

FOR li_x = 1 to li_totcol
	is_colname[li_x] = dw_master.Describe('#' + String(li_x) + '.name')
	is_coltype[li_x] = dw_master.Describe(is_colname[li_x] + ".ColType")
	is_coltitle[li_x] = dw_master.Describe(is_colname[li_x] + ".Tag")
	IF is_coltitle[li_x] = '?' THEN is_coltitle[li_x] = is_colname[li_x]
	ll_rc = ddlb_filtro.AddItem(is_colname[li_x])
	CHOOSE CASE is_coltype[li_x]
		CASE 'date'
		CASE 'datetime'
		CASE Else
				IF Left(is_coltype[li_x],4) = 'char' THEN
					is_coltype[li_x] = 'char'
				ELSE
					is_coltype[li_x] = 'numeric'
				END IF
	END CHOOSE
Next



end event

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

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4)

Return ll_row
end function

public subroutine of_set_column_pointer (string as_pointer);Integer	li_x

FOR li_x = 1 TO UPPERBOUND(is_argname)
	dw_master.Modify(is_argname[li_x] + ".Pointer = " + as_pointer)
NEXT

end subroutine

public function string of_get_where (datawindow adw_object, string as_campo, string as_argumento);String  ls_sql,ls_descripcion, ls_temp
Integer ll_pos,ll_pos_two,ll_found
Boolean lb_where

ls_sql      = UPPER(adw_object.GetSQLSelect())
ll_found    = Pos(ls_sql,'WHERE',1)
ls_temp 		= as_campo

IF ll_found > 0 THEN 
   lb_where = false
ELSE
   lb_where = true
END IF	

ls_temp   = UPPER(ls_temp)
ll_pos      = Pos(ls_sql,' '+ls_temp,1) 
ls_sql      = Mid(ls_sql,1,ll_pos)
ll_pos_two = Pos(ls_sql,',',1)
ls_sql      = Mid(ls_sql,ll_pos_two)

DO WHILE ll_pos_two > 0
	ll_pos_two = Pos(ls_sql,',',1)
	IF ll_pos_two > 0 THEN 
	   ls_sql = Mid(ls_sql,ll_pos_two+1)
	ELSE
		ll_pos_two = 0
	END IF	
LOOP

ll_pos_two = Pos(ls_sql,'SELECT',1) 

IF ll_pos_two > 0 THEN 
	ls_sql = Mid(ls_sql,7)
END IF

ll_pos = Pos(ls_sql,' AS ',1) 
ls_sql = Mid(ls_sql,1,ll_pos)

IF ISNULL(as_argumento) OR  TRIM(as_argumento) = '' THEN 
	ls_descripcion = "'"+'%'+"'"
ELSE 
   ls_descripcion = "'"+TRIM(as_argumento)+'%'+"'"
END IF

IF lb_where THEN
   ls_temp = ' WHERE ( '+ls_sql+' LIKE '+ls_descripcion+' )'    
ELSE
	ls_temp = ' AND ( '+ls_sql+' LIKE '+ls_descripcion+' )'
END IF

Return ls_temp
end function

on w_cns_col_sl_pop.create
int iCurrent
call super::create
this.pb_1=create pb_1
this.ddlb_operador=create ddlb_operador
this.st_2=create st_2
this.st_1=create st_1
this.sle_valor=create sle_valor
this.ddlb_filtro=create ddlb_filtro
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.pb_1
this.Control[iCurrent+2]=this.ddlb_operador
this.Control[iCurrent+3]=this.st_2
this.Control[iCurrent+4]=this.st_1
this.Control[iCurrent+5]=this.sle_valor
this.Control[iCurrent+6]=this.ddlb_filtro
this.Control[iCurrent+7]=this.dw_master
end on

on w_cns_col_sl_pop.destroy
call super::destroy
destroy(this.pb_1)
destroy(this.ddlb_operador)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_valor)
destroy(this.ddlb_filtro)
destroy(this.dw_master)
end on

event open;// override

THIS.EVENT ue_open_pre()

end event

event resize;call super::resize;dw_master.width  = newwidth - dw_master.x - 10
dw_master.height = newheight - dw_master.y - 10
end event

event ue_open_pre();call super::ue_open_pre;// Contenido de str_list_pop

//String 		dataobject	Nombre  del datawindow object para la nueva ventana.
//String			Title			Titulo de la nueva ventana.
//Integer 		x				Ubicación x de la ventana pop
//Integer		y				Ubicación y de la ventana pop
//Integer		Width			Ancho de la nueva ventana.
//Integer		Height		Altura de la nueva ventana.
//String			field[]		Columna que recepciona el dato en w_cns_col_list.
//Integer		id[]			Código del campo que es el identificador
//Datawindow	dw				Datawindow para ser el retrieve al retorno
//Boolean		fixed			Indica: fijo = True, se borra depues de la selección = False
//String			arg[4]		Los cuatro argumentos posibles para leer el datawindow en la consulta.

Long		ll_row
String	ls_str
Integer	li_rc
Long		ll_total

idw_1 = dw_master              				// asignar dw corriente
istr_1 = Message.PowerObjectParm				// lectura de parametros

idw_1.DataObject = istr_1.DataObject    	// asignar datawindow
THIS.title  = istr_1.title						// asignar titulo de la ventana
THIS.width  = istr_1.width						// asignar ancho y altura de ventana
THIS.height = istr_1.height
THIS.x = istr_1.x									// asignar posicion x e y de la ventana
THIS.y = istr_1.y

idw_1.SetTransObject(SQLCA)

// ii_help = 101           					// help topic

THIS.EVENT ue_load_filter()

is_original = dw_master.GetSQLSelect()


end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

type pb_1 from picturebutton within w_cns_col_sl_pop
integer x = 1234
integer y = 36
integer width = 206
integer height = 104
integer taborder = 30
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "\Source\Gif\go3.gif"
alignment htextalign = left!
end type

event clicked;String	ls_original, ls_where, ls_temp, ls_modificado
Integer	li_rc

ls_original = is_original

CHOOSE CASE is_coltype[parent.ii_index]
	CASE 'date'
			ls_temp = sle_valor.text
	CASE 'datetime'
			ls_temp = sle_valor.text
	CASE 'char'
			ls_temp = "'" + sle_valor.text + "'"
	CASE 'numeric'
			ls_temp = sle_valor.text
END CHOOSE

ls_where = "WHERE " + is_colname[parent.ii_index] + " " + ddlb_operador.text + " " + ls_temp

ls_modificado = ls_original + ls_where

li_rc = dw_master.SetSQLSelect(ls_modificado)

IF li_rc = 1 THEN
	dw_master.Retrieve()
ELSE
	MessageBox("Error en crear el Datawindow",li_rc)
END IF


end event

type ddlb_operador from dropdownlistbox within w_cns_col_sl_pop
integer x = 261
integer y = 156
integer width = 224
integer height = 464
integer taborder = 20
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean vscrollbar = true
string item[] = {"=",">","<",">=","<=","<>",""}
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cns_col_sl_pop
integer x = 41
integer y = 168
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Valor:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type st_1 from statictext within w_cns_col_sl_pop
integer x = 41
integer y = 36
integer width = 210
integer height = 64
integer textsize = -10
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Filtro:"
borderstyle borderstyle = styleraised!
boolean focusrectangle = false
end type

type sle_valor from singlelineedit within w_cns_col_sl_pop
integer x = 507
integer y = 156
integer width = 654
integer height = 96
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type ddlb_filtro from dropdownlistbox within w_cns_col_sl_pop
integer x = 261
integer y = 36
integer width = 910
integer height = 464
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
string text = "none"
boolean sorted = false
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

event selectionchanged;parent.ii_index = index
end event

type dw_master from u_dw_cns within w_cns_col_sl_pop
integer x = 9
integer y = 264
integer width = 1509
integer height = 376
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;
ii_ck[1] = 1



end event

event clicked;call super::clicked;IF row = 0 THEN RETURN

Integer	li_x
String	ls_type, ls_width, ls_resultado


FOR li_x = 1 TO UpperBound(istr_1.id)
	ls_type = THIS.Describe('#' + String(istr_1.id[li_x]) + ".ColType")

	CHOOSE CASE ls_type
		CASE 'Date'
				ls_resultado = String(GetItemDate(row, istr_1.id[li_x]),'dd/mm/yyyy')
		CASE 'DateTime'
				ls_resultado = String(GetItemDateTime(row, istr_1.id[li_x]), 'dd/mm/yyyy hh:mm:ss')
		CASE Else
			IF Left(ls_type,4) = 'char' THEN
				ls_resultado = GetItemString(row, istr_1.id[li_x])
			ELSE
				ls_resultado = String(GetItemNumber(row, istr_1.id[li_x]))
			END IF
	END CHOOSE
	istr_1.dw.SetColumn(istr_1.field[li_x])
	istr_1.dw.SetText(ls_resultado)
NEXT

Close(Parent)

end event

