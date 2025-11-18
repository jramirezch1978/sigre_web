$PBExportHeader$n_cst_file_blob.sru
forward
global type n_cst_file_blob from nonvisualobject
end type
end forward

global type n_cst_file_blob from nonvisualobject
end type
global n_cst_file_blob n_cst_file_blob

forward prototypes
public function blob of_read_blob (string as_filename) throws exception
public function boolean of_write_blob (string as_file, blob ablb_data)
end prototypes

public function blob of_read_blob (string as_filename) throws exception;integer 	li_FileNum, li_loops, li_i
long 		ll_FileLen, ll_BytesRead, ll_NewPos

blob 		lbl_tmp, lbl_FileBlob
Exception lex_error

//Valido si el archivo existe
if not FileExists(as_filename) then
	lex_error = create Exception
	lex_error.setMessage('No existe el archivo, por favor verifique')
	throw lex_error
	return lbl_FileBlob
end if

// Set a wait cursor
SetPointer(HourGlass!)

// Get the file length, and open the file
ll_FileLen = FileLength(as_fileName)

li_FileNum = FileOpen(as_FileName, StreamMode!, Read!, LockRead!)

// Determine how many times to call FileRead
IF ll_FileLen > 32765 THEN
	IF Mod(ll_FileLen, 32765) = 0 THEN
   	li_loops = ll_FileLen/32765
   ELSE
      li_loops = (ll_FileLen/32765) + 1
   END IF
ELSE
   li_loops = 1
END IF

// Read the file
ll_NewPos = 1

FOR li_i = 1 to li_loops
    ll_BytesRead = FileRead(li_FileNum, lbl_Tmp)
    lbl_FileBlob = lbl_FileBlob + lbl_Tmp
NEXT

FileClose(li_FileNum)

setPointer(Arrow!)

return lbl_FileBlob
end function

public function boolean of_write_blob (string as_file, blob ablb_data);Integer li_FileNum

if IsNull(ablb_data) then return false

li_FileNum = FileOpen(as_file, StreamMode!, Write!, Shared!, Replace!)

if li_FileNum = -1 then 
	gnvo_app.of_mensaje_error("No se puede abrir el archivo " + as_file + ". Por favor corregir")
	return false
end if


FileWriteEx(li_FileNum, ablb_data)
FileClose(li_FileNum)

return true
end function

on n_cst_file_blob.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_file_blob.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

