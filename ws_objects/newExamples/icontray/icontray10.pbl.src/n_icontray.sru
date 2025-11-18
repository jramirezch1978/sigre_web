$PBExportHeader$n_icontray.sru
$PBExportComments$Icon System Tray functions
forward
global type n_icontray from nonvisualobject
end type
type guid from structure within n_icontray
end type
type notifyicondata from structure within n_icontray
end type
type dllversioninfo from structure within n_icontray
end type
type point from structure within n_icontray
end type
end forward

type guid from structure
	long		data1
	integer		data2
	integer		data3
	character		data4[7]
end type

type notifyicondata from structure
	long		cbsize
	long		hwnd
	long		uid
	long		uflags
	long		ucallbackmessage
	long		hicon
	character		sztip[128]
	long		dwstate
	long		dwstatemask
	character		szinfo[256]
	long		utimeoutandversion
	character		szinfotitle[64]
	long		dwinfoflags
	guid		guiditem
end type

type dllversioninfo from structure
	unsignedlong		cbsize
	unsignedlong		dwmajorversion
	unsignedlong		dwminorversion
	unsignedlong		dwbuildnumber
	unsignedlong		dwplatformid
end type

type point from structure
	long		cx
	long		cy
end type

global type n_icontray from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean Shell_NotifyIcon ( &
	long dwMessage, &
	Ref notifyicondata pnid &
	) Library "shell32.dll" alias for "Shell_NotifyIcon;Ansi"

Function boolean SetForegroundWindow ( &
	ulong hWnd &
	) Library "user32.dll"

Function long LoadImage ( &
	long hInst, &
	string lpszName, &
	uint uType, &
	int cxDesired, &
	int cyDesired, &
	uint fuLoad &
	) Library "user32.dll" Alias For "LoadImageW"

Function long ExtractIcon ( &
	long hInst, &
	string lpszExeFileName, &
	uint nIconIndex &
	) Library "shell32.dll" Alias For "ExtractIconW"

Function boolean DestroyIcon ( &
	long hIcon &
	) Library "user32.dll"

Function boolean RegisterHotKey ( &
	ulong hWnd, &
	int id, &
	uint fsModifiers, &
	uint vk &
	) Library "user32.dll"

Function boolean UnregisterHotKey ( &
	ulong hWnd, &
	int id &
	) Library "user32.dll"

Function long DllGetVersion ( &
	Ref dllversioninfo pdvi &
	) Library "comctl32.dll" alias for "DllGetVersion;Ansi"

Function long LoadLibrary ( &
	string lpFileName &
	) Library "kernel32.dll" Alias For "LoadLibraryW"

Function boolean FreeLibrary ( &
	long hModule &
	) Library "kernel32.dll"

Function long GetProcAddress ( &
	long hModule, &
	string lpProcName &
	) Library "kernel32.dll" alias for "GetProcAddress;Ansi"

Function boolean GetCursorPos ( &
	Ref point lpPoint &
	) Library "user32.dll"

end prototypes

type variables
Long il_iconhandles[]
Long NOTIFYICONDATA_SIZE = 88
Long NOTIFYICON_VERSION = 1

// function constants

CONSTANT long NIF_MESSAGE	= 1
CONSTANT long NIF_ICON		= 2
CONSTANT long NIF_TIP		= 4
CONSTANT long NIF_STATE		= 8
CONSTANT long NIF_INFO		= 16

CONSTANT long NIM_ADD		= 0
CONSTANT long NIM_MODIFY	= 1
CONSTANT long NIM_DELETE	= 2
CONSTANT long NIM_SETFOCUS	= 3
CONSTANT long NIM_SETVERSION	= 4
CONSTANT long NIM_VERSION	= 5

CONSTANT long NIS_HIDDEN	= 1
CONSTANT long NIS_SHAREDICON	= 2

CONSTANT long NIIF_NONE		= 0
CONSTANT long NIIF_INFO		= 1
CONSTANT long NIIF_WARNING	= 2
CONSTANT long NIIF_ERROR	= 3
CONSTANT long NIIF_USER		= 4
CONSTANT long NIIF_GUID		= 5
CONSTANT long NIIF_ICON_MASK	= 15
CONSTANT long NIIF_NOSOUND	= 16

CONSTANT long WM_USER = 1024
CONSTANT long NIN_BALLOONSHOW			= WM_USER + 2
CONSTANT long NIN_BALLOONHIDE			= WM_USER + 3
CONSTANT long NIN_BALLOONTIMEOUT		= WM_USER + 4
CONSTANT long NIN_BALLOONUSERCLICK	= WM_USER + 5

