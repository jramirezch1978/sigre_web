$PBExportHeader$n_cst_xml.sru
forward
global type n_cst_xml from nonvisualobject
end type
end forward

global type n_cst_xml from nonvisualobject
end type
global n_cst_xml n_cst_xml

type variables
public:
String				is_file_xml
String				is_path_xml

private:
n_cst_utilitario	invo_util
n_cst_inifile		invo_inifile
end variables

forward prototypes
public function boolean of_write_rc_xml (string as_filename, string as_texto, date ad_fecha)
public function boolean of_write_ra_xml (string as_filename, string as_texto, date ad_fecha)
public function boolean of_write_ce_fs (string as_filename, string as_texto, date ad_fecha)
public function boolean of_filedelete_xml (string as_filename, date ad_fecha)
public function boolean of_fileexists_xml (string as_filename, date ad_fecha)
public function string of_get_fullname (string as_filename, date ad_fecha)
public function string of_get_pathfilexml_fs (string as_filename, date ad_fecha)
public function string of_get_pathfilexml_rc (string as_filename, date ad_fecha)
public function string of_get_pathfilexml_ra (string as_filename, date ad_fecha)
public function boolean of_load ()
public function string of_get_path (string as_filename, date ad_fecha)
end prototypes

public function boolean of_write_rc_xml (string as_filename, string as_texto, date ad_fecha);String	ls_path, ls_file_xml
Integer 	li_filenum = 0, li_rc


try 
	//Directorio donde se guardan los PDF
	ls_path= this.is_path_xml + 'Resumen_diario\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			 + '\' + string(ad_fecha, 'yyyymmdd') +'\'  //NOMBRE DE DIRECTORIO
	
	If not DirectoryExists ( ls_path ) Then
		
		//CREACION DE CARPETA
		if not invo_util.of_CreateDirectory ( ls_path ) then
			RETURN false
		end if
	
	End If
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	//Abro el archivo
	li_filenum = FileOpen(ls_file_xml, StreamMode!, Write!, LockWrite!, Append!)
	
	//Guardo el texto
	li_rc = FileWrite(li_filenum, as_texto + char(13) + char(10))
	
	//Cierro el archivo
	IF li_rc < 0 THEN
		MessageBox('Error', 'HA ocurrido un error al grabar el texto ' + as_texto + ' en archivo XML ' + ls_file_xml, StopSign!)
		return false
	End if
	
	return true
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_write_rc_xml. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
finally
	//Cierro el archivo
	if li_filenum > 0 then
		FileClose(li_filenum)
		
		IF li_rc > 0 THEN
			li_rc = FileClose(li_filenum)
		else
			MessageBox('Error', 'Ha ocurrido un error al grabar al cerrar el archivo ' + ls_file_xml, StopSign!)
			return false
		End if
	end if
end try


end function

public function boolean of_write_ra_xml (string as_filename, string as_texto, date ad_fecha);String	ls_path, ls_file_xml
Integer 	li_filenum = 0, li_rc

try 
	//Directorio donde se guardan los PDF
	ls_path = this.is_path_xml + 'Resumen_baja\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	
	If not DirectoryExists ( ls_path ) Then
		
		//CREACION DE CARPETA
		if not invo_util.of_CreateDirectory ( ls_path ) then return false
	
	End If
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	//Abro el archivo
	li_filenum = FileOpen(ls_file_xml, StreamMode!, Write!, LockWrite!, Append!)
	
	//Guardo el texto
	li_rc = FileWrite(li_filenum, as_texto + char(13) + char(10))
	
	//Cierro el archivo
	IF li_rc < 0 THEN
		MessageBox('Error', 'HA ocurrido un error al grabar el texto ' + as_texto + ' en archivo XML ' + ls_file_xml, StopSign!)
		return false
	End if
	
	return true

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_write_ra_xml. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
finally
	//Cierro el archivo
	if li_filenum > 0 then
		FileClose(li_filenum)
		
		IF li_rc > 0 THEN
			li_rc = FileClose(li_filenum)
		else
			MessageBox('Error', 'Ha ocurrido un error al grabar al cerrar el archivo ' + ls_file_xml, StopSign!)
			return false
		End if
	end if
end try



end function

public function boolean of_write_ce_fs (string as_filename, string as_texto, date ad_fecha);String	ls_path, ls_tipo_doc, ls_serie
Integer 	li_filenum  = 0, li_rc

try 
	
	if IsNull(as_texto) or trim(as_texto) = '' then
		MessageBox('Error', 'El texto enviado es nulo o vacio, no se puede grabar en archivo XML ' + is_file_xml, StopSign!)
		return false
	end if
	
	//Directorio donde se guardan los PDF
	ls_path = of_get_path(as_filename, ad_fecha)
	
	If not DirectoryExists ( ls_path ) Then
		//CREACION DE CARPETA
		if not invo_util.of_CreateDirectory ( ls_path ) then return false

	End If
	
	//Nombre del archivo  PDF
	is_file_xml = ls_path + as_filename + '.xml'
	
	//Abro el archivo
	li_filenum = FileOpen(is_file_xml, StreamMode!, Write!, LockWrite!, Append!)
	
	IF li_filenum = -1 then
		MessageBox('Error', 'Ha ocurrido un error al abrir el ARCHIVO XML ' + is_file_xml, StopSign!)
		return false
	End if
	
	//Guardo el texto
	li_rc = FileWrite(li_filenum, as_texto + char(13) + char(10))
	
	IF li_rc < 0 then
		MessageBox('Error', 'Ha ocurrido un error al grabar el texto ' + as_texto + ' en archivo XML ' + is_file_xml, StopSign!)
		return false
	End if
	
	return true

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_wrtie_ce_fs. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
finally
	//Cierro el archivo
	if li_filenum > 0 then
		li_rc = FileClose(li_filenum)
		
		IF li_rc < 0 THEN
			MessageBox('Error', 'Ha ocurrido un error al grabar al cerrar el archivo ' + is_file_xml, StopSign!)
			return false
		End if
	end if
