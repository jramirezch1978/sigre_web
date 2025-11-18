$PBExportHeader$w_config.srw
forward
global type w_config from window
end type
type st_1 from statictext within w_config
end type
type cb_1 from commandbutton within w_config
end type
type sle_path from singlelineedit within w_config
end type
type cb_salir from commandbutton within w_config
end type
type cb_retrieve from commandbutton within w_config
end type
type cb_eliminar from commandbutton within w_config
end type
type cb_grabar from commandbutton within w_config
end type
type cb_insertar from commandbutton within w_config
end type
type dw_config from u_dw_abc within w_config
end type
type gb_1 from groupbox within w_config
end type
end forward

global type w_config from window
integer width = 3141
integer height = 1440
boolean titlebar = true
string title = "Configuración para backups"
boolean controlmenu = true
boolean minbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
st_1 st_1
cb_1 cb_1
sle_path sle_path
cb_salir cb_salir
cb_retrieve cb_retrieve
cb_eliminar cb_eliminar
cb_grabar cb_grabar
cb_insertar cb_insertar
dw_config dw_config
gb_1 gb_1
end type
global w_config w_config

on w_config.create
this.st_1=create st_1
this.cb_1=create cb_1
this.sle_path=create sle_path
this.cb_salir=create cb_salir
this.cb_retrieve=create cb_retrieve
this.cb_eliminar=create cb_eliminar
this.cb_grabar=create cb_grabar
this.cb_insertar=create cb_insertar
this.dw_config=create dw_config
this.gb_1=create gb_1
this.Control[]={this.st_1,&
this.cb_1,&
this.sle_path,&
this.cb_salir,&
this.cb_retrieve,&
this.cb_eliminar,&
this.cb_grabar,&
this.cb_insertar,&
this.dw_config,&
this.gb_1}
end on

on w_config.destroy
destroy(this.st_1)
destroy(this.cb_1)
destroy(this.sle_path)
destroy(this.cb_salir)
destroy(this.cb_retrieve)
destroy(this.cb_eliminar)
destroy(this.cb_grabar)
destroy(this.cb_insertar)
destroy(this.dw_config)
destroy(this.gb_1)
end on

type st_1 from statictext within w_config
integer x = 41
integer y = 104
integer width = 421
integer height = 56
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Directorio backup:"
boolean focusrectangle = false
end type

type cb_1 from commandbutton within w_config
integer x = 1518
integer y = 84
integer width = 137
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "..."
end type

type sle_path from singlelineedit within w_config
integer x = 466
integer y = 88
integer width = 1047
integer height = 88
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

type cb_salir from commandbutton within w_config
integer x = 2272
integer y = 1204
integer width = 402
integer height = 112
integer taborder = 40
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Salir"
end type

event clicked;close(parent)
end event

type cb_retrieve from commandbutton within w_config
integer x = 1861
integer y = 1204
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Refrescar"
end type

type cb_eliminar from commandbutton within w_config
integer x = 1449
integer y = 1204
integer width = 402
integer height = 112
integer taborder = 30
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Eliminar"
end type

type cb_grabar from commandbutton within w_config
integer x = 1038
integer y = 1204
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Grabar"
end type

type cb_insertar from commandbutton within w_config
integer x = 626
integer y = 1204
integer width = 402
integer height = 112
integer taborder = 20
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "&Insertar"
end type

type dw_config from u_dw_abc within w_config
integer y = 420
integer width = 3122
integer height = 744
string dataobject = "d_config"
boolean hscrollbar = true
boolean vscrollbar = true
end type

type gb_1 from groupbox within w_config
integer width = 3122
integer height = 400
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
string text = "Datos generales"
end type

