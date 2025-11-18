$PBExportHeader$n_cst_api.sru
$PBExportComments$Funciones API del Sistema Operativo
forward
global type n_cst_api from nonvisualobject
end type
end forward

global type n_cst_api from nonvisualobject
end type
global n_cst_api n_cst_api

type prototypes
FUNCTION boolean GetUserNameA( ref string userID, ref ulong len ) library "ADVAPI32.DLL" alias for "GetUserNameA;Ansi"
FUNCTION boolean CopyFileA( ref string cfrom, ref string cto, boolean flag ) library "kernel32.dll" alias for "CopyFileA;Ansi"
FUNCTION boolean DeleteFileA( ref string filename ) library "kernel32.dll" alias for "DeleteFileA;Ansi"
Function boolean sndPlaySoundA( string SoundName, uint Flags ) Library "WINMM.DLL" alias for "sndPlaySoundA;Ansi"
Function uint waveOutGetNumDevs() Library "WINMM.DLL"
Function boolean GetComputerName (ref string  lpBuffer, ref ulong nSize) Library "KERNEL32.DLL" Alias for "GetComputerNameA;Ansi"
Function ulong GetCurrentDirectory (ulong nBufferLength, ref string lpBuffer) Library "KERNEL32.DLL" Alias for "GetCurrentDirectoryA;Ansi"
Function boolean Beep (ulong dwFreq, ulong dwDuration) Library "KERNEL32.DLL" 
Function boolean SetCurrentDirectory (ref string lpPathName) Library "KERNEL32.DLL" Alias for "SetCurrentDirectoryA;Ansi"
Function boolean CreateDirectory (ref string lpPathName, ref ulong lnull) Library "KERNEL32.DLL"  Alias for "CreateDirectoryA;Ansi"
Function boolean GetDiskFreeSpace (ref string lpRootPathName, ref ulong lpSectorsPerCluster, ref ulong lpBytesPerSector, ref ulong lpNumberOfFreeClusters, ref ulong lpTotalNumberOfClusters) Library "KERNEL32.DLL" Alias for "GetDiskFreeSpaceA;Ansi"
Function uint GetDriveType (ref string lpRootPathName) Library "KERNEL32.DLL" Alias for "GetDriveTypeA;Ansi"
Function ulong GetFileAttributes (ref string lpFileName) Library "KERNEL32.DLL" Alias for "GetFileAttributesA;Ansi"
function boolean SetKeyboardState( char lpKeyState[256] ) library 'user32.dll' alias for "SetKeyboardState;Ansi"
function boolean GetKeyboardState( REF char lpKeyState[256] ) library 'user32.dll' alias for "GetKeyboardState;Ansi"
function ulong MapVirtualKeyA(ulong uCode, ulong uMapType ) library 'user32.dll'
function ulong CreateMutexA(ulong lpMutexAttributes,int bInitialOwner,ref string lpName) library "kernel32.dll" alias for "CreateMutexA;Ansi"
function ulong GetLastError() library "kernel32.dll"



end prototypes

forward prototypes
public function string of_get_user ()
public function string of_get_work_station ()
public function string of_get_directory ()
public function boolean of_file_delete (string as_file)
public function boolean of_file_copy (string as_origin, string as_target)
public function boolean of_directory_create (string as_directory)
public function boolean of_play_ding (unsignedlong ai_freq, unsignedlong ai_dur)
public function boolean of_set_directory (string as_directory)
public function boolean of_get_drive_space (string as_drive, ref long al_total_space, ref long al_free_space)
public function boolean of_copy_file (string as_origin, string as_target)
public function boolean of_play_wav (string as_file)
public function boolean of_get_key_status (integer ai_key)
public function integer of_set_key_status (integer ai_key, boolean ab_switch)
public function integer of_set_key (integer ai_key)
public function integer of_set_key_caps ()
public function integer of_set_key_numlock ()
public subroutine of_close_app_duplicada (string as_app_name)
end prototypes

public function string of_get_user ();string  ls_temp 
ulong   lul_value
boolean lb_rc

lul_value = 255
ls_temp = Space( 255 )
lb_rc = GetUserNameA( ls_temp, lul_value )

RETURN Trim( ls_temp )

end function

public function string of_get_work_station ();string  ls_temp 
ulong   lul_value
boolean lb_rc

lul_value = 255
ls_temp = Space( 255 )
lb_rc = GetComputerName( ls_temp, lul_value )

RETURN Trim( ls_temp )
end function

public function string of_get_directory ();string  ls_temp 
ulong   lul_value, lul_rc

lul_value = 255
ls_temp = Space( 255 )
lul_rc = GetCurrentDirectory( lul_value, ls_temp )

RETURN Trim( ls_temp )
end function

public function boolean of_file_delete (string as_file);boolean lb_rc


lb_rc = DeleteFileA( as_file )

RETURN lb_rc
end function

public function boolean of_file_copy (string as_origin, string as_target);boolean lb_rc, lb_flag

lb_rc = CopyFileA( as_origin, as_target, lb_flag )

RETURN lb_rc
end function

public function boolean of_directory_create (string as_directory);string  ls_temp 
ulong   lul_value
boolean lb_rc

lul_value = 255
ls_temp = Space( 255 )
ls_temp = as_directory
lb_rc = CreateDirectory( ls_temp, lul_value )

RETuRN lb_rc
end function

