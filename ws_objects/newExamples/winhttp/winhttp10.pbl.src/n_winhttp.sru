$PBExportHeader$n_winhttp.sru
forward
global type n_winhttp from nonvisualobject
end type
type large_integer from structure within n_winhttp
end type
end forward

type large_integer from structure
	unsignedlong		low_part
	unsignedlong		high_part
end type

global type n_winhttp from nonvisualobject autoinstantiate
end type

type prototypes
Function ulong GetLastError( ) Library "kernel32.dll"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Function boolean QueryPerformanceFrequency ( &
	Ref large_integer lpFrequency &
	) Library "kernel32.dll"

Function boolean QueryPerformanceCounter ( &
	Ref large_integer lpPerformanceCount &
	) Library "kernel32.dll"

Function ulong FindMimeFromData ( &
	ulong pBC, &
	string pwzUrl, &
	blob pBuffer, &
	ulong cbSize, &
	ulong pwzMimeProposed, &
	ulong dwMimeFlags, &
	ref ulong ppwzMimeOut, &
	ulong dwReserved &
	) Library "urlmon.dll"

Function boolean WinHttpCloseHandle ( &
	ulong hInternet &
	) Library "winhttp.dll"

Function ulong WinHttpOpen ( &
	string pwszUserAgent, &
	ulong dwAccessType, &
	ulong pwszProxyName, &
	ulong pwszProxyBypass, &
	ulong dwFlags &
	) Library "winhttp.dll"

Function ulong WinHttpConnect ( &
	ulong hSession, &
	string pswzServerName, &
	uint nServerPort, &
	ulong dwReserved &
	) Library "winhttp.dll"

Function ulong WinHttpOpenRequest ( &
	ulong hConnect, &
	string pwszVerb, &
	string pwszObjectName, &
	ulong pwszVersion, &
	ulong pwszReferrer, &
	ulong ppwszAcceptTypes, &
	ulong dwFlags &
	) Library "winhttp.dll"

Function boolean WinHttpSendRequest ( &
	ulong hRequest, &
	ulong pwszHeaders, &
	ulong dwHeadersLength, &
	ulong lpOptional, &
	ulong dwOptionalLength, &
	ulong dwTotalLength, &
	ulong dwContext &
	) Library "winhttp.dll"

Function boolean WinHttpReceiveResponse ( &
	ulong hRequest, &
	ulong lpReserved &
	) Library "winhttp.dll"

Function boolean WinHttpQueryDataAvailable ( &
	ulong hRequest, &
	Ref ulong lpdwNumberOfBytesAvailable &
	) Library "winhttp.dll"

Function boolean WinHttpReadData ( &
	ulong hRequest, &
	Ref blob lpBuffer, &
	ulong dwNumberOfBytesToRead, &
	Ref ulong lpdwNumberOfBytesRead &
	) Library "winhttp.dll"

Function boolean WinHttpWriteData ( &
	ulong hRequest, &
	Ref blob lpBuffer, &
	ulong dwNumberOfBytesToWrite, &
	Ref ulong lpdwNumberOfBytesWritten &
	) Library "winhttp.dll"

Function boolean WinHttpSetTimeouts ( &
	ulong hInternet, &
	ulong dwResolveTimeout, &
	ulong dwConnectTimeout, &
	ulong dwSendTimeout, &
	ulong dwReceiveTimeout &
	) Library "winhttp.dll"

Function boolean WinHttpAddRequestHeaders ( &
	ulong hRequest, &
	string pwszHeaders, &
	ulong dwHeadersLength, &
	ulong dwModifiers &
	) Library "winhttp.dll"

end prototypes

type variables
Private:

// WinHttpOpen dwAccessType values
Constant ulong WINHTTP_ACCESS_TYPE_DEFAULT_PROXY	= 0
Constant ulong WINHTTP_ACCESS_TYPE_NO_PROXY			= 1
Constant ulong WINHTTP_ACCESS_TYPE_NAMED_PROXY		= 3

