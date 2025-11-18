$PBExportHeader$n_fileinfo.sru
$PBExportComments$Retrieve version string from a file
forward
global type n_fileinfo from nonvisualobject
end type
type os_fileversioninfo from structure within n_fileinfo
end type
type os_transarray from structure within n_fileinfo
end type
end forward

type os_fileversioninfo from structure
	string		ProductName
	string		ProductVersion
	string		OriginalFilename
	string		FileDescription
	string		FileVersion
	string		CompanyName
	string		LegalCopyright
	string		LegalTrademarks
	string		InternalName
	string		PrivateBuild
	string		SpecialBuild
	string		Comments
end type

type os_transarray from structure
	unsignedinteger		wlanguageid
	unsignedinteger		wcharacterset
end type

global type n_fileinfo from nonvisualobject
end type
global n_fileinfo n_fileinfo

type prototypes
Subroutine CopyMemory ( &
	Ref string Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Subroutine CopyMemory ( &
	Ref structure Destination, &
	ulong Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Function long GetFileVersionInfoSize ( &
	string lptstrFilename, &
	Ref ulong lpdwHandle &
	) Library "version.dll" Alias For "GetFileVersionInfoSizeW"

Function boolean GetFileVersionInfo( &
	string lptstrFilename, &
	long dwHandle, &
	long dwLen, &
	Ref string lpData &
	) Library "version.dll" Alias For "GetFileVersionInfoW"

Function boolean VerQueryValue( &
	Ref string lpBlock, &
	string lpSubBlock, &
	Ref long lpBuffer, &
	Ref uint puLen &
	) Library "version.dll" Alias For "VerQueryValueW"

end prototypes

forward prototypes
public function string of_hex (unsignedlong aul_decimal)
public function boolean of_getfileversioninfo (string as_filename, ref os_fileversioninfo astr_fvi)
public function string of_get_fileversion (string as_filename)
end prototypes

public function string of_hex (unsignedlong aul_decimal);// convert number to hex string
String ls_hex
Char lch_hex[0 to 15] = {'0', '1', '2', '3', '4', '5', '6', '7', '8', '9', &
							'a', 'b', 'c', 'd', 'e', 'f'}

Do 
	ls_hex = lch_hex[mod (aul_decimal, 16)] + ls_hex
	aul_decimal /= 16
Loop Until aul_decimal= 0

Return ls_hex

end function

public function boolean of_getfileversioninfo (string as_filename, ref os_fileversioninfo astr_fvi);ulong	dwHandle
ulong	dwLength
string	ls_versionkeys[12] = { "ProductName", "ProductVersion", &
			"OriginalFilename", "FileDescription", "FileVersion", &
			"CompanyName", "LegalCopyright", "LegalTrademarks", &
			"InternalName", "PrivateBuild", "SpecialBuild", "Comments" }
string	ls_versioninfo[12]

dwLength = GetFileVersionInfoSize( as_filename, dwHandle )
IF dwLength <= 0 THEN
	// No version information available
	Return False
END IF

OS_TRANSARRAY	lst_trans
string		ls_Buff, ls_key, ls_language, ls_charset
uint			lui_length
integer		i
long			ll_pointer

// Allocate version information buffer
ls_Buff = Space( dwLength )
ls_key = Space(80)

// Get version information
IF NOT GetFileVersionInfo( as_filename, dwHandle, dwLength, ls_Buff ) THEN
	Return False
END IF

// Get the structure language ID and character set
ls_key = "\VarFileInfo\Translation"
IF NOT VerQueryValue( ls_Buff, ls_key, ll_pointer, lui_length ) THEN
	Return False
END IF

// ll_pointer contains a pointer to the structure, copy that into a local variable
CopyMemory( lst_trans, ll_pointer, lui_length )

// Convert the langid and char set into 4-digit hex value
ls_language  = of_Hex( lst_trans.wLanguageId )
ls_language  = Fill( '0', 4 - Len( ls_language ) ) + ls_language

ls_charset = of_Hex( lst_trans.wCharacterSet )
ls_charset = Fill( '0', 4 - Len( ls_charset ) ) + ls_charset

// If version info exists, and the key query is successful, add
//  the value.  Otherwise, the value for the key is NULL.
FOR i = 1 TO 12 
	ls_key = "\StringFileInfo\" + ls_language + ls_charset + "\" + ls_versionkeys[i]
	IF NOT VerQueryValue( ls_buff, ls_key, ll_pointer, lui_length ) OR &
		lui_length <= 0 THEN
		ls_versioninfo[i] = ""
	ELSE
		// ll_pointer contains a pointer to the string, copy that into a local variable
		lui_length = lui_length * 2	// this line needed in PB10 due to Unicode
		ls_versioninfo[i] = Space( lui_length )
		CopyMemory( ls_versioninfo[i], ll_pointer, lui_length )
	END IF
NEXT

astr_fvi.ProductName = ls_versioninfo[1]
astr_fvi.ProductVersion = ls_versioninfo[2]
astr_fvi.OriginalFilename = ls_versioninfo[3]
astr_fvi.FileDescription = ls_versioninfo[4]
astr_fvi.FileVersion = ls_versioninfo[5]
astr_fvi.CompanyName = ls_versioninfo[6]
astr_fvi.LegalCopyright = ls_versioninfo[7]
astr_fvi.LegalTrademarks = ls_versioninfo[8]
astr_fvi.InternalName = ls_versioninfo[9]
astr_fvi.PrivateBuild = ls_versioninfo[10]
astr_fvi.SpecialBuild = ls_versioninfo[11]
astr_fvi.Comments = ls_versioninfo[12]

Return True

end function

public function string of_get_fileversion (string as_filename);// return FileVersion string
OS_FILEVERSIONINFO lstr_fvi

this.of_GetFileVersionInfo(as_filename, lstr_fvi)

Return lstr_fvi.FileVersion

end function

on n_fileinfo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_fileinfo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

