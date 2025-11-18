$PBExportHeader$n_cst_numlet_lg.sru
$PBExportComments$Convierte numeros a literales
forward
global type n_cst_numlet_lg from nonvisualobject
end type
end forward

global type n_cst_numlet_lg from nonvisualobject
end type
global n_cst_numlet_lg n_cst_numlet_lg

forward prototypes
public function string of_numlet0 (string as_numero)
public function string of_numlet2d (string as_numero)
public function string of_numlet3d (string as_numero)
public function string of_numfechlar (date ad_fecha)
public function string of_numlet100 (string as_numero)
public function string of_numlet10 (string as_numero)
public function string of_numfech (date ad_fecha)
public function integer of_check_separador ()
public function string of_numlet (string as_numero)
end prototypes

public function string of_numlet0 (string as_numero);String ls_resultado
Integer li_numero

li_numero = Integer(as_numero)

CHOOSE CASE li_numero
	CASE 0
		ls_resultado = ""
	CASE 1
		ls_resultado = "UN"
	CASE 2
		ls_resultado = "DOS"
	CASE 3
		ls_resultado = "TRES"
	CASE 4
		ls_resultado = "CUATRO"
	CASE 5
		ls_resultado = "CINCO"
	CASE 6
		ls_resultado = "SEIS"
	CASE 7
		ls_resultado = "SIETE"
	CASE 8
		ls_resultado = "OCHO"
	CASE 9
		ls_resultado = "NUEVE"
END CHOOSE

RETURN ls_resultado
	
end function

public function string of_numlet2d (string as_numero);String ls_resultado
Integer li_len

li_len = Len(as_numero)

CHOOSE CASE li_len
   CASE 1
      ls_resultado = of_numlet0(as_numero)
   CASE 2
      ls_resultado = of_numlet10(as_numero)      
END CHOOSE
   
RETURN ls_resultado
end function

public function string of_numlet3d (string as_numero);String ls_resultado
Integer li_len

li_len = Len(as_numero)

CHOOSE CASE li_len
   CASE 1
      ls_resultado = of_numlet0(as_numero)
   CASE 2
      ls_resultado = of_numlet10(as_numero)      
   CASE 3
      ls_resultado = of_numlet100(as_numero)       
END CHOOSE
   
RETURN ls_resultado
end function

public function string of_numfechlar (date ad_fecha);String	ls_fecha, ls_mes, ls_dia, ls_year, ls_de, ls_temp
Integer	li_mes, li_pos, li_len
Decimal	ldc_dia, ldc_year

li_mes = Month(ad_fecha)
ldc_dia = DAY(ad_fecha)
ldc_year = Year(ad_fecha)

// convertir mes
CHOOSE CASE li_mes
	CASE 1
		ls_mes = 'Enero'
	CASE 2
		ls_mes = 'Febrero'
	CASE 3
		ls_mes = 'Marzo'
	CASE 4
		ls_mes = 'Abril'
	CASE 5
		ls_mes = 'Mayo'
	CASE 6
		ls_mes = 'Junio'
	CASE 7
		ls_mes = 'Julio'
	CASE 8
		ls_mes = 'Agosto'
	CASE 9
		ls_mes = 'Septiembre'
	CASE 10
		ls_mes = 'Octubre'
	CASE 11
		ls_mes = 'Noviembre'
	CASE 12
		ls_mes = 'Diciembre'
	CASE ELSE
		ls_fecha = 'Error'
		GOTO SALIDA
END CHOOSE
	
// convertir dia
ls_dia = String(ldc_dia) + '.00'
ls_dia = of_numlet(ls_dia)
li_pos = POS(ls_dia, ' y') 
li_len = Len(ls_dia)
ls_dia = Left(ls_dia, li_pos -1)
IF Right(ls_dia, 2) = 'UN' THEN ls_dia = ls_dia + 'O'
	
// convertir año
ls_year = of_numlet(String(ldc_year) + '.00')
li_pos = POS(ls_year, ' y')
li_len = Len(ls_year)
ls_year = Left(ls_year, li_pos -1)
IF Right(ls_year, 2) = 'UN' THEN ls_year = ls_year + 'O'

IF ldc_year >= 2000 THEN
	ls_de = ' DEL '
ELSE
	ls_de = ' DE '
