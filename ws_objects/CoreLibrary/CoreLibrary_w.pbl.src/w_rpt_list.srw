$PBExportHeader$w_rpt_list.srw
$PBExportComments$Reporte basado en una seleccion de listas
forward
global type w_rpt_list from w_rpt
end type
type dw_report from u_dw_rpt within w_rpt_list
end type
type dw_1 from u_dw_abc within w_rpt_list
end type
type pb_1 from picturebutton within w_rpt_list
end type
type pb_2 from picturebutton within w_rpt_list
end type
type dw_2 from u_dw_abc within w_rpt_list
end type
type cb_report from commandbutton within w_rpt_list
end type
end forward

global type w_rpt_list from w_rpt
integer width = 3470
integer height = 1676
long backcolor = 12632256
dw_report dw_report
dw_1 dw_1
pb_1 pb_1
pb_2 pb_2
dw_2 dw_2
cb_report cb_report
end type
global w_rpt_list w_rpt_list

type variables
u_dw_abc  idw_otro
end variables

forward prototypes
public subroutine of_dw_sort ()
end prototypes

public subroutine of_dw_sort ();Integer	li_rc, li_x, li_total
string	ls_sort

li_total = UpperBound(idw_otro.ii_ck)
IF li_total < 1 THEN RETURN

ls_sort = "#" + String(idw_otro.ii_ck[1]) + " A"

FOR li_x = 2 TO li_total
	 ls_sort = ls_sort + ", #" + String(idw_otro.ii_ck[li_x]) +" A"
NEXT

idw_otro.SetSort (ls_sort)
idw_otro.Sort()

end subroutine

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

on w_rpt_list.create
int iCurrent
call super::create
this.dw_report=create dw_report
this.dw_1=create dw_1
this.pb_1=create pb_1
this.pb_2=create pb_2
this.dw_2=create dw_2
this.cb_report=create cb_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
this.Control[iCurrent+2]=this.dw_1
this.Control[iCurrent+3]=this.pb_1
this.Control[iCurrent+4]=this.pb_2
this.Control[iCurrent+5]=this.dw_2
this.Control[iCurrent+6]=this.cb_report
end on

on w_rpt_list.destroy
call super::destroy
destroy(this.dw_report)
destroy(this.dw_1)
destroy(this.pb_1)
destroy(this.pb_2)
destroy(this.dw_2)
destroy(this.cb_report)
end on

event ue_open_pre;call super::ue_open_pre;
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

//dw_1.SetTransObject(sqlca)
//dw_2.SetTransObject(sqlca)

// ii_help = 101           // help topic

//of_position_window(0,0) 		// Posicionar window




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

event resize;call super::resize;//dw_report.width = newwidth - dw_report.x
//dw_report.height = newheight - dw_report.y
//
//pb_1.x = newwidth / 2 - pb_1.width / 2
//pb_2.x = newwidth / 2 - pb_2.width / 2
//
//dw_1.height = newheight - dw_1.y - 10
//dw_1.width = pb_1.x - dw_1.x - 10
//
//
//dw_2.x = pb_1.x + pb_1.width + 10
//dw_2.width = newwidth - dw_2.x - 10
//dw_2.height = newheight - dw_2.y - 10
//
//dw_text.width = dw_1.width + dw_1.x - dw_text.x
end event

type dw_report from u_dw_rpt within w_rpt_list
integer x = 1394
integer y = 124
integer width = 2021
integer height = 1416
boolean bringtotop = true
end type

type dw_1 from u_dw_abc within w_rpt_list
integer x = 18
integer y = 276
integer width = 640
integer height = 1112
integer taborder = 20
boolean bringtotop = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_2
 
// ii_dk[1] = 1
// ii_rk[1] = 1
end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_count, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()
ll_count = Long(this.object.Datawindow.Column.Count)
FOR li_x = 1 to ll_count
	la_id = THIS.object.data.primary.current[al_row, li_x]	
	ll_rc = idw_det.SetItem(ll_row, li_x, la_id)
NEXT

idw_det.ScrollToRow(ll_row)
end event

type pb_1 from picturebutton within w_rpt_list
event ue_clicked_pre ( )
integer x = 32
integer y = 1412
integer width = 155
integer height = 128
integer taborder = 30
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = ">"
end type

event ue_clicked_pre;idw_otro = dw_2
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_1.EVENT ue_selected_row()

// ordenar ventana derecha
of_dw_sort()

end event

type pb_2 from picturebutton within w_rpt_list
event ue_clicked_pre ( )
integer x = 494
integer y = 1412
integer width = 155
integer height = 128
integer taborder = 50
boolean bringtotop = true
integer textsize = -14
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "<"
alignment htextalign = left!
end type

event ue_clicked_pre;idw_otro = dw_1
end event

event clicked;THIS.EVENT ue_clicked_pre()

dw_2.EVENT ue_selected_row()

// ordenar ventana izquierda
of_dw_sort()
end event

type dw_2 from u_dw_abc within w_rpt_list
integer x = 686
integer y = 280
integer width = 640
integer height = 1112
integer taborder = 40
boolean bringtotop = true
end type

event constructor;call super::constructor;is_dwform = 'tabular'	// tabular, grid, form (default)
ii_ss = 0 					// indica si se usa seleccion: 1=individual (default), 0=multiple
idw_det = dw_1
 
// ii_dk[1] = 1
// ii_rk[1] = 1

end event

event ue_selected_row_pos;call super::ue_selected_row_pos;Long	ll_row, ll_y

ll_row = THIS.GetSelectedRow(0)

Do While ll_row <> 0
	THIS.DeleteRow(ll_row)
	ll_row = THIS.GetSelectedRow(0)
Loop


end event

event ue_selected_row_pro;call super::ue_selected_row_pro;Long	ll_row, ll_rc
Any	la_id
Integer	li_x

ll_row = idw_det.EVENT ue_insert()

FOR li_x = 1 to UpperBound(ii_dk)
	la_id = THIS.object.data.primary.current[al_row, ii_dk[li_x]]	
	ll_rc = idw_det.SetItem(ll_row, idw_det.ii_rk[li_x], la_id)
NEXT

idw_otro.ScrollToRow(ll_row)

end event

type cb_report from commandbutton within w_rpt_list
integer x = 754
integer y = 1420
integer width = 539
integer height = 108
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Generar Reporte"
end type

event clicked;//Any			la_arg[]
//Long 		ll_row
//
//FOR ll_row = 1 to dw_2.rowcount()
//	la_arg[ll_row] = dw_2.of_get_column_data(ll_row, dw_2.ii_ck[1])
//NEXT
//
//idw_1.retrieve(la_arg)
//PARENT.event ue_preview()
	    
end event

