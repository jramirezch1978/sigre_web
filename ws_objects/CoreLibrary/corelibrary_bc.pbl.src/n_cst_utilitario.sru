$PBExportHeader$n_cst_utilitario.sru
forward
global type n_cst_utilitario from nonvisualobject
end type
end forward

global type n_cst_utilitario from nonvisualobject autoinstantiate
end type

type variables
String is_regkey_config 	= "HKEY_CURRENT_USER\Software\SIGRE\Configuration"
String is_regkey_register 	= "HKEY_CURRENT_USER\Software\SIGRE\Register"
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
public subroutine of_set_register (string as_entry, string as_value)
public function string of_get_register (string as_entry, string as_default)
public subroutine of_set_config (string as_entry, string as_value)
public function string of_get_config (string as_entry, string as_default)
public function string of_get_register (string as_empresa, string as_entry, string as_default) throws exception
public subroutine of_set_register (string as_empresa, string as_entry, string as_value) throws exception
public function string of_left_time_to_string (decimal adc_time_left)
public function string of_10tobase (unsignedlong al_number10, integer ai_base)
public function ulong uf_baseto10 (string as_number, integer ai_base)
public function string of_long2hex (unsignedlong al_number)
public function string of_get_juliano (date ad_fecha)
public function integer of_modelo_factura ()
public function string ltrim (string as_cadena, string as_caracter)
public function boolean find_in_array (string as_value, string as_array[])
public function string of_time_to_string (decimal adc_time_left)
public function str_parametros of_split (string as_cadena)
public function str_ubigeo of_get_ubigeo ()
public function string of_get_string (string as_titulo, string as_default_txt)
public function string of_set_numera (string as_table_name, string as_origen, integer an_longitud, boolean ab_hex)
public function string of_set_numera (string as_table_name, integer an_longitud)
public function string of_set_numera (string as_table_name, integer an_longitud, boolean ab_hex)
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

String	ls_palabra, ls_divisor, ls_texto, ls_string[]
Long		ll_pos, ll_inicio, ll_index

ls_texto = trim(as_cadena)

if IsNull(as_separador) or trim(as_separador) = '' then
	ls_divisor = ' '
else
	ls_divisor = as_separador
end if

ll_inicio = 1
ll_pos = pos(as_cadena, ls_divisor, ll_inicio)

if ll_pos = 0 then
	ls_string[1] = ls_texto 
else
	DO WHILE ll_pos > 0
		ll_index = UpperBound(ls_string)
		
		ls_palabra = mid(ls_texto, ll_inicio, ll_pos - ll_inicio)
		ll_index ++
		ls_string[ll_index] = ls_palabra 
		
		//Obtengo la siguiente palabra
		ll_inicio = ll_pos + 1
		ll_pos = pos(as_cadena, ls_divisor, ll_inicio)
      
	LOOP
	
	if ll_inicio <= len(as_cadena) then
		ls_palabra = mid(ls_texto, ll_inicio)
		ll_index ++
		ls_string[ll_index] = ls_palabra 
	end if
end if

lstr_param.str_array = ls_string

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

if not lstr_param.b_return then return gnvo_app.is_null

ls_texto = lstr_param.texto

return ls_texto
end function

public function boolean of_createdirectory (string as_directorio);string 	ls_path, ls_directorio
Long		ll_found, ll_inicio
Integer	li_return

if right(as_directorio, 1) <> '\' then
	ls_directorio = as_directorio + '\'
else
	ls_directorio = as_directorio
end if

if left(ls_directorio, 1) = '\' then
	ll_inicio = 2
elseif mid(ls_directorio, 2, 1) = ':' then
	ll_inicio = 4
else
	ll_inicio = 1
end if



