$PBExportHeader$n_cst_zlib.sru
$PBExportComments$Funciones para comprimir a formato gzip
forward
global type n_cst_zlib from nonvisualobject
end type
end forward

global type n_cst_zlib from nonvisualobject
end type
global n_cst_zlib n_cst_zlib

type prototypes
Function Long compress (Ref blob Destination, Ref ulong DestLen, Ref blob Source, ulong SourceLen ) Library "zlib.dll"
Function Long compress2 (Ref blob Destination, Ref ulong DestLen, Ref blob Source, ulong SourceLen, int Level ) Library "zlib.dll"
Function Long uncompress ( Ref blob Destination, Ref ulong DestLen, Ref blob Sourse, ulong SourceLen ) Library "zlib.dll"
Function Long gzopen ( Ref string Path, Ref String Mode ) Library "zlib.dll"
Function long gzread ( long File, Ref blob Buffer, ulong BufferLen ) Library "zlib.dll"
Function long gzwrite ( long File, Ref blob Buffer, ulong BufferLen ) Library "zlib.dll"
Function long gzclose ( long File ) Library "zlib.dll"
Function string gzerror ( long File, Ref long ErrNum ) Library "zlib.dll"
Function long gzrewind ( long File ) Library "zlib.dll"
Function long gzeof ( long File ) Library "zlib.dll"
Function string zlibVersion() Library "zlib.dll"
end prototypes

type variables
// Constants as defined in ZLIB.H
////////////////////////////////
// Allowed flush values; see deflate()
Public Constant long Z_NO_FLUSH		= 0
Public Constant long Z_PARTIAL_FLUSH	= 1 // will be removed, use Z_SYNC_FLUSH instead
Public Constant long Z_SYNC_FLUSH		= 2
Public Constant long Z_FULL_FLUSH		= 3
Public Constant long Z_FINISH		= 4

// Return codes for the compression/decompression functions. Negative
// values are errors, positive values are used for special but normal events.
Public Constant long Z_OK			= 0
Public Constant long Z_STREAM_END		= 1
Public Constant long Z_NEED_DICT		= 2
Public Constant long Z_ERRNO		= -1
Public Constant long Z_STREAM_ERROR	= -2
Public Constant long Z_DATA_ERROR		= -3
Public Constant long Z_MEM_ERROR		= -4
Public Constant long Z_BUF_ERROR		= -5
Public Constant long Z_VERSION_ERROR	= -6

// compression levels
Public Constant long Z_NO_COMPRESSION	= 0
Public Constant long Z_BEST_SPEED		= 1
Public Constant long Z_BEST_COMPRESSION	= 9
Public Constant long Z_DEFAULT_COMPRESSION = -1

// compression strategy; see deflateInit2()
Public Constant long Z_FILTERED		= 1
Public Constant long Z_HUFFMAN_ONLY	= 2
Public Constant long Z_DEFAULT_STRATEGY	= 0

// Possible values of the data_type field
Public Constant long Z_BINARY		= 0
Public Constant long Z_ASCII			= 1
Public Constant long Z_UNKNOWN		= 2

// The deflate compression method (the only one supported in this version)
Public Constant long Z_DEFLATED		= 8
end variables

forward prototypes
public function long of_compress2 (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource, integer ailevel)
public function long of_compress (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource)
public function long of_uncompress (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource)
public function long of_gzopen (string asfilename, string asmode)
public function long of_gzread (long alFile, ref blob ablBuffer, ulong aulBufferLength)
public function long of_gzwrite (long alFile, blob ablBuffer)
public function long of_gzclose (long alFile)
public function string of_gzerror (long alFile, ref long alErrorNumber)
public function long of_gzrewind (long alFile)
public function long of_gzeof (long alFile)
public function string of_zlibversion ()
public function integer of_zip (string as_source, string as_zip_file)
end prototypes

