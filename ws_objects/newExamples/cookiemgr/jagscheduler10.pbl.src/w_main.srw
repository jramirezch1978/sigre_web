$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type em_interval from editmask within w_main
end type
type st_3 from statictext within w_main
end type
type rb_start from radiobutton within w_main
end type
type rb_resume from radiobutton within w_main
end type
type rb_suspend from radiobutton within w_main
end type
type rb_stop from radiobutton within w_main
end type
type cb_process from commandbutton within w_main
end type
type sle_component from singlelineedit within w_main
end type
type sle_package from singlelineedit within w_main
end type
type st_2 from statictext within w_main
end type
type st_1 from statictext within w_main
end type
type cb_cancel from commandbutton within w_main
end type
end forward

global type w_main from window
integer width = 1509
integer height = 944
boolean titlebar = true
string title = "JagScheduler"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
em_interval em_interval
st_3 st_3
rb_start rb_start
rb_resume rb_resume
rb_suspend rb_suspend
rb_stop rb_stop
cb_process cb_process
sle_component sle_component
sle_package sle_package
st_2 st_2
st_1 st_1
cb_cancel cb_cancel
end type
global w_main w_main

forward prototypes
public subroutine wf_start (string as_package, string as_component, integer ai_interval)
public subroutine wf_stop (string as_package, string as_component)
public subroutine wf_resume (string as_package, string as_component)
public subroutine wf_suspend (string as_package, string as_component)
end prototypes

public subroutine wf_start (string as_package, string as_component, integer ai_interval);GenericService l_gs
ThreadManager l_tm
String ls_errmsg, ls_group
Long ll_rc

// instantiate the component
ll_rc = gn_jag.CreateInstance(l_gs, as_package + "/" + as_component)
If ll_rc <> 0 Then
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
	Return
End If

// create local instance of Thread Manager
ll_rc = gn_jag.CreateInstance(l_tm, "CtsComponents/ThreadManager")
If ll_rc > 0 Then
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
	Return
End If

// set thread group name
ls_group = "com." + as_package + "." + as_component

// set thread count
l_tm.SetThreadCount(ls_group, 1)

If ai_interval = 0 Then
	// component will run only once
	l_tm.SetRunInterval(ls_group, -1)
Else
	// component will run once every x seconds
	l_tm.SetRunInterval(ls_group, ai_interval)
End If

// start the component
l_tm.Start(ls_group, l_gs)

end subroutine

public subroutine wf_stop (string as_package, string as_component);ThreadManager l_tm
String ls_errmsg, ls_group
Long ll_rc

// create local instance of Thread Manager
ll_rc = gn_jag.CreateInstance(l_tm, "CtsComponents/ThreadManager")
If ll_rc > 0 Then
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
	Return
End If

// set thread group name
ls_group = "com." + as_package + "." + as_component

// stop the component
l_tm.Stop(ls_group)

end subroutine

public subroutine wf_resume (string as_package, string as_component);ThreadManager l_tm
String ls_errmsg, ls_group
Long ll_rc

// create local instance of Thread Manager
ll_rc = gn_jag.CreateInstance(l_tm, "CtsComponents/ThreadManager")
If ll_rc > 0 Then
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
	Return
End If

// set thread group name
ls_group = "com." + as_package + "." + as_component

// resume the component
l_tm.Resume(ls_group)

end subroutine

public subroutine wf_suspend (string as_package, string as_component);ThreadManager l_tm
String ls_errmsg, ls_group
Long ll_rc

// create local instance of Thread Manager
ll_rc = gn_jag.CreateInstance(l_tm, "CtsComponents/ThreadManager")
If ll_rc > 0 Then
	ls_errmsg = gn_jag.of_errmsg(ll_rc)
	MessageBox("Jaguar Error", ls_errmsg)
	Return
End If

// set thread group name
ls_group = "com." + as_package + "." + as_component

// suspend the component
l_tm.Suspend(ls_group)

end subroutine

on w_main.create
this.em_interval=create em_interval
this.st_3=create st_3
this.rb_start=create rb_start
this.rb_resume=create rb_resume
this.rb_suspend=create rb_suspend
this.rb_stop=create rb_stop
this.cb_process=create cb_process
this.sle_component=create sle_component
this.sle_package=create sle_package
this.st_2=create st_2
this.st_1=create st_1
this.cb_cancel=create cb_cancel
this.Control[]={this.em_interval,&
this.st_3,&
this.rb_start,&
this.rb_resume,&
this.rb_suspend,&
this.rb_stop,&
this.cb_process,&
this.sle_component,&
this.sle_package,&
this.st_2,&
this.st_1,&
this.cb_cancel}
end on

on w_main.destroy
destroy(this.em_interval)
destroy(this.st_3)
destroy(this.rb_start)
destroy(this.rb_resume)
destroy(this.rb_suspend)
destroy(this.rb_stop)
destroy(this.cb_process)
destroy(this.sle_component)
destroy(this.sle_package)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.cb_cancel)
end on

event open;this.title = this.title + " - " + Message.StringParm

end event

type em_interval from editmask within w_main
integer x = 366
integer y = 312
integer width = 151
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "60"
borderstyle borderstyle = stylelowered!
string mask = "#####"
double increment = 1
string minmax = "1~~10000"
end type

type st_3 from statictext within w_main
integer x = 37
integer y = 324
integer width = 329
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Interval:"
boolean focusrectangle = false
end type

type rb_start from radiobutton within w_main
integer x = 37
integer y = 452
integer width = 626
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Start component"
boolean checked = true
end type

type rb_resume from radiobutton within w_main
integer x = 37
integer y = 740
integer width = 626
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Resume component"
end type

type rb_suspend from radiobutton within w_main
integer x = 37
integer y = 644
integer width = 626
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Suspend component"
end type

type rb_stop from radiobutton within w_main
integer x = 37
integer y = 548
integer width = 626
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Stop component"
end type

type cb_process from commandbutton within w_main
integer x = 1097
integer y = 448
integer width = 334
integer height = 100
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Process"
end type

event clicked;String ls_package, ls_component
Integer li_interval

SetPointer(HourGlass!)

ls_package = sle_package.text
If ls_package = "" Then
	MessageBox("Edit Error", "Package is required!", StopSign!)
	sle_package.SetFocus()
	Return
End If

ls_component = sle_component.text
If ls_component = "" Then
	MessageBox("Edit Error", "Component is required!", StopSign!)
	sle_component.SetFocus()
	Return
End If

If rb_start.checked Then
	li_interval = Integer(em_interval.text)
	wf_start(ls_package, ls_component, li_interval)
Else
	If rb_stop.checked Then
		wf_stop(ls_package, ls_component)
	Else
		If rb_suspend.checked Then
			wf_suspend(ls_package, ls_component)
		Else
			If rb_resume.checked Then
				wf_resume(ls_package, ls_component)
			End If
		End If
	End If
End If

end event

type sle_component from singlelineedit within w_main
integer x = 366
integer y = 184
integer width = 1065
integer height = 84
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

type sle_package from singlelineedit within w_main
integer x = 366
integer y = 56
integer width = 1065
integer height = 84
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

type st_2 from statictext within w_main
integer x = 37
integer y = 196
integer width = 329
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Component:"
boolean focusrectangle = false
end type

type st_1 from statictext within w_main
integer x = 37
integer y = 68
integer width = 256
integer height = 60
integer textsize = -8
integer weight = 700
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Package:"
boolean focusrectangle = false
end type

type cb_cancel from commandbutton within w_main
integer x = 1097
integer y = 704
integer width = 334
integer height = 100
integer taborder = 40
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

