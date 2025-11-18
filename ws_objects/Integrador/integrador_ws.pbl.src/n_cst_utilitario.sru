$PBExportHeader$n_cst_utilitario.sru
forward
global type n_cst_utilitario from nonvisualobject
end type
end forward

global type n_cst_utilitario from nonvisualobject autoinstantiate
end type

type variables
String is_regkey_config 	= "HKEY_CURRENT_USER\Software\SIGRE\Configuration"
String is_regkey_register 	= "HKEY_CURRENT_USER\Software\SIGRE\Registro"
end variables

forward prototypes
public function string of_replace (string as_cadena, string as_string1, string as_string2)
public function string of_replaceall (string as_oldstring, string as_findstr, string as_replace)
public function string lpad (string as_cadena, long al_longitud, string as_caracter)
public function str_parametros of_split (string as_cadena, string as_separador)
public function string of_get_texto (string as_titulo, string as_default_txt)
public function boolean of_createdirectory (string as_directorio)
public function date of_get_fecha ()
public function blob of_load_blob (string as_filename)
public function string of_get_serie (string as_nro_doc)
public function string of_get_nro (string as_nro_doc)
public function string of_get_nro_doc (string as_serie, string as_nro)
public function string of_get_full_nro (string as_nro_doc)
public function integer of_print_preview ()
public function string of_nro_tipo_serie (string as_tipo_doc, string as_serie)
public function string of_set_numera (string as_table_name)
public subroutine of_setreg (string as_entry, string as_value)
public function string of_getreg (string as_entry, string as_default)
end prototypes

public function string of_replace (string as_cadena, string as_string1, string as_string2);//Utiliza esta sintáxis, 
Long 		ll_pos
string	ls_retorno

ls_retorno = as_cadena

ll_pos = Pos(ls_retorno, as_string1) 
DO WHILE ll_pos > 0 
	ls_retorno = replace(ls_retorno, ll_pos, len(as_string1), as_string2) 
	ll_pos = Pos(ls_retorno, as_string1, ll_pos + len(as_string2)) 
LOOP

return ls_retorno

end function

public function string of_replaceall (string as_oldstring, string as_findstr, string as_replace);String ls_newstring
Long ll_findstr, ll_replace, ll_pos

// get length of strings
ll_findstr = Len(as_findstr)
ll_replace = Len(as_replace)

// find first occurrence
ls_newstring = as_oldstring
ll_pos = Pos(ls_newstring, as_findstr)

Do While ll_pos > 0
	// replace old with new
	ls_newstring = Replace(ls_newstring, ll_pos, ll_findstr, as_replace)
	// find next occurrence
	ll_pos = Pos(ls_newstring, as_findstr, (ll_pos + ll_replace))
Loop

Return ls_newstring

end function

public function string lpad (string as_cadena, long al_longitud, string as_caracter);//***************************************************************************************//
// Objectivo  : Permite llenar una cadena con caracteres                                 //
// Sintaxis   : f_llena_ceros(as_caracter,as_variable,as_long)                           //
// Argumentos : as_caracter -> Caracter con el que se desea llenar una cadena            //
//              as_cadena   -> Es la Cadena que sera llenada con caracteres              //
//              as_long     -> El numero de caracteres que llenan la cadena              //
//																											        //
// Ejemplo :  f_llena_ceros('#','cadena',2)                                              //
// Return  :  '##cadena'                                                                 //
//***************************************************************************************//
String  ls_temp, ls_codigo
Integer li_resto, li_i

li_resto = al_longitud - len(trim(as_cadena))

ls_temp = ""

if li_resto > 0 then
	
	FOR li_i=1 TO li_resto 
	  ls_temp += as_caracter	
	NEXT

	ls_codigo = ls_temp + trim(as_cadena)
else
	ls_codigo = trim(as_cadena)
end if

RETURN ls_codigo
end function

public function str_parametros of_split (string as_cadena, string as_separador);str_parametros	lstr_param

string 	ls_array[], ls_now, ls_cadena
long 		ln_arraylen, ln_stringlen, ln_place_nbr, ln_i, ln_place_tt

ls_cadena = trim(as_cadena)

ln_stringlen = len(ls_cadena)
DO WHILE ln_stringlen > 0 
	ln_place_nbr = pos(ls_cadena, ",")
	IF ln_place_nbr > 0 THEN
		ln_place_tt = ln_place_nbr - 1
		ls_now = Mid(ls_cadena, 0, ln_place_tt)
		ls_cadena = RIGHT(ls_cadena, ln_stringlen - ln_place_nbr)
		ln_stringlen = ln_stringlen - ln_place_nbr
	ELSE
		ls_now = ls_cadena
		ls_cadena = RIGHT(ls_cadena, ln_stringlen - ln_place_nbr)
		ln_stringlen = 0
	END IF
  	ls_now = trim(ls_now)
  	ln_arraylen = UpperBound(ls_array)
  	ls_array[ln_arraylen + 1] = ls_now
