$PBExportHeader$n_adapter.sru
forward
global type n_adapter from nonvisualobject
end type
type ip_addr_string from structure within n_adapter
end type
type ip_adapter_info from structure within n_adapter
end type
end forward

type ip_addr_string from structure
	unsignedlong		nextptr
	character		ipaddress[16]
	character		ipmask[16]
	unsignedlong		context
end type

type ip_adapter_info from structure
	unsignedlong		nextptr
	unsignedlong		comboindex
	character		adaptername[260]
	character		description[132]
	unsignedlong		addresslength
	long		address[2]
	unsignedlong		index
	unsignedinteger		adaptertype
	unsignedinteger		dhcpenabled
	unsignedlong		currentipaddress
	unsignedlong		reserved1
	ip_addr_string		ipaddresslist
	ip_addr_string		gatewaylist
	ip_addr_string		dhcpserver
	boolean		havewins
	unsignedinteger		reserved2
	ip_addr_string		primarywinsserver
	ip_addr_string		secondarywinsserver
	unsignedlong		leaseobtained
	unsignedlong		leaseexpires
end type

global type n_adapter from nonvisualobject autoinstantiate
end type

type prototypes
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

Function ulong GetAdaptersInfo ( &
	Ref IP_ADAPTER_INFO pAdapterInfo[], &
	Ref ulong pOutBufLen &
	) Library "iphlpapi.dll" Alias For "GetAdaptersInfo;Ansi"

Subroutine CopyMemory ( &
	Ref blob Destination, &
	long Source[], &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemory ( &
	Ref integer Destination, &
	blob Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

end prototypes

forward prototypes
public function string of_getlasterror ()
public function string of_nbr2hex (unsignedlong aul_number, integer ai_digit)
public function boolean of_getadaptersinfo (ref string as_macaddress[], ref string as_description[], ref string as_adaptername[], ref string as_ipaddress[])
end prototypes

public function string of_getlasterror ();// -----------------------------------------------------------------------------
// SCRIPT:     n_adapters.of_GetLastError
//
// PURPOSE:    This function returns the last Windows API error.
//
// RETURN:     Error message text
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/23/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_buffer, ls_errmsg
ULong lul_error

lul_error = GetLastError()

ls_buffer = Space(255)

FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
		lul_error, LANG_NEUTRAL, ls_buffer, 255, 0)

ls_errmsg = "Error# " + String(lul_error) + "~r~n~r~n" + ls_buffer

Return ls_errmsg

end function

public function string of_nbr2hex (unsignedlong aul_number, integer ai_digit);// -----------------------------------------------------------------------------
// SCRIPT:     n_adapters.of_Nbr2Hex
//
// PURPOSE:    This function converts a number to a hex string.
//
// ARGUMENTS:  aul_number	- A number to convert
//					ai_digit		- The number of hex digits expected
//
// RETURN:     Hex string
//
// DATE        CHANGED BY	DESCRIPTION OF CHANGE / REASON
// ----------  ----------  -----------------------------------------------------
// 12/23/2010  RolandS		Initial creation
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
   Return lc_ret + of_Nbr2Hex(aul_number - lul_temp1, ai_digit - 1)
End If

Return ""

end function

public function boolean of_getadaptersinfo (ref string as_macaddress[], ref string as_description[], ref string as_adaptername[], ref string as_ipaddress[]);// -----------------------------------------------------------------------------
// SCRIPT:     n_adapters.of_GetAdaptersInfo
//
// PURPOSE:    This function returns information about network adapters.
//
// ARGUMENTS:  as_macaddress	- Array of MAC addresses
//					as_description	- Array of Descriptions
//					as_adaptername	- Array of Adapter names
//					as_ipaddress	- Array of IP addresses
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 12/23/2010  RolandS		Initial creation
// -----------------------------------------------------------------------------

Constant ULong ERROR_SUCCESS = 0
Constant ULong ERROR_BUFFER_OVERFLOW = 111
IP_ADAPTER_INFO lstr_Adapter[]
ULong lul_OutBufLen
Integer li_idx, li_max, li_macidx, li_macmax, li_byte
Blob lblob_address

// call function to get buffer size
If GetAdaptersInfo(lstr_Adapter, lul_OutBufLen) = ERROR_BUFFER_OVERFLOW Then
	// how many adapters?
	li_max = lul_OutBufLen / 640
	// allocate structure
	lstr_Adapter[li_max].NextPtr = 0
	// call function to get data
	If GetAdaptersInfo(lstr_Adapter, lul_OutBufLen) = ERROR_SUCCESS Then
		For li_idx = 1 To li_max
			// get adapter information
			as_description[li_idx] = String(lstr_Adapter[li_idx].Description)
			as_adaptername[li_idx] = String(lstr_Adapter[li_idx].AdapterName)
			as_ipaddress[li_idx]   = String(lstr_Adapter[li_idx].IpAddressList.IpAddress)
			// convert MAC address from blob data
			li_macmax = lstr_Adapter[li_idx].AddressLength
			lblob_address = Blob(Space(li_macmax))
			CopyMemory(lblob_address, lstr_Adapter[li_idx].Address, li_macmax)
			For li_macidx = 1 To li_macmax
				CopyMemory(li_byte, BlobMid(lblob_address, li_macidx, 1), 1)
				as_macaddress[li_idx] += of_Nbr2Hex(li_byte, 2)
				If li_macidx < li_macmax Then
					as_macaddress[li_idx] += "-"
				End If
			Next
		Next
		Return True
	End If
End If

MessageBox("Error in of_GetAdaptersInfo", &
				of_GetLastError(), StopSign!)

Return False


end function

on n_adapter.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_adapter.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

