$PBExportHeader$n_osversion.sru
forward
global type n_osversion from nonvisualobject
end type
type osversioninfoex from structure within n_osversion
end type
type system_info from structure within n_osversion
end type
type langandcodepage from structure within n_osversion
end type
type vs_fixedfileinfo from structure within n_osversion
end type
end forward

type osversioninfoex from structure
	unsignedlong		dwosversioninfosize
	unsignedlong		dwmajorversion
	unsignedlong		dwminorversion
	unsignedlong		dwbuildnumber
	unsignedlong		dwplatformid
	character		szcsdversion[128]
	unsignedinteger		wservicepackmajor
	unsignedinteger		wservicepackminor
	unsignedinteger		wsuitemask
	unsignedinteger		wproducttype
end type

type system_info from structure
	unsignedinteger		wprocessorarchitecture
	unsignedinteger		wreserved
	unsignedlong		dwpagesize
	unsignedlong		lpminimumapplicationaddress
	unsignedlong		lpmaximumapplicationaddress
	unsignedlong		dwactiveprocessormask
	unsignedlong		dwnumberofprocessors
	unsignedlong		dwprocessortype
	unsignedlong		dwallocationgranularity
	unsignedinteger		wprocessorlevel
	unsignedinteger		wprocessorrevsion
end type

type langandcodepage from structure
	integer		wlanguageid
	integer		wcharacterset
end type

type vs_fixedfileinfo from structure
	unsignedlong		dwsignature
	unsignedlong		dwstrucversion
	unsignedlong		dwfileversionms
	unsignedlong		dwfileversionls
	unsignedlong		dwproductversionms
	unsignedlong		dwproductversionls
	unsignedlong		dwfileflagsmask
	unsignedlong		dwfileflags
	unsignedlong		dwfileos
	unsignedlong		dwfiletype
	unsignedlong		dwfilesubtype
	unsignedlong		dwfiledatems
	unsignedlong		dwfiledatels
end type

global type n_osversion from nonvisualobject autoinstantiate
end type

type prototypes
Function integer GetSystemMetrics ( &
	integer nIndex &
	) Library "user32.dll"

Function Boolean GetVersionEx ( &
	Ref OSVERSIONINFOEX lpVersionInformation &
	) Library "kernel32.dll" Alias For "GetVersionExW"

Function Boolean GetProductInfo ( &
	ulong dwOSMajorVersion, &
	ulong dwOSMinorVersion, &
	ulong dwSpMajorVersion, &
	ulong dwSpMinorVersion, &
	Ref ulong pdwReturnedProductType &
	) Library "kernel32.dll"

Subroutine GetNativeSystemInfo ( &
	Ref SYSTEM_INFO lpSystemInfo &
	) Library "kernel32.dll"

Subroutine GetSystemInfo ( &
	Ref SYSTEM_INFO lpSystemInfo &
	) Library "kernel32.dll"

Function Boolean IsWow64Process ( &
	long hProcess, &
	Ref boolean Wow64Process &
	) Library "kernel32.dll"

Function Long GetCurrentProcess ( &
	) Library "kernel32.dll"