CONSTANT ulong NOTIFYICONDATA_V1_SIZE = 88  // pre-5.0 structure size
CONSTANT ulong NOTIFYICONDATA_V2_SIZE = 488 // pre-6.0 structure size
CONSTANT ulong NOTIFYICONDATA_V3_SIZE = 504 // 6.0+ structure size

CONSTANT long ICON_SMALL	= 0
CONSTANT long ICON_BIG		= 1

CONSTANT uint IMAGE_BITMAP	= 0
CONSTANT uint IMAGE_ICON	= 1
CONSTANT uint IMAGE_CURSOR	= 2

CONSTANT uint LR_DEFAULTCOLOR		= 0
CONSTANT uint LR_MONOCHROME		= 1
CONSTANT uint LR_COLOR			= 2
CONSTANT uint LR_COPYRETURNORG	= 4
CONSTANT uint LR_COPYDELETEORG	= 8
CONSTANT uint LR_LOADFROMFILE		= 16
CONSTANT uint LR_LOADTRANSPARENT	= 32
CONSTANT uint LR_DEFAULTSIZE		= 64
CONSTANT uint LR_VGACOLOR		= 128
CONSTANT uint LR_LOADMAP3DCOLORS	= 4096
CONSTANT uint LR_CREATEDIBSECTION	= 8192
CONSTANT uint LR_COPYFROMRESOURCE	= 16384
CONSTANT uint LR_SHARED		= 32768

// windows messages
CONSTANT long WM_GETICON		= 127
CONSTANT long WM_MOUSEMOVE		= 512
CONSTANT long WM_LBUTTONDOWN	= 513
CONSTANT long WM_LBUTTONUP		= 514
CONSTANT long WM_LBUTTONDBLCLK	= 515
CONSTANT long WM_RBUTTONDOWN	= 516
CONSTANT long WM_RBUTTONUP		= 517
CONSTANT long WM_RBUTTONDBLCLK	= 518
CONSTANT long PBM_CUSTOM01		= 1024

// hotkey values
CONSTANT uint MOD_NONE	= 0
CONSTANT uint MOD_ALT		= 1
CONSTANT uint MOD_CONTROL	= 2
CONSTANT uint MOD_SHIFT	= 4
CONSTANT uint MOD_WIN		= 8
uint iui_keycode = 0
uint iui_modifier = 0

