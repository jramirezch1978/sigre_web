$PBExportHeader$uo_configuracion_regional.sru
forward
global type uo_configuracion_regional from nonvisualobject
end type
type str_valores from structure within uo_configuracion_regional
end type
end forward

type str_valores from structure
	string		sdecimal
	string		idigits
	string		sthousand
	string		slist
	string		smondecimalsep
	string		icurrdigits
	string		smonthousandsep
	string		sshortdate
	string		slongdate
end type

global type uo_configuracion_regional from nonvisualobject
end type
global uo_configuracion_regional uo_configuracion_regional

type variables
private:
str_valores istr_val
boolean lb_cambio
end variables

forward prototypes
public function integer of_getvalores ()
public function integer of_setvalores ()
public function integer of_setvalores_anteriores ()
end prototypes

public function integer of_getvalores ();/* Funcion que captura los valores de la configuracion regional antes de entrar al sistema.*/


string ls_sepa_dec,ls_sepa_mil,ls_cantdec,ls_seplis,ls_mon_sepa_dec,ls_mon_sepa_mil
string ls_mon_cantdec,ls_fechacorta,ls_fechalarga
int li_res = 1
//capturo el valor de separador decimal
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sDecimal", ls_sepa_dec) = -1 then 
	setnull(ls_sepa_dec)
	li_res = -1
end if
//capturo el valor de cantidad de decimales
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","iDigits", ls_cantdec) = -1 then 
	setnull(ls_cantdec)
	li_res = -1
end if
//capturo el valor de separador de miles
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sThousand", ls_sepa_mil) = -1 then 
	setnull(ls_sepa_mil)
	li_res = -1
end if
//capturo el valor de separador de listas
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sList", ls_seplis) = -1 then 
	setnull(ls_seplis)
	li_res = -1
end if
//capturo el valor de separador decimal de moneda
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sMonDecimalSep", ls_mon_sepa_dec) = -1 then 
	setnull(ls_mon_sepa_dec)
	li_res = -1
end if
//capturo el valor de la cantidad de digitos de la moneda
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","iCurrDigits", ls_mon_cantdec) = -1 then 
	setnull(ls_mon_cantdec)
	li_res = -1
end if
//capturo el valor de separador de miles de la moneda
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sMonThousandSep", ls_mon_sepa_mil) = -1 then 
	setnull(ls_mon_sepa_mil)
	li_res = -1
end if
//capturo el valor de la fecha corta
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sShortDate", ls_fechacorta) = -1 then 
	setnull(ls_fechacorta)
	li_res = -1
end if
//capturo el valor de la fecha larga
if RegistryGet( "HKEY_CURRENT_USER\Control Panel\International","sLongDate", ls_fechalarga) = -1 then 
	setnull(ls_fechalarga)
	li_res = -1
end if

istr_val.sDecimal = ls_sepa_dec
istr_val.iDigits = ls_cantdec
istr_val.sThousand = ls_sepa_mil
istr_val.sList = ls_seplis
istr_val.sMonDecimalSep = ls_mon_sepa_dec
istr_val.iCurrDigits = ls_mon_cantdec
istr_val.sMonThousandSep = ls_mon_sepa_mil
istr_val.sShortDate = ls_fechacorta
istr_val.sLongDate = ls_fechalarga
return li_res
end function

public function integer of_setvalores ();/* 
Función que setea los valores de la configuración regional a los que necesita el sistema:
	Separador decimal de numeros y moneda: 		'.'
	Separador de miles de numeros y de moneda: 	','
	Separador de listas de numero: 					'.'
	Formato de fecha corta:								dd/MM/yyyy
	Formato de fecha larga:								dddd, dd' de 'MMMM' de 'yyyy 
*/ 
string ls_sepa_dec,ls_sepa_mil,ls_cantdec,ls_seplis,ls_mon_sepa_dec,ls_mon_sepa_mil
string ls_mon_cantdec,ls_fechacorta,ls_fechalarga
int li_return = 1
/*
	Antes de cambiar verifica que el valor no este setada ya como lo necesita, en ese caso no
	hace nada. En el caso de hacer algun cambio setea lb_cambio = true, para que al salir
	restaure los valores que estaban en la maquina previo a abrir el sistema
*/