Subroutine CopyMemory ( &
	Ref string Destination, &
	long Source, &
	long Length &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemory ( &
	Ref structure Destination, &
	long Source, &
	long Length &
	) Library 'kernel32.dll' Alias For "RtlMoveMemory"

Function long GetFileVersionInfoSize ( &
	string lptstrFilename, &
	Ref ulong lpdwHandle &
	) Library "version.dll" Alias For "GetFileVersionInfoSizeW"

Function boolean GetFileVersionInfo ( &
	string lptstrFilename, &
	long dwHandle, &
	long dwLen, &
	Ref blob lpData &
	) Library "version.dll" Alias For "GetFileVersionInfoW"

Function boolean VerQueryValue ( &
	Ref blob lpBlock, &
	string lpSubBlock, &
	Ref ulong lplpBuffer, &
	Ref uint puLen &
	) Library "version.dll" Alias For "VerQueryValueW"

Function ulong CopyMemory( &
	ref ulong dest, &
	ulong source, &
	ulong size &
	) Library "kernel32.dll" Alias For "RtlMoveMemory"

Function ulong NetWkstaGetInfo( &
	string servername, &
	ulong level, &
	ref ulong bufptr &
	) Library "netapi32.dll" Alias for "NetWkstaGetInfo"

Function ulong NetApiBufferFree( &
	ulong Buffer &
	) Library "netapi32.dll"

end prototypes

type variables
String Comments
String CompanyName
String FileDescription
String FileVersion
String InternalName
String LegalCopyright
String LegalTrademarks
String OriginalFilename
String ProductName
String ProductVersion
String PrivateBuild
String SpecialBuild
String FixedProductVersion
String FixedFileVersion

Uint MajorVersion
Uint MinorVersion
Uint BuildNumber
Uint ServicePackMajor
Uint ServicePackMinor
Uint SuiteMask
Uint ProductType

end variables

forward prototypes
public function string of_pbvmname ()
public function string of_getproductinfo ()
public function boolean of_getosversion (ref string as_osversion, ref string as_osedition, ref string as_csdversion)
public function boolean of_getfileversioninfo (string as_filename)
public function integer of_getosbits ()
public function string of_hex (unsignedlong aul_decimal, integer ai_length)
public function unsignedinteger of_bitwiseand (unsignedinteger aui_value1, unsignedinteger aui_value2)
public function unsignedlong of_bitwiseand (unsignedlong aul_value1, unsignedlong aul_value2)
public function boolean of_remotesession ()
public function unsignedlong of_getpointer (unsignedlong aul_baseptr, integer ai_ptrnum, integer ai_arraynum, integer ai_ptrcnt)
public subroutine of_osversion (ref unsignedlong aul_osmajor, ref unsignedlong aul_osminor)
end prototypes

public function string of_pbvmname ();// This function the name of the PowerBuilder VM file.

Environment le_env
String ls_vmname
Integer li_major

GetEnvironment(le_env)

li_major = le_env.PBMajorRevision
choose case li_major
	case 10, 11, 12
		choose case le_env.PBMinorRevision
			case 5
				ls_vmname = "pbvm" + String(li_major) + "5.dll"
			case 6
				ls_vmname = "pbvm" + String(li_major) + "6.dll"
			case else
				ls_vmname = "pbvm" + String(li_major) + "0.dll"
		end choose
	case else
		ls_vmname = "pbvm" + String(li_major) + "0.dll"
end choose

Return ls_vmname

end function

public function string of_getproductinfo ();// This function gets product info from Vista & Newer

String ls_info
ULong lul_ProductType
Boolean lb_rtn

lb_rtn = GetProductInfo(MajorVersion, MinorVersion, &
					ServicePackMajor, ServicePackMinor, lul_ProductType)

// this is just a few of the types
choose case lul_ProductType
	case 1	// 0x00000001 - PRODUCT_ULTIMATE
		ls_info = "Ultimate"
	case 48	// 0x00000030 - PRODUCT_PROFESSIONAL
		ls_info = "Professional"
	case 3	// 0x00000003 - PRODUCT_HOME_PREMIUM
		ls_info = "Home Premium"
	case 2	// 0x00000002 - PRODUCT_HOME_BASIC
		ls_info = "Home Basic"
	case 4	// 0x00000004 - PRODUCT_ENTERPRISE
		ls_info = "Enterprise"
	case 6	// 0x00000006 - PRODUCT_BUSINESS
		ls_info = "Business"
	case 11	// 0x0000000B - PRODUCT_STARTER
		ls_info = "Starter"
	case 18	// 0x00000012 - PRODUCT_CLUSTER_SERVER
		ls_info = "Cluster Server"
	case 8	// 0x00000008 - PRODUCT_DATACENTER_SERVER
		ls_info = "Datacenter (full installation)"
	case 12	// 0x0000000C - PRODUCT_DATACENTER_SERVER_CORE
		ls_info = "Datacenter (core installation)"
	case 72	// 0x00000048 - PRODUCT_ENTERPRISE_EVALUATION
		ls_info = "Enterprise (evaluation installation)"
	case 10	// 0x0000000A - PRODUCT_ENTERPRISE_SERVER
		ls_info = "Enterprise (full installation)"
	case 14	// 0x0000000E - PRODUCT_ENTERPRISE_SERVER_CORE
		ls_info = "Enterprise (core installation)"
	case 15	// 0x0000000F - PRODUCT_ENTERPRISE_SERVER_IA64
		ls_info = "Enterprise for Itanium-based Systems"
	case 9	// 0x00000009 - PRODUCT_SMALLBUSINESS_SERVER
		ls_info = "Small Business"
	case 25	// 0x00000019 - PRODUCT_SMALLBUSINESS_SERVER_PREMIUM
		ls_info = "Small Business Premium"
	case 7	// 0x00000007 - PRODUCT_STANDARD_SERVER
		ls_info = "Standard"
	case 13	// 0x0000000D - PRODUCT_STANDARD_SERVER_CORE
		ls_info = "Standard (core installation)"
	case 17	// 0x00000011 - PRODUCT_WEB_SERVER
		ls_info = "Web Server (full installation)"
	case 29	// 0x0000001D - PRODUCT_WEB_SERVER
		ls_info = "Web Server (core installation)"
	case 101	// 0x00000065 - PRODUCT_CORE
		ls_info = "Home"
	case 100	// 0x00000064 - PRODUCT_CORE_SINGLELANGUAGE
		ls_info = "Single Language"
	case else
		ls_info = "lul_ProductType: " + String(lul_ProductType)
end choose

Return ls_info

end function

public function boolean of_getosversion (ref string as_osversion, ref string as_osedition, ref string as_csdversion);// This function gets operating system version information.

OSVERSIONINFOEX lstr_ovi
Constant Integer SM_TABLETPC = 86
Constant Integer SM_MEDIACENTER = 87
Constant Integer SM_STARTER = 88
Constant Integer SM_SERVERR2 = 89
Constant UInt VER_NT_SERVER = 3
Constant UInt VER_NT_WORKSTATION = 1
Constant UInt VER_SUITE_SMALLBUSINESS = 1
Constant UInt VER_SUITE_ENTERPRISE = 2
Constant UInt VER_SUITE_TERMINAL = 16
Constant UInt VER_SUITE_EMBEDDEDNT = 64
Constant UInt VER_SUITE_DATACENTER = 128
Constant UInt VER_SUITE_SINGLEUSERRTS = 256
Constant UInt VER_SUITE_PERSONAL = 512
Constant UInt VER_SUITE_BLADE = 1024
Constant UInt VER_SUITE_STORAGE_SERVER = 8192
Constant UInt VER_SUITE_COMPUTE_SERVER = 16384
Constant UInt VER_SUITE_WH_SERVER = 32768

as_osversion  = ""
as_osedition  = ""
as_csdversion = ""

lstr_ovi.dwOSVersionInfoSize = 284	// for Ansi use 156

// call function
If Not GetVersionEx(lstr_ovi) Then Return False

// use NetWkstaGetInfo to get true OS Version
of_OSVersion(lstr_ovi.dwMajorVersion, lstr_ovi.dwMinorVersion)

// save values to instance variables
MajorVersion		= lstr_ovi.dwMajorVersion
MinorVersion		= lstr_ovi.dwMinorVersion
BuildNumber			= lstr_ovi.dwBuildNumber
ServicePackMajor	= lstr_ovi.wServicePackMajor
ServicePackMinor	= lstr_ovi.wServicePackMinor
SuiteMask			= lstr_ovi.wSuiteMask
ProductType			= lstr_ovi.wProductType

// set default values
as_osversion = "Windows " + &
		String(lstr_ovi.dwMajorVersion) + "." + &
		String(lstr_ovi.dwMinorVersion)
as_osedition = "wSuiteMask:" + String(lstr_ovi.wSuiteMask)

// populate by ref string arguments
choose case lstr_ovi.dwMajorVersion
	case 3
		as_osversion = "Windows NT 3.51"
	case 4
		as_osversion = "Windows NT 4"
		choose case lstr_ovi.wProductType
			case 1
				as_osedition = "Workstation"
			case 3
				If lstr_ovi.wSuiteMask = 2 Then
					as_osedition = "Server Enterprise"
				Else
					as_osedition = "Server Standard"
				End If
		end choose
	case 5
		as_csdversion = Trim(String(lstr_ovi.szCSDVersion))
		choose case lstr_ovi.dwMinorVersion
			case 0
				as_osversion = "Windows 2000"
				choose case lstr_ovi.wProductType
					case VER_NT_WORKSTATION
						as_osedition = "Professional"
					case VER_NT_SERVER
						as_osedition = "Server"
				end choose
			case 1
				as_osversion = "Windows XP"
				If lstr_ovi.wSuiteMask = 0 Or &
				   of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_TERMINAL + VER_SUITE_SINGLEUSERRTS) <> 0 Then
					as_osedition = "Professional"
				ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_EMBEDDEDNT) <> 0 Then
					as_osedition = "Embedded"
				ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_PERSONAL) <> 0 Then
					as_osedition = "Home Edition"
				ElseIf GetSystemMetrics(SM_MEDIACENTER) > 0 Then
					as_osedition = "Media Center Edition"
				ElseIf GetSystemMetrics(SM_STARTER) > 0 Then
					as_osedition = "Starter Edition"
				ElseIf GetSystemMetrics(SM_TABLETPC) > 0 Then
					as_osedition = "Tablet PC Edition"
				Else
					as_osedition = "wSuiteMask:" + String(lstr_ovi.wSuiteMask)
				End If
			case 2
				If GetSystemMetrics(SM_SERVERR2) > 0 Then
					as_osversion = "Windows Server 2003 R2"
				ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_STORAGE_SERVER) <> 0 Then
					as_osversion = "Windows Storage Server 2003"
				ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_WH_SERVER) <> 0 Then
					as_osversion = "Windows Home Server"
				ElseIf lstr_ovi.wProductType = VER_NT_WORKSTATION And of_GetOSBits() = 64 Then
					as_osversion = "Windows XP"
					as_osedition = "Professional x64 Edition"
				Else
					as_osversion = "Windows Server 2003"
				End If
				If as_osedition = "" Then
					If of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_COMPUTE_SERVER) <> 0 Then
						as_osedition = "Compute Cluster Edition"
					ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_DATACENTER) <> 0 Then
						as_osedition = "Datacenter Edition"
					ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_ENTERPRISE) <> 0 Then
						as_osedition = "Enterprise Edition"
					ElseIf of_BitwiseAnd(lstr_ovi.wSuiteMask, VER_SUITE_BLADE) <> 0 Then
						as_osedition = "Web Edition"
					Else
						as_osedition = "Standard Edition"
					End If
				End If
		end choose
	case 6
		as_csdversion = Trim(String(lstr_ovi.szCSDVersion))
		choose case lstr_ovi.dwMinorVersion
			case 0
				choose case lstr_ovi.wProductType
					case VER_NT_SERVER
						as_osversion = "Windows Server 2008"
						as_osedition = of_GetProductInfo()
					case else
						as_osversion = "Windows Vista"
						as_osedition = of_GetProductInfo()
				end choose
			case 1
				choose case lstr_ovi.wProductType
					case VER_NT_SERVER
						as_osversion = "Windows Server 2008 R2"
						as_osedition = of_GetProductInfo()
					case else
						as_osversion = "Windows 7"
						as_osedition = of_GetProductInfo()
				end choose
			case 2
				choose case lstr_ovi.wProductType
					case VER_NT_SERVER
						as_osversion = "Windows Server 2012"
						as_osedition = of_GetProductInfo()
					case else
						as_osversion = "Windows 8"
						as_osedition = of_GetProductInfo()
				end choose
			case 3
				as_osversion = "Windows 8.1"
				as_osedition = of_GetProductInfo()
		end choose
	case 10
		as_osversion = "Windows 10"
		as_osedition = of_GetProductInfo()
		as_csdversion = Trim(String(lstr_ovi.szCSDVersion))
