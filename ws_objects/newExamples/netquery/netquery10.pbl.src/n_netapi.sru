$PBExportHeader$n_netapi.sru
$PBExportComments$Network API functions
forward
global type n_netapi from nonvisualobject
end type
type netresource from structure within n_netapi
end type
end forward

type netresource from structure
	unsignedlong		scope
	unsignedlong		dwtype
	unsignedlong		dwdisplaytype
	unsignedlong		dwusage
	string		lplocalname
	string		lpremotename
	string		lpcomment
	string		lpprovider
end type

global type n_netapi from nonvisualobject autoinstantiate
end type

type prototypes
Function ulong CopyMemory( &
	ref ulong dest, &
	ulong source, &
	ulong size &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function ulong NetApiBufferFree( &
	ref ulong buffer &
	) Library "netapi32.dll"

Function ulong NetGetDCName( &
	string servername, &
	string domainname, &
	ref ulong bufptr &
	) Library "netapi32.dll" Alias for "NetGetDCName"

Function boolean GetComputerName( &
	ref string buffer, &
	ref ulong buflen &
	) Library "kernel32.dll" Alias For "GetComputerNameW"

Function uint GetDriveType ( &
	string lpBuffer &
	) Library "kernel32.dll" Alias For "GetDriveTypeW"

Function ulong NetMessageBufferSend( &
	string servername, &
	string msgname, &
	string fromname, &
	string buf, &
	ulong buflen &
	) Library "netapi32.dll" Alias for "NetMessageBufferSend"

Function ulong NetQueryDisplayInformation( &
	string server, &
	ulong level, &
	ulong index, &
	ulong entriesrequested, &
	ulong prefmaxlen, &
	ref ulong entrycount, &
	ref ulong bufptr &
	) Library "netapi32.dll" Alias for "NetQueryDisplayInformation"

Function ulong NetServerEnum( &
	string servername, &
	ulong level, &
	ref ulong bufptr, &
	long prefmaxlen, &
	ref ulong entriesread, &
	ref ulong totalentries, &
	ulong servertype, &
	string domain, &
	ref ulong resume_handle &
	) Library "netapi32.dll" Alias for "NetServerEnum"

Function ulong NetSessionEnum( &
	string servername, &
	string UncClientName, &
	string username, &
	ulong level, &
	ref ulong bufptr, &
	ulong prefmaxlen, &
	ref ulong entriesread, &
	ref ulong totalentries, &
	ref ulong resume_handle &
	) Library "netapi32.dll" Alias for "NetSessionEnum"

Function ulong NetUserGetInfo( &
	string servername, &
	string username, &
	ulong level, &
	ref ulong bufptr &
	) Library "netapi32.dll" Alias for "NetUserGetInfo"

Function ulong NetWkstaGetInfo( &
	string servername, &
	ulong level, &
	ref ulong bufptr &
	) Library "netapi32.dll" Alias for "NetWkstaGetInfo"

Function ulong NetWkstaUserEnum( &
	string servername, &
	ulong level, &
	ref ulong bufptr, &
	long prefmaxlen, &
	ref ulong entriesread, &
	ref ulong totalentries, &
	ref ulong resume_handle &
	) Library "netapi32.dll" Alias for "NetWkstaUserEnum"

Function ulong WNetAddConnection2 ( &
	netresource lpNetResource, &
	string lpPassword, &
	string lpUsername, &
	long dwFlags &
	) Library "mpr.dll" Alias For "WNetAddConnection2W"

Function ulong WNetCancelConnection2 ( &
	string lpName, &
	long dwFlags, &
	boolean fForce &
	) Library "mpr.dll" Alias For "WNetCancelConnection2W"

Function ulong WNetGetConnection ( &
	string lpszLocalName, &
	ref string lpszRemoteName, &
	ref ulong buflen &
	) Library "mpr.dll" Alias For "WNetGetConnectionW"

Function ulong WNetGetUser( &
	string lpname, &
	ref string lpusername, &
	ref ulong buflen &
	) Library "mpr.dll" Alias For "WNetGetUserW"

end prototypes

type variables
CONSTANT ulong NO_ERROR = 0
CONSTANT ulong NERR_Success = 0
CONSTANT ulong ERROR_MORE_DATA = 234
CONSTANT long MAX_PREFERRED_LENGTH = -1

end variables

forward prototypes
public function string of_netgetdcname (string as_domain)
public function string of_formatmessage (unsignedlong aul_error)
public function string of_netquerydisplayinformation (string as_server, integer ai_level, integer ai_flag)
public function string of_wnetgetuser ()
public function string of_get_userid ()
public function unsignedlong of_getpointer (unsignedlong aul_baseptr, integer ai_ptrnum, integer ai_arraynum, integer ai_ptrcnt)
public function boolean of_getbit (unsignedlong aul_number, integer ai_bit)
public function string of_getcomputername ()
public function unsignedinteger of_getdrivetype (string as_drive)
public function boolean of_netmessagebuffersend (string as_sendto, string as_msgtext)
public function string of_netsessionenum (string as_server)
public function string of_wnetgetconnection (string as_drive)
public function string of_whatdriveshare (string as_share)
public function boolean of_wnetcancelconnection2 (string as_drive)
public function boolean of_wnetaddconnection2 (string as_local, string as_remote, boolean ab_reconnect)
public function boolean of_netwkstagetinfo (ref string as_computername, ref string as_langroup, ref integer ai_osmajor, ref integer ai_osminor)
public function string of_netserverenum (string as_domain, unsignedlong aul_svrtype)
public function string of_netwkstauserenum (string as_server)
public function boolean of_netusergetinfo (string as_server, string as_username, ref string as_fullname, ref string as_comment)
public function boolean of_finduser (string as_server, string as_username, ref string as_computer[])
public function boolean of_whosecomputer (string as_server, string as_computer, string as_username)
end prototypes

public function string of_netgetdcname (string as_domain);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetGetDCName
//
// PURPOSE:		This function returns the name of the domain controller
//					that the current user was logged on by.
//
// ARGUMENTS:	as_domain - Network domain name (or blank for current)
//
// RETURN:		Machine name of domain controller
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

String ls_server, ls_dcname, ls_msg
ULong lul_result, lul_ptr

// call function to get DC name
lul_result = NetGetDCName(ls_server, as_domain, lul_ptr)

If lul_result = NERR_Success Then
	// get string from buffer
	ls_dcname = String(lul_ptr, "ADDRESS")
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetGetDCName Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

// free buffer
NetAPIBufferFree(lul_ptr)

Return ls_dcname

end function

public function string of_formatmessage (unsignedlong aul_error);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_FormatMessage
//
// PURPOSE:		This function returns the error text that goes
//					with the error code.
//
// ARGUMENTS:	aul_error - System error code
//
// RETURN:		System error message text
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_buffer
ULong lul_rtn, lul_nsize

lul_nsize = 200
ls_buffer = Space(lul_nsize)

lul_rtn = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
				aul_error, LANG_NEUTRAL, ls_buffer, lul_nsize, 0)

