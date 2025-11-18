$PBExportHeader$w_data_rpt.srw
$PBExportComments$Ventana para crear dinamicamente reportes
forward
global type w_data_rpt from w_rpt
end type
type dw_report from u_dw_rpt within w_data_rpt
end type
end forward

global type w_data_rpt from w_rpt
integer width = 754
integer height = 712
string title = ""
string menuname = "m_rpt_pop"
long backcolor = 12632256
dw_report dw_report
end type
global w_data_rpt w_data_rpt

type variables
str_cns_pop  istr_1
end variables

forward prototypes
public function long of_retrieve ()
public function long of_retrieve (string as_arg1)
public function long of_retrieve (string as_arg1, string as_arg2)
public function long of_retrieve (string as_arg1, string as_arg2, string as_arg3)
public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4)
end prototypes

public function long of_retrieve ();Long	ll_row

ll_row = idw_1.Retrieve()

Return ll_row
end function

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

public function integer of_retrieve (string as_arg1, string as_arg2, string as_arg3, string as_arg4);Long	ll_row

ll_row = idw_1.Retrieve(as_arg1, as_arg2, as_arg3, as_arg4)

Return ll_row
end function

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

on w_data_rpt.create
int iCurrent
call super::create
if this.MenuName = "m_rpt_pop" then this.MenuID = create m_rpt_pop
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_data_rpt.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event ue_open_pre;call super::ue_open_pre;Long	ll_row, ll_total

idw_1 = dw_report
//istr_1 = Message.PowerObjectParm					// lectura de parametros
//
//idw_1.DataObject = istr_1.DataObject    		// asignar datawindow
//THIS.title  = istr_1.title							// asignar titulo de la ventana
//THIS.width  = istr_1.width							// asignar ancho y altura de ventana
//THIS.height = istr_1.height
//
//idw_1.SetTransObject(SQLCA)
THIS.Event ue_preview()

//IF IsValid(istr_1.dw) THEN
//	IF istr_1.flag_share THEN
//		istr_1.dw.ShareData(idw_1)
//	ELSE
//		ll_total = istr_1.dw.RowCount()
//		istr_1.dw.RowsCopy(1, ll_total, Primary!, idw_1, 1, Primary!)
//	END IF
//ELSE
//	ll_row = of_retrieve(istr_1.arg[1], istr_1.arg[2], istr_1.arg[3], istr_1.arg[4])
//end if


//idw_1.Object.p_logo.filename = is_logo
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

type dw_report from u_dw_rpt within w_data_rpt
integer x = 5
integer y = 4
integer width = 539
integer height = 368
integer taborder = 20
boolean bringtotop = true
boolean hscrollbar = true
boolean vscrollbar = true
end type