END IF

ls_fecha = ls_dia + ' DE ' + upper(ls_mes) + ls_de + ls_year

SALIDA:
RETURN ls_fecha



end function

public function string of_numlet100 (string as_numero);String ls_resultado, ls_digito10
Integer li_numero

ls_digito10 = Right(as_numero,2)
ls_digito10 = String(Integer(ls_digito10))
li_numero = Integer(as_numero)

CHOOSE CASE li_numero
	CASE 100
		ls_resultado = "CIEN"
	CASE 101 TO 199
		ls_resultado = "CIENTO " + of_numlet2d(ls_digito10)
	CASE 200
		ls_resultado = "DOSCIENTOS"
	CASE 201 TO 299
		ls_resultado = "DOSCIENTOS " + of_numlet2d(ls_digito10)
	CASE 300
		ls_resultado = "TRESCIENTOS "
	CASE 301 TO 399
		ls_resultado = "TRESCIENTOS " + of_numlet2d(ls_digito10)
	CASE 400
		ls_resultado = "CUATROCIENTOS "

	CASE 401 TO 499
		ls_resultado = "CUATROCIENTOS " + of_numlet2d(ls_digito10)
	CASE 500
		ls_resultado = "QUINIENTOS"
	CASE 501 TO 599
		ls_resultado = "QUINIENTOS " + of_numlet2d(ls_digito10)
	CASE 600
		ls_resultado = "SEISCIENTOS"
	CASE 601 TO 699
		ls_resultado = "SEISCIENTOS " + of_numlet2d(ls_digito10)
	CASE 700
		ls_resultado = "SETECIENTOS"
	CASE 701 TO 799
		ls_resultado = "SETECIENTOS " + of_numlet2d(ls_digito10)
	CASE 800
		ls_resultado = "OCHOCIENTOS"
	CASE 801 TO 899
		ls_resultado = "OCHOCIENTOS " + of_numlet2d(ls_digito10)
	CASE 900
		ls_resultado = "NOVECIENTOS"
	CASE 901 TO 999
		ls_resultado = "NOVECIENTOS " + of_numlet2d(ls_digito10)
END CHOOSE

RETURN ls_resultado
	
end function

public function string of_numlet10 (string as_numero);String ls_resultado, ls_digito
Integer li_numero

ls_digito = RIGHT(as_numero,1)
li_numero = Integer(as_numero)

CHOOSE CASE li_numero
	CASE 10
		ls_resultado = "DIEZ"
	CASE 11
		ls_resultado = "ONCE"
	CASE 12
		ls_resultado = "DOCE"
	CASE 13
		ls_resultado = "TRECE"
	CASE 14
		ls_resultado = "CATORCE"
	CASE 15
		ls_resultado = "QUINCE"
	CASE 16 TO 19
		ls_resultado = "DIECI" + of_numlet0(ls_digito)
	CASE 20
		ls_resultado = "VEINTE"
	CASE 21 TO 29
		ls_resultado = "VEINTI" + of_numlet0(ls_digito)
	CASE 30
		ls_resultado = "TREINTA"
	CASE 31 TO 39
		ls_resultado = "TREINTI" + of_numlet0(ls_digito)	
	CASE 40
		ls_resultado = "CUARENTA"
	CASE 41 TO 49
		ls_resultado = "CUARENTAI" + of_numlet0(ls_digito)
	CASE 50
		ls_resultado = "CINCUENTA"
	CASE 51 TO 59
		ls_resultado = "CINCUENTAI" + of_numlet0(ls_digito)
	CASE 60
		ls_resultado = "SESENTA"
	CASE 61 TO 69
		ls_resultado = "SESENTAI" + of_numlet0(ls_digito)
	CASE 70
		ls_resultado = "SETENTA"
	CASE 71 TO 79
		ls_resultado = "SETENTAI" + of_numlet0(ls_digito)
	CASE 80
		ls_resultado = "OCHENTA"
	CASE 81 TO 89
		ls_resultado = "OCHENTAI" + of_numlet0(ls_digito)
	CASE 90
		ls_resultado = "NOVENTA"
	CASE 91 TO 99
		ls_resultado = "NOVENTAI" + of_numlet0(ls_digito)
END CHOOSE

RETURN ls_resultado
	