ll_found = pos(ls_directorio, '\', ll_inicio)

do while ll_found > 0
	ls_path = mid(ls_directorio, 1, ll_found)
	
	if Not DirectoryExists(ls_path) then
		li_return = CreateDirectory(ls_path)
	
		if li_return = -1 then
			Messagebox('Aviso','Fallo, NO SE PUDO CREAR el Directorio ' + ls_path, StopSign!)
			RETURN false
		end if	
	end if
	
	
	li_return = ChangeDirectory (ls_path)
	
	if li_return = -1 then
		Messagebox('Aviso','Fallo, NO SE PUDO CAMBIAR de Directorio ' + ls_path, StopSign!)
		RETURN false
	end if	
	
	ll_inicio = ll_found + 1
	ll_found = pos(ls_directorio, '\', ll_inicio)
loop


//Messagebox('Aviso','Creacion de directorio ' + ls_path + ' satisfactorio', StopSign!)

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
ls_nro_doc = trim(ls_nro_doc) + ltrim(ls_nro, '0')

//ll_longitud = len(trim(ls_nro))
//ll_flag = 0
//for ll_i = 1 to ll_longitud
//	ls_char = mid(ls_nro, ll_i, 1)
//	  if ls_char = '0' and ll_flag = 0 then
//	  ll_flag = 1
//	elseif ls_char <> '0' and ll_flag >= 0 then
//	  ls_nro_doc = trim(ls_nro_doc) + ls_char
//	  ll_flag = -1
//	elseif ll_flag = -1 then
//	  ls_nro_doc = trim(ls_nro_doc) + ls_char
//	  end if
//next
 
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

return string(ll_ult_nro, '00000000')
 

end function

public function string of_set_numera (string as_table_name);return this.of_set_numera(as_table_name, gs_origen, 10, false)
end function

public subroutine of_setreg (string as_entry, string as_value);
RegistrySet(is_regkey_config, as_entry, as_value)

end subroutine

public function string of_getreg (string as_entry, string as_default);String ls_regvalue

RegistryGet(is_regkey_config, as_entry, ls_regvalue)

If ls_regvalue = "" Then
	ls_regvalue = as_default
	
	this.of_setReg(as_entry, ls_regvalue)
End If

Return ls_regvalue

end function

public subroutine of_set_register (string as_entry, string as_value);
RegistrySet(is_regkey_register, as_entry, as_value)

end subroutine

public function string of_get_register (string as_entry, string as_default);String ls_regvalue

RegistryGet(is_regkey_register, as_entry, ls_regvalue)

If trim(ls_regvalue) = "" Then
	if trim(as_default) <> "" then
		ls_regvalue = as_default
	
		this.of_set_Register(as_entry, ls_regvalue)
	end if
End If

Return ls_regvalue

end function

public subroutine of_set_config (string as_entry, string as_value);
RegistrySet(is_regkey_config, as_entry, as_value)

end subroutine

public function string of_get_config (string as_entry, string as_default);String ls_regvalue

RegistryGet(is_regkey_config, as_entry, ls_regvalue)

If trim(ls_regvalue) = "" Then
	if trim(as_default) <> "" then
		ls_regvalue = as_default
	
		this.of_set_Register(as_entry, ls_regvalue)
	end if
End If

Return ls_regvalue

end function

public function string of_get_register (string as_empresa, string as_entry, string as_default) throws exception;String 		ls_regvalue, ls_regkey
Exception	ex

if trim(as_empresa) = '' then
	ex = create Exception
	ex.setMessage('Debe indicar una empresa, por favor verifique!')
	throw ex
end if

ls_regkey = is_regkey_register + "\" + as_empresa

RegistryGet(ls_regkey, as_entry, ls_regvalue)

If trim(ls_regvalue) = "" Then
	if trim(as_default) <> "" then
		ls_regvalue = as_default
	
		this.of_set_Register(as_empresa, as_entry, ls_regvalue)
	end if
End If

Return ls_regvalue

end function

public subroutine of_set_register (string as_empresa, string as_entry, string as_value) throws exception;String	ls_regkey
Exception	ex

if trim(as_empresa) = '' then
	ex = create Exception
	ex.setMessage('Debe indicar una empresa, por favor verifique!')
	throw ex
end if

ls_regkey = is_regkey_register + "\" + as_empresa

RegistrySet(ls_regkey, as_entry, as_value)

end subroutine

public function string of_left_time_to_string (decimal adc_time_left);String	ls_texto = ""
Decimal	ldc_temp

if adc_time_left = 0 then return ""

ls_texto = ""

//Calculo los días
ldc_temp = Truncate(adc_time_left / (24 * 60 * 60), 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " dias "
	adc_time_left = adc_time_left - ldc_temp * 24 * 60 * 60
end if

//Calculo las horas
ldc_temp = Truncate(adc_time_left / (60 * 60), 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " hrs. "
	adc_time_left = adc_time_left - ldc_temp * 60 * 60
end if

//Calculo los minutos
ldc_temp = Truncate(adc_time_left / 60, 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " min. "
	adc_time_left = adc_time_left - ldc_temp * 60
end if

//Calculo los segundos
ldc_temp = adc_time_left

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00.00000') + " seg. "
	adc_time_left = adc_time_left - ldc_temp
end if

if len(trim(ls_texto)) > 0 then
	ls_texto = "Quedan " + ls_texto
end if

return ls_texto



end function

public function string of_10tobase (unsignedlong al_number10, integer ai_base);string 	ls_rem, ls_num 
integer 	li_rem 

ls_num = ''
DO 
	li_rem = Mod(al_number10, ai_base) 
	
	if li_rem <= 9 then 
		ls_rem = string(li_rem) 
	else 
		ls_rem = Char(55+li_rem) 
	end if 
	ls_num 		= ls_rem + ls_num 
	al_number10 = al_number10 / ai_base 
	
LOOP UNTIL al_number10 = 0 

return ls_num 

end function

public function ulong uf_baseto10 (string as_number, integer ai_base);integer 			li_i, li_max 
unsignedlong 	ll_return, ll_num 
string 			ls_char 

as_number 	= Upper(as_number) 
li_max 		= Len(as_number) 

for li_i = li_max to 1 step -1 
	ls_char = Mid(as_number, li_i, 1) 
	if IsNumber(ls_char) then 
		ll_num = integer(ls_char) 
	else 
		ll_num = Asc(ls_char) - 55 
	end if 
	ll_num 	*= ai_base ^ (li_max - li_i) 
	ll_return += ll_num 
next

return ll_return 
end function

public function string of_long2hex (unsignedlong al_number);return this.of_10tobase( al_number, 16 )
end function

public function string of_get_juliano (date ad_fecha);Date 		ld_inicio_year
Integer	li_year
String	ls_dia_juliano

if IsNull(ad_fecha) then return gnvo_app.is_null

li_year = year(ad_fecha)
ld_inicio_year = Date('01/01/' + trim(string(li_year, '0000')))

ls_dia_juliano = string(DaysAfter(ld_inicio_year, ad_fecha) + 1, '000')

return ls_dia_juliano
end function

public function integer of_modelo_factura ();//Solicita si es impresión directa o previsualización
str_parametros lstr_param

Open(w_choise_factura_comercial)
lstr_param = Message.PowerObjectParm

return lstr_param.i_return

end function

public function string ltrim (string as_cadena, string as_caracter);String 	ls_cadena
Long		ll_longitud, ll_pos, ll_i

ls_cadena = as_cadena
ll_longitud = len(as_caracter)

if len(ls_cadena) <= ll_longitud then return ls_cadena

do
	if mid(ls_cadena, 1, ll_longitud) = as_caracter then
		ls_cadena = mid(ls_cadena, 1 + ll_longitud)
	else
		exit
	end if
loop while true

return ls_cadena
end function

public function boolean find_in_array (string as_value, string as_array[]);Boolean 	lb_return
Long		ll_items, ll_i

ll_items = UpperBound(as_array) 

//Por defecto la busqueda es false
lb_Return = false

FOR ll_i = 1 to ll_items 
	IF trim(as_array[ll_i]) = trim(as_value) then 
		lb_Return = true
		exit 
	end if
NEXT 


return lb_return
end function

public function string of_time_to_string (decimal adc_time_left);String	ls_texto = ""
Decimal	ldc_temp

if adc_time_left = 0 then return ""

ls_texto = ""

//Calculo los días
ldc_temp = Truncate(adc_time_left / (24 * 60 * 60), 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " dias "
	adc_time_left = adc_time_left - ldc_temp * 24 * 60 * 60
end if

//Calculo las horas
ldc_temp = Truncate(adc_time_left / (60 * 60), 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " hrs. "
	adc_time_left = adc_time_left - ldc_temp * 60 * 60
end if

//Calculo los minutos
ldc_temp = Truncate(adc_time_left / 60, 0)

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00') + " min. "
	adc_time_left = adc_time_left - ldc_temp * 60
end if

//Calculo los segundos
ldc_temp = adc_time_left

if ldc_temp > 0 then
	ls_texto += string(ldc_temp, '#,#00.00000') + " seg. "
	adc_time_left = adc_time_left - ldc_temp
end if

return ls_texto



end function

public function str_parametros of_split (string as_cadena);return this.of_split(as_cadena, ' ')
end function

public function str_ubigeo of_get_ubigeo ();str_ubigeo		lstr_ubigeo


open(w_ubigeo)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return lstr_ubigeo

lstr_ubigeo = Message.PowerObjectParm

return lstr_ubigeo
end function

public function string of_get_string (string as_titulo, string as_default_txt);String ls_texto
str_parametros lstr_param


ls_texto = ''
lstr_param.titulo = as_titulo
lstr_param.texto 	= as_default_txt


openWithParm(w_string, lstr_param)

if ISNull(Message.PowerObjectParm) or not IsValid(Message.PowerObjectParm) then return ls_texto

lstr_param = Message.PowerObjectParm

if not lstr_param.b_return then return gnvo_app.is_null

ls_texto = lstr_param.texto

return ls_texto
end function

public function string of_set_numera (string as_table_name, string as_origen, integer an_longitud, boolean ab_hex);//Numera documento
Long 		ll_ult_nro, ll_i
string	ls_mensaje, ls_next_nro

Select ult_nro 
	into :ll_ult_nro 
from num_tablas 
where tabla 	= :as_table_name
  and origen 	= :as_origen for update;

IF SQLCA.SQLCode = 100 then
	ll_ult_nro = 1
	
	Insert into num_tablas (tabla, origen, ult_nro)
		values(:as_table_name, :as_origen, 1);
	
	IF SQLCA.SQLCode < 0 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error ', 'Error al insertar registro en num_tablas. ' &
								 + '~r~nOrigen: ' + as_origen &
								 + '~r~nTable Name: ' + as_table_name &
								 + '~r~nMensaje: ' + ls_mensaje, StopSign!)
		return gnvo_app.is_null
	end if
end if

//Asigna numero a cabecera
if not ab_hex then
	ls_next_nro = TRIM(as_origen) + this.lpad(trim(string( ll_ult_nro )), an_longitud - len(trim(as_origen)), '0')
else
	ls_next_nro = TRIM(as_origen) + this.lpad(this.of_long2hex( ll_ult_nro ), an_longitud - len(trim(as_origen)), '0')
end if

//Incrementa contador
Update num_tablas 
	set ult_nro = :ll_ult_nro + 1 
 where tabla 	= :as_table_name
	and origen 	= :as_origen;

IF SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	ROLLBACK;
	MessageBox('Error', 'Error al actualizar num_tablas. Mensaje: ' + ls_mensaje, StopSign!)
	return gnvo_app.is_null
end if
	
return ls_next_nro
end function

public function string of_set_numera (string as_table_name, integer an_longitud);return this.of_set_numera(as_table_name, gs_origen, an_longitud, false)
end function

public function string of_set_numera (string as_table_name, integer an_longitud, boolean ab_hex);return this.of_set_numera(as_table_name, gs_origen, an_longitud, ab_hex)
end function

on n_cst_utilitario.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_utilitario.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

