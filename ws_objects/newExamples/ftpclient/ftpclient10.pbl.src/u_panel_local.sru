$PBExportHeader$u_panel_local.sru
forward
global type u_panel_local from u_panel
end type
type st_local_split from u_splitbar_horizontal within u_panel_local
end type
type lv_files from u_listview within u_panel_local
end type
type tv_drives from u_treeview within u_panel_local
end type
end forward

global type u_panel_local from u_panel
st_local_split st_local_split
lv_files lv_files
tv_drives tv_drives
end type
global u_panel_local u_panel_local

type variables
Datastore ids_sorter
Long il_handle
Long il_myfolders
Long il_mydocuments
Long il_cdrive
String is_path
String is_data[]

end variables

forward prototypes
public subroutine of_populate_listview (long al_handle)
public subroutine of_menufunction (string as_command)
public subroutine of_deletefiles ()
public subroutine of_uploadfiles (boolean ab_delete)
public function boolean of_gotodirectory (string as_directory)
end prototypes

public subroutine of_populate_listview (long al_handle);n_filesys ln_fsys
TreeViewItem ltvi_item
ListViewItem llvi_item
Integer li_cnt, li_max, li_item
Long ll_unknown, ll_folder, ll_parent, ll_sorttype, ll_filesize
Long ll_row, ll_max, ll_large, ll_small, ll_index
String ls_name[], ls_fullname, ls_filename
String ls_filetype, ls_extn, ls_prevextn
DateTime ldt_write[], ldt_modified
Boolean lb_subdir[]
Double ld_size[]

il_handle = al_handle
tv_drives.GetItem(al_handle, ltvi_item)
is_path = ltvi_item.Data
If is_path = "" Then Return

SetPointer(HourGlass!)

// destroy and create new image list
lv_files.of_DestroyImageLists()
lv_files.of_CreateSmallImageList()

// add shell icons
ll_unknown = lv_files.of_ImportSmallIcon("shell32.dll", 1)		// Unknown
ll_folder  = lv_files.of_ImportSmallIcon("shell32.dll", 4)		// Folder
ll_parent  = lv_files.of_ImportSmallIcon("shell32.dll", 147)	// Parent Folder

// get the list of files
li_max = ln_fsys.of_GetFiles(is_path, False, ls_name, &
					ld_size, ldt_write, lb_subdir)
If li_max = -1 Then
	MessageBox("Local Files", &
		"There is no disk in drive " + is_path, Exclamation!)
Else
	// load files & directories into datawindow for sorting
	ids_sorter.Reset()
	For li_cnt = 1 To li_max
		If lb_subdir[li_cnt] Then
			ll_sorttype = 0
			ll_filesize = 0
		Else
			ll_sorttype = 1
			ll_filesize = ld_size[li_cnt]
			If ll_filesize > 0 Then
				ll_filesize = (ll_filesize + 1024) / 1024
			End If
		End If
		ls_fullname = is_path + "\" + ls_name[li_cnt]
		ls_filename = ls_name[li_cnt]
		ls_filetype = lv_files.of_GetFileDescription(ls_fullname)
		ldt_modified = ldt_write[li_cnt]
		ll_row = ids_sorter.InsertRow(0)
		ids_sorter.SetItem(ll_row, "sorttype", ll_sorttype)
		ids_sorter.SetItem(ll_row, "fullname", ls_fullname)
		ids_sorter.SetItem(ll_row, "filename", ls_filename)
		ids_sorter.SetItem(ll_row, "filesize", ll_filesize)
		ids_sorter.SetItem(ll_row, "filetype", ls_filetype)
		ids_sorter.SetItem(ll_row, "modified", ldt_modified)
	Next
	ids_sorter.Sort()

	lv_files.SetRedraw(False)
	lv_files.DeleteItems()

	// add parent folder item
	llvi_item.Data = ""
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
			ls_fullname  = ids_sorter.GetItemString(ll_row, "fullname")
			ls_filename  = ids_sorter.GetItemString(ll_row, "filename")
			ldt_modified = ids_sorter.GetItemDateTime(ll_row, "modified")
			// add directory item
			llvi_item.Data = ls_fullname
			llvi_item.Label = ls_filename
			llvi_item.PictureIndex = ll_folder
			li_item = lv_files.AddItem(llvi_item)
			// fill in additional columns
			lv_files.SetItem(li_item, 2, String(ldt_modified, "[shortdate] h:mm AM/PM"))
			lv_files.SetItem(li_item, 3, "File Folder")
			lv_files.SetItem(li_item, 4, "")
		Else
			// file
			ls_fullname  = ids_sorter.GetItemString(ll_row, "fullname")
			ls_filename  = ids_sorter.GetItemString(ll_row, "filename")
			ldt_modified = ids_sorter.GetItemDateTime(ll_row, "modified")
			ll_filesize  = ids_sorter.GetItemNumber(ll_row, "filesize")
			ls_filetype  = ids_sorter.GetItemString(ll_row, "filetype")
			// load associated icon
			ls_extn = Mid(ls_filename, Pos(ls_filename, "."))
			If Lower(ls_extn) = ".ico" Then
				// add associated icon
				If lv_files.of_ImportAssociatedIcon(ls_fullname, &
										ll_large, ll_small) Then
					ll_index = ll_small
				Else
					ll_index = ll_unknown
				End If
			Else
				If ls_extn <> ls_prevextn Then
					ls_prevextn = ls_extn
					// add associated icon
					If lv_files.of_ImportAssociatedIcon(ls_fullname, &
											ll_large, ll_small) Then
						ll_index = ll_small
					Else
						ll_index = ll_unknown
					End If
				End If
			End If
			// add file item
			llvi_item.Data = ls_fullname
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
End If