public function boolean of_play_ding (unsignedlong ai_freq, unsignedlong ai_dur);ulong   lul_freq, lul_duration
boolean lb_rc

lul_freq = 255
lul_duration = 255

lul_freq = ai_freq
lul_duration = ai_dur

lb_rc = Beep( lul_freq, lul_duration )

RETURN lb_rc
end function

public function boolean of_set_directory (string as_directory);string  ls_temp 
boolean lb_rc

ls_temp = Space( 255 )
ls_temp = as_directory
lb_rc = SetCurrentDirectory( ls_temp )

RETURN lb_rc
end function

public function boolean of_get_drive_space (string as_drive, ref long al_total_space, ref long al_free_space);ULong ll_sectors_cluster, ll_bytes_sector, ll_free_clusters, ll_total_clusters, ll_bytes_cluster
Boolean lb_rc

lb_rc = GetDiskFreeSpace(as_drive, ll_sectors_cluster, ll_bytes_sector, ll_free_clusters, ll_total_clusters)

ll_bytes_cluster = ll_bytes_sector * ll_sectors_cluster

al_free_space = ll_bytes_cluster * ll_free_clusters

al_total_space = ll_bytes_cluster * ll_total_clusters

RETURN lb_rc
end function

public function boolean of_copy_file (string as_origin, string as_target);boolean lb_rc, lb_flag

lb_rc = CopyFileA( as_origin, as_target, lb_flag )

RETURN lb_rc
end function

public function boolean of_play_wav (string as_file);uint lui_NumDevs

lui_NumDevs = WaveOutGetNumDevs()

IF lui_NumDevs > 0 THEN
    sndPlaySoundA( as_file, 1 )
END IF

RETURN true
end function

public function boolean of_get_key_status (integer ai_key);char ls_key[256]

GetKeyboardState( ls_key )

return ( ls_key[ai_key + 1] = char(1) )

end function

public function integer of_set_key_status (integer ai_key, boolean ab_switch);char ls_key[256]

GetKeyboardState( ls_key )

if ab_switch then
	ls_key[ai_key + 1] = char(1)
else
	ls_key[ai_key + 1] = char(0)
end if

SetKeyboardState( ls_key )

return 1

end function

public function integer of_set_key (integer ai_key);
of_Set_Key_status(ai_key, NOT of_Get_Key_status(ai_key))

Return ai_key

//LBUTTON        = 1
//RBUTTON        = 2
//CANCEL         = 3
//MBUTTON        = 4 
//BACK           = 8
//TAB            = 9
//SHIFT          = 10
//CLEAR          = 12
//RETURN         = 13
//CONTROL        = 17
//MENU           = 18
//PAUSE          = 19
//CAPITAL        = 20
//EsCAPE         = 27
//SPACE          = 32
//PRIOR          = 33
//NEXT           = 34
//END            = 35
//HOME           = 36
//LEFT           = 37
//UP             = 38
//RIGHT          = 39
//DOWN           = 40
//SELECT         = 41
//PRINT          = 42
//EXECUTE        = 43
//SNAPSHOT       = 44
//INSERT         = 45
//DELETE         = 46
//HELP           = 47

/* VK_0 thru VK_9 are the same as ASCII '0' thru '9' (= 30 - = 39) */
/* VK_A thru VK_Z are the same as ASCII 'A' thru 'Z' (= 41 - = 5A) */

//LWIN           = 91
//RWIN           = 92
//APPS           = 93
//NUMPAD0        = 96
//NUMPAD1        = 97
//NUMPAD2        = 98
//NUMPAD3        = 99
//NUMPAD4        = 100
//NUMPAD5        = 101
//NUMPAD6        = 102
//NUMPAD7        = 103
//NUMPAD8        = 104
//NUMPAD9        = 105
//MULTIPLY       = 106
//ADD            = 107
//SEPARATOR      = 108
//SUBTRACT       = 109
//DECIMAL        = 110
//DIVIDE         = 111
//F1             = 112
//F2             = 113
//F3             = 114
//F4             = 115
//F5             = 116
//F6             = 117
//F7             = 118
//F8             = 119
//F9             = 120
//F10            = 121
//F11            = 122
//F12            = 123
//F13            = 124
//F14            = 125
//F15            = 126
//F16            = 127
//F17            = 128
//F18            = 129
//F19            = 130
//F20            = 131
//F21            = 132
//F22            = 133
//F23            = 134
//F24            = 135
//NUMLOCK        = 144
//SCROLL         = 145


end function

public function integer of_set_key_caps ();CONSTANT integer VK_CAPITAL        = 20
Integer li_rc

li_rc = of_Set_Key(vk_capital)

RETURN li_rc
end function

public function integer of_set_key_numlock ();CONSTANT integer VK_NUMLOCK        = 144
Integer li_rc

li_rc = of_Set_Key(vk_numlock)

RETURN li_rc

end function

public subroutine of_close_app_duplicada (string as_app_name);// Verifica si aplicacion ya esta en uso  
ulong ll_mutex, ll_error
String ls_mutex_name
	
IF handle(GetApplication(), FALSE) <> 0 THEN
	ls_mutex_name = as_app_name + char(0)
	ll_mutex = CreateMutexA(0,0,ls_mutex_name)
	ll_error = GEtLastError()
		
	IF ll_error = 183 THEN
	   Messagebox("Aviso", "Aplicacion ya esta Ejecutandose", Information!)
		HALT
	END IF
END IF
end subroutine

on n_cst_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