// WinHttpOpen prettifiers for optional parameters
Constant ulong WINHTTP_NO_PROXY_NAME	= 0
Constant ulong WINHTTP_NO_PROXY_BYPASS	= 0

// WinHttpConnect ServerPort values
Constant uint INTERNET_DEFAULT_PORT			= 0
Constant uint INTERNET_DEFAULT_HTTP_PORT	= 80
Constant uint INTERNET_DEFAULT_HTTPS_PORT	= 443

// WinHttpOpenRequest prettifers for optional parameters
Constant ulong WINHTTP_NO_REFERER				= 0
Constant ulong WINHTTP_DEFAULT_ACCEPT_TYPES	= 0

// WinHttpOpenRequest dwFlags values
Constant ulong WINHTTP_FLAG_BYPASS_PROXY_CACHE	= 256
Constant ulong WINHTTP_FLAG_SECURE					= 8388608

// WinHttpSendRequest prettifiers for optional parameters.
Constant ulong WINHTTP_NO_ADDITIONAL_HEADERS	= 0
Constant ulong WINHTTP_NO_REQUEST_DATA			= 0

// WinHttpAddRequestHeaders values for dwModifiers parameter.
Constant ulong WINHTTP_ADDREQ_FLAG_ADD     = 536870912	// 0x20000000
Constant ulong WINHTTP_ADDREQ_FLAG_REPLACE = 2147483648	// 0x80000000

// timeout values
Long il_ResolveTimeout	= 0
Long il_ConnectTimeout	= 60000
Long il_SendTimeout		= 30000
Long il_ReceiveTimeout	= 30000

ULong iul_session, iul_connect, iul_request
ULong iul_frequency, iul_begin
Long il_write_handle, il_write_event
String is_method

Public:

ULong LastErrorNum
String LastErrorText
String ResponseText
Double Elapsed

end variables

forward prototypes
public subroutine settimeouts (long al_resolvetimeout, long al_connecttimeout, long al_sendtimeout, long al_receivetimeout)
private subroutine closehandles ()
public function boolean setrequestheader (readonly string as_name, readonly string as_value)
public function boolean open (readonly string as_method, readonly string as_url)
private function unsignedlong geterrormsg (readonly string as_function, ref string as_msgtext)
public subroutine setwriteprogress (long al_handle, long al_event)
public subroutine perfbegin ()
public function double perfend ()
private function unsignedlong senddata (blob ablob_buffer, ref blob ablob_response)
public function unsignedlong send (readonly string as_data)
public function unsignedlong send (readonly blob ablob_data)
public function unsignedlong geturl (readonly string as_urlname, ref blob ablob_response)
public function unsignedlong send ()
public function unsignedlong posturl (readonly string as_urlname, readonly blob ablob_data, readonly string as_mimetype, ref blob ablob_response)
private function string stringfromptr (unsignedlong aul_ptr)
public function string getmimetype (readonly string as_filename, ref blob ablob_filedata)
public function string getmimetype (readonly string as_filename, ref string as_filedata)
public function string hex (unsignedlong aul_number, integer ai_digit)
public function string urlencode (string as_string)
end prototypes

public subroutine settimeouts (long al_resolvetimeout, long al_connecttimeout, long al_sendtimeout, long al_receivetimeout);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.SetTimeouts
//
// PURPOSE:		This function sets the timeout options. All are in
//					milliseconds.
//
// ARGUMENTS:	al_ResolveTimeout	-	Timeout for name resolution.
//												Default=0 (Infinite)
//					al_ConnectTimeout	-	Timeout for server connection requests.
//												Default=60000 (60 seconds)
//					al_SendTimeout		-	Timeout for sending requests.
//												Default=30000 (30 seconds)
//					al_ReceiveTimeout	-	Timeout for receiving a response.
//												Default=30000 (30 seconds)
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

il_ResolveTimeout	= al_ResolveTimeout
il_ConnectTimeout	= al_ConnectTimeout
il_SendTimeout		= al_SendTimeout
il_ReceiveTimeout	= al_ReceiveTimeout

