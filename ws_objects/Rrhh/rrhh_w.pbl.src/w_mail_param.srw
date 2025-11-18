$PBExportHeader$w_mail_param.srw
forward
global type w_mail_param from window
end type
type sle_2 from singlelineedit within w_mail_param
end type
type mle_1 from multilineedit within w_mail_param
end type
type pb_2 from picturebutton within w_mail_param
end type
type pb_1 from picturebutton within w_mail_param
end type
type st_4 from statictext within w_mail_param
end type
type sle_3 from singlelineedit within w_mail_param
end type
type st_3 from statictext within w_mail_param
end type
type st_2 from statictext within w_mail_param
end type
type st_1 from statictext within w_mail_param
end type
type sle_1 from singlelineedit within w_mail_param
end type
end forward

global type w_mail_param from window
integer width = 2213
integer height = 700
windowtype windowtype = response!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_2 sle_2
mle_1 mle_1
pb_2 pb_2
pb_1 pb_1
st_4 st_4
sle_3 sle_3
st_3 st_3
st_2 st_2
st_1 st_1
sle_1 sle_1
end type
global w_mail_param w_mail_param

type variables

end variables

on w_mail_param.create
this.sle_2=create sle_2
this.mle_1=create mle_1
this.pb_2=create pb_2
this.pb_1=create pb_1
this.st_4=create st_4
this.sle_3=create sle_3
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_1=create sle_1
this.Control[]={this.sle_2,&
this.mle_1,&
this.pb_2,&
this.pb_1,&
this.st_4,&
this.sle_3,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_1}
end on

on w_mail_param.destroy
destroy(this.sle_2)
destroy(this.mle_1)
destroy(this.pb_2)
destroy(this.pb_1)
destroy(this.st_4)
destroy(this.sle_3)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_1)
end on

event open;sle_3.text = Message.StringParm
end event

type sle_2 from singlelineedit within w_mail_param
integer x = 517
integer y = 24
integer width = 1655
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;if trim(sle_1.text) = '' then 
	sle_1.text = trim(sle_2.text)
end if
end event

type mle_1 from multilineedit within w_mail_param
integer x = 517
integer y = 264
integer width = 1655
integer height = 396
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean autohscroll = true
borderstyle borderstyle = stylelowered!
end type

type pb_2 from picturebutton within w_mail_param
integer x = 151
integer y = 520
integer width = 201
integer height = 132
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\close.bmp"
alignment htextalign = left!
end type

event clicked;closewithreturn(Parent, 'cancel')
end event

type pb_1 from picturebutton within w_mail_param
integer x = 151
integer y = 392
integer width = 201
integer height = 132
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string picturename = "H:\Source\BMP\mail.bmp"
alignment htextalign = left!
end type

event clicked;string ls_name,ls_address, ls_subject, ls_note, ls_pass

ls_name = trim(sle_1.text) + '|P1|'
ls_address = trim(sle_2.text) + '|P2|'
ls_subject = trim(sle_3.text) + '|P3|'
ls_note = trim(mle_1.text)
messagebox('',ls_address)
ls_pass = ls_name + ls_address + ls_subject + ls_note

closewithreturn(Parent, ls_pass)
end event

type st_4 from statictext within w_mail_param
integer x = 37
integer y = 280
integer width = 434
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Texto"
boolean focusrectangle = false
end type

type sle_3 from singlelineedit within w_mail_param
integer x = 517
integer y = 184
integer width = 1655
integer height = 76
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

type st_3 from statictext within w_mail_param
integer x = 37
integer y = 196
integer width = 434
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Sujeto"
boolean focusrectangle = false
end type

type st_2 from statictext within w_mail_param
integer x = 37
integer y = 36
integer width = 434
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Correo Electrónico"
boolean focusrectangle = false
end type

type st_1 from statictext within w_mail_param
integer x = 37
integer y = 116
integer width = 434
integer height = 64
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
boolean underline = true
long textcolor = 33554432
long backcolor = 67108864
string text = "Nombre"
boolean focusrectangle = false
end type

type sle_1 from singlelineedit within w_mail_param
integer x = 517
integer y = 104
integer width = 1655
integer height = 76
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

event getfocus;if trim(this.text) = '' then return
this.SelectText(1,Len(this.Text))
end event