end function

public function string of_numfech (date ad_fecha);String	ls_fecha, ls_mes
Integer	li_mes, li_dia, li_ano

li_mes = Month(ad_fecha)
li_dia = DAY(ad_fecha)
li_ano = Year(ad_fecha)

CHOOSE CASE li_mes
	CASE 1
		ls_mes = 'Enero'
	CASE 2
		ls_mes = 'Febrero'
	CASE 3
		ls_mes = 'Marzo'
	CASE 4
		ls_mes = 'Abril'
	CASE 5
		ls_mes = 'Mayo'
	CASE 6
		ls_mes = 'Junio'
	CASE 7
		ls_mes = 'Julio'
	CASE 8
		ls_mes = 'Agosto'
	CASE 9
		ls_mes = 'Septiembre'
	CASE 10
		ls_mes = 'Octubre'
	CASE 11
		ls_mes = 'Noviembre'
	CASE 12
		ls_mes = 'Diciembre'
	CASE ELSE
		ls_fecha = 'Error'
		GOTO SALIDA
END CHOOSE
	
ls_fecha = String(li_dia) + ' de ' + ls_mes + ' de ' + String(li_ano)
	
SALIDA:
RETURN ls_fecha
end function

public function integer of_check_separador ();Integer 	li_rc = 0
Real		lr_test
String	ls_test, ls_separador

lr_test = (3/2) -1

ls_test = String(lr_test)

ls_separador = Left(ls_test,1)

IF ls_separador <> '.' THEN
	li_rc = -1
	MessageBox('Error', 'Error en Configuracion de Separador de Decimales = ' + ls_separador)
END IF





RETURN li_rc

end function

public function string of_numlet (string as_numero);String ls_resultado, ls_result1, ls_result2, ls_result3
String ls_millon, ls_mil, ls_resto, ls_entero, ls_dec
Integer li_punto, li_len, li_len_numero

as_numero = String(Round(Dec(as_numero), 2))
li_len_numero = Len(as_numero)
li_punto = POS(as_numero,".")

IF li_punto = 0 THEN
	as_numero = as_numero + '.00'
	li_punto = li_len_numero + 1
	li_len_numero = Len(as_numero)
ELSE
	IF li_punto = li_len_numero THEN
		as_numero = as_numero + '00'
		li_len_numero = Len(as_numero)
	ELSE
		IF li_punto = li_len_numero - 1 THEN
			as_numero = as_numero + '0'
			li_len_numero = Len(as_numero)
		END IF
	END IF
END IF

ls_dec = " y " + Mid(as_numero, li_punto + 1) + "/100"
ls_entero = Mid(as_numero,1, li_punto - 1)
ls_entero = STRING(DEC(ls_entero))
li_len = Len(ls_entero)

CHOOSE CASE li_len
   CASE 1 TO 3
      ls_resultado = of_numlet3d(ls_entero)
   CASE 4 TO 6
		ls_mil = LEFT(ls_entero,li_len - 3)
		ls_resto = RIGHT(ls_entero,3)
		ls_resto = String(Integer(ls_resto))
		IF Integer(ls_mil) = 1 THEN
			ls_result1 = "UN"
		ELSE
			ls_result1 = of_numlet3d(ls_mil)
		END IF
		ls_resultado = ls_result1 + " MIL " + of_numlet3d(ls_resto)
	CASE 7 TO 9
		ls_millon = LEFT(ls_entero,li_len - 6)
		ls_mil = MID(ls_entero,li_len - 5,3)
		ls_mil = String(Integer(ls_mil))
		ls_resto = RIGHT(ls_entero,3)
		ls_resto = String(Integer(ls_resto))
		IF Integer(ls_millon) = 1 THEN
			ls_result1 = "UN MILLON "
		ELSE
			ls_result1 = of_numlet3d(ls_millon) + " MILLONES "
		END IF
		IF ls_mil = "0" THEN
			ls_result2 = ""
		ELSE
			ls_result2 = of_numlet3d(ls_mil) + " MIL "
		END IF
	  	ls_resultado = ls_result1 + ls_result2 + of_numlet3d(ls_resto)
END CHOOSE
   
RETURN ls_resultado + ls_dec
end function

on n_cst_numlet_lg.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_numlet_lg.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

