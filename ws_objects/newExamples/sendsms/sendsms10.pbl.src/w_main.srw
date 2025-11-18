$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type sle_from from singlelineedit within w_main
end type
type st_7 from statictext within w_main
end type
type sle_pass from singlelineedit within w_main
end type
type st_6 from statictext within w_main
end type
type sle_user from singlelineedit within w_main
end type
type st_5 from statictext within w_main
end type
type sle_api from singlelineedit within w_main
end type
type st_4 from statictext within w_main
end type
type cb_send from commandbutton within w_main
end type
type mle_response from multilineedit within w_main
end type
type st_3 from statictext within w_main
end type
type sle_msgtext from singlelineedit within w_main
end type
type em_phone from editmask within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type cb_cancel from commandbutton within w_main
end type
type gb_1 from groupbox within w_main
end type
end forward

global type w_main from window
integer width = 1806
integer height = 1260
boolean titlebar = true
string title = "Send SMS using www.clickatell.com"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
sle_from sle_from
st_7 st_7
sle_pass sle_pass
st_6 st_6
sle_user sle_user
st_5 st_5
sle_api sle_api
st_4 st_4
cb_send cb_send
mle_response mle_response
st_3 st_3
sle_msgtext sle_msgtext
em_phone em_phone
st_2 st_2
st_1 st_1
cb_cancel cb_cancel
gb_1 gb_1
end type
global w_main w_main

type variables
n_winhttp in_http
String is_API, is_User, is_Pass, is_From

end variables

forward prototypes
public function string wf_getreg (string as_entry, string as_default)
public subroutine wf_setreg (string as_entry, string as_value)
public function boolean wf_sendsms (string as_phonenbr, string as_message, ref string as_response)
end prototypes

public function string wf_getreg (string as_entry, string as_default);// This function gets a setting from the registry.

String ls_regkey, ls_regvalue

ls_regkey = "HKEY_CURRENT_USER\Software\TopWiz\SendSMS"

RegistryGet(ls_regkey, as_entry, ls_regvalue)
If ls_regvalue = "" Then
	ls_regvalue = as_default
End If

Return ls_regvalue

end function

public subroutine wf_setreg (string as_entry, string as_value);// This function saves a setting in the registry.

String ls_regkey

ls_regkey = "HKEY_CURRENT_USER\Software\TopWiz\SendSMS"

RegistrySet(ls_regkey, as_entry, as_value)

end subroutine

public function boolean wf_sendsms (string as_phonenbr, string as_message, ref string as_response);// This function sends a SMS message via Clickatell.
//
//	Note: The variable mo=1 is something we added to our Clickatell
//			account to help routing replies. You can remove it from
//			the code if not used.
//

String ls_theURL, ls_Message
ULong lul_length

ls_Message = in_http.URLEncode(as_Message)

ls_theURL  = "http://api.clickatell.com/http/sendmsg?"
ls_theURL += "api_id=" + is_API + "&user=" + is_User
ls_theURL += "&password=" + is_Pass + "&from=" + is_From
ls_theURL += "&to=1" + as_PhoneNbr + "&mo=1" + "&text=" + ls_Message

If in_http.Open("GET", ls_theURL) Then
	lul_length = in_http.Send()
	If lul_length > 0 Then
		as_response = in_http.ResponseText
		Return True
	Else
		as_response = "Send Error #" + String(in_http.LastErrorNum) + " " + &
									in_http.LastErrorText
	End If
Else
	as_response = "Open Error #" + String(in_http.LastErrorNum) + " " + &
								in_http.LastErrorText
End If

Return False

end function

on w_main.create
this.sle_from=create sle_from
this.st_7=create st_7
this.sle_pass=create sle_pass
this.st_6=create st_6
this.sle_user=create sle_user
this.st_5=create st_5
this.sle_api=create sle_api
this.st_4=create st_4
this.cb_send=create cb_send
this.mle_response=create mle_response
this.st_3=create st_3
this.sle_msgtext=create sle_msgtext
this.em_phone=create em_phone
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.gb_1=create gb_1
this.Control[]={this.sle_from,&
this.st_7,&
this.sle_pass,&
this.st_6,&
this.sle_user,&
this.st_5,&
this.sle_api,&
this.st_4,&
this.cb_send,&
this.mle_response,&
this.st_3,&
this.sle_msgtext,&
this.em_phone,&
this.st_2,&
this.st_1,&
this.cb_cancel,&
this.gb_1}
end on

