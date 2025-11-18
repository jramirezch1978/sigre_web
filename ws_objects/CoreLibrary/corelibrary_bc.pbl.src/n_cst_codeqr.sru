$PBExportHeader$n_cst_codeqr.sru
forward
global type n_cst_codeqr from nonvisualobject
end type
end forward

global type n_cst_codeqr from nonvisualobject
end type
global n_cst_codeqr n_cst_codeqr

type prototypes
//Funciones para la generación del codigo QR
SUBROUTINE FastQRCode(REF String Texto, REF String FileName) LIBRARY "\sigre_exe\QRCodeLib.dll" Alias for "FastQRCode;Ansi"
//subroutine FastQRCode(ref string text, ref string filename) library '\sigre_exe\QRCodeLib.dll' ALIAS FOR "FastQRCode"
Function String QRCodeLibVer() LIBRARY "\sigre_exe\QRCodeLib.dll" Alias for "QRCodeLibVer;Ansi"
end prototypes

type variables
n_cst_utilitario	invo_util
end variables

forward prototypes
public function string of_generar_qrcode (string as_tipo_doc_ident, string as_nro_doc_ident, string as_valor) throws exception
public function string of_generar_qrcode (string as_valor, string as_codigo) throws exception
end prototypes

public function string of_generar_qrcode (string as_tipo_doc_ident, string as_nro_doc_ident, string as_valor) throws exception;String 		ls_path, ls_file_qr
Exception	ex

If ISNull(as_valor) or trim(as_valor) = '' Then
	ex = create exception
	ex.setMessage("Error, no se ha ingresado un valor para generar el codigo QR")
	throw ex

End If

//Directorio donde se guardan los codeQR
ls_path ='\SIGRE_EXE\QR_CODE_TMP\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '\'  

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then 
		ex = create exception
		ex.setMessage("No se creado el directorio correctamente. Directorio: " + ls_path)
		throw ex
	end if

End If

//Nombre del archivo 
ls_file_qr = ls_path + as_tipo_doc_ident + '_' + as_nro_doc_ident + '.bmp'

//Genero el codigo QR
FastQRCode(as_valor, ls_file_qr)

If not FileExists ( ls_file_qr ) Then
	ex = create exception
	ex.setMessage("No se ha creado el archivo QR correctamente. File: " + ls_file_qr)
	throw ex

End If

return ls_file_qr
end function

public function string of_generar_qrcode (string as_valor, string as_codigo) throws exception;String 		ls_path, ls_file_qr
Exception	ex

If ISNull(as_valor) or trim(as_valor) = '' Then
	ex = create exception
	ex.setMessage("Error, no se ha ingresado un valor para generar el codigo QR")
	throw ex

End If

//Directorio donde se guardan los codeQR
ls_path ='\SIGRE_EXE\QR_CODE_TMP\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla + '\'  

If not DirectoryExists ( ls_path ) Then
	
	if not invo_util.of_CreateDirectory( ls_path ) then 
		ex = create exception
		ex.setMessage("No se creado el directorio correctamente. Directorio: " + ls_path)
		throw ex
	end if

End If

//Nombre del archivo 
ls_file_qr = ls_path + as_codigo + '.bmp'

//Genero el codigo QR
FastQRCode(as_valor, ls_file_qr)

If not FileExists ( ls_file_qr ) Then
	ex = create exception
	ex.setMessage("No se ha creado el archivo QR correctamente. File: " + ls_file_qr)
	throw ex

End If

return ls_file_qr
end function

on n_cst_codeqr.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_codeqr.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

