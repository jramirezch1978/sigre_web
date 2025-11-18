$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_process from commandbutton within w_main
end type
type dw_1 from datawindow within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 3520
integer height = 1128
boolean titlebar = true
string title = "USPS Bar Code"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
cb_process cb_process
dw_1 dw_1
cb_cancel cb_cancel
end type
global w_main w_main

type prototypes
Function long USPSEncode ( &
	blob TrackPtr, &
	blob RoutePtr, &
	Ref string BarPtr &
	) Library "usps4pb.dll" Alias For "pbEncoder;Ansi"

end prototypes

forward prototypes
public function long wf_uspsencode (string as_tracking, string as_routing, ref string as_barcode)
end prototypes

public function long wf_uspsencode (string as_tracking, string as_routing, ref string as_barcode);Blob lblb_Track, lblb_Route

lblb_Track = Blob(Trim(as_Tracking)+Space(21), EncodingAnsi!)
lblb_Route = Blob(Trim(as_Routing)+Space(12), EncodingAnsi!)

as_BarCode = Space(65)

Return USPSEncode(lblb_Track, lblb_Route, as_BarCode)

end function

on w_main.create
this.cb_process=create cb_process
this.dw_1=create dw_1
this.cb_cancel=create cb_cancel
this.Control[]={this.cb_process,&
this.dw_1,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.cb_process)
destroy(this.dw_1)
destroy(this.cb_cancel)
end on

type cb_process from commandbutton within w_main
integer x = 37
integer y = 896
integer width = 334
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Process"
end type

event clicked;Long ll_row, ll_max, ll_RetCode
String ls_Track, ls_Route, ls_BarCode

ll_max = dw_1.RowCount()
For ll_row = 1 To ll_max
	ls_Track = dw_1.GetItemString(ll_row, "tracking")
	ls_Route = dw_1.GetItemString(ll_row, "routing")
	ll_RetCode = wf_USPSEncode(ls_Track, ls_Route, ls_BarCode)
	If ll_RetCode = 0 Then
		dw_1.SetItem(ll_row, "barcode", ls_BarCode)
		dw_1.SetItem(ll_row, "errormsg", "")
	Else
		dw_1.SetItem(ll_row, "barcode", "")
		dw_1.SetItem(ll_row, "errormsg", ls_BarCode)
	End If
Next

end event

type dw_1 from datawindow within w_main
integer x = 37
integer y = 32
integer width = 3406
integer height = 836
integer taborder = 10
string title = "none"
string dataobject = "d_testcases"
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type

type cb_cancel from commandbutton within w_main
integer x = 3109
integer y = 896
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