public function long of_compress2 (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource, integer ailevel);//====================================================================
// Function - of_compress2 for nvo_zlib
//--------------------------------------------------------------------
// Description:Compress the source buffer into the destination
//					buffer. sourceLen is the byte length of the source
//					buffer and is automatically calculated using Len().
//					See notes below on initializing the destination buffer.
//					This is exactly the same as of_compress() except
//					you can now specify the compression level.
//--------------------------------------------------------------------
// Arguments:	
//
//	REF blob abldestination
//		Destination buffer containing compressed data.
//	REF unsignedlong auldestinationlength
//		Length of the compressed buffer.
//	blob ablsource
//		Source (uncompressed) buffer.
// integer ailevel
//		The level parameter indicates the compression level.
//		It can be Z_DEFAULT_COMPRESSION (equates to a level of 6), 
//		or any number between 0 and 9, where
//		0 = Z_NO_COMPRESSION, 1 = Z_BEST_SPEED, 9 = Z_BEST_COMPRESSION
//--------------------------------------------------------------------
// Returns:	(LONG) - Z_OK if success.
//							Z_MEM_ERROR if there was not enough memory.
//							Z_BUF_ERROR if there was not enough room in 
//								the destination (output) buffer.
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================
ulong	lulSourceLen
long	llRC

lulSourceLen = Len( ablSource )

// As per zLib documentation:
// Upon entry, destLen is the total size of the destination buffer,
// which must be at least 0.1% larger than the sourcelen plus 12 bytes.
// Upon exit, destLen is the actual size of the compressed buffer.
//
// This actually makes the buffer 1% larger, better safe than sorry.
aulDestinationLength = (lulSourceLen * 101 / 100) + 12

// Initialize destination buffer before calling API function
ablDestination = Blob( Space(aulDestinationLength) )

llRC = compress2( ablDestination, aulDestinationLength, ablSource, lulSourceLen, aiLevel )

// Resize the destination buffer (blob) to the correct size
// The compression routine does not resize the allocated memory, so the
// destination buffer will still be the original size. Using the LEN() function
// will NOT return the same value as aulDestinationLength.
ablDestination = BlobMid( ablDestination, 1, aulDestinationLength )

RETURN llRC

end function

public function long of_compress (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource);//====================================================================
// Function - of_compress for nvo_zlib
//--------------------------------------------------------------------
// Description:Compress the source buffer into the destination
//					buffer. sourceLen is the byte length of the source
//					buffer and is automatically calculated using Len().
//					See notes below on initializing the destination buffer.
//--------------------------------------------------------------------
// Arguments:	
//
//	REF blob abldestination
//		Destination buffer containing compressed data.
//	REF unsignedlong auldestinationlength
//		Length of the compressed buffer.
//	blob ablsource
//		Source (uncompressed) buffer.
//--------------------------------------------------------------------
// Returns:	(LONG) - Z_OK if success.
//							Z_MEM_ERROR if there was not enough memory.
//							Z_BUF_ERROR if there was not enough room in 
//								the destination (output) buffer.
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================
ulong	lulSourceLen
long	llRC

// Calculate the length of the source (uncompressed) data.
lulSourceLen = Len( ablSource )

// As per zLib documentation:
// Upon entry, destLen is the total size of the destination buffer,
// which must be at least 0.1% larger than the sourcelen plus 12 bytes.
// Upon exit, destLen is the actual size of the compressed buffer.
//
// This actually makes the buffer 1% larger, better safe than sorry.
aulDestinationLength = (lulSourceLen * 101 / 100) + 12

// Initialize destination buffer before calling API function
ablDestination = Blob( Space(aulDestinationLength) )

// Perform in memory compression.
llRC = compress( ablDestination, aulDestinationLength, ablSource, lulSourceLen )

// Resize the destination buffer (blob) to the correct size
// The compression routine does not resize the allocated memory, so the
// destination buffer will still be the original size. Using the LEN() function
// will NOT return the same value as aulDestinationLength.
ablDestination = BlobMid( ablDestination, 1, aulDestinationLength )

RETURN llRC

end function

public function long of_uncompress (ref blob abldestination, ref unsignedlong auldestinationlength, blob ablsource);//====================================================================
// Function - of_uncompress for nvo_zlib
//--------------------------------------------------------------------
// Description:Decompresses the source buffer into the destination
//					buffer. See the notes below for determining the 
//					size of the destination buffer.
//--------------------------------------------------------------------
// Arguments:	
//
//	blob abldestination
//		Destination buffer containing uncompressed data
//	unsignedlong auldestinationlength
//		Size of the destination buffer (length of uncompressed data)
//	blob ablsource
//		Source buffer containing compressed data.
//--------------------------------------------------------------------
// Returns:	(LONG) - Z_OK if success.
//							Z_MEM_ERROR if there was not enough memory
//							Z_BUF_ERROR if there is not enough memory in the
//								output (destination) buffer.
//							Z_DATA_ERROR if the input data is corrupted.
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================
ulong	lulSourceLen
long	llRC

