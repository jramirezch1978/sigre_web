$PBExportHeader$u_tabpg_text.sru
forward
global type u_tabpg_text from u_tabpg
end type
type mle_body from multilineedit within u_tabpg_text
end type
end forward

global type u_tabpg_text from u_tabpg
integer width = 3296
integer height = 1572
string text = "Text View"
mle_body mle_body
end type
global u_tabpg_text u_tabpg_text

forward prototypes
public subroutine of_load ()
end prototypes

public subroutine of_load ();// load message

u_tab_pop3 lu_parent
Integer li_idx, li_max
String ls_type

lu_parent = this.GetParent()

mle_body.text = "No Text View"

li_max = UpperBound(lu_parent.is_types)
For li_idx = 1 To li_max
	ls_type = Lower(lu_parent.is_types[li_idx])
	If Pos(ls_type, "content-type: text/plain;") > 0 Then
		mle_body.text = lu_parent.is_parts[li_idx]
		Exit
	End If
Next

end subroutine

on u_tabpg_text.create
int iCurrent
call super::create
this.mle_body=create mle_body
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.mle_body
end on

on u_tabpg_text.destroy
call super::destroy
destroy(this.mle_body)
end on

type mle_body from multilineedit within u_tabpg_text
integer x = 37
integer y = 32
integer width = 3223
integer height = 1508
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
boolean border = false
boolean vscrollbar = true
boolean displayonly = true
end type

