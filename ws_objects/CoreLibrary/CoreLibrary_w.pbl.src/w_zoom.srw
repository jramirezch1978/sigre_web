$PBExportHeader$w_zoom.srw
$PBExportComments$menu de zoom
forward
global type w_zoom from Window
end type
type st_1 from statictext within w_zoom
end type
type em_porcentaje from editmask within w_zoom
end type
type cb_cancel from commandbutton within w_zoom
end type
type cb_ok from commandbutton within w_zoom
end type
end forward

global type w_zoom from Window
int X=727
int Y=540
int Width=672
int Height=412
boolean TitleBar=true
string Title="Zoom"
long BackColor=79741120
boolean ControlMenu=true
ToolBarAlignment ToolBarAlignment=AlignAtLeft!
WindowType WindowType=response!
event ue_help_topic ( )
event ue_help_index ( )
st_1 st_1
em_porcentaje em_porcentaje
cb_cancel cb_cancel
cb_ok cb_ok
end type
global w_zoom w_zoom

on w_zoom.create
this.st_1=create st_1
this.em_porcentaje=create em_porcentaje
this.cb_cancel=create cb_cancel
this.cb_ok=create cb_ok
this.Control[]={this.st_1,&
this.em_porcentaje,&
this.cb_cancel,&
this.cb_ok}
end on

on w_zoom.destroy
destroy(this.st_1)
destroy(this.em_porcentaje)
destroy(this.cb_cancel)
destroy(this.cb_ok)
end on

event open;Integer	li_Zoom

li_Zoom = Message.DoubleParm

em_porcentaje.Text = String(li_Zoom)






end event

type st_1 from statictext within w_zoom
int X=64
int Y=92
int Width=247
int Height=56
boolean Enabled=false
string Text="Tamaño"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_porcentaje from editmask within w_zoom
int X=46
int Y=164
int Width=279
int Height=100
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
string Mask="###"
boolean Spin=true
double Increment=5
string MinMax="5~~300"
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_cancel from commandbutton within w_zoom
int X=393
int Y=176
int Width=197
int Height=92
int TabOrder=20
string Text="Cancel"
boolean Cancel=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;CloseWithReturn(Parent, -1)

end event

type cb_ok from commandbutton within w_zoom
int X=393
int Y=36
int Width=197
int Height=92
int TabOrder=10
string Text="OK"
boolean Default=true
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;Integer	li_Zoom


If IsNumber(em_porcentaje.Text) Then
		li_Zoom = Integer(em_porcentaje.Text)
	Else
		MessageBox("Numero Invalido ", "Por favor introduzca % valido", Exclamation!, OK!)
		Return
	End If

CloseWithReturn(Parent, li_Zoom)

end event

