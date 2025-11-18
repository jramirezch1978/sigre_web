$PBExportHeader$n_dwr_colors.sru
$PBExportComments$By PBKiller v2.5.18(http://kivens.nease.net)
forward
global type n_dwr_colors from n_associated_ulong_srv
end type
end forward

global type n_dwr_colors from n_associated_ulong_srv
end type
global n_dwr_colors n_dwr_colors

type prototypes
public function ulong getsyscolor (integer index)  library "USER32.DLL" alias for "GetSysColor"
public function long getdc (long hwnd)  library "user32.dll" alias for "GetDC"
public function long getdevicecaps (long dc,long index)  library "gdi32.dll" alias for "GetDeviceCaps"
end prototypes

type variables
public n_xls_workbook invo_writer
public long color_scrollbar
public long color_background = 1
public long color_activecaption = 2
public long color_inactivecaption = 3
public long color_menu = 4
public long color_window = 5
public long color_windowframe = 6
public long color_menutext = 7
public long color_windowtext = 8
public long color_captiontext = 9
public long color_activeborder = 10
public long color_inactiveborder = 11
public long color_appworkspace = 12
public long color_highlight = 13
public long color_highlighttext = 14
public long color_btnface = 15
public long color_btnshadow = 16
public long color_graytext = 17
public long color_btntext = 18
public long color_inactivecaptiontext = 19
public long color_btnhighlight = 20
public long color_3ddkshadow = 21
public long color_3dlight = 22
public long color_infotext = 23
public long color_infobk = 24
public long color_hotlight = 26
public long color_gradientactivecaption = 27
public long color_gradientinactivecaption = 28
public ulong cldelta = 2147483648
public ulong clscrollbar = 2147483648
public ulong clbackground = 2147483649
public ulong clactivecaption = 2147483650
public ulong clinactivecaption = 2147483651
public ulong clmenu = 2147483652
public ulong clwindow = 2147483653
public ulong clwindowframe = 2147483654
public ulong clmenutext = 2147483655
public ulong clwindowtext = 2147483656
public ulong clcaptiontext = 2147483657
public ulong clactiveborder = 2147483658
public ulong clinactiveborder = 2147483659
public ulong clappworkspace = 2147483660
public ulong clhighlight = 2147483661
public ulong clhighlighttext = 2147483662
public ulong clbtnface = 2147483663
public ulong clbtnshadow = 2147483664
public ulong clgraytext = 2147483665
public ulong clbtntext = 2147483666
public ulong clinactivecaptiontext = 2147483667
public ulong clbtnhighlight = 2147483668
public ulong cl3ddkshadow = 2147483669
public ulong cl3dlight = 2147483670
public ulong clinfotext = 2147483671
public ulong clinfobk = 2147483672
public integer ii_bitsperpixel = 4
end variables

forward prototypes
public function long of_get_color (long al_color)
public function integer of_get_custom_color_index (long al_color)
end prototypes

public function long of_get_color (long al_color);long ll_mask = 16777216
long ll_col
boolean lb_sys = false

if al_color > ll_mask then
	ll_col = truncate(al_color / ll_mask,0)

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
			al_color = getsyscolor(al_color)
			lb_sys = true
	end choose

end if

if al_color >= cldelta and ( not lb_sys) then
	return getsyscolor(al_color - cldelta)
else
	return al_color
end if
end function

public function integer of_get_custom_color_index (long al_color);ulong ll_index
integer li_red
integer li_green
integer li_blue

if truncate(al_color / 16777216,0) = 64 then
	return 65
end if

ll_index = of_find_key(al_color)

if ll_index > 0 then
	return (64 - integer(ll_index))
else

	if of_get_keys_count() > 63 - 8 then
		return -1
	else
		ll_index = of_add_key(al_color)
		li_red = mod(al_color,256)
		li_green = mod(truncate(al_color / 256,0),256)
		li_blue = mod(truncate(al_color / (256 * 256),0),256)
		invo_writer.of_set_custom_color(64 - integer(ll_index),li_red,li_green,li_blue)
		return (64 - integer(ll_index))
	end if

end if
end function

on n_dwr_colors.create
triggerevent("constructor")
end on

on n_dwr_colors.destroy
triggerevent("destructor")
end on