end subroutine

private subroutine closehandles ();// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.CloseHandles
//
// PURPOSE:		This is a private function that closes open handles
//
// RETURN:		Error Number
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

If iul_request > 0 Then
	WinHttpCloseHandle(iul_request)
	iul_request = 0
End If

If iul_connect > 0 Then
	WinHttpCloseHandle(iul_connect)
	iul_connect = 0
End If

If iul_session > 0 Then
	WinHttpCloseHandle(iul_session)
	iul_session = 0
End If

end subroutine

public function boolean setrequestheader (readonly string as_name, readonly string as_value);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.SetRequestHeader
//
// PURPOSE:		This function adds a request header.
//
// ARGUMENTS:	as_name	- The name of the header
//					as_value	- The value of the header
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Constant String CRLF = "~r~n"
String ls_header
Boolean lb_results

ls_Header = Trim(as_name) + ": " + Trim(as_value) + CRLF
lb_Results = WinHttpAddRequestHeaders(iul_request, ls_Header, -1, &
						WINHTTP_ADDREQ_FLAG_ADD + WINHTTP_ADDREQ_FLAG_REPLACE)
If Not lb_Results Then
	LastErrorNum = GetErrorMsg("WinHttpAddRequestHeaders", LastErrorText)
	CloseHandles()
	Return False
End If

Return True

end function

public function boolean open (readonly string as_method, readonly string as_url);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.Open
//
// PURPOSE:		This function initiates the request.
//
// ARGUMENTS:	as_method	- The HTTP method such as GET or PUT
//					as_url		- The requested URL
//
// RETURN:		True=Success, False=Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Long ll_pos
String ls_url, ls_ServerName, ls_FileName
UInt lui_port = INTERNET_DEFAULT_HTTP_PORT
ULong lul_dwFlags
Boolean lb_results

// parse the URL into protocol, server and file
ll_pos = Pos(as_url, "://")
If ll_pos > 0 Then
	ls_url = Mid(as_url, ll_pos + 3)
	If Lower(Left(as_url, 5)) = "https" Then
		lui_port = INTERNET_DEFAULT_HTTPS_PORT
		lul_dwFlags = lul_dwFlags + WINHTTP_FLAG_SECURE
	End If
Else
	ls_url = as_url
End If
ll_pos = Pos(ls_url, "/")
If ll_pos = 0 Then
	ls_ServerName = ls_url
	ls_FileName = ""
Else
	ls_ServerName = Left(ls_url, ll_pos - 1)
	ls_FileName = Mid(ls_url, ll_pos + 1)
End If

// Use WinHttpOpen to obtain a session handle.
iul_session = WinHttpOpen(this.ClassName(), &
								 WINHTTP_ACCESS_TYPE_DEFAULT_PROXY, &
								 WINHTTP_NO_PROXY_NAME, &
								 WINHTTP_NO_PROXY_BYPASS, 0)
If iul_session = 0 Then
	LastErrorNum = GetErrorMsg("WinHttpOpen", LastErrorText)
	Return False
End If

// set the timeouts
lb_results = WinHttpSetTimeouts(iul_session, il_ResolveTimeout, &
						il_ConnectTimeout, il_SendTimeout, il_ReceiveTimeout)
If Not lb_Results Then
	LastErrorNum = GetErrorMsg("WinHttpSetTimeouts", LastErrorText)
	CloseHandles()
	Return False
End If

// Specify an HTTP server.
iul_connect = WinHttpConnect(iul_session, &
						ls_ServerName, lui_port, 0)
If iul_connect = 0 Then
	LastErrorNum = GetErrorMsg("WinHttpConnect", LastErrorText)
	CloseHandles()
	Return False
End If

// Note that use of WINHTTP_DEFAULT_ACCEPT_TYPES restricts
// the request to Text type files.

// Create an HTTP request handle.
is_method = Upper(as_method)
iul_request = WinHttpOpenRequest(iul_connect, is_method, &
						ls_FileName, 0, WINHTTP_NO_REFERER, &
						WINHTTP_DEFAULT_ACCEPT_TYPES, lul_dwFlags)
