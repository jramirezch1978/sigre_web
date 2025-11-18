$PBExportHeader$n_dwautowidth.sru
$PBExportComments$Performs autowidth on grid datawindow columns
forward
global type n_dwautowidth from nonvisualobject
end type
type os_size from structure within n_dwautowidth
end type
end forward

type os_size from structure
	long		cx
	long		cy
end type

global type n_dwautowidth from nonvisualobject autoinstantiate
end type

type prototypes
Function ulong GetDC ( &
	ulong hWnd &
	) Library "user32.dll"

Function ulong SelectObject ( &
	ulong hdc, &
	ulong hWnd &
	) Library "gdi32.dll"

Function boolean GetTextExtentPoint32 ( &
	ulong hdcr, &
	string lpString, &
	long nCount, &
	Ref os_size size &
	) Library "gdi32.dll" Alias For "GetTextExtentPoint32W"

Function long ReleaseDC ( &
	ulong hWnd, &
	ulong hdcr &
	) Library "user32.dll"

end prototypes

type variables
Constant Integer WM_GETFONT = 49
Window iw_parent
Datawindow idw_data
Integer ii_original[]

end variables

forward prototypes
public subroutine of_register (readonly window aw_parent, ref datawindow adw_datawindow)
public function long of_resize (string as_colname)
public function long of_resize (integer ai_colnbr)
public subroutine of_statictext_resize (ref statictext ast_text)
end prototypes

public subroutine of_register (readonly window aw_parent, ref datawindow adw_datawindow);// -----------------------------------------------------------------------------
// SCRIPT:     n_dwautowidth.of_register
//
// PURPOSE:    This function saves a reference to the window and datawindow
//             in instance variables for use in the of_resize function. It
//					also saves the initial width of all visible columns to use as
//					minimum width.
//
// CALLED BY:  Usually called from Constructor event of the datawindow or right
//					after setting the .DataObject property of the dw control.
//
// ARGUMENTS:  aw_parent - Window that the datawindow is on
//					adw_datawindow - Datawindow whose columns will be resized
//
// RETURN:     Row containing the longest value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 11/25/2002  Roland S		Initial creation
// -----------------------------------------------------------------------------

Integer li_col, li_max

// save references to parent window and datawindow
iw_parent = aw_parent
idw_data = adw_datawindow

// record column original size
li_max = Integer(adw_datawindow.Object.DataWindow.Column.Count)
FOR li_col = 1 TO li_max
	ii_original[li_col] = Integer(adw_datawindow.Describe("#" + String(li_col) + ".Width"))
NEXT

end subroutine

public function long of_resize (string as_colname);// -----------------------------------------------------------------------------
// SCRIPT:     n_dwautowidth.of_resize
//
// PURPOSE:    This function will change the column width so that the longest
//             value will fit.  The minimum width is the initial width set in
//					the datawindow painter.
//
// CALLED BY:  Usually called from RetrieveEnd event of the datawindow or
//					just after inserting/modifying the values in the column.
//
// ARGUMENTS:  as_colname - Column to be resized
//
// RETURN:     Row containing the longest value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 11/25/2002  Roland S		Initial creation
// -----------------------------------------------------------------------------

Long ll_row, ll_max, ll_maxrow
ULong lul_Handle, lul_hDC, lul_hFont
Integer li_maxwidth, li_rc, li_size, li_colnbr
String ls_value, ls_format, ls_modify
StaticText lst_text
os_size lstr_Size

