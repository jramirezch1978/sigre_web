$PBExportHeader$u_panel_remote.sru
forward
global type u_panel_remote from u_panel
end type
type lv_files from u_listview within u_panel_remote
end type
end forward

global type u_panel_remote from u_panel
lv_files lv_files
end type
global u_panel_remote u_panel_remote

type variables
Datastore ids_sorter

end variables

forward prototypes
public subroutine of_populate_listview ()
public subroutine of_menufunction (string as_command)
public subroutine of_deletefiles ()
public subroutine of_downloadfiles (boolean ab_prompt)
public subroutine of_deletedirectories ()
public function boolean of_connect (integer ai_profile)
public subroutine of_disconnect ()
end prototypes

public subroutine of_populate_listview ();// initialize panel when connected

s_ftpdirlist lstr_dirlist[]
ListViewItem llvi_item
Long ll_large, ll_small, ll_unknown, ll_folder, ll_parent
Long ll_index, ll_sorttype, ll_filesize, ll_row, ll_max
Integer li_idx, li_max, li_item
String ls_filename, ls_filetype
String ls_extn, ls_prevextn, ls_current
DateTime ldt_modified

SetPointer(HourGlass!)

// destroy and create new image list
lv_files.of_DestroyImageLists()
lv_files.of_CreateSmallImageList()

// add shell icons
ll_unknown = lv_files.of_ImportSmallIcon("shell32.dll", 1)		// Unknown
ll_folder  = lv_files.of_ImportSmallIcon("shell32.dll", 4)		// Folder
ll_parent  = lv_files.of_ImportSmallIcon("shell32.dll", 147)	// Parent Folder

// get the current directory
gn_ftp.of_Ftp_GetCurrentDirectory(ls_current)

gw_frame.wf_addmsg("Get directory list for " + ls_current + "...")

// get file list
li_max = gn_ftp.of_Ftp_Directory(lstr_dirlist)

// load files & directories into datawindow for sorting
ids_sorter.Reset()
For li_idx = 1 To li_max
	If lstr_dirlist[li_idx].b_subdir Then
		ll_sorttype = 0
		ll_filesize = 0
	Else
		ll_sorttype = 1
		ll_filesize = lstr_dirlist[li_idx].db_filesize
		If ll_filesize > 0 Then
			ll_filesize = (ll_filesize + 1024) / 1024
		End If
	End If
	ls_filename = lstr_dirlist[li_idx].s_filename
	ls_filetype = lv_files.of_GetFileDescription(ls_filename)
	ldt_modified = lstr_dirlist[li_idx].dt_lastwritetime
	ll_row = ids_sorter.InsertRow(0)
	ids_sorter.SetItem(ll_row, "sorttype", ll_sorttype)
	ids_sorter.SetItem(ll_row, "filename", ls_filename)
	ids_sorter.SetItem(ll_row, "filesize", ll_filesize)
	ids_sorter.SetItem(ll_row, "filetype", ls_filetype)
	ids_sorter.SetItem(ll_row, "modified", ldt_modified)
Next
ids_sorter.Sort()

lv_files.SetRedraw(False)
lv_files.DeleteItems()

// add parent folder item
llvi_item.Data = ls_current
llvi_item.Label = "Parent Folder"
llvi_item.PictureIndex = ll_parent
li_item = lv_files.AddItem(llvi_item)
// fill in additional columns
lv_files.SetItem(li_item, 3, "File Folder")

