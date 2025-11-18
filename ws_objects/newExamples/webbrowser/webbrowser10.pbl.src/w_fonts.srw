$PBExportHeader$w_fonts.srw
forward
global type w_fonts from w_base_response
end type
type dw_detail from datawindow within w_fonts
end type
type cb_ok from commandbutton within w_fonts
end type
type cb_cancel from commandbutton within w_fonts
end type
end forward

global type w_fonts from w_base_response
integer width = 1111
string title = "Fonts"
dw_detail dw_detail
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_fonts w_fonts

type variables
u_web_browser iu_web

end variables

on w_fonts.create
int iCurrent
call super::create
this.dw_detail=create dw_detail
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_detail
this.Control[iCurrent+2]=this.cb_ok
this.Control[iCurrent+3]=this.cb_cancel
end on

on w_fonts.destroy
call super::destroy
destroy(this.dw_detail)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;iu_web = Message.PowerObjectParm

end event

type dw_detail from datawindow within w_fonts
integer x = 37
integer y = 32
integer width = 992
integer height = 516
integer taborder = 10
string title = "none"
string dataobject = "d_fontdetail"
boolean border = false
boolean livescroll = true
end type

event constructor;this.InsertRow(0)

end event

type cb_ok from commandbutton within w_fonts
integer x = 37
integer y = 608
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;String ls_FontName, ls_ForeColor, ls_BackColor
Long ll_FontSize

dw_detail.AcceptText()

ls_FontName  = dw_detail.GetItemString(1, "name")
ll_FontSize  = dw_detail.GetItemNumber(1, "size")
ls_ForeColor = dw_detail.GetItemString(1, "forecolor")
ls_BackColor = dw_detail.GetItemString(1, "backcolor")

iu_web.of_DocumentCommand("FontName", ls_FontName)
iu_web.of_DocumentCommand("FontSize", String(ll_FontSize))
iu_web.of_DocumentCommand("ForeColor", ls_ForeColor)
iu_web.of_DocumentCommand("BackColor", ls_BackColor)

Close(Parent)

end event

type cb_cancel from commandbutton within w_fonts
integer x = 695
integer y = 608
integer width = 334
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

