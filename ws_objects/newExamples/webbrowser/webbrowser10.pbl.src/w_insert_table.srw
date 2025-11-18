$PBExportHeader$w_insert_table.srw
forward
global type w_insert_table from w_base_response
end type
type sle_width from singlelineedit within w_insert_table
end type
type em_cols from editmask within w_insert_table
end type
type em_rows from editmask within w_insert_table
end type
type st_3 from statictext within w_insert_table
end type
type st_2 from statictext within w_insert_table
end type
type st_1 from statictext within w_insert_table
end type
type cb_ok from commandbutton within w_insert_table
end type
type cb_cancel from commandbutton within w_insert_table
end type
end forward

global type w_insert_table from w_base_response
integer width = 928
integer height = 692
string title = "Insert Table"
sle_width sle_width
em_cols em_cols
em_rows em_rows
st_3 st_3
st_2 st_2
st_1 st_1
cb_ok cb_ok
cb_cancel cb_cancel
end type
global w_insert_table w_insert_table

type variables
u_web_browser iu_web

end variables

on w_insert_table.create
int iCurrent
call super::create
this.sle_width=create sle_width
this.em_cols=create em_cols
this.em_rows=create em_rows
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.cb_ok=create cb_ok
this.cb_cancel=create cb_cancel
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_width
this.Control[iCurrent+2]=this.em_cols
this.Control[iCurrent+3]=this.em_rows
this.Control[iCurrent+4]=this.st_3
this.Control[iCurrent+5]=this.st_2
this.Control[iCurrent+6]=this.st_1
this.Control[iCurrent+7]=this.cb_ok
this.Control[iCurrent+8]=this.cb_cancel
end on

on w_insert_table.destroy
call super::destroy
destroy(this.sle_width)
destroy(this.em_cols)
destroy(this.em_rows)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_ok)
destroy(this.cb_cancel)
end on

event open;call super::open;iu_web = Message.PowerObjectParm

end event

type sle_width from singlelineedit within w_insert_table
integer x = 329
integer y = 296
integer width = 224
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "50%"
borderstyle borderstyle = stylelowered!
end type

type em_cols from editmask within w_insert_table
integer x = 329
integer y = 168
integer width = 224
integer height = 84
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "3"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type em_rows from editmask within w_insert_table
integer x = 329
integer y = 40
integer width = 224
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "3"
borderstyle borderstyle = stylelowered!
string mask = "###"
end type

type st_3 from statictext within w_insert_table
integer x = 37
integer y = 304
integer width = 187
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Width:"
boolean focusrectangle = false
end type

type st_2 from statictext within w_insert_table
integer x = 37
integer y = 176
integer width = 261
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Columns:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_insert_table
integer x = 37
integer y = 48
integer width = 187
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Rows:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_insert_table
integer x = 37
integer y = 448
integer width = 334
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "OK"
boolean default = true
end type

event clicked;String ls_html, ls_width
Integer li_row, li_rows, li_col, li_cols
Double ldbl_data

em_rows.GetData(ldbl_data)
li_rows = Integer(ldbl_data)

em_cols.GetData(ldbl_data)
li_cols = Integer(ldbl_data)

ls_width = sle_width.text
If ls_width = "" Then
	ls_width = "100"
End If

ls_html =  "<table border=1 width=" + ls_width + ">"
For li_row = 1 To li_rows
	ls_html += "<tr>"
	For li_col = 1 To li_cols
		ls_html += "<td>"
		ls_html += "</td>"
	Next
	ls_html += "</tr>"
Next

ls_html += "</table>"

iu_web.of_InsertHTML(ls_html)

Close(Parent)

end event

type cb_cancel from commandbutton within w_insert_table
integer x = 512
integer y = 448
integer width = 334
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

