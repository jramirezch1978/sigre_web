$PBExportHeader$w_cam756_resumen_exportado.srw
forward
global type w_cam756_resumen_exportado from window
end type
type cb_1 from commandbutton within w_cam756_resumen_exportado
end type
type st_1 from statictext within w_cam756_resumen_exportado
end type
type st_2 from statictext within w_cam756_resumen_exportado
end type
type dw_report from datawindow within w_cam756_resumen_exportado
end type
type sle_semana2 from singlelineedit within w_cam756_resumen_exportado
end type
type sle_semana1 from singlelineedit within w_cam756_resumen_exportado
end type
end forward

global type w_cam756_resumen_exportado from window
integer width = 3378
integer height = 1408
boolean titlebar = true
string title = "[CAM756] Resumen Exportado"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_1 cb_1
st_1 st_1
st_2 st_2
dw_report dw_report
sle_semana2 sle_semana2
sle_semana1 sle_semana1
end type
global w_cam756_resumen_exportado w_cam756_resumen_exportado

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_cam756_resumen_exportado.create
this.cb_1=create cb_1
this.st_1=create st_1
this.st_2=create st_2
this.dw_report=create dw_report
this.sle_semana2=create sle_semana2
this.sle_semana1=create sle_semana1
this.Control[]={this.cb_1,&
this.st_1,&
this.st_2,&
this.dw_report,&
this.sle_semana2,&
this.sle_semana1}
end on

on w_cam756_resumen_exportado.destroy
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.st_2)
destroy(this.dw_report)
destroy(this.sle_semana2)
destroy(this.sle_semana1)
end on

type cb_1 from commandbutton within w_cam756_resumen_exportado
integer x = 1614
integer y = 36
integer width = 402
integer height = 80
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;Integer ln_semana1, ln_semana2

ln_semana1 = Integer(sle_semana1.text)
ln_semana2 = Integer(sle_semana2.text)
dw_report.settransobject(SQLCA)
dw_report.retrieve(ln_semana1, ln_semana2)
end event

type st_1 from statictext within w_cam756_resumen_exportado
integer x = 87
integer y = 36
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "De Semana"
boolean focusrectangle = false
end type

type st_2 from statictext within w_cam756_resumen_exportado
integer x = 727
integer y = 36
integer width = 402
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "A Semana"
boolean focusrectangle = false
end type

type dw_report from datawindow within w_cam756_resumen_exportado
integer x = 105
integer y = 192
integer width = 3154
integer height = 1040
integer taborder = 20
string title = "none"
string dataobject = "d_rpt_volumen_exportado_crt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type sle_semana2 from singlelineedit within w_cam756_resumen_exportado
integer x = 1051
integer y = 36
integer width = 151
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_semana1 from singlelineedit within w_cam756_resumen_exportado
integer x = 443
integer y = 36
integer width = 165
integer height = 80
integer taborder = 10
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

