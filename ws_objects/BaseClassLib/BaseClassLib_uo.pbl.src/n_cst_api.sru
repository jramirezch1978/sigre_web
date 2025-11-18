$PBExportHeader$n_cst_api.sru
$PBExportComments$Funciones API del Sistema Operativo
forward
global type n_cst_api from nonvisualobject
end type
type wsadatatype from structure within n_cst_api
end type
end forward

type WSADATAType from structure
	integer		wversion
	integer		wHighVersion
	byte		szDescription[256]
	byte		szSystemStatus[128]
	integer		iMaxSockets
	integer		iMaxUdpDg
	Long		lpszVendorInfo
end type

global type n_cst_api from nonvisualobject
end type
global n_cst_api n_cst_api

type prototypes
FUNCTION boolean GetUserNameA( ref byte userID[256], ref ulong len ) library "ADVAPI32.DLL"
FUNCTION boolean CopyFileA( ref string cfrom, ref string cto, boolean flag ) library "kernel32.dll"
FUNCTION boolean DeleteFileA( ref string filename ) library "kernel32.dll"
Function boolean sndPlaySoundA( string SoundName, uint Flags ) Library "WINMM.DLL"
Function uint waveOutGetNumDevs() Library "WINMM.DLL"
Function boolean GetComputerName (ref byte lpBuffer[255], ref ulong nSize) Library "KERNEL32.DLL" Alias for "GetComputerNameA"
Function ulong GetCurrentDirectory (ulong nBufferLength, ref string lpBuffer) Library "KERNEL32.DLL" Alias for "GetCurrentDirectoryA"
Function boolean Beep (ulong dwFreq, ulong dwDuration) Library "KERNEL32.DLL" 
Function boolean SetCurrentDirectory (ref string lpPathName) Library "KERNEL32.DLL" Alias for "SetCurrentDirectoryA"
Function boolean CreateDirectory (ref string lpPathName, ref ulong lnull) Library "KERNEL32.DLL"  Alias for "CreateDirectoryA"
Function boolean GetDiskFreeSpace (ref string lpRootPathName, ref ulong lpSectorsPerCluster, ref ulong lpBytesPerSector, ref ulong lpNumberOfFreeClusters, ref ulong lpTotalNumberOfClusters) Library "KERNEL32.DLL" Alias for "GetDiskFreeSpaceA"
Function uint GetDriveType (ref string lpRootPathName) Library "KERNEL32.DLL" Alias for "GetDriveTypeA"
Function ulong GetFileAttributes (ref string lpFileName) Library "KERNEL32.DLL" Alias for "GetFileAttributesA"
function boolean SetKeyboardState( char lpKeyState[256] ) library 'user32.dll'
function boolean GetKeyboardState( REF char lpKeyState[256] ) library 'user32.dll'
function ulong MapVirtualKeyA(ulong uCode, ulong uMapType ) library 'user32.dll'
function ulong CreateMutexA(ulong lpMutexAttributes,int bInitialOwner,ref string lpName) library "kernel32.dll"
function ulong GetLastError() library "kernel32.dll"
//Api para reiniciar el equipo
Function ulong ExitWindowsEx(Long uFlags, Long dwReserved) Library "user32.dll"
//Api para buscar un ventana en el sistema operativo
Function uLong FindWindow(byte lpClassName[256], byte lpWindowName[256]) Library "user32.dll"

//Apis para obtener el IP
function int WSAStartup( uint UIVersionRequested, ref str_WSAData lpWSAData ) library "wsock32.dll" alias for "WSAStartup;ansi"
function int WSACleanup() library "wsock32.dll" 
function int WSAGetLastError ( ) library "wsock32.dll" 
function int gethostname ( ref string name, int namelen ) library "wsock32.dll" alias for "gethostname;ansi"
function string GetHost(string lpszhost, ref blob lpszaddress ) library "pbws32.dll" alias for "GetHost;ansi"

end prototypes

type variables
Public:
constant Long EWX_LOGOFF = 0
constant Long EWX_SHUTDOWN = 1
constant Long EWX_REBOOT = 2
constant Long EWX_FORCE = 4

Private:
Constant Long WSADescription_Len = 256
Constant Long WSASYS_Status_Len = 128
n_cst_errorlogging invo_log



end variables

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
public subroutine of_close_app_duplicada (n_cst_app_obj anvo_app)
public function integer of_exitwindows ()
public subroutine of_obteneriplocal (ref string as_ip_address[])
public function string of_getipaddress ()
end prototypes

public function string of_get_user ();byte  lby_dato[256]
String ls_temp
ulong   lul_len
boolean lb_rc
integer i

lul_len = UpperBound(lby_dato)
lb_rc = GetUserNameA( lby_dato, lul_len )

if lul_len > 0 then
	ls_temp = ""
	
	for i = 1 to integer(lul_len)
		ls_temp += string(char(lby_dato[i]))
	next
else
	ls_temp = ""
end if

RETURN Trim( ls_temp )

end function

public function string of_get_work_station ();byte  lby_dato[255]
String ls_temp
ulong   lul_len
boolean lb_rc
integer i

lul_len = UpperBound(lby_dato)
lb_rc = GetComputerName( lby_dato, lul_len )

if lul_len > 0 then
	ls_temp = ""
	
	for i = 1 to integer(lul_len)
		ls_temp += string(char(lby_dato[i]))
	next
else
	ls_temp = ""
