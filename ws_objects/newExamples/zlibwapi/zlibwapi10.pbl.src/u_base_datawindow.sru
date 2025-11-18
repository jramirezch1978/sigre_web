$PBExportHeader$u_base_datawindow.sru
$PBExportComments$Base datawindow object ( with GridSortArrows feature )
forward
global type u_base_datawindow from datawindow
end type
end forward

global type u_base_datawindow from datawindow
integer width = 494
integer height = 360
integer taborder = 10
boolean livescroll = true
borderstyle borderstyle = stylelowered!
end type
global u_base_datawindow u_base_datawindow

type prototypes
Function ulong GetSysColor ( &
	integer nindex &
	) Library "user32.dll"

end prototypes

type variables
String is_sort
end variables

forward prototypes
public subroutine of_gridsort_arrows (unsignedlong aul_color)
public function unsignedlong of_get_syscolor (integer ai_index)
end prototypes

public subroutine of_gridsort_arrows (unsignedlong aul_color);// add arrows to grid column headers to indicate sorting

Integer li_col, li_max
String ls_syntax, ls_xpos, ls_width, ls_name
String ls_color, ls_exprsn, ls_align

// bail out if not a valid grid datawindow
If this.DataObject = "" Then Return
If this.Object.DataWindow.Processing <> "1" Then Return

// loop thru all visible columns
li_max = Integer(this.Object.DataWindow.Column.Count)
FOR li_col = 1 TO li_max
	// process column if visible
	If this.Describe("#" + String(li_col) + ".Visible") = "1" Then
		// get columns name
		ls_name = this.Describe("#" + String(li_col) + ".Name")
		// build parts of the syntax
		ls_xpos  = this.Describe(ls_name + ".X")
		ls_width = this.Describe(ls_name + ".Width")
		ls_color = String(aul_color)
		If this.Describe(ls_name + "_t.Alignment") = "1" Then
			ls_align = "0"
		Else
			ls_align = "1"
		End If
		// build compute expression
		ls_exprsn  = "~"if(pos(lower(describe('datawindow.table.sort')), '"
		ls_exprsn += ls_name + " a') > 0, '5', "
		ls_exprsn += "if(pos(lower(describe('datawindow.table.sort')), '"
		ls_exprsn += ls_name + " d') > 0, '6', "
		ls_exprsn += "if(pos(lower(describe('datawindow.table.sort')), '"
		ls_exprsn += "lookupdisplay(" + ls_name + ") a') > 0, '5', "
		ls_exprsn += "if(pos(lower(describe('datawindow.table.sort')), '"
		ls_exprsn += "lookupdisplay(" + ls_name + ") d') > 0, '6', ''))))~" "
		// build create computed column syntax
		ls_syntax  = "create compute( band=header alignment=~"" + ls_align + "~" expression=" + ls_exprsn
		ls_syntax += "border=~"0~" color=~"" + ls_color + "~" x=~"" + ls_xpos + "~" y=~"8~" "
		ls_syntax += "height=~"48~" width=~"" + ls_width + "~" format=~"[general]~" "
		ls_syntax += "name=" + ls_name + "_a font.face=~"Marlett~" font.height=~"-10~" "
		ls_syntax += "font.weight=~"400~" font.family=~"0~" font.pitch=~"2~" font."
		ls_syntax += "charset=~"2~" background.mode=~"1~" background.color=~"553648127~" )"
		// create the computed column
		this.Modify(ls_syntax)
		this.SetPosition(ls_name + "_a", "header", True)
	End If
NEXT

end subroutine

public function unsignedlong of_get_syscolor (integer ai_index);// These are the argument values
//
//        Object          Value         Object          Value
// --------------------- ------- --------------------- -------
// Scroll Bar Background     0
// Desktop Background        1   Inactive Border          11
// Active Title Bar          2   App Work Space           12
// Inactive Title Bar        3   Highlight                13
// Menu                      4   Highlight Text           14
// Window                    5   Button Face              15
// Window Frame              6   Button Shadow            16
// Menu Text                 7   Gray Text                17
// Window Text               8   Button Text              18
// Title Bar Text            9   Inactive Title Bar Text  19
// Active Border            10   Button Highlight         20

// ToolTip Text             23   ToolTip Background       24

Return GetSysColor(ai_index)

end function

event rowfocuschanged;this.SelectRow(0, False)
this.SelectRow(currentrow, True)

end event

event clicked;String ls_name, ls_sort

// sort grid datawindow if header clicked on
If this.Object.DataWindow.Processing = "1" Then
	ls_name = dwo.Name
	If Right(ls_name, 2) = "_a" or Right(ls_name, 2) = "_t" Then
		ls_name = Left(ls_name, Len(ls_name) - 2)
		// if this is a dropdown, sort on display value not data value
		If this.Describe(ls_name + ".Edit.Style") = "dddw" Or &
			this.Describe(ls_name + ".Edit.CodeTable") = "yes" Then
			ls_name = "LookUpDisplay(" + ls_name + ")"
		End If
		ls_sort = ls_name + " A"
		If ls_sort = is_sort Then
			is_sort = ls_name + " D"
		Else
			is_sort = ls_sort
		End If
		this.SetSort(is_sort)
		this.Sort()
		this.Event RowFocusChanged(this.GetRow())
	End If
End If

// get out if user clicked in a non-row area
If row = 0 Then Return

end event

on u_base_datawindow.create
end on

on u_base_datawindow.destroy
end on

