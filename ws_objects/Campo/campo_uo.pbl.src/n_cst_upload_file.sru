$PBExportHeader$n_cst_upload_file.sru
forward
global type n_cst_upload_file from nonvisualobject
end type
end forward

global type n_cst_upload_file from nonvisualobject
end type
global n_cst_upload_file n_cst_upload_file

forward prototypes
public function boolean of_grabar_foto (string as_filename, string as_codtra, string as_doc, date ad_fec, string as_id)
end prototypes

public function boolean of_grabar_foto (string as_filename, string as_codtra, string as_doc, date ad_fec, string as_id);Integer 	li_result
blob  	lbl_Emp_foto
string 	ls_mensaje
n_cst_file_Blob	lnvo_fileRead

lnvo_FileRead = create n_cst_file_blob

try
	lbl_Emp_foto = lnvo_FileRead.of_read_blob( as_filename )
catch (Exception ex)
	MessageBox('Error al momento de leer el archivo', ex.getMessage())
end try

destroy lnvo_FileRead

choose case as_id
	case '1'
		// Actualizo el archivo blob
				UPDATEBLOB sic_productor_file
						 SET doc_blob = :lbl_Emp_foto
				WHERE proveedor = :as_codtra
					and cod_documento = :as_doc
					and fec_documento = :ad_fec;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir el Archivo', ls_mensaje)
					return false
				end if
				
				//Actualizo el arreglo
				UPDATE sic_productor_file
					SET filename = :as_filename
				WHERE proveedor = :as_codtra
					and cod_documento = :as_doc
					and fec_documento = :ad_fec;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir Archivo', ls_mensaje)
					return false
				end if
				
				IF SQLCA.SQLNRows > 0 THEN
					COMMIT;
				else
					ROLLBACK;
					MessageBox('Error al subir Archivo', 'No existe codigo: ' + as_codtra)
					return false
				END IF
	case '2'
		// Actualizo el archivo blob
				UPDATEBLOB sic_procedimientos
						 SET doc_blob = :lbl_Emp_foto
				WHERE to_char(procedimiento_id) = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir El Archivo', ls_mensaje)
					return false
				end if
				
				//Actualizo el arreglo
				UPDATE sic_procedimientos
					SET filename = :as_filename
				WHERE to_char(procedimiento_id) = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir Archivo', ls_mensaje)
					return false
				end if
				
				IF SQLCA.SQLNRows > 0 THEN
					COMMIT;
				else
					ROLLBACK;
					MessageBox('Error al subir Archivo', 'No existe codigo: ' + as_codtra)
					return false
				END IF
		case '3'
		// Actualizo el archivo blob
				UPDATEBLOB sic_cuaderno_productor
						 SET CROQUIS = :lbl_Emp_foto
				WHERE to_char(nro_registro) = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir El Archivo', ls_mensaje)
					return false
				end if
				
				//Actualizo el arreglo
				UPDATE sic_cuaderno_productor
					SET filename = :as_filename
				WHERE to_char(nro_registro) = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir Archivo', ls_mensaje)
					return false
				end if
				
				IF SQLCA.SQLNRows > 0 THEN
					COMMIT;
				else
					ROLLBACK;
					MessageBox('Error al subir Archivo', 'No existe codigo: ' + as_codtra)
					return false
				END IF

	case '4'
		// Actualizo el archivo blob
				UPDATEBLOB SIC_DOCUMENTOS_EMPRESA
						 SET doc_blob = :lbl_Emp_foto
				WHERE doc_id = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir el Archivo', ls_mensaje)
					return false
				end if
				
				//Actualizo el arreglo
				UPDATE SIC_DOCUMENTOS_EMPRESA
					SET filename = :as_filename
				WHERE doc_id = :as_codtra;
				
				if SQLCA.sqlcode = -1 then
					ls_mensaje = SQLCA.SQLErrText
					ROLLBACK;
					MessageBox('Error al subir Archivo', ls_mensaje)
					return false
				end if
				
				IF SQLCA.SQLNRows > 0 THEN
					COMMIT;
				else
					ROLLBACK;
					MessageBox('Error al subir Archivo', 'No existe codigo: ' + as_codtra)
					return false
				END IF

end choose

				

return true
end function

on n_cst_upload_file.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_upload_file.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