Return ls_buffer

end function

public function string of_netquerydisplayinformation (string as_server, integer ai_level, integer ai_flag);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetQueryDisplayInformation
//
// PURPOSE:		This function returns a list on users or machines
//					that are defined to the network.
//
// ARGUMENTS:	as_server	- Domain controller
//					ai_level		- 1 = Users, 2=Machines, 3=Groups
//					ai_flag		- Which bit flag to return
//
// RETURN:		String to be imported into datawindow
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Ulong lul_result, lul_ptr, lul_strptr
Ulong lul_read, lul_index, lul_loop
String ls_data, ls_import, ls_msg

lul_index = 0
lul_result = ERROR_MORE_DATA

DO
	// get list of users
	lul_result = NetQueryDisplayInformation(as_server, &
						ai_level, lul_index, 100, &
						MAX_PREFERRED_LENGTH, lul_read, lul_ptr)
	CHOOSE CASE lul_result
		CASE NERR_Success, ERROR_MORE_DATA
			FOR lul_loop = 1 TO lul_read
				If ai_level = 1 Then
					// get userid
					lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 6)
					ls_data = String(lul_strptr, "ADDRESS")
					ls_import = ls_import + Trim(ls_data) + "~t"
					// get user name
					lul_strptr = of_getpointer(lul_ptr, 4, lul_loop, 6)
					ls_data = String(lul_strptr, "ADDRESS")
					ls_import = ls_import + Trim(ls_data) + "~t"
					// get account flag
					lul_strptr = of_getpointer(lul_ptr, 3, lul_loop, 6)
					If of_getbit(lul_strptr, ai_flag) Then
						ls_import = ls_import + "Y~r~n"
					Else
						ls_import = ls_import + "N~r~n"
					End If
					// get next index
					lul_index = of_getpointer(lul_ptr, 6, lul_loop, 6)
				Else
					// get machine/group name
					lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 5)
					ls_data = String(lul_strptr, "ADDRESS")
					If Right(ls_data, 1) = "$" Then
						ls_data = Left(ls_data, Len(ls_data) - 1)
					End If
					ls_import = ls_import + Trim(ls_data) + "~t"
					// get comment
					lul_strptr = of_getpointer(lul_ptr, 2, lul_loop, 5)
					ls_data = String(lul_strptr, "ADDRESS")
					ls_import = ls_import + Trim(ls_data) + "~t"
					// get account flag
					lul_strptr = of_getpointer(lul_ptr, 3, lul_loop, 6)
					If of_getbit(lul_strptr, ai_flag) Then
						ls_import = ls_import + "Y~r~n"
					Else
						ls_import = ls_import + "N~r~n"
					End If
					// get next index
					lul_index = of_getpointer(lul_ptr, 5, lul_loop, 5)
				End If
			NEXT
		CASE ELSE
			ls_msg = of_FormatMessage(lul_result)
			MessageBox(	"NetQueryDisplayInformation Error", &
							"Error #" + String(lul_result) + "~r~n~r~n" + &
							ls_msg, StopSign!)
	END CHOOSE