If iul_request = 0 Then
	LastErrorNum = GetErrorMsg("WinHttpOpenRequest", LastErrorText)
	CloseHandles()
	Return False
End If

Return True

end function

private function unsignedlong geterrormsg (readonly string as_function, ref string as_msgtext);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.GetErrorMsg
//
// PURPOSE:		This is a private function that gets the most recent
//					API error message.
//
// ARGUMENTS:	as_function	- The function that failed
//					as_msgtext	- The error message text (by ref)
//
// RETURN:		Error Number
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
ULong lul_rtn, lul_error
String ls_msgtext

lul_error = GetLastError()

ls_msgtext = Space(255)

lul_rtn = FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
				lul_error, LANG_NEUTRAL, ls_msgtext, Len(ls_msgtext), 0)

as_msgtext = as_function + ":~r~n~r~n" + Trim(ls_msgtext)

Return lul_error

end function

public subroutine setwriteprogress (long al_handle, long al_event);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.SetWriteProgress
//
// PURPOSE:		This function sets the object handle and event id that
//					write progress is reported to.
//					The al_event arg is 1023 + the pbm_custom## number.
//
// ARGUMENTS:	al_handle	-	Window/UserObject handle.
//					al_event		-	Event id of the event to trigger.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

il_write_handle	= al_handle
il_write_event		= al_event

end subroutine

public subroutine perfbegin ();// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.PerfBegin
//
// PURPOSE:		This function saves the current value of the
//					operating system's performance counter.
//
// RETURN:		Length of Response or -1 for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

LARGE_INTEGER lstr_counter

QueryPerformanceCounter(lstr_counter)

iul_begin = lstr_counter.low_part

end subroutine

public function double perfend ();// -----------------------------------------------------------------------------
// FUNCTION:	n_winhttp.PerfEnd
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
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------------

LARGE_INTEGER lstr_counter
Double ldbl_elapsed
ULong lul_end

QueryPerformanceCounter(lstr_counter)

lul_end = lstr_counter.low_part

If iul_frequency > 0 Then
	ldbl_elapsed = (lul_end - iul_begin) / iul_frequency
End If

Return ldbl_elapsed

end function

private function unsignedlong senddata (blob ablob_buffer, ref blob ablob_response);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.SendData
//
// PURPOSE:		This function sends the request and returns the response.
//
// ARGUMENTS:	ablob_buffer	- The data to be sent with the request
//					ablob_response	- The reponse data
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Boolean lb_results
ULong lul_size, lul_read, lul_written, lul_totalread
ULong lul_NextChunk, lul_BufferLen
Blob lblob_buffer

// start performance counter
PerfBegin()

// Send a request.
lb_Results = WinHttpSendRequest(iul_request, &
						WINHTTP_NO_ADDITIONAL_HEADERS, &
						0, WINHTTP_NO_REQUEST_DATA, 0, 0, 0)
If Not lb_Results Then
	LastErrorNum = GetErrorMsg("WinHttpSendRequest", LastErrorText)
	CloseHandles()
	Return 0
End If

// Write data to the server.
lul_BufferLen = Len(ablob_buffer)
If lul_BufferLen > 0 Then
	lul_NextChunk = 1
	do while lul_NextChunk <= lul_BufferLen
		// break out a chunk of data
		lblob_buffer = BlobMid(ablob_buffer, lul_NextChunk, 8192)
		lul_size = Len(lblob_buffer)
		// write the chunk to the server
		lb_Results = WinHttpWriteData(iul_request, &
								lblob_buffer, lul_size, lul_written)
		If Not lb_Results Then
			LastErrorNum = GetErrorMsg("WinHttpWriteData", LastErrorText)
			CloseHandles()
			Return 0
		End If
		lul_NextChunk += lul_size 
		SetNull(lblob_buffer)
		// trigger progress event
		If il_write_handle > 0 Then
			Send(il_write_handle, il_write_event, lul_NextChunk, lul_BufferLen)
		End If
	loop