SetPointer(Arrow!)

end subroutine

public subroutine of_menufunction (string as_command);// menu commands

choose case as_command
	case "m_uploadfiles"
		of_uploadfiles(False)
	case "m_uploaddeletefiles"
		of_uploadfiles(True)
	case "m_refreshlocal"
		of_Populate_Listview(il_handle)
	case "m_gotodirectory"
		// show pre-defined directory in ListView
		OpenWithParm(w_gotodir, is_path)
		If DirectoryExists(Message.StringParm) Then
			of_GotoDirectory(Message.StringParm)
		End If
	case "m_deletelocalfiles"
		of_deletefiles()
	case "m_mydocuments"
		// select My Documents
		tv_drives.ExpandItem(il_mydocuments)
		tv_drives.SelectItem(il_mydocuments)
		tv_drives.SetFocus()
	case "m_cdrive"
		// select C Drive Root
		tv_drives.ExpandItem(il_cdrive)
		tv_drives.SelectItem(il_cdrive)
		tv_drives.SetFocus()
end choose

end subroutine

public subroutine of_deletefiles ();// delete selected files

ListViewItem llvi_item
Integer li_idx, li_max, li_rc
String ls_localfile

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
				ls_localfile = String(llvi_item.Data)
				FileDelete(ls_localfile)
		end choose
	End If
Next

of_Populate_Listview(il_handle)

end subroutine

public subroutine of_uploadfiles (boolean ab_delete);// upload selected files

m_main lm_menu
ListViewItem llvi_item
Integer li_idx, li_max, li_rc
String ls_localfile, ls_remotefile

// get local reference to the menu
lm_menu = gw_frame.MenuID

If ab_delete Then
	li_rc = MessageBox("Upload Files", &
				"Are you sure you want to upload the selected files and then delete them?", &
				Question!, YesNo!)
Else
	li_rc = MessageBox("Upload Files", &
				"Are you sure you want to upload the selected files?", &
				Question!, YesNo!)
End if
If li_rc = 2 Then Return

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
				ls_localfile  = String(llvi_item.Data)
				ls_remotefile = llvi_item.Label
				gw_frame.wf_addmsg("Uploading " + ls_remotefile + "...")
				If Not gn_ftp.of_Ftp_WriteFile(ls_localfile, &
								ls_remotefile, Handle(gw_frame), 1025) Then
					gw_frame.wf_addmsg(gn_ftp.LastErrorMsg)
					MessageBox("WriteFile Error " + String(gn_ftp.LastErrorNbr), &
									gn_ftp.LastErrorMsg, StopSign!)
					Return
				End If
				llvi_item.Selected = False
				lv_files.SetItem(li_idx, llvi_item)
				gw_frame.wf_addmsg("Upload complete")
				If ab_delete Then
					FileDelete(ls_localfile)
				End If
		end choose
	End If
