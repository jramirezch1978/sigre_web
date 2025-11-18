$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type cb_posturl_file from commandbutton within w_main
end type
type cb_post_binary from commandbutton within w_main
end type
type cb_geturl_file from commandbutton within w_main
end type
type st_msg from statictext within w_main
end type
type cb_geturl_text from commandbutton within w_main
end type
type cb_post_text from commandbutton within w_main
end type
type mle_response from multilineedit within w_main
end type
type cb_get from commandbutton within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 3195
integer height = 1716
boolean titlebar = true
string title = "WinHTTP"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_setwriteprogress pbm_custom01
cb_posturl_file cb_posturl_file
cb_post_binary cb_post_binary
cb_geturl_file cb_geturl_file
st_msg st_msg
cb_geturl_text cb_geturl_text
cb_post_text cb_post_text
mle_response mle_response
cb_get cb_get
cb_cancel cb_cancel
end type
global w_main w_main

type prototypes

end prototypes

type variables

end variables

event ue_setwriteprogress;// update write progress

String ls_msg

ls_msg = "Send Data " + &
			String(wparam / lparam, "#0%") + " complete."

st_msg.text = ls_msg

Yield()

end event

on w_main.create
this.cb_posturl_file=create cb_posturl_file
this.cb_post_binary=create cb_post_binary
this.cb_geturl_file=create cb_geturl_file
this.st_msg=create st_msg
this.cb_geturl_text=create cb_geturl_text
this.cb_post_text=create cb_post_text
this.mle_response=create mle_response
this.cb_get=create cb_get
this.cb_cancel=create cb_cancel
this.Control[]={this.cb_posturl_file,&
this.cb_post_binary,&
this.cb_geturl_file,&
this.st_msg,&
this.cb_geturl_text,&
this.cb_post_text,&
this.mle_response,&
this.cb_get,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.cb_posturl_file)
destroy(this.cb_post_binary)
destroy(this.cb_geturl_file)
destroy(this.st_msg)
destroy(this.cb_geturl_text)
destroy(this.cb_post_text)
destroy(this.mle_response)
destroy(this.cb_get)
destroy(this.cb_cancel)
end on

type cb_posturl_file from commandbutton within w_main
integer x = 2706
integer y = 832
integer width = 407
integer height = 100
integer taborder = 70
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "PostURL File"
end type

event clicked;// example HTTP POST in the style of the PostURL function

n_winhttp ln_http
String ls_URL, ls_title, ls_pathname, ls_filename
String ls_filter, ls_data, ls_mimetype
Blob lblob_data, lblob_response
Integer li_rc, li_fnum
ULong lul_length

ls_title  = "Select a File"
ls_filter = "Target Files (*.pbt),*.pbt"

li_rc = GetFileOpenName(ls_title, ls_pathname, &
							ls_filename, "", ls_filter)
If li_rc < 1 Then
	Return
End If

li_fnum = FileOpen(ls_pathname, TextMode!, Read!)
lul_length = FileReadEx(li_fnum, ls_data)
FileClose(li_fnum)
lblob_data = Blob(ls_data, EncodingAnsi!)

SetPointer(HourGlass!)

ln_http.SetWriteProgress(Handle(Parent), 1024)

ls_URL  = "http://www.topwizprogramming.com"
ls_URL += "/winhttp/roland_post.asp?filename=" + ls_filename

ls_mimetype = ln_http.GetMIMEType(ls_pathname, lblob_data)

lul_length = ln_http.PostURL(ls_URL, &
			lblob_data, ls_mimetype, lblob_response)
If lul_length > 0 Then
	mle_response.text = String(lblob_response, EncodingAnsi!)
	st_msg.text = "Post Complete in " + &
		String(ln_http.Elapsed, "#,##0.####") + " seconds."
