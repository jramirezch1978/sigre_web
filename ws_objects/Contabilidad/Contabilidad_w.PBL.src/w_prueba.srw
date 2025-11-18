$PBExportHeader$w_prueba.srw
forward
global type w_prueba from w_rpt
end type
type st_1 from statictext within w_prueba
end type
type cb_1 from commandbutton within w_prueba
end type
type dw_report from u_dw_rpt within w_prueba
end type
end forward

global type w_prueba from w_rpt
integer width = 3264
integer height = 2028
string title = "Libro de Retenciones"
string menuname = "m_abc_report_smpl"
long backcolor = 12632256
st_1 st_1
cb_1 cb_1
dw_report dw_report
end type
global w_prueba w_prueba

event resize;call super::resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_prueba.create
int iCurrent
call super::create
if this.MenuName = "m_abc_report_smpl" then this.MenuID = create m_abc_report_smpl
this.st_1=create st_1
this.cb_1=create cb_1
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.cb_1
this.Control[iCurrent+3]=this.dw_report
end on

on w_prueba.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.dw_report)
end on

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

event ue_open_pre;call super::ue_open_pre;idw_1 = dw_report

idw_1.SetTransObject(sqlca)
ib_preview = false
THIS.Event ue_preview()
This.Event ue_retrieve()




end event

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
end event

type st_1 from statictext within w_prueba
integer x = 251
integer y = 68
integer width = 1536
integer height = 56
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 255
long backcolor = 67108864
string text = "Opción en prueba, libro de retenciones del año 2006, mes 8"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_prueba
integer x = 2807
integer y = 128
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Procesar"
end type

event clicked;Long ll_ano,ll_mes


ll_ano = 2006
ll_mes = 8


DECLARE PB_usp_cntbl_libro_retenciones PROCEDURE FOR usp_cntbl_libro_retenciones 
(:ll_ano,:ll_mes);
EXECUTE PB_usp_cntbl_libro_retenciones ;

IF SQLCA.SQLCode = -1 THEN 
	MessageBox('Error ', SQLCA.SQLErrText)
	Return
END IF


dw_report.Retrieve()

Rollback ;
end event

type dw_report from u_dw_rpt within w_prueba
integer x = 27
integer y = 256
integer width = 3177
integer height = 1564
string dataobject = "d_prueba"
boolean hscrollbar = true
boolean vscrollbar = true
end type

