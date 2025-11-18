$PBExportHeader$w_dm_pb2xls.srw
forward
global type w_dm_pb2xls from Window
end type
type st_3 from statictext within w_dm_pb2xls
end type
type st_2 from statictext within w_dm_pb2xls
end type
type st_1 from statictext within w_dm_pb2xls
end type
type cb_1 from commandbutton within w_dm_pb2xls
end type
end forward

global type w_dm_pb2xls from Window
int X=471
int Y=624
int Width=1824
int Height=460
boolean TitleBar=true
string Title="Demo version"
long BackColor=79741120
WindowType WindowType=response!
st_3 st_3
st_2 st_2
st_1 st_1
cb_1 cb_1
end type
global w_dm_pb2xls w_dm_pb2xls

type variables
integer cc = 10
end variables

event open;timer(1)
event timer()

end event

event timer;if cc > 0 then
	cb_1.Text = 'Close ' + string(cc)+ ' sec'
	cc --
else
	cb_1.Text = 'Close'
	cb_1.enabled = true
	cc = 00
end if
end event

on w_dm_pb2xls.create
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_1=create cb_1
this.Control[]={this.st_3,&
this.st_2,&
this.st_1,&
this.cb_1}
end on

on w_dm_pb2xls.destroy
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_1)
end on

type st_3 from statictext within w_dm_pb2xls
int X=763
int Y=116
int Width=983
int Height=76
int TabOrder=10
string Text="http://desta.com.ua/pb2xls"
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=79741120
string Pointer="C:\WINDOWS\CURSORS\Hand-m.cur"
int TextSize=-8
int Weight=700
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;run('start "' + this.text + '"', minimized!) 

end event

type st_2 from statictext within w_dm_pb2xls
int X=50
int Y=116
int Width=695
int Height=76
boolean Enabled=false
string Text="For more information visit:"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_dm_pb2xls
int X=50
int Y=40
int Width=1696
int Height=76
boolean Enabled=false
string Text="In your application the demo version of library PB2XLS is used"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_dm_pb2xls
int X=1317
int Y=220
int Width=434
int Height=92
int TabOrder=20
boolean Enabled=false
string Text="Close"
int TextSize=-8
int Weight=400
string FaceName="MS Sans Serif"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;close(parent)
end event

