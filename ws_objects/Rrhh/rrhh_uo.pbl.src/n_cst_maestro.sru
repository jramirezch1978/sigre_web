$PBExportHeader$n_cst_maestro.sru
forward
global type n_cst_maestro from nonvisualobject
end type
end forward

global type n_cst_maestro from nonvisualobject
end type
global n_cst_maestro n_cst_maestro

forward prototypes
public function boolean of_grabar_foto (string as_filename, string as_codtra)
public function long of_dias_trabajados (string as_codtrab, date ad_fecha1, date ad_fecha2)
public function boolean of_grabar_mof (string as_filename, string as_cod_cargo)
end prototypes

public function boolean of_grabar_foto (string as_filename, string as_codtra);Integer 	li_result
blob  	lbl_Emp_foto
string 	ls_mensaje
n_cst_file_Blob	lnvo_fileRead

try
	lnvo_FileRead = create n_cst_file_blob
	lbl_Emp_foto = lnvo_FileRead.of_read_blob( as_filename )
	
	// Actualizo el archivo blob
	UPDATEBLOB Maestro 
			 SET foto_blob = :lbl_Emp_foto
	WHERE cod_trabajador = :as_codtra
	   or trim(nro_doc_ident_rtps) = :as_codtra;
	
	if SQLCA.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al subir la foto', "Error al momento de subir la foto. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	IF SQLCA.SQLNRows = 0 THEN
		ROLLBACK;
		MessageBox('Error al subir la foto', 'No existe codigo o Nro Documento Identidad : ' + as_codtra)
		return false
	end if
	
	//Actualizo el arreglo
	UPDATE Maestro 
		SET FOTO_TRABAJ = :as_filename
	WHERE cod_trabajador = :as_codtra
	   or trim(nro_doc_ident_rtps) = :as_codtra;
	
	if SQLCA.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al subir la foto', "Error al momento de subir la foto. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	IF SQLCA.SQlCode = 100 THEN
		ROLLBACK;
		MessageBox('Error al subir la foto', 'No existe codigo: ' + as_codtra)
		return false
	end if
	
	COMMIT;
	
	return true

catch (Exception ex)
	MessageBox('Error al momento de leer el archivo', ex.getMessage())
	
finally
	destroy lnvo_FileRead
	
end try
end function

public function long of_dias_trabajados (string as_codtrab, date ad_fecha1, date ad_fecha2);String 	ls_mensaje
Long		ll_nro_dias

//function of_dias_asist(
//		  as_cod_trabajador  maestro.cod_trabajador%TYPE, 
//		  adi_fecha1         date, 
//		  adi_Fecha2         date
//) return decimal is
  
DECLARE of_dias_asist PROCEDURE FOR 
	USP_SIGRE_RRHH.of_dias_asist( :as_codtrab, 
											:ad_Fecha1,
											:ad_fecha2);	
EXECUTE of_dias_asist;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al ejecutar la función of_dias_trabajados de la clas n_cst_maestro. Mensaje: ' + ls_mensaje)
	return -1
end if

FETCH of_dias_asist into :ll_nro_dias;

Close of_dias_asist;

return ll_nro_dias
end function

public function boolean of_grabar_mof (string as_filename, string as_cod_cargo);Integer 	li_result
blob  	lbl_data
string 	ls_mensaje
n_cst_file_Blob	lnvo_fileRead

try
	lnvo_FileRead = create n_cst_file_blob
	lbl_data = lnvo_FileRead.of_read_blob( as_filename )
	
	// Actualizo el archivo blob
	UPDATEBLOB cargo 
			 SET manual_mof = :lbl_data
	WHERE cod_cargo = :as_cod_Cargo;
	
	if SQLCA.sqlcode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error al subir datos', "Error al momento de subir MOF al CARGO. Mensaje: " + ls_mensaje, StopSign!)
		return false
	end if
	
	IF SQLCA.SQLNRows = 0 THEN
		ROLLBACK;
		MessageBox('Error al subir datos', 'No existe codigo de cargo: ' + as_cod_Cargo)
		return false
	end if
	
	return true

catch (Exception ex)
	MessageBox('Error al momento de leer el archivo', ex.getMessage())
	
finally
	destroy lnvo_FileRead
	
end try
end function

on n_cst_maestro.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_maestro.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