end choose

Return True

end function

public function boolean of_getfileversioninfo (string as_filename);// This function gets version information strings from a file.

VS_FIXEDFILEINFO lstr_FixedInfo
LANGANDCODEPAGE lstr_Translate
String	ls_versionkeys[12] = { "Comments", &
					"CompanyName", "FileDescription", "FileVersion", &
					"InternalName", "LegalCopyright", "LegalTrademarks", &
					"OriginalFilename", "ProductName", "ProductVersion", &
					"PrivateBuild", "SpecialBuild" }
String	ls_versioninfo[12], ls_key, ls_language, ls_charset
Integer	li_part1, li_part2, li_part3, li_part4
ULong		dwHandle, dwLength, dwPointer
UInt		lui_length
Blob		lblob_Buffer
Integer	i

dwLength = GetFileVersionInfoSize(as_filename, dwHandle)
If dwLength <= 0 Then
	// No version information available
	Return False
End If

// Allocate version information buffer
lblob_Buffer = Blob(Space(dwLength/2))

// Get version information
If Not GetFileVersionInfo(as_filename, dwHandle, &
				dwLength, lblob_Buffer) Then
	Return False
End If

// Get Fixed File Info
If VerQueryValue(lblob_Buffer, "\", dwPointer, lui_length) Then
	// copy Fixed File Info to structure
	CopyMemory(lstr_FixedInfo, dwPointer, 52)
	// build FixedProductVersion
	If lstr_FixedInfo.dwProductVersionMS = 0 And &
		lstr_FixedInfo.dwProductVersionLS = 0 Then
		FixedProductVersion = ""
	Else
		li_part1 = IntHigh(lstr_FixedInfo.dwProductVersionMS)
		li_part2 = IntLow(lstr_FixedInfo.dwProductVersionMS)
		li_part3 = IntHigh(lstr_FixedInfo.dwProductVersionLS)
		li_part4 = IntLow(lstr_FixedInfo.dwProductVersionLS)
		FixedProductVersion = String(li_part1) + "." + &
					String(li_part2) + "." + String(li_part3) + &
					"." + String(li_part4)
	End If
	// build FixedFileVersion
	If lstr_FixedInfo.dwFileVersionMS = 0 And &
		lstr_FixedInfo.dwFileVersionLS = 0 Then
		FixedFileVersion = ""
	Else
		li_part1 = IntHigh(lstr_FixedInfo.dwFileVersionMS)
		li_part2 = IntLow(lstr_FixedInfo.dwFileVersionMS)
		li_part3 = IntHigh(lstr_FixedInfo.dwFileVersionLS)
		li_part4 = IntLow(lstr_FixedInfo.dwFileVersionLS)
		FixedFileVersion = String(li_part1) + "." + &
					String(li_part2) + "." + String(li_part3) + &
					"." + String(li_part4)
	End If
End If

// Get the structure language ID and character set
ls_key = "\VarFileInfo\Translation"
If Not VerQueryValue(lblob_Buffer, ls_key, dwPointer, lui_length) Then
	Return False
End If

// copy memory at dwPointer to structure
CopyMemory(lstr_Translate, dwPointer, lui_length)

// Convert the langid and char set into 4-digit hex value
ls_language = of_Hex(lstr_Translate.wLanguageId, 4)
ls_charset  = of_Hex(lstr_Translate.wCharacterSet, 4)

// for PB executables
If ls_charset = "1252" Then
	ls_charset = "04E4"
End If

// Query each of the version strings
For i = 1 To 12
	ls_key = "\StringFileInfo\" + ls_language + &
					ls_charset + "\" + ls_versionkeys[i]
	If Not VerQueryValue(lblob_Buffer, ls_key, dwPointer, lui_length) Or &
		lui_length <= 0 Then
		ls_versioninfo[i] = ""
	Else
		// copy memory at dwPointer to string array
		lui_length = lui_length * 2
		ls_versioninfo[i] = Space(lui_length)
		CopyMemory(ls_versioninfo[i], dwPointer, lui_length)
	End If
Next

// save values to instance variables
Comments				= ls_versioninfo[1]
CompanyName			= ls_versioninfo[2]
FileDescription	= ls_versioninfo[3]
FileVersion			= ls_versioninfo[4]
InternalName		= ls_versioninfo[5]
LegalCopyright		= ls_versioninfo[6]
LegalTrademarks	= ls_versioninfo[7]
OriginalFilename	= ls_versioninfo[8]
ProductName			= ls_versioninfo[9]
ProductVersion		= ls_versioninfo[10]
PrivateBuild		= ls_versioninfo[11]
SpecialBuild		= ls_versioninfo[12]

Return True

end function

public function integer of_getosbits ();// This function determines if OS is 32 bits or 64 bits.

Constant Long PROCESSOR_ARCHITECTURE_INTEL = 0	// x86
Constant Long PROCESSOR_ARCHITECTURE_IA64  = 6	// Intel Itanium-based
Constant Long PROCESSOR_ARCHITECTURE_AMD64 = 9	// x64 (AMD or Intel)
SYSTEM_INFO lstr_si
Integer li_bits
Boolean lb_IsWow64

IsWOW64Process(GetCurrentProcess(), lb_IsWow64)

If lb_IsWow64 Then
	GetNativeSystemInfo(lstr_si)
Else
	GetSystemInfo(lstr_si)
End If

choose case lstr_si.wProcessorArchitecture
	case PROCESSOR_ARCHITECTURE_IA64
		li_bits = 64
	case PROCESSOR_ARCHITECTURE_AMD64
		li_bits = 64
	case else
		li_bits = 32
end choose

Return li_bits

end function

public function string of_hex (unsignedlong aul_decimal, integer ai_length);// This function converts a number to a hex string.

String ls_hex
Char lch_hex[0 to 15] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', &
							'A', 'B', 'C', 'D', 'E', 'F'}