// copy datawindow to listview
ll_max = ids_sorter.RowCount()
For ll_row = 1 To ll_max
	ll_sorttype = ids_sorter.GetItemNumber(ll_row, "sorttype")
	If ll_sorttype = 0 Then
		// directory
		ls_filename  = ids_sorter.GetItemString(ll_row, "filename")
		ldt_modified = ids_sorter.GetItemDateTime(ll_row, "modified")
		// add directory item
		llvi_item.Data = ls_current
		llvi_item.Label = ls_filename
		llvi_item.PictureIndex = ll_folder
		li_item = lv_files.AddItem(llvi_item)
		// fill in additional columns
		lv_files.SetItem(li_item, 2, String(ldt_modified, "[shortdate] h:mm AM/PM"))
		lv_files.SetItem(li_item, 3, "File Folder")
		lv_files.SetItem(li_item, 4, "")
	Else
		// file
		ls_filename  = ids_sorter.GetItemString(ll_row, "filename")
		ldt_modified = ids_sorter.GetItemDateTime(ll_row, "modified")
		ll_filesize  = ids_sorter.GetItemNumber(ll_row, "filesize")
		ls_filetype  = ids_sorter.GetItemString(ll_row, "filetype")
		ls_extn = Mid(ls_filename, Pos(ls_filename, "."))
		// load associated icon
		ls_extn = Mid(ls_filename, Pos(ls_filename, "."))
		If ls_extn <> ls_prevextn Then
			ls_prevextn = ls_extn
			// add associated icon
			If lv_files.of_ImportAssociatedIcon(ls_filename, &
									ll_large, ll_small) Then
				ll_index = ll_small
			Else
				ll_index = ll_unknown
			End If
		End If
		// add file item
		llvi_item.Data = ls_current
		llvi_item.Label = ls_filename
		llvi_item.PictureIndex = ll_index
		li_item = lv_files.AddItem(llvi_item)
		// fill in additional columns
		lv_files.SetItem(li_item, 2, String(ldt_modified, "[shortdate] h:mm AM/PM"))
		lv_files.SetItem(li_item, 3, ls_filetype)
		lv_files.SetItem(li_item, 4, String(ll_filesize, "#,##0") + " KB")
	End If
Next

lv_files.SetRedraw(True)

gw_frame.wf_addmsg("Number of files: " + String(ll_max))

SetPointer(Arrow!)

end subroutine

public subroutine of_menufunction (string as_command);// menu commands

SetPointer(HourGlass!)

