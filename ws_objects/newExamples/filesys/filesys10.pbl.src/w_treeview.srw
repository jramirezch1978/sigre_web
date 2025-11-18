$PBExportHeader$w_treeview.srw
forward
global type w_treeview from window
end type
type lv_files from u_listview within w_treeview
end type
type st_splitbar from u_splitbar_vertical within w_treeview
end type
type cb_cancel from commandbutton within w_treeview
end type
type tv_drives from treeview within w_treeview
end type
end forward

global type w_treeview from window
integer width = 4439
integer height = 2708
boolean titlebar = true
string title = "File Explorer"
boolean controlmenu = true
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_postopen ( )
lv_files lv_files
st_splitbar st_splitbar
cb_cancel cb_cancel
tv_drives tv_drives
end type
global w_treeview w_treeview

type prototypes

end prototypes

type variables
Datastore ids_sorter
Long il_handle

end variables

forward prototypes
public subroutine wf_populate_listview (long al_handle)
end prototypes

event ue_postopen();n_filesys ln_fsys
String ls_image, ls_drive[], ls_label[]
Integer li_cnt, li_max, li_type[]
TreeViewItem ltvi_item
Long ll_MyDocuments, ll_MyComputer

SetPointer(HourGlass!)

// Insert My Documents
ltvi_item.Expanded = False
ltvi_item.Data = ln_fsys.of_GetFolderPath(ln_fsys.CSIDL_MYDOCUMENTS)
ltvi_item.Label = "My Documents"
ltvi_item.PictureIndex = 8
ltvi_item.SelectedPictureIndex = 8
ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
ll_MyDocuments = tv_drives.InsertItemLast(0, ltvi_item)

// Insert My Computer
ltvi_item.Expanded = True
ltvi_item.Data = ""
ltvi_item.Label = "My Computer"
ltvi_item.PictureIndex = 1
ltvi_item.SelectedPictureIndex = 1
ll_MyComputer = tv_drives.InsertItemLast(0, ltvi_item)

// add drives to My Computer
li_max = ln_fsys.of_GetDrives(ls_drive, li_type, ls_label)
For li_cnt = 1 To li_max
	// define the item
	ltvi_item.Expanded = False
	ltvi_item.Data = ls_drive[li_cnt] + ":"
	ltvi_item.Label = ls_label[li_cnt] + " (" + ltvi_item.Data + ")"
	ltvi_item.PictureIndex = li_type[li_cnt]
	ltvi_item.SelectedPictureIndex = li_type[li_cnt]
	ltvi_item.Children = ln_fsys.of_DirsExist(ltvi_item.Data, False)
	// insert the item
	tv_drives.InsertItemLast(ll_MyComputer, ltvi_item)
Next

// select My Documents
tv_drives.ExpandItem(ll_MyDocuments)
tv_drives.SelectItem(ll_MyDocuments)
tv_drives.SetFocus()

end event

public subroutine wf_populate_listview (long al_handle);n_filesys ln_fsys
TreeViewItem ltvi_item
ListViewItem llvi_item
String ls_path, ls_name[], ls_fullname, ls_filename
String ls_filetype, ls_prevextn, ls_extn
Integer li_cnt, li_max, li_item
DateTime ldt_write[], ldt_modified
Boolean lb_subdir[]
Double ld_size[]
Long ll_sorttype, ll_filesize, ll_row, ll_max
Long ll_index, ll_large, ll_small, ll_folder, ll_unknown

il_handle = al_handle

tv_drives.GetItem(al_handle, ltvi_item)
ls_path = ltvi_item.Data
If ls_path = "" Then Return

// destroy and create new image list
lv_files.of_DestroyImageLists()
lv_files.of_CreateSmallImageList()

// add shell icons
ll_unknown = lv_files.of_ImportSmallIcon("shell32.dll", 1)		// Unknown
ll_folder  = lv_files.of_ImportSmallIcon("shell32.dll", 4)		// Folder

// get the list of files
li_max = ln_fsys.of_getfiles(ls_path, False, ls_name, &
					ld_size, ldt_write, lb_subdir)
If li_max = -1 Then
	MessageBox(This.title, &
		"There is no disk in drive " + ls_path, Exclamation!)
