$PBExportHeader$u_splitbar_vertical.sru
$PBExportComments$Vertical Splitbar Object
forward
global type u_splitbar_vertical from statictext
end type
end forward

global type u_splitbar_vertical from statictext
integer width = 18
integer height = 900
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string pointer = "SizeWE!"
long textcolor = 33554432
long backcolor = 255
boolean focusrectangle = false
event mousedown pbm_lbuttondown
event mousemove pbm_mousemove
event mouseup pbm_lbuttonup
end type
global u_splitbar_vertical u_splitbar_vertical

type prototypes
Function ulong GetSysColor ( &
	integer nindex &
	) Library "user32.dll"

end prototypes

type variables
Window iw_parent
String is_myname
PowerObject ipo_parent
Dragobject idrg_left[]
Dragobject idrg_right[]
Boolean ib_livesizing
String is_company
String is_appname
Integer ii_minrange = 100
Integer ii_maxrange = 100

end variables

forward prototypes
public function unsignedlong of_get_syscolor (integer ai_index)
public subroutine of_set_livesizing (boolean ab_flag)
public function window of_get_parentwindow ()
public function string of_get_objectname ()
public subroutine of_set_leftobject (ref dragobject adrg_left)
public subroutine of_set_rightobject (ref dragobject adrg_right)
public subroutine of_get_location ()
public subroutine of_set_location ()
public subroutine of_arrange_objects ()
public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange)
end prototypes

event mousedown;// make sure object stays on top
this.SetPosition(ToTop!)

// set color to button shadow
If Not ib_livesizing Then
	this.BackColor = of_get_syscolor(16)
End If

end event

event mousemove;Integer li_pointer, li_minrange, li_maxrange
DragObject ldrg_parent

// if left button pressed, move object
If KeyDown(keyLeftButton!) Then
	// get location of mouse pointer
	If ipo_parent.TypeOf() = Window! Then
		li_pointer = iw_parent.PointerX()
	Else
		ldrg_parent = ipo_parent
		li_pointer = ldrg_parent.PointerX()
	End If
	// calculate the valid range of movement
	li_minrange = idrg_left[1].x + ii_minrange
	li_maxrange = (idrg_right[1].x + idrg_right[1].width) - ii_maxrange
	// move the splitbar if within the range
	If li_pointer > li_minrange And li_pointer < li_maxrange Then
		// move splitbar to mouse location
		this.X = li_pointer
		// resize objects if using livesizing
		If ib_livesizing Then
			of_arrange_objects()
		End If
	End If
End If

end event

event mouseup;// arrange objects
of_arrange_objects()

// restore color to match background
If Not ib_livesizing Then
	this.BackColor = iw_parent.BackColor
End If

end event

public function unsignedlong of_get_syscolor (integer ai_index);// These are the argument values
//
//        Object          Value         Object          Value
// --------------------- ------- --------------------- -------
// Scroll Bar Background     0
// Desktop Background        1   Inactive Border          11
// Active Title Bar          2   App Work Space           12
// Inactive Title Bar        3   Highlight                13
// Menu                      4   Highlight Text           14
// Window                    5   Button Face              15
// Window Frame              6   Button Shadow            16
// Menu Text                 7   Gray Text                17
// Window Text               8   Button Text              18
// Title Bar Text            9   Inactive Title Bar Text  19
// Active Border            10   Button Highlight         20

// ToolTip Text             23   ToolTip Background       24

Return GetSysColor(ai_index)

end function

public subroutine of_set_livesizing (boolean ab_flag);// set livesizing flag
ib_livesizing = ab_flag

end subroutine

public function window of_get_parentwindow ();PowerObject	lpo_parent
Window lw_window

// loop thru parents until a window is found
lpo_parent = this.GetParent()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	lpo_parent = lpo_parent.GetParent()
Loop

// set return to the window or null if not found
If IsValid (lpo_parent) Then
	lw_window = lpo_parent
Else
	SetNull(lw_window)
End If

Return lw_window

end function

public function string of_get_objectname ();PowerObject	lpo_parent
String ls_object

// loop thru parents building object name
lpo_parent = this.GetParent()
ls_object = this.ClassName()
Do While lpo_parent.TypeOf() <> Window! and IsValid (lpo_parent)
	ls_object = lpo_parent.ClassName() + "." + ls_object
	lpo_parent = lpo_parent.GetParent()
Loop

Return ls_object

end function

public subroutine of_set_leftobject (ref dragobject adrg_left);Integer li_max, li_range

li_max = UpperBound(idrg_left) + 1

// set drag left object
idrg_left[li_max] = adrg_left

// arrange objects
of_arrange_objects()

end subroutine

public subroutine of_set_rightobject (ref dragobject adrg_right);Integer li_max, li_range

li_max = UpperBound(idrg_right) + 1

// set right drag object
idrg_right[li_max] = adrg_right

// arrange objects
of_arrange_objects()

end subroutine

public subroutine of_get_location ();// this function loads current location from the registry

String ls_regkey, ls_value
Long ll_position

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company
ls_regkey += "\" + is_appname + "\SplitBars"

// set value in registry
RegistryGet(ls_regkey, is_myname, RegString!, ls_value)

// move object to prior location
ll_position = Long(ls_value)
If ll_position > 0 Then
	this.X = ll_position
	of_arrange_objects()
End If

end subroutine

public subroutine of_set_location ();// this function saves current location in the registry

String ls_regkey

ls_regkey  = "HKEY_CURRENT_USER\Software\" + is_company
ls_regkey += "\" + is_appname + "\SplitBars"

// set value in registry
RegistrySet(ls_regkey, is_myname, String(this.x))

end subroutine

public subroutine of_arrange_objects ();// resize and arrange dragobjects

Integer li_cnt, li_max, li_maxsize

If UpperBound(idrg_left) = 0 Then Return
If UpperBound(idrg_right) = 0 Then Return

iw_parent.SetRedraw(False)

// resize the left dragobjects
li_max = UpperBound(idrg_left)
FOR li_cnt = 1 TO li_max
	idrg_left[li_cnt].width = this.x - idrg_left[li_cnt].x
NEXT

// resize the right dragobjects
li_max = UpperBound(idrg_right)
FOR li_cnt = 1 TO li_max
	li_maxsize = (idrg_right[li_cnt].x + idrg_right[li_cnt].width)
	idrg_right[li_cnt].x = this.x + this.width
	idrg_right[li_cnt].width = li_maxsize - idrg_right[li_cnt].x
NEXT

iw_parent.SetRedraw(True)

end subroutine

public subroutine of_set_minsize (integer ai_minrange, integer ai_maxrange);// set minimum size
ii_minrange = ai_minrange
ii_maxrange = ai_maxrange

end subroutine

event constructor;// set identification variables
is_appname = gn_app.of_GetAppName()
is_company = gn_app.of_GetCompany()
iw_parent = this.of_Get_ParentWindow()
ipo_parent = this.GetParent()
is_myname = iw_parent.ClassName() + "." + this.of_Get_ObjectName()

// set color to match background
this.BackColor = iw_parent.BackColor

end event

on u_splitbar_vertical.create
end on

on u_splitbar_vertical.destroy
end on