// virtual keycodes
CONSTANT uint KeyBack		= 8
CONSTANT uint KeyTab		= 9
CONSTANT uint KeyEnter		= 13
CONSTANT uint KeyShift		= 16
CONSTANT uint KeyControl		= 17
CONSTANT uint KeyAlt		= 18
CONSTANT uint KeyPause		= 19
CONSTANT uint KeyCapsLock	= 20
CONSTANT uint KeyEscape		= 27
CONSTANT uint KeySpaceBar	= 32
CONSTANT uint KeyPageUp		= 33
CONSTANT uint KeyPageDown	= 34
CONSTANT uint KeyEnd		= 35
CONSTANT uint KeyHome		= 36
CONSTANT uint KeyLeftArrow	= 37
CONSTANT uint KeyUpArrow		= 38
CONSTANT uint KeyRightArrow	= 39
CONSTANT uint KeyDownArrow	= 40
CONSTANT uint KeyPrintScreen	= 44
CONSTANT uint KeyInsert		= 45
CONSTANT uint KeyDelete		= 46
CONSTANT uint Key0	= 48
CONSTANT uint Key1	= 49
CONSTANT uint Key2	= 50
CONSTANT uint Key3	= 51
CONSTANT uint Key4	= 52
CONSTANT uint Key5	= 53
CONSTANT uint Key6	= 54
CONSTANT uint Key7	= 55
CONSTANT uint Key8	= 56
CONSTANT uint Key9	= 57
CONSTANT uint KeyA	= 65
CONSTANT uint KeyB	= 66
CONSTANT uint KeyC	= 67
CONSTANT uint KeyD	= 68
CONSTANT uint KeyE	= 69
CONSTANT uint KeyF	= 70
CONSTANT uint KeyG	= 71
CONSTANT uint KeyH	= 72
CONSTANT uint KeyI	= 73
CONSTANT uint KeyJ	= 74
CONSTANT uint KeyK	= 75
CONSTANT uint KeyL	= 76
CONSTANT uint KeyM	= 77
CONSTANT uint KeyN	= 78
CONSTANT uint KeyO	= 79
CONSTANT uint KeyP	= 80
CONSTANT uint KeyQ	= 81
CONSTANT uint KeyR	= 82
CONSTANT uint KeyS	= 83
CONSTANT uint KeyT	= 84
CONSTANT uint KeyU	= 85
CONSTANT uint KeyV	= 86
CONSTANT uint KeyW	= 87
CONSTANT uint KeyX	= 88
CONSTANT uint KeyY	= 89
CONSTANT uint KeyZ	= 90
CONSTANT uint KeyLeftWindows	= 91
CONSTANT uint KeyRightWindows	= 92
CONSTANT uint KeyApps		= 93
CONSTANT uint KeyNumPad0	= 96
CONSTANT uint KeyNumPad1	= 97
CONSTANT uint KeyNumPad2	= 98
CONSTANT uint KeyNumPad3	= 99
CONSTANT uint KeyNumPad4	= 100
CONSTANT uint KeyNumPad5	= 101
CONSTANT uint KeyNumPad6	= 102
CONSTANT uint KeyNumPad7	= 103
CONSTANT uint KeyNumPad8	= 104
CONSTANT uint KeyNumPad9	= 105
CONSTANT uint KeyMultiply		= 106
CONSTANT uint KeyAdd		= 107
CONSTANT uint KeySubtract		= 109
CONSTANT uint KeyDecimal		= 110
CONSTANT uint KeyDivide		= 111
CONSTANT uint KeyF1	= 112
CONSTANT uint KeyF2	= 113
CONSTANT uint KeyF3	= 114
CONSTANT uint KeyF4	= 115
CONSTANT uint KeyF5	= 116
CONSTANT uint KeyF6	= 117
CONSTANT uint KeyF7	= 118
CONSTANT uint KeyF8	= 119
CONSTANT uint KeyF9	= 120
CONSTANT uint KeyF10	= 121
CONSTANT uint KeyF11	= 122
CONSTANT uint KeyF12	= 123
CONSTANT uint KeyNumLock	= 144
CONSTANT uint KeyScrollLock	= 145
CONSTANT uint KeySemiColon	= 186
CONSTANT uint KeyEqual		= 187
CONSTANT uint KeyComma		= 188
CONSTANT uint KeyDash		= 189
CONSTANT uint KeyPeriod		= 190
CONSTANT uint KeySlash		= 191
CONSTANT uint KeyBackQuote	= 192
CONSTANT uint KeyLeftBracket	= 219
CONSTANT uint KeyBackSlash	= 220
CONSTANT uint KeyRightBracket	= 221
CONSTANT uint KeyQuote		= 222

end variables

forward prototypes
public subroutine of_setfocus (window aw_window)
public function boolean of_modify_icon (window aw_window, string as_imagename, unsignedinteger aui_index)
public function boolean of_modify_icon (window aw_window, string as_imagename)
public function boolean of_add_icon (window aw_window)
public function boolean of_add_icon (window aw_window, string as_imagename)
public function boolean of_add_icon (window aw_window, string as_imagename, unsignedinteger aui_index)
private function long of_loadimage (string as_filename, unsignedinteger aui_iconindex)
private function long of_loadimage (string as_imagename)
public function boolean of_modify_tip (window aw_window, string as_newtip)
public function boolean of_registerhotkey (window aw_window, integer ai_hotkeyid, unsignedinteger aui_modifier, unsignedinteger aui_keycode)
public function boolean of_unregisterhotkey (window aw_window, integer ai_hotkeyid)
public function boolean of_ishotkey (unsignedlong wparam, long lparam)
public function boolean of_delete_icon (window aw_window, boolean ab_show)
public function integer of_dllversion ()
public function boolean of_getpointerpos (ref long al_xpos, ref long al_ypos)
public function boolean of_balloon_tip (window aw_window, string as_title, string as_info, icon dwinfoflag)
public function boolean of_trayfocus ()
public function boolean of_balloon_tip (window aw_window, string as_title, string as_info)
end prototypes

public subroutine of_setfocus (window aw_window);// give window proper focus
SetForegroundWindow(Handle(aw_window))

end subroutine

public function boolean of_modify_icon (window aw_window, string as_imagename, unsignedinteger aui_index);// modify icon in the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_ICON
lstr_data.hIcon	= this.of_loadimage(as_imagename, aui_index)