LOOP WHILE lul_result = ERROR_MORE_DATA

// free buffer
NetAPIBufferFree(lul_ptr)

Return ls_import

end function

public function string of_wnetgetuser ();// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WNetGetUser
//
// PURPOSE:		This function retrieves the current default user name, or
//					the user name used to establish a network connection.
//
// ARGUMENTS:	aul_error - System error code
//
// RETURN:		System error test
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

String ls_userid, ls_msg
Ulong lul_result, lul_buflen

lul_buflen = 32
ls_userid = Space(lul_buflen)

lul_result = WNetGetUser("", ls_userid, lul_buflen)

If lul_result = NO_ERROR Then
	Return ls_userid
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"WNetGetUser Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

Return ""

end function

public function string of_get_userid ();// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_Get_Userid
//
// PURPOSE:		This function returns the userid of the person logged on
//					to the network.
//
// RETURN:		The logged on person's userid (Uppercase)
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

String ls_userid

ls_userid = this.of_WNetGetUser()

ls_userid = Upper(Trim(ls_userid))

Return ls_userid

end function

public function unsignedlong of_getpointer (unsignedlong aul_baseptr, integer ai_ptrnum, integer ai_arraynum, integer ai_ptrcnt);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_GetPointer
//
// PURPOSE:		This function returns a pointer from a memory location
//					containing an array of pointers to strings.
//
// ARGUMENTS:	aul_baseptr	- Base address of buffer
//					ai_ptrnum	- Which pointer in the structure is needed
//					ai_arraynum	- Which array occurrence
//					ai_ptrcnt	- How many pointers in the structure
//
// RETURN:		Pointer to the desired string
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_bufptr, lul_strptr

// calculate memory location
lul_bufptr = aul_baseptr + ((ai_arraynum - 1) * (ai_ptrcnt * 4)) + ((ai_ptrnum - 1) * 4)

// copy pointer into local variable
CopyMemory(lul_strptr, lul_bufptr, 4)

Return lul_strptr

end function

public function boolean of_getbit (unsignedlong aul_number, integer ai_bit);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_GetBit
//
// PURPOSE:		This function determines if the specified bit is on or off
//					in the passed number.
//
// ARGUMENTS:	aul_number	- Number to be analyzed
//					ai_bit		- Bit number to check (starting with 1)
//
// RETURN:		True = Bit on, False = Bit off
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Boolean lb_null

If Int(Mod(aul_number / (2 ^(ai_bit - 1)), 2)) > 0 Then
	Return True
End If

Return False

end function

