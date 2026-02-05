$PBExportHeader$n_cst_rrhh.sru
forward
global type n_cst_rrhh from nonvisualobject
end type
end forward

global type n_cst_rrhh from nonvisualobject
end type
global n_cst_rrhh n_cst_rrhh

type variables
Public:
//Conceptos Puros
String is_cnc_vacac, is_tipo_emp, is_tipo_jor, is_tipo_des, is_tipo_tri, is_grp_utilidad

//Grupos de calculo
String	is_grp_vacac, is_path_sigre

n_cst_wait 			invo_wait	
n_cst_utilitario 	invo_util
u_ds_base			ids_boleta_pago
n_cst_pdf			invo_pdf
n_cst_inifile		invo_inifile
n_smtp				invo_smtp
n_cst_serversmtp	invo_email
n_cst_email_dll		invo_email_dll		//Nueva clase para envio de correos via DLL
end variables

forward prototypes
public function boolean load_param ()
public function boolean of_sector_agrario (string as_tipo_trabajador)
public function date of_get_ult_fec_proceso (string asi_origen, string asi_tipo_trabaj)
public function date of_get_ult_fec_proceso (string asi_origen, string asi_tipo_trabaj, string asi_tipo_planilla)
public function string of_get_firma_autorizado_cts (string as_ini_file) throws exception
public subroutine of_send_boleta_to_email (long al_row, u_dw_abc adw_listado_trabajadores, u_dw_abc adw_procesos_planilla)
public function string get_dw_boleta (string as_tipo_trabajador, string as_tipo_planilla)
public function boolean of_existe_boleta ()
public function string of_generar_pdf (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen)
public function boolean of_get_body_subject (string as_cod_trabajador, string as_nom_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen, ref string as_body_html, ref string as_subject)
public function boolean of_enviar_correo (string as_filename_pdf, string as_email, string as_cod_trabajador, string as_nom_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen)
public function boolean of_eliminar_pdf (string as_filename_pdf)
public function boolean of_update_fecha_envio (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen, string as_email)
public subroutine of_generar_boleta (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen) throws exception
public function string get_dw_boleta_email (string as_tipo_trabajador, string as_tipo_planilla)
end prototypes

public function boolean load_param ();try 
	invo_inifile.of_set_inifile(gnvo_app.is_empresas_iniFile)
	
	select r.gan_fij_calc_vacac
		into :is_grp_vacac
	from rrhhparam_cconcep r;
	
	select concepto_gen
		into :is_cnc_vacac
	from grupo_calculo r
	where r.grupo_calculo = :is_grp_vacac;
	
	
	//PArametros generales de RRHH
	SELECT r.tipo_trab_obrero, r.tipo_trab_empleado, r.tipo_trab_tripulante, r.tipo_trab_destajo
		into :is_tipo_jor, :is_tipo_emp, :is_tipo_tri, :is_tipo_des
	FROM rrhhparam r
	where r.reckey = '1';
	
	//Parametro para el grupo de utilidades
	is_grp_utilidad = gnvo_app.of_get_parametro("GRUPO_AFECTO_UTILIDAD", '090')
	
	is_path_sigre 	= invo_inifile.of_get_parametro( "SIGRE_EXE", "PATH_SIGRE", "I:\SIGRE_EXE")
	
	return true

catch ( Exception ex)
	gnvo_app.of_catch_exception(ex, 'Error al cargar parametros en objecto n_cst_rrhh')
end try

end function

public function boolean of_sector_agrario (string as_tipo_trabajador);String ls_sector_agrario

select t.flag_sector_agrario
  into :ls_sector_agrario
  from tipo_trabajador t
 where t.tipo_trabajador = :as_tipo_trabajador;
 
 if ls_sector_agrario = '1' then
	return true 
else
	return false
end if
	

end function

public function date of_get_ult_fec_proceso (string asi_origen, string asi_tipo_trabaj);Date ld_fecha

select fec_proceso
	into :ld_fecha
from rrhh_param_org
where origen = :asi_origen
  and tipo_trabajador = :asi_tipo_trabaj
  and rownum 			 = 1
order by fec_proceso desc;  

return ld_fecha
end function

public function date of_get_ult_fec_proceso (string asi_origen, string asi_tipo_trabaj, string asi_tipo_planilla);Date ld_fecha