// convert to hexidecimal
Do 
	ls_hex = lch_hex[mod (aul_decimal, 16)] + ls_hex
	aul_decimal /= 16
Loop Until aul_decimal= 0

// add zeroes to front so that result is ai_length characters
ls_hex = Fill('0', ai_length) + ls_hex
ls_hex = Right(ls_hex, ai_length)

Return ls_hex

end function

public function unsignedinteger of_bitwiseand (unsignedinteger aui_value1, unsignedinteger aui_value2);// This function performs a bit-wise AND operation
// on two unsigned int's. Code courtesy John Fauss.

Integer li_i
UInt    lui_result, lui_factor

If IsNull( aui_value1) Or IsNull( aui_value2) Then
	SetNull( lui_result)
	Return lui_result
End If

lui_result = 0
For li_i = 1 To 16
	If aui_value1 = 0 Or aui_value2 = 0 Then Exit
	If li_i = 1 Then
		lui_factor = 1
	Else
		lui_factor = lui_factor * 2
	End If
	If Mod( aui_value1, 2) = 1 And Mod( aui_value2, 2) = 1 Then
		lui_result += lui_factor
	End If
	aui_value1 = aui_value1 / 2
	aui_value2 = aui_value2 / 2
Next

Return lui_result
end function

public function unsignedlong of_bitwiseand (unsignedlong aul_value1, unsignedlong aul_value2);// This function performs a bit-wise AND operation
// on two unsigned long's. Code courtesy John Fauss.