If lstr_data.hIcon = 0 Then Return False

// modify icon in system tray
Return Shell_NotifyIcon(NIM_MODIFY, lstr_data)

end function

public function boolean of_modify_icon (window aw_window, string as_imagename);// modify icon in the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_ICON
lstr_data.hIcon	= this.of_loadimage(as_imagename)

// modify icon in system tray
Return Shell_NotifyIcon(NIM_MODIFY, lstr_data)

end function

public function boolean of_add_icon (window aw_window);// add window icon to the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_ICON + NIF_TIP + NIF_MESSAGE
lstr_data.uCallBackMessage	= PBM_CUSTOM01
lstr_data.hIcon	= Send(lstr_data.hWnd, WM_GETICON, ICON_SMALL, 0)
lstr_data.szTip	= aw_window.title

// add icon to system tray
If Shell_NotifyIcon(NIM_ADD, lstr_data) Then
	// make window invisible
	aw_window.Hide()
	Return True
Else
	Return False
End If

end function

public function boolean of_add_icon (window aw_window, string as_imagename);// add loaded icon to the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_ICON + NIF_TIP + NIF_MESSAGE
lstr_data.uCallBackMessage	= PBM_CUSTOM01
lstr_data.hIcon	= this.of_loadimage(as_imagename)
lstr_data.szTip	= aw_window.title

// add icon to system tray
If Shell_NotifyIcon(NIM_ADD, lstr_data) Then
	// make window invisible
	aw_window.Hide()
	Return True
Else
	Return False
End If

end function

public function boolean of_add_icon (window aw_window, string as_imagename, unsignedinteger aui_index);// add loaded icon to the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_ICON + NIF_TIP + NIF_MESSAGE
lstr_data.uCallBackMessage	= PBM_CUSTOM01
lstr_data.hIcon	= this.of_loadimage(as_imagename, aui_index)
lstr_data.szTip	= aw_window.title

If lstr_data.hIcon = 0 Then Return False

// add icon to system tray
If Shell_NotifyIcon(NIM_ADD, lstr_data) Then
	// make window invisible
	aw_window.Hide()
	Return True
Else
	Return False
End If

end function

private function long of_loadimage (string as_filename, unsignedinteger aui_iconindex);// load icon into memory from .exe or .dll file
// aui_iconindex is zero based (first icon is 0, second is 1)

Long ll_handle

// load icon
ll_handle = ExtractIcon(Handle(GetApplication()), as_filename, aui_iconindex)

// save handle for destroy in destructor event
If ll_handle > 0 Then
	il_iconhandles[UpperBound(il_iconhandles) + 1] = ll_handle
End If

Return ll_handle

end function

private function long of_loadimage (string as_imagename);// load image into memory from .ico, .cur or .ani file

Long ll_handle

CHOOSE CASE Lower(Right(as_imagename, 4))
	CASE ".ico"
		ll_handle = LoadImage(0, as_imagename, IMAGE_ICON, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE)
	CASE ".cur", ".ani"
		ll_handle = LoadImage(0, as_imagename, IMAGE_CURSOR, 0, 0, LR_LOADFROMFILE + LR_DEFAULTSIZE)
	CASE ELSE
END CHOOSE

Return ll_handle

end function

public function boolean of_modify_tip (window aw_window, string as_newtip);// modify window icon tip in the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_TIP
lstr_data.szTip	= as_newtip

// modify icon tip
Return Shell_NotifyIcon(NIM_MODIFY, lstr_data)

end function

public function boolean of_registerhotkey (window aw_window, integer ai_hotkeyid, unsignedinteger aui_modifier, unsignedinteger aui_keycode);// remember hotkey info
iui_keycode  = aui_keycode
iui_modifier = aui_modifier

// register a system wide hotkey
Return RegisterHotKey(Handle(aw_window), ai_hotkeyid, aui_modifier, aui_keycode)

end function

public function boolean of_unregisterhotkey (window aw_window, integer ai_hotkeyid);// unregister a system wide hotkey
Return UnregisterHotKey(Handle(aw_window), ai_hotkeyid)

end function

public function boolean of_ishotkey (unsignedlong wparam, long lparam);// return whether this is a WM_HOTKEY event
// called from window 'Other' event

If wparam = 1 Then
	If IntHigh(lparam) = iui_keycode Then
		If IntLow(lparam)  = iui_modifier Then
			Return True
		End If
	End If
End If

Return False

end function

public function boolean of_delete_icon (window aw_window, boolean ab_show);// delete window icon from the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1