Next

lm_menu.mf_StopAction(False)

If ab_delete Then
	of_Populate_Listview(il_handle)
End If

gw_frame.uo_remote.of_Populate_Listview()

end subroutine

public function boolean of_gotodirectory (string as_directory);// goto a directory in the treeview and then show it in the listview

String ls_part[], ls_path
Long ll_idx, ll_max, ll_idxp, ll_maxp, ll_handle

ll_max = gn_app.of_Parse(as_directory, "\", ls_part)

For ll_idx = 1 To ll_max
	If ll_idx = 1 Then
		ls_path = ls_part[ll_idx]
	Else
		ls_path = ls_path + "\" + ls_part[ll_idx]
	End If
	ll_maxp = UpperBound(is_data)
	For ll_idxp = 1 To ll_maxp
		If Lower(is_data[ll_idxp]) = Lower(ls_path) Then
			ll_handle = ll_idxp
			// select treeview handle
			tv_drives.ExpandItem(ll_handle)
			Exit
		End If
	Next
Next

If ll_handle = 0 Then
	Return False
End If

tv_drives.SelectItem(ll_handle)
tv_drives.SetFocus()

is_path = ls_path
of_Populate_Listview(ll_handle)

Return True

end function

on u_panel_local.create
int iCurrent
call super::create
this.st_local_split=create st_local_split
this.lv_files=create lv_files
this.tv_drives=create tv_drives
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.st_local_split
this.Control[iCurrent+2]=this.lv_files
this.Control[iCurrent+3]=this.tv_drives
end on

on u_panel_local.destroy
call super::destroy
destroy(this.st_local_split)
destroy(this.lv_files)
destroy(this.tv_drives)
end on

event constructor;call super::constructor;// create sorter datastore
ids_sorter = Create Datastore
ids_sorter.DataObject = "d_filesorter"

end event

event ue_postopen;call super::ue_postopen;Environment le_env
n_filesys ln_fsys
TreeViewItem ltvi_item
Integer li_cnt, li_max, li_type[]
Long ll_parent, ll_item
String ls_drive[], ls_label[], ls_regkey, ls_value

SetPointer(HourGlass!)

GetEnvironment(le_env)

// destroy and create new image list
tv_drives.of_DestroyImageList()
tv_drives.of_CreateImageList()

// add shell icons
tv_drives.of_ImportIcon("shell32.dll", 16)		// 1  - MyComputer
tv_drives.of_ImportIcon("shell32.dll", 7)			// 2  - Floppy
tv_drives.of_ImportIcon("shell32.dll", 9)			// 3  - LocalDrive
tv_drives.of_ImportIcon("shell32.dll", 10)		// 4  - NetDrive
tv_drives.of_ImportIcon("shell32.dll", 12)		// 5  - CD-ROM
tv_drives.of_ImportIcon("shell32.dll", 4)			// 6  - Folder
tv_drives.of_ImportIcon("shell32.dll", 5)			// 7  - FolderOpen
If le_env.OSMajorRevision < 6 Then
	tv_drives.of_ImportIcon("shell32.dll", 127)		// 8  - My Documents
	tv_drives.of_ImportIcon("shell32.dll", 43)		// 9  - My Folders
	tv_drives.of_ImportIcon("shell32.dll", 16)		// 10 - Desktop
	tv_drives.of_ImportIcon("shell32.dll", 127)		// 11 - Documents
	tv_drives.of_ImportIcon("shell32.dll", 4)			// 12 - Downloads
	tv_drives.of_ImportIcon("shell32.dll", 129)		// 13 - Music
	tv_drives.of_ImportIcon("shell32.dll", 128)		// 14 - Pictures
	tv_drives.of_ImportIcon("shell32.dll", 130)		// 15 - Videos
	tv_drives.of_ImportIcon("shell32.dll", 4)			// 16 - Profile
Else
	tv_drives.of_ImportIcon("imageres.dll", 108)		// 8  - My Documents
	tv_drives.of_ImportIcon("imageres.dll", 203)		// 9  - My Folders
	tv_drives.of_ImportIcon("imageres.dll", 106)		// 10 - Desktop
	tv_drives.of_ImportIcon("imageres.dll", 189)		// 11 - Documents
	tv_drives.of_ImportIcon("imageres.dll", 176)		// 12 - Downloads
	tv_drives.of_ImportIcon("imageres.dll", 191)		// 13 - Music
	tv_drives.of_ImportIcon("imageres.dll", 190)		// 14 - Pictures
	tv_drives.of_ImportIcon("imageres.dll", 192)		// 15 - Videos
	tv_drives.of_ImportIcon("imageres.dll", 118)		// 16 - Profile
End If

// register objects with horizontal splitbar
st_local_split.of_set_topobject(tv_drives)
st_local_split.of_set_bottomobject(lv_files)
st_local_split.of_set_minsize(500, 500)
st_local_split.of_set_livesizing(False)
st_local_split.of_get_location()

// Insert My Folders
ltvi_item.Expanded = False
ltvi_item.Data = "My Folders"
ltvi_item.Label = "My Folders"
ltvi_item.PictureIndex = 9
ltvi_item.SelectedPictureIndex = 9
ltvi_item.Children = True
il_myfolders = tv_drives.InsertItemLast(0, ltvi_item)

// Insert My Documents
ltvi_item.Expanded = False
ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYDOCUMENTS)
ltvi_item.Label = "My Documents"
ltvi_item.PictureIndex = 8
ltvi_item.SelectedPictureIndex = 8
ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
il_mydocuments = tv_drives.InsertItemLast(0, ltvi_item)

