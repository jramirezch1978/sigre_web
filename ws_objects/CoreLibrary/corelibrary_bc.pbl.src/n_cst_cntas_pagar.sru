$PBExportHeader$n_cst_cntas_pagar.sru
forward
global type n_cst_cntas_pagar from nonvisualobject
end type
end forward

global type n_cst_cntas_pagar from nonvisualobject
end type
global n_cst_cntas_pagar n_cst_cntas_pagar

type variables
n_cst_utilitario 	invo_utility
n_cst_Wait			invo_wait
n_smtp				invo_smtp
n_cst_serversmtp	invo_email
end variables

forward prototypes
public function boolean of_validar_doc (u_dw_abc adw_master)
public function boolean of_validar_doc (string asi_proveedor, string asi_tipo_doc, string asi_serie, string asi_numero)
public function string of_get_nro_doc (string asi_proveedor, string asi_tipo_doc, string asi_serie, string asi_numero) throws exception
public function boolean of_enviar_email (string as_cod_relacion, string as_tipo_doc, string as_nro_doc)
end prototypes

public function boolean of_validar_doc (u_dw_abc adw_master);Integer 	li_count
DateTime	ldt_fecha
String	ls_usuario, ls_proveedor, ls_tipo_doc, ls_serie, ls_numero

//Si no hay registros en el maestro, entonces devuelvo que esta correcto
if adw_master.RowCount() = 0 then return true

ls_proveedor 	= adw_master.object.cod_relacion [1] 
ls_tipo_doc 	= adw_master.object.tipo_doc 		[1] 
ls_serie 		= adw_master.object.serie_cp 		[1] 
ls_numero 		= adw_master.object.numero_cp 	[1] 

//Si alguno de los datos esta pendiente se retorna como valido, porque no se puede comparar
if IsNull(ls_proveedor) or ISNull(ls_tipo_Doc) or IsNull(ls_serie) or ISNull(ls_numero) or &
	trim(ls_proveedor) = '' or trim(ls_tipo_doc) = '' or trim(ls_serie) = '' or trim(ls_numero) = '' then return true

//Valido el documento, si existe o no existe
select count(*)
	into :li_count
from cntas_pagar cp
where cp.cod_relacion 	= :ls_proveedor
  and cp.tipo_doc			= :ls_tipo_doc
  and cp.serie_cp			= :ls_serie	
  and cp.numero_cp		= :ls_numero;

if li_count > 0 then
	select cp.fecha_registro, u.nombre
		into :li_count, :ls_usuario
	from 	cntas_pagar cp,
			usuario		u
	where cp.cod_usr			= u.cod_usr		(+)
	  and cp.cod_relacion 	= :ls_proveedor
  	  and cp.tipo_doc			= :ls_tipo_doc
  	  and cp.serie_cp			= :ls_serie	
  	  and cp.numero_cp		= :ls_numero;

	gnvo_app.of_mensaje_error( "El documento ya ha sido registrado por el usuario " + trim(ls_usuario) + " el día " + string(ldt_fecha, 'dd/mm/yyyy hh24:mi:ss') + ". Por favor verifique!" &
							+ "~r~nProveedor: " + ls_proveedor &
							+ "~r~Tipo Documento: " + ls_tipo_doc &
							+ "~r~nNumero de Documento: " + ls_serie + '-' + ls_numero )
	return false
end if

return true
end function

public function boolean of_validar_doc (string asi_proveedor, string asi_tipo_doc, string asi_serie, string asi_numero);Integer 	li_count
DateTime	ldt_fecha
String	ls_usuario, ls_numero_cp, ls_nro_doc
n_cst_wait 	lnvo_wait