public function string of_getcomputername ();// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_GetComputerName
//
// PURPOSE:		This function returns the NetBIOS name of the local
//					computer.
//
// RETURN:		The computer's name
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

String ls_compname
Ulong lul_buflen
Boolean lb_result

lul_buflen = 32
ls_compname = Space(lul_buflen)

lb_result = GetComputerName(ls_compname, lul_buflen)

Return ls_compname

end function

public function unsignedinteger of_getdrivetype (string as_drive);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_GetDriveType
//
// PURPOSE:		This function determines whether a disk drive is a
//					removable, fixed, CD-ROM, RAM disk, or network drive.
//
// ARGUMENTS:	as_drive - Drive letter
//
// RETURN:		Type	Meaning
//					0		The drive type cannot be determined.
//					1		The root path is invalid. For example, no
//							volume is mounted at the path.
//					2		The disk can be removed from the drive.
//					3		The disk cannot be removed from the drive.
//					4		The drive is a remote (network) drive.
//					5		The drive is a CD-ROM drive.
//					6		The drive is a RAM disk.
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Constant UInt DRIVE_UNKNOWN		= 0
Constant UInt DRIVE_NO_ROOT_DIR	= 1
Constant UInt DRIVE_REMOVABLE		= 2
Constant UInt DRIVE_FIXED			= 3
Constant UInt DRIVE_REMOTE			= 4
Constant UInt DRIVE_CDROM			= 5
Constant UInt DRIVE_RAMDISK		= 6

UInt lui_type
String ls_drive

ls_drive = as_drive + ":\"

lui_type = GetDriveType(ls_drive)

Return lui_type

end function

public function boolean of_netmessagebuffersend (string as_sendto, string as_msgtext);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetMessageBufferSend
//
// PURPOSE:		This function sends a text message to the specified
//					machine on the network.
//
// ARGUMENTS:	as_sendto	- Name of the computer receiving the message
//					as_msgtext	- The text of the message
//
// RETURN:		True = Msg sent, False = Error
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_buflen, lul_result
String ls_msg, ls_server, ls_from

// length in bytes of message
lul_buflen = Len(as_msgtext) * 2

// get computer name
ls_from = this.of_GetComputerName()

// send network message
lul_result = NetMessageBufferSend(ls_server, &
						as_sendto, ls_from, as_msgtext, lul_buflen)

If lul_result = NERR_Success Then
	Return True
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetMessageBufferSend Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

Return False

end function

public function string of_netsessionenum (string as_server);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetSessionEnum
//
// PURPOSE:		This function provides information about sessions
//					established on a server.
//
// ARGUMENTS:	as_server	- Server to get sessions for
//
// RETURN:		String to be imported into datawindow
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Ulong lul_result, lul_ptr, lul_strptr, lul_read
ULong lul_entries, lul_resume, lul_loop
String ls_null, ls_msg, ls_data, ls_import

SetNull(ls_null)

lul_result = ERROR_MORE_DATA

DO
	lul_result = NetSessionEnum(as_server, ls_null, ls_null, &
							10, lul_ptr, MAX_PREFERRED_LENGTH, &
							lul_read, lul_entries, lul_resume)
	CHOOSE CASE lul_result
		CASE NERR_Success, ERROR_MORE_DATA
			FOR lul_loop = 1 TO lul_read
				// get computer name
				lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 4)
				ls_data = String(lul_strptr, "ADDRESS")
				ls_import = ls_import + Trim(ls_data) + "~t"
				// get user name
				lul_strptr = of_getpointer(lul_ptr, 2, lul_loop, 4)
				ls_data = String(lul_strptr, "ADDRESS")
				ls_import = ls_import + Trim(ls_data) + "~r~n"
			NEXT
		CASE ELSE
			ls_msg = of_FormatMessage(lul_result)
			MessageBox(	"NetSessionEnum Error", &
							"Error #" + String(lul_result) + "~r~n~r~n" + &
							ls_msg, StopSign!)
	END CHOOSE
LOOP WHILE lul_result = ERROR_MORE_DATA

// free buffer
NetAPIBufferFree(lul_ptr)

Return ls_import

end function

