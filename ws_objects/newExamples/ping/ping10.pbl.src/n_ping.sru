$PBExportHeader$n_ping.sru
$PBExportComments$Userobject to perform network Ping
forward
global type n_ping from nonvisualobject
end type
type icmp_echo_reply from structure within n_ping
end type
type large_integer from structure within n_ping
end type
type hostent from structure within n_ping
end type
type wsadata from structure within n_ping
end type
end forward

type icmp_echo_reply from structure
	unsignedlong		address
	unsignedlong		status
	unsignedlong		roundtriptime
	unsignedlong		datasize
	unsignedlong		reserved[3]
	character		data[]
end type

type large_integer from structure
	unsignedlong		low_part
	unsignedlong		high_part
end type

type hostent from structure
	unsignedlong		h_name
	unsignedlong		h_aliases
	integer		h_addrtype
	integer		h_length
	unsignedlong		h_addr_list
end type

type wsadata from structure
	unsignedinteger		version 
	unsignedinteger		highversion 
	character		description[257] 
	character		systemstatus[129] 
	unsignedinteger		maxsockets 
	unsignedinteger		maxupddg 
	string		 vendorinfo 
end type

global type n_ping from nonvisualobject autoinstantiate
end type

type prototypes
Function boolean QueryPerformanceFrequency ( &
	Ref large_integer lpFrequency &
	) Library "kernel32.dll"

Function boolean QueryPerformanceCounter ( &
	Ref large_integer lpPerformanceCount &
	) Library "kernel32.dll"