try 
	lnvo_wait = create n_cst_wait
	ls_numero_cp = asi_numero

	select count(*)
		into :li_count
	from cntas_pagar cp
	where cp.cod_relacion 	= :asi_proveedor
	  and cp.tipo_doc			= :asi_tipo_doc
	  and cp.serie_cp			= :asi_serie	
	  and cp.numero_cp		= :ls_numero_cp;
	
	if li_count > 0 then
		select cp.fecha_registro, u.nombre
			into :li_count, :ls_usuario
		from 	cntas_pagar cp,
				usuario		u
		where cp.cod_usr			= u.cod_usr     (+)
		  and cp.cod_relacion 	= :asi_proveedor
		  and cp.tipo_doc			= :asi_tipo_doc
		  and cp.serie_cp			= :asi_serie	
		  and cp.numero_cp		= :ls_numero_cp;
	
		gnvo_app.of_mensaje_error( "El documento ya ha sido registrado por el usuario " + trim(ls_usuario) + " el día " + string(ldt_fecha, 'dd/mm/yyyy hh24:mi:ss') + ". Por favor verifique!" &
								+ "~r~nProveedor: " + asi_proveedor &
								+ "~r~Tipo Documento: " + asi_tipo_doc &
								+ "~r~nNumero de Documento: " + asi_serie + '-' + ls_numero_cp )
		return false
	end if
	

	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Error al momento de validar el registro en Cntas_Pagar')
	return false
	
finally
	lnvo_wait.of_close()
	destroy lnvo_wait
end try

end function

public function string of_get_nro_doc (string asi_proveedor, string asi_tipo_doc, string asi_serie, string asi_numero) throws exception;Integer 	li_count
DateTime	ldt_fecha
String	ls_usuario, ls_numero_cp, ls_nro_doc
n_cst_wait 	lnvo_wait

try 
	lnvo_wait = create n_cst_wait
	ls_numero_cp = invo_utility.ltrim(asi_numero, '0')

	if not this.of_validar_doc( asi_proveedor, asi_tipo_doc, asi_serie, asi_numero ) then
		return gnvo_app.is_null
	end if
	
	//Ahora lo valido con el nro_doc
	ls_nro_doc = invo_utility.of_get_nro_doc( asi_serie, ls_numero_cp)
	
	select count(*)
		into :li_count
	from cntas_pagar cp
	where cp.cod_relacion 	= :asi_proveedor
	  and cp.tipo_doc			= :asi_tipo_doc
	  and cp.nro_doc			= :ls_nro_doc;
	
	if li_count > 0 then
		select cp.fecha_registro, u.nombre
			into :ldt_fecha, :ls_usuario
		from 	cntas_pagar cp,
				usuario		u
		where cp.cod_usr			= u.cod_usr
		  and cp.cod_relacion 	= :asi_proveedor
		  and cp.tipo_doc			= :asi_tipo_doc
		  and cp.nro_doc			= :ls_nro_doc;
	
		If MessageBox('Aviso', "El documento ya ha sido registrado por el usuario " + trim(ls_usuario) + " el día " + string(ldt_fecha, 'dd/mm/yyyy hh24:mm:ss') &
								+ "~r~nProveedor: " + asi_proveedor &
								+ "~r~Tipo Documento: " + asi_tipo_doc &
								+ "~r~nNumero de Documento: " + ls_nro_doc &
								+ "~r~nDesea continuar?, En caso de continuar el nro_doc se remplazara por otro", Information!, YesNo!, 2 ) = 2 then 
			return gnvo_app.is_null
		end if
		
		DO
			ls_numero_cp = left(ls_numero_cp, len(ls_numero_cp) - 1)
			lnvo_wait.of_mensaje("Procesando Numero " + ls_numero_cp)
	
			ls_nro_doc = invo_utility.of_get_nro_doc( asi_serie, ls_numero_cp)
			
			if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then return gnvo_app.is_null
			
			select count(*)
				into :li_count
			from cntas_pagar cp
			where cp.cod_relacion 	= :asi_proveedor
			  and cp.tipo_doc			= :asi_tipo_doc
			  and cp.nro_doc			= :ls_nro_doc;
	  
		LOOP WHILE li_count > 0 and len(ls_numero_cp) > 1
		
		if li_count > 0 then
			//Si pasa a este punto entonces tranformo el numero en hexadecimal
			ls_numero_cp = invo_utility.of_long2hex(Long(invo_utility.ltrim(asi_numero, '0')))
			
			//Ahora lo valido con el nro_doc
			ls_nro_doc = invo_utility.of_get_nro_doc( asi_serie, ls_numero_cp)
			
			select count(*)
				into :li_count
			from cntas_pagar cp
			where cp.cod_relacion 	= :asi_proveedor
			  and cp.tipo_doc			= :asi_tipo_doc
			  and cp.nro_doc			= :ls_nro_doc;
			  
			if li_count > 0 then
				DO
					ls_numero_cp = left(ls_numero_cp, len(ls_numero_cp) - 1)
					lnvo_wait.of_mensaje("Procesando Numero " + ls_numero_cp)
			
					ls_nro_doc = invo_utility.of_get_nro_doc( asi_serie, ls_numero_cp)
					
					if IsNull(ls_nro_doc) or trim(ls_nro_doc) = '' then return gnvo_app.is_null
					
					select count(*)
						into :li_count
					from cntas_pagar cp
					where cp.cod_relacion 	= :asi_proveedor
					  and cp.tipo_doc			= :asi_tipo_doc
					  and cp.nro_doc			= :ls_nro_doc;
			  
				LOOP WHILE li_count > 0 and len(ls_numero_cp) > 1
				
				if li_count > 0 then
					MessageBox('Error', 'No es posible encontrar un numero de documento valido que no se repita para esta factura', StopSign!)
				Else
					MessageBox('Error', 'El nro de documento generado es ' + ls_nro_doc, Information!)
				end if
				
			end if
		else
			MessageBox('Error', 'El nro de documento generado es ' + ls_nro_doc, StopSign!)
		end if
		
	end if
		
		
	return ls_nro_doc