select s.fec_proceso
	into :ld_fecha
from(	
	select fec_proceso
	from rrhh_param_org
	where origen 				= :asi_origen
	  and tipo_trabajador 	= :asi_tipo_trabaj
	  and tipo_planilla		= :asi_tipo_planilla
	minus
	select distinct fec_calc_plan
	from historico_calculo hc
	where cod_origen			= :asi_origen
	  and tipo_trabajador 	= :asi_tipo_trabaj
	  and tipo_planilla		= :asi_tipo_planilla
) s
order by s.fec_proceso desc;  

return ld_fecha
end function

public function string of_get_firma_autorizado_cts (string as_ini_file) throws exception;String 			ls_file
n_cst_inifile 	lnvo_inifile

//ls_file		 = ProfileString (as_ini_file, "Firma_digital", "CTS_" + gs_empresa, "i:\sigre\firma_Digital\Autorizado_rrhh.jpg")

try
	
	lnvo_inifile = create n_cst_inifile
	
	lnvo_inifile.of_set_inifile(as_ini_file)
	
	ls_file = lnvo_inifile.of_get_parametro("Firma_digital", "CTS_" + gs_empresa, "i:\sigre\firma_Digital\Autorizado_rrhh.jpg")
	
	return ls_file

catch(Exception ex)
	throw ex
	
finally
	destroy lnvo_inifile
end try


end function

public subroutine of_send_boleta_to_email (long al_row, u_dw_abc adw_listado_trabajadores, u_dw_abc adw_procesos_planilla);String 	ls_cod_trabajador, ls_tipo_trabajador, ls_email, ls_nom_trabajador, ls_checked, &
			ls_tipo_planilla, ls_origen, ls_file_pdf, ls_fec_proceso
Date 		ld_fec_proceso			
Long		ll_row

try
	ls_origen			= adw_listado_trabajadores.object.cod_origen	 		[al_row]
	ls_cod_trabajador 	= adw_listado_trabajadores.object.cod_trabajador 		[al_row]
	ls_tipo_trabajador 	= adw_listado_trabajadores.object.tipo_trabajador		[al_row]
	ls_tipo_planilla 	= adw_listado_trabajadores.object.tipo_planilla 		[al_row]
	ld_fec_proceso		= Date(adw_listado_trabajadores.object.fec_calc_plan	[al_row])
	ls_email 			= adw_listado_trabajadores.object.email 				[al_row]
	ls_nom_trabajador 	= adw_listado_trabajadores.object.nom_trabajador 		[al_row]
	
	//quito las comas y los puntos y comas
	ls_nom_trabajador = invo_util.of_replaceall(ls_nom_trabajador, ",", "")


	//invo_wait.of_mensaje("Procesando boleta de Trabjador : " + ls_nom_trabajador)
	
	of_generar_boleta(ls_cod_trabajador, ls_tipo_trabajador, ld_fec_proceso, ls_tipo_planilla, ls_origen)
	
	ChangeDirectory ( this.is_path_sigre )
			
	if of_Existe_boleta() then
		ls_file_pdf = of_generar_pdf(ls_cod_trabajador, ls_tipo_trabajador, ld_fec_proceso, ls_tipo_planilla, ls_origen)
		
		if of_enviar_correo(ls_file_pdf, 		&
							ls_email,			&
							ls_cod_trabajador, 	&
							ls_nom_trabajador, 	&
							ls_tipo_trabajador, &
							ld_fec_proceso, 	&
							ls_tipo_planilla, 	&
							ls_origen			) then
			
			of_eliminar_pdf(ls_file_pdf)
			
			if not of_update_fecha_envio(ls_cod_trabajador, &
										 ls_tipo_trabajador, &
										 ld_fec_proceso, &
										 ls_tipo_planilla, &
										 ls_origen, &
										 ls_email) then return
			
		end if
	end if
			


catch ( Exception e )
	gnvo_app.of_catch_exception(e, 'Ha ocurrido una exception al enviar Boletas por email')
	
finally

	//invo_wait.of_close()
end try


end subroutine

public function string get_dw_boleta (string as_tipo_trabajador, string as_tipo_planilla);string ls_dw


if as_tipo_planilla = 'C' and upper(gs_empresa) = 'SAKANA' then
	ls_dw = 'd_rpt_boleta_cts_sakana_tbl'
	
