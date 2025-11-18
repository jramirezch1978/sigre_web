$PBExportHeader$w_saveas_opt.srw
$PBExportComments$opciones de impresion
forward
global type w_saveas_opt from window
end type
type rb_pdf from radiobutton within w_saveas_opt
end type
type rb_xls from radiobutton within w_saveas_opt
end type
type rb_html from radiobutton within w_saveas_opt
end type
type cb_cancelar from commandbutton within w_saveas_opt
end type
type cb_ok from commandbutton within w_saveas_opt
end type
type gb_1 from groupbox within w_saveas_opt
end type
end forward

global type w_saveas_opt from window
integer x = 672
integer y = 268
integer width = 800
integer height = 620
boolean titlebar = true
string title = "Export Options"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 79741120
toolbaralignment toolbaralignment = alignatleft!
boolean center = true
event ue_help_topic ( )
event ue_help_index ( )
rb_pdf rb_pdf
rb_xls rb_xls
rb_html rb_html
cb_cancelar cb_cancelar
cb_ok cb_ok
gb_1 gb_1
end type
global w_saveas_opt w_saveas_opt

type variables
string is_opt_pag
datawindow idw_1
Integer ii_help
end variables

event ue_help_topic;ShowHelp(gnvo_app.is_help, Topic! , ii_help)
end event

event ue_help_index;ShowHelp(gnvo_app.is_help, Index!)
end event

event open;
// ii_help = 101           // help topic

end event

on w_saveas_opt.create
this.rb_pdf=create rb_pdf
this.rb_xls=create rb_xls
this.rb_html=create rb_html
this.cb_cancelar=create cb_cancelar
this.cb_ok=create cb_ok
this.gb_1=create gb_1
this.Control[]={this.rb_pdf,&
this.rb_xls,&
this.rb_html,&
this.cb_cancelar,&
this.cb_ok,&
this.gb_1}
end on

on w_saveas_opt.destroy
destroy(this.rb_pdf)
destroy(this.rb_xls)
destroy(this.rb_html)
destroy(this.cb_cancelar)
destroy(this.cb_ok)
destroy(this.gb_1)
end on

type rb_pdf from radiobutton within w_saveas_opt
integer x = 82
integer y = 284
integer width = 667
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "PDF:  Adobe Acrobat"
end type

type rb_xls from radiobutton within w_saveas_opt
integer x = 82
integer y = 188
integer width = 622
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "XLS:  Excell"
end type

type rb_html from radiobutton within w_saveas_opt
integer x = 82
integer y = 92
integer width = 608
integer height = 72
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "HTML:  Web"
end type

type cb_cancelar from commandbutton within w_saveas_opt
integer x = 430
integer y = 408
integer width = 338
integer height = 88
integer taborder = 80
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancelar"
boolean cancel = true
end type

event clicked;closewithreturn(parent, -1)
end event

type cb_ok from commandbutton within w_saveas_opt
integer x = 18
integer y = 408
integer width = 338
integer height = 88
integer taborder = 70
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "OK"
boolean default = true
end type

event clicked;string 	ls_work, ls_prtparam,  ls_error
long 		ll_row, ll_result


IF rb_html.Checked THEN
	ll_result = 1
ELSEIF rb_xls.Checked THEN
	ll_result = 2
ELSEIF rb_pdf.Checked THEN
	ll_result = 3
END IF

CloseWithReturn(parent, ll_result)

end event

type gb_1 from groupbox within w_saveas_opt
integer x = 14
integer y = 20
integer width = 763
integer height = 356
integer taborder = 10
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 78748035
string text = "Formato"
end type

