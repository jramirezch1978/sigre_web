$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type tab_main from u_tab_main within w_main
end type
type tab_main from u_tab_main within w_main
end type
type str_point from structure within w_main
end type
type str_minmaxinfo from structure within w_main
end type
end forward

type str_point from structure
	long		lx
	long		ly
end type

type str_minmaxinfo from structure
	str_point		ptreserved
	str_point		ptmaxsize
	str_point		ptmaxposition
	str_point		ptmintracksize
	str_point		ptmaxtracksize
end type

global type w_main from window
integer width = 4576
integer height = 2808
boolean titlebar = true
string title = "WebBrowser Designer"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event getminmaxinfo pbm_getminmaxinfo
event m_new ( )
event m_open ( )
event m_save ( )
event m_saveas ( )
mdi_1 mdi_1
tab_main tab_main
end type
global w_main w_main

type prototypes
Subroutine GetMinMaxInfo ( &
	Ref str_minmaxinfo d, &
	long s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine SetMinMaxInfo ( &
	long d, &
	str_minmaxinfo s, &
	long l &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

end prototypes

type variables
String is_wintitle
String is_filename

end variables

forward prototypes
public subroutine wf_triggerevent (string as_eventname)
end prototypes

event getminmaxinfo;str_minmaxinfo lstr_minmaxinfo
Environment le_env

GetEnvironment(le_env)

// copy the data to local structure
GetMinMaxInfo(lstr_minmaxinfo, minmaxinfo, 40)

// set the minimum size for our window
lstr_minmaxinfo.ptMinTrackSize.lx = 550
lstr_minmaxinfo.ptMinTrackSize.ly = 400

// set the maximum size for our window
//lstr_minmaxinfo.ptMaxTrackSize.lx = le_env.ScreenWidth * .9
//lstr_minmaxinfo.ptMaxTrackSize.ly = le_env.ScreenHeight * .9

// copy the structure back into memory
SetMinMaxInfo(minmaxinfo, lstr_minmaxinfo, 40)

// important: must return 0
Return 0

end event

event m_new();// new

u_tabpg_design lu_design

is_filename = ""
this.title = is_wintitle

lu_design = tab_main.of_GetDesign()

lu_design.ole_browser.of_SetSource("")

end event

event m_open();// open

u_tabpg_design lu_design
Integer li_rc
String ls_pathname, ls_filename, ls_source

li_rc = GetFileOpenName("Open HTML Document", &
					ls_pathname, ls_filename, "html", &
					"HTML Documents (*.html),*.html")
If li_rc = 1 Then
	is_filename = ls_pathname
	this.title = is_wintitle + " - " + ls_filename
	lu_design = tab_main.of_GetDesign()
	lu_design.ole_browser.of_ReadFile(is_filename, ls_source)
	lu_design.ole_browser.of_SetSource(ls_source)
End If

end event

event m_save();// save

u_tabpg_design lu_design
String ls_source, ls_header

SetPointer(HourGlass!)

// get the file name
If is_filename = "" Then
	this.Event m_saveas()
	Return
End If

// get the source from the browser
lu_design = tab_main.of_GetDesign()
ls_source = lu_design.ole_browser.of_GetSource()

ls_header = "<HTML>"

// write the file to disk
lu_design.ole_browser.of_WriteFile(is_filename, &
					ls_header + ls_source + "</HTML>")

end event

event m_saveas();// saveas

Integer li_rc
String ls_pathname, ls_filename

li_rc = GetFileSaveName("Save HTML Document", &
					ls_pathname, ls_filename, "html", &
					"HTML Documents (*.html),*.html")
If li_rc = 1 Then
	is_filename = ls_pathname
	this.title = is_wintitle + " - " + ls_filename
	this.Event m_save()
End If

end event

public subroutine wf_triggerevent (string as_eventname);tab_main.of_TriggerEvent(as_eventname)

end subroutine

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.tab_main=create tab_main
this.Control[]={this.mdi_1,&
this.tab_main}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.tab_main)
end on

event resize;tab_main.Width  = this.WorkSpaceWidth()  - 75
tab_main.Height = this.WorkSpaceHeight() - 125

end event

event open;is_wintitle = this.title

tab_main.Event Open()

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

type tab_main from u_tab_main within w_main
integer x = 37
integer y = 128
integer taborder = 20
end type