end if

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

public subroutine of_close_app_duplicada (n_cst_app_obj anvo_app);// Verifica si aplicacion ya esta en uso  
ulong ll_mutex, ll_error
String ls_mutex_name, ls_appName, ls_mensaje
n_cst_errorlogging lnvo_log

ls_appName = anvo_app.is_AppName
lnvo_log = CREATE n_cst_errorlogging
	
IF handle(GetApplication(), FALSE) <> 0 THEN
	ls_mutex_name = ls_appName + char(0)
	ll_mutex = CreateMutexA(0,0,ls_mutex_name)
	ll_error = GetLastError()
		
	IF ll_error = 183 THEN
		ls_mensaje = "Aplicacion " + ls_appName + " ya esta Ejecutandose"
		lnvo_log.of_errorlog(ls_mensaje )
	 	Messagebox(anvo_app.is_TitleMessageBox , ls_mensaje , Information!)
		destroy lnvo_log
		HALT
	end if
else
	lnvo_log.of_Tracelog("Aplicación " + ls_appName + " se ejecuta por primera vez")
END IF

destroy lnvo_log
end subroutine

public function integer of_exitwindows ();Long lc_ret
lc_ret = ExitWindowsEx(EWX_FORCE + EWX_REBOOT, 0)

return lc_ret
end function

public subroutine of_obteneriplocal (ref string as_ip_address[]);//string 	hostname = space(256), ips
//Long 		hostent_addr, hostip_addr, ipl, len
//Integer 	x
//
//HostEnt 	host
//str_addr ad
//
//If Not (this.of_StartWinsock()) Then 
//	return
//end if
//
//
//If gethostname(hostname, 256) = -1 Then
//	return
//End If
//
//hostent_addr = gethostbyname(hostname)
//
//If hostent_addr = 0 Then return
//len = 36
//MemCopy(Host, hostent_addr, len)
//MemCopy(hostip_addr, Host.h_addr_list, Host.h_length)
//
//Do
//
//MemCopy( ad.s_addr, hostip_addr, Host.h_length)
//ipl = inet_ntoa(ad.s_addr)
//
//ips = String$(lstrlen(ipl) + 1, 0)
//lstrcpy ips, ipl
//
//ip_address(x) = ips
//
//Host.h_addr_list = Host.h_addr_list + LenB(Host.h_addr_list)
//MemCopy hostip_addr, Host.h_addr_list, Host.h_length
//
//x = x + 1
//Loop While (hostip_addr <> 0)
//
//NombreEqu = hostname
//
//of_EndWinsock()
//End Function
end subroutine

public function string of_getipaddress ();/* Primero, declaramos todas las variables que necesitamos*/ 
str_wsadata lstr_WSAData
 
string ls_HostName = space(128)
string ls_IpAddress, ls_mensaje
int li_version = 257 
blob		lbl_HostAddress  

/* Entonces creamos una sesión, basada en la versión winsock. Este número de versión consiste en dos partes, un número de revisión mayor y otro menor, ambos representados en un byte. Así, la versión 1.1 nos dá un número entero de versión de 257 (256 + 1). */ 
IF wsastartup ( li_version, lstr_WSAData ) = 0 THEN 
	/* La estructura wsadata contiene mucha información. El elemento Descripción nos dice la versión de winsock*/ 
	invo_log.of_Tracelog("Winsock Version: " + lstr_WSAData.description )
	/* Ahora, averiguemos el hostname de la máquina sobre la que estamos trabajando*/
	IF gethostname ( ls_HostName, len(ls_HostName) ) < 0 THEN
		ls_mensaje ="GetHostName: " + string(WSAGetLastError())
		invo_log.of_errorlog(ls_mensaje)
		gnvo_app.of_showmessagedialog( ls_mensaje )
	ELSE
		/* Con el hostname, se llama a la función DLL y traza los punteros de la dirección IP a una variable de tipo Blob de Powerbuilder, con una longitud de 4 bytes.Esto se hace porque la estructura interna contiene 4 punteros, cada puntero apunta a una de las partes de la dirección IP. Una dirección IP consta de 4 bytes. */ 
		//Messagebox("Hostname", ls_HostName)
		GetHost(ls_HostName, lbl_HostAddress)
		/*Se convierten los punteros a escalares, y se concatenan tosos en una cadena , la dirección IP*/
		ls_IpAddress  = string(asc(string(BlobMid(lbl_HostAddress,1,1), Encodingansi!)),"") + "."
		ls_IpAddress += string(asc(string(BlobMid(lbl_HostAddress,2,1), Encodingansi!)),"") + "."
		ls_IpAddress += string(asc(string(BlobMid(lbl_HostAddress,3,1), Encodingansi!)),"") + "."
		ls_IpAddress += string(asc(string(BlobMid(lbl_HostAddress,4,1), Encodingansi!)),"")
		//Messagebox("Ip Address", ls_IpAddress )
	END IF
 
	/* Una vez que hemos terminado, limpiamos el lío que hemos hecho*/
	WSACleanup()
 
ELSE 
	ls_mensaje ="GetHostName: " + string(WSAGetLastError())
	invo_log.of_Errorlog(ls_mensaje)
	gnvo_app.of_showmessagedialog( ls_mensaje )
END IF  

return ls_IpAddress
end function

on n_cst_api.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_api.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_log = create n_cst_errorlogging
end event

event destructor;destroy invo_log
end event

