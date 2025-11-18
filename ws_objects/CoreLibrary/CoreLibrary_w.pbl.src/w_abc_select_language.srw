$PBExportHeader$w_abc_select_language.srw
forward
global type w_abc_select_language from window
end type
type rb_eng from radiobutton within w_abc_select_language
end type
type rb_esp from radiobutton within w_abc_select_language
end type
type cb_1 from commandbutton within w_abc_select_language
end type
type cb_aceptar from commandbutton within w_abc_select_language
end type
type p_1 from picture within w_abc_select_language
end type
type gb_1 from groupbox within w_abc_select_language
end type
end forward

global type w_abc_select_language from window
integer width = 1678
integer height = 568
boolean titlebar = true
string title = "Elija un idioma ..."
windowtype windowtype = response!
long backcolor = 16777215
string icon = "AppIcon!"
boolean center = true
rb_eng rb_eng
rb_esp rb_esp
cb_1 cb_1
cb_aceptar cb_aceptar
p_1 p_1
gb_1 gb_1
end type
global w_abc_select_language w_abc_select_language

on w_abc_select_language.create
this.rb_eng=create rb_eng
this.rb_esp=create rb_esp
this.cb_1=create cb_1
this.cb_aceptar=create cb_aceptar
this.p_1=create p_1
this.gb_1=create gb_1
this.Control[]={this.rb_eng,&
this.rb_esp,&
this.cb_1,&
this.cb_aceptar,&
this.p_1,&
this.gb_1}
end on

on w_abc_select_language.destroy
destroy(this.rb_eng)
destroy(this.rb_esp)
destroy(this.cb_1)
destroy(this.cb_aceptar)
destroy(this.p_1)
destroy(this.gb_1)
end on

type rb_eng from radiobutton within w_abc_select_language
integer x = 704
integer y = 200
integer width = 722
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Inglés"
end type

type rb_esp from radiobutton within w_abc_select_language
integer x = 704
integer y = 104
integer width = 722
integer height = 80
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
string text = "Español"
boolean checked = true
end type

type cb_1 from commandbutton within w_abc_select_language
integer x = 1193
integer y = 332
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Cancelar"
boolean cancel = true
end type

event clicked;str_parametros lstr_param

lstr_param.i_return = -1
CloseWithReturn(parent, lstr_param)
end event

type cb_aceptar from commandbutton within w_abc_select_language
integer x = 791
integer y = 332
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Aceptar"
boolean default = true
end type

event clicked;str_parametros lstr_param

if rb_esp.checked then
	lstr_param.language = 1
elseif rb_eng.checked then
	lstr_param.language = 2
else
	lstr_param.language = -1
end if

lstr_param.i_return = 1
CloseWithReturn(parent, lstr_param)
end event

type p_1 from picture within w_abc_select_language
integer x = 27
integer y = 60
integer width = 571
integer height = 292
string picturename = "C:\SIGRE\resources\PNG\sigre.png"
boolean focusrectangle = false
end type

type gb_1 from groupbox within w_abc_select_language
integer width = 1641
integer height = 476
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 16777215
end type