li_rc = iw_parent.OpenUserObject(lst_text)
If li_rc = 1 Then
	// get column number
	li_colnbr  = Integer(idw_data.Describe(as_colname + ".ID"))
	// get column format string
	ls_format = idw_data.Describe(as_colname + ".Format")
	// give static text same font properties as column
	lst_text.FaceName = idw_data.Describe(as_colname + ".Font.Face")
	lst_text.TextSize = Integer(idw_data.Describe(as_colname + ".Font.Height"))
	lst_text.Weight = Integer(idw_data.Describe(as_colname + ".Font.Weight"))
	// set italic property
	If idw_data.Describe(as_colname + ".Font.Italic") = "1" Then
		lst_text.Italic = True
	Else
		lst_text.Italic = False
	End If
	// set charset property
	CHOOSE CASE idw_data.Describe(as_colname + ".Font.CharSet")
		CASE "0"
			lst_text.FontCharSet = ANSI!
		CASE "2"
			lst_text.FontCharSet = Symbol!
		CASE "128"
			lst_text.FontCharSet = ShiftJIS!
		CASE "255"
			lst_text.FontCharSet = OEM!
		CASE ELSE
			lst_text.FontCharSet = DefaultCharSet!
	END CHOOSE
	// set family property
	CHOOSE CASE idw_data.Describe(as_colname + ".Font.Family")
		CASE "1"
			lst_text.FontFamily = Roman!
		CASE "2"
			lst_text.FontFamily = Swiss!
		CASE "3"
			lst_text.FontFamily = Modern!
		CASE "4"
			lst_text.FontFamily = Script!
		CASE "5"
			lst_text.FontFamily = Decorative!
		CASE ELSE
			lst_text.FontFamily = AnyFont!
	END CHOOSE
	// set pitch property
	CHOOSE CASE idw_data.Describe(as_colname + ".Font.Pitch")
		CASE "1"
			lst_text.FontPitch = Fixed!
		CASE "2"
			lst_text.FontPitch = Variable!
		CASE ELSE
			lst_text.FontPitch = Default!
	END CHOOSE
	// create device context for statictext
	lul_Handle = Handle(lst_text)
	lul_hDC = GetDC(lul_Handle)
	// get handle to the font used by statictext
	lul_hFont = Send(lul_Handle, WM_GETFONT, 0, 0)
	// Select it into the device context
	SelectObject(lul_hDC, lul_hFont)
	// walk thru each row of datawindow
	ll_max = idw_data.RowCount()
	FOR ll_row = 1 TO ll_max
		// get value from datawindow
		ls_value = RightTrim(String(idw_data.object.data[ll_row, li_colnbr], ls_format))
		// determine text width
		If Not GetTextExtentPoint32(lul_hDC, ls_value, Len(ls_value), lstr_Size) Then
			ReleaseDC(lul_Handle, lul_hDC)
			iw_parent.CloseUserObject(lst_text)
			Return -1
		End If
		// convert length in pixels to PBUnits
		li_size = PixelsToUnits(lstr_Size.cx, XPixelsToUnits!)
		If li_size > li_maxwidth Then
			li_maxwidth = li_size
			ll_maxrow = ll_row
		End If
	NEXT
	// release the device context
	ReleaseDC(lul_Handle, lul_hDC)
	// modify the column width
	If li_maxwidth > ii_original[li_colnbr] Then
		ls_modify = as_colname + ".Width = " + String(li_maxwidth + 8)
	Else
		ls_modify = as_colname + ".Width = " + String(ii_original[li_colnbr])
	End If
	idw_data.Modify(ls_modify)
	// destroy statictext
	iw_parent.CloseUserObject(lst_text)
End If

Return ll_maxrow

end function

public function long of_resize (integer ai_colnbr);// -----------------------------------------------------------------------------
// SCRIPT:     n_dwautowidth.of_resize
//
// PURPOSE:    This function gets the name for the passed column number
//             and passes it to the function that does the resizing.
//
// CALLED BY:  Usually called from RetrieveEnd event of the datawindow or
//					just after inserting/modifying the values in the column.
//
// ARGUMENTS:  ai_colnbr - Column to be resized
//
// RETURN:     Row containing the longest value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 11/25/2002  Roland S		Initial creation
// -----------------------------------------------------------------------------

String ls_colname

ls_colname = idw_data.Describe("#" + String(ai_colnbr) + ".Name")

Return this.of_resize(ls_colname)

end function

public subroutine of_statictext_resize (ref statictext ast_text);// resize static text control

os_size lstr_Size
ULong lul_handle, lul_hDC, lul_hFont
String ls_value
Integer li_size

// create device context for statictext
lul_Handle = Handle(ast_text)
lul_hDC = GetDC(lul_Handle)

// get handle to the font used by statictext
lul_hFont = Send(lul_Handle, WM_GETFONT, 0, 0)

// Select it into the device context
SelectObject(lul_hDC, lul_hFont)

// determine text length
ls_value = Trim(ast_text.text)
GetTextExtentPoint32(lul_hDC, ls_value, Len(ls_value), lstr_Size)

// convert length in pixels to PBUnits
li_size = PixelsToUnits(lstr_Size.cx, XPixelsToUnits!) + 8

// release the device context
ReleaseDC(lul_Handle, lul_hDC)

// resize the statictext
ast_text.width = li_size

end subroutine

on n_dwautowidth.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_dwautowidth.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