elseif as_tipo_planilla = 'G' and upper(gs_empresa) = 'SAKANA' then
	ls_dw = 'd_rpt_boleta_grati_sakana_tbl'

elseif as_tipo_planilla = 'V' and upper(gs_empresa) = 'SAKANA' then

	ls_dw = 'd_rpt_boleta_vaca_sakana_tbl'

elseif as_tipo_planilla = 'B' and upper(gs_empresa) = 'SAKANA' then

	ls_dw = 'd_rpt_boleta_bonif_sakana_tbl'
	
else
	
	if gs_empresa = 'ADEN' then
		ls_dw = 'd_rpt_boleta_pago_aden_tbl'
	elseif gs_empresa = 'CANTABRIA' then
		ls_dw = 'd_rpt_boleta_pago_cantabria_tbl'
	elseif gs_empresa = 'SAKANA' then
		ls_dw = 'd_rpt_boleta_pago_sakana_tbl'
	elseif gs_empresa = 'FRUITXCHANGE' then
		ls_dw = 'd_rpt_boleta_pago_fxchange_tbl'
	else
		ls_dw = 'd_rpt_boleta_pago_tbl'
	end if
	
end if		

return ls_dw
end function

public function boolean of_existe_boleta ();if ids_boleta_pago.RowCount() > 0 then 
	return true
else
	return false
end if
end function

public function string of_generar_pdf (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen);String ls_filename_pdf, ls_path

//Directorio donde se guardan los PDF
ls_path = this.is_path_sigre + 'EFACT_PDF\' + gnvo_app.empresa.is_ruc + '_' &
		  + gnvo_app.empresa.is_sigla + '\PLANILLA\' + as_tipo_trabajador + '\' &
		  + string(ad_fec_proceso, 'yyyymmdd') &
		  + '\' //NOMBRE DE DIRECTORIO

If not DirectoryExists ( ls_path ) Then
	if not invo_util.of_CreateDirectory( ls_path ) then return ""
	
End If

//Nombre del archivo  PDF
ls_filename_pdf = ls_path + trim(as_origen) + '_' + trim(as_tipo_trabajador) + '_' &
					 + string(ad_fec_proceso, 'yyyymmdd') + "_" &
					 + trim(as_cod_trabajador) + "_" &
					 + trim(as_tipo_planilla) + '.pdf'

if not invo_pdf.of_create_pdf( ids_boleta_pago, ls_filename_pdf, 1) then return ""

return ls_filename_pdf


end function

public function boolean of_get_body_subject (string as_cod_trabajador, string as_nom_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen, ref string as_body_html, ref string as_subject);

//Armo la cabecera la tabla
as_body_html = '<table width="100%">'

//1. El saludo preliminar
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<h4>Estimado Trabajador: </h4>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '	</tr>'

//2. Datos del cliente
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<table>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>Codigo Trajabador</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + as_cod_trabajador + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>Nombre Trabajador</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + as_nom_trabajador + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '			</table>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '	</tr>' + char(10) + char(13) 


//3. Linea anterior de verificacion
as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			Se le hace llegar la boleta de pagos correspondiente al periodo' + char(10) + char(13) &
				  + '		</td>' + char(10) + char(13) &
				  + '	</TR>' + char(10) + char(13)

as_body_html += '	<tr>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '			<table>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>Codigo Origen</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + as_origen + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>tipo Trabajador</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + as_tipo_trabajador + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>Fecha Proceso</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + string(ad_fec_proceso, 'dd/mm/yyyy') + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '				<tr>' + char(10) + char(13) &
				  + '					<td>tipo Planilla</td>' + char(10) + char(13) &
				  + '					<td>:</td>' + char(10) + char(13) &
				  + '					<td>' + as_tipo_planilla + '</td>' + char(10) + char(13) &
				  + '				</tr>' + char(10) + char(13) &
				  + '			</table>' + char(10) + char(13) &
				  + '		<td>' + char(10) + char(13) &
				  + '	</tr>' + char(10) + char(13) 

				  
//8. Cierro la tabla
as_body_html += '</table>'

//Ahora preparo el Subject
as_subject = 'BOLETA DE PAGOS DEL TRABAJADOR : '+ as_cod_trabajador + '-' + as_nom_trabajador

return true
end function

