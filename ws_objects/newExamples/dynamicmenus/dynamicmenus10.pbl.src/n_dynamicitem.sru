$PBExportHeader$n_dynamicitem.sru
forward
global type n_dynamicitem from nonvisualobject
end type
end forward

global type n_dynamicitem from nonvisualobject autoinstantiate
end type

type variables
m_dynamicitem im_dynamic[]
Window iw_parent

end variables

forward prototypes
public function integer of_additem (ref menu am_parent, string as_text)
public function integer of_addseparator (ref menu am_parent)
public function boolean of_getitembool (integer ai_index, string as_propname)
public function integer of_getitemcount ()
public function string of_getitemstring (integer ai_index, string as_propname)
public subroutine of_setitem (integer ai_index, string as_propname, boolean ab_value)
public subroutine of_setitem (integer ai_index, string as_propname, string as_value)
public subroutine of_setparent (readonly window aw_parent)
public subroutine of_setitem (integer ai_index, string as_propname, integer ai_value)
public function integer of_getiteminteger (integer ai_index, string as_propname)
end prototypes

public function integer of_additem (ref menu am_parent, string as_text);// create a new item

Integer li_index

// get next index
li_index = UpperBound(am_parent.Item) + 1

// create the menu item
im_dynamic[li_index] = Create m_dynamicitem
am_parent.Item[li_index] = im_dynamic[li_index].Item[1]

// save references in the newly created item
im_dynamic[li_index].iw_parent = iw_parent
im_dynamic[li_index].ii_index = li_index

// set the Text property
of_SetItem(li_index, "text", as_text)

// force redraw
am_parent.Hide()
am_parent.Show()

Return li_index

end function

public function integer of_addseparator (ref menu am_parent);// create a new separator item
Return of_AddItem(am_parent, "-")

end function

public function boolean of_getitembool (integer ai_index, string as_propname);// return the specified item boolean property

Boolean lb_value

choose case Lower(as_propname)
	case "checked"
		lb_value = im_dynamic[ai_index].Item[1].Checked
	case "default"
		lb_value = im_dynamic[ai_index].Item[1].Default
	case "enabled"
		lb_value = im_dynamic[ai_index].Item[1].Enabled
	case "visible"
		lb_value = im_dynamic[ai_index].Item[1].Visible
	case "toolbaritemdown"
		lb_value = im_dynamic[ai_index].Item[1].ToolbarItemDown
	case "toolbaritemvisible"
		lb_value = im_dynamic[ai_index].Item[1].ToolbarItemVisible
	case else
		MessageBox("GetItemBoolean Error", &
				"Invalid property name: " + as_propname, StopSign!)
end choose

Return lb_value

end function

public function integer of_getitemcount ();// return the number of items
Return UpperBound(im_dynamic)

end function

public function string of_getitemstring (integer ai_index, string as_propname);// return the specified item string property

String ls_value

choose case Lower(as_propname)
	case "microhelp"
		ls_value = im_dynamic[ai_index].Item[1].Microhelp
	case "tag"
		ls_value = im_dynamic[ai_index].Item[1].Tag
	case "text"
		ls_value = im_dynamic[ai_index].Item[1].Text
	case "toolbaritemdownname"
		ls_value = im_dynamic[ai_index].Item[1].ToolbarItemDownName
	case "toolbaritemname"
		ls_value = im_dynamic[ai_index].Item[1].ToolbarItemName
	case "toolbaritemtext"
		ls_value = im_dynamic[ai_index].Item[1].ToolbarItemText
	case else
		MessageBox("GetItemString Error", &
				"Invalid property name: " + as_propname, StopSign!)
end choose

Return ls_value

end function

public subroutine of_setitem (integer ai_index, string as_propname, boolean ab_value);// set the specified item boolean property

choose case Lower(as_propname)
	case "checked"
		im_dynamic[ai_index].Item[1].Checked = ab_value
	case "default"
		im_dynamic[ai_index].Item[1].Default = ab_value
	case "enabled"
		im_dynamic[ai_index].Item[1].Enabled = ab_value
	case "visible"
		im_dynamic[ai_index].Item[1].Visible = ab_value
	case "toolbaritemdown"
		im_dynamic[ai_index].Item[1].ToolbarItemDown = ab_value
	case "toolbaritemvisible"
		im_dynamic[ai_index].Item[1].ToolbarItemVisible = ab_value
	case else
		MessageBox("SetItem Error", &
				"Invalid boolean property name: " + as_propname, StopSign!)
end choose

end subroutine

public subroutine of_setitem (integer ai_index, string as_propname, string as_value);// set the specified item string property

choose case Lower(as_propname)
	case "microhelp"
		im_dynamic[ai_index].Item[1].Microhelp = as_value
	case "tag"
		im_dynamic[ai_index].Item[1].Tag = as_value
	case "text"
		im_dynamic[ai_index].Item[1].Text = as_value
	case "toolbaritemdownname"
		im_dynamic[ai_index].Item[1].ToolbarItemDownName = as_value
	case "toolbaritemname"
		im_dynamic[ai_index].Item[1].ToolbarItemName = as_value
	case "toolbaritemtext"
		im_dynamic[ai_index].Item[1].ToolbarItemText = as_value
	case else
		MessageBox("SetItem Error", &
				"Invalid string property name: " + as_propname, StopSign!)
end choose

end subroutine

public subroutine of_setparent (readonly window aw_parent);// set the parent window
iw_parent = aw_parent

end subroutine

public subroutine of_setitem (integer ai_index, string as_propname, integer ai_value);// set the specified item integer property

choose case Lower(as_propname)
	case "toolbaritembarindex"
		im_dynamic[ai_index].Item[1].ToolbarItemBarIndex = ai_value
	case "toolbaritemorder"
		im_dynamic[ai_index].Item[1].ToolbarItemOrder = ai_value
	case "toolbaritemspace"
		im_dynamic[ai_index].Item[1].ToolbarItemSpace = ai_value
	case else
		MessageBox("SetItem Error", &
				"Invalid integer property name: " + as_propname, StopSign!)
end choose

end subroutine

public function integer of_getiteminteger (integer ai_index, string as_propname);// return the specified item integer property

Integer li_value

choose case Lower(as_propname)
	case "toolbaritembarindex"
		li_value = im_dynamic[ai_index].Item[1].ToolbarItemBarIndex
	case "toolbaritemorder"
		li_value = im_dynamic[ai_index].Item[1].ToolbarItemOrder
	case "toolbaritemspace"
		li_value = im_dynamic[ai_index].Item[1].ToolbarItemSpace
	case else
		MessageBox("GetItemInteger Error", &
				"Invalid property name: " + as_propname, StopSign!)
end choose

Return li_value

end function

on n_dynamicitem.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dynamicitem.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

