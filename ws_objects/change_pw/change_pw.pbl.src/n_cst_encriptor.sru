$PBExportHeader$n_cst_encriptor.sru
$PBExportComments$funciones para encriptar y desencriptar datos
forward
global type n_cst_encriptor from nonvisualobject
end type
end forward

global type n_cst_encriptor from nonvisualobject
end type
global n_cst_encriptor n_cst_encriptor

type variables
String     is_original
String     is_encriptado
String     is_key='System_Key'


end variables

forward prototypes
public function string of_encriptar (string as_texto)
public function string of_desencriptar (string as_texto)
public function integer of_set_key (string as_key)
public function string of_encriptarjr (string as_texto)
public function string of_desencriptarjr (string as_texto)
end prototypes

public function string of_encriptar (string as_texto);String 	ls_work, ls_temp
Integer	li_orig, li_kind, li_klen, li_olen, li_work, li_ktemp

is_original = as_texto		// colocar argumento como valor original
li_olen = len(is_original)  // tamaño del valor original
li_klen = len(is_key)		// tamaño del key
is_encriptado = ""			// borrar valor encriptado
li_kind = 1						// inicializar indicador de key
FOR li_orig = 1 TO li_olen
	li_ktemp = asc(mid(is_key, li_kind,1))	// tomar char del key
	li_work = asc(mid(is_original, li_orig,1)) // tomar char del valor original
	li_work += li_ktemp
	DO WHILE li_work > 255	// corrige valores ASCII superiores a 255
		IF li_work > 255 THEN
			li_work = li_work - 255		// ver que el codigo ASCII de la vuelta a 1
		END IF
	LOOP
	ls_temp = char(li_work)	// conversion de codigo ASCII a char
	is_encriptado += ls_temp
	li_kind ++					// correr al siguiente char del key
	if li_kind > len(is_key) then li_kind = 1		// ver que el char del key de la vuelta
NEXT

RETURN is_encriptado
end function

public function string of_desencriptar (string as_texto);String	ls_work, ls_temp
Integer	li_orig, li_kind, li_klen, li_olen, li_work, li_ktemp

is_encriptado = as_texto   // colocar argumento como valor encriptado
li_olen = len(is_encriptado)	// longitud de valor encriptado
li_klen = len(is_key)		// logitud del key
is_original = ""				// borrar valor original
li_kind = 1						// inicializar indicador del key
FOR li_orig = 1 to li_olen
	li_ktemp = asc(mid(is_key, li_kind, 1))
	li_work = asc(mid(is_encriptado, li_orig, 1))
	li_work -= li_ktemp
	DO WHILE li_work < 0		// dar la vuelta a los valores superiores a 255
		IF li_work < 0 THEN
			li_work = li_work + 255
		END IF
	LOOP
	ls_temp = char(li_work)		// covertir codigo ASCII a caracter
	is_original += ls_temp		// sumar al resultado final
	li_kind ++						// correr al siguiente char del key
	if li_kind > len(is_key) then li_kind = 1		// dar la vuelta al char del key
NEXT

RETURN is_original
end function

public function integer of_set_key (string as_key);is_key = as_Key

Return 1


end function

public function string of_encriptarjr (string as_texto);String 	ls_work, ls_temp
Integer	li_orig, li_kind, li_klen, li_olen, li_work, li_ktemp

is_original = as_texto		// colocar argumento como valor original
li_olen = len(is_original)  // tamaño del valor original
li_klen = len(is_key)		// tamaño del key
is_encriptado = ""			// borrar valor encriptado
li_kind = 1						// inicializar indicador de key
FOR li_orig = 1 TO li_olen
	li_ktemp = asc(mid(is_key, li_kind,1))	// tomar char del key
	li_work = asc(mid(is_original, li_orig,1)) // tomar char del valor original
	li_work += li_ktemp
	DO WHILE li_work > 255	// corrige valores ASCII superiores a 255
		IF li_work > 255 THEN
			li_work = li_work - 255		// ver que el codigo ASCII de la vuelta a 1
		END IF
	LOOP
	ls_temp = string(li_work, '000')	// lo grabo como una sucesion de numeros
	is_encriptado += ls_temp
	li_kind ++					// correr al siguiente char del key
	if li_kind > len(is_key) then li_kind = 1		// ver que el char del key de la vuelta
NEXT

RETURN is_encriptado
end function

public function string of_desencriptarjr (string as_texto);String	ls_work, ls_temp
Integer	li_orig, li_kind, li_klen, li_olen, li_work, li_ktemp


is_encriptado = as_texto   // colocar argumento como valor encriptado
li_olen = len(is_encriptado)	// longitud de valor encriptado
li_klen = len(is_key)		// logitud del key
is_original = ""				// borrar valor original
li_kind = 1						// inicializar indicador del key
FOR li_orig = 1 to li_olen step 3
	li_ktemp = asc(mid(is_key, li_kind, 1))
	li_work = integer(mid(is_encriptado, li_orig, 3))
	li_work -= li_ktemp
	DO WHILE li_work < 0		// dar la vuelta a los valores superiores a 255
		IF li_work < 0 THEN
			li_work = li_work + 255
		END IF
	LOOP
	ls_temp = char(li_work)		// covertir codigo ASCII a caracter
	is_original += ls_temp		// sumar al resultado final
	li_kind ++						// correr al siguiente char del key
	if li_kind > len(is_key) then li_kind = 1		// dar la vuelta al char del key
NEXT

RETURN is_original
end function

on n_cst_encriptor.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_encriptor.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;is_key = of_encriptar(is_key)
end event

