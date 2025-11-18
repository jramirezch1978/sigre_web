$PBExportHeader$n_cst_file.sru
forward
global type n_cst_file from nonvisualobject
end type
end forward

global type n_cst_file from nonvisualobject autoinstantiate
end type

type variables

private:
n_cst_utilitario	invo_util
n_cst_inifile		invo_inifile
end variables

forward prototypes
public function string of_get_fullname (string as_filename, date ad_fecha)
public function boolean of_write (string as_filename, string as_texto)
end prototypes

public function string of_get_fullname (string as_filename, date ad_fecha);String	ls_path, ls_file_txt, ls_tipo_doc, ls_serie
Integer 	li_filenum  = 0, li_rc

try 
	ls_tipo_doc = mid(as_filename, 13, 2)
	ls_Serie	   = mid(as_filename, 16, 1)
	
	//Directorio donde se guardan los PDF
	ls_path = gnvo_app.is_path_sigre + 'TXT\EMBARGO_TELEMATICO\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
		
	//Nombre del archivo  PDF
	ls_file_txt = ls_path + as_filename
	
	return ls_file_txt

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_get_fullname. Mensaje: ' + ex.getMessage(), StopSign!)
	return ''
	
end try



end function

public function boolean of_write (string as_filename, string as_texto);String	ls_path, ls_tipo_doc, ls_serie
Integer 	li_filenum  = 0, li_pos, li_rc

try 

	
	//Directorio donde se guardan los PDF
	li_pos = LastPos(as_filename, '\')
	
	if li_pos > 0 then
		ls_path = mid(as_filename, 1, li_pos)
	end if
	
	If not DirectoryExists ( ls_path ) Then
		//CREACION DE CARPETA
		if not invo_util.of_CreateDirectory ( ls_path ) then return false

	End If
	
	//Abro el archivo
	li_filenum = FileOpen(as_filename, StreamMode!, Write!, LockWrite!, Append!)
	
	IF li_filenum = -1 then
		MessageBox('Error', 'Ha ocurrido un error al abrir el ARCHIVO TXT ' + as_filename, StopSign!)
		return false
	End if
	
	//Guardo el texto
	li_rc = FileWrite(li_filenum, as_texto + char(13) + char(10))
	
	IF li_rc < 0 then
		MessageBox('Error', 'Ha ocurrido un error al grabar el texto ' + as_texto &
								+ ' en archivo TXT ' + as_filename, StopSign!)
		return false
	End if
	
	return true

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_write. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
finally
	//Cierro el archivo
	if li_filenum > 0 then
		FileClose(li_filenum)
		
		IF li_rc > 0 THEN
			li_rc = FileClose(li_filenum)
		else
			MessageBox('Error', 'Ha ocurrido un error al grabar al cerrar el archivo ' + as_filename, StopSign!)
			return false
		End if
	end if
end try



end function

on n_cst_file.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_file.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

