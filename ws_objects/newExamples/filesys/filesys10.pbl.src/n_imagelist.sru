$PBExportHeader$n_imagelist.sru
forward
global type n_imagelist from nonvisualobject
end type
end forward

global type n_imagelist from nonvisualobject autoinstantiate
end type

type prototypes
Function long ImageList_Create( &
	long cx, &
	long cy, &
	ulong flags, &
	long cInitial, &
	long cGrow &
	) Library "comctl32.dll"

Function boolean ImageList_Destroy( &
	long himl &
	) Library "comctl32.dll"

Function long ImageList_GetImageCount( &
	long himl &
	) Library "comctl32.dll"

Function long ImageList_ReplaceIcon( &
	long himl, &
	long i, &
	long hicon &
	) Library "comctl32.dll"

Function long ImageList_Add( &
	long himl, &
	long hbmImage, &
	long hbmMask &
	) Library "comctl32.dll"

// PowerBuilder VM Function
Function long FN_ResGetBitmapID( &
	string lpImageName &
	) Library "pbvm100.dll"

end prototypes

type variables
Private:
Long il_hImageList

Public:
Constant Long ILC_COLOR		= 0		// 0x0000
Constant Long ILC_MASK		= 1		// 0x0001
Constant Long ILC_COLOR4	= 4		// 0x0004
Constant Long ILC_COLOR8	= 8		// 0x0008
Constant Long ILC_COLOR16	= 16		// 0x0010
Constant Long ILC_COLOR24	= 24		// 0x0018
Constant Long ILC_COLOR32	= 32		// 0x0020
Constant Long ILC_COLORDDB	= 254		// 0x00FE
Constant Long ILC_PALETTE	= 2048	// 0x0800

end variables

forward prototypes
public function boolean of_destroy ()
public function long of_gethandle ()
public function long of_getimagecount ()
public function long of_addbitmap (long al_bitmap)
public function long of_addicon (long al_icon)
public function boolean of_create (long al_size, unsignedlong aul_flags)
public function long of_replaceicon (long al_index, long al_icon)
public subroutine of_sethandle (long al_handle)
public function string of_getstockbitmap (string as_imagename)
public function string of_pbvmname ()
end prototypes

public function boolean of_destroy ();// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_Destroy
//
// PURPOSE:    This function destroys the ImageList.
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If il_hImageList > 0 Then
	Return ImageList_Destroy(il_hImageList)
Else
	Return True
End If

end function

public function long of_gethandle ();// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_GetHandle
//
// PURPOSE:    This function returns the ImageList handle.
//
//	RETURN:		ImageList handle
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return il_hImageList

end function

public function long of_getimagecount ();// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_GetImageCount
//
// PURPOSE:    This function returns the number of images in the ImageList.
//
//	RETURN:		Image count
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If il_hImageList > 0 Then
	Return ImageList_GetImageCount(il_hImageList)
Else
	Return 0
End If

end function

public function long of_addbitmap (long al_bitmap);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_AddBitmap
//
// PURPOSE:    This function adds a bitmap to the ImageList.
//
// ARGUMENTS:  al_bitmap	- Handle of the loaded bitmap
//
//	RETURN:		Index of the added bitmap
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return ImageList_Add(il_hImageList, al_Bitmap, 0) + 1

end function

public function long of_addicon (long al_icon);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_AddIcon
//
// PURPOSE:    This function adds an icon to the ImageList.
//
// ARGUMENTS:  al_icon	- Handle of the loaded icon
//
//	RETURN:		Index of the added icon
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return of_ReplaceIcon(-1, al_Icon)

end function

public function boolean of_create (long al_size, unsignedlong aul_flags);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_Create
//
// PURPOSE:    This function creates the ImageList.
//
// ARGUMENTS:  al_size		- Width/Height of the images in pixels
//					aul_flags	- Creation flags
//
//	RETURN:		True=Success, False=Failure
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long		ll_hImageList
Boolean	lb_Return

ll_hImageList = ImageList_Create(al_Size, al_Size, aul_Flags, 0, 1)
If ll_hImageList > 0 Then
	il_hImageList = ll_hImageList
	lb_Return = True
Else
	il_hImageList = -1
	lb_Return = False
End If

Return lb_Return

end function

public function long of_replaceicon (long al_index, long al_icon);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_ReplaceIcon
//
// PURPOSE:    This function adds/replaces an icon in the ImageList.
//
// ARGUMENTS:  al_index		- Index to replace ( -1 means add to end )
//					al_icon		- Handle of the loaded icon
//
//	RETURN:		Index of the added/replaced icon
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return ImageList_ReplaceIcon(il_hImageList, al_Index, al_Icon)

end function

public subroutine of_sethandle (long al_handle);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_SetHandle
//
// PURPOSE:    This function saves the existing ImageList handle for later use.
//
// ARGUMENTS:  al_handle	- Handle of the existing ImageList
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_hImageList = al_handle

end subroutine

public function string of_getstockbitmap (string as_imagename);// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_GetStockBitmap
//
// PURPOSE:    This function returns the ResourceID for named bitmaps.
//
// ARGUMENTS:  as_imagename	- Name of the Bitmap
//
//	RETURN:		ResourceID
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return String(FN_ResGetBitmapID(as_imagename))

end function

public function string of_pbvmname ();// -----------------------------------------------------------------------------
// SCRIPT:     n_imagelist.of_PBVMName
//
// PURPOSE:    This function returns the name of the PBVM .dll file.
//
//	RETURN:		The name of the file
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 04/20/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Environment le_env
String ls_vmname

GetEnvironment(le_env)

If le_env.PBMinorRevision = 5 Then
	ls_vmname = "pbvm" + String(le_env.PBMajorRevision) + "5.dll"
Else
	ls_vmname = "pbvm" + String(le_env.PBMajorRevision) + "0.dll"
End If

Return ls_vmname

end function

on n_imagelist.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_imagelist.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;il_hImageList = -1

end event