lulSourceLen = Len( ablSource )

// As per zLib documentation:
//  Upon entry, destLen is the total size of the destination buffer, 
//  which must be large enough to hold the entire uncompressed data.
//  (The size of the uncompressed data must have been saved previously
//  by the compressor and transmitted to the decompressor by some
//  meachanism outside the scope of this compression library).
//  Upon exit, destLen is the actual size of the decompressed buffer.

// !!! THIS MEANS YOU MUST PASS IN THE DESTINATION LENGTH !!!

// Initialize destination buffer before calling API function
ablDestination = Blob( Space(aulDestinationLength) )

llRC = uncompress( ablDestination, aulDestinationLength, ablSource, lulSourceLen )

// Resize the destination buffer (blob) to the correct size
// The decompression routine does not resize the allocated memory, so the
// destination buffer will still be the original size. Using the LEN() function
// will NOT return the same value as aulDestinationLength.
ablDestination = BlobMid( ablDestination, 1, aulDestinationLength )

RETURN llRC

end function

public function long of_gzopen (string asfilename, string asmode);//====================================================================
// Function - of_gzopen for nvo_zlib
//--------------------------------------------------------------------
// Description:Opens a gzip (.gz) file for reading or writing.
//					gzopen can be used to read a file which is NOT in gzip
//					format. In this case, gzread will directly read from
//					the file without decompression.
//--------------------------------------------------------------------
// Arguments:	
//
//	string asfilename
//		Name of the filename (usually has a .gz extension)
//	string asmode
//		"rb" = Read
//		"wb" = Write
//					You can also include the compression level:
//						e.g. "wb9" = Write + Level 9 (best) compression
//					You can also include the strategy:
//						e.g. "wb6f" = Write + Level 6 (default) compression + Filtered
//						e.g. "wb1h" = Write + Level 1 (fastest) compression + Huffman
//--------------------------------------------------------------------
// Returns:	(LONG) - >0 = Success and returns the file handle
//							NULL if the file could not be opened, or if there
//							was insufficient memory to allocate the
//							decompression state.
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzopen( asFileName, asMode )

end function

public function long of_gzread (long alFile, ref blob ablBuffer, ulong aulBufferLength);//====================================================================
// Function - of_gzread for nvo_zlib
//--------------------------------------------------------------------
// Description:Reads the given number of UNCOMPRESSED bytes from
//					the compressed file. If the input file is not in
//					gzip format, gzread copies the given number of bytes
//					into the buffer.
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned from GZOPEN
//	blob ablBuffer
//		Buffer containing uncompressed data
//	ulong aulBufferLength
//		Number of UNCOMPRESSED bytes to read from the file.
//--------------------------------------------------------------------
// Returns:	(LONG) - >0 = The number of uncompressed bytes actually read.
//							 0 = End of file
//							-1 = Error
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

// Allocate memory before calling API function
ablBuffer = Blob( Space(aulBufferLength) )

RETURN gzread( alFile, ablBuffer, aulBufferLength )

end function

public function long of_gzwrite (long alFile, blob ablBuffer);//====================================================================
// Function - of_gzwrite for nvo_zlib
//--------------------------------------------------------------------
// Description:Writes the given number of UNCOMPRESSED bytes into
//					the compressed file.
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned by GZOPEN
//	blob ablBuffer
//		Buffer containing the UNCOMPRESSED data.
//--------------------------------------------------------------------
// Returns:	(LONG) - >0 Number of uncompressed bytes actually written
//							0 = Error
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzwrite( alFile, ablBuffer, Len(ablBuffer) )

end function

public function long of_gzclose (long alFile);//====================================================================
// Function - of_gzclose for nvo_zlib
//--------------------------------------------------------------------
// Description:Flushes all pending output if necessary, closes the
//					compressed file and deallocates all the compression
//					state.
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned by GZOPEN
//--------------------------------------------------------------------
// Returns:	(LONG) - Returns the zlib error number (see GZERROR)
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzclose( alFile )