Else
	// load files & directories into datawindow for sorting
	ids_sorter.Reset()
	For li_cnt = 1 To li_max
		If lb_subdir[li_cnt] Then
			ll_sorttype = 0
			ll_filesize = 0
		Else
			ll_sorttype = 1
			ll_filesize = (ld_size[li_cnt] + 512) / 1024
			If ld_size[li_cnt] > 0 And ll_filesize = 0 Then
				ll_filesize = 1
			End If
		End If
		ls_fullname = ls_path + "\" + ls_name[li_cnt]
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
	// copy datawindow to listview
	lv_files.SetRedraw(False)
	lv_files.DeleteItems()
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
			lv_files.SetItem(li_item, 2, "")
			lv_files.SetItem(li_item, 3, "File Folder")
			lv_files.SetItem(li_item, 4, String(ldt_modified))
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
			lv_files.SetItem(li_item, 2, "")
			lv_files.SetItem(li_item, 3, "File Folder")
			lv_files.SetItem(li_item, 4, String(ldt_modified))
			lv_files.SetItem(li_item, 2, String(ll_filesize, "#,##0") + " KB")
			lv_files.SetItem(li_item, 3, ls_filetype)
			lv_files.SetItem(li_item, 4, String(ldt_modified))
		End If
	Next
	lv_files.SetRedraw(True)
End If

end subroutine

on w_treeview.create
this.lv_files=create lv_files
this.st_splitbar=create st_splitbar
this.cb_cancel=create cb_cancel
this.tv_drives=create tv_drives
this.Control[]={this.lv_files,&
this.st_splitbar,&
this.cb_cancel,&
this.tv_drives}
end on

on w_treeview.destroy
destroy(this.lv_files)
destroy(this.st_splitbar)
destroy(this.cb_cancel)
destroy(this.tv_drives)
end on

event open;// create sorter datastore
ids_sorter = Create Datastore
ids_sorter.DataObject = "d_filesorter"

// associate objects with splitbar
st_splitbar.of_set_leftobject(tv_drives)
st_splitbar.of_set_rightobject(lv_files)
st_splitbar.of_set_minsize(500, 500)

this.Event Post ue_postopen()

end event

type lv_files from u_listview within w_treeview
integer x = 1353
integer y = 32
integer width = 3040
integer height = 2372
integer taborder = 20
integer textsize = -8
string facename = "Tahoma"
listviewview view = listviewreport!
end type

event constructor;call super::constructor;// add columns to report view
this.AddColumn("Name", Left!, 1250)
this.AddColumn("Size", Right!, 350)
this.AddColumn("Type", Left!, 750)
this.AddColumn("Date Modified", Left!, 550)

end event

event destructor;call super::destructor;this.of_DestroyImageLists()

end event

event doubleclicked;call super::doubleclicked;TreeViewItem ltvi_item
ListViewItem llvi_item
String ls_data
Long ll_handle

this.GetItem(index, llvi_item)
ls_data = String(llvi_item.Data)

If llvi_item.PictureIndex = 2 Then
	// double clicked on a folder, find it in the treeview
	tv_drives.ExpandItem(il_handle)
	ll_handle = tv_drives.FindItem(ChildTreeItem!, il_handle)
	do while ll_handle > 0
		tv_drives.GetItem(ll_handle, ltvi_item)
		If ls_data = String(ltvi_item.Data) Then
			tv_drives.SelectItem(ll_handle)
			tv_drives.SetFocus()
			Return
		End If
		ll_handle = tv_drives.FindItem(NextTreeItem!, ll_handle)
	loop
Else
	// double clicked on a file
	MessageBox(llvi_item.Label, ls_data)
End If

end event

type st_splitbar from u_splitbar_vertical within w_treeview
integer x = 1335
integer y = 32
integer height = 2372
end type

event destructor;call super::destructor;// save location
this.of_set_location()

end event

event constructor;call super::constructor;// restore location
this.of_get_location()

end event

type cb_cancel from commandbutton within w_treeview
integer x = 37
integer y = 2464
integer width = 334
integer height = 100
integer taborder = 20
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

type tv_drives from treeview within w_treeview
integer x = 37
integer y = 32
integer width = 1298
integer height = 2372
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
boolean linesatroot = true
boolean trackselect = true
string picturename[] = {"mycomputer.bmp","floppy.bmp","localdrive.bmp","netdrive.bmp","cdrom.bmp","folder.bmp","foldero.bmp","mydocuments.bmp"}
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type

event itempopulate;n_filesys ln_fsys
TreeViewItem ltvi_item
String ls_path, ls_name[]
DateTime ldt_write[]
Boolean lb_subdir[]
Double ld_size[]
Integer li_cnt, li_max

this.GetItem(handle, ltvi_item)
ls_path = ltvi_item.Data

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
		tv_drives.InsertItemLast(handle, ltvi_item)
	End if
Next

end event

event selectionchanged;wf_populate_listview(newhandle)

end event

