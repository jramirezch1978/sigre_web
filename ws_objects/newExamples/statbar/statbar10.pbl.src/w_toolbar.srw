$PBExportHeader$w_toolbar.srw
forward
global type w_toolbar from window
end type
type cbx_bigbuttons from checkbox within w_toolbar
end type
end forward

global type w_toolbar from window
integer width = 402
integer height = 92
boolean border = false
windowtype windowtype = child!
long backcolor = 67108864
cbx_bigbuttons cbx_bigbuttons
end type
global w_toolbar w_toolbar

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

end variables

forward prototypes
public subroutine wf_reposition ()
public subroutine wf_setparent ()
end prototypes

public subroutine wf_reposition ();choose case gw_frame.ToolbarAlignment
	case AlignAtTop!, AlignAtBottom!
		this.x = gw_frame.width - (this.width + 38)
		this.y = 8
	case AlignAtLeft!, AlignAtRight!
		this.x = 6
		this.y = gw_frame.height - (this.height + 300)
end choose

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

on w_toolbar.create
this.cbx_bigbuttons=create cbx_bigbuttons
this.Control[]={this.cbx_bigbuttons}
end on

on w_toolbar.destroy
destroy(this.cbx_bigbuttons)
end on

event open;Environment le_env
Application la_app

GetEnvironment(le_env)
la_app = GetApplication()

this.height = 90
cbx_bigbuttons.checked = la_app.ToolbarText

// set object class name
If le_env.PBMajorRevision = 10 And &
	le_env.PBMinorRevision = 5 Then
	// PowerBuilder 10.5
	is_classname = "FNFIXEDBAR105"
Else
	is_classname = "FNFIXEDBAR" + &
		String(le_env.PBMajorRevision * 10)
End If

// set parenthood
this.wf_setparent()

// position the window
this.wf_reposition()

end event

type cbx_bigbuttons from checkbox within w_toolbar
integer x = 9
integer y = 12
integer width = 370
integer height = 64
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Big Buttons"
boolean lefttext = true
end type

event clicked;Application la_app

la_app = GetApplication()
la_app.ToolbarText = this.checked


end event