End If

// End the request.
lb_Results = WinHttpReceiveResponse(iul_request, 0)
If Not lb_Results Then
	LastErrorNum = GetErrorMsg("WinHttpReceiveResponse", LastErrorText)
	CloseHandles()
	Return 0
End If

// Keep checking for response data until there is nothing left.
do
	// Check for available data.
	lul_size = 0
	If Not WinHttpQueryDataAvailable(iul_request, lul_size) Then
		LastErrorNum = GetErrorMsg("WinHttpQueryDataAvailable", LastErrorText)
		CloseHandles()
		Return 0
	End If
	If lul_size > 0 Then
		// Allocate space for the buffer.
		lblob_buffer = Blob(Space(lul_size+1), EncodingAnsi!)
		// Read the Data.
		If Not WinHttpReadData(iul_request, &
						lblob_buffer, lul_size, lul_read) Then
			LastErrorNum = GetErrorMsg("WinHttpReadData", LastErrorText)
			CloseHandles()
			Return 0
		End If
		lul_totalread = lul_totalread + lul_read
		// Append data to by reference argument
		ablob_response += BlobMid(lblob_buffer, 1, lul_read)
		// Free the memory allocated to the buffer.
		SetNull(lblob_buffer)
	End If
loop while lul_size > 0

// Close any open handles.
CloseHandles()

// end performance counter
Elapsed = PerfEnd()

Return lul_totalread

end function

public function unsignedlong send (readonly string as_data);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.Send
//
// PURPOSE:		This function sends the request and saves the response
//					in instance variable ResponseText.
//
// ARGUMENTS:	ablob_data	- The data being sent
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

ULong lul_length
Blob lblob_data, lblob_response

lblob_data = Blob(as_data, EncodingAnsi!)

lul_length = SendData(lblob_data, lblob_response)
If lul_length > 0 Then
	ResponseText = String(lblob_response, EncodingAnsi!)
Else
	ResponseText = ""
End If

Return lul_length

end function

public function unsignedlong send (readonly blob ablob_data);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.Send
//
// PURPOSE:		This function sends the request and saves the response
//					in instance variable ResponseText.
//
// ARGUMENTS:	ablob_data	- The data being sent
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

ULong lul_length
Blob lblob_response

lul_length = SendData(ablob_data, lblob_response)
If lul_length > 0 Then
	ResponseText = String(lblob_response, EncodingAnsi!)
Else
	ResponseText = ""
End If

Return lul_length

end function

public function unsignedlong geturl (readonly string as_urlname, ref blob ablob_response);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.GetURL
//
// PURPOSE:		This function duplicates the standard GetURL function
//					except it returns the result instead of an
//					InternetResult object reference.
//
// ARGUMENTS:	as_urlname		- The URL whose source data is returned
//					ablob_response	- The source data being returned
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Blob lblob_buffer

If Open("GET", as_urlname) = False Then
	Return 0
End If

Return SendData(lblob_buffer, ablob_response)

end function

public function unsignedlong send ();// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.Send
//
// PURPOSE:		This function sends the request and saves the response
//					in instance variable ResponseText.
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

Blob lblob_data

Return Send(lblob_data)

end function

public function unsignedlong posturl (readonly string as_urlname, readonly blob ablob_data, readonly string as_mimetype, ref blob ablob_response);// -----------------------------------------------------------------------
// SCRIPT:		n_winhttp.PostURL
//
// PURPOSE:		This function duplicates the standard PostURL function
//					except it returns the result instead of an
//					InternetResult object reference.
//
// ARGUMENTS:	as_urlname		- The URL where data is being posted
//					ablob_data		- The data being posted
//					as_mimetype		- The MIMETYPE of data being posted
//					ablob_response	- The response data
//
// RETURN:		Length of Response or Zero for errors
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	---------	-----------------------------------------------
// 03/25/2014	RolandS		Initial Coding
// -----------------------------------------------------------------------

