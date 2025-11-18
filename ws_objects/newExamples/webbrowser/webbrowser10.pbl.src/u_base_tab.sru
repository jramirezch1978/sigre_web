$PBExportHeader$u_base_tab.sru
forward
global type u_base_tab from tab
end type
end forward

global type u_base_tab from tab
integer width = 2491
integer height = 1764
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long backcolor = 67108864
boolean raggedright = true
boolean focusonbuttondown = true
boolean boldselectedtext = true
integer selectedtab = 1
event open pbm_open
event close pbm_close
event resize pbm_size
end type
global u_base_tab u_base_tab

type variables
Window iw_parent

end variables

forward prototypes
public function window of_parentwindow ()
public subroutine of_triggerevent (string as_eventname)
end prototypes

event open;// trigger event on all tabs
this.TabTriggerEvent("open")

end event

event close;// trigger event on all tabs
this.TabTriggerEvent("close")

end event

event resize;// resize

end event

public function window of_parentwindow ();PowerObject	lpo_parent
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

public subroutine of_triggerevent (string as_eventname);// trigger event on current tab page
Control[this.SelectedTab].TriggerEvent(as_eventname)

end subroutine

event constructor;iw_parent = of_ParentWindow()

end event

event selectionchanged;// trigger event on new tab page
If newindex > 0 Then
	Return Control[newindex].Event Dynamic SelectionChanged(oldindex, newindex)
End If

end event

event selectionchanging;// trigger event on old tab page
If oldindex > 0 Then
	Return Control[oldindex].Event Dynamic SelectionChanging(oldindex, newindex)
End If

end event