end try



end function

public function boolean of_filedelete_xml (string as_filename, date ad_fecha);String	ls_path, ls_file_xml, ls_tipo_doc, ls_serie
Integer 	li_filenum  = 0, li_rc

try 
	
	//Directorio donde se guardan los PDF
	ls_path = this.of_get_path(as_filename, ad_fecha)
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	if Not FileDelete(ls_file_xml) then return false
	
	return true

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_fileexists_ce. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
end try



end function

public function boolean of_fileexists_xml (string as_filename, date ad_fecha);String	ls_path, ls_file_xml, ls_tipo_doc, ls_serie
Integer 	li_filenum  = 0, li_rc

try 
	
	//Directorio donde se guardan los PDF
	ls_path = this.of_get_path(as_filename, ad_fecha)
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	if Not FileExists(ls_file_xml) then return false
	
	return true

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_fileexists_ce. Mensaje: ' + ex.getMessage(), StopSign!)
	return false
	
end try



end function

public function string of_get_fullname (string as_filename, date ad_fecha);String	ls_path, ls_file_xml
Integer 	li_filenum  = 0, li_rc

try 
	
	//Directorio donde se guardan los PDF
	ls_path = this.of_get_path(as_filename, ad_fecha)
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	return ls_file_xml

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_fileexists_ce. Mensaje: ' + ex.getMessage(), StopSign!)
	return ''
	
end try



end function

public function string of_get_pathfilexml_fs (string as_filename, date ad_fecha);String	ls_path, ls_tipo_doc, ls_serie, ls_PathFile

try 
	
	//Directorio donde se guardan los PDF
	ls_path = this.of_get_path(as_filename, ad_fecha)
	
	//Nombre del archivo  PDF
	ls_PathFile = ls_path + as_filename + '.xml'
	
	return ls_PathFile

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_wrtie_ce_fs. Mensaje: ' + ex.getMessage(), StopSign!)
	return gnvo_app.is_null
	
end try



end function

public function string of_get_pathfilexml_rc (string as_filename, date ad_fecha);String	ls_path, ls_file_xml


try 
	//Directorio donde se guardan los PDF
	ls_path= this.is_path_xml + 'Resumen_diario\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			 + '\' + string(ad_fecha, 'yyyymmdd') +'\'  //NOMBRE DE DIRECTORIO
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	
	return ls_file_xml
	
catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_get_pathFileXML_RC. Mensaje: ' + ex.getMessage(), StopSign!)
	return gnvo_app.is_null
	
end try


end function

public function string of_get_pathfilexml_ra (string as_filename, date ad_fecha);String	ls_path, ls_file_xml

try 
	//Directorio donde se guardan los PDF
	ls_path = this.is_path_xml + 'Resumen_baja\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
			  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	
	//Nombre del archivo  PDF
	ls_file_xml = ls_path + as_filename + '.xml'
	
	return ls_file_xml

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_get_pathFileXML_RA. Mensaje: ' + ex.getMessage(), StopSign!)
	return gnvo_app.is_null
	
end try



end function

public function boolean of_load ();try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	this.is_path_xml		 	= invo_inifile.of_get_parametro( "EXPORT_XML", "PathXML", "i:\SIGRE_EXE\XML\")
	
	//Si no termina con la barra invertida entonces lo agrego
	if right(this.is_path_xml, 1) <> '\' then
		this.is_path_xml += '\'
	end if
	
	return true

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, 'Error en of_load()')
	
end try



end function

public function string of_get_path (string as_filename, date ad_fecha);String	ls_tipo_doc, ls_serie, ls_path

try 
	ls_tipo_doc = mid(as_filename, 13, 2)
	ls_Serie	   = mid(as_filename, 16, 1)
	
	//Directorio donde se guardan los PDF
	if ls_tipo_doc = '01' then
		ls_path =  this.is_path_xml + 'Facturas\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	elseif ls_tipo_doc = '03' then
		ls_path = this.is_path_xml + 'Boletas\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	elseif ls_tipo_doc = '07' or ls_tipo_doc = '08' then
		if ls_serie = 'B' then
			ls_path = this.is_path_xml + 'Boletas\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
					  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
		else
			ls_path = this.is_path_xml + 'Facturas\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
					  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
		end if		
	elseif ls_tipo_doc = '09' then
		//Guias de Remisión Electronica
		ls_path = this.is_path_xml + 'GREs\' + gnvo_app.empresa.is_ruc + '_' + gnvo_app.empresa.is_sigla &
				  + '\' + string(ad_fecha, 'yyyymmdd') + '\' //NOMBRE DE DIRECTORIO
	end if
	
	return ls_path

catch ( Exception ex )
	MessageBox('Error', 'Ha ocurrido una exception en la función of_wrtie_ce_fs. Mensaje: ' + ex.getMessage(), StopSign!)
	return gnvo_app.is_null
	
end try



end function

on n_cst_xml.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_xml.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_inifile = create n_cst_inifile
end event

event destructor;destroy invo_inifile
end event

