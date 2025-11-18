$PBExportHeader$w_main.srw
forward
global type w_main from window
end type
type mdi_1 from mdiclient within w_main
end type
type dw_info from u_base_datawindow within w_main
end type
end forward

global type w_main from window
integer x = 23
integer y = 24
integer width = 4210
integer height = 2424
boolean titlebar = true
string title = "ZLib - Compression Library Example"
string menuname = "m_main"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowtype windowtype = mdihelp!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_openzip ( )
event ue_comments ( )
event ue_extract ( )
event ue_newzip ( )
mdi_1 mdi_1
dw_info dw_info
end type
global w_main w_main

type variables
n_dwautowidth in_dwaw
String is_zipfile

end variables

event ue_openzip();String ls_filename
Integer li_rc

li_rc = GetFileOpenName("Open Zip Archive", &
		is_zipfile, ls_filename, "ZIP", "Zip Archives (*.zip),*.ZIP")

If li_rc = 1 Then
	// get directory of zipfile
	dw_info.Event ue_populate()
End If

end event

event ue_comments();String ls_comment
ULong lul_unzFile

If is_zipfile = "" Then Return

// open the zip archive
lul_unzFile = gn_zlib.of_unzOpen(is_zipfile)
If lul_unzFile > 0 Then
	// get global comment
	ls_comment = gn_zlib.of_unzGetGlobalComment(lul_unzFile)
	MessageBox("Global Comment", ls_comment)
	// close the zip archive
	gn_zlib.of_unzClose(lul_unzFile)
End If

end event

event ue_extract();String ls_name, ls_fullname, ls_filename
ULong lul_unzFile
Long ll_row
Integer li_rc

ll_row = dw_info.GetRow()
If ll_row = 0 Then Return

// get file name and fullname
ls_name = dw_info.GetItemString(ll_row, "name")
ls_fullname = dw_info.GetItemString(ll_row, "fullname")

// get filename to extract to
li_rc = GetFileSaveName("Extract File", &
		ls_name, ls_filename, "", "All Files (*.*),*.*")
If li_rc = 1 Then
	SetPointer(HourGlass!)
	// open the zip archive
	lul_unzFile = gn_zlib.of_unzOpen(is_zipfile)
	If lul_unzFile > 0 Then
		// extract the file
		gn_zlib.of_ExtractFile(lul_unzFile, ls_name, ls_fullname)
		// close the zip archive
		gn_zlib.of_unzClose(lul_unzFile)
		Beep(1)
	End If
End If

end event

event ue_newzip();n_getopenfilename ln_ofn
ULong lul_zipFile
Integer li_rc, li_file, li_count
String ls_title, ls_fname, ls_filter, ls_folder, ls_initialdir
String ls_pathname[], ls_filename[]
Boolean lb_folder = False

li_rc = GetFileSaveName("Create Zip Archive", &
		is_zipfile, ls_fname, "zip", "Zip Archives (*.zip),*.zip")
If li_rc = 1 Then
	SetPointer(HourGlass!)
	If lb_folder Then
		ls_title = "Add Folder to Archive"
		li_rc = GetFolder(ls_title, ls_folder)
		If li_rc = 1 Then
			// open zipfile
			lul_zipFile = gn_zlib.of_zipOpen(is_zipfile)
			// import selected folder
			gn_zlib.of_ImportFolder(lul_zipFile, ls_folder)
			// close zipfile
			gn_zlib.of_zipClose(lul_zipFile, "Zip archive created by PowerBuilder!")
		End If
	Else
		// get name of files to add
		ls_title = "Add Files to Archive"
		ls_filter = "All Files (*.*), *.*"
		li_rc = ln_ofn.of_GetOpenFileName(Handle(this), ls_title, &
									ls_pathname, ls_filename, ls_filter, ls_initialdir)
		If li_rc = 1 Then
			// open zipfile
			lul_zipFile = gn_zlib.of_zipOpen(is_zipfile)
			// import selected files
			li_count = UpperBound(ls_pathname)
			FOR li_file = 1 TO li_count
				gn_zlib.of_ImportFile(lul_zipFile, ls_pathname[li_file], ls_filename[li_file])
			NEXT
			// close zipfile
			gn_zlib.of_zipClose(lul_zipFile, "Zip archive created by PowerBuilder!")
		End If
	End If
	// get directory of zipfile
	dw_info.Event ue_populate()
End If

end event

on w_main.create
if this.MenuName = "m_main" then this.MenuID = create m_main
this.mdi_1=create mdi_1
this.dw_info=create dw_info
this.Control[]={this.mdi_1,&
this.dw_info}
end on

on w_main.destroy
if IsValid(MenuID) then destroy(MenuID)
destroy(this.mdi_1)
destroy(this.dw_info)
end on

event resize;dw_info.Width  = this.WorkSpaceWidth() - 18
dw_info.Height = this.WorkSpaceHeight() - 75

end event

type mdi_1 from mdiclient within w_main
long BackColor=268435456
end type

type dw_info from u_base_datawindow within w_main
event ue_populate ( )
integer x = 9
integer y = 164
integer width = 4091
integer height = 2016
string dataobject = "d_zipdirectory"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event ue_populate();// get directory of created zipfile

String ls_import

SetPointer(HourGlass!)

this.SetRedraw(False)

Parent.title = "ZLib - " + is_zipfile

ls_import = gn_zlib.of_Directory(is_zipfile, False)

this.Reset()

this.ImportString(ls_import)

this.Sort()

// resize columns
in_dwaw.of_resize("name")
in_dwaw.of_resize("type")
in_dwaw.of_resize("size")
in_dwaw.of_resize("packed")
in_dwaw.of_resize("path")

this.SetRedraw(True)

this.Event RowFocusChanged(1)

end event

event constructor;call super::constructor;// turn on gridsort arrows
this.of_gridsort_arrows(this.of_get_syscolor(16))

// register window/datawindow
in_dwaw.of_register(Parent, dw_info)

end event

