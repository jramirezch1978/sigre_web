$PBExportHeader$w_cns_col_pop.srw
$PBExportComments$Consulta, que muestra una lista, en la imputacion de datos
forward
global type w_cns_col_pop from w_cns
end type
type dw_master from u_dw_cns within w_cns_col_pop
end type
end forward

global type w_cns_col_pop from w_cns
integer width = 581
integer height = 576
string menuname = "m_cns_pop"
dw_master dw_master
end type
global w_cns_col_pop w_cns_col_pop

type variables
str_col_pop  istr_1
String  is_column, is_argname[]
end variables

forward prototypes
public function long of_retrieve ()
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4)
public subroutine of_set_column_pointer (string as_pointer)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6)
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

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4)

Return ll_row
end function

public subroutine of_set_column_pointer (string as_pointer);Integer	li_x

FOR li_x = 1 TO UPPERBOUND(is_argname)
	dw_master.Modify(is_argname[li_x] + ".Pointer = " + as_pointer)
NEXT

end subroutine

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5)

Return ll_row
end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6);Long	ll_row

ll_row = dw_master.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5, as_arg6)

Return ll_row
end function

on w_cns_col_pop.create
int iCurrent
call super::create
if this.MenuName = "m_cns_pop" then this.MenuID = create m_cns_pop
this.dw_master=create dw_master
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_master
end on

on w_cns_col_pop.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
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

//ll_row = of_retrieve(istr_1.arg[1], istr_1.arg[2], istr_1.arg[3], istr_1.arg[4], istr_1.arg[5], istr_1.arg[6])

//istr_1.dw.SetColumn(istr_1.field)

// ii_help = 101           					// help topic





end event

event ue_scrollrow;call super::ue_scrollrow;Long ll_rc

ll_rc = dw_master.of_ScrollRow(as_value)

//RETURN ll_rc
end event

type dw_master from u_dw_cns within w_cns_col_pop
integer x = 14
integer y = 8
integer width = 485
integer height = 328
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

