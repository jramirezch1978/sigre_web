$PBExportHeader$w_toolbar.srw
$PBExportComments$menu de toolbars
forward
global type w_toolbar from window
end type
type rb_flotante from radiobutton within w_toolbar
end type
type rb_abajo from radiobutton within w_toolbar
end type
type rb_derecha from radiobutton within w_toolbar
end type
type rb_arriba from radiobutton within w_toolbar
end type
type rb_izquierda from radiobutton within w_toolbar
end type
type cb_done from commandbutton within w_toolbar
end type
type cb_visible from commandbutton within w_toolbar
end type
type cbx_descripcion from checkbox within w_toolbar
end type
type gb_1 from groupbox within w_toolbar
end type
end forward

global type w_toolbar from window
integer x = 850
integer y = 468
integer width = 923
integer height = 1004
boolean titlebar = true
string title = "Toolbars"
boolean controlmenu = true
windowtype windowtype = response!
long backcolor = 67108864
event ue_help_topic ( )
event ue_help_index ( )
rb_flotante rb_flotante
rb_abajo rb_abajo
rb_derecha rb_derecha
rb_arriba rb_arriba
rb_izquierda rb_izquierda
cb_done cb_done
cb_visible cb_visible
cbx_descripcion cbx_descripcion
gb_1 gb_1
end type
global w_toolbar w_toolbar

type variables
/* Current application */
Application	iapp_application

/* Owning toolbar window */
Window		iw_window
end variables

event open;iw_window = message.powerobjectparm			// nombre de Parent window

iapp_application = GetApplication ()		// nombre de Parent Application

choose case iw_window.toolbaralignment		// seteo inicial de alineamiento
	case alignatbottom! 
		rb_abajo.Checked = TRUE
	case alignatleft!
		rb_izquierda.Checked = TRUE
	case alignatright! 
		rb_derecha.Checked = TRUE
	case alignattop! 
		rb_arriba.Checked = TRUE
	case floating!
		rb_flotante.Checked = TRUE
end choose

if iw_window.toolbarvisible then				// status visibilidad
	cb_visible.text = "Esconder"
else
	cb_visible.text = "Mostrar"
end if

cbx_descripcion.checked = iapp_application.toolbartext  // status descripcion


end event

on w_toolbar.create
this.rb_flotante=create rb_flotante
this.rb_abajo=create rb_abajo
this.rb_derecha=create rb_derecha
this.rb_arriba=create rb_arriba
this.rb_izquierda=create rb_izquierda
this.cb_done=create cb_done
this.cb_visible=create cb_visible
this.cbx_descripcion=create cbx_descripcion
this.gb_1=create gb_1
this.Control[]={this.rb_flotante,&
this.rb_abajo,&
this.rb_derecha,&
this.rb_arriba,&
this.rb_izquierda,&
this.cb_done,&
this.cb_visible,&
this.cbx_descripcion,&
this.gb_1}
end on

on w_toolbar.destroy
destroy(this.rb_flotante)
destroy(this.rb_abajo)
destroy(this.rb_derecha)
destroy(this.rb_arriba)
destroy(this.rb_izquierda)
destroy(this.cb_done)
destroy(this.cb_visible)
destroy(this.cbx_descripcion)
destroy(this.gb_1)
end on

type rb_flotante from radiobutton within w_toolbar
integer x = 256
integer y = 456
integer width = 334
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Flotante"
end type

event clicked;iw_window.toolbaralignment = floating!
end event

type rb_abajo from radiobutton within w_toolbar
integer x = 256
integer y = 376
integer width = 315
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Abajo"
end type

event clicked;iw_window.toolbaralignment = alignatbottom!
end event

type rb_derecha from radiobutton within w_toolbar
integer x = 256
integer y = 296
integer width = 334
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Derecha"
end type

event clicked;iw_window.toolbaralignment = alignatright!
end event

type rb_arriba from radiobutton within w_toolbar
integer x = 256
integer y = 136
integer width = 261
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Arriba"
end type

event clicked;iw_window.toolbaralignment = alignattop!
end event

type rb_izquierda from radiobutton within w_toolbar
integer x = 256
integer y = 216
integer width = 347
integer height = 72
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Century Gothic"
long textcolor = 33554432
long backcolor = 67108864
string text = "Izquierda"
end type

event clicked;iw_window.toolbaralignment = alignatleft!
end event

type cb_done from commandbutton within w_toolbar
integer x = 480
integer y = 768
integer width = 334
integer height = 108
integer taborder = 30
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cerrar"
end type

event clicked;
Close (parent)
end event

type cb_visible from commandbutton within w_toolbar
integer x = 41
integer y = 768
integer width = 334
integer height = 108
integer taborder = 20
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Esconder"
boolean default = true
end type

event clicked;
IF THIS.text = "Esconder" THEN
	iw_window.toolbarvisible = FALSE
	this.text = "Mostrar"
ELSE
	iw_window.toolbarvisible = TRUE
	this.text = "Esconder"
END IF
end event

type cbx_descripcion from checkbox within w_toolbar
integer x = 55
integer y = 640
integer width = 645
integer height = 72
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Mostrar Descripcion"
end type

event clicked;iapp_application.toolbartext = this.checked 

end event

type gb_1 from groupbox within w_toolbar
integer x = 160
integer y = 48
integer width = 571
integer height = 520
integer taborder = 10
integer textsize = -10
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Ubicar Toolbar"
end type