public function boolean of_enviar_correo (string as_filename_pdf, string as_email, string as_cod_trabajador, string as_nom_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen);/********************************************************************
   Función: of_enviar_correo
   Propósito: Envía boleta de pago por email usando n_cst_email_dll
   
   Parámetros:
      - as_filename_pdf: Ruta del archivo PDF a adjuntar
      - as_email: Email(s) del trabajador (puede tener separadores ; o /)
      - as_cod_trabajador: Código del trabajador
      - as_nom_trabajador: Nombre del trabajador
      - as_tipo_trabajador: Tipo de trabajador
      - ad_fec_proceso: Fecha del proceso de planilla
      - as_tipo_planilla: Tipo de planilla
      - as_origen: Origen del proceso
   
   Retorno: True si se envió correctamente, False si hubo error
********************************************************************/
String 					ls_email_soporte, ls_resultado, ls_adjuntos
String					ls_mensaje, ls_body_html, ls_subject
String					ls_separador, ls_sub_email
Long					ll_pos, ll_inicio, ll_idx_to, ll_idx_cco
str_email_address		lstr_from
str_email_address		lstr_to[], lstr_cc[], lstr_cco[]		//CC vacío, CCO para soporte

try 
	invo_wait.of_mensaje("Validando inputs")
	invo_email_dll = create n_cst_email_dll
	
	//Configurar el remitente (FROM)
	lstr_from.email = gnvo_app.of_get_parametro("EMAIL_FROM_RRHH", "sigre@npssac.com.pe")
	lstr_from.nombre = gnvo_app.of_get_parametro("NOMBRE_FROM_RRHH", "Recursos Humanos")
	
	ll_idx_to = 0
	ll_idx_cco = 0
	
	//Si el email del trabajador es valido entonces lo agrego a destinatarios (TO)
	try
		if trim(as_email) <> '' and pos(as_email, '@', 1) > 0 then
			
			//Verificar si hay múltiples emails (separados por ; o /)
			if pos(as_email, '/', 1) > 0 or pos(as_email, ';', 1) > 0 then
				
				//Determinar el separador
				if pos(as_email, ';', 1) > 0 then
					ls_separador = ';'
				else
					ls_separador = '/'
				end if
				
				//Parsear múltiples emails
				ll_inicio = 1
				ll_pos = Pos(as_email, ls_separador, ll_inicio)
				
				do while ll_pos > 0
					ls_sub_email = trim(mid(as_email, ll_inicio, ll_pos - ll_inicio))
					
					if len(ls_sub_email) > 0 and pos(ls_sub_email, '@') > 0 then
						ll_idx_to ++
						lstr_to[ll_idx_to].email = ls_sub_email
						lstr_to[ll_idx_to].nombre = as_nom_trabajador
					end if
					
					ll_inicio = ll_pos + 1
					ll_pos = Pos(as_email, ls_separador, ll_inicio)
				loop
				
				//Último email después del separador
				ls_sub_email = trim(mid(as_email, ll_inicio))
				if len(ls_sub_email) > 0 and pos(ls_sub_email, '@') > 0 then
					ll_idx_to ++
					lstr_to[ll_idx_to].email = ls_sub_email
					lstr_to[ll_idx_to].nombre = as_nom_trabajador
				end if
				
			else
				//Email único del trabajador
				if not invo_smtp.of_ValidEmail(as_email, ls_mensaje) then
					yield()
					invo_wait.of_mensaje("Advertencia al validar email: " + ls_mensaje)
					sleep(1)
					yield()
					//Continuamos aunque haya advertencia
				end if
				
				invo_wait.of_mensaje("Adicionando Email del trabajador")
				ll_idx_to ++
				lstr_to[ll_idx_to].email = trim(as_email)
				lstr_to[ll_idx_to].nombre = as_nom_trabajador
			end if
		end if
		
	catch(Exception e)
		invo_wait.of_mensaje("Error en el correo del trabajador: " + e.getMessage())
		return false
	end try
	
	//Añadir emails CC desde parámetro RRHH_EMAIL_CC
	//Formato: "email1@dominio.com; email2@dominio.com" o un solo email
	invo_wait.of_mensaje("Adicionando emails CC")
	String ls_emails_cc, ls_email_cco
	ls_emails_cc = gnvo_app.of_get_parametro("RRHH_EMAIL_CC", "jramirez@npssac.com.pe; jhonnyaramirezch@gmail.com;")
	
	if not IsNull(ls_emails_cc) and trim(ls_emails_cc) <> '' then
		//Verificar si hay múltiples emails (separados por ;)
		if pos(ls_emails_cc, ';') > 0 then
			//Parsear múltiples emails CCO
			ll_inicio = 1
			ll_pos = Pos(ls_emails_cc, ';', ll_inicio)
			
			do while ll_pos > 0
				ls_email_cco = trim(mid(ls_emails_cc, ll_inicio, ll_pos - ll_inicio))
				
				if len(ls_email_cco) > 0 and pos(ls_email_cco, '@') > 0 then
					ll_idx_cco ++
					lstr_cc[ll_idx_cco].email = ls_email_cco
					lstr_cc[ll_idx_cco].nombre = ls_emails_cc
				end if
				
				ll_inicio = ll_pos + 1
				ll_pos = Pos(ls_emails_cc, ';', ll_inicio)
			loop
			
			//Último email después del separador
			ls_email_cco = trim(mid(ls_emails_cc, ll_inicio))
			if len(ls_email_cco) > 0 and pos(ls_email_cco, '@') > 0 then
				ll_idx_cco ++
				lstr_cc[ll_idx_cco].email = ls_email_cco
				lstr_cc[ll_idx_cco].nombre = ls_emails_cc
			end if
		else
			//Email único CCO
			ls_emails_cc = trim(ls_emails_cc)
			if pos(ls_email_cco, '@') > 0 then
				ll_idx_cco ++
				lstr_cc[ll_idx_cco].email = ls_emails_cc
				lstr_cc[ll_idx_cco].nombre = ls_emails_cc
			end if
		end if
	end if
	
	//Generar el cuerpo HTML y asunto del email
	invo_wait.of_mensaje("Obteniendo el CUERPO y ASUNTO del email")
	if not this.of_get_body_subject(as_cod_trabajador, &
									as_nom_Trabajador, &
									as_tipo_trabajador, &
									ad_fec_proceso, &
									as_tipo_planilla, &
									as_origen, & 
									ls_body_html, &
									ls_subject) then return false

	//Preparar adjuntos (separados por |)
	invo_wait.of_mensaje("Preparando Archivos Adjuntos")
	ls_adjuntos = ""
	if trim(as_filename_pdf) <> '' then 
		if FileExists(as_filename_pdf) then
			ls_adjuntos = as_filename_pdf
		else
			invo_wait.of_mensaje("Archivo PDF no encontrado: " + as_filename_pdf)
		end if
	end if
	
	//Si no hay destinatarios, agregar uno por defecto
	if ll_idx_to = 0 then
		invo_wait.of_mensaje("No hay destinatarios, usando email por defecto")
		ll_idx_to = 1
		lstr_to[1].email = 'no-reply@npssac.com.pe'
		lstr_to[1].nombre = 'NO REPLY'
	end if
	
	//Enviar el email usando la nueva clase n_cst_email_dll
	if ll_idx_to > 0 or ll_idx_cco > 0 then
		invo_wait.of_mensaje("Enviando Mensaje via DLL...")
		
		//Crear instancia del objeto si no existe
		if IsNull(invo_email_dll) then
			invo_email_dll = create n_cst_email_dll
		end if
		
		//Llamar al método de envío (lstr_cc vacío, lstr_cco para emails de soporte)
		ls_resultado = invo_email_dll.of_send_email(lstr_from, &
													lstr_to, &
													lstr_cc, &
													lstr_cco, &
													ls_subject, &
													ls_body_html, &
													true, &
													ls_adjuntos)
		
		//Verificar resultado (el DLL retorna JSON: {"exitoso":true/false,"mensaje":"..."})
		if pos(lower(ls_resultado), '"exitoso":true') > 0 or pos(lower(ls_resultado), '"exitoso": true') > 0 then
			invo_wait.of_mensaje("Email Enviado Satisfactoriamente")
		else
			invo_wait.of_mensaje("Error al enviar email: " + ls_resultado)
			sleep(2)
			return false
		end if
	end if
	
	return true
	
