$PBExportHeader$w_fi724_rpt_cobrar_directo.srw
forward
global type w_fi724_rpt_cobrar_directo from w_rpt
end type
type dw_report from u_dw_rpt within w_fi724_rpt_cobrar_directo
end type
end forward

global type w_fi724_rpt_cobrar_directo from w_rpt
integer width = 3433
integer height = 1936
string title = "Impresion de Cobrar Directo"
string menuname = "m_reporte"
dw_report dw_report
end type
global w_fi724_rpt_cobrar_directo w_fi724_rpt_cobrar_directo

type variables
Str_cns_pop istr_1
end variables

on w_fi724_rpt_cobrar_directo.create
int iCurrent
call super::create
if this.MenuName = "m_reporte" then this.MenuID = create m_reporte
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_report
end on

on w_fi724_rpt_cobrar_directo.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.dw_report)
end on

event resize;call super::resize;dw_report.width  = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

event ue_open_pre();call super::ue_open_pre;of_position_window(0,0)
idw_1 = dw_report
idw_1.SetTransObject(sqlca)

istr_1 = Message.PowerObjectParm					// lectura de parametros

THIS.Event ue_preview()
This.Event ue_retrieve()


//ii_help = 101           // help topic


end event

event ue_retrieve;call super::ue_retrieve;idw_1.Retrieve(istr_1.arg[1],istr_1.arg[2])

end event

event ue_print();call super::ue_print;idw_1.EVENT ue_print()
end event

event ue_preview();call super::ue_preview;IF ib_preview THEN
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

type dw_report from u_dw_rpt within w_fi724_rpt_cobrar_directo
integer x = 5
integer width = 3218
integer height = 1624
string dataobject = "d_rpt_cobrar_directo_tbl"
end type