Else
	MessageBox("PostURL Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type cb_post_binary from commandbutton within w_main
integer x = 2706
integer y = 672
integer width = 407
integer height = 100
integer taborder = 60
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Post Binary File"
end type

event clicked;// example HTTP POST

n_winhttp ln_http
String ls_URL, ls_title, ls_pathname, ls_filename
String ls_filter, ls_mimetype
Integer li_rc, li_fnum
ULong lul_length
Blob lblob_data

ls_title  = "Select a File"
ls_filter = "Adobe Acrobat Files (*.pdf),*.pdf"

li_rc = GetFileOpenName(ls_title, ls_pathname, &
							ls_filename, "", ls_filter)
If li_rc < 1 Then
	Return
End If

li_fnum = FileOpen(ls_pathname, StreamMode!, Read!)
lul_length = FileReadEx(li_fnum, lblob_data)
FileClose(li_fnum)

SetPointer(HourGlass!)

ln_http.SetWriteProgress(Handle(Parent), 1024)

ls_URL  = "http://www.topwizprogramming.com"
ls_URL += "/winhttp/roland_post.asp?filename=" + ls_filename

ls_mimetype = ln_http.GetMIMEType(ls_pathname, lblob_data)

ln_http.Open("POST", ls_URL)
ln_http.SetRequestHeader("Content-Length", String(lul_length))
ln_http.SetRequestHeader("Content-Type", ls_mimetype)

lul_length = ln_http.Send(lblob_data)
If lul_length > 0 Then
	mle_response.text = ln_http.ResponseText
	st_msg.text = "Post Complete in " + &
		String(ln_http.Elapsed, "#,##0.####") + " seconds."
Else
	MessageBox("HTTP Post Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type cb_geturl_file from commandbutton within w_main
integer x = 2706
integer y = 352
integer width = 407
integer height = 100
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GetURL File"
end type

event clicked;// example HTTP GET in the style of the GetURL function

n_winhttp ln_http
Blob lblob_data
String ls_URL, ls_pathname, ls_filename
Integer li_rc, li_fnum
ULong lul_length

SetPointer(HourGlass!)

// get a binary file from the server
ls_pathname = "payflowgateway_guide.pdf"
ls_URL = "http://www.topwizprogramming.com/winhttp/" + ls_pathname

lul_length = ln_http.GetURL(ls_URL, lblob_data)
If lul_length > 0 Then
	st_msg.text = "GetURL returned " + &
		String(Len(lblob_data)) + " characters in " + &
		String(ln_http.Elapsed, "#,##0.####") + " seconds."
	li_rc = GetFileSaveName("Save File", &
				ls_pathname, ls_filename, "pdf", &
				"Adobe Acrobat Files (*.pdf), *.pdf")
	If li_rc = 1 Then
		// save the returned blob to disk
		li_fnum = FileOpen(ls_pathname, StreamMode!, &
							Write!, LockWrite!, Replace!)
		FileWriteEx(li_fnum, lblob_data)
		FileClose(li_fnum)
	End If
Else
	MessageBox("GetURL Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type st_msg from statictext within w_main
integer x = 37
integer y = 1504
integer width = 2601
integer height = 68
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
long backcolor = 67108864
boolean focusrectangle = false
end type

type cb_geturl_text from commandbutton within w_main
integer x = 2706
integer y = 192
integer width = 407
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "GetURL Text"
end type

event clicked;// example HTTP GET in the style of the GetURL function

n_winhttp ln_http
ULong lul_length
Blob lblob_data
String ls_URL

SetPointer(HourGlass!)

// get a text file from the server
ls_URL = "http://www.topwizprogramming.com/about.html"

lul_length = ln_http.GetURL(ls_URL, lblob_data)
If lul_length > 0 Then
	st_msg.text = "GetURL returned " + &
		String(Len(lblob_data)) + " characters in " + &
		String(ln_http.Elapsed, "#,##0.####") + " seconds."
	mle_response.text = String(lblob_data, EncodingAnsi!)
Else
	MessageBox("GetURL Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type cb_post_text from commandbutton within w_main
integer x = 2706
integer y = 512
integer width = 407
integer height = 100
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Post Text File"
end type

event clicked;// example HTTP POST

n_winhttp ln_http
String ls_URL, ls_title, ls_pathname, ls_filename
String ls_filter, ls_mimetype, ls_data
Integer li_rc, li_fnum
ULong lul_length

ls_title  = "Select a File"
ls_filter = "Target Files (*.pbt),*.pbt"

li_rc = GetFileOpenName(ls_title, ls_pathname, &
							ls_filename, "", ls_filter)
If li_rc < 1 Then
	Return
End If

li_fnum = FileOpen(ls_pathname, TextMode!, Read!)
lul_length = FileReadEx(li_fnum, ls_data)
FileClose(li_fnum)

SetPointer(HourGlass!)

ln_http.SetWriteProgress(Handle(Parent), 1024)

ls_URL  = "http://www.topwizprogramming.com"
ls_URL += "/winhttp/roland_post.asp?filename=" + ls_filename

ls_mimetype = ln_http.GetMIMEType(ls_pathname, ls_data)

ln_http.Open("POST", ls_URL)
ln_http.SetRequestHeader("Content-Length", String(lul_length))
ln_http.SetRequestHeader("Content-Type", ls_mimetype)

lul_length = ln_http.Send(ls_data)
If lul_length > 0 Then
	mle_response.text = ln_http.ResponseText
	st_msg.text = "Post Complete in " + &
		String(ln_http.Elapsed, "#,##0.####") + " seconds."
Else
	MessageBox("HTTP Post Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type mle_response from multilineedit within w_main
integer x = 37
integer y = 32
integer width = 2601
integer height = 1444
integer taborder = 10
integer textsize = -9
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = fixed!
fontfamily fontfamily = modern!
string facename = "Fixedsys"
long textcolor = 33554432
boolean vscrollbar = true
boolean autovscroll = true
boolean displayonly = true
borderstyle borderstyle = stylelowered!
end type

type cb_get from commandbutton within w_main
integer x = 2706
integer y = 32
integer width = 407
integer height = 100
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Get"
end type

event clicked;// example HTTP Get in the style of XMLHttpRequest

n_winhttp ln_http
ULong lul_length
String ls_URL

SetPointer(HourGlass!)

// get a text file from the server
ls_URL = "http://www.topwizprogramming.com/about.html"

If ln_http.Open("GET", ls_URL) Then
	lul_length = ln_http.Send()
	If lul_length > 0 Then
		st_msg.text = "Get returned " + &
			String(lul_length) + " characters in " + &
			String(ln_http.Elapsed, "#,##0.####") + " seconds."
		mle_response.text = ln_http.ResponseText
	Else
		MessageBox("Send Error #" + &
						String(ln_http.LastErrorNum), &
						ln_http.LastErrorText, StopSign!)
	End If
Else
	MessageBox("Open Error #" + &
					String(ln_http.LastErrorNum), &
					ln_http.LastErrorText, StopSign!)
End If

end event

type cb_cancel from commandbutton within w_main
integer x = 2706
integer y = 1472
integer width = 407
integer height = 100
integer taborder = 80
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
string text = "Cancel"
boolean cancel = true
end type

event clicked;Close(Parent)

end event