catch ( Exception ex )
	yield()
	invo_wait.of_mensaje("Ha ocurrido una exception: " + ex.getMessage())
	sleep(2)
	yield()
	
	return false

finally
	invo_wait.of_close()
	destroy invo_email_dll
end try
end function

public function boolean of_eliminar_pdf (string as_filename_pdf);return FileDelete(as_filename_pdf)

end function

public function boolean of_update_fecha_envio (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen, string as_email);String ls_mensaje

update historico_calculo t
	set t.FEC_ENVIO_EMAIL = sysdate,
		t.EMAIL_TO_SENDED = :as_email
 where t.cod_trabajador	 		= :as_cod_trabajador
   and t.tipo_trabajador		= :as_tipo_trabajador
	and trunc(t.fec_calc_plan) 	= trunc(:ad_fec_proceso)
	and t.tipo_planilla			= :as_tipo_planilla
	and t.cod_origen			= :as_origen;
 
if SQLCA.SQLCode < 0 then
	ls_mensaje = SQLCA.SQLErrText
	rollback;
	MessageBox('Error', 'No se pudo actualizar la fec_envio_email en la tabla historico_Calculo  ' &
							+ 'con Cod_Trabajador: ' + trim(as_cod_trabajador) &
							+ 'Mensaje de Error: ' + ls_mensaje + '.Por favor verifique!', StopSign!)
	return false			