If ab_show Then
	// make window visible
	aw_window.Show()
	// give the window primary focus
	this.of_SetFocus(aw_window)
End If

// remove icon from system tray
Return Shell_NotifyIcon(NIM_DELETE, lstr_data)

end function

public function integer of_dllversion ();// determine NOTIFYICONDATA version to use

DLLVERSIONINFO lstr_dvi
String ls_libname, ls_function
Long ll_rc, ll_module, ll_version

// default to original
ll_version = 1

ls_libname  = "comctl32.dll"
ls_function = "DllGetVersion"

ll_module = LoadLibrary(ls_libname)
If ll_module > 0 Then
	ll_rc = GetProcAddress(ll_module, ls_function)
	If ll_rc > 0 Then
		lstr_dvi.cbSize = 20
		ll_rc = DllGetVersion(lstr_dvi)
		CHOOSE CASE lstr_dvi.dwMajorVersion
			CASE 6
				ll_version = 3
			CASE 5
				ll_version = 2
			CASE ELSE
				ll_version = 1
		END CHOOSE
	End If
	FreeLibrary(ll_module)
End If

Return ll_version

end function

public function boolean of_getpointerpos (ref long al_xpos, ref long al_ypos);// this function returns the x/y location of the mouse pointer

POINT lstr_pos
Boolean lb_rtn

lb_rtn = GetCursorPos(lstr_pos)

al_xpos = PixelsToUnits(lstr_pos.cx - 34, XPixelsToUnits!)
al_ypos = PixelsToUnits(lstr_pos.cy - 65, YPixelsToUnits!)

Return lb_rtn

end function

public function boolean of_balloon_tip (window aw_window, string as_title, string as_info, icon dwinfoflag);// create balloon tip in the system tray
// Note: to close a balloon tip, call with as_info an empty string

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.uFlags	= NIF_INFO
lstr_data.szInfoTitle = as_title
lstr_data.szInfo	= as_info

Choose Case dwinfoflag
	Case StopSign!
		lstr_data.dwInfoFlags	= NIIF_ERROR
	Case Information!
		lstr_data.dwInfoFlags	= NIIF_INFO
	Case None!
		lstr_data.dwInfoFlags	= NIIF_NONE
	Case Exclamation!
		lstr_data.dwInfoFlags	= NIIF_WARNING
	Case Else
		lstr_data.dwInfoFlags	= NIIF_NONE
End Choose

// create balloon tip
Return Shell_NotifyIcon(NIM_MODIFY, lstr_data)

end function

public function boolean of_trayfocus ();// give focus to the system tray

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize = NOTIFYICONDATA_SIZE

// give focus to the system tray
Return Shell_NotifyIcon(NIM_SETFOCUS, lstr_data)

end function

public function boolean of_balloon_tip (window aw_window, string as_title, string as_info);// create balloon tip in the system tray using the window icon
// Note: to close a balloon tip, call with as_info an empty string

NOTIFYICONDATA lstr_data

// populate structure
lstr_data.cbSize	= NOTIFYICONDATA_SIZE
lstr_data.hWnd		= Handle(aw_window)
lstr_data.uID		= 1
lstr_data.szInfoTitle = as_title
lstr_data.szInfo	= as_info

// use the window icon
lstr_data.uFlags = NIF_INFO + NIF_ICON
lstr_data.dwInfoFlags = NIIF_USER
lstr_data.hIcon = Send(lstr_data.hWnd, WM_GETICON, ICON_SMALL, 0)

// create balloon tip
Return Shell_NotifyIcon(NIM_MODIFY, lstr_data)

end function

on n_icontray.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_icontray.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event destructor;Integer li_cnt, li_max

// destroy icon handles created by ExtractIcon function
li_max = UpperBound(il_iconhandles)
FOR li_cnt = 1 TO li_max
	DestroyIcon(il_iconhandles[li_cnt])
NEXT

end event

event constructor;// determine version of NOTIFYICONDATA to use

NOTIFYICON_VERSION = this.of_dllversion()

CHOOSE CASE NOTIFYICON_VERSION
	CASE 3
		NOTIFYICONDATA_SIZE = NOTIFYICONDATA_V3_SIZE
	CASE 2
		NOTIFYICONDATA_SIZE = NOTIFYICONDATA_V2_SIZE
	CASE ELSE
		NOTIFYICONDATA_SIZE = NOTIFYICONDATA_V1_SIZE
END CHOOSE

end event