catch ( Exception ex )
	throw ex
	
finally
	
	lnvo_wait.of_close()
	destroy lnvo_wait
end try

end function

public function boolean of_enviar_email (string as_cod_relacion, string as_tipo_doc, string as_nro_doc);String					ls_serie_cp, ls_numero_cp, ls_nom_proveedor, ls_ruc_dni, ls_email, ls_mensaje,&
							ls_email_soporte, ls_body_html, ls_subject, ls_full_nro_doc
Date						ld_fecha_emision
n_cst_emailMessage	lnvo_msg

try 
	
	//Obtengo los datos necesarios
	select cp.serie_cp,
			 cp.numero_cp,
			 cp.serie_cp || '-' || PKG_UTILITY.of_trim(cp.numero_cp, '0') as full_nro_doc,
			 cp.fecha_emision,
			 p.nom_proveedor,
			 decode(p.tipo_doc_ident, '6', p.ruc, p.nro_doc_ident) as ruc_dni,
			 p.email
	  into :ls_serie_cp, 
	  		 :ls_numero_cp, 
	  		 :ls_full_nro_doc,
	  		 :ld_fecha_emision, 
			 :ls_nom_proveedor, 
			 :ls_ruc_dni, 
			 :ls_email
	  from cntas_pagar cp,
			 proveedor   p
	 where cp.cod_relacion = p.proveedor
		and cp.cod_relacion = :as_cod_relacion
		and cp.tipo_doc     = :as_tipo_doc
		and cp.nro_doc      = :as_nro_doc;
		
	if SQLCA.SQLCode = 100 then
		ROLLBACK;
		MessageBox('Error', 'No se ha encontrado registro en provisión de Cntas x Pagar para el documento, por favor verifique!' &
								+ '~r~nCod Relacion: ' + as_cod_relacion &
								+ '~r~nTipo Doc: ' 	  + as_tipo_doc &
								+ '~r~nNro Doc: ' 	  + as_nro_doc, StopSign!)
								
								
		return false
	end if
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error para buscar el registro en Cntas x Pagar, por favor verifique!' &
								+ '~r~nCod Relacion: '     + as_cod_relacion &
								+ '~r~nTipo Doc: ' 	      + as_tipo_doc &
								+ '~r~nNro Doc: ' 	      + as_nro_doc &
								+ '~r~nMensaje de Error: ' + ls_mensaje, StopSign!)
								
								
		return false
	end if
	
	//Si no tiene email, entonces le pido al usuario que ingrese el email correspondiente
	if IsNull(ls_email) or trim(ls_email) = '' then
		if not gnvo_app.of_prompt_string("Indique el email del proveedor: " + ls_nom_proveedor, ls_email) then return false
	end if
	
	if IsNull(ls_email) or trim(ls_email) = '' then
		MessageBox('Error', "No se ha indicado ningun email para el proveedor " + ls_nom_proveedor + ", por favor verifique!", StopSign!)
		return false
	end if
	
	//Validando y añadiendo el email del proveedor
	if pos(ls_email, '@', 1) = 0 then
		MessageBox('Error', "Email ingresado al " + ls_nom_proveedor + " no es valido, por favor verifique!" &
								+ '~r~nEmail Proveedor: ' + ls_email, StopSign!)
		return false
	end if
			
	if pos(ls_email, '/', 1) > 0 or pos(ls_email, ';', 1) > 0 then
	
		//Si el email tiene ';' o '/' entonces son mas de un cuenta de correo a la vez
		if not lnvo_msg.of_add_emails_client_from_string(ls_nom_proveedor, ls_email) then return false
		
	else
		//Si no solamente adiciono el email del cliente como un unico email
		if not invo_smtp.of_ValidEmail(ls_email, ls_mensaje) then
			
			yield()
			invo_wait.of_mensaje("Error al validar email : " + ls_email + ". Mensaje: " + ls_mensaje)
			sleep(2)
			yield()

			//invo_wait.of_close()
			
			return false
		end if
		
		invo_wait.of_mensaje("Adicionando Email del cliente")
		if not lnvo_msg.of_add_email_to(ls_nom_proveedor, ls_email) then return false

	end if
	
	//Actualizo el email en el proveedor
	update proveedor p
	   set p.email = :ls_email
	where p.proveedor = :as_cod_relacion;
	
	if SQLCA.SQLCode = -1 then
		ls_mensaje = SQLCA.SQLErrText
		ROLLBACK;
		MessageBox('Error', 'Ha ocurrido un error al actualizar el email en la tabla PROVEEDOR, por favor verifique!' &
								+ '~r~nCod Relacion: '     + as_cod_relacion &
								+ '~r~nMensaje de Error: ' + ls_mensaje, StopSign!)
								
		return false
	end if
	
	commit;
	
	// Ahora añado el email de soporte al cual va a ir con copia
	invo_wait.of_mensaje("Adicionando email de soporte")
	ls_email_soporte = gnvo_app.of_get_parametro("EMAIL_SOPORTE", "MI EMPRESA, miemail@miempresa.pe; Jhonny Ramirez Chiroque, jramirez@npssac.com.pe;")
	if not IsNull(ls_email_soporte) and trim(ls_email_soporte) <> '' then
		lnvo_msg.of_add_emails_from_string(ls_email_soporte)
	end if
	
	//Sin no han emails en ITR_EMAIL_TO agrego uno por defecto
	if UpperBound(lnvo_msg.istr_email_to) = 0 then
		if not lnvo_msg.of_add_email_to('NO REPLY', 'no-reply@npssac.com.pe') then return false
	end if

	//Ahora preparo el Subject
	ls_subject = 'COMPROBANTE DE PAGO: ' + trim(as_tipo_doc) + ' / ' + ls_full_nro_doc + '. Fecha: ' &
				  + string(ld_fecha_emision, 'dd/mm/yyyy') &
			  	  + ' CLIENTE: ' + ls_ruc_dni + '-' + ls_nom_proveedor 


	//Ahora genero el mensaje que sería HTML
	ls_body_html = '<table width="100%">'
	
	//1. El saludo preliminar
	ls_body_html += '	<tr>' + char(10) + char(13) &
					  + '		<td>' + char(10) + char(13) &
					  + '			<h4>Estimado Proveedor: </h4>' + char(10) + char(13) &
					  + '		<td>' + char(10) + char(13) &
					  + '	</tr>'
	
	//2. Datos del Proveedor
	ls_body_html += '	<tr>' + char(10) + char(13) &
					  + '		<td>' + char(10) + char(13) &
					  + '			<table>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RUC / DNI</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_ruc_dni + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>RAZON SOCIAL</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + ls_nom_proveedor + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>NRO COMPROBANTE</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + trim(as_tipo_doc) + ' - ' + ls_full_nro_doc + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '				<tr>' + char(10) + char(13) &
					  + '					<td>FECHA EMISION</td>' + char(10) + char(13) &
					  + '					<td>:</td>' + char(10) + char(13) &
					  + '					<td>' + string(ld_fecha_emision, 'dd/mm/yyyy') + '</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '			</table>' + char(10) + char(13) &
					  + '		<td>' + char(10) + char(13) &
					  + '	</tr>' + char(10) + char(13) 
	
	//3. Linea anterior de verificacion
	ls_body_html += '	<tr>' + char(10) + char(13) &
					  + '		<td>' + char(10) + char(13) &
					  + '			Se le informa que el comprobante indicado en el email ha sido registrado '&
					  + '			en nuestro Sistema Integrado ERP - SIGRE. Por favor no responda a este ' &
					  + '			email ya que fue enviado automaticamente por el SIGRE.' + char(10) + char(13) &
					  + '		</td>' + char(10) + char(13) &
					  + '	</TR>' + char(10) + char(13) &
					  + '	<tr>' + char(10) + char(13) &
				  	  + '		<td>' + char(10) + char(13) 

	//4. Sello de Powered by SIGRE
	ls_body_html += '			<table>' + char(10) + char(13) &
					  + '				<tr style="font-size:10px">' + char(10) + char(13) &
					  + '					<td valign="top" align="right" colspan="10">' + char(10) + char(13) &
					  + '						Powered by SIGRE' + char(10) + char(13) &
					  + '					</td>' + char(10) + char(13) &
					  + '				</tr>' + char(10) + char(13) &
					  + '			</table>' + char(10) + char(13) &
					  + '		</td>' + char(10) + char(13) &
					  + '	</tr>' + char(10) + char(13)
					  
	//5. Cierro la tabla
	ls_body_html += '</table>'
				  
	//Poner Body y Subject (Asunto)
	lnvo_msg.of_set_Body(ls_body_html)
	lnvo_msg.of_set_Subject(ls_subject)
	
	//Cargo los parametros
	invo_wait.of_mensaje("Caragando Parametros")
	invo_email.of_load()
	
	
	
	//envio el email
	if UpperBound(lnvo_msg.istr_email_to) > 0 or UpperBound(lnvo_msg.istr_email_bcc) > 0 then
		invo_wait.of_mensaje("Enviando Mensaje")
		if not invo_email.of_Send(lnvo_msg) then return false
		invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
	end if
	
	return true

catch ( Exception ex )
	gnvo_app.of_catch_exception(ex, 'Ha ocurrido una exception en funcion n_cst_cntas_pagar.of_enviar_email()')
	return false
	
finally
	invo_wait.of_close()
	
end try



end function

on n_cst_cntas_pagar.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_cntas_pagar.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_wait 	= create n_Cst_wait
end event

event destructor;destroy invo_wait
end event

