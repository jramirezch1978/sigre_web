$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_cancel from commandbutton within w_main
end type
type dw_adapters from datawindow within w_main
end type
end forward

global type w_main from window
integer width = 2423
integer height = 1392
boolean titlebar = true
string title = "Network Adapter Info"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_cancel cb_cancel
dw_adapters dw_adapters
end type
global w_main w_main

type variables
n_adapter in_adapt

end variables

on w_main.create
this.cb_cancel=create cb_cancel
this.dw_adapters=create dw_adapters
this.Control[]={this.cb_cancel,&
this.dw_adapters}
end on

on w_main.destroy
destroy(this.cb_cancel)
destroy(this.dw_adapters)
end on

event open;String ls_macaddress[], ls_description[]
String ls_adaptername[], ls_ipaddress[]
Integer li_cnt, li_max, li_row

in_adapt.of_GetAdaptersInfo(ls_macaddress, ls_description, &
					ls_adaptername, ls_ipaddress)

li_max = UpperBound(ls_description)
For li_cnt = 1 To li_max
	li_row = dw_adapters.InsertRow(0)
	dw_adapters.SetItem(li_row, "macaddress",  ls_macaddress[li_row])
	dw_adapters.SetItem(li_row, "description", ls_description[li_row])
	dw_adapters.SetItem(li_row, "adaptername", ls_adaptername[li_row])
	dw_adapters.SetItem(li_row, "ipaddress",   ls_ipaddress[li_row])
Next

end event

type cb_cancel from commandbutton within w_main
integer x = 2011
integer y = 1152
integer width = 334
integer height = 100
integer taborder = 20
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

type dw_adapters from datawindow within w_main
integer x = 37
integer y = 32
integer width = 2309
integer height = 1044
integer taborder = 10
string title = "none"
string dataobject = "d_adapters"
boolean vscrollbar = true
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

