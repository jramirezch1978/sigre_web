$PBExportHeader$w_statusbar.srw
forward
global type w_statusbar from window
end type
type st_message_border from statictext within w_statusbar
end type
type st_date_border from statictext within w_statusbar
end type
type st_time_border from statictext within w_statusbar
end type
type ln_far_left from line within w_statusbar
end type
type st_time from statictext within w_statusbar
end type
type st_date from statictext within w_statusbar
end type
type st_message from statictext within w_statusbar
end type
end forward

global type w_statusbar from window
integer width = 905
integer height = 84
boolean border = false
windowtype windowtype = child!
long backcolor = 79741120
st_message_border st_message_border
st_date_border st_date_border
st_time_border st_time_border
ln_far_left ln_far_left
st_time st_time
st_date st_date
st_message st_message
end type
global w_statusbar w_statusbar

type prototypes
Function integer GetClassName ( &
	ulong hWind, &
	Ref string name, &
	int cbmax &
	) Library "user32.dll" Alias For "GetClassNameW"

Function ulong GetWindow ( &
	ulong hWind, &
	uint fuRel &
	) Library "user32.dll"

Function ulong SetParent ( &
	ulong hChild, &
	ulong hParent &
	) Library "user32.dll"

end prototypes

type variables
String is_classname
Integer ii_width

end variables

forward prototypes
public subroutine wf_set_message (string as_msg)
public subroutine wf_reposition ()
public subroutine wf_setparent ()
end prototypes

public subroutine wf_set_message (string as_msg);// set message
st_message.text = " " + Trim(as_msg)

// update date/time
this.Event Timer()

end subroutine

public subroutine wf_reposition ();Integer li_share

// if the window would be more than 2/3
// of width hide it off to the right
li_share = (gw_frame.width / 3) * 2
If this.ii_width > li_share Then
	this.x = gw_frame.width
Else
	If gw_frame.WindowState = Maximized! Then
		this.x = gw_frame.width - ii_width - 25
	Else
		this.x = gw_frame.width - ii_width - 90
	End If
End If
this.y = 5

// update date/time
this.Event Timer()

end subroutine

public subroutine wf_setparent ();String ls_name
ULong lul_hwnd
Integer li_rc

// find the microhelp handle
lul_hwnd = GetWindow(Handle(gw_frame), 5)
DO UNTIL lul_hwnd = 0
	ls_name = Space(25)
	li_rc = GetClassName(lul_hwnd, ls_name, Len(ls_name))
	If ls_name = is_classname Then
		lul_hwnd = SetParent(Handle(this), lul_hwnd)
		lul_hwnd = 0
	Else
		lul_hwnd = GetWindow(lul_hwnd, 2)
	End If
LOOP

end subroutine

on w_statusbar.create
this.st_message_border=create st_message_border
this.st_date_border=create st_date_border
this.st_time_border=create st_time_border
this.ln_far_left=create ln_far_left
this.st_time=create st_time
this.st_date=create st_date
this.st_message=create st_message
this.Control[]={this.st_message_border,&
this.st_date_border,&
this.st_time_border,&
this.ln_far_left,&
this.st_time,&
this.st_date,&
this.st_message}
end on

on w_statusbar.destroy
destroy(this.st_message_border)
destroy(this.st_date_border)
destroy(this.st_time_border)
destroy(this.ln_far_left)
destroy(this.st_time)
destroy(this.st_date)
destroy(this.st_message)
end on

event open;Environment le_env

GetEnvironment(le_env)

// determine position of window within microhelp bar
ii_width = st_time.x + st_time.width + 25
this.width = ii_width

// set object class name
If le_env.PBMajorRevision = 10 And &
	le_env.PBMinorRevision = 5 Then
	// PowerBuilder 10.5
	is_classname = "FNHELP105"
Else
	is_classname = "FNHELP" + &
		String(le_env.PBMajorRevision * 10)
End If

// set parenthood
this.wf_setparent()

// position the window
this.wf_reposition()

// initiate timer
Timer(60)

end event

event timer;// set current time
st_time.text = String(Now(), "h:mm AM/PM")

// set current date
st_date.text = String(Today(), "m/dd/yy")

end event

type st_message_border from statictext within w_statusbar
integer x = 14
integer y = 4
integer width = 375
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_date_border from statictext within w_statusbar
integer x = 398
integer y = 4
integer width = 242
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type st_time_border from statictext within w_statusbar
integer x = 649
integer y = 4
integer width = 238
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
boolean enabled = false
boolean border = true
borderstyle borderstyle = stylelowered!
boolean focusrectangle = false
end type

type ln_far_left from line within w_statusbar
long linecolor = 16777215
integer linethickness = 4
integer beginy = 4
integer endy = 68
end type

type st_time from statictext within w_statusbar
integer x = 654
integer y = 8
integer width = 224
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
alignment alignment = center!
boolean focusrectangle = false
end type

type st_date from statictext within w_statusbar
integer x = 402
integer y = 8
integer width = 233
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
alignment alignment = center!
boolean focusrectangle = false
end type

type st_message from statictext within w_statusbar
integer x = 18
integer y = 8
integer width = 361
integer height = 56
boolean bringtotop = true
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long backcolor = 79741120
boolean focusrectangle = false
end type

event clicked;String ls_name

// get window classname
ls_name = Space(25)
GetClassName(Handle(Parent), ls_name, Len(ls_name))

MessageBox("Window Class", ls_name)

end event

