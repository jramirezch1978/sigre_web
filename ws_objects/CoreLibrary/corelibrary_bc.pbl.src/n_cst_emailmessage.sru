$PBExportHeader$n_cst_emailmessage.sru
forward
global type n_cst_emailmessage from nonvisualobject
end type
end forward

global type n_cst_emailmessage from nonvisualobject autoinstantiate
end type

type variables
string		is_to_Address [], is_from_address[], is_body, is_subject, is_attachment[]

str_emails	istr_email_to[], istr_email_from, istr_email_bcc[]
n_smtp		invo_smtp
end variables

forward prototypes
public function boolean of_add_email_to (string as_nombre, string as_email)
public function boolean of_add_emails_from_string (string as_cadena)
public function boolean of_set_body (string as_body)
public function boolean of_set_subject (string as_subject)
public function boolean of_add_attach (string as_filename)
public function boolean of_add_email_bcc (string as_nombre, string as_email)
public function boolean of_add_emails_client_from_string (string as_nom_cliente, string as_cadena) throws exception
end prototypes

public function boolean of_add_email_to (string as_nombre, string as_email);long ll_len

ll_len = upperBound(this.istr_email_to)

this.istr_email_to[ll_len + 1].nombre 	= as_nombre
this.istr_email_to[ll_len + 1].email 	= as_email

return true
end function

public function boolean of_add_emails_from_string (string as_cadena);Long		ll_pos, ll_inicio, ll_pos_separador
String 	ls_cadena, ls_email, ls_nombre, ls_sub_cadena

ls_cadena = trim(as_cadena)

if len(ls_cadena) <= 1 then return true

ll_inicio = 1
ll_pos = Pos(ls_cadena, ';', ll_inicio)

//Si los emails no estan separados por ';' entonces no tiene la esctructura de nombre, email; 
//sino email1, email2, email3
if ll_pos = 0 then
	ll_pos = Pos(ls_cadena, ',', ll_inicio)
	
	//Si no hay comas, y si la cadena no es vacía lo unico que me queda es que sea un solo email
	if ll_pos = 0 then 
		ll_pos = Pos(ls_cadena, '@', ll_inicio)
		
		//Si no tiene el @ entonces definitivamenta no es una cadena valida
		if ll_pos = 0 then
			MessageBox('Error', 'La cadena ingresada ' + ls_cadena + ' no es un email valido', StopSign!)
			return false
		
		end if
		
		//de lo contrario entonce es un email y lo agrego
		this.of_add_email_bcc(ls_cadena, ls_cadena)
		
	else
		
		//Si hay comas (,) sin las separaciones (;) entonces son full correos, asi que los saco uno por uno
		do while ll_pos > 0 
			
			ls_email = trim(mid(ls_cadena, ll_inicio, ll_pos - ll_inicio))
			
			if len(ls_email) = 0 then
				MessageBox('Error', 'La cadena ' + ls_cadena + ' tiene un email vacia en la posición ' + string(ll_inicio) &
										+ '. Por favor verifique y corrija!', StopSign!)
				return false
			end if
			
			if pos(ls_email, '@') = 0 then
				MessageBox('Error', 'La cadena ' + ls_cadena + ' tiene un email INVALIDO en la posición ' + string(ll_inicio) &
										+ '. Por favor verifique y corrija!', StopSign!)
				return false
			end if

			this.of_add_email_bcc(ls_email, ls_email)
			
			ll_inicio = ll_pos + 1
			ll_pos = Pos(ls_cadena, ',', ll_inicio)
		loop
		
		//la ultima cadena si es mayor que cero y es valido lo adiciono
		ls_email = trim(mid(ls_cadena, ll_inicio))
		
		if len(ls_email) > 0 then
			if pos(ls_email, '@') = 0 then
				MessageBox('Error', 'La cadena ' + ls_cadena + ' tiene un email INVALIDO en la ultima posición ' + string(ll_inicio) &
										+ '. Por favor verifique y corrija!', StopSign!)
				return false
			end if
		end if
		
		this.of_add_email_bcc(ls_email, ls_email)
	end if