Subroutine CopyMemoryIP ( &
	Ref hostent Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemoryIP ( &
	Ref blob Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemoryIP ( &
	Ref ulong Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Function ulong GetLastError( &
	) Library "kernel32.dll"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function boolean GetComputerName ( &
	Ref string buffer, &
	Ref long buflen &
	) Library "kernel32.dll" Alias For "GetComputerNameW"

Function long WNetGetUser ( &
	string lpname, &
	Ref string lpusername, &
	Ref long buflen &
	) Library "mpr.dll" Alias For "WNetGetUserW"

Function long WSAStartup ( &
	long wVersionRequested, &
	Ref wsadata lpWSAData &
	) Library "ws2_32.dll"

Function long WSACleanup ( &
	) Library "ws2_32.dll"

Function ulong inet_addr ( &
	string cp &
	) Library "ws2_32.dll" Alias for "inet_addr;Ansi"

Function integer gethostname ( &
	Ref string name, &
	integer namelen &
	) Library "ws2_32.dll" Alias for "gethostname;Ansi"

Function ulong gethostbyname ( &
	string name &
	) Library "ws2_32.dll" Alias for "gethostbyname;Ansi"

Function ulong gethostbyaddr ( &
	Ref ulong addr, &
	long len, &
	long htype &
	) Library "ws2_32.dll" Alias for "gethostbyaddr"

Function integer WSAGetLastError ( &
	) Library "ws2_32.dll"  

Function ulong IcmpCreateFile ( &
	) Library "icmp.dll"

Function long IcmpSendEcho ( &
	ulong IcmpHandle, &
	ulong DestinationAddress, &
	string RequestData, &
	long RequestSize, &
	long RequestOptions, &
	Ref icmp_echo_reply ReplyBuffer, &
	long ReplySize, &
	long Timeout &
	) Library "icmp.dll" Alias for "IcmpSendEcho"

Function long IcmpCloseHandle ( &
	ulong IcmpHandle &
	) Library "icmp.dll"

end prototypes

type variables
ULong iul_frequency
ULong iul_begin
Long il_timeout = 200

end variables

forward prototypes
public subroutine of_performance_beg ()
public function double of_performance_end ()
public function boolean of_ping (string as_ipaddress)
public function string of_wsagetlasterror ()
public function boolean of_ping (string as_ipaddress, string as_echomsg)
public function string of_formatmessage (unsignedlong aul_error)
public function string of_wnetgetuser ()
public function string of_getlasterror ()
public function string of_getcomputername ()
public function string of_getipaddress (string as_hostname)
public function string of_gethostname (string as_ipaddress)
public function string of_gethostname ()
end prototypes

public subroutine of_performance_beg ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_Performance_Beg
//
// PURPOSE:		This function saves the current value of the
//					operating system's performance counter.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

large_integer lstr_counter

QueryPerformanceCounter(lstr_counter)

iul_begin = lstr_counter.low_part

end subroutine

public function double of_performance_end ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_Performance_End
//
// PURPOSE:		This function gets the current value of the
//					operating system's performance counter and
//					calculates the elapsed time since of_Begin_Timer
//					was called.
//
//	RETURN:		Elapsed time in seconds
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

large_integer lstr_counter
Double ldbl_elapsed
ULong lul_end

QueryPerformanceCounter(lstr_counter)

lul_end = lstr_counter.low_part

If iul_frequency > 0 Then
	ldbl_elapsed = (lul_end - iul_begin) / iul_frequency
End If

Return ldbl_elapsed

end function

public function boolean of_ping (string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_Ping
//
// PURPOSE:		This function provides a default echo string
//					to the main of_Ping function.
//
// ARGUMENTS:	as_ipaddress	- IP address of the server
//
// RETURN:		True = Success, False = Failed
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_echomsg

ls_echomsg = "abcdefghijklmnopqrstuvwxyz"

Return of_Ping(as_ipaddress, ls_echomsg)

end function

public function string of_wsagetlasterror ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_WSAGetLastError
//
// PURPOSE:		This function returns the message text for

//					the most recent Winsock error.
//
// RETURN:		Counter value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_error
String ls_errmsg

lul_error = WSAGetLastError()

If lul_error = 0 Then
	ls_errmsg = "An unknown error has occurred!"
Else
	ls_errmsg = of_FormatMessage(lul_error)
End If

Return ls_errmsg

end function

public function boolean of_ping (string as_ipaddress, string as_echomsg);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_Ping
//
// PURPOSE:		This function performs a 'ping' against the
//					server at the specified IP address.
//
// ARGUMENTS:	as_ipaddress	- IP address of the server
//					as_echomsg		- The text to send to server
//
// RETURN:		True = Success, False = Failed
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_address, lul_handle
Long ll_rc, ll_size
String ls_errmsg, ls_reply
icmp_echo_reply lstr_reply

lul_address = inet_addr(as_ipaddress)
If lul_address > 0 Then
	lstr_reply.Data[Len(as_echomsg)] = ""
	lul_handle = IcmpCreateFile()
	ll_size = Len(as_echomsg) * 2
	ll_rc = IcmpSendEcho(lul_handle, lul_address, &
						as_echomsg, ll_size, 0, &
						lstr_reply, 28 + ll_size, il_timeout)
	IcmpCloseHandle(lul_handle)
	If ll_rc = 0 Then
		ls_errmsg = of_WSAGetLastError()
		MessageBox(	"Send Echo Error in of_Ping", &
						ls_errmsg, StopSign!)
	Else
		If lstr_reply.Status = 0 Then
			ls_reply = String(lstr_reply.Data)
			If ls_reply = as_echomsg Then
				Return True
			Else
				ls_errmsg  = "The returned string is different:~r~n~r~n"
				ls_errmsg += "Sent: " + as_echomsg + "~r~n"
				ls_errmsg += "Recv: " + ls_reply
				MessageBox(	"Echo Error in of_Ping", &
								ls_errmsg, StopSign!)
			End If
		Else
			ls_errmsg = of_FormatMessage(lstr_reply.Status)
			MessageBox(	"Echo Status Error in of_Ping", &
							ls_errmsg, StopSign!)
		End If
	End If
Else
	ls_errmsg = "The given IP Address is invalid!"
	MessageBox(	"Winsock Error in of_Ping", &
					ls_errmsg, StopSign!)
End If

Return False

end function

public function string of_formatmessage (unsignedlong aul_error);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_FormatMessage
//
// PURPOSE:		This function returns the message text for
//					the given system error code.
//
// ARGUMENTS:	aul_error	- Error code
//
// RETURN:		Message text
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_buffer, ls_errmsg

ls_buffer = Space(200)

FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
		aul_error, LANG_NEUTRAL, ls_buffer, 200, 0)

ls_errmsg = "Error# " + String(aul_error) + "~r~n~r~n" + ls_buffer

Return ls_errmsg

end function

public function string of_wnetgetuser ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_WNetGetUser
//
// PURPOSE:		This function retrieves the userid used to establish
//					the current network connection.
//
// RETURN:		The userid or empty string if error occurred.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_userid, ls_errmsg
Long ll_result, ll_buflen

ll_buflen = 32
ls_userid = Space(ll_buflen)

ll_result = WNetGetUser("", ls_userid, ll_buflen)
If ll_result <> 0 Then
	ls_errmsg = of_FormatMessage(ll_result)
	MessageBox(	"Network Error in of_WNetGetUser", &
					ls_errmsg, StopSign!)
End If

Return ls_userid

end function

public function string of_getlasterror ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetLastError
//
// PURPOSE:		This function returns the message text for
//					the most recent system error.
//
// RETURN:		Counter value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_error
String ls_errmsg

lul_error = GetLastError()

If lul_error = 0 Then
	ls_errmsg = "An unknown error has occurred!"
Else
	ls_errmsg = of_FormatMessage(lul_error)
End If

Return ls_errmsg

end function

public function string of_getcomputername ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetComputerName
//
// PURPOSE:		This function retrieves the NetBIOS name of the local computer.
//
// RETURN:		The userid or empty string if error occurred.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_compname, ls_errmsg
Long ll_buflen
Boolean lb_result

ll_buflen = 32
ls_compname = Space(ll_buflen)

lb_result = GetComputerName(ls_compname, ll_buflen)
If lb_result = False Then
	ls_errmsg = of_GetLastError()
	MessageBox(	"Network Error in of_GetComputerName", &
					ls_errmsg, StopSign!)
End If

Return ls_compname

end function

public function string of_getipaddress (string as_hostname);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetIPAddress
//
// PURPOSE:		This function finds the IP address for the
//					specified host name.
//
// ARGUMENTS:	as_hostname	- host name of a server
//
// RETURN:		IP Address
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_ipaddress, ls_errmsg
Blob lblb_ipaddr
hostent lstr_host
ULong lul_ptr, lul_ipaddr

// get information about host
lul_ptr = gethostbyname(as_hostname)

If lul_ptr > 0 Then
	// copy structure to local structure
	CopyMemoryIP(lstr_host, lul_ptr, 16)
	// get memory address where ipaddress is located
	CopyMemoryIP(lul_ipaddr, lstr_host.h_addr_list, 4)
	// copy ipaddress to local blob
	lblb_ipaddr = Blob(Space(4),EncodingAnsi!)
	CopyMemoryIP(lblb_ipaddr, lul_ipaddr, 4)
	// convert blob to string ip address
	ls_ipaddress  = String(AscA(String(BlobMid(lblb_ipaddr,1,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,2,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,3,1),EncodingAnsi!)),"##0") + "."
	ls_ipaddress += String(AscA(String(BlobMid(lblb_ipaddr,4,1),EncodingAnsi!)),"##0")
Else
	ls_errmsg = of_WSAGetLastError()
	MessageBox(	"Winsock Error in of_GetIPAddress", &
					ls_errmsg, StopSign!)
End If

Return ls_ipaddress

end function

public function string of_gethostname (string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetHostName
//
// PURPOSE:		This function finds the host name that corresponds to the
//					specified IP Address.
//
// ARGUMENTS:	as_ipaddress	- IP Address of a server
//
// RETURN:		IP Address
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
//	03/09/2009	RolandS		Added error handling to gethostbyaddr
// -----------------------------------------------------------------------------

String ls_hostname, ls_errmsg
ULong lul_address, lul_ptr, lul_host
Blob lblb_host
hostent lstr_host
Constant Long AF_INET = 2

lul_address = inet_addr(as_ipaddress)
If lul_address > 0 Then
	// get information about host
	lul_ptr = gethostbyaddr(lul_address, 4, AF_INET)
	If lul_ptr > 0 Then
		// copy structure to local structure
		CopyMemoryIP(lstr_host, lul_ptr, 16)
		// copy ipaddress to local blob
		lblb_host = Blob(Space(250),EncodingAnsi!)
		CopyMemoryIP(lblb_host, lstr_host.h_name, 250)
		ls_hostname = String(lblb_host,EncodingAnsi!)
	Else
		ls_errmsg = of_WSAGetLastError()
		MessageBox(	"Winsock Error in of_GetHostName", &
						ls_errmsg, StopSign!)
	End If
Else
	ls_errmsg = "The given IP Address is invalid!"
	MessageBox(	"Winsock Error in of_GetHostName", &
					ls_errmsg, StopSign!)
End If

Return ls_hostname

end function

public function string of_gethostname ();// -----------------------------------------------------------------------------
// FUNCTION:	n_ping.of_GetHostName
//
// PURPOSE:		This function retrieves the standard host name for the
//					local computer.
//
// RETURN:		IP Address
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 03/23/2004	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_hostname, ls_errmsg
Integer li_rc, li_namelen

li_namelen = 32
ls_hostname = Space(li_namelen)

li_rc = gethostname(ls_hostname, li_namelen)
If li_rc <> 0 Then
	ls_errmsg = of_WSAGetLastError()
	MessageBox(	"Winsock Error in of_GetHostName", &
					ls_errmsg, StopSign!)
End If

Return ls_hostname

end function

on n_ping.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_ping.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;wsadata lstr_wsadata
large_integer lstr_frequency
Long ll_rc
String ls_errmsg

// determine the performance counter frequency
QueryPerformanceFrequency(lstr_frequency)
iul_frequency = lstr_frequency.low_part

// initialize Winsock
ll_rc = WSAStartup(257, lstr_wsadata)
If ll_rc <> 0 Then
	ls_errmsg = of_GetLastError()
	MessageBox(	"WSAStartup Error in constructor", &
					ls_errmsg, StopSign!)
End If

end event

event destructor;// cleanup Winsock
WSACleanup()

end event