on w_main.destroy
destroy(this.sle_from)
destroy(this.st_7)
destroy(this.sle_pass)
destroy(this.st_6)
destroy(this.sle_user)
destroy(this.st_5)
destroy(this.sle_api)
destroy(this.st_4)
destroy(this.cb_send)
destroy(this.mle_response)
destroy(this.st_3)
destroy(this.sle_msgtext)
destroy(this.em_phone)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancel)
destroy(this.gb_1)
end on

event open;String ls_PhoneNbr

ls_PhoneNbr = wf_GetReg("PhoneNbr", "")
em_phone.text = ls_PhoneNbr

sle_api.text  = wf_GetReg("API", "")
sle_from.text = wf_GetReg("From", "")
sle_user.text = wf_GetReg("User", "")
sle_pass.text = wf_GetReg("Pass", "")

end event

type sle_from from singlelineedit within w_main
integer x = 1125
integer y = 728
integer width = 489
integer height = 76
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_7 from statictext within w_main
integer x = 914
integer y = 736
integer width = 192
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "From:"
boolean focusrectangle = false
end type

type sle_pass from singlelineedit within w_main
integer x = 1125
integer y = 824
integer width = 489
integer height = 76
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_6 from statictext within w_main
integer x = 914
integer y = 832
integer width = 192
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Pass:"
boolean focusrectangle = false
end type

type sle_user from singlelineedit within w_main
integer x = 357
integer y = 824
integer width = 489
integer height = 76
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_5 from statictext within w_main
integer x = 146
integer y = 832
integer width = 192
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "User:"
boolean focusrectangle = false
end type

type sle_api from singlelineedit within w_main
integer x = 357
integer y = 728
integer width = 489
integer height = 76
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_4 from statictext within w_main
integer x = 146
integer y = 736
integer width = 192
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "API:"
boolean focusrectangle = false
end type

type cb_send from commandbutton within w_main
integer x = 37
integer y = 1024
integer width = 343
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Send"
boolean default = true
end type

event clicked;String ls_PhoneNbr, ls_Message, ls_Response

em_phone.GetData(ls_PhoneNbr)
ls_Message = sle_msgtext.text
is_API  = sle_api.text
is_From = sle_from.text
is_User = sle_user.text
is_Pass = sle_pass.text

If ls_PhoneNbr = "" Then
	MessageBox(this.text, "Phone Number is required!", StopSign!)
	em_phone.SetFocus()
	Return
End If

If ls_Message = "" Then
	MessageBox(this.text, "Message is required!", StopSign!)
	sle_msgtext.SetFocus()
	Return
End If

If is_API = "" Then
	MessageBox(this.text, "API is required!", StopSign!)
	sle_api.SetFocus()
	Return
End If

If is_From = "" Then
	MessageBox(this.text, "From is required!", StopSign!)
	sle_from.SetFocus()
	Return
End If

If is_User = "" Then
	MessageBox(this.text, "User is required!", StopSign!)
	sle_user.SetFocus()
	Return
End If

If is_Pass = "" Then
	MessageBox(this.text, "Pass is required!", StopSign!)
	sle_pass.SetFocus()
	Return
End If

SetPointer(HourGlass!)

// Send the message
wf_SendSMS(ls_PhoneNbr, ls_Message, ls_Response)

// Get the response
mle_response.text = ls_Response

wf_SetReg("PhoneNbr", ls_PhoneNbr)
wf_SetReg("API", sle_api.text)
wf_SetReg("FROM", sle_from.text)
wf_SetReg("User", sle_user.text)
wf_SetReg("Pass", sle_pass.text)

end event

type mle_response from multilineedit within w_main
integer x = 475
integer y = 300
integer width = 1248
integer height = 184
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_3 from statictext within w_main
integer x = 37
integer y = 308
integer width = 297
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Response:"
boolean focusrectangle = false
end type

type sle_msgtext from singlelineedit within w_main
integer x = 475
integer y = 172
integer width = 1248
integer height = 76
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type em_phone from editmask within w_main
integer x = 475
integer y = 44
integer width = 407
integer height = 76
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
maskdatatype maskdatatype = stringmask!
string mask = "(###) ###-####"
end type

type st_2 from statictext within w_main
integer x = 37
integer y = 180
integer width = 270
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Message:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 37
integer y = 52
integer width = 416
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Phone Number:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_main
integer x = 1381
integer y = 1024
integer width = 343
integer height = 100
integer taborder = 90
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

type gb_1 from groupbox within w_main
integer x = 37
integer y = 640
integer width = 1687
integer height = 324
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Clickatell Account Settings"
end type