end function

public function string of_gzerror (long alFile, ref long alErrorNumber);//====================================================================
// Function - of_gzerror for nvo_zlib
//--------------------------------------------------------------------
// Description:Returns the error message for the last error which
//					occured on the given compressed file. 
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned by GZOPEN
//	REF long alErrorNumber
//		zlib error number.
//--------------------------------------------------------------------
// Returns:	(STRING) - Error message for the last error which occured.
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzerror( alFile, alErrorNumber )

end function

public function long of_gzrewind (long alFile);//====================================================================
// Function - of_gzrewind for nvo_zlib
//--------------------------------------------------------------------
// Description:Rewinds the given file. 
//
//	NOTE:	This function is only supported for reading.
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned by GZOPEN
//--------------------------------------------------------------------
// Returns:	(LONG) - Z_OK
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzrewind( alFile )

end function

public function long of_gzeof (long alFile);//====================================================================
// Function - of_gzeof for nvo_zlib
//--------------------------------------------------------------------
// Description:Returns 1 when EOF has previously been detected reading
//					the given input stream. Otherwise 0.
//--------------------------------------------------------------------
// Arguments:	
//
//	long alFile
//		File handle returned by GZOPEN
//--------------------------------------------------------------------
// Returns:	(LONG) - 1 = EOF
//							0 = Not EOF
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN gzeof( alFile )

end function

public function string of_zlibversion ();//====================================================================
// Function - of_zlibversion for nvo_zlib
//--------------------------------------------------------------------
// Description:Returns the zlib version (currently 1.1.3)
//--------------------------------------------------------------------
// Returns:	(STRING) - zlib version string
//--------------------------------------------------------------------
// Author:	REGAN SIZER		Date: April, 2000
//====================================================================

RETURN zlibVersion()

end function

public function integer of_zip (string as_source, string as_zip_file);CONSTANT LONG BUFFER_LENGTH = 2048	// Tamaño de Bloque de Lectura/Escritura 2K

string	ls_source, ls_zip_file, lsErrorMessage
long		ll_gZipFile, ll_SourceFile, ll_Bytes, ll_Error
blob		lblBuffer
Integer	li_rc, li_pos

// Nombre de Archivos
ls_source	= as_source
ls_zip_file		= as_zip_file

li_pos = POS(ls_zip_file,'.')			//  Terminacion .gz al nombre del file
IF li_pos > 1 THEN
	ls_zip_file = Left(ls_zip_file, li_pos -1) + '.gz'
ELSE
	ls_zip_file = ls_zip_file + '.gz'
END IF

// Validacion de nombre de archivos
IF (ls_source = "") OR NOT FileExists( ls_source ) OR (ls_zip_file = "") THEN
	MessageBox( "Error", "Revise los nombres de archivos" )
	li_rc = -1	
	RETURN li_rc
END IF

// parametros de libreria GZIP 
ll_SourceFile	= of_gzOpen( ls_source, "rb" )
ll_gZipFile		= of_gzOpen( ls_zip_file, "wb9" )	// BEST compression (9)

// Leer del buffer
ll_Bytes = of_gzRead( ll_SourceFile, lblBuffer, BUFFER_LENGTH )

DO WHILE (ll_Bytes > 0)
	// Escribir en file comprimido
	IF of_gzWrite( ll_gZipFile, lblBuffer ) < 1 THEN
		// Error de escritura
		lsErrorMessage = of_gzError( ll_gZipFile, ll_Error )
		MessageBox( "zlib error", "Error Comprimiento el Archivo: " + ls_zip_file + &
			"~r~n~r~nNumero Error: " + String(ll_Error) + &
			"~r~n~r~nMensaje: " + lsErrorMessage )
		EXIT
	END IF

	// Leer siguiente bloque de data
	ll_Bytes = of_gzRead( ll_SourceFile, lblBuffer, BUFFER_LENGTH )
LOOP

// Cerrar Archivos
of_gzClose( ll_SourceFile )
of_gzClose( ll_gZipFile )
li_rc = 1


RETURN li_rc		// -1 = error, 1=ok


end function

on n_cst_zlib.create
TriggerEvent( this, "constructor" )
end on

on n_cst_zlib.destroy
TriggerEvent( this, "destructor" )
end on

