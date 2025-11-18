$PBExportHeader$w_cam754_resumen_cont.srw
forward
global type w_cam754_resumen_cont from window
end type
type sle_semana2 from singlelineedit within w_cam754_resumen_cont
end type
type sle_ano2 from singlelineedit within w_cam754_resumen_cont
end type
type st_2 from statictext within w_cam754_resumen_cont
end type
type sle_ano1 from singlelineedit within w_cam754_resumen_cont
end type
type sle_semana1 from singlelineedit within w_cam754_resumen_cont
end type
type st_1 from statictext within w_cam754_resumen_cont
end type
type dw_report from datawindow within w_cam754_resumen_cont
end type
type cb_1 from commandbutton within w_cam754_resumen_cont
end type
end forward

global type w_cam754_resumen_cont from window
integer width = 3378
integer height = 1484
boolean titlebar = true
string title = "[CAM754] Resumen de Contenedores"
string menuname = "m_rpt_smpl"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_saveas ( )
sle_semana2 sle_semana2
sle_ano2 sle_ano2
st_2 st_2
sle_ano1 sle_ano1
sle_semana1 sle_semana1
st_1 st_1
dw_report dw_report
cb_1 cb_1
end type
global w_cam754_resumen_cont w_cam754_resumen_cont

event ue_saveas();//Overrding
string ls_path, ls_file
int li_rc

li_rc = GetFileSaveName ( "Select File", &
   ls_path, ls_file, "XLS", &
   "All Files (*.*),*.*" , "C:\", 32770)

IF li_rc = 1 Then
   uf_save_dw_as_excel ( dw_report, ls_file )
End If
end event

event resize;dw_report.width = newwidth - dw_report.x
dw_report.height = newheight - dw_report.y
end event

on w_cam754_resumen_cont.create
if this.MenuName = "m_rpt_smpl" then this.MenuID = create m_rpt_smpl
this.sle_semana2=create sle_semana2
this.sle_ano2=create sle_ano2
this.st_2=create st_2
this.sle_ano1=create sle_ano1
this.sle_semana1=create sle_semana1
this.st_1=create st_1
this.dw_report=create dw_report
this.cb_1=create cb_1
this.Control[]={this.sle_semana2,&
this.sle_ano2,&
this.st_2,&
this.sle_ano1,&
this.sle_semana1,&
this.st_1,&
this.dw_report,&
this.cb_1}
end on

on w_cam754_resumen_cont.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.sle_semana2)
destroy(this.sle_ano2)
destroy(this.st_2)
destroy(this.sle_ano1)
destroy(this.sle_semana1)
destroy(this.st_1)
destroy(this.dw_report)
destroy(this.cb_1)
end on

type sle_semana2 from singlelineedit within w_cam754_resumen_cont
integer x = 901
integer y = 112
integer width = 165
integer height = 80
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_ano2 from singlelineedit within w_cam754_resumen_cont
integer x = 658
integer y = 112
integer width = 210
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_cam754_resumen_cont
integer x = 654
integer y = 36
integer width = 411
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "A   Año      Sem"
boolean focusrectangle = false
end type

type sle_ano1 from singlelineedit within w_cam754_resumen_cont
integer x = 114
integer y = 112
integer width = 210
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type sle_semana1 from singlelineedit within w_cam754_resumen_cont
integer x = 357
integer y = 112
integer width = 165
integer height = 80
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_1 from statictext within w_cam754_resumen_cont
integer x = 87
integer y = 36
integer width = 411
integer height = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "De   Año      Sem"
boolean focusrectangle = false
end type

type dw_report from datawindow within w_cam754_resumen_cont
integer x = 96
integer y = 276
integer width = 3186
integer height = 996
integer taborder = 20
string title = "none"
string dataobject = "d_rpt_resumen_cont_crt"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_cam754_resumen_cont
integer x = 1266
integer y = 40
integer width = 402
integer height = 176
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Filtrar"
end type

event clicked;Integer ln_semana1, ln_semana2, ln_ano1, ln_ano2

ln_ano1 = Integer(sle_ano1.text)
ln_semana1 = Integer(sle_semana1.text)
ln_ano2 = Integer(sle_ano2.text)
ln_semana2 = Integer(sle_semana2.text)
dw_report.settransobject(SQLCA)
dw_report.retrieve(ln_ano1, ln_semana1, ln_ano2, ln_semana2)
end event