// Insert My Computer
ltvi_item.Expanded = True
ltvi_item.Data = ""
ltvi_item.Label = "My Computer"
ltvi_item.PictureIndex = 1
ltvi_item.SelectedPictureIndex = 1
ll_parent = tv_drives.InsertItemLast(0, ltvi_item)

// add drives to My Computer
li_max = ln_fsys.of_GetDrives(ls_drive, li_type, ls_label)
For li_cnt = 1 To li_max
	If li_type[li_cnt] = ln_fsys.DRIVE_REMOVABLE Then
		// no floppy drives
	Else
		// define the item
		ltvi_item.Expanded = False
		ltvi_item.Data = ls_drive[li_cnt] + ":"
		ltvi_item.Label = ls_label[li_cnt] + " (" + ltvi_item.Data + ")"
		ltvi_item.PictureIndex = li_type[li_cnt]
		ltvi_item.SelectedPictureIndex = li_type[li_cnt]
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(ll_parent, ltvi_item)
		is_data[ll_item] = ltvi_item.Data
		If ls_drive[li_cnt] = "C" Then
			il_cdrive = ll_item
		End If
	End If
Next

// get startup directory
ls_regkey = "HKEY_CURRENT_USER\Software\" + &
					gn_app.is_company + "\Ftpclient"
RegistryGet(ls_regkey, "Startup", RegString!, ls_value)

If ls_value = "" Then
	// select My Documents
	tv_drives.ExpandItem(il_mydocuments)
	tv_drives.SelectItem(il_mydocuments)
	tv_drives.SetFocus()
Else
	If Not of_GotoDirectory(ls_value) Then
		// select My Documents
		tv_drives.ExpandItem(il_mydocuments)
		tv_drives.SelectItem(il_mydocuments)
		tv_drives.SetFocus()
	End If
End If

end event

event resize;call super::resize;tv_drives.Width = this.Width
lv_files.Width = this.Width
st_local_split.Width = this.Width

lv_files.Height = this.Height - lv_files.Y

end event

event ue_preclose;call super::ue_preclose;st_local_split.of_set_location()

end event

type st_local_split from u_splitbar_horizontal within u_panel_local
integer y = 704
integer width = 1870
end type

type lv_files from u_listview within u_panel_local
integer y = 724
integer width = 1870
integer height = 720
integer taborder = 20
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
TreeViewItem ltvi_item
ListViewItem llvi_item
String ls_filename
Long ll_handle

this.GetItem(index, llvi_item)
ls_filename = String(llvi_item.Data)

