$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type lb_results from listbox within w_main
end type
type st_test from statictext within w_main
end type
type cb_choose from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 1879
integer height = 1140
boolean titlebar = true
string title = "Choose Font"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
lb_results lb_results
st_test st_test
cb_choose cb_choose
cb_cancel cb_cancel
end type
global w_main w_main

on w_main.create
this.lb_results=create lb_results
this.st_test=create st_test
this.cb_choose=create cb_choose
this.cb_cancel=create cb_cancel
this.Control[]={this.lb_results,&
this.st_test,&
this.cb_choose,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.lb_results)
destroy(this.st_test)
destroy(this.cb_choose)
destroy(this.cb_cancel)
end on

type lb_results from listbox within w_main
integer x = 37
integer y = 640
integer width = 1760
integer height = 356
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Lucida Console"
long textcolor = 33554432
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

type st_test from statictext within w_main
integer x = 37
integer y = 224
integer width = 1760
integer height = 356
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Lucida Console"
long textcolor = 33554432
long backcolor = 16777215
string text = "This is some text to show the selected font."
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type cb_choose from commandbutton within w_main
integer x = 37
integer y = 32
integer width = 407
integer height = 132
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Choose Font"
end type

event clicked;// choose font
//
// Note: StaticText controls do not support StrikeOut
//

n_choosefont ln_cf

If ln_cf.of_ChooseFont(Parent, st_test.FaceName) Then
	// change settings ( Strikeout not supported by Statictext control )
	st_test.FaceName	= ln_cf.iFaceName
	st_test.TextSize	= ln_cf.iTextSize
	st_test.TextColor	= ln_cf.iTextColor
	st_test.Weight		= ln_cf.iWeight
	st_test.Underline	= ln_cf.iUnderline
	st_test.Italic		= ln_cf.iItalic
	// show results in listbox
	lb_results.Reset()
	lb_results.AddItem("FaceName: " + ln_cf.iFaceName)
	lb_results.AddItem("TextSize: " + String(ln_cf.iTextSize))
	lb_results.AddItem("TextColor: " + String(ln_cf.iBold))
	lb_results.AddItem("Bold: " + String(ln_cf.iBold))
	lb_results.AddItem("Underline: " + String(ln_cf.iUnderline))
	lb_results.AddItem("Italic: " + String(ln_cf.iItalic))
End If

end event

type cb_cancel from commandbutton within w_main
integer x = 1390
integer y = 32
integer width = 407
integer height = 132
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

