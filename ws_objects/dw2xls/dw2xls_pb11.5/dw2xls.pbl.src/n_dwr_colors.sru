$PBExportHeader$n_dwr_colors.sru
forward
global type n_dwr_colors from n_associated_ulong_srv
end type
end forward

global type n_dwr_colors from n_associated_ulong_srv
end type
global n_dwr_colors n_dwr_colors

type prototypes
FUNCTION ulong GetDC(ulong hwnd) LIBRARY "user32.dll"

FUNCTION ulong GetSysColor(ulong nIndex) LIBRARY "user32.dll"

FUNCTION ulong GetDeviceCaps(ulong hdc,ulong nIndex) LIBRARY "gdi32.dll"
end prototypes

type variables
PUBLIC n_xls_workbook invo_writer
PUBLIC LONG color_scrollbar

PUBLIC LONG color_background = 1
PUBLIC LONG color_activecaption = 2

PUBLIC LONG color_inactivecaption = 3
PUBLIC LONG color_menu = 4
PUBLIC LONG color_window = 5

PUBLIC LONG color_windowframe = 6
PUBLIC LONG color_menutext = 7

PUBLIC LONG color_windowtext = 8
PUBLIC LONG color_captiontext = 9

PUBLIC LONG color_activeborder = 10
PUBLIC LONG color_inactiveborder = 11

PUBLIC LONG color_appworkspace = 12
PUBLIC LONG color_highlight = 13

PUBLIC LONG color_highlighttext = 14
PUBLIC LONG color_btnface = 15
PUBLIC LONG color_btnshadow = 16

PUBLIC LONG color_graytext = 17
PUBLIC LONG color_btntext = 18

PUBLIC LONG color_inactivecaptiontext = 19
PUBLIC LONG color_btnhighlight = 20

PUBLIC LONG color_3ddkshadow = 21
PUBLIC LONG color_3dlight = 22

PUBLIC LONG color_infotext = 23
PUBLIC LONG color_infobk = 24

PUBLIC LONG color_hotlight = 26
PUBLIC LONG color_gradientactivecaption = 27
PUBLIC LONG color_gradientinactivecaption = 28

PUBLIC ULONG cldelta = 2147483648  
PUBLIC ULONG clscrollbar = 2147483648

PUBLIC ULONG clbackground = 2147483649
PUBLIC ULONG clactivecaption = 2147483650

PUBLIC ULONG clinactivecaption = 2147483651
PUBLIC ULONG clmenu = 2147483652

PUBLIC ULONG clwindow = 2147483653
PUBLIC ULONG clwindowframe = 2147483654

PUBLIC ULONG clmenutext = 2147483655

PUBLIC ULONG clwindowtext = 2147483656
PUBLIC ULONG clcaptiontext = 2147483657
PUBLIC ULONG clactiveborder = 2147483658

PUBLIC ULONG clinactiveborder = 2147483659
PUBLIC ULONG clappworkspace = 2147483660

PUBLIC ULONG clhighlight = 2147483661
PUBLIC ULONG clhighlighttext = 2147483662

PUBLIC ULONG clbtnface = 2147483663 
PUBLIC ULONG clbtnshadow = 2147483664

PUBLIC ULONG clgraytext = 2147483665
PUBLIC ULONG clbtntext = 2147483666

PUBLIC ULONG clinactivecaptiontext = 2147483667
PUBLIC ULONG clbtnhighlight = 2147483668
PUBLIC ULONG cl3ddkshadow = 2147483669

PUBLIC ULONG cl3dlight = 2147483670
PUBLIC ULONG clinfotext = 2147483671

PUBLIC ULONG clinfobk = 2147483672
PUBLIC INTEGER ii_bitsperpixel = 4

CONSTANT  ULONG  COLOR_WHITE=RGB(255,255,255)
CONSTANT  ULONG  COLOR_BLACK=0
CONSTANT  ULONG  COLOR_RED=255
CONSTANT  ULONG  COLOR_BLUE=RGB(0,0,255)
CONSTANT  ULONG  COLOR_GREEN=RGB(0,255,0) 
CONSTANT  ULONG  COLOR_SKY_BLUE=RGB(0, 204, 255) 

CONSTANT  UINT	  BLACK_INDEX=8
CONSTANT  UINT   WHITE_INDEX=9
CONSTANT  UINT	  RED_INDEX=10
CONSTANT  UINT   GREEN_INDEX  = 11 
CONSTANT  UINT   BLUE_INDEX=12 
CONSTANT  UINT   SKY_BLUE_INDEX = 40

//CONSTANT  UINT   

//CONSTANT  UINT   BLUE_INDEX= 
//CONSTANT  UINT   GREEN_INDEX=10 

CONSTANT  ULONG  COLOR_TRANSPARENT= 536870912 

end variables

forward prototypes
public function integer of_get_custom_color_index (long al_color)
public function long of_get_color (long al_color)
end prototypes

public function integer of_get_custom_color_index (long al_color);ulong ll_index
integer li_red
integer li_green
integer li_blue



IF al_Color=COLOR_TRANSPARENT Then  //透明
	Return 65
END IF 


IF al_Color=COLOR_BLACK THEN
	Return BLACK_INDEX
ELSEIF al_Color=COLOR_WHITE THEN
	Return WHITE_Index
	
ELSEIF al_Color=COLOR_RED Then
	Return RED_Index

ELSEIF al_Color=COLOR_BLUE Then
	 Return BLUE_INDEX
	 
ELSEIF  al_COLOR=COLOR_GREEN Then
	  Return GREEN_INDEX 
END IF 


ll_index = of_find_key(al_color)
if ll_index > 0 then
    return 64 - integer(ll_index)
elseif of_get_keys_count() > 63 - 8 then
    return -1
else
    ll_index = of_add_key(al_color)
    li_red = mod(al_color, 256)
    li_green = mod(truncate(al_color / 256 ,0  ),  256)
    li_blue = mod(truncate(al_color / ( 256 * 256), 0 ),  256)
    invo_writer.of_set_custom_color(64 - integer(ll_index), li_red, li_green, li_blue)
    return 64 - integer(ll_index)
end if



end function

public function long of_get_color (long al_color);//LONG ll_mask = 16777216
//LONG ll_col
//
//
//IF al_color > ll_mask THEN
//	ll_col = TRUNCATE(al_color / ll_mask, 0)
//	
//	CHOOSE CASE ll_col
//		CASE 64
//			al_color = clwindow
//		CASE 2
//			al_color = clwindowtext
//		CASE 4
//			al_color = clbtnface
//		CASE 16
//			al_color = clappworkspace
//	END CHOOSE
//	
//END IF
//
//IF al_color >= cldelta THEN
//	ll_col=  getsyscolor(al_color - cldelta)
//	
//	IF ll_Col<=0 Then
//		
//		Return COLOR_TRANSPARENT
//		
//	END IF
//	
//	Return ll_col 
//ELSE
//	RETURN al_color
//END IF
//


ULong ll_Index
IF al_Color<=COLOR_WHITE OR al_Color=COLOR_TRANSPARENT Then
	Return al_Color
END IF

IF al_color=67108864 Then
	 ll_Index=15
ELSEIF al_color=268435456 Then
	 ll_Index=12
ELSE 
    ll_Index=al_color - 134217728
END IF

al_Color= GetSysColor(ll_Index ) 
//IF al_Color<=0 Then
//	al_Color = COLOR_TRANSPARENT
//END IF

IF al_color<0  Then
	 al_color=0
END IF 

Return al_Color 

end function

on n_dwr_colors.create
call super::create
end on

on n_dwr_colors.destroy
call super::destroy
end on