public function string of_wnetgetconnection (string as_drive);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WNetGetConnection
//
// PURPOSE:		This function retrieves the name of the network resource
//					associated with a local device.
//
// ARGUMENTS:	as_drive - Drive letter
//
// RETURN:		Network share name
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

String ls_connection, ls_drive, ls_msg
ULong lul_result, lul_buflen

lul_buflen = 260
ls_connection = Space(lul_buflen)
ls_drive = Upper(Left(as_drive,1)) + ":"

lul_result = WNetGetConnection(ls_drive, ls_connection, lul_buflen)

If lul_result = NO_ERROR Then
	Return ls_connection
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"WNetGetConnection Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

Return ""

end function

public function string of_whatdriveshare (string as_share);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WhatDriveShare
//
// PURPOSE:		This function returns the drive letter that is mapped
//					to the passed share name.
//
// ARGUMENTS:	as_share	- Share name
//
// RETURN:		Drive letter
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Uint lui_type
Integer li_cnt
String ls_drive, ls_share, ls_result

ls_share = Lower(as_share)

FOR li_cnt = 65 TO 90
	ls_drive = Char(li_cnt)
	lui_type = this.of_GetDriveType(ls_drive)
	If lui_type = 4 Then
		ls_result = Lower(this.of_WNetGetConnection(ls_drive))
		If Pos(ls_result, ls_share) > 0 Then
			Return ls_drive
		End If
	End If
NEXT

Return ""

end function

public function boolean of_wnetcancelconnection2 (string as_drive);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WNetCancelConnection2
//
// PURPOSE:		This function disconnects a network shared drive.
//
// ARGUMENTS:	as_drive	- Local drive letter
//
// RETURN:		True = Success, False = Error
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_result
String ls_msg, ls_drive

ls_drive = Upper(Left(as_drive,1)) + ":"

lul_result = WNetCancelConnection2(ls_drive, 0, True)

If lul_result = NO_ERROR Then
	Return True
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"WNetCancelConnection2 Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

Return False

end function

public function boolean of_wnetaddconnection2 (string as_local, string as_remote, boolean ab_reconnect);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WNetAddConnection2
//
// PURPOSE:		This function connects a network share to a drive letter.
//
// ARGUMENTS:	as_local			- Local drive letter
//					as_remote		- Remote share name
//					ab_reconnect	- Reconnect at logon option
//
// RETURN:		True = Success, False = Error
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_result
Long ll_reconnect
NETRESOURCE lstr_net
String ls_userid, ls_passwd, ls_msg, ls_drive
Constant Ulong RESOURCETYPE_DISK = 1
Constant Long CONNECT_UPDATE_PROFILE = 1

ls_drive = Upper(Left(as_local,1)) + ":"

lstr_net.dwType			= RESOURCETYPE_DISK
lstr_net.lpLocalname		= ls_drive
lstr_net.lpRemotename	= as_remote
lstr_net.lpProvider		= ""

SetNull(ls_userid)
SetNull(ls_passwd)

If ab_reconnect Then
	ll_reconnect = CONNECT_UPDATE_PROFILE
Else
	ll_reconnect = 0
End If

lul_result = WNetAddConnection2(lstr_net, &
						ls_passwd, ls_userid, ll_reconnect)

If lul_result = NO_ERROR Then
	Return True
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"WNetAddConnection2 Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

Return False

end function

public function boolean of_netwkstagetinfo (ref string as_computername, ref string as_langroup, ref integer ai_osmajor, ref integer ai_osminor);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetWkstaGetInfo
//
// PURPOSE:		This function returns information about the workstation
//					placing it in the by reference arguments.
//
// ARGUMENTS:	as_computername	- Computer name (by ref)
//					as_langroup			- Domain name (by ref)
//					ai_osmajor			- OS Major Version (by ref)
//					ai_osminor			- OS Minor Version (by ref)
//
// RETURN:		True = Success, False = Error
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_result, lul_ptr, lul_strptr
String ls_msg, ls_server
Boolean lb_return

lul_result = NetWkstaGetInfo(ls_server, 100, lul_ptr)
If lul_result = NO_ERROR Then
	// get computer name
	lul_strptr = of_getpointer(lul_ptr, 2, 1, 5)
	as_computername = String(lul_strptr, "ADDRESS")
	// get domain name
	lul_strptr = of_getpointer(lul_ptr, 3, 1, 5)
	as_langroup = String(lul_strptr, "ADDRESS")
	// get operating system version
	ai_osmajor = of_getpointer(lul_ptr, 4, 1, 5)
	ai_osminor = of_getpointer(lul_ptr, 5, 1, 5)
	lb_return = True
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetWkstaGetInfo Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