LOOP

lstr_param.str_array = ls_array

return lstr_param
end function

public function string of_get_texto (string as_titulo, string as_default_txt);String ls_texto
str_parametros lstr_param


ls_texto = ''
lstr_param.titulo = as_titulo
lstr_param.texto 	= as_default_txt


openWithParm(w_texto, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return ls_texto

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return ls_texto

ls_texto = lstr_param.texto

return ls_texto
end function

public function boolean of_createdirectory (string as_directorio);string 	ls_path
Long		ll_found, ll_inicio
Integer	li_return

if left(as_directorio, 1) = '\' then
	ll_inicio = 2
else
	ll_inicio = 1
end if

ll_found = pos(as_directorio, '\', ll_inicio)

do while ll_found > 0
	ls_path = mid(as_directorio, 1, ll_found)
	CreateDirectory(ls_path)
	
	li_return = ChangeDirectory (ls_path)
	
	if li_return = -1 then
		Messagebox('Aviso','Fallo Creacion de Directorio ' + ls_path, StopSign!)
		RETURN false
	end if	
	
	ll_inicio = ll_found + 1
	ll_found = pos(as_directorio, '\', ll_inicio)
loop


return true
end function

public function date of_get_fecha ();Str_parametros lstr_param
date				ld_return

open(w_get_fecha)

lstr_param = Message.PowerObjectParm

if lstr_param.b_return then
	ld_return =  lstr_param.fecha1
else
	SetNull(ld_return)
end if

return ld_return

end function

public function blob of_load_blob (string as_filename);//Todo el siguiente codigo en el evento click del CommandButton, "Elegir Imagen"
//Definir parametros para ventana que muestra la carpeta de las imagenes
/// mostrar la imagen
String	ls_mensaje

//Datos a utilizar para almacenar la imagen
integer 	li_vueltas, li_archivo, li_bytes_leidos, li_i 

blob 		lblb_data, lblb_total // Blob variables que vamos a utilizar para la imagen
long 		ll_longitud // Longitud de la imagen
   
if not FileExists(as_filename) then
	MessageBox('Error en funcion of_load_blob()', 'No existe el archivo: ' + as_filename + '. Por favor verifique!!!', StopSign!)
	return lblb_total
end if

// Obtenemos la longitud de la imagen 
ll_longitud = FileLength(as_filename)
   
// Calculamos la longitud para leer la imagen por partes   
IF ll_longitud > 32765 THEN 
	IF Mod(ll_longitud, 32765) = 0 THEN 
		li_vueltas = ll_longitud/32765 
	ELSE 
		li_vueltas = (ll_longitud/32765) + 1 
	END IF 
ELSE 
	li_vueltas = 1 
END IF 
   
// Abrimos el archivo en modo lectura 
li_archivo = FileOpen(as_filename, StreamMode!, Read!, LockRead!) 

//Leemos los bytes del archivo
FOR li_i = 1 to li_vueltas 
	 li_bytes_leidos = FileRead(li_archivo, lblb_Data) 
	 lblb_total = lblb_total + lblb_Data 
NEXT 

// Cerramos el archivo 
FileClose(li_archivo) 

return lblb_total
end function

public function string of_get_serie (string as_nro_doc);string    ls_serie

ls_serie = this.of_replace(as_nro_doc, '.', '-')
    
if Pos(ls_serie, '-') > 0 then
	ls_serie = trim(mid(ls_serie, 1, pos(ls_serie, '-') - 1))
 
 	if left(ls_serie, 1) = 'B'or left(ls_serie, 1) = 'F' or left(ls_serie, 1) = 'T' or left(ls_serie, 1) = 'E' then
	 	ls_serie = left(ls_serie, 1) + this.lpad(trim(mid(ls_serie, 2)), 3, '0')
 	else
	 	ls_Serie = this.lpad(trim(ls_serie), 4, '0')
 	end if
 
else
 	ls_serie = ''
end if
    
return ls_Serie
end function

public function string of_get_nro (string as_nro_doc);string ls_nro 
  
ls_nro = this.of_replace(as_nro_doc, '.', '-')

if pos(ls_nro, '-') > 0 then
	ls_nro = this.lpad(trim(mid(ls_nro, pos(ls_nro, '-') + 1)), 6, '0')
 
else
 	ls_nro = trim(ls_nro)
end if

return ls_nro
  

end function

public function string of_get_nro_doc (string as_serie, string as_nro);string	ls_nro_doc, ls_nro, ls_char
Long		ll_longitud, ll_i, ll_flag
  
ls_nro_doc = ''
ll_flag = 0;
 
// Primero proceso la serie
ll_longitud = len(trim(as_Serie));
for ll_i = 1 to ll_longitud 
	ls_char = mid(as_serie, ll_i, 1)
	if ls_char = 'B' or ls_char = 'F' or ls_char = 'E' or ls_char = 'T' then
		ls_nro_doc = trim(ls_nro_doc) + ls_char
	elseif ls_char = '0' and ll_flag = 0 then
		ll_flag = 1
	elseif ls_char <> '0' and ll_flag >= 0 then
		ls_nro_doc = trim(ls_nro_doc) + ls_char
		if ll_flag = 1 or ll_i > 1 then ll_flag = -1
	elseif ll_flag = -1 then
		ls_nro_doc = trim(ls_nro_doc) + ls_char;
	end if
next
 
ls_nro_doc = trim(ls_nro_doc) + '-';
 
// Segundo proceso el numero
ll_longitud = 10 - len(trim(ls_nro_doc))

if len(trim(as_nro)) > ll_longitud then
	ls_nro = mid(trim(as_nro), len(trim(as_nro)) - ll_longitud + 1, ll_longitud);
else
 	ls_nro = trim(as_nro);
end if;    
 
// Quito los ceros
ll_longitud = len(trim(ls_nro))
ll_flag = 0
for ll_i = 1 to ll_longitud
	ls_char = mid(ls_nro, ll_i, 1)
  	if ls_char = '0' and ll_flag = 0 then
	  ll_flag = 1
	elseif ls_char <> '0' and ll_flag >= 0 then
	  ls_nro_doc = trim(ls_nro_doc) + ls_char
	  ll_flag = -1
	elseif ll_flag = -1 then
	  ls_nro_doc = trim(ls_nro_doc) + ls_char
  	end if
next
 
return ls_nro_doc


end function

public function string of_get_full_nro (string as_nro_doc);string ls_nro, ls_serie
  
ls_serie = this.of_get_serie(as_nro_doc)

if trim(ls_serie) <> '' then
	ls_nro = ls_serie +  '-' + this.of_get_nro(as_nro_doc)
else
	ls_nro = this.of_get_nro(as_nro_doc)
end if
    
return ls_nro

end function

public function integer of_print_preview ();//Solicita si es impresión directa o previsualización
str_parametros lstr_param

Open(w_print_preview)
lstr_param = Message.PowerObjectParm

return lstr_param.i_return

end function

public function string of_nro_tipo_serie (string as_tipo_doc, string as_serie);Long		ll_ult_nro
string	ls_mensaje

select n.ultimo_numero
	into :ll_ult_nro
from num_doc_tipo n
where n.tipo_doc 	= :as_tipo_doc
  and n.nro_serie	= :as_serie;

if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al obtener el ultimo nro de NUMDOC_TIPO. Mensaje: ' + ls_mensaje, StopSign!)
	return 'ERROR'
end if

if SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
end if

return string(ll_ult_nro, '000000')
 

end function

public function string of_set_numera (string as_table_name);//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_next_nro

Select ult_nro 
	into :ll_ult_nro 
from num_tablas 
where tabla = :as_table_name
  and origen = :gs_origen for update;

IF SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
	
	Insert into num_tablas (tabla, origen, ult_nro)
		values(:as_table_name, :gs_origen, 1);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
		return gnvo_app.is_null
	end if
end if

//Asigna numero a cabecera
ls_next_nro = TRIM(gs_origen) + trim(string(ll_ult_nro, '00000000'))

//Incrementa contador
Update num_tablas 
	set ult_nro = :ll_ult_nro + 1 
 where tabla = :as_table_name
	and origen = :gs_origen;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al actualizar num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
	return gnvo_app.is_null
end if
	
return ls_next_nro
end function

public subroutine of_setreg (string as_entry, string as_value);String is_regkey_config

RegistrySet(is_regkey_config, as_entry, as_value)

end subroutine

public function string of_getreg (string as_entry, string as_default);String ls_regvalue

is_regkey_config = "HKEY_CURRENT_USER\Software\SIGRE\EmailSMTP"

RegistryGet(is_regkey_config, as_entry, ls_regvalue)

If ls_regvalue = "" Then
	ls_regvalue = as_default
	
	this.of_setReg(as_entry, ls_regvalue)
End If

Return ls_regvalue

end function

on n_cst_utilitario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_utilitario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

