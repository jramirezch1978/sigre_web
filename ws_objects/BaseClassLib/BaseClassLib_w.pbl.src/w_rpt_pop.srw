$PBExportHeader$w_rpt_pop.srw
$PBExportComments$Ventana para crear dinamicamente reportes
forward
global type w_rpt_pop from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_pop
end type
end forward

global type w_rpt_pop from w_rpt
integer width = 3154
integer height = 2132
string menuname = "m_rpt_pop"
dw_report dw_report
end type
global w_rpt_pop w_rpt_pop

type variables
str_cns_pop  istr_1
String  is_column, is_argname[]
end variables

forward prototypes
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3)
public function long of_retrieve ()
public subroutine of_set_column_pointer (string as_pointer)
public function integer of_get_next_str (string as_column)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6)
end prototypes

public function long of_retrieve (string as_arg1);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1)

Return ll_row
end function

public function long of_retrieve (string as_arg1, string as_arg2);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2)

Return ll_row
end function

public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2, as_arg3)

Return ll_row
end function

public function long of_retrieve ();Long	ll_row

ll_row = idw_1.Retrieve()

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

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4)

Return ll_row
end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5)

Return ll_row
end function

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4, string as_arg5, string as_arg6);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4, as_arg5, as_arg6)

Return ll_row
end function

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

on w_rpt_pop.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_pop" then this.MenuID = create m_rpt_pop
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_rpt_pop.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;Long		ll_row, ll_total
String	ls_rc, ls_modify
Integer	li_rc
Menu		lm_1, lm_menu

lm_1   = THIS.MenuID
idw_1  = dw_report
istr_1 = Message.PowerObjectParm					// lectura de parametros

idw_1.DataObject = istr_1.DataObject    		// asignar datawindow
THIS.title  = istr_1.title							// asignar titulo de la ventana
THIS.width  = istr_1.width							// asignar ancho y altura de ventana
THIS.height = istr_1.height

idw_1.SetTransObject(SQLCA)

//THIS.Event ue_preview()

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

idw_1.object.p_logo.filename = gnvo_app.is_logo
idw_1.object.t_nombre.text = gnvo_app.invo_empresa.is_empresa
idw_1.object.t_user.text = gnvo_app.is_user

// ii_help = 101           // help topic


end event

event open;// override

THIS.EVENT ue_open_pre()
end event

event ue_preview;call super::ue_preview;IF ib_preview THEN
	idw_1.Modify("DataWindow.Print.Preview=No")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = FALSE
ELSE
	idw_1.Modify("DataWindow.Print.Preview=Yes")
	idw_1.Modify("datawindow.print.preview.zoom = " + String(idw_1.ii_zoom_actual))
	idw_1.title = "Reporte " + " (Zoom: " + String(idw_1.ii_zoom_actual) + "%)"
	SetPointer(hourglass!)
	ib_preview = TRUE
END IF
end event

type ole_skin from w_rpt`ole_skin within w_rpt_pop
end type

type uo_h from w_rpt`uo_h within w_rpt_pop
end type

type st_box from w_rpt`st_box within w_rpt_pop
end type

type phl_logonps from w_rpt`phl_logonps within w_rpt_pop
end type

type p_mundi from w_rpt`p_mundi within w_rpt_pop
end type

type p_logo from w_rpt`p_logo within w_rpt_pop
end type

type dw_report from u_dw_rpt within w_rpt_pop
integer x = 494
integer y = 296
integer width = 1824
integer height = 1192
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

event doubleclicked;call super::doubleclicked;IF row = 0 THEN RETURN

Integer	li_x
String	ls_type, ls_width

IF dwo.Name = is_column  THEN
	FOR li_x = 1 TO UPPERBOUND(is_argname)
		ls_type = THIS.Describe(is_argname[li_x] + ".ColType")
//		MessageBox(is_argname[li_x], ls_type)
		CHOOSE CASE ls_type
			CASE 'Date'
				istr_1.Arg[li_x] = String(GetItemDate(row,is_argname[li_x]), 'dd/mm/yyyy')
			CASE 'DateTime'
				istr_1.Arg[li_x] = String(GetItemDateTime(row,is_argname[li_x]), 'dd/mm/yyyy hh:mm:ss')
			CASE Else
				IF Left(ls_type,4) = 'char' THEN
					istr_1.Arg[li_x] = GetItemString(row,is_argname[li_x])
//					MessageBox(is_argname[li_x], istr_1.Arg[li_x])
				ELSE
					istr_1.Arg[li_x] = String(GetItemNumber(row,is_argname[li_x]))
				END IF
 		END CHOOSE
	NEXT
	of_new_sheet(istr_1)
END IF


end event

