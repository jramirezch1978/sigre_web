$PBExportHeader$w_toolbar.srw
$PBExportComments$menu de toolbars
forward
global type w_toolbar from Window
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

global type w_toolbar from Window
int X=850
int Y=468
int Width=923
int Height=1004
boolean TitleBar=true
string Title="Toolbars"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
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
int X=256
int Y=456
int Width=334
int Height=72
string Text="Flotante"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iw_window.toolbaralignment = floating!
end event

type rb_abajo from radiobutton within w_toolbar
int X=256
int Y=376
int Width=315
int Height=72
string Text="Abajo"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iw_window.toolbaralignment = alignatbottom!
end event

type rb_derecha from radiobutton within w_toolbar
int X=256
int Y=296
int Width=334
int Height=72
string Text="Derecha"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iw_window.toolbaralignment = alignatright!
end event

type rb_arriba from radiobutton within w_toolbar
int X=256
int Y=136
int Width=261
int Height=72
string Text="Arriba"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iw_window.toolbaralignment = alignattop!
end event

type rb_izquierda from radiobutton within w_toolbar
int X=256
int Y=216
int Width=347
int Height=72
string Text="Izquierda"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="Century Gothic"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iw_window.toolbaralignment = alignatleft!
end event

type cb_done from commandbutton within w_toolbar
int X=480
int Y=768
int Width=334
int Height=108
int TabOrder=30
string Text="Cerrar"
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;
Close (parent)
end event

type cb_visible from commandbutton within w_toolbar
int X=41
int Y=768
int Width=334
int Height=108
int TabOrder=20
string Text="Esconder"
boolean Default=true
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
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
int X=55
int Y=640
int Width=645
int Height=72
string Text="Mostrar Descripcion"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;iapp_application.toolbartext = this.checked 

end event

type gb_1 from groupbox within w_toolbar
int X=160
int Y=48
int Width=571
int Height=520
int TabOrder=10
string Text="Ubicar Toolbar"
BorderStyle BorderStyle=StyleLowered!
long TextColor=33554432
long BackColor=12632256
int TextSize=-10
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