else
	//Si hay separaciones (;) entonces son listados de nombres, correos;
	do while ll_pos > 0 
		
		ls_sub_cadena = trim(mid(ls_cadena, ll_inicio, ll_pos - ll_inicio))
		
		if len(ls_sub_cadena) = 0 then
			MessageBox('Error', 'La cadena ' + ls_cadena + ' tiene un subcadena vacía en la posición ' + string(ll_inicio) &
									+ '. Por favor verifique y corrija!', StopSign!)
			return false
		end if
		
		//Ahora separo el nombre y el email
		ll_pos_separador = pos(ls_sub_cadena, ',') 
		
		if ll_pos_separador = 0 then
			MessageBox('Error', 'La subcadena ' + ls_sub_cadena + ' no tiene una estructura valida de nombre, email.' &
									+ ' Por favor verifique y corrija!', StopSign!)
			return false
		end if
		
		ls_nombre 	= trim(mid(ls_sub_cadena, 1, ll_pos_Separador - 1))
		ls_email 	= trim(mid(ls_sub_cadena, ll_pos_Separador + 1))
		
		if pos(ls_email, '@') = 0 then
			MessageBox('Error', 'La subcadena ' + ls_sub_cadena + ' tiene un email INVALIDO en la posición ' + string(ll_pos_Separador) &
									+ '. Por favor verifique y corrija!', StopSign!)
			return false
		end if
		
		this.of_add_email_bcc(ls_nombre, ls_email)
		
		ll_inicio = ll_pos + 1
		ll_pos = Pos(ls_cadena, ';', ll_inicio)
	loop
	
	//la ultima cadena si es mayor que cero y es valido lo adiciono
	ls_sub_cadena = trim(mid(ls_cadena, ll_inicio))
	
	if len(ls_sub_cadena) > 0 then
		ll_pos_separador = pos(ls_sub_cadena, ',') 
		
		if ll_pos_separador = 0 then
			MessageBox('Error', 'La ultima subcadena ' + ls_cadena + ' no tiene una estructura valida de nombre, email.'  &
									+ ' Por favor verifique y corrija!', StopSign!)
			return false
		end if
		ls_nombre 	= trim(mid(ls_sub_cadena, 1, ll_pos_Separador - 1))
		ls_email 	= trim(mid(ls_sub_cadena, ll_pos_Separador + 1))
		
		if pos(ls_email, '@') = 0 then
			MessageBox('Error', 'La subcadena ' + ls_sub_cadena + ' tiene un email INVALIDO en la posición ' + string(ll_pos_Separador) &
									+ '. Por favor verifique y corrija!', StopSign!)
			return false
		end if
			
	
		this.of_add_email_bcc(ls_nombre, ls_email)

	end if
	

end if

end function

public function boolean of_set_body (string as_body);this.is_body = as_body
return true
end function

public function boolean of_set_subject (string as_subject);this.is_subject = as_subject
return true
end function

public function boolean of_add_attach (string as_filename);long ll_len

if not FileExists(as_filename) then
	MessageBox('Error', 'Archivo ' + as_filename + ' no existe. Por favor verifique!', StopSign!)
	return false
end if

ll_len = upperBound(this.is_attachment)

this.is_attachment[ll_len + 1] 	= as_filename


return true
end function

public function boolean of_add_email_bcc (string as_nombre, string as_email);long ll_len

ll_len = upperBound(this.istr_email_bcc)

this.istr_email_bcc[ll_len + 1].nombre 	= as_nombre
this.istr_email_bcc[ll_len + 1].email 	= as_email

return true
end function

public function boolean of_add_emails_client_from_string (string as_nom_cliente, string as_cadena) throws exception;Long			ll_pos, ll_inicio, ll_pos_separador
String 		ls_cadena, ls_email, ls_nombre, ls_separador, ls_sub_cadena, ls_mensaje
Exception	ex

ls_cadena = trim(as_cadena)

if len(ls_cadena) <= 1 then return true

//Los email del cliente estan separados por / o por un ;

ll_inicio = 1
ll_pos = Pos(ls_cadena, ';', ll_inicio)

if ll_pos = 0 then
	ll_pos = Pos(ls_cadena, '/', ll_inicio)
	
	if ll_pos = 0 then
		ex = create Exception
		Ex.setMessage('La cadena ingresada ' + ls_cadena + ' no tiene un separador valido [;] or [/]')
		throw ex
		return false
	else
		ls_separador = '/'
	end if
else
	ls_separador = ';'
end if

ll_inicio = 1

do while ll_pos > 0
	
	//Obtengo la subcadena
	ls_sub_cadena = trim(mid(ls_cadena, ll_inicio, ll_pos - ll_inicio))
		
	if len(ls_sub_cadena) = 0 then
		ex = create Exception
		Ex.setMessage('La cadena ' + ls_cadena + ' tiene un subcadena vacía en la posición ' + string(ll_inicio) &
								+ '. Por favor verifique y corrija!')
		throw ex
		return false
	end if
	
	if not invo_smtp.of_ValidEmail(ls_sub_cadena, ls_mensaje) then
		ex = create Exception
		Ex.setMessage('Error al validar la subcadena ' + ls_sub_cadena + ' como email: ' + ls_mensaje)
		throw ex
		return false
	end if
		
	this.of_add_email_to(as_nom_cliente, ls_sub_Cadena)
		
	ll_inicio = ll_pos + 1
	ll_pos = Pos(ls_cadena, ls_separador, ll_inicio)
loop
	
//la ultima cadena si es mayor que cero y es valido lo adiciono
ls_sub_cadena = trim(mid(ls_cadena, ll_inicio))
	
if len(ls_sub_cadena) > 0 then
	
	if not invo_smtp.of_ValidEmail(ls_sub_cadena, ls_mensaje) then
		ex = create Exception
		Ex.setMessage('Error al validar la subcadena ' + ls_sub_cadena + ' como email: ' + ls_mensaje)
		throw ex
		return false
	end if
			
	this.of_add_email_to(as_nom_cliente, ls_sub_cadena)

end if
	

end function

on n_cst_emailmessage.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_emailmessage.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