choose case as_command
	case "m_downloadfiles"
		of_downloadfiles(False)
	case "m_refresh"
		of_Populate_Listview()
	case "m_changedirectory"
		Open(w_changedir)
		If Message.StringParm = "cb_ok" Then
			of_Populate_Listview()
		End If
	case "m_deletefiles"
		of_deletefiles()
	case "m_home"
		gw_frame.wf_addmsg("Change current directory: \")
		If Not gn_ftp.of_ftp_SetCurrentDirectory("\") Then
			gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
			MessageBox("SetCurrentDirectory Error " + String(gn_ftp.LastErrorNbr), &
							gn_ftp.LastErrorMsg, StopSign!)
			Return
		End If
		of_Populate_Listview()
	case "m_createdirectory"
		Open(w_createdir)
		If Message.StringParm = "cb_ok" Then
			of_Populate_Listview()
		End If
	case "m_deletedirectories"
		of_deletedirectories()
	case "m_sendcommand"
		Open(w_command)
end choose

end subroutine

public subroutine of_deletefiles ();// delete selected files

ListViewItem llvi_item
Integer li_idx, li_max, li_rc
String ls_remotefile

li_rc = MessageBox("Delete Files", &
			"Are you sure you want to delete the selected files?", &
			Question!, YesNo!)
If li_rc = 2 Then Return

// get selected files
li_max = lv_files.TotalItems()
For li_idx = 1 To li_max
	lv_files.GetItem(li_idx, llvi_item)
	If llvi_item.Selected Then
		choose case llvi_item.PictureIndex
			case 2, 3
				llvi_item.Selected = False
				lv_files.SetItem(li_idx, llvi_item)
			case else
				ls_remotefile = llvi_item.Label
				gw_frame.wf_addmsg("Deleting " + ls_remotefile + "...")
				If Not gn_ftp.of_Ftp_DeleteFile(ls_remotefile) Then
					gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
					MessageBox("Delete Error " + String(gn_ftp.LastErrorNbr), &
									gn_ftp.LastErrorMsg, StopSign!)
					Return
				End If
				gw_frame.wf_addmsg("Delete complete")
		end choose
	End If
Next

of_Populate_Listview()

end subroutine

public subroutine of_downloadfiles (boolean ab_prompt);// download selected files

m_main lm_menu
ListViewItem llvi_item
Integer li_idx, li_max, li_rc
String ls_localdir, ls_localfile, ls_remotefile

// get local reference to the menu
lm_menu = gw_frame.MenuID

li_rc = MessageBox("Download Files", &
			"Are you sure you want to download the selected files?", &
			Question!, YesNo!)
If li_rc = 2 Then Return

If ab_prompt Then
	li_rc = GetFolder("Choose Download Location", ls_localdir)
	If li_rc = 0 Then Return
Else
	ls_localdir = gw_frame.uo_local.is_path
End If

lm_menu.mf_StopAction(True)

gw_frame.ib_StopAction = False

// get selected files
li_max = lv_files.TotalItems()
For li_idx = 1 To li_max
	If gw_frame.ib_StopAction Then
		Exit
	End If
	lv_files.GetItem(li_idx, llvi_item)
	If llvi_item.Selected Then
		choose case llvi_item.PictureIndex
			case 2, 3
				llvi_item.Selected = False
				lv_files.SetItem(li_idx, llvi_item)
			case else
				ls_remotefile = llvi_item.Label
				ls_localfile = ls_localdir + "\" + llvi_item.Label
				gw_frame.wf_addmsg("Downloading " + ls_remotefile + "...")
				If Not gn_ftp.of_Ftp_ReadFile(ls_remotefile, &
								ls_localfile, Handle(gw_frame), 1024) Then
					gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
					MessageBox("ReadFile Error " + String(gn_ftp.LastErrorNbr), &
									gn_ftp.LastErrorMsg, StopSign!)
					Return
				End If
				llvi_item.Selected = False
				lv_files.SetItem(li_idx, llvi_item)
				gw_frame.wf_addmsg("Download complete")
		end choose
	End If
Next

lm_menu.mf_StopAction(False)

gw_frame.uo_local.of_Populate_Listview(gw_frame.uo_local.il_handle)

end subroutine

public subroutine of_deletedirectories ();// delete selected directories

ListViewItem llvi_item
Integer li_idx, li_max, li_rc
String ls_remotedir

li_rc = MessageBox("Delete Directories", &
			"Are you sure you want to delete the selected directories?", &
			Question!, YesNo!)
If li_rc = 2 Then Return

// get selected directories
li_max = lv_files.TotalItems()
For li_idx = 1 To li_max
	lv_files.GetItem(li_idx, llvi_item)
	If llvi_item.Selected Then
		choose case llvi_item.PictureIndex
			case 2
				ls_remotedir = llvi_item.Label
				gw_frame.wf_addmsg("Deleting " + ls_remotedir + "...")
				If Not gn_ftp.of_Ftp_RemoveDirectory(ls_remotedir) Then
					gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
					MessageBox("Delete Error " + String(gn_ftp.LastErrorNbr), &
									gn_ftp.LastErrorMsg, StopSign!)
					Return
				End If
				gw_frame.wf_addmsg("Delete complete")
			case else
				llvi_item.Selected = False
				lv_files.SetItem(li_idx, llvi_item)
		end choose
	End If
Next

of_Populate_Listview()

end subroutine

public function boolean of_connect (integer ai_profile);// connect to the ftp server

m_main lm_menu
String ls_subkey, ls_server, ls_userid, ls_password, ls_initialdir, ls_errmsg
Boolean lb_result, lb_passive, lb_anonymous
UInt lui_port

SetPointer(HourGlass!)

lm_menu = gw_frame.MenuID

ls_subkey = "Profiles\" + String(ai_profile)

ls_server		= gn_app.of_GetReg(ls_subkey, "Server", "")
ls_userid		= gn_app.of_GetReg(ls_subkey, "Userid", "")
ls_password		= gn_app.of_GetReg(ls_subkey, "Password", "")
ls_initialdir	= gn_app.of_GetReg(ls_subkey, "InitialDir", "")
lui_port			= Integer(gn_app.of_GetReg(ls_subkey, "Port", "21"))

If gn_app.of_GetReg(ls_subkey, "Anonymous", "false") = "true" Then
	lb_anonymous = True
Else
	lb_anonymous = False
End If

If gn_app.of_GetReg(ls_subkey, "Passive", "false") = "true" Then
	lb_passive = True
Else
	lb_passive = False
End If

// disconnect from current session
gw_frame.wf_addmsg("Disconnecting existing session")
SetPointer(HourGlass!)
gn_ftp.of_SessionClose()

// connect to remote server
gw_frame.wf_addmsg("Connecting to " + ls_server)
SetPointer(HourGlass!)
If lb_anonymous Then
	lb_result = gn_ftp.of_Ftp_InternetConnect(ls_server, &
						lui_port, lb_passive)
Else
	lb_result = gn_ftp.of_Ftp_InternetConnect(ls_server, &
						ls_userid, ls_password, &
						lui_port, lb_passive)
End If
If lb_result = False Then
	ls_errmsg = "Connect Error " + String(gn_ftp.LastErrorNbr)
	gw_frame.wf_addmsg(ls_errmsg + ": " + gn_ftp.LastErrorMsg)
	MessageBox(ls_errmsg, gn_ftp.LastErrorMsg, StopSign!)
	Return False
End If
gw_frame.wf_addmsg("Session connected")
SetPointer(HourGlass!)

// set the initial directory
If Len(ls_initialdir) > 0 Then
	gw_frame.wf_addmsg("Change current directory: " + ls_initialdir)
	If Not gn_ftp.of_ftp_SetCurrentDirectory(ls_initialdir) Then
		gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
		MessageBox("SetCurrentDirectory Error " + String(gn_ftp.LastErrorNbr), &
						gn_ftp.LastErrorMsg, StopSign!)
		Return False
	End If
End If

// enable ftp actions
lm_menu.mf_Status(True)

Return True

end function

public subroutine of_disconnect ();// disconnect from the ftp server

m_main lm_menu

SetPointer(HourGlass!)

lm_menu = gw_frame.MenuID

// disconnect from current session
gw_frame.wf_addmsg("Disconnecting existing session")
gn_ftp.of_SessionClose()
gw_frame.wf_addmsg("Session disconnected")

// disable ftp actions
lm_menu.mf_Status(False)

// delete items from listview
lv_files.DeleteItems()

end subroutine

on u_panel_remote.create
int iCurrent
call super::create
this.lv_files=create lv_files
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.lv_files
end on

on u_panel_remote.destroy
call super::destroy
destroy(this.lv_files)
end on

event resize;call super::resize;lv_files.Width = this.Width
lv_files.Height = this.Height

end event

event constructor;call super::constructor;// create sorter datastore
ids_sorter = Create Datastore
ids_sorter.DataObject = "d_filesorter"

end event

type lv_files from u_listview within u_panel_remote
integer width = 1870
integer height = 1220
integer taborder = 10
integer textsize = -8
string facename = "Tahoma"
boolean extendedselect = true
boolean hideselection = false
boolean fullrowselect = true
listviewview view = listviewreport!
long smallpicturemaskcolor = 12632256
end type

event constructor;call super::constructor;// add columns to report view
this.AddColumn("Name", Left!, 1250)
this.AddColumn("Date Modified", Left!, 550)
this.AddColumn("Type", Left!, 750)
this.AddColumn("Size", Right!, 350)

end event

event destructor;call super::destructor;this.of_DestroyImageLists()

end event

event doubleclicked;call super::doubleclicked;n_runandwait ln_rwait
n_filesys ln_fsys
ListViewItem llvi_item
String ls_current, ls_folder, ls_filename, ls_tempfile

this.GetItem(index, llvi_item)
ls_current = String(llvi_item.Data)
ls_folder  = llvi_item.Label

choose case llvi_item.PictureIndex
	case 2
		// double clicked on a folder
		gw_frame.wf_addmsg("Change current directory: " + ls_folder)
		If Not gn_ftp.of_ftp_SetCurrentDirectory(ls_folder) Then
			gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
			MessageBox("SetCurrentDirectory Error " + String(gn_ftp.LastErrorNbr), &
							gn_ftp.LastErrorMsg, StopSign!)
			Return
		End If
		of_Populate_Listview()
	case 3
		// double clicked on Parent Folder
		If ls_current = "/" Then
			// already at root directory
		Else
			ls_folder = Left(ls_current, LastPos(ls_current, "/") - 1)
			If ls_folder = "" Then
				ls_folder = "/"
			End If
			gw_frame.wf_addmsg("Change current directory: " + ls_folder)
			If Not gn_ftp.of_ftp_SetCurrentDirectory(ls_folder) Then
				gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
				MessageBox("SetCurrentDirectory Error " + String(gn_ftp.LastErrorNbr), &
								gn_ftp.LastErrorMsg, StopSign!)
				Return
			End If
			of_Populate_Listview()
		End If
	case else
		// double clicked on a file
		SetPointer(HourGlass!)
		ls_filename = llvi_item.Label
		ls_tempfile = ln_fsys.of_GetTempPath() + ls_filename
		If gn_ftp.of_Ftp_GetFile(ls_filename, ls_tempfile, False) Then
			SetPointer(Arrow!)
			ln_rwait.of_ShellRun(ls_tempfile, "Open", Normal!)
			FileDelete(ls_tempfile)
		Else
			gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
			MessageBox("GetFile Error " + String(gn_ftp.LastErrorNbr), &
							gn_ftp.LastErrorMsg, StopSign!)
			Return
		End If
end choose

end event

