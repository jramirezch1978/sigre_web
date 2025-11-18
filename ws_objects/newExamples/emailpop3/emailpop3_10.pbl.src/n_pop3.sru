$PBExportHeader$n_pop3.sru
forward
global type n_pop3 from n_winsock
end type
type systemtime from structure within n_pop3
end type
end forward

type systemtime from structure
	unsignedinteger		wyear
	unsignedinteger		wmonth
	unsignedinteger		wdayofweek
	unsignedinteger		wday
	unsignedinteger		whour
	unsignedinteger		wminute
	unsignedinteger		wsecond
	unsignedinteger		wmilliseconds
end type

global type n_pop3 from n_winsock
string is_lasterror = "110"
end type

type prototypes
Function long CreateFile ( &
	string lpFileName, &
	ulong dwDesiredAccess, &
	ulong dwShareMode, &
	ulong lpSecurityAttributes, &
	ulong dwCreationDisposition, &
	ulong dwFlagsAndAttributes, &
	ulong hTemplateFile &
	) Library "kernel32.dll" Alias For "CreateFileW"

Function boolean CloseHandle ( &
	long hObject &
	) Library "kernel32.dll"

Function boolean ReadFile ( &
	long hFile, &
	Ref blob lpBuffer, &
	ulong nNumberOfBytesToRead, &
	Ref ulong lpNumberOfBytesRead, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function boolean WriteFile ( &
	ulong hFile, &
	blob lpBuffer, &
	ulong nNumberOfBytesToWrite, &
	Ref ulong lpNumberOfBytesWritten, &
	ulong lpOverlapped &
	) Library "kernel32.dll"

Function long SendStringMessage ( &
	long hWnd, &
	uint Msg, &
	ulong wParam, &
	Ref string lParam &
	) Library "user32.dll" Alias For "SendMessageW"

Subroutine SleepMS ( &
	ulong dwMilliseconds &
	) Library "kernel32.dll" Alias For "Sleep"

Function boolean SystemTimeToTzSpecificLocalTime ( &
	ulong lpTimeZone, &
	SYSTEMTIME lpUniversalTime, &
	Ref SYSTEMTIME lpLocalTime &
	) Library "kernel32.dll"

// Cryptlib Functions
Function long cryptInit ( &
	) Library "cl32.dll"

Function long cryptEnd ( &
	) Library "cl32.dll"

Function long cryptCreateSession ( &
	Ref long pSession, &
	long cryptUser, &
	long SessionType &
	) Library "cl32.dll"

Function long cryptDestroySession ( &
	long session &
	) Library "cl32.dll"

Function long cryptSetAttributeString ( &
	long hCrypt, &
	long CryptAttType, &
	Ref string pBuff, &
	long StrLen &
	) Library "cl32.dll" Alias For "cryptSetAttributeString;Ansi"

Function long cryptSetAttribute ( &
	long hCrypt, &
	long CryptAttType, &
	long value &
	) Library "cl32.dll"

Function long cryptPopData ( &
	long envelope, &
	Ref string pBuff, &
	long StrLen, &
	Ref long pBytesCopied &
	) Library "cl32.dll" Alias For "cryptPopData;Ansi"

Function long cryptPushData ( &
	long envelope, &
	Ref string pBuff, &
	long StrLen, &
	Ref long pBytesCopied &
	) Library "cl32.dll" Alias For "cryptPushData;Ansi"

Function long cryptFlushData ( &
	long envelope &
	) Library "cl32.dll"

Function long cryptGetAttributeString ( &
	long hCrypt, &
	long CryptAttType, &
	Ref string pBuff, &
	Ref integer StrLen &
	) Library "cl32.dll" Alias For "cryptGetAttributeString;Ansi"
 
Function long cryptGetAttribute ( &
	long hCrypt, &
	long CryptAttType, &
	Ref long value &
	) Library "cl32.dll"

end prototypes

type variables
Private:

Constant	String CRLF = Char(13) + Char(10)

// Cryptlib constants
Constant Long CRYPT_OK                      =  0
Constant Long CRYPT_UNUSED                  = -101
Constant Long CRYPT_SESSION_SSL             = 3
Constant Long CRYPT_SESSINFO_ACTIVE         = 6001
Constant Long CRYPT_SESSINFO_SERVER_NAME    = 6008
Constant Long CRYPT_SESSINFO_SERVER_PORT    = 6009
Constant Long CRYPT_SESSINFO_NETWORKSOCKET  = 6014
Constant Long CRYPT_SESSINFO_SSL_OPTIONS    = 6026
Constant Long CRYPT_SSLOPTION_DISABLE_NAMEVERIFY = 16
Constant	Long CRYPT_OPTION_CERT_COMPLIANCELEVEL = 118
Constant	Long CRYPT_COMPLIANCELEVEL_PKIX_FULL = 4
Constant	Long CRYPT_COMPLIANCELEVEL_PKIX_PARTIAL = 3
Constant	Long CRYPT_COMPLIANCELEVEL_STANDARD = 2
Constant	Long CRYPT_COMPLIANCELEVEL_REDUCED = 1
Constant	Long CRYPT_COMPLIANCELEVEL_OBLIVIOUS = 0

// constants for CreateFile API function
Constant Long INVALID_HANDLE_VALUE = -1
Constant ULong GENERIC_READ     = 2147483648
Constant ULong GENERIC_WRITE    = 1073741824
Constant ULong FILE_SHARE_READ  = 1
Constant ULong FILE_SHARE_WRITE = 2
Constant ULong CREATE_NEW			= 1
Constant ULong CREATE_ALWAYS		= 2
Constant ULong OPEN_EXISTING		= 3
Constant ULong OPEN_ALWAYS			= 4
Constant ULong TRUNCATE_EXISTING = 5

ULong iul_socket
Long il_Session

UInt iui_port				= 110
Boolean ib_eventlog 		= False
Boolean ib_jaguarlog		= False
Boolean ib_messagebox	= False
Boolean ib_logfile		= False
String is_userid
String is_passwd
String is_server
String is_logfile
Long il_sleeptime = 25
Long il_totalbytes
Long il_recvdbytes
Long il_window
Long il_event
String is_email[]
String is_uidl[]

end variables

forward prototypes
public subroutine of_logerror (integer ai_msglevel, string as_msgtext)
private subroutine of_logfile (string as_logmsg)
public subroutine of_setlogerror (boolean ab_eventlog, boolean ab_jaguarlog, boolean ab_messagebox)
public subroutine of_setlogfile (boolean ab_flag, string as_logfile)
public subroutine of_setport (unsignedinteger aui_port)
public subroutine of_setlogin (string as_userid, string as_passwd)
public subroutine of_setserver (string as_server)
public function boolean of_send (unsignedlong aul_socket, string as_data)
public function boolean of_recv (unsignedlong aul_socket, ref string as_data)
public function boolean of_recvmail_start ()
private function boolean of_sendmsg (string as_cmd, ref string as_reply)
public function boolean of_recvmail_stop ()
public function integer of_msgcount ()
public function long of_msglength (integer ai_msgnum)
public function string of_msgcontent (integer ai_msgnum)
public function string of_msgsubject (integer ai_msgnum)
public subroutine of_msgfrom (integer ai_msgnum, ref string as_name, ref string as_email)
public function string of_crypterror (long al_retval)
private function boolean of_sendmsg_crypt (string as_cmd, ref string as_reply)
public function boolean of_recvmail_crypt_stop ()
public function boolean of_recvmail_crypt_start ()
private subroutine of_separate (readonly string as_content, ref string as_part[], ref string as_type[])
public function string of_msgproperty (integer ai_msgnum, string as_property)
public function integer of_msgbody (integer ai_msgnum, ref string as_part[], ref string as_type[])
public function integer of_msgload (string as_filename)
private function boolean of_readfile (string as_filename, ref blob ablob_data)
public function integer of_hex2int (string as_hex)
public subroutine of_quotedprintable (ref string as_content)
public function string of_attachname (string as_type)
public function string of_replaceall (readonly string as_oldstring, readonly string as_findstr, readonly string as_replace)
public function boolean of_writefile (readonly string as_filename, readonly blob ablob_filedata)
public subroutine of_decodestring (ref string as_string)
public function boolean of_msgreceipt (integer ai_msgnum, ref string as_name, ref string as_email)
public subroutine of_progress_done ()
public subroutine of_progress_message (string as_message)
public subroutine of_progress_notify (long al_window, long al_event)
public subroutine of_progress_start (long al_length)
public subroutine of_progress_update (long al_length)
public subroutine of_setsleeptime (long al_sleeptime)
public subroutine of_base64 (readonly string as_type, ref string as_part)
public function boolean of_recvmail_msgs (boolean ab_delete, boolean ab_headers)
public function boolean of_recvmail (boolean ab_delete, boolean ab_headers)
public function boolean of_recvmail_crypt_msgs (boolean ab_delete, boolean ab_headers)
public function boolean of_recvsslmail (boolean ab_delete, boolean ab_headers)
public function datetime of_msgsentdate (integer ai_msgnum)
public function integer of_msgadd (readonly string as_email, readonly string as_uidl)
public function string of_msguidl (integer ai_msgnum)
public function boolean of_deletemail (string as_uidl[])
public function boolean of_recvmail (integer ai_msgnum[])
public function boolean of_deletesslmail (string as_uidl[])
public function boolean of_recvsslmail (integer ai_msgnum[])
end prototypes

public subroutine of_logerror (integer ai_msglevel, string as_msgtext);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_LogError
//
// PURPOSE:    This function writes a message to the selected destinations.
//
// ARGUMENTS:  ai_msglevel	- The level of message importance
//					as_msgtext	- The text of the message
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/08/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

If ib_eventlog Then
	this.of_EventLog(ai_msglevel, as_msgtext)
End If

If ib_jaguarlog Then
	this.of_JaguarLog(ai_msglevel, as_msgtext)
End If

If ib_messagebox Then
	this.of_MessageBox(ai_msglevel, as_msgtext)
End If

end subroutine

private subroutine of_logfile (string as_logmsg);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_LogFile
//
// PURPOSE:    This function writes messages to the POP3 logfile.
//
// ARGUMENTS:  as_logmsg - Message text
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/10/2010	RolandS		Initial coding
// 07/06/2011	RolandS		Changed to use filename from instance variable
// -----------------------------------------------------------------------------

Integer li_fnum

If ib_logfile Then
	li_fnum = FileOpen(is_logfile, LineMode!, Write!, Shared!, Append!)
	FileWrite(li_fnum, as_logmsg)
	FileClose(li_fnum)
End If

end subroutine

public subroutine of_setlogerror (boolean ab_eventlog, boolean ab_jaguarlog, boolean ab_messagebox);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetLogError
//
// PURPOSE:    This function is used to set how messages are logged.
//
// ARGUMENTS:  ab_eventlog		- Write error messages to the Event Log
//					ab_jaguarlog	- Write error messages to the Jaguar Log
//					ab_messagebox	- Display error messages with MessageBox
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/08/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

ib_eventlog   = ab_eventlog
ib_jaguarlog  = ab_jaguarlog
ib_messagebox = ab_messagebox

end subroutine

public subroutine of_setlogfile (boolean ab_flag, string as_logfile);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetLogFile
//
// PURPOSE:    This function is used to turn on POP3 conversation logging.
//
// ARGUMENTS:  ab_flag		- True/False
//					as_logfile	- Name of the logfile
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/10/2010	RolandS		Initial coding
// 07/06/2011	RolandS		Added as_logfile
// -----------------------------------------------------------------------------

ib_logfile = ab_flag
is_logfile = as_logfile

end subroutine

public subroutine of_setport (unsignedinteger aui_port);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetPort
//
// PURPOSE:    This function is used to set the port the server is using.
//					The default is 110 and usually does not need to change.
//
// ARGUMENTS:  aui_port - Server port
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/08/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

iui_port = aui_port

end subroutine

public subroutine of_setlogin (string as_userid, string as_passwd);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetLogin
//
// PURPOSE:    This function is used to set the userid and password.
//
// ARGUMENTS:  as_userid - Server userid
//					as_passwd - Server password
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/08/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

is_userid = as_userid
is_passwd = as_passwd

end subroutine

public subroutine of_setserver (string as_server);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetServer
//
// PURPOSE:    This function is used to set the server name
//
// ARGUMENTS:  as_server - Server name
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/08/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

is_server = as_server

end subroutine

public function boolean of_send (unsignedlong aul_socket, string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Send
//
// PURPOSE:    This override of the ancestor adds optional logging.
//
// ARGUMENTS:  aul_socket	- Open socket
//					as_data		- By ref string
//
// RETURN:     True  = Success
//					False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/10/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

of_LogFile(as_data)

Return Super::of_Send(aul_socket, as_data)

end function

public function boolean of_recv (unsignedlong aul_socket, ref string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Recv
//
// PURPOSE:    This override of the ancestor adds optional logging.
//
// ARGUMENTS:  aul_socket	- Open socket
//					as_data		- By ref string
//
// RETURN:     True  = Success
//					False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/10/2010	RolandS		Initial coding
// -----------------------------------------------------------------------------

Boolean lb_return

lb_return = Super::of_Recv(aul_socket, as_data)

of_LogFile(as_data)

Return lb_return

end function

public function boolean of_recvmail_start ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail_Start
//
// PURPOSE:    This function starts the recvmail session.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// 12/30/2013	RolandS		Added logging
// -----------------------------------------------------------------------------

Constant	String REPLY_READY = "220"
String ls_reply, ls_msg

// update progress
of_Progress_Message("Connecting to the server")

// POP3 is Ansi
of_SetUnicode(False, False)

// initialize Winsock
of_Startup()

// connect to server
of_LogFile("Connect to server " + is_server + " on port " + String(iui_port) + CRLF)
iul_socket = of_Connect(is_server, iui_port)
If iul_socket = 0 Then Return False

// receive response
of_Recv(iul_socket, ls_reply)
If Left(ls_reply, 3) <> "+OK" Then
	of_SetLastError(ls_reply)
	of_LogError(iERROR, ls_reply)
	Return False
End If

// update progress
of_Progress_Message("Logging into the server")

// send the Userid
ls_msg = "USER " + is_userid + CRLF
If Not of_SendMsg(ls_msg, ls_reply) Then
	of_Close(iul_socket)
	Return False
End If

// send the Password
ls_msg = "PASS " + is_passwd + CRLF
If Not of_SendMsg(ls_msg, ls_reply) Then
	of_Close(iul_socket)
	Return False
End If

Return True

end function

private function boolean of_sendmsg (string as_cmd, ref string as_reply);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SendMsg
//
// PURPOSE:    This function is used by other functions to send a message and
//					receive any reply.
//
// ARGUMENTS:  as_cmd 	- POP3 command to be sent
//					as_reply	- The reply received from the server
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 08/20/2010	RolandS		Initial coding
// 04/03/2012	RolandS		Added in wait time
// -----------------------------------------------------------------------------

// send the data
If Not of_Send(iul_socket, as_cmd) Then
	Return False
End If

// wait before continuing
SleepMS(il_sleeptime)

// receive response
of_Recv(iul_socket, as_reply)

// check for errors
choose case Left(as_reply, 3)
	case "+OK"
		Return True
	case else
		of_SetLastError(as_reply)
		of_LogError(iERROR, as_reply)
		Return False
end choose

Return True

end function

public function boolean of_recvmail_stop ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail_Stop
//
// PURPOSE:    This function ends the recvmail session.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// -----------------------------------------------------------------------------

String ls_msg, ls_reply

// update progress
of_Progress_Message("Disconnecting from the server")

// quit the session
ls_msg = "QUIT" + CRLF
If Not of_Send(iul_socket, ls_msg) Then
	of_Close(iul_socket)
	Return False
End If

// receive response
of_Recv(iul_socket, ls_reply)

// close the socket
of_Close(iul_socket)

Return True

end function

public function integer of_msgcount ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgCount
//
// PURPOSE:    This function returns the number of received email messages.
//
// RETURN:     Email count
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return UpperBound(is_email)

end function

public function long of_msglength (integer ai_msgnum);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgLength
//
// PURPOSE:    This function returns the length of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//
// RETURN:     Email length
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return Len(is_email[ai_msgnum])

end function

public function string of_msgcontent (integer ai_msgnum);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgContent
//
// PURPOSE:    This function returns the entire content of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//
// RETURN:     Email content
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return is_email[ai_msgnum]

end function

public function string of_msgsubject (integer ai_msgnum);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgSubject
//
// PURPOSE:    This function returns the subject of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//
// RETURN:     Email subject
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/13/2012	RolandS		Added handling for subject going onto next line
// -----------------------------------------------------------------------------

Long ll_pos
String ls_result, ls_remain

ll_pos = Pos(is_email[ai_msgnum], "~nSubject:")
If ll_pos > 0 Then
	ls_result = Trim(Mid(is_email[ai_msgnum], ll_pos + 9, 250))
	ls_result = of_ReplaceAll(ls_result, CRLF+" ", " ")
	ls_remain = Mid(ls_result, Pos(ls_result, CRLF) + 2)
	ls_result = Left(ls_result, Pos(ls_result, CRLF) - 1)
	ls_result = Trim(ls_result)
	of_DecodeString(ls_result)
	If Left(ls_remain,  1) = "~t" Then
		ls_remain = Mid(ls_remain, 2)
		ls_remain = Left(ls_remain, Pos(ls_remain, CRLF) - 1)
		ls_remain = Trim(ls_remain)
		of_DecodeString(ls_remain)
		ls_result += ls_remain
	End If
End If

Return ls_result

end function

public subroutine of_msgfrom (integer ai_msgnum, ref string as_name, ref string as_email);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgFrom
//
// PURPOSE:    This function returns the from name/address of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//					as_name		- From name (by ref)
//					as_email		- From email (by ref)
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_pos
String ls_result

as_name  = ""
as_email = ""

ll_pos = Pos(is_email[ai_msgnum], "~nFrom:")
If ll_pos > 0 Then
	// parse out From: line
	ls_result = Trim(Mid(is_email[ai_msgnum], ll_pos + 6, 250))
	ls_result = Left(ls_result, Pos(ls_result, CRLF) - 1)
	// separate name & email
	ll_pos = Pos(ls_result, "<")
	If ll_pos > 1 Then
		ll_pos = ll_pos + 1
		as_email = Mid(ls_result, ll_pos, Len(ls_result) - ll_pos)
		as_name  = Trim(Left(ls_result, ll_pos - 2))
		If Left(as_name, 1) = "~"" Then
			as_name = Mid(as_name, 2)
		End If
		If Right(as_name, 1) = "~"" Then
			as_name = Left(as_name, Len(as_name) - 1)
		End If
		of_DecodeString(as_name)
	Else
		If Left(ls_result, 1) = "~"" Then
			ls_result = Mid(ls_result, 2)
		End If
		If Right(ls_result, 1) = "~"" Then
			ls_result = Left(ls_result, Len(ls_result) - 1)
		End If
		of_DecodeString(ls_result)
		as_email = ls_result
		as_name  = as_email
	End If
End If

end subroutine

public function string of_crypterror (long al_retval);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_CryptError
//
// PURPOSE:    This function returns message text for Cryptlib errors.
//
// ARGUMENTS:  al_retval - The error returned by a Cryptlib function
//
// RETURN:     Error message
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/21/2010	RolandS		Initial coding
//	12/30/2013	RolandS		Added extended error message
// -----------------------------------------------------------------------------

Constant Long CRYPT_ATTRIBUTE_ERRORMESSAGE = 12
String ls_Return, ls_extended
Integer li_Strlen
Long ll_RetVal

If al_RetVal = CRYPT_OK Then
	Return ""
End If

choose case al_RetVal
	// Errors in function calls
	case -1
		ls_Return = "Bad argument - parameter 1"
	case -2
		ls_Return = "Bad argument - parameter 2"
	case -3
		ls_Return = "Bad argument - parameter 3"
	case -4
		ls_Return = "Bad argument - parameter 4"
	case -5
		ls_Return = "Bad argument - parameter 5"
	case -6
		ls_Return = "Bad argument - parameter 6"
	case -7
		ls_Return = "Bad argument - parameter 7"
	// Errors due to insufficient resources  
	case -10
		ls_Return = "Out of memory"
	case -11
		ls_Return = "Data has not been initialised"
	case -12
		ls_Return = "Data has already been init'd"
	case -13
		ls_Return = "Operation not avail at requested sec level"
	case -14
		ls_Return = "No reliable random data available"
	case -15
		ls_Return = "Operation failed"
	case -16
		ls_Return = "Internal consistency check failed"
	// Security violations
	case -20
		ls_Return = "This type of operation not available"
	case -21
		ls_Return = "No permission to perform this operation"
	case -22
		ls_Return = "Incorrect key used to decrypt data"
	case -23
		ls_Return = "Operation incomplete/still in progress"
	case -24
		ls_Return = "Operation complete/can't continue"
	case -25
		ls_Return = "Operation timed out before completion"
	case -26
		ls_Return = "Invalid/inconsistent information"
	case -27
		ls_Return = "Resource destroyed by extnl.event"
	// High-level function errors     
	case -30
		ls_Return = "Resources/space exhausted"
	case -31
		ls_Return = "Not enough data available"
	case -32
		ls_Return = "Bad/unrecognised data format"
	case -33
		ls_Return = "Signature/integrity check failed"
	// Data access function errors
	case -40
		ls_Return = "Cannot open object"
	case -41
		ls_Return = "Cannot read item from object"
	case -42
		ls_Return = "Cannot write item to object"
	case -43
		ls_Return = "Requested item not found in object"
	case -44
		ls_Return = "Item already present in object"
	// Data enveloping errors     
	case -50
		ls_Return = "Need resource to proceed"
	case else
		ls_Return = "Unknown error code!"
end choose

// get extended error information
li_Strlen = 255
ls_Extended = Space(li_Strlen)

ll_RetVal = cryptGetAttributeString(il_Session, &
				CRYPT_ATTRIBUTE_ERRORMESSAGE, ls_Extended, li_Strlen)
If li_Strlen > 0 Then
	ls_Return += "~r~n~r~n" + ls_Extended
End If

Return ls_Return

end function

private function boolean of_sendmsg_crypt (string as_cmd, ref string as_reply);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_sendmsg_crypt
//
// PURPOSE:    This function is used by other TLS functions to send an
//					encrypted message and receive any reply.
//
// ARGUMENTS:  as_cmd 	- POP3 command to be sent
//					as_reply	- The reply received from the server
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 09/21/2010	RolandS		Initial coding
// 04/03/2012	RolandS		Added in wait time
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_reply, ls_msg, ls_Buffer
Long ll_RetVal, ll_ReplyBytes, ll_SentBytes

of_LogFile(as_cmd)

// trap unexpected returns
ls_Reply = Space(256)
ll_RetVal = cryptPopData(il_session, &
						ls_Reply, Len(ls_Reply), ll_ReplyBytes)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptPopData: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
ElseIf ll_ReplyBytes > 0 Then
	ls_msg = "Unexpected bytes in buffer: " + ls_Reply
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If

// Push data
ll_RetVal = cryptPushData(il_session, as_cmd, Len(as_cmd), ll_SentBytes)
If ll_RetVal <> CRYPT_OK Then
	ls_msg = "CryptPushData: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If
If Len(as_cmd) <> ll_SentBytes Then
	ls_msg = String(ll_SentBytes) + " bytes sent, " + String(Len(as_cmd)) + " expected."
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If

// Flush outgoing data
ll_RetVal = cryptFlushData(il_session)
If ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptFlushData: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If

as_Reply = ""
ll_ReplyBytes = 0

do while ll_ReplyBytes = 0
	// wait before getting data
	SleepMS(il_sleeptime)
	// get next Reply
	ls_Buffer = Space(256)
	ll_RetVal = cryptPopData(il_session, ls_Buffer, Len(ls_Buffer), ll_ReplyBytes)
	If ll_RetVal <> CRYPT_OK Then
		ls_msg = "cryptPopData: " + of_CryptError(ll_RetVal)
		of_SetLastError(ls_msg)
		of_LogError(iERROR, ls_msg)
		Return False
	End If
loop

If as_cmd = "QUIT" + CRLF Then
	// add previous Buffer to Reply
	as_Reply += Left(ls_Buffer, ll_ReplyBytes)
	of_LogFile(as_Reply)
	Return True
End If

do while ll_ReplyBytes > 0
	// update progress
	il_recvdbytes = il_recvdbytes + ll_ReplyBytes
	of_Progress_Update(il_recvdbytes)
	// wait before getting data
	SleepMS(il_sleeptime)
	// add previous Buffer to Reply
	as_Reply += Left(ls_Buffer, ll_ReplyBytes)
	// get next Reply
	ls_Buffer = Space(256)
	ll_RetVal = cryptPopData(il_session, ls_Buffer, Len(ls_Buffer), ll_ReplyBytes)
	If ll_RetVal <> CRYPT_OK Then
		ls_msg = "cryptPopData: " + of_CryptError(ll_RetVal)
		of_SetLastError(ls_msg)
		of_LogError(iERROR, ls_msg)
		Return False
	End If
loop

// check the reply for errors
If Left(as_Reply, 3) <> "+OK" Then
	ls_msg = "Command failed: " + as_Reply
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If

of_LogFile(as_Reply)

Return True

end function

public function boolean of_recvmail_crypt_stop ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_recvmail_crypt_Stop
//
// PURPOSE:    This function ends the encrypted sendmail session.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// -----------------------------------------------------------------------------

String ls_msg, ls_reply

// update progress
of_Progress_Message("Disconnecting from the server")

// quit the session
ls_msg = "QUIT" + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	cryptEnd()
	Return False
End If

// Close the session
cryptDestroySession(il_Session)

// Close the Library
cryptEnd()

Return True

end function

public function boolean of_recvmail_crypt_start ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail_Crypt_Start
//
// PURPOSE:    This function starts the encrypted recvmail session for port 995.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// 12/30/2013	RolandS		Added logging
// 12/30/2013	RolandS		Added call to set certificate compliance level
// 01/02/2014	RolandS		Added call to disable name checking
// -----------------------------------------------------------------------------

String ls_reply, ls_msg
Long ll_RetVal, ll_ReplyBytes, ll_Version

// update progress
of_Progress_Message("Connecting to the server")

// Initialize the Library
ll_RetVal = cryptInit()
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptInit: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	Return False
End If
of_LogFile("cryptInit: OK")

// Create the session
ll_RetVal = cryptCreateSession(il_Session, CRYPT_UNUSED, CRYPT_SESSION_SSL)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptCreateSession: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptCreateSession: OK")

// Set compliance level
ll_RetVal = cryptSetAttribute(il_Session, &
		CRYPT_OPTION_CERT_COMPLIANCELEVEL, CRYPT_COMPLIANCELEVEL_OBLIVIOUS)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptSetAttribute (Set compliance level): " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptSetAttribute (Set compliance level): OK")

// Disable name checking
ll_RetVal = cryptSetAttribute(il_Session, &
		CRYPT_SESSINFO_SSL_OPTIONS, CRYPT_SSLOPTION_DISABLE_NAMEVERIFY)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptSetAttribute (Disable name checking): " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptSetAttribute (Disable name checking): OK")

// Add the server name
ll_RetVal = cryptSetAttributeString(il_Session, &
						CRYPT_SESSINFO_SERVER_NAME, is_server, Len(is_server)) 
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptSetAttributeString (Add the server name): " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptSetAttributeString (Add the server name): OK")

