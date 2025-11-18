$PBExportHeader$u_listview.sru
forward
global type u_listview from listview
end type
type shfileinfo from structure within u_listview
end type
end forward

type shfileinfo from structure
	long		hicon
	long		iicon
	long		dwattributes
	character		szdisplayname[260]
	character		sztypename[80]
end type

global type u_listview from listview
integer width = 480
integer height = 400
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
long largepicturemaskcolor = 536870912
long smallpicturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_listview u_listview

type prototypes
Function long ExtractIconEx( &
	string lpszFile, &
	long nIconIndex, &
	Ref long phIconLarge[], &
	Ref long phIconSmall[], &
	long nIcons &
	) Library "shell32.dll" Alias For "ExtractIconExW"

Function boolean DestroyIcon( &
	long hIcon &
	) LIbrary "user32.dll"

Function ulong SHGetFileInfo ( &
	string pszPath, &
	long dwFileAttributes, &
	Ref SHFILEINFO psfi, &
	long cbFileInfo, &
	long uFlags &
	) Library "shell32.dll" Alias For "SHGetFileInfoW"

Function long CopyIcon ( &
	long hIcon &
	) Library "user32.dll"

Function long LoadLibrary( &
	string lpFileName &
	) Library "kernel32.dll" Alias For "LoadLibraryW"

Function boolean FreeLibrary( &
	long hModule &
	) Library "kernel32.dll"

Function long LoadImage( &
	long hinst, &
	string lpszName, &
	ulong uType, &
	long cxDesired, &
	long cyDesired, &
	ulong fuLoad &
	) Library "user32.dll" Alias For "LoadImageW"

Function boolean DeleteObject( &
	long hObject &
	) Library "gdi32.dll"

end prototypes

type variables
n_imagelist in_Large
n_imagelist in_Small
Boolean ib_Large
Boolean ib_Small

Constant Long LVM_FIRST				= 4096	// 0x1000
Constant Long LVM_GETIMAGELIST	= (LVM_FIRST + 2)
Constant Long LVM_SETIMAGELIST	= (LVM_FIRST + 3)
Constant Long LVSIL_NORMAL			= 0
Constant Long LVSIL_SMALL			= 1

Constant Long IMAGE_BITMAP	= 0

Constant Long LR_CREATEDIBSECTION	= 8192	// 0x00002000
Constant Long LR_DEFAULTCOLOR			= 0		// 0x00000000
Constant Long LR_DEFAULTSIZE			= 64		// 0x00000040
Constant Long LR_LOADFROMFILE			= 16		// 0x00000010
Constant Long LR_LOADMAP3DCOLORS		= 4096	// 0x00001000
Constant Long LR_LOADTRANSPARENT		= 32		// 0x00000020
Constant Long LR_MONOCHROME			= 1		// 0x00000001
Constant Long LR_SHARED					= 32768	// 0x00008000
Constant Long LR_VGACOLOR				= 128		// 0x00000080

end variables

forward prototypes
public function string of_getfiledescription (string as_filename)
public function boolean of_importassociatedicon (string as_filename, ref long al_largeicon, ref long al_smallicon)
public function long of_importlargeicon (string as_filename, long al_index)
public function long of_importsmallicon (string as_filename, long al_index)
public function long of_importicons (string as_filename, long al_index, boolean ab_large, boolean ab_small, ref long al_largeicon, ref long al_smallicon)
public function long of_getlargeimagecount ()
public function long of_getsmallimagecount ()
public function boolean of_createlargeimagelist ()
public function boolean of_createsmallimagelist ()
public function long of_importlargebitmap (string as_filename, string as_resourceid)
public function long of_importsmallbitmap (string as_filename, string as_resourceid)
public function long of_importlargebitmap (string as_filename)
public function long of_importsmallbitmap (string as_filename)
public function long of_geticoncount (string as_filename)
public subroutine of_destroyimagelists ()
public function boolean of_setlargeimagelist ()
public function boolean of_setsmallimagelist ()
public function long of_importstockbitmap (string as_imagename)
end prototypes