end if

commit;

invo_wait.of_mensaje("Datos Actualizados en historico de calculo")
	
return true
end function

public subroutine of_generar_boleta (string as_cod_trabajador, string as_tipo_trabajador, date ad_fec_proceso, string as_tipo_planilla, string as_origen) throws exception;String ls_mensaje, ls_desc_origen, ls_cencos
	
ids_boleta_pago.dataObject = get_dw_boleta_email(as_tipo_trabajador, as_tipo_planilla)

ids_boleta_pago.setTransObject(SQLCA)


if as_tipo_planilla = 'C' and upper(gs_empresa) = 'SAKANA' then
	
	ids_boleta_pago.retrieve(as_tipo_trabajador, ad_fec_proceso)
	
elseif as_tipo_planilla = 'G' and upper(gs_empresa) = 'SAKANA' then
		
	ids_boleta_pago.retrieve(as_origen, as_tipo_trabajador, ad_fec_proceso, as_cod_trabajador)
	
elseif as_tipo_planilla = 'V' and upper(gs_empresa) = 'SAKANA' then
	//Si es planilla de Gratificacion y es sakana entonces es otra boleta
	ids_boleta_pago.retrieve(as_origen, as_tipo_trabajador, ad_fec_proceso, as_cod_trabajador)
	
elseif as_tipo_planilla = 'B' and upper(gs_empresa) = 'SAKANA' then
		
	ids_boleta_pago.retrieve(as_origen, as_tipo_trabajador, as_cod_trabajador, ad_fec_proceso)
		
