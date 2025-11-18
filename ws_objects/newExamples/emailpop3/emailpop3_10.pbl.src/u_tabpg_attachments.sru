$PBExportHeader$u_tabpg_attachments.sru
forward
global type u_tabpg_attachments from u_tabpg
end type
type st_1 from statictext within u_tabpg_attachments
end type
type lb_types from listbox within u_tabpg_attachments
end type
end forward

global type u_tabpg_attachments from u_tabpg
integer width = 3296
integer height = 1572
string text = "Attachments"
st_1 st_1
lb_types lb_types
end type
global u_tabpg_attachments u_tabpg_attachments

type variables
String is_parts[]
String is_types[]

end variables

forward prototypes
public subroutine of_load ()
end prototypes

public subroutine of_load ();// load attachments

u_tab_pop3 lu_parent
Integer li_idx, li_max, li_next
String ls_filename

lu_parent = this.GetParent()

lb_types.Reset()

li_max = UpperBound(lu_parent.is_types)
For li_idx = 1 To li_max
	// check part type for attachment
	If Pos(lu_parent.is_types[li_idx], &
				"Content-Disposition: attachment") > 0 Then
		// save types/parts to instance array
		li_next = UpperBound(is_parts) + 1
		is_parts[li_next] = lu_parent.is_parts[li_idx]
		is_types[li_next] = lu_parent.is_types[li_idx]
		// get attachment file name and add to list
		ls_filename = gn_pop3.of_AttachName(is_types[li_next])
		lb_types.AddItem(ls_filename)
	End If
Next

If lb_types.TotalItems() > 0 Then
	lb_types.SelectItem(1)
End If

end subroutine

on u_tabpg_attachments.create
int iCurrent
call super::create
this.st_1=create st_1
this.lb_types=create lb_types
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_1
this.Control[iCurrent+2]=this.lb_types
end on

on u_tabpg_attachments.destroy
call super::destroy
destroy(this.st_1)
destroy(this.lb_types)
end on

type st_1 from statictext within u_tabpg_attachments
integer x = 37
integer y = 32
integer width = 1285
integer height = 68
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Double-click the file name to save file to disk."
boolean focusrectangle = false
end type

type lb_types from listbox within u_tabpg_attachments
integer x = 37
integer y = 128
integer width = 1285
integer height = 740
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
boolean sorted = false
borderstyle borderstyle = stylelowered!
end type

event doubleclicked;// save attachment

Integer li_rc
Blob lblob_attach
String ls_pathname, ls_filename

li_rc = GetFolder("Save Attachment", ls_pathname)
If li_rc = 1 Then
	// get the attachment name
	ls_filename = gn_pop3.of_AttachName(is_types[index])
	// convert attachment to blob
	lblob_attach = gn_pop3.of_Decode64(is_parts[index])
	// write the blob to disk
	ls_pathname += "\" + ls_filename
	gn_pop3.of_WriteFile(ls_pathname, lblob_attach)
	MessageBox("Save Attachment", "File Saved: " + ls_pathname)
End If

end event

