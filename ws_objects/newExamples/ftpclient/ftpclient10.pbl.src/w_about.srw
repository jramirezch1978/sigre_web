$PBExportHeader$w_about.srw
$PBExportComments$About Box
forward
global type w_about from w_base_response
end type
type st_version from statictext within w_about
end type
type shl_website from statichyperlink within w_about
end type
type st_author from statictext within w_about
end type
type st_title from statictext within w_about
end type
type p_topwiz from picture within w_about
end type
type cb_ok from commandbutton within w_about
end type
end forward

global type w_about from w_base_response
integer width = 2135
integer height = 908
string title = "About FTPClient"
st_version st_version
shl_website shl_website
st_author st_author
st_title st_title
p_topwiz p_topwiz
cb_ok cb_ok
end type
global w_about w_about

on w_about.create
int iCurrent
call super::create
this.st_version=create st_version
this.shl_website=create shl_website
this.st_author=create st_author
this.st_title=create st_title
this.p_topwiz=create p_topwiz
this.cb_ok=create cb_ok
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_version
this.Control[iCurrent+2]=this.shl_website
this.Control[iCurrent+3]=this.st_author
this.Control[iCurrent+4]=this.st_title
this.Control[iCurrent+5]=this.p_topwiz
this.Control[iCurrent+6]=this.cb_ok
end on

on w_about.destroy
call super::destroy
destroy(this.st_version)
destroy(this.shl_website)
destroy(this.st_author)
destroy(this.st_title)
destroy(this.p_topwiz)
destroy(this.cb_ok)
end on

event open;call super::open;st_version.text = "Version: " + gn_app.is_version + " - " + String(gn_app.ld_compiled)

end event

type st_version from statictext within w_about
integer x = 1061
integer y = 256
integer width = 992
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Version"
alignment alignment = center!
boolean focusrectangle = false
end type

type shl_website from statichyperlink within w_about
integer x = 1061
integer y = 512
integer width = 992
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
boolean underline = true
string pointer = "HyperLink!"
long textcolor = 134217856
long backcolor = 67108864
string text = "www.topwizprogramming.com"
alignment alignment = center!
boolean focusrectangle = false
string url = "http://www.topwizprogramming.com/"
end type

type st_author from statictext within w_about
integer x = 1061
integer y = 384
integer width = 992
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Written by Roland Smith"
alignment alignment = center!
boolean focusrectangle = false
end type

type st_title from statictext within w_about
integer x = 1061
integer y = 64
integer width = 992
integer height = 132
integer textsize = -18
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "FTPClient"
alignment alignment = center!
boolean focusrectangle = false
end type

type p_topwiz from picture within w_about
integer x = 73
integer y = 64
integer width = 942
integer height = 676
boolean originalsize = true
string picturename = "topwiz.gif"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_about
integer x = 1719
integer y = 672
integer width = 334
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