Integer li_i
ULong   lul_result, lul_factor

If IsNull( aul_value1) Or IsNull( aul_value2) Then
	SetNull( lul_result)
	Return lul_result
End If

lul_result = 0
For li_i = 1 To 32
	If aul_value1 = 0 Or aul_value2 = 0 Then Exit
	If li_i = 1 Then
		lul_factor = 1
	Else
		lul_factor = lul_factor * 2
	End If
	If Mod( aul_value1, 2) = 1 And Mod( aul_value2, 2) = 1 Then
		lul_result += lul_factor
	End If
	aul_value1 = aul_value1 / 2
	aul_value2 = aul_value2 / 2
Next

Return lul_result
end function

public function boolean of_remotesession ();// Determine Remote Desktop/Terminal Services

Constant Integer SM_REMOTESESSION = 4096	// 0x1000

If GetSystemMetrics(SM_REMOTESESSION) = 0 Then
	Return False
Else
	Return True
End If

end function

public function unsignedlong of_getpointer (unsignedlong aul_baseptr, integer ai_ptrnum, integer ai_arraynum, integer ai_ptrcnt);// Returns a pointer from a memory location containing an array of pointers.

ULong lul_bufptr, lul_strptr

// calculate memory location
lul_bufptr = aul_baseptr + ((ai_arraynum - 1) * (ai_ptrcnt * 4)) + ((ai_ptrnum - 1) * 4)

// copy pointer into local variable
CopyMemory(lul_strptr, lul_bufptr, 4)

Return lul_strptr

end function

public subroutine of_osversion (ref unsignedlong aul_osmajor, ref unsignedlong aul_osminor);// determine the operating system version

CONSTANT ulong NERR_Success = 0
ULong lul_Return, lul_BufPtr
String ls_ServerName

SetNull(ls_ServerName)

lul_Return = NetWkstaGetInfo(ls_ServerName, 100, lul_BufPtr)
If lul_Return = NERR_Success Then
	// get operating system version
	aul_osmajor = of_GetPointer(lul_BufPtr, 4, 1, 5)
	aul_osminor = of_GetPointer(lul_BufPtr, 5, 1, 5)
Else
	MessageBox("NetWkstaGetInfo", &
		"A system error has occurred: " + String(lul_Return), StopSign!)
End If

// free buffer
If lul_BufPtr > 0 Then
	NetAPIBufferFree(lul_BufPtr)
End If

end subroutine

on n_osversion.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_osversion.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

