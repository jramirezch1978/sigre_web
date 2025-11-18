$PBExportHeader$w_cm727_codigos_barra.srw
forward
global type w_cm727_codigos_barra from w_rpt
end type
type cb_1 from commandbutton within w_cm727_codigos_barra
end type
type rb_3col from radiobutton within w_cm727_codigos_barra
end type
type rb_2col from radiobutton within w_cm727_codigos_barra
end type
type dw_report from u_dw_rpt within w_cm727_codigos_barra
end type
type gb_1 from groupbox within w_cm727_codigos_barra
end type
end forward

global type w_cm727_codigos_barra from w_rpt
integer x = 283
integer y = 248
integer width = 3150
integer height = 1716
string title = "[CM727] Listado de Codigos de Barra"
string menuname = "m_impresion"
windowstate windowstate = maximized!
long backcolor = 79741120
cb_1 cb_1
rb_3col rb_3col
rb_2col rb_2col
dw_report dw_report
gb_1 gb_1
end type
global w_cm727_codigos_barra w_cm727_codigos_barra

on w_cm727_codigos_barra.create
int iCurrent
call super::create
if this.MenuName = "m_impresion" then this.MenuID = create m_impresion
this.cb_1=create cb_1
this.rb_3col=create rb_3col
this.rb_2col=create rb_2col
this.dw_report=create dw_report
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.cb_1
this.Control[iCurrent+2]=this.rb_3col
this.Control[iCurrent+3]=this.rb_2col
this.Control[iCurrent+4]=this.dw_report
this.Control[iCurrent+5]=this.gb_1
end on

on w_cm727_codigos_barra.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.cb_1)
destroy(this.rb_3col)
destroy(this.rb_2col)
destroy(this.dw_report)
destroy(this.gb_1)
end on

event ue_open_pre;call super::ue_open_pre;//idw_1.Visible = False
idw_1 = dw_report
ii_help = 101           // help topic

idw_1.SetTransObject( SQLCA )
THIS.Event ue_preview()

end event

event ue_retrieve;call super::ue_retrieve;
if rb_2col.checked then
	dw_report.DataObject = 'd_rpt_codigos_barra_lbl'
elseif rb_3col.checked then
	dw_report.DataObject = 'd_rpt_codigos_3barra_lbl'
end if

dw_report.SetTransObject(SQLCA)
dw_report.Retrieve()

dw_report.Visible = True

if dw_report.of_ExistsPictureName("p_logo") then
	dw_report.Object.p_logo.filename = gs_logo	
end if

if dw_report.of_ExistsText("t_user") then
	dw_report.object.t_user.text     = gs_user
end if

if dw_report.of_ExistsText("t_empresa") then
	dw_report.object.t_empresa.text     = gs_empresa
end if

if dw_report.of_ExistsText("t_codigo") then
	dw_report.object.t_codigo.text     = dw_report.dataobject
end if


end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y


end event

event ue_print();call super::ue_print;dw_report.EVENT ue_print()
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

type cb_1 from commandbutton within w_cm727_codigos_barra
integer x = 882
integer y = 64
integer width = 343
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Reporte"
end type

event clicked;parent.event ue_retrieve()
end event

type rb_3col from radiobutton within w_cm727_codigos_barra
integer x = 434
integer y = 76
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "3 columnas"
end type

type rb_2col from radiobutton within w_cm727_codigos_barra
integer x = 37
integer y = 76
integer width = 343
integer height = 72
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "2 columnas"
boolean checked = true
end type

type dw_report from u_dw_rpt within w_cm727_codigos_barra
integer y = 236
integer width = 3063
integer height = 1068
boolean bringtotop = true
string dataobject = "d_rpt_codigos_barra_lbl"
end type

type gb_1 from groupbox within w_cm727_codigos_barra
integer width = 1545
integer height = 228
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Opciones"
end type