public function string of_getfiledescription (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_GetFileDescription
//
// PURPOSE:    This function returns the file type description.
//
// ARGUMENTS:  as_filename		- The name of the file
//
//	RETURN:		File Description
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant Long SHGFI_ICON = 256 
Constant Long SHGFI_DISPLAYNAME = 512
Constant Long SHGFI_TYPENAME = 1024
SHFILEINFO lstr_SFI
String ls_typename, ls_extn, ls_regkey, ls_regvalue
Long ll_rc, ll_pos

ll_pos = LastPos(as_filename, ".")
ls_extn = Mid(as_filename, ll_pos + 1)

ll_rc = SHGetFileInfo(as_filename, 0, lstr_SFI, 352, SHGFI_TYPENAME)
If ll_rc = 1 Then
	ls_typename = String(lstr_SFI.szTypeName)
Else
	ls_regkey = "HKEY_CLASSES_ROOT\." + ls_extn
	RegistryGet(ls_regkey, "", RegString!, ls_regvalue)
	ls_regkey = "HKEY_CLASSES_ROOT\" + ls_regvalue
	RegistryGet(ls_regkey, "", RegString!, ls_typename)
End If

If ls_typename = "" Then
	ls_typename = Upper(ls_extn) + " File"
End If

Return ls_typename

end function

public function boolean of_importassociatedicon (string as_filename, ref long al_largeicon, ref long al_smallicon);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportAssociatedIcon
//
// PURPOSE:    This function imports icons associated with a type of file.
//
// ARGUMENTS:  as_filename		- The name of the file
//					al_largeicon	- Picture index for Large Icon (by ref)
//					al_smallicon	- Picture index for Small Icon (by ref)
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant Long SHGFI_ICON = 256
Constant Long SHGFI_LARGEICON = 0
Constant Long SHGFI_SMALLICON = 1
Constant Long SHGFI_USEFILEATTRIBUTES = 16
SHFILEINFO lstr_SFI
Long ll_rtn, ll_LargeIcons[], ll_SmallIcons[]

al_largeicon = 0
al_smallicon = 0

If ib_large Then
	ll_rtn = SHGetFileInfo(as_filename, 0, &
					lstr_SFI, 352, SHGFI_ICON + SHGFI_LARGEICON + SHGFI_USEFILEATTRIBUTES)
	If ll_rtn = 0 Then Return False
	ll_LargeIcons[1] = CopyIcon(lstr_SFI.hIcon)
	al_largeicon = in_Large.of_AddIcon(ll_LargeIcons[1]) + 1
	DestroyIcon(ll_LargeIcons[1])
End If

If ib_small Then
	ll_rtn = SHGetFileInfo(as_filename, 0, &
					lstr_SFI, 352, SHGFI_ICON + SHGFI_SMALLICON + SHGFI_USEFILEATTRIBUTES)
	If ll_rtn = 0 Then Return False
	ll_SmallIcons[1] = CopyIcon(lstr_SFI.hIcon)
	al_smallicon = in_Small.of_AddIcon(ll_SmallIcons[1]) + 1
	DestroyIcon(ll_SmallIcons[1])
End If

Return True

end function

public function long of_importlargeicon (string as_filename, long al_index);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportLargeIcon
//
// PURPOSE:    This function imports just a large icon.
//
// ARGUMENTS:  as_filename	- The name of the file
//					al_index		- The index of the icon in the file
//
//	RETURN:		ImageList index
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_count, ll_large, ll_small

ll_count = this.of_ImportIcons(as_filename, al_index, &
								True, False, ll_large, ll_small)

Return ll_large

end function

public function long of_importsmallicon (string as_filename, long al_index);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportSmallIcon
//
// PURPOSE:    This function imports just a small icon.
//
// ARGUMENTS:  as_filename	- The name of the file
//					al_index		- The index of the icon in the file
//
//	RETURN:		ImageList index
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_count, ll_large, ll_small

ll_count = this.of_ImportIcons(as_filename, al_index, &
								False, True, ll_large, ll_small)

Return ll_small

end function

public function long of_importicons (string as_filename, long al_index, boolean ab_large, boolean ab_small, ref long al_largeicon, ref long al_smallicon);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportIcons
//
// PURPOSE:    This function imports icons from a file into an ImageList.
//
// ARGUMENTS:  as_filename		- The name of the file
//					al_index			- Icon within file to load (zero for all)
//					ab_large			- Import into Large ImageList
//					ab_small			- Import into Small ImageList
//					al_largeicon	- Picture index for Large Icon (by ref)
//					al_smallicon	- Picture index for Small Icon (by ref)
//
//					Icons within a file are numbered starting with zero. Since
//					zero based arrays aren't supported, you need to add one if
//					importing a single icon.
//
//	RETURN:		Return from ExtractIconEx, normally the number of icons.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_IconCount, ll_IconIndex, ll_LargeIcons[], ll_SmallIcons[]

al_largeicon = 0
al_smallicon = 0

// Count the icons in the file
ll_IconCount = ExtractIconEx(as_FileName, -1, ll_LargeIcons, ll_SmallIcons, 0)
If ll_IconCount > 0 Then
	// Allocate memory for the array
	ll_LargeIcons[ll_IconCount] = 0
	ll_SmallIcons[ll_IconCount] = 0
	// Extract array of Icon Handles
	ExtractIconEx(as_FileName, 0, ll_LargeIcons, ll_SmallIcons, ll_IconCount)
	For ll_IconIndex = 1 TO ll_IconCount
		// Add Icon to ImageList
		If (ll_IconIndex = al_index) Or (al_index = 0) Then
			If ab_large Then
				al_largeicon = in_Large.of_AddIcon(ll_LargeIcons[ll_IconIndex]) + 1
			End If
			If ab_small Then
				al_smallicon = in_Small.of_AddIcon(ll_SmallIcons[ll_IconIndex]) + 1
			End If
		End If
		DestroyIcon(ll_LargeIcons[ll_IconIndex])
		DestroyIcon(ll_SmallIcons[ll_IconIndex])
	Next
End If

Return ll_IconCount

end function

public function long of_getlargeimagecount ();// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_GetLargeImageCount
//
// PURPOSE:    This function returns the number of images in the ImageList.
//
//	RETURN:		Image count
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return in_Large.of_GetImageCount()

end function

public function long of_getsmallimagecount ();// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_GetSmallImageCount
//
// PURPOSE:    This function returns the number of images in the ImageList.
//
//	RETURN:		Image count
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return in_Small.of_GetImageCount()

end function

public function boolean of_createlargeimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_CreateLargeImageList
//
// PURPOSE:    This function creates an ImageList for Large pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_Large = True

// remove existing pictures
this.DeleteLargePictures()

// Create ImageList
If in_Large.of_Create(32, in_Large.ILC_COLOR32 + in_Large.ILC_MASK) Then
	// Assign ImageList to ListView
	Send(Handle(this), LVM_SETIMAGELIST, LVSIL_NORMAL, in_Large.of_GetHandle())
Else
	Return False
End If

Return True

end function

public function boolean of_createsmallimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_CreateSmallImageList
//
// PURPOSE:    This function creates an ImageList for Small pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_Small = True

// remove existing pictures
this.DeleteSmallPictures()

// Create ImageList
If in_Small.of_Create(16, in_Small.ILC_COLOR32 + in_Small.ILC_MASK) Then
	// Assign ImageList to ListView
	Send(Handle(this), LVM_SETIMAGELIST, LVSIL_SMALL, in_Small.of_GetHandle())
Else
	Return False
End If

Return True

end function

public function long of_importlargebitmap (string as_filename, string as_resourceid);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportLargeBitmap
//
// PURPOSE:    This function imports a bitmap resource.
//
// ARGUMENTS:  as_filename		- The name of the file
//					as_resourceid	- The ResourceID (by name or number)
//
//	RETURN:		ImageList index
//					( if bitmap is an image strip, this is the first entry )
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/19/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_Index, ll_Module, ll_Bitmap
String ls_ResourceID

// load the library into memory
ll_Module = LoadLibrary(as_filename)
If ll_Module <= 0 Then
	Return 0
End If

// prefix # for numbered resource
If IsNumber(as_resourceid) Then
	ls_ResourceID = "#" + as_resourceid
Else
	ls_ResourceID = as_resourceid
End If

// load the bitmap
ll_Bitmap = LoadImage(ll_Module, ls_ResourceID, IMAGE_BITMAP, &
					0, 0, LR_LOADTRANSPARENT)

// add it to the ImageList
ll_Index = in_Large.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

// free the library
FreeLibrary(ll_Module)

Return ll_Index

end function

public function long of_importsmallbitmap (string as_filename, string as_resourceid);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportSmallBitmap
//
// PURPOSE:    This function imports a bitmap resource.
//
// ARGUMENTS:  as_filename		- The name of the file
//					as_resourceid	- The ResourceID (by name or number)
//
//	RETURN:		ImageList index
//					( if bitmap is an image strip, this is the first entry )
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_Index, ll_Module, ll_Bitmap
String ls_ResourceID

// load the library into memory
ll_Module = LoadLibrary(as_filename)
If ll_Module <= 0 Then
	Return 0
End If

// prefix # for numbered resource
If IsNumber(as_resourceid) Then
	ls_ResourceID = "#" + as_resourceid
Else
	ls_ResourceID = as_resourceid
End If

// load the bitmap
ll_Bitmap = LoadImage(ll_Module, ls_ResourceID, IMAGE_BITMAP, &
					0, 0, LR_LOADTRANSPARENT)

// add it to the ImageList
ll_Index = in_Small.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

// free the library
FreeLibrary(ll_Module)

Return ll_Index

end function

public function long of_importlargebitmap (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportLargeBitmap
//
// PURPOSE:    This function imports a bitmap file.
//
// ARGUMENTS:  as_filename	- The name of the file
//
//	RETURN:		ImageList index
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_Index, ll_Bitmap

// load the bitmap
ll_Bitmap = LoadImage(0, as_filename, IMAGE_BITMAP, &
					0, 0, LR_LOADTRANSPARENT + LR_LOADFROMFILE)

// add it to the ImageList
ll_Index = in_Large.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

Return ll_Index

end function

public function long of_importsmallbitmap (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportSmallBitmap
//
// PURPOSE:    This function imports a bitmap file.
//
// ARGUMENTS:  as_filename	- The name of the file
//
//	RETURN:		ImageList index
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_Index, ll_Bitmap

// load the bitmap
ll_Bitmap = LoadImage(0, as_filename, IMAGE_BITMAP, &
					0, 0, LR_LOADTRANSPARENT + LR_LOADFROMFILE)

// add it to the ImageList
ll_Index = in_Small.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

Return ll_Index

end function

public function long of_geticoncount (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_GetIconCount
//
// PURPOSE:    This function returns the number of icons in the file.
//
// ARGUMENTS:  as_filename	- The name of the file
//
//	RETURN:		The number of icons in the file
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_LargeIcons[], ll_SmallIcons[]

// Count the icons in the file
Return ExtractIconEx(as_FileName, -1, ll_LargeIcons, ll_SmallIcons, 0)

end function

public subroutine of_destroyimagelists ();// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_DestroyImageLists
//
// PURPOSE:    This function destroys the ImageLists.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If ib_Large Then
	in_Large.of_Destroy()
End If

If ib_Small Then
	in_Small.of_Destroy()
End If

end subroutine

public function boolean of_setlargeimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_SetLargeImageList
//
// PURPOSE:    This function sets the existing ImageList for Large pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_handle

ll_handle = Send(Handle(this), LVM_GETIMAGELIST, LVSIL_NORMAL, 0)

in_Large.of_SetHandle(ll_handle)

Return True

end function

public function boolean of_setsmallimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_SetSmallImageList
//
// PURPOSE:    This function sets the existing ImageList for Small pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_handle

ll_handle = Send(Handle(this), LVM_GETIMAGELIST, LVSIL_SMALL, 0)

in_Small.of_SetHandle(ll_handle)

Return True

end function

public function long of_importstockbitmap (string as_imagename);// -----------------------------------------------------------------------------
// SCRIPT:     u_listview.of_ImportStockBitmap
//
// PURPOSE:    This function imports a PowerBuilder stock bitmap file.
//
// ARGUMENTS:  as_imagename	- The name of the bitmap
//
//	RETURN:		ImageList index
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_ResourceID

ls_ResourceID = in_Small.of_GetStockBitmap(as_imagename)

Return of_ImportSmallBitmap(in_Small.of_PBVMName(), ls_ResourceID)

end function

on u_listview.create
end on

on u_listview.destroy
end on

