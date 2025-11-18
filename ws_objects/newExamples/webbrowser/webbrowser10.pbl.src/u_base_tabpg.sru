$PBExportHeader$u_base_tabpg.sru
forward
global type u_base_tabpg from userobject
end type
end forward

global type u_base_tabpg from userobject
integer width = 2455
integer height = 1636
long backcolor = 67108864
string text = "none"
long tabtextcolor = 33554432
long picturemaskcolor = 536870912
event selectionchanged pbm_tcnselchanged
event open pbm_open
event close pbm_close
event resize pbm_size
event selectionchanging pbm_tcnselchanging
event m_printpreview ( )
event m_print ( )
event m_pagesetup ( )
end type
global u_base_tabpg u_base_tabpg

type variables
Window iw_parent

end variables

forward prototypes
public function window of_parentwindow ()
end prototypes

event selectionchanged;// triggered by base tab

end event

event open;// triggered by base tab

end event

event close;// triggered by base tab

end event

event resize;// Resize

end event

event selectionchanging;// triggered by base tab

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

on u_base_tabpg.create
end on

on u_base_tabpg.destroy
end on

event constructor;iw_parent = of_ParentWindow()

end event

