$PBExportHeader$n_dwr_colors.sru
forward
global type n_dwr_colors from n_associated_ulong_srv
end type
end forward

shared variables

end variables

global type n_dwr_colors from n_associated_ulong_srv
end type
global n_dwr_colors n_dwr_colors

type prototypes
Function ulong GetSysColor(integer Index) Library "USER32.DLL"
Function long GetDC(long hWnd) library "user32.dll"
Function long GetDeviceCaps(long DC, long Index ) library "gdi32.dll"

end prototypes

type variables
public n_xls_workbook invo_writer

long   COLOR_SCROLLBAR = 0
long   COLOR_BACKGROUND = 1
long   COLOR_ACTIVECAPTION = 2
long   COLOR_INACTIVECAPTION = 3
long   COLOR_MENU = 4
long   COLOR_WINDOW = 5
long   COLOR_WINDOWFRAME = 6
long   COLOR_MENUTEXT = 7
long   COLOR_WINDOWTEXT = 8
long   COLOR_CAPTIONTEXT = 9
long   COLOR_ACTIVEBORDER = 10
long   COLOR_INACTIVEBORDER = 11
long   COLOR_APPWORKSPACE = 12
long   COLOR_HIGHLIGHT = 13
long   COLOR_HIGHLIGHTTEXT = 14
long   COLOR_BTNFACE = 15
long   COLOR_BTNSHADOW = 16
long   COLOR_GRAYTEXT = 17
long   COLOR_BTNTEXT = 18
long   COLOR_INACTIVECAPTIONTEXT = 19
long   COLOR_BTNHIGHLIGHT = 20
long   COLOR_3DDKSHADOW = 21
long   COLOR_3DLIGHT = 22
long   COLOR_INFOTEXT = 23
long   COLOR_INFOBK = 24
long   COLOR_HOTLIGHT = 26
long   COLOR_GRADIENTACTIVECAPTION = 27
long   COLOR_GRADIENTINACTIVECAPTION = 28

ulong clDelta =  2147483648

ulong   clScrollBar = 0 + 2147483648 
ulong   clBackground = 1 + 2147483648
ulong   clActiveCaption = 2 + 2147483648
ulong   clInactiveCaption = 3 + 2147483648
ulong   clMenu = 4 + 2147483648
ulong   clWindow = 5 + 2147483648
ulong   clWindowFrame = 6 + 2147483648
ulong   clMenuText = 7 + 2147483648
ulong   clWindowText = 8 + 2147483648
ulong   clCaptionText = 9 + 2147483648
ulong   clActiveBorder = 10 + 2147483648
ulong   clInactiveBorder = 11 + 2147483648
ulong   clAppWorkSpace = 12 + 2147483648
ulong   clHighlight = 13 + 2147483648
ulong   clHighlightText = 14 + 2147483648
ulong   clBtnFace = 15 + 2147483648
ulong   clBtnShadow = 16 + 2147483648
ulong   clGrayText = 17 + 2147483648
ulong   clBtnText = 18 + 2147483648
ulong   clInactiveCaptionText = 19 + 2147483648
ulong   clBtnHighlight = 20 + 2147483648
ulong   cl3DDkShadow = 21 + 2147483648
ulong   cl3DLight = 22 + 2147483648
ulong   clInfoText = 23 + 2147483648
ulong   clInfoBk = 24 + 2147483648

integer ii_bitsperpixel = 4
end variables

forward prototypes
public function integer of_get_custom_color_index (long al_color)
public function long of_get_color (long al_color)
end prototypes

public function integer of_get_custom_color_index (long al_color);ulong ll_index
integer li_red, li_green, li_blue

if truncate(al_color/16777216, 0) = 64 then return 65

ll_index = of_find_key(al_color)
if ll_index > 0 then
   return 64 - integer(ll_index)
else
   if of_get_keys_count() > (63 - 8) then
      return -1
   else
      ll_index = of_add_key(al_color)
      li_red = mod(al_color, 256)
      li_green = mod(truncate(al_color/256, 0), 256)
      li_blue = mod(truncate(al_color/(256 * 256), 0), 256)
      invo_writer.of_set_custom_color(64 - integer(ll_index), li_red, li_green, li_blue)
      return 64 - integer(ll_index)
   end if
end if

end function

public function long of_get_color (long al_color);long ll_mask = 16777216
long ll_col
boolean lb_sys = false

if al_color > ll_mask then
  ll_col = truncate(al_color/ll_mask, 0)
	choose case ll_col
		case 64
			al_color = clwindow
		case 2
			al_color = clwindowtext
		case 4
			al_color = clbtnface
		case 16
			al_color = clappworkspace
		case 8
			al_color = GetSysColor(al_color)
			lb_sys = true
	end choose
end if

if (al_color >= clDelta) and not(lb_sys) then
	return GetSysColor(al_color - clDelta)
else
	return al_color
end if
end function

on n_dwr_colors.create
TriggerEvent( this, "constructor" )
end on

on n_dwr_colors.destroy
TriggerEvent( this, "destructor" )
end on

