$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type dw_query from datawindow within w_main
end type
type cb_retrieve from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 3598
integer height = 1840
boolean titlebar = true
string title = "LDAP Query"
boolean controlmenu = true
long backcolor = 67108864
boolean center = true
dw_query dw_query
cb_retrieve cb_retrieve
cb_cancel cb_cancel
end type
global w_main w_main

type variables
n_ds_ldapquery ids_test

end variables

forward prototypes
public function string wf_errmsg (integer ai_rc)
end prototypes

public function string wf_errmsg (integer ai_rc);String ls_errmsg

choose case ai_rc
	case -1
		ls_errmsg = "Invalid Call: the argument is the Object property of a control"
	case -2
		ls_errmsg = "Class name not found"
	case -3
		ls_errmsg = "Object could not be created"
	case -4
		ls_errmsg = "Could not connect to object"
	case -9
		ls_errmsg = "Other error"
	case -15
		ls_errmsg = "COM+ is not loaded on this computer"
	case -16
		ls_errmsg = "Invalid Call: this function not applicable"
	case else
		ls_errmsg = "Undefined error: " + String(ai_rc)
end choose

Return ls_errmsg

end function

on w_main.create
this.dw_query=create dw_query
this.cb_retrieve=create cb_retrieve
this.cb_cancel=create cb_cancel
this.Control[]={this.dw_query,&
this.cb_retrieve,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.dw_query)
destroy(this.cb_retrieve)
destroy(this.cb_cancel)
end on

event open;ids_test = Create n_ds_ldapquery
ids_test.DataObject = dw_query.DataObject
ids_test.ShareData(dw_query)

end event

event close;Destroy ids_test

end event

type dw_query from datawindow within w_main
integer x = 37
integer y = 160
integer width = 3515
integer height = 1540
integer taborder = 20
string title = "none"
string dataobject = "d_query"
boolean hscrollbar = true
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

event rowfocuschanged;this.SelectRow(0, False)
this.SelectRow(currentrow, True)

end event

type cb_retrieve from commandbutton within w_main
integer x = 37
integer y = 32
integer width = 407
integer height = 100
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Retrieve"
end type

event clicked;String ls_where
Long ll_rc

SetPointer(HourGlass!)

//ls_where = "objectCategory='person' AND objectClass='user'"
ls_where = "objectClass='user' and objectCategory='person'"

dw_query.SetRedraw(False)

ll_rc = ids_test.of_Retrieve(ls_where)

dw_query.Event RowFocusChanged(dw_query.GetRow())

dw_query.SetRedraw(True)

dw_query.SetFocus()

end event

type cb_cancel from commandbutton within w_main
integer x = 3218
integer y = 32
integer width = 334
integer height = 100
integer taborder = 10
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