else
	ls_cencos = '%%'
	
	if gnvo_app.of_get_parametro("BOLETAS_POR_CENCOS", "0") = "0" then
				
		//		create or replace procedure usp_rh_rpt_boleta_pago(
		//				 asi_tipo_trabajador in tipo_trabajador.tipo_trabajador%TYPE, 
		//				 asi_origen          in origen.cod_origen%TYPE, 
		//				 asi_codigo          in maestro.cod_trabajador%TYPE,
		//				 adi_fec_proceso     in DATE,
		//				 asi_tipo_planilla   in calculo.tipo_planilla%TYPE
		//		) is
		Declare usp_rh_rpt_boleta_pago PROCEDURE FOR 
			usp_rh_rpt_boleta_pago ( :as_tipo_trabajador, 
											 :as_origen, 
											 :as_cod_trabajador, 
											 :ad_fec_proceso,
											 :as_tipo_planilla) ;
		Execute usp_rh_rpt_boleta_pago ;
		
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE usp_rh_rpt_boleta_pago: " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return 
		END IF
		
		Close usp_rh_rpt_boleta_pago;
			
	else
			
		//Filtro por centros de costo
		
		//create or replace procedure usp_rh_rpt_boleta_pago(
		//		 asi_tipo_trabajador in tipo_trabajador.tipo_trabajador%TYPE, 
		//		 asi_origen          in origen.cod_origen%TYPE, 
		//		 asi_codigo          in maestro.cod_trabajador%TYPE,
		//		 asi_cencos          in centros_costo.cencos%TYPE,
		//		 adi_fec_proceso     in DATE,
		//		 asi_tipo_planilla   in calculo.tipo_planilla%TYPE
		//) is	
		Declare usp_rh_rpt_boleta_pago_cencos PROCEDURE FOR 
			usp_rh_rpt_boleta_pago ( :as_tipo_trabajador, 
											 :as_origen, 
											 :as_cod_trabajador, 
											 :ls_cencos,
											 :ad_fec_proceso,
											 :as_tipo_planilla) ;
		Execute usp_rh_rpt_boleta_pago_cencos ;
		
		IF SQLCA.sqlcode = -1 THEN
			ls_mensaje = "PROCEDURE usp_rh_rpt_boleta_pago (usp_rh_rpt_boleta_pago_cencos): " + SQLCA.SQLErrText
			Rollback ;
			MessageBox('SQL error', ls_mensaje, StopSign!)	
			return 
		END IF
		
		Close usp_rh_rpt_boleta_pago_cencos;
		
	end if


	
	ids_boleta_pago.retrieve(gs_user, as_tipo_planilla)
		
	//Pongo los logos en caso se requiera
	if ids_boleta_pago.of_ExistsPictureName("p_logo") then
		ids_boleta_pago.object.p_logo.filename  = gs_logo
	end if
	
	select nombre
		into :ls_Desc_origen
	from origen 
	where cod_origen = :as_origen;
	
	if ids_boleta_pago.of_ExistsText("t_nombre") then
		ids_boleta_pago.object.t_nombre.text    = ls_desc_origen
	end if
	
	if ids_boleta_pago.of_ExistsPictureName("p_logo1") then
		ids_boleta_pago.object.p_logo1.filename = gs_logo
	end if
	if ids_boleta_pago.of_ExistsText("t_nombre1") then
		ids_boleta_pago.object.t_nombre1.text   = ls_desc_origen
	end if

	
	// Coloco la firma escaneada del representante 
	if gs_firma_digital <> "" then
		if Not FileExists(gs_firma_digital) then
			MessageBox('Error', 'No existe el archivo ' + gs_firma_digital + ", por favor verifique!!", StopSign!)
			return
		end if
		ids_boleta_pago.object.p_firma.filename  = gs_firma_digital
		
		if ids_boleta_pago.of_ExistsPictureName("p_firma1") then
			ids_boleta_pago.object.p_firma1.filename = gs_firma_digital
		end if
		
		
	end if
end if

end subroutine

public function string get_dw_boleta_email (string as_tipo_trabajador, string as_tipo_planilla);string ls_dw


if as_tipo_planilla = 'C' and upper(gs_empresa) = 'SAKANA' then
	ls_dw = 'd_rpt_boleta_cts_sakana_tbl'
	
elseif as_tipo_planilla = 'G' and upper(gs_empresa) = 'SAKANA' then
	ls_dw = 'd_rpt_boleta_grati_sakana_tbl'

elseif as_tipo_planilla = 'V' and upper(gs_empresa) = 'SAKANA' then

	ls_dw = 'd_rpt_boleta_vaca_sakana_tbl'

elseif as_tipo_planilla = 'B' and upper(gs_empresa) = 'SAKANA' then

	ls_dw = 'd_rpt_boleta_bonif_sakana_tbl'
	
else
	
	if gs_empresa = 'ADEN' then
		ls_dw = 'd_rpt_boleta_pago_aden_tbl'
	elseif gs_empresa = 'CANTABRIA' then
		ls_dw = 'd_rpt_boleta_pago_email_cantabria_tbl'
	elseif gs_empresa = 'SAKANA' then
		ls_dw = 'd_rpt_boleta_pago_sakana_tbl'
	elseif gs_empresa = 'FRUITXCHANGE' then
		ls_dw = 'd_rpt_boleta_pago_fxchange_tbl'
	else
		ls_dw = 'd_rpt_boleta_pago_tbl'
	end if
	
end if		

return ls_dw
end function

on n_cst_rrhh.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_cst_rrhh.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;invo_wait			= create n_cst_wait
ids_boleta_pago 	= create u_ds_base
invo_pdf				= create n_Cst_pdf
invo_inifile		= create n_cst_inifile
end event

event destructor;destroy invo_wait	
destroy ids_boleta_pago
destroy invo_pdf
destroy n_cst_inifile
end event