if ls_sepa_dec <> '.' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sDecimal", '.') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador decimal')
		li_return =  -1
	else 
		lb_cambio = true
	end if
end if

if ls_cantdec <> '2' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","iDigits", '2') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar la Cantidad de decimales')
		li_return =  -1
	else
		lb_cambio = true
	end if
end if

if ls_sepa_mil <> ',' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sThousand", ',') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de miles')
		li_return =  -1
	else
		lb_cambio = true
	end if
end if

if ls_seplis <> '.' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sList", '.') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de lista')
		li_return =  -1
	else
		lb_cambio = true	
	end if
end if

if ls_mon_sepa_dec <> '.' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sMonDecimalSep", '.') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de decimal'&
		+'de la moneda')
		li_return =  -1
	else
		lb_cambio = true
	end if
end if 

if ls_mon_cantdec <> '2' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","iCurrDigits", '2') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar la cantidad de decimales'&
		+'de la moneda')
		li_return =  -1
	else
		lb_cambio = true	
	end if
end if

if ls_mon_sepa_mil <> ',' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sMonThousandSep", ',') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de miles'&
		+'de la moneda')
		li_return =  -1
	else
		lb_cambio = true	
	end if
end if 

if ls_fechacorta <> 'dd/MM/yyyy' then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sShortDate", 'dd/MM/yyyy') = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el formato de fecha corta')
		li_return =  -1
	else
		lb_cambio = true	
	end if
end if

if ls_fechalarga <> "dddd, dd' de 'MMMM' de 'yyyy" then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sLongDate", "dddd, dd' de 'MMMM' de 'yyyy") = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el formato de fecha larga')
		li_return =  -1
	else
		lb_cambio = true	
	end if
end if


return li_return
end function

public function integer of_setvalores_anteriores ();/* 
	Función que restaura los valores de la configuracion regional 
	que estaban en la maquina previo a la apertura del sistema
*/

string ls_sepa_dec,ls_sepa_mil,ls_cantdec,ls_seplis,ls_mon_sepa_dec,ls_mon_sepa_mil
string ls_mon_cantdec,ls_fechacorta,ls_fechalarga
int li_return = 1
ls_sepa_dec = istr_val.sDecimal//Separador decimal
ls_cantdec = istr_val.iDigits//cantidad de decimales
ls_sepa_mil =istr_val.sThousand  //separador de miles
ls_seplis = istr_val.sList //separador de listas
ls_mon_sepa_dec = istr_val.sMonDecimalSep //separador decimal de moneda
ls_mon_cantdec = istr_val.iCurrDigits//cantidad de decimales de moneda
ls_mon_sepa_mil = istr_val.sMonThousandSep //separador de miles de moneda
ls_fechacorta = istr_val.sShortDate //formato de fecha corta
ls_fechalarga = istr_val.sLongDate //formato de fecha larga
/*
	Siempre chequea si hubo algun cambio (lb_cambio = true) 
	para determinar si tiene que 
	restaurar los valores a como estaban antes
*/

if lb_cambio then
	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sDecimal", ls_sepa_dec) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador decimal')
		li_return =  -1
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","iDigits", ls_cantdec) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar la Cantidad de decimales')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sThousand", ls_sepa_mil) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de miles')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sList", ls_seplis) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de lista')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sMonDecimalSep", ls_mon_sepa_dec) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de decimal'&
		+'de la moneda')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","iCurrDigits", ls_mon_cantdec) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar la cantidad de decimales'&
		+'de la moneda')
		li_return = -1
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sMonThousandSep", ls_mon_sepa_mil) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el separador de miles'&
		+'de la moneda')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sShortDate", ls_fechacorta) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el formato de fecha corta')
		li_return = -1
	
	end if


	if Registryset( "HKEY_CURRENT_USER\Control Panel\International","sLongDate", ls_fechalarga) = -1 then 
		messagebox('Error al Cambiar Cambiar Configuración Regional','Error al Tratar de cambiar el formato de fecha larga')
		li_return = -1
		
	end if

end if

return li_return
end function

on uo_configuracion_regional.create
call super::create
TriggerEvent( this, "constructor" )
end on

on uo_configuracion_regional.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