// free buffer
NetAPIBufferFree(lul_ptr)

Return lb_return

end function

public function string of_netserverenum (string as_domain, unsignedlong aul_svrtype);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetServerEnum
//
// PURPOSE:		This function lists all servers of the specified type
//					that are visible in a domain.
//
// ARGUMENTS:	as_domain	- Domain to get servers for
//					aul_svrtype	- Type of server to search for
//
// RETURN:		String to be imported into datawindow
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Ulong lul_result, lul_ptr, lul_strptr
Ulong lul_read, lul_total, lul_resume, lul_loop
String ls_msg, ls_data, ls_import

lul_resume = 0
lul_result = ERROR_MORE_DATA

DO
	// get list of servers
	lul_result = NetServerEnum("", 101, lul_ptr, &
						MAX_PREFERRED_LENGTH, lul_read, &
						lul_total, aul_svrtype, as_domain, lul_resume )
	CHOOSE CASE lul_result
		CASE NERR_Success, ERROR_MORE_DATA
			FOR lul_loop = 1 TO lul_read
				// get server name
				lul_strptr = of_getpointer(lul_ptr, 2, lul_loop, 6)
				ls_data = String(lul_strptr, "ADDRESS")
				ls_import = ls_import + Trim(ls_data) + "~t"
				// get comment
				lul_strptr = of_getpointer(lul_ptr, 6, lul_loop, 6)
				ls_data = String(lul_strptr, "ADDRESS")
				ls_import = ls_import + Trim(ls_data) + "~t~n"
			NEXT
		CASE ELSE
			ls_msg = of_FormatMessage(lul_result)
			MessageBox(	"NetServerEnum Error", &
							"Error #" + String(lul_result) + "~r~n~r~n" + &
							ls_msg, StopSign!)
	END CHOOSE
LOOP WHILE lul_result = ERROR_MORE_DATA

// free buffer
NetAPIBufferFree(lul_ptr)

Return ls_import

end function

public function string of_netwkstauserenum (string as_server);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetWkstaUserEnum
//
// PURPOSE:		This function lists information about all users currently
//					logged on to the workstation.
//
// ARGUMENTS:	as_server	- Server to list users
//
// RETURN:		String to be imported into datawindow
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Ulong lul_result, lul_ptr, lul_strptr
Ulong lul_read, lul_total, lul_resume, lul_loop
String ls_msg, ls_data, ls_import

lul_resume = 0
lul_result = ERROR_MORE_DATA

DO
	// get list of users
	lul_result = NetWkstaUserEnum(as_server, 0, lul_ptr, &
						MAX_PREFERRED_LENGTH, lul_read, &
						lul_total, lul_resume )
	CHOOSE CASE lul_result
		CASE NERR_Success, ERROR_MORE_DATA
			FOR lul_loop = 1 TO lul_read
				// get user name
				lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 1)
				ls_data = String(lul_strptr, "ADDRESS")
				ls_import = ls_import + Trim(ls_data) + "~n"
			NEXT
		CASE ELSE
			ls_msg = of_FormatMessage(lul_result)
			MessageBox(	"NetWkstaUserEnum Error", &
							"Error #" + String(lul_result) + "~r~n~r~n" + &
							ls_msg, StopSign!)
	END CHOOSE
LOOP WHILE lul_result = ERROR_MORE_DATA

// free buffer
NetAPIBufferFree(lul_ptr)

Return ls_import

end function

public function boolean of_netusergetinfo (string as_server, string as_username, ref string as_fullname, ref string as_comment);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_NetUserGetInfo
//
// PURPOSE:		This function 
//
// ARGUMENTS:	as_server	- Name of server (domain controller usually)
//					as_username	- Userid of account to get info for
//					as_fullname	- Full name (by ref)
//					as_comment	- Comment (by ref)
//
// RETURN:		True = Success, False = Error
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 09/27/04	RolandS		Initial creation
// -----------------------------------------------------------------------