// Specify the Port
ll_RetVal = cryptSetAttribute(il_Session, &
						CRYPT_SESSINFO_SERVER_PORT, iui_port)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptSetAttribute (Specify the Port): " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptSetAttribute (Specify the Port): OK")

// Activate the session
ll_RetVal = cryptSetAttribute(il_Session, CRYPT_SESSINFO_ACTIVE, 1) 
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptSetAttribute (Activate the session): " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptSetAttribute (Activate the session): OK")

// Remove any response created by connecting
ls_Reply = Space(256)
ll_RetVal = cryptPopData(il_session, &
						ls_Reply, Len(ls_Reply), ll_ReplyBytes)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptPopData: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptPopData: OK")

// update progress
of_Progress_Message("Logging into the server")

// send the Userid
ls_msg = "USER " + is_userid + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	Return False
End If

// send the Password
ls_msg = "PASS " + is_passwd + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	Return False
End If

// Remove any response created by setting the userid/password
ls_Reply = Space(256)
ll_RetVal = cryptPopData(il_session, &
						ls_Reply, Len(ls_Reply), ll_ReplyBytes)
IF ll_RetVal <> CRYPT_OK Then
	ls_msg = "cryptPopData: " + of_CryptError(ll_RetVal)
	of_SetLastError(ls_msg)
	of_LogError(iERROR, ls_msg)
	cryptEnd()
	Return False