ULong lul_length

If Open("POST", as_urlname) = False Then
	Return 0
End If

lul_length = Len(ablob_data)
SetRequestHeader("Content-Length", String(lul_length))
SetRequestHeader("Content-Type", as_mimetype)

Return SendData(ablob_data, ablob_response)

end function

private function string stringfromptr (unsignedlong aul_ptr);// -----------------------------------------------------------------------------
// SCRIPT:     n_winhttp.StringFromPtr
//
// PURPOSE:    This function returns a string from a memory pointer.
//
// ARGUMENTS:  aul_ptr - Pointer to a string
//
// RETURN:     String
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/27/2014	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return String(aul_ptr, "address")

end function

public function string getmimetype (readonly string as_filename, ref blob ablob_filedata);// -----------------------------------------------------------------------------
// SCRIPT:     n_winhttp.GetMIMEType
//
// PURPOSE:    This function is determines the file MIME type.
//
// ARGUMENTS:  as_filename 	- Filename
//					ablob_filedata	- The file contents
//
// RETURN:     MIME Type
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/27/2014	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_mimetype, ls_errmsg
ULong lul_ptr, lul_rtn

lul_rtn = FindMimeFromData(0, as_filename, ablob_filedata, &
				Len(ablob_filedata), 0, 0, lul_ptr, 0)
If lul_rtn = 0 Then
	ls_mimetype = StringFromPtr(lul_ptr)
Else
	LastErrorNum = GetErrorMsg("FindMimeFromData", LastErrorText)
	SetNull(ls_mimetype)
End If

Return ls_mimetype

end function

public function string getmimetype (readonly string as_filename, ref string as_filedata);// -----------------------------------------------------------------------------
// SCRIPT:     n_winhttp.GetMIMEType
//
// PURPOSE:    This function is determines the file MIME type.
//
// ARGUMENTS:  as_filename - Filename
//					as_filedata	- The file contents
//
// RETURN:     MIME Type
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 03/27/2014	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob lblob_filedata

lblob_filedata = Blob(as_filedata)

Return GetMIMEType(as_filename, lblob_filedata)

end function

public function string hex (unsignedlong aul_number, integer ai_digit);// -----------------------------------------------------------------------------
// SCRIPT:     n_winhttp.Hex
//
// PURPOSE:    This function converts a number to a hex string.
//
// ARGUMENTS:  aul_number	- A number to convert
//					ai_digit		- The number of hex digits expected
//
// RETURN:     Hex string
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/24/2014	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_temp0, lul_temp1
Char lc_ret

If ai_digit > 0 Then
   lul_temp0 = Abs(aul_number / (16 ^ (ai_digit - 1)))
   lul_temp1 = lul_temp0 * (16 ^ (ai_digit - 1))
   If lul_temp0 > 9 Then
      lc_ret = Char(lul_temp0 + 55)
   Else
      lc_ret = Char(lul_temp0 + 48)
   End If
   Return lc_ret + Hex(aul_number - lul_temp1, ai_digit - 1)
End If

Return ""

end function

public function string urlencode (string as_string);// -----------------------------------------------------------------------------
// SCRIPT:     n_winhttp.URLEncode
//
// PURPOSE:    This function URL encodes the passed string.
//
// ARGUMENTS:  as_string	- String to encode
//
// RETURN:     The encoded string
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 04/24/2014	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_result, ls_char
Integer li_idx

For li_idx = 1 To Len(as_string)
	ls_char = Mid(as_string, li_idx, 1) 
	choose case Asc(ls_char)
		case 48 To 57, 65 To 90, 97 To 122
			ls_result += ls_char
		case 32
			ls_result += "+"
		case else
			ls_result += "%" + Hex(Asc(ls_char), 2)
	end choose
Next

Return ls_result

end function

on n_winhttp.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_winhttp.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;LARGE_INTEGER lstr_frequency

// determine the performance counter frequency
QueryPerformanceFrequency(lstr_frequency)
iul_frequency = lstr_frequency.low_part

end event