choose case llvi_item.PictureIndex
	case 2
		// double clicked on a folder, find it in the treeview
		tv_drives.ExpandItem(il_handle)
		ll_handle = tv_drives.FindItem(ChildTreeItem!, il_handle)
		do while ll_handle > 0
			tv_drives.GetItem(ll_handle, ltvi_item)
			If ls_filename = String(ltvi_item.Data) Then
				tv_drives.SelectItem(ll_handle)
				tv_drives.SetFocus()
				Return
			End If
			ll_handle = tv_drives.FindItem(NextTreeItem!, ll_handle)
		loop
	case 3
		// double clicked on Parent Folder
		il_handle = tv_drives.FindItem(ParentTreeItem!, il_handle)
		tv_drives.SelectItem(il_handle)
		tv_drives.SetFocus()
		Return
	case else
		// double clicked on a file
		ln_rwait.of_set_options(False, 1)
		ln_rwait.of_ShellRun(ls_filename, "Open", Normal!)
end choose

end event

type tv_drives from u_treeview within u_panel_local
integer width = 1870
integer height = 704
integer taborder = 10
integer textsize = -8
string facename = "Tahoma"
boolean linesatroot = true
boolean trackselect = true
end type

event itempopulate;n_filesys ln_fsys
TreeViewItem ltvi_item
String ls_path, ls_name[], ls_regkey, ls_value
DateTime ldt_write[]
Boolean lb_subdir[]
Double ld_size[]
Integer li_cnt, li_max
Long ll_item

this.GetItem(handle, ltvi_item)
ls_path = ltvi_item.Data

choose case ls_path
	case "My Folders"
		// Insert Desktop
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_DESKTOP)
		ltvi_item.Label = "Desktop"
		ltvi_item.PictureIndex = 10
		ltvi_item.SelectedPictureIndex = 10
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data

		// Insert Documents
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYDOCUMENTS)
		ltvi_item.Label = "Documents"
		ltvi_item.PictureIndex = 11
		ltvi_item.SelectedPictureIndex = 11
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data

		// get Downloads location
		ls_regkey = "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
		RegistryGet(ls_regkey, "{374DE290-123F-4565-9164-39C4925E467B}", RegString!, ls_value)
		If ls_value <> "" Then
			// Insert Downloads
			ltvi_item.Expanded = False
			ltvi_item.Data = ls_value
			ltvi_item.Label = "Downloads"
			ltvi_item.PictureIndex = 12
			ltvi_item.SelectedPictureIndex = 12
			ltvi_item.Selected = False
			ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
			// insert the item
			ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
			is_data[ll_item] = ltvi_item.Data
		End If

		// Insert Music
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYMUSIC)
		ltvi_item.Label = "Music"
		ltvi_item.PictureIndex = 13
		ltvi_item.SelectedPictureIndex = 13
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data

		// Insert Pictures
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYPICTURES)
		ltvi_item.Label = "Pictures"
		ltvi_item.PictureIndex = 14
		ltvi_item.SelectedPictureIndex = 14
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data

		// Insert Videos
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYVIDEO)
		ltvi_item.Label = "Videos"
		ltvi_item.PictureIndex = 15
		ltvi_item.SelectedPictureIndex = 15
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data

		// Insert Profile
		ltvi_item.Expanded = False
		ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_PROFILE)
		ltvi_item.Label = "Profile"
		ltvi_item.PictureIndex = 16
		ltvi_item.SelectedPictureIndex = 16
		ltvi_item.Selected = False
		ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
		// insert the item
		ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
		is_data[ll_item] = ltvi_item.Data
	case else
		li_max = ln_fsys.of_GetFiles(ls_path, False, ls_name, &
							ld_size, ldt_write, lb_subdir)
		For li_cnt = 1 To li_max
			If lb_subdir[li_cnt] Then
				// define the item
				ltvi_item.Expanded = False
				ltvi_item.Data = ls_path + "\" + ls_name[li_cnt]
				ltvi_item.Label = ls_name[li_cnt]
				ltvi_item.PictureIndex = 6
				ltvi_item.SelectedPictureIndex = 7
				ltvi_item.Selected = False
				ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
				// insert the item
				ll_item = tv_drives.InsertItemLast(handle, ltvi_item)
				is_data[ll_item] = ltvi_item.Data
			End if
		Next
end choose

end event

event selectionchanged;choose case newhandle
	case il_myfolders
		// do nothing
	case else
		// populate the listview
		of_populate_listview(newhandle)
end choose

// expand this item in the tree
this.ExpandItem(newhandle)

end event