End If
of_LogFile("cryptPopData: OK")

Return True

end function

private subroutine of_separate (readonly string as_content, ref string as_part[], ref string as_type[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Separate
//
// PURPOSE:    This function is used to separate message parts.
//
// ARGUMENTS:  as_content	- The message content
//					as_part		- Array of parts (by ref)
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 03/17/2012	RolandS		Added Base64 Encoding support
// 04/11/2012	RolandS		Corrected parsing issues
// 04/13/2012	RolandS		Moved base64 decoding to of_Base64
// 08/05/2013	RolandS		Changed to handle content-type and
//									content-transfer-encoding in different order
// -----------------------------------------------------------------------------

String ls_boundary, ls_body, ls_work, ls_part[]
Long ll_pos, ll_idx, ll_max, ll_index
Boolean lb_ContentFound

ls_boundary = Mid(as_content, Pos(as_content, "boundary=") + 9, 256)
ls_boundary = Left(ls_boundary, Pos(ls_boundary, CRLF) - 1)
If Left(ls_boundary, 1) = "~"" Then
	ls_boundary = Mid(ls_boundary, 2)
	ls_boundary = Left(ls_boundary, Pos(ls_boundary, "~"") - 1)
End If
ls_boundary = "--" + ls_boundary

ll_pos = Pos(as_content, ls_boundary)
ls_body = Mid(as_content, ll_pos + Len(ls_boundary))

ll_max = of_Parse(ls_body, ls_boundary, ls_part)
For ll_idx = 1 To ll_max
	ll_pos = Pos(Lower(ls_part[ll_idx]), CRLF + "content-type: ")
	If ll_pos > 0 Then
		lb_ContentFound = True
		ls_work = Mid(ls_part[ll_idx], ll_pos + 2)
		If Lower(Left(ls_work, 24)) = "content-type: multipart/" Then
			of_Separate(ls_work, as_part, as_type)
		Else
			ll_index = UpperBound(as_part) + 1
			// separate out part content
			ll_pos = Pos(ls_work, CRLF + CRLF)
			as_part[ll_index] = Mid(ls_work, ll_pos + 4)
			If Left(as_part[ll_index], 2) = CRLF Then
				as_part[ll_index] = Mid(as_part[ll_index], 3)
			End If
			If Right(as_part[ll_index], 2) = CRLF Then
				as_part[ll_index] = Left(as_part[ll_index], Len(as_part[ll_index]) - 2)
			End If
			// separate out the content type
			ls_work = Left(ls_work, ll_pos - 1)
			ls_work = of_ReplaceAll(ls_work, "~t", ";")
			ls_work = of_ReplaceAll(ls_work, "~r~n", ";")
			ls_work = of_ReplaceAll(ls_work, ";;;", ";")
			ls_work = of_ReplaceAll(ls_work, ";;", ";")
			ls_work = of_ReplaceAll(ls_work, "ype:text", "ype: text")
			If Left(ls_work, 1) = ";" Then
				ls_work = Mid(ls_work, 2)
			End If
			as_type[ll_index] = ls_work
			// determine encoding
			ls_work = Lower(ls_work)
			If Left(ls_work, 19) = "content-type: text/" Then
				ls_work = Lower(Left(ls_part[ll_idx], 25000))
				ll_pos = Pos(ls_work, CRLF + "content-transfer-encoding:")
				If ll_pos > 0 Then
					ls_work = of_ReplaceAll(ls_work, "~r~n", ";")
					ll_pos = Pos(ls_work, "content-transfer-encoding:")
					ls_work = Mid(ls_work, ll_pos + 26) + ";"
					ls_work = Trim(Left(ls_work, Pos(ls_work, ";") - 1))
					choose case ls_work
						case "quoted-printable"
							of_QuotedPrintable(as_part[ll_index])
						case "base64"
							of_Base64(as_type[ll_index], as_part[ll_index])
					end choose
				End If
			End If
			// remove trailing CRLF
			do while Right(as_part[ll_index], 2) = CRLF
				as_part[ll_index] = Left(as_part[ll_index], Len(as_part[ll_index]) - 2)
			loop
		End If
	End If
Next

If Not lb_ContentFound Then
	of_Separate(ls_body, as_part, as_type)
End If

end subroutine

public function string of_msgproperty (integer ai_msgnum, string as_property);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgSubject
//
// PURPOSE:    This function returns the subject of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//					as_property	- Name of the property to return
//
// RETURN:     Property value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_pos
String ls_result

ll_pos = Pos(is_email[ai_msgnum], "~n" + as_property + ":")
If ll_pos > 0 Then
	ll_pos = ll_pos + Len(as_property) + 2
	ls_result = Trim(Mid(is_email[ai_msgnum], ll_pos, 250))
	ls_result = Left(ls_result, Pos(ls_result, CRLF))
	If Left(ls_result, 1) = "<" Then
		ls_result = Mid(ls_result, 2)
		ll_pos = LastPos(ls_result, ">")
		ls_result = Left(ls_result, ll_pos - 1)
	End If
End If

Return Trim(ls_result)

end function

public function integer of_msgbody (integer ai_msgnum, ref string as_part[], ref string as_type[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgBody
//
// PURPOSE:    This function returns the parts of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//					as_part		- Body Parts (by ref)
//					as_type		- Body Part Content Type (by ref)
//
// RETURN:     Number of parts
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 03/17/2012	RolandS		Added Base64 Encoding support
// 04/03/2012	RolandS		Changes to how encoding parsed
// 04/13/2012	RolandS		Moved base64 decoding to of_Base64
// -----------------------------------------------------------------------------

String ls_empty[], ls_work
Long ll_pos, ll_index = 1

// initialize
as_part = ls_empty
as_type = ls_empty

// break out the body content from headers
ls_work = Lower(Left(is_email[ai_msgnum], 25000))
ll_pos = Pos(ls_work, "~ncontent-type:")
If ll_pos = 0 Then
	ll_pos = Pos(ls_work, CRLF + CRLF)
	as_part[ll_index] = Mid(is_email[ai_msgnum], ll_pos + 4)
	as_type[ll_index] = "Content-Type: text/plain;"
	Return ll_index
End If
ls_work = Mid(is_email[ai_msgnum], ll_pos + 1)

// remove trailing CRLF
do while Right(ls_work, 2) = CRLF
	ls_work = Left(ls_work, Len(ls_work) - 2)
loop

// check for multipart
If Lower(Left(ls_work, 24)) = "content-type: multipart/" Then
	of_Separate(ls_work, as_part, as_type)
Else
	// separate out part content
	ll_pos = Pos(ls_work, CRLF + CRLF)
	as_part[ll_index] = Mid(ls_work, ll_pos + 4)
	If Right(as_part[ll_index], 2) = CRLF Then
		as_part[ll_index] = Left(as_part[ll_index], Len(as_part[ll_index]) - 2)
	End If
	// separate out the content type
	ls_work = Left(ls_work, ll_pos - 1)
	ls_work = of_ReplaceAll(ls_work, "~t", ";")
	ls_work = of_ReplaceAll(ls_work, "~r~n", ";")
	ls_work = of_ReplaceAll(ls_work, ";;;", ";")
	ls_work = of_ReplaceAll(ls_work, ";;", ";")
	ls_work = of_ReplaceAll(ls_work, "ype:text", "ype: text")
	If Left(ls_work, 1) = ";" Then
		ls_work = Mid(ls_work, 2)
	End If
	as_type[ll_index] = ls_work
	// determine encoding
	ls_work = Lower(Left(is_email[ai_msgnum], 25000))
	ll_pos = Pos(ls_work, CRLF + "content-transfer-encoding:")
	If ll_pos > 0 Then
		ls_work = of_ReplaceAll(ls_work, "~r~n", ";")
		ll_pos = Pos(ls_work, "content-transfer-encoding:")
		ls_work = Mid(ls_work, ll_pos + 28) + ";"
		ls_work = Trim(Left(ls_work, Pos(ls_work, ";") - 1))
		ls_work = Trim(Left(ls_work, Pos(ls_work, CRLF) - 1))
		choose case ls_work
			case "quoted-printable"
				of_QuotedPrintable(as_part[ll_index])
			case "base64"
				of_Base64(as_type[ll_index], as_part[ll_index])
		end choose
	End If
	// remove trailing CRLF
	do while Right(as_part[ll_index], 2) = CRLF
		as_part[ll_index] = Left(as_part[ll_index], Len(as_part[ll_index]) - 2)
	loop
End If

Return UpperBound(as_part)

end function

public function integer of_msgload (string as_filename);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgLoad
//
// PURPOSE:    This function loads a message from a file.
//
// ARGUMENTS:  as_filename - File name of an email message file (.eml)
//
// RETURN:     Message number
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/10/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_index
Blob lblob_data

If of_ReadFile(as_filename, lblob_data) Then
	li_index = UpperBound(is_email) + 1
	is_email[li_index] = String(lblob_data, EncodingAnsi!)
	is_uidl[li_index] = ""
End If

Return li_index

end function

private function boolean of_readfile (string as_filename, ref blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_ReadFile
//
// PURPOSE:    This function is used to read a file from disk to a blob.
//
// ARGUMENTS:  as_filename - Filename
//					ablob_data	- By ref blob to receive the file contents
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/10/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_bytes, lul_length
Long ll_hFile
Blob lblob_filedata
Boolean lb_result

// get file length
lul_length = FileLength(as_filename)

// open file for read
ll_hFile = CreateFile(as_filename, GENERIC_READ, &
					FILE_SHARE_READ, 0, OPEN_EXISTING, 0, 0)
If ll_hFile = INVALID_HANDLE_VALUE Then
	Return False
End If

// read the entire file contents in one shot
lblob_filedata = Blob(Space(lul_length), EncodingAnsi!)
lb_result = ReadFile(ll_hFile, lblob_filedata, &
					lul_length, lul_bytes, 0)
ablob_data = BlobMid(lblob_filedata, 1, lul_length)

// close the file
CloseHandle(ll_hFile)

Return lb_result

end function

public function integer of_hex2int (string as_hex);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Hex2Int
//
// PURPOSE:    This function converts hexidecimal to a number.
//
// ARGUMENTS:  as_string - Hexidecimal string
//
// RETURN:     Number
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/10/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_work
String ls_code, ls_hex = '123456789ABCDEF'
Long ll_rc, ll_lp

ls_code = Reverse(Upper(as_hex))
ll_rc = Len(ls_code)

For ll_lp = 1 To ll_rc
	li_work = li_work + Pos(ls_hex, &
			Mid(ls_code, ll_lp, 1), 1) * (16^(ll_lp - 1))
Next

Return li_work

end function

public subroutine of_quotedprintable (ref string as_content);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_QuotedPrintable
//
// PURPOSE:    This function decodes quoted-printable text.
//
// ARGUMENTS:  as_content 	- Text content (by ref)
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/10/2012	RolandS		Initial coding
// 04/18/2012	RolandS		Added check for spaces encoded as underscore
// -----------------------------------------------------------------------------

String ls_hex, ls_findstr, ls_replace
Integer li_char
Long ll_pos

// Equal signs at end of lines
as_content = of_ReplaceAll(as_content, "="+CRLF, "")

// Encoded Space
as_content = of_ReplaceAll(as_content, "_", " ")

// Decode all except Equal signs
ll_pos = Pos(as_content, "=")
do while ll_pos > 0
	ls_hex = Mid(as_content, ll_pos + 1, 2)
	If ls_hex = "3D" Then
	Else
		li_char = of_hex2int(ls_hex)
		If li_char > 0 Then
			ls_findstr = "="+ls_hex
			ls_replace = Char(li_char)
			as_content = of_ReplaceAll(as_content, ls_findstr, ls_replace)
		End If
	End If
	ll_pos = Pos(as_content, "=", ll_pos + 1)
loop

// Encoded Equal signs
as_content = of_ReplaceAll(as_content, "=3D", "=")

end subroutine

public function string of_attachname (string as_type);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_AttachName
//
// PURPOSE:    This function extracts attachment file name from content type.
//
// ARGUMENTS:  as_type - The message Content-Type string
//
// RETURN:     Filename
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/14/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_filename
Long ll_pos

ll_pos = Pos(as_type, "filename=")

ls_filename = Mid(as_type, ll_pos + 10)

ll_pos = Pos(ls_filename, "~"")

ls_filename = Left(ls_filename, ll_pos - 1)

Return  ls_filename

end function

public function string of_replaceall (readonly string as_oldstring, readonly string as_findstr, readonly string as_replace);// -----------------------------------------------------------------------------
// FUNCTION:	n_pop3.of_ReplaceAll
//
// PURPOSE:		This function replaces all occurrences of one string in another.
//
// ARGUMENTS:	as_oldstring	- The string to search within
//					as_findstr		- The string to look for
//					as_replace		- The string to replace with
//
// RETURN:		Updated string
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 06/24/2008	RolandS		Initial coding
// 03/17/2012	RolandS		Changed arguments to readonly
// -----------------------------------------------------------------------------

String ls_newstring
Long ll_findstr, ll_replace, ll_pos

// get length of strings
ll_findstr = Len(as_findstr)
ll_replace = Len(as_replace)

// find first occurrence
ls_newstring = as_oldstring
ll_pos = Pos(ls_newstring, as_findstr)

Do While ll_pos > 0
	// replace old with new
	ls_newstring = Replace(ls_newstring, ll_pos, ll_findstr, as_replace)
	// find next occurrence
	ll_pos = Pos(ls_newstring, as_findstr, (ll_pos + ll_replace))
Loop

Return ls_newstring

end function

public function boolean of_writefile (readonly string as_filename, readonly blob ablob_filedata);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_WriteFile
//
// PURPOSE:    This function writes a blob to a file on disk.
//
// ARGUMENTS:  as_filename		- The name of the file
//					ablob_filedata	- The blob data of the file
//
// RETURN:		0	= Success
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/10/2012	RolandS		Initial coding
// 03/17/2012	RolandS		Changed arguments to readonly
// -----------------------------------------------------------------------------

ULong lul_file, lul_length, lul_written
Boolean lb_rtn

lul_length = Len(ablob_filedata)

// open file for write
lul_file = CreateFile(as_filename, GENERIC_WRITE, &
					FILE_SHARE_WRITE, 0, CREATE_ALWAYS, 0, 0)
If lul_file = INVALID_HANDLE_VALUE Then
	Return False
End If

// write file to disk
lb_rtn = WriteFile(lul_file, ablob_filedata, &
					lul_Length, lul_written, 0)

// close the file
CloseHandle(lul_file)

Return True

end function

public subroutine of_decodestring (ref string as_string);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_DecodeString
//
// PURPOSE:    This function decodes encoded strings.
//
// ARGUMENTS:  as_string - The string to be decoded
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/21/2012	RolandS		Initial coding
//	04/18/2012	RolandS		Added handling for Subject going to next line
//									Changed GB2312 to Ansi
// -----------------------------------------------------------------------------

Long ll_pos

// quoted-printable
If Left(as_string, 15) = "=?iso-8859-1?Q?" Then
	as_string = Mid(as_string, 16, Len(as_string) - 17)
	ll_pos = Pos(as_string, "?= =?iso-8859-1?Q?")
	If ll_pos > 0 Then
		as_string = Left(as_string, ll_pos - 1) + &
							Mid(as_string, ll_pos + 18)
	End If
	of_QuotedPrintable(as_string)
	Return
End If
If Left(as_string, 10) = "=?utf-8?Q?" Then
	as_string = Mid(as_string, 11, Len(as_string) - 12)
	ll_pos = Pos(as_string, "?= =?utf-8?Q?")
	If ll_pos > 0 Then
		as_string = Left(as_string, ll_pos - 1) + &
							Mid(as_string, ll_pos + 13)
	End If
	of_QuotedPrintable(as_string)
	Return
End If

// base64
If Left(as_string, 15) = "=?iso-8859-1?B?" Then
	as_string = Mid(as_string, 16, Len(as_string) - 17)
	ll_pos = Pos(as_string, "?= =?iso-8859-1?B?")
	If ll_pos > 0 Then
		as_string = Left(as_string, ll_pos - 1) + &
							Mid(as_string, ll_pos + 18)
	End If
	as_string = String(of_Decode64(as_string), EncodingUTF8!)
	Return
End If
If Left(as_string, 10) = "=?UTF-8?B?" Then
	as_string = Mid(as_string, 11, Len(as_string) - 12)
	ll_pos = Pos(as_string, "?= =?UTF-8?B?")
	If ll_pos > 0 Then
		as_string = Left(as_string, ll_pos - 1) + &
							Mid(as_string, ll_pos + 13)
	End If
	as_string = String(of_Decode64(as_string), EncodingUTF8!)
	Return
End If
If Left(as_string, 11) = "=?GB2312?B?" Then
	as_string = Mid(as_string, 12, Len(as_string) - 13)
	ll_pos = Pos(as_string, "?= =?GB2312?B?")
	If ll_pos > 0 Then
		as_string = Left(as_string, ll_pos - 1) + &
							Mid(as_string, ll_pos + 14)
	End If
	as_string = String(of_Decode64(as_string), EncodingAnsi!)
	Return
End If

end subroutine

public function boolean of_msgreceipt (integer ai_msgnum, ref string as_name, ref string as_email);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgReceipt
//
// PURPOSE:    This function returns the Reply Receipt name/address of
//					an email message if one was provided.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//					as_name		- From name (by ref)
//					as_email		- From email (by ref)
//
// RETURN:     True = Reply Receipt found, False = not found
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/24/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_pos
String ls_result

as_name  = ""
as_email = ""

ll_pos = Pos(is_email[ai_msgnum], "~nDisposition-Notification-To:")
If ll_pos = 0 Then
	Return False
Else
	// parse out From: line
	ls_result = Trim(Mid(is_email[ai_msgnum], ll_pos + 29, 250))
	ls_result = Left(ls_result, Pos(ls_result, CRLF) - 1)
	// separate name & email
	ll_pos = Pos(ls_result, "<")
	If ll_pos > 1 Then
		ll_pos = ll_pos + 1
		as_email = Mid(ls_result, ll_pos, Len(ls_result) - ll_pos)
		as_name  = Left(ls_result, ll_pos - 3)
		of_DecodeString(as_name)
		If Left(as_name, 1) = "~"" Then
			as_name = Mid(as_name, 2)
		End If
		If Right(as_name, 1) = "~"" Then
			as_name = Left(as_name, Len(as_name) - 1)
		End If
	Else
		of_DecodeString(ls_result)
		If Left(ls_result, 1) = "~"" Then
			ls_result = Mid(ls_result, 2)
		End If
		If Right(ls_result, 1) = "~"" Then
			ls_result = Left(ls_result, Len(ls_result) - 1)
		End If
		as_email = ls_result
		as_name  = as_email
	End If
	Return True
End If

end function

public subroutine of_progress_done ();// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Progress_Done
//
// PURPOSE:    This function notifies the progress bar that the process is done.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If il_window > 0 Then
	// 1=Start, 2=Update, 3=Done
	Send(il_window, il_event, 3, 0)
	Yield()
End If

end subroutine

public subroutine of_progress_message (string as_message);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Progress_Message
//
// PURPOSE:    This function sends a text message to the progress event.
//
// ARGUMENTS:  as_message	- The status message to be displayed
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If il_window > 0 Then
	SendStringMessage(il_window, il_event, 0, as_message)
	Yield()
End If

end subroutine

public subroutine of_progress_notify (long al_window, long al_event);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Progress_Notify
//
// PURPOSE:    This function records the window handle and custom event number
//					that will be notified when progress is made.
//
// ARGUMENTS:  al_window	- Handle of the window to be notified
//					al_event		- Custom Event number ( 1 - 75 )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_window = al_window
il_event  = 1023 + al_event

end subroutine

public subroutine of_progress_start (long al_length);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Progress_Start
//
// PURPOSE:    This function notifies the progress bar process is starting.
//
// ARGUMENTS:  al_length	- Number of bytes downloaded so far
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

If il_window > 0 Then
	il_totalbytes = al_length
	// 1=Start, 2=Update, 3=Done
	Send(il_window, il_event, 1, 0)
	Yield()
End If

end subroutine

public subroutine of_progress_update (long al_length);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Progress_Update
//
// PURPOSE:    This function notifies the progress bar with percent complete.
//
// ARGUMENTS:  al_length	- Number of bytes downloaded so far
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_percent

If il_window > 0 Then
	If il_totalbytes > 0 Then
		ll_percent = 100 * (al_length / il_totalbytes)
		// 1=Start, 2=Update, 3=Done
		Send(il_window, il_event, 2, ll_percent)
		Yield()
	End If
End If

end subroutine

public subroutine of_setsleeptime (long al_sleeptime);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_SetSleepTime
//
// PURPOSE:    This function sets the sleep time used in several places in the
//					download process.
//
// ARGUMENTS:  al_sleeptime	- Sleep interval in milliseconds.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/03/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_sleeptime = al_sleeptime

end subroutine

public subroutine of_base64 (readonly string as_type, ref string as_part);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_Base64
//
// PURPOSE:    This function decodes base64 encoded messages.
//
//					Note that the PB8 and PB10 versions of this function are
//					very different due to Unicode conversion!
//
// ARGUMENTS:  as_type 	- Content descriptors
//					as_part	- Text content (by ref)
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/13/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_charset

ls_charset = Mid(as_type, Pos(as_type, "charset=") + 8)
ls_charset = Left(ls_charset, Pos(ls_charset, ";") - 1)

If Left(ls_charset, 1) = "~"" Then
	ls_charset = Mid(ls_charset, 2)
End If
If Right(ls_charset, 1) = "~"" Then
	ls_charset = Left(ls_charset, Len(ls_charset) - 1)
End If

choose case Lower(ls_charset)
	case "utf8", "utf-8"
		as_part = String(of_Decode64(as_part), EncodingUTF8!)
	case "gb2312"
		as_part = String(of_Decode64(as_part), EncodingAnsi!)
	case else
		as_part = String(of_Decode64(as_part), EncodingUTF8!)
end choose

end subroutine

public function boolean of_recvmail_msgs (boolean ab_delete, boolean ab_headers);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail_Msgs
//
// PURPOSE:    This function receives email messages from the server.
//
// ARGUMENTS:  ab_delete 	- Indicates whether messages are deleted from server
//					ab_headers	- True if only headers and first 10 lines of the
//									  messages are to be downloaded.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// 04/13/2012	RolandS		Added retrieval of UIDL (unique identifier)
// 04/13/2012	RolandS		Added ab_headers argument
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_content, ls_wrk, ls_empty[]
Integer li_cnt, li_idx, li_pos
Long ll_pos, ll_total, ll_bytes

is_email = ls_empty
is_uidl  = ls_empty

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_SendMsg(ls_msg, ls_reply) Then
	of_Close(iul_socket)
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))
ll_total = Long(Mid(ls_wrk, li_pos + 1))

of_Progress_Start(ll_total)

For li_idx = 1 To li_cnt
	// update progress
	of_Progress_Message("Downloading message " + String(li_idx) + " of " + String(li_cnt))
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_SendMsg(ls_msg, ls_reply) Then
		of_Close(iul_socket)
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// copy content to array (removing CRLF at end)
		If Right(ls_content, 2) = CRLF Then
			is_uidl[li_idx] = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	// send retrieve message
	If ab_headers Then
		ls_msg = "TOP " + String(li_idx) + " 10" + CRLF
	Else
		ls_msg = "RETR " + String(li_idx) + CRLF
	End If
	If Not of_SendMsg(ls_msg, ls_reply) Then
		of_Close(iul_socket)
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		// parse out data already received
		ll_pos = Pos(ls_reply, CRLF)
		ls_content = Mid(ls_reply, ll_pos + 2)
		ll_bytes = ll_bytes + Len(ls_content)
		of_Progress_Update(ll_bytes)
		// receive the rest of the data
		do while Right(ls_reply, 5) <> MSGEND
			// wait before continuing
			SleepMS(il_sleeptime)
			// receive the next block of data
			of_Recv(iul_socket, ls_reply)
			ls_content += ls_reply
			ll_bytes = ll_bytes + Len(ls_reply)
			of_Progress_Update(ll_bytes)
		loop
		// copy content to array (removing MSGEND)
		is_email[li_idx] = Left(ls_content, Len(ls_content) - 3)
		// delete message
		If ab_delete Then
			ls_msg = "DELE " + String(li_idx) + CRLF
			If Not of_SendMsg(ls_msg, ls_reply) Then
				of_Close(iul_socket)
				Return False
			End If
		End If
	Else
		of_SetLastError(ls_reply)
		of_LogError(iERROR, ls_reply)
		Return False
	End If
	// wait before continuing
	SleepMS(il_sleeptime)
Next

of_Progress_Done()

Return True

end function

public function boolean of_recvmail (boolean ab_delete, boolean ab_headers);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail
//
// PURPOSE:    This function is the main process to receive email messages.
//
// ARGUMENTS:  ab_delete 	- Whether messages are deleted from server
//					ab_headers	- True if only headers and first 10 lines of the
//									  messages are to be downloaded.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/13/2012	RolandS		Added ab_headers argument
// -----------------------------------------------------------------------------

DateTime ldt_current

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_RecvMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Start() Then
	Return False
End If

// receive the email messages
If Not of_RecvMail_Msgs(ab_delete, ab_headers) Then
	Return False
End If

// stop the server session
If Not of_RecvMail_Stop() Then
	Return False
End If

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_RecvMail End: " + String(ldt_current))

Return True

end function

public function boolean of_recvmail_crypt_msgs (boolean ab_delete, boolean ab_headers);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail_Crypt_Msgs
//
// PURPOSE:    This function receives the email messages from the server.
//
// ARGUMENTS:  ab_delete 	- Whether messages are deleted from server
//					ab_headers	- True if only headers and first 10 lines of the
//									  messages are to be downloaded.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/03/2012	RolandS		Added progress tracking
// 04/13/2012	RolandS		Added retrieval of UIDL (unique identifier)
// 04/13/2012	RolandS		Added ab_headers argument
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_content, ls_wrk, ls_empty[]
Integer li_cnt, li_idx, li_pos
Long ll_pos, ll_total

is_email = ls_empty
is_uidl  = ls_empty

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))
ll_total = Long(Mid(ls_wrk, li_pos + 1))
il_recvdbytes = 0

of_Progress_Start(ll_total)

For li_idx = 1 To li_cnt
	// update progress
	of_Progress_Message("Downloading message " + String(li_idx) + " of " + String(li_cnt))
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// copy content to array (removing CRLF at end)
		If Right(ls_content, 2) = CRLF Then
			is_uidl[li_idx] = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	// send retrieve message
	If ab_headers Then
		ls_msg = "TOP " + String(li_idx) + " 10" + CRLF
	Else
		ls_msg = "RETR " + String(li_idx) + CRLF
	End If
	If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		// copy content (removing status line)
		ls_content = Mid(ls_reply, Pos(ls_reply, CRLF) + 2)
		// copy content (removing MSGEND)
		is_email[li_idx] = Left(ls_content, Len(ls_content) - 3)
		// delete message
		If ab_delete Then
			ls_msg = "DELE " + String(li_idx) + CRLF
			If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
				Return False
			End If
		End If
	Else
		of_SetLastError(ls_reply)
		of_LogError(iERROR, ls_reply)
		Return False
	End If
	// wait before continuing
	SleepMS(il_sleeptime)
Next

of_Progress_Done()

Return True

end function

public function boolean of_recvsslmail (boolean ab_delete, boolean ab_headers);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvSSLMail
//
// PURPOSE:    This function is the main process to send the email.
//
// ARGUMENTS:  ab_delete 	- Whether messages are deleted from server
//					ab_headers	- True if only headers and first 10 lines of the
//									  messages are to be downloaded.
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/03/2012	RolandS		Initial coding
// 04/13/2012	RolandS		Added ab_headers argument
// -----------------------------------------------------------------------------

DateTime ldt_current

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_RecvSSLMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Crypt_Start() Then
	Return False
End If

// receive the email messages
If Not of_RecvMail_Crypt_Msgs(ab_delete, ab_headers) Then
	Return False
End If

// stop the server session
If Not of_RecvMail_Crypt_Stop() Then
	Return False
End If

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_RecvSSLMail End: " + String(ldt_current))

Return True

end function

public function datetime of_msgsentdate (integer ai_msgnum);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgSentDate
//
// PURPOSE:    This function returns the datetime the email message was sent.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//
// RETURN:     DateTime value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/13/2012	RolandS		Initial coding
// 02/26/2014	RolandS		Changed to handle when no time given
// -----------------------------------------------------------------------------

SYSTEMTIME lstr_UTCTime, lstr_LocalTime
String ls_date, ls_parts[], ls_time, ls_offset
Integer li_offset_hrs, li_offset_day
Boolean lb_OffsetPlus, lb_rtn
DateTime ldt_datetime
Date ld_date
Time lt_time
Long ll_pos

ls_date = of_MsgProperty(ai_msgnum, "Date")

ll_pos = Pos(ls_date, ",")
If ll_pos > 0 Then
	ls_date = Trim(Mid(ls_date, ll_pos + 1))
End If

of_Parse(ls_date, " ", ls_parts)

// prevent out of array range abort
ls_parts[9] = ""

ls_offset = ls_parts[5]
If Left(ls_offset, 1 ) = "+" Then
	lb_OffsetPlus = True
	li_offset_hrs = Integer(Mid(ls_offset, 2, 2))
End If

lstr_UTCTime.wDay = Integer(ls_parts[1])

choose case Lower(ls_parts[2])
	case "jan"
		lstr_UTCTime.wMonth = 1
	case "feb"
		lstr_UTCTime.wMonth = 2
	case "mar"
		lstr_UTCTime.wMonth = 3
	case "apr"
		lstr_UTCTime.wMonth = 4
	case "may"
		lstr_UTCTime.wMonth = 5
	case "jun"
		lstr_UTCTime.wMonth = 6
	case "jul"
		lstr_UTCTime.wMonth = 7
	case "aug"
		lstr_UTCTime.wMonth = 8
	case "sep"
		lstr_UTCTime.wMonth = 9
	case "oct"
		lstr_UTCTime.wMonth = 10
	case "nov"
		lstr_UTCTime.wMonth = 11
	case "dec"
		lstr_UTCTime.wMonth = 12
end choose

lstr_UTCTime.wYear = Integer(ls_parts[3])

ls_time = ls_parts[4]
of_Parse(ls_time, ":", ls_parts)

If UpperBound(ls_parts) < 3 Then
	// no time was given
	lstr_LocalTime = lstr_UTCTime
Else
	// convert UTC Time to Local Time
	lstr_UTCTime.wHour   = Integer(ls_parts[1])
	lstr_UTCTime.wMinute = Integer(ls_parts[2])
	lstr_UTCTime.wSecond = Integer(ls_parts[3])
	lb_rtn = SystemTimeToTzSpecificLocalTime(0, &
							lstr_UTCTime, lstr_LocalTime)
	If lb_OffsetPlus Then
		If lstr_LocalTime.wHour < li_offset_hrs Then
			lstr_LocalTime.wHour = (24 + lstr_LocalTime.wHour) - li_offset_hrs
			li_offset_day = -1
		Else
			lstr_LocalTime.wHour = lstr_LocalTime.wHour - li_offset_hrs
		End If
	Else
		lstr_LocalTime.wHour = lstr_LocalTime.wHour + li_offset_hrs
		If lstr_LocalTime.wHour > 23 Then
			lstr_LocalTime.wHour = lstr_LocalTime.wHour - 24
			li_offset_day = 1
		End If
	End If
End If

ld_date = Date( lstr_LocalTime.wYear, &
					 lstr_LocalTime.wMonth, &
					 lstr_LocalTime.wDay )
ld_date = RelativeDate(ld_date, li_offset_day)

lt_time = Time( lstr_LocalTime.wHour, &
					 lstr_LocalTime.wMinute, &
					 lstr_LocalTime.wSecond )

ldt_datetime = DateTime(ld_date, lt_time)

Return ldt_datetime

end function

public function integer of_msgadd (readonly string as_email, readonly string as_uidl);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgAdd
//
// PURPOSE:    This function loads a message from strings.
//
// ARGUMENTS:  as_email - Email content
//					as_uidl	- Unique identifier
//
// RETURN:     Message number
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Integer li_index

li_index = UpperBound(is_email) + 1

is_email[li_index] = as_email
is_uidl[li_index] = as_uidl

Return li_index

end function

public function string of_msguidl (integer ai_msgnum);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_MsgUIDL
//
// PURPOSE:    This function returns the unique identifier of an email message.
//
// ARGUMENTS:  ai_msgnum 	- Message number
//
// RETURN:     Unique identifier
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return is_uidl[ai_msgnum]

end function

public function boolean of_deletemail (string as_uidl[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_DeleteMail
//
// PURPOSE:    This function deletes specified email messages.
//
// ARGUMENTS:  as_uidl 	- Unique identifiers of the emails to delete
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_wrk, ls_uidl, ls_content
Integer li_pos, li_idx, li_cnt, li_idx2, li_cnt2
DateTime ldt_current

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_DeleteMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Start() Then
	Return False
End If

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_SendMsg(ls_msg, ls_reply) Then
	of_Close(iul_socket)
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))

li_cnt2 = UpperBound(as_uidl)

For li_idx = 1 To li_cnt
	ls_uidl = ""
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_SendMsg(ls_msg, ls_reply) Then
		of_Close(iul_socket)
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// remove any CRLF at end
		If Right(ls_content, 2) = CRLF Then
			ls_uidl = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	For li_idx2 = 1 To li_cnt2
		// delete this email if it matches
		If ls_uidl = as_uidl[li_idx2] Then
			// update progress
			of_Progress_Message("Deleting message " + &
					String(li_idx) + " from server")
			ls_msg = "DELE " + String(li_idx) + CRLF
			If Not of_SendMsg(ls_msg, ls_reply) Then
				of_Close(iul_socket)
				Return False
			End If
		End If
	Next
Next

// stop the server session
If Not of_RecvMail_Stop() Then
	Return False
End If

of_Progress_Done()

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_DeleteMail End: " + String(ldt_current))

Return True

end function

public function boolean of_recvmail (integer ai_msgnum[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvMail
//
// PURPOSE:    This function downloads specified email messages that were
//					downloaded in header only mode previously.
//
// ARGUMENTS:  ai_msgnum 	- Message numbers of the emails to download
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_wrk, ls_uidl, ls_content
Integer li_pos, li_idx, li_cnt, li_idx2, li_cnt2, li_msgnum
DateTime ldt_current
Long ll_pos

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_RecvMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Start() Then
	Return False
End If

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_SendMsg(ls_msg, ls_reply) Then
	of_Close(iul_socket)
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))

li_cnt2 = UpperBound(ai_msgnum)

For li_idx = 1 To li_cnt
	ls_uidl = ""
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_SendMsg(ls_msg, ls_reply) Then
		of_Close(iul_socket)
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// remove any CRLF at end
		If Right(ls_content, 2) = CRLF Then
			ls_uidl = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	For li_idx2 = 1 To li_cnt2
		// download this email if it matches
		li_msgnum = ai_msgnum[li_idx2]
		If ls_uidl = is_uidl[li_msgnum] Then
			// update progress
			of_Progress_Message("Downloading message " + &
					String(li_idx) + " from server")
			// send retrieve message
			ls_msg = "RETR " + String(li_idx) + CRLF
			If Not of_SendMsg(ls_msg, ls_reply) Then
				of_Close(iul_socket)
				Return False
			End If
			If Left(ls_reply, 3) = "+OK" Then
				// parse out data already received
				ll_pos = Pos(ls_reply, CRLF)
				ls_content = Mid(ls_reply, ll_pos + 2)
				// receive the rest of the data
				do while Right(ls_reply, 5) <> MSGEND
					// wait before continuing
					SleepMS(il_sleeptime)
					// receive the next block of data
					of_Recv(iul_socket, ls_reply)
					ls_content += ls_reply
				loop
				// copy content to array (removing MSGEND)
				is_email[li_msgnum] = Left(ls_content, Len(ls_content) - 3)
			End If
		End If
	Next
Next

// stop the server session
If Not of_RecvMail_Stop() Then
	Return False
End If

of_Progress_Done()

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_RecvMail End: " + String(ldt_current))

Return True

end function

public function boolean of_deletesslmail (string as_uidl[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_DeleteSSLMail
//
// PURPOSE:    This function deletes specified email messages.
//
// ARGUMENTS:  as_uidl 	- Unique identifiers of the emails to delete
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_wrk, ls_uidl, ls_content
Integer li_pos, li_idx, li_cnt, li_idx2, li_cnt2
DateTime ldt_current

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_DeleteSSLMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Crypt_Start() Then
	Return False
End If

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))

li_cnt2 = UpperBound(as_uidl)

For li_idx = 1 To li_cnt
	ls_uidl = ""
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// remove any CRLF at end
		If Right(ls_content, 2) = CRLF Then
			ls_uidl = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	For li_idx2 = 1 To li_cnt2
		// delete this email if it matches
		If ls_uidl = as_uidl[li_idx2] Then
			// update progress
			of_Progress_Message("Deleting message " + &
					String(li_idx) + " from server")
			ls_msg = "DELE " + String(li_idx) + CRLF
			If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
				Return False
			End If
		End If
	Next
Next

// stop the server session
If Not of_RecvMail_Crypt_Stop() Then
	Return False
End If

of_Progress_Done()

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_DeleteSSLMail End: " + String(ldt_current))

Return True

end function

public function boolean of_recvsslmail (integer ai_msgnum[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_pop3.of_RecvSSLMail
//
// PURPOSE:    This function downloads specified email messages that were
//					downloaded in header only mode previously.
//
// ARGUMENTS:  ai_msgnum 	- Message numbers of the emails to download
//
// RETURN:     True = Success, False = Failure
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/15/2012	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant	String MSGEND = CRLF + Char(46) + CRLF
String ls_msg, ls_reply, ls_wrk, ls_uidl, ls_content
Integer li_pos, li_idx, li_cnt, li_idx2, li_cnt2, li_msgnum
DateTime ldt_current
Long ll_pos

// log start of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("~r~nof_RecvSSLMail Start: " + String(ldt_current) + "~r~n")

// start the server session
If Not of_RecvMail_Crypt_Start() Then
	Return False
End If

// request the number of messages
ls_msg = "STAT" + CRLF
If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
	Return False
End If

// parse out msg count
ls_wrk = Mid(ls_reply, 5)
li_pos = Pos(ls_wrk, " ")
li_cnt = Integer(Left(ls_wrk, li_pos - 1))

li_cnt2 = UpperBound(ai_msgnum)

For li_idx = 1 To li_cnt
	ls_uidl = ""
	// get the unique identifier
	ls_msg = "UIDL " + String(li_idx) + CRLF
	If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
		Return False
	End If
	If Left(ls_reply, 3) = "+OK" Then
		ls_content = Mid(ls_reply, 9)
		// remove any CRLF at end
		If Right(ls_content, 2) = CRLF Then
			ls_uidl = Left(ls_content, Len(ls_content) - 2)
		End If
	End If
	For li_idx2 = 1 To li_cnt2
		// download this email if it matches
		li_msgnum = ai_msgnum[li_idx2]
		If ls_uidl = is_uidl[li_msgnum] Then
			// update progress
			of_Progress_Message("Downloading message " + &
					String(li_idx) + " from server")
			// send retrieve message
			ls_msg = "RETR " + String(li_idx) + CRLF
			If Not of_sendmsg_crypt(ls_msg, ls_reply) Then
				Return False
			End If
			If Left(ls_reply, 3) = "+OK" Then
				// copy content (removing status line)
				ls_content = Mid(ls_reply, Pos(ls_reply, CRLF) + 2)
				// copy content (removing MSGEND)
				is_email[li_msgnum] = Left(ls_content, Len(ls_content) - 3)
			Else
				of_SetLastError(ls_reply)
				of_LogError(iERROR, ls_reply)
				Return False
			End If
		End If
	Next
Next

// stop the server session
If Not of_RecvMail_Crypt_Stop() Then
	Return False
End If

of_Progress_Done()

// log end of POP3 conversation
ldt_current = DateTime(Today(), Now())
of_LogFile("of_RecvSSLMail End: " + String(ldt_current))

Return True

end function

on n_pop3.create
call super::create
end on

on n_pop3.destroy
call super::destroy
end on