ULong lul_result, lul_ptr, lul_strptr
String ls_msg
Boolean lb_return

lul_result = NetUserGetInfo(as_server, as_username, 20, lul_ptr)
If lul_result = NO_ERROR Then
	// get full name
	lul_strptr = of_getpointer(lul_ptr, 2, 1, 5)
	as_fullname = String(lul_strptr, "ADDRESS")
	// get comment
	lul_strptr = of_getpointer(lul_ptr, 3, 1, 5)
	as_comment = String(lul_strptr, "ADDRESS")
	lb_return = True
Else
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetUserGetInfo Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

// free buffer
NetAPIBufferFree(lul_ptr)

Return lb_return

end function

public function boolean of_finduser (string as_server, string as_username, ref string as_computer[]);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_FindUser
//
// PURPOSE:		This function searches for a user and returns
//					which machine they are connected to.
//
// ARGUMENTS:	as_server	- Server to search
//					as_username	- User to look for
//					as_computer	- By Ref Array with list of computers
//
// RETURN:		True = Found, False = Not Found
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 10/07/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Boolean lb_found
Integer li_index
Ulong lul_result, lul_ptr, lul_strptr, lul_read
ULong lul_entries, lul_resume, lul_loop
String ls_null, ls_msg, ls_username

SetNull(ls_null)

lul_result = NetSessionEnum(as_server, ls_null, ls_null, &
						10, lul_ptr, MAX_PREFERRED_LENGTH, &
						lul_read, lul_entries, lul_resume)

If lul_result = NERR_Success Then
	FOR lul_loop = 1 TO lul_read
		// get user name
		lul_strptr = of_getpointer(lul_ptr, 2, lul_loop, 4)
		ls_username = String(lul_strptr, "ADDRESS")
		// is this who we are looking for?
		If Lower(ls_username) = Lower(as_username) Then
			li_index = UpperBound(as_computer) + 1
			// get computer name
			lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 4)
			as_computer[li_index] = String(lul_strptr, "ADDRESS")
			lb_found = True
		End If
	NEXT
Else
	// display error message
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetSessionEnum Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

// free buffer
NetAPIBufferFree(lul_ptr)

Return lb_found

end function

public function boolean of_whosecomputer (string as_server, string as_computer, string as_username);// -----------------------------------------------------------------------
// SCRIPT:		n_netapi.of_WhoseComputer
//
// PURPOSE:		This function searches for a computer and returns
//					which user is logged onto it.
//
// ARGUMENTS:	as_server	- Server to search
//					as_computer	- Computer to search for
//					as_username	- Userid of person logged on
//
// RETURN:		True = Found, False = Not Found
//
// DATE		PROG/ID		DESCRIPTION OF CHANGE / REASON
// --------	----------- --------------------------------------------------
// 10/07/04	RolandS		Initial creation
// -----------------------------------------------------------------------

Boolean lb_found
Integer li_index
Ulong lul_result, lul_ptr, lul_strptr, lul_read
ULong lul_entries, lul_resume, lul_loop
String ls_null, ls_msg, ls_computer

SetNull(ls_null)

lul_result = NetSessionEnum(as_server, ls_null, ls_null, &
						10, lul_ptr, MAX_PREFERRED_LENGTH, &
						lul_read, lul_entries, lul_resume)

If lul_result = NERR_Success Then
	FOR lul_loop = 1 TO lul_read
		// get computer name
		lul_strptr = of_getpointer(lul_ptr, 1, lul_loop, 4)
		ls_computer = String(lul_strptr, "ADDRESS")
		// is this who we are looking for?
		If Lower(ls_computer) = Lower(as_computer) Then
			// get user name
			lul_strptr = of_getpointer(lul_ptr, 2, lul_loop, 4)
			as_username = String(lul_strptr, "ADDRESS")
			lb_found = True
			Exit
		End If
	NEXT
Else
	// display error message
	ls_msg = of_FormatMessage(lul_result)
	MessageBox(	"NetSessionEnum Error", &
					"Error #" + String(lul_result) + "~r~n~r~n" + &
					ls_msg, StopSign!)
End If

// free buffer
NetAPIBufferFree(lul_ptr)

Return lb_found

end function

on n_netapi.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_netapi.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

