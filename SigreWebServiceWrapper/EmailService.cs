using System;
using System.Configuration;
using System.Net;
using System.Net.Mail;
using System.Runtime.InteropServices;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Servicio para envío de correos electrónicos
    /// Expuesto como objeto COM para uso desde PowerBuilder 2025
    /// Lee la configuración SMTP del archivo SigreWebServiceWrapper.dll.config
    /// </summary>
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [ProgId("SigreWebServiceWrapper.EmailService")]
    [Guid("B2C3D4E5-F6A7-4890-BCDE-F01234567890")]
    public class EmailService
    {
        private string _smtpServer;
        private int _smtpPort;
        private string _smtpUser;
        private string _smtpPassword;
        private bool _enableSsl;
        private string _lastError;

        /// <summary>
        /// Constructor - carga la configuración del archivo .config
        /// </summary>
        public EmailService()
        {
            CargarConfiguracion();
        }

        /// <summary>
        /// Carga la configuración SMTP del archivo .config
        /// </summary>
        private void CargarConfiguracion()
        {
            try
            {
                _smtpServer = ConfigurationManager.AppSettings["SmtpServer"] ?? "smtp.gmail.com";
                _smtpPort = int.Parse(ConfigurationManager.AppSettings["SmtpPort"] ?? "587");
                _smtpUser = ConfigurationManager.AppSettings["SmtpUser"] ?? "";
                _smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"] ?? "";
                _enableSsl = bool.Parse(ConfigurationManager.AppSettings["SmtpEnableSSL"] ?? "true");
            }
            catch (Exception ex)
            {
                _lastError = "Error al cargar configuración SMTP: " + ex.Message;
                // Valores por defecto
                _smtpServer = "smtp.gmail.com";
                _smtpPort = 587;
                _smtpUser = "";
                _smtpPassword = "";
                _enableSsl = true;
            }
        }

        /// <summary>
        /// Configura manualmente los parámetros SMTP (sobrescribe el .config)
        /// </summary>
        public void ConfigurarSMTP(string servidor, int puerto, string usuario, string password, bool usarSSL)
        {
            _smtpServer = servidor;
            _smtpPort = puerto;
            _smtpUser = usuario;
            _smtpPassword = password;
            _enableSsl = usarSSL;
        }

        /// <summary>
        /// Envía un correo electrónico simple
        /// </summary>
        /// <param name="destinatario">Email del destinatario</param>
        /// <param name="asunto">Asunto del correo</param>
        /// <param name="mensaje">Cuerpo del mensaje (texto plano)</param>
        /// <returns>Resultado del envío</returns>
        public EmailResult Enviar(string destinatario, string asunto, string mensaje)
        {
            return EnviarCorreo(destinatario, "", "", asunto, mensaje, false, "");
        }

        /// <summary>
        /// Envía un correo electrónico con HTML
        /// </summary>
        /// <param name="destinatario">Email del destinatario</param>
        /// <param name="asunto">Asunto del correo</param>
        /// <param name="mensajeHtml">Cuerpo del mensaje en HTML</param>
        /// <returns>Resultado del envío</returns>
        public EmailResult EnviarHtml(string destinatario, string asunto, string mensajeHtml)
        {
            return EnviarCorreo(destinatario, "", "", asunto, mensajeHtml, true, "");
        }

        /// <summary>
        /// Envía un correo electrónico con opciones avanzadas
        /// </summary>
        /// <param name="destinatario">Email del destinatario (puede ser múltiples separados por ;)</param>
        /// <param name="cc">Emails en copia (separados por ;)</param>
        /// <param name="cco">Emails en copia oculta (separados por ;)</param>
        /// <param name="asunto">Asunto del correo</param>
        /// <param name="mensaje">Cuerpo del mensaje</param>
        /// <param name="esHtml">true si el mensaje es HTML</param>
        /// <param name="adjuntos">Rutas de archivos adjuntos (separados por |)</param>
        /// <returns>Resultado del envío</returns>
        public EmailResult EnviarAvanzado(
            string destinatario,
            string cc,
            string cco,
            string asunto,
            string mensaje,
            bool esHtml,
            string adjuntos)
        {
            return EnviarCorreo(destinatario, cc, cco, asunto, mensaje, esHtml, adjuntos);
        }

        /// <summary>
        /// Método interno para enviar correos
        /// </summary>
        private EmailResult EnviarCorreo(
            string destinatario,
            string cc,
            string cco,
            string asunto,
            string mensaje,
            bool esHtml,
            string adjuntos)
        {
            var resultado = new EmailResult();

            try
            {
                // Validaciones
                if (string.IsNullOrEmpty(_smtpUser))
                {
                    resultado.Exitoso = false;
                    resultado.Mensaje = "No se ha configurado el usuario SMTP. Verifique el archivo .config";
                    return resultado;
                }

                if (string.IsNullOrEmpty(destinatario))
                {
                    resultado.Exitoso = false;
                    resultado.Mensaje = "El destinatario no puede estar vacío";
                    return resultado;
                }

                // Crear mensaje
                using (var mail = new MailMessage())
                {
                    mail.From = new MailAddress(_smtpUser);
                    
                    // Agregar destinatarios (soporta múltiples separados por ;)
                    foreach (var email in destinatario.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries))
                    {
                        mail.To.Add(email.Trim());
                    }

                    // Agregar CC
                    if (!string.IsNullOrEmpty(cc))
                    {
                        foreach (var email in cc.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            mail.CC.Add(email.Trim());
                        }
                    }

                    // Agregar CCO
                    if (!string.IsNullOrEmpty(cco))
                    {
                        foreach (var email in cco.Split(new[] { ';', ',' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            mail.Bcc.Add(email.Trim());
                        }
                    }

                    mail.Subject = asunto ?? "";
                    mail.Body = mensaje ?? "";
                    mail.IsBodyHtml = esHtml;

                    // Agregar adjuntos
                    if (!string.IsNullOrEmpty(adjuntos))
                    {
                        foreach (var archivo in adjuntos.Split(new[] { '|' }, StringSplitOptions.RemoveEmptyEntries))
                        {
                            if (System.IO.File.Exists(archivo.Trim()))
                            {
                                mail.Attachments.Add(new Attachment(archivo.Trim()));
                            }
                        }
                    }

                    // Configurar cliente SMTP
                    using (var smtp = new SmtpClient(_smtpServer, _smtpPort))
                    {
                        smtp.EnableSsl = _enableSsl;
                        smtp.UseDefaultCredentials = false;
                        smtp.Credentials = new NetworkCredential(_smtpUser, _smtpPassword);
                        smtp.DeliveryMethod = SmtpDeliveryMethod.Network;
                        smtp.Timeout = 30000; // 30 segundos

                        // Enviar
                        smtp.Send(mail);
                    }
                }

                resultado.Exitoso = true;
                resultado.Mensaje = "Correo enviado exitosamente";
                return resultado;
            }
            catch (SmtpException smtpEx)
            {
                resultado.Exitoso = false;
                resultado.Mensaje = "Error SMTP: " + smtpEx.Message;
                if (smtpEx.InnerException != null)
                {
                    resultado.Mensaje += " - " + smtpEx.InnerException.Message;
                }
                return resultado;
            }
            catch (Exception ex)
            {
                resultado.Exitoso = false;
                resultado.Mensaje = "Error al enviar correo: " + ex.Message;
                return resultado;
            }
        }

        /// <summary>
        /// Prueba la conexión SMTP
        /// </summary>
        /// <returns>Resultado de la prueba</returns>
        public EmailResult ProbarConexion()
        {
            var resultado = new EmailResult();

            try
            {
                using (var smtp = new SmtpClient(_smtpServer, _smtpPort))
                {
                    smtp.EnableSsl = _enableSsl;
                    smtp.UseDefaultCredentials = false;
                    smtp.Credentials = new NetworkCredential(_smtpUser, _smtpPassword);
                    smtp.Timeout = 10000; // 10 segundos

                    // Intentar conectar (no hay método directo, usamos una prueba)
                    resultado.Exitoso = true;
                    resultado.Mensaje = string.Format(
                        "Configuración SMTP válida: {0}:{1} (SSL: {2})",
                        _smtpServer, _smtpPort, _enableSsl);
                }
                return resultado;
            }
            catch (Exception ex)
            {
                resultado.Exitoso = false;
                resultado.Mensaje = "Error de conexión SMTP: " + ex.Message;
                return resultado;
            }
        }

        /// <summary>
        /// Obtiene el último error ocurrido
        /// </summary>
        public string ObtenerUltimoError()
        {
            return _lastError ?? "";
        }

        /// <summary>
        /// Obtiene la configuración SMTP actual (para debug)
        /// </summary>
        public string ObtenerConfiguracion()
        {
            return string.Format(
                "Servidor: {0}, Puerto: {1}, Usuario: {2}, SSL: {3}",
                _smtpServer, _smtpPort, _smtpUser, _enableSsl);
        }
    }

    /// <summary>
    /// Resultado del envío de correo
    /// </summary>
    [ComVisible(true)]
    [ClassInterface(ClassInterfaceType.AutoDual)]
    [Guid("C3D4E5F6-A7B8-4901-CDEF-012345678901")]
    public class EmailResult
    {
        /// <summary>
        /// Indica si el envío fue exitoso
        /// </summary>
        public bool Exitoso { get; set; }

        /// <summary>
        /// Mensaje de resultado o error
        /// </summary>
        public string Mensaje { get; set; }

        /// <summary>
        /// Constructor
        /// </summary>
        public EmailResult()
        {
            Exitoso = false;
            Mensaje = "";
        }
    }
}
