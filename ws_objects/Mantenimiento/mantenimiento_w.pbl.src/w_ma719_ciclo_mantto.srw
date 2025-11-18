$PBExportHeader$w_ma719_ciclo_mantto.srw
forward
global type w_ma719_ciclo_mantto from w_rpt
end type
type cb_reporte from commandbutton within w_ma719_ciclo_mantto
end type
type cb_equipos from commandbutton within w_ma719_ciclo_mantto
end type
type dw_report from u_dw_rpt within w_ma719_ciclo_mantto
end type
end forward

global type w_ma719_ciclo_mantto from w_rpt
integer width = 2226
integer height = 1868
string title = "Programa Ciclico de Mantenimiento (MA719)"
string menuname = "m_impresion"
long backcolor = 67108864
event ue_copiar ( )
cb_reporte cb_reporte
cb_equipos cb_equipos
dw_report dw_report
end type
global w_ma719_ciclo_mantto w_ma719_ciclo_mantto

event ue_copiar();dw_report.ClipBoard("gr_1")
end event

event resize;call super::resize;dw_report.width  = newwidth  - dw_report.x - 10
dw_report.height = newheight - dw_report.y - 10
end event

event ue_retrieve;call super::ue_retrieve;Long ll_Count

select count(*)
 	into :ll_count
from tt_mtt_equipos;

if ll_count = 0 then
	MessageBox('Aviso', 'No ha seleccionado ningun equipo')
	return
end if
idw_1 = dw_report

idw_1.SetTransObject(SQLCA)
idw_1.Retrieve()

idw_1.Object.p_logo.filename = gs_logo
idw_1.Object.t_empresa.text = gs_empresa
idw_1.object.usuario_t.text = 'Usuario : ' + trim(gs_user)
idw_1.Object.Datawindow.Print.Orientation = 1
idw_1.Object.Datawindow.Print.Paper.Size = 9
ib_preview = true
idw_1.Modify("DataWindow.Print.Preview=Yes")




end event

on w_ma719_ciclo_mantto.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_reporte=create cb_reporte
this.cb_equipos=create cb_equipos
this.dw_report=create dw_report
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_reporte
this.Control[iCurrent+2]=this.cb_equipos
this.Control[iCurrent+3]=this.dw_report
end on

on w_ma719_ciclo_mantto.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_reporte)
destroy(this.cb_equipos)
destroy(this.dw_report)
end on

event ue_print;call super::ue_print;idw_1.EVENT ue_print()
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

type cb_reporte from commandbutton within w_ma719_ciclo_mantto
integer x = 352
integer y = 32
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Reporte"
end type

event clicked;parent.event dynamic ue_retrieve()
end event

type cb_equipos from commandbutton within w_ma719_ciclo_mantto
integer x = 9
integer y = 32
integer width = 343
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Equipos"
end type

event clicked;Open(w_abc_seleccion_equipos)

end event

type dw_report from u_dw_rpt within w_ma719_ciclo_mantto
integer y = 172
integer width = 2167
integer height = 1464
integer taborder = 60
string dataobject = "d_rpt_prog_ciclo_mantto"
boolean hscrollbar = true
boolean vscrollbar = true
end type

