$PBExportHeader$u_treeview.sru
forward
global type u_treeview from treeview
end type
type shfileinfo from structure within u_treeview
end type
end forward

type shfileinfo from structure
	long		hicon
	long		iicon
	long		dwattributes
	character		szdisplayname[260]
	character		sztypename[80]
end type

global type u_treeview from treeview
string tag = "normal "
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
long picturemaskcolor = 536870912
long statepicturemaskcolor = 536870912
end type
global u_treeview u_treeview

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
n_imagelist in_Normal

Constant Long TV_FIRST				= 4352
Constant Long TVM_GETIMAGELIST	= (TV_FIRST + 8)
Constant Long TVM_SETIMAGELIST	= (TV_FIRST + 9)
Constant Long TVSIL_NORMAL			= 0

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
public subroutine of_destroyimagelist ()
public function boolean of_importassociatedicon (string as_filename, ref long al_normalicon)
public function boolean of_createimagelist ()
public function long of_importicons (string as_filename, long al_index, ref long al_normalicon)
public subroutine of_deleteitems ()
public function long of_getimagecount ()
public function long of_importicon (string as_filename, long al_index)
public function long of_importbitmap (string as_filename, string as_resourceid)
public function long of_importbitmap (string as_filename)
public function long of_geticoncount (string as_filename)
public function boolean of_setimagelist ()
public function long of_importstockbitmap (string as_imagename)
end prototypes

public subroutine of_destroyimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_DestroyImageList
//
// PURPOSE:    This function destroys the ImageList.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

in_Normal.of_Destroy()

end subroutine

public function boolean of_importassociatedicon (string as_filename, ref long al_normalicon);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportAssociatedIcon
//
// PURPOSE:    This function imports icons associated with a type of file.
//
// ARGUMENTS:  as_filename		- The name of the file
//					al_normalicon	- Picture index in the ImageList (by ref)
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
Long ll_rtn, ll_SmallIcons[]

al_normalicon = 0

ll_rtn = SHGetFileInfo(as_filename, 0, &
					lstr_SFI, 352, SHGFI_ICON + SHGFI_SMALLICON + SHGFI_USEFILEATTRIBUTES)
If ll_rtn = 0 Then Return False

ll_SmallIcons[1] = CopyIcon(lstr_SFI.hIcon)
al_normalicon = in_Normal.of_AddIcon(ll_SmallIcons[1]) + 1

DestroyIcon(ll_SmallIcons[1])

Return True

end function

public function boolean of_createimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_CreateImageList
//
// PURPOSE:    This function creates an ImageList for Normal pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

// remove existing pictures
this.DeletePictures()

// Create ImageList
If in_Normal.of_Create(16, in_Normal.ILC_COLOR32 + in_Normal.ILC_MASK) Then
	// Assign ImageList to TreeView
	Send(Handle(this), TVM_SETIMAGELIST, TVSIL_NORMAL, in_Normal.of_GetHandle())
Else
	Return False
End If

Return True

end function

public function long of_importicons (string as_filename, long al_index, ref long al_normalicon);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportIcons
//
// PURPOSE:    This function imports icons from a file into an ImageList.
//
// ARGUMENTS:  as_filename		- The name of the file
//					al_index			- Icon within file to load (zero for all)
//					al_normalicon	- Picture index for Normal Icon
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
			al_normalicon = in_Normal.of_AddIcon(ll_SmallIcons[ll_IconIndex]) + 1
		End If
		DestroyIcon(ll_LargeIcons[ll_IconIndex])
		DestroyIcon(ll_SmallIcons[ll_IconIndex])
	Next
End If

Return ll_IconCount

end function

public subroutine of_deleteitems ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_DeleteItems
//
// PURPOSE:    This function deletes all items from the treeview.
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Do Until this.FindItem(RootTreeItem!, 0) = -1
	this.DeleteItem(0)
Loop

end subroutine

public function long of_getimagecount ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_GetImageCount
//
// PURPOSE:    This function returns the number of images in the ImageList.
//
//	RETURN:		Image count
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return in_Normal.of_GetImageCount()

end function

public function long of_importicon (string as_filename, long al_index);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportIcon
//
// PURPOSE:    This function imports just a normal icon.
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

Long ll_count, ll_normal

ll_count = this.of_ImportIcons(as_filename, al_index, ll_normal)

Return ll_normal

end function

public function long of_importbitmap (string as_filename, string as_resourceid);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportBitmap
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
ll_Index = in_Normal.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

// free the library
FreeLibrary(ll_Module)

Return ll_Index

end function

public function long of_importbitmap (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportBitmap
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
ll_Index = in_Normal.of_AddBitmap(ll_Bitmap)

// delete bitmap from memory
DeleteObject(ll_Bitmap)

Return ll_Index

end function

public function long of_geticoncount (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_GetIconCount
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

public function boolean of_setimagelist ();// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_SetImageList
//
// PURPOSE:    This function sets the existing ImageList for Normal pictures.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_handle

ll_handle = Send(Handle(this), TVM_GETIMAGELIST, TVSIL_NORMAL, 0)

in_Normal.of_SetHandle(ll_handle)

Return True

end function

public function long of_importstockbitmap (string as_imagename);// -----------------------------------------------------------------------------
// SCRIPT:     u_treeview.of_ImportStockBitmap
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

ls_ResourceID = in_Normal.of_GetStockBitmap(as_imagename)

Return of_ImportBitmap(in_Normal.of_PBVMName(), ls_ResourceID)

end function

on u_treeview.create
end on

on u_treeview.destroy
end on

