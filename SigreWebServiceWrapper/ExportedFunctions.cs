using System;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Funciones exportadas para uso directo desde PowerBuilder
    /// Usar con: FUNCTION string NombreFuncion(...) LIBRARY "SigreWebServiceWrapper.dll"
    /// 
    /// FLUJO RECOMENDADO PARA CONSULTA RUC:
    /// 1. Al iniciar la aplicación: ConfigurarCredencialesRuc(usuario, clave, empresa)
    /// 2. Cada consulta: ConsultarRuc(ruc, rucOrigen, computerName)
    ///    - El DLL maneja automáticamente el token JWT
    ///    - Si el token expiró, lo renueva automáticamente
    ///    - El token se guarda en disco para persistir entre sesiones
    /// </summary>
    public static class ExportedFunctions
    {
        // ============================================================
        //                    SERVICIO DE EMAIL
        // ============================================================

        /// <summary>
        /// Envía un correo electrónico
        /// PowerBuilder: FUNCTION string EnviarCorreo(string dest, string nombres, string asunto, string msg, boolean html, string adj) LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("EnviarCorreo", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string EnviarCorreo(
            [MarshalAs(UnmanagedType.LPWStr)] string destinatarios,
            [MarshalAs(UnmanagedType.LPWStr)] string nombresDestinatarios,
            [MarshalAs(UnmanagedType.LPWStr)] string asunto,
            [MarshalAs(UnmanagedType.LPWStr)] string mensaje,
            [MarshalAs(UnmanagedType.Bool)] bool esHtml,
            [MarshalAs(UnmanagedType.LPWStr)] string adjuntos)
        {
            Logger.Info("EnviarCorreo: destinatarios=" + (destinatarios ?? "null") + ", asunto=" + (asunto ?? "null"));
            try
            {
                var emailService = new EmailService();
                var resultado = emailService.EnviarCorreoCompleto(
                    destinatarios ?? "",
                    nombresDestinatarios ?? "",
                    "", // CC
                    "", // CCO
                    asunto ?? "",
                    mensaje ?? "",
                    esHtml,
                    adjuntos ?? "");

                if (resultado.Exitoso)
                {
                    Logger.Info("EnviarCorreo: " + resultado.Mensaje);
                }
                else
                {
                    Logger.Error("EnviarCorreo: " + resultado.Mensaje);
                }

                return FormatResult(resultado.Exitoso, resultado.Mensaje);
            }
            catch (Exception ex)
            {
                Logger.Error("EnviarCorreo exception", ex);
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Envía un correo con CC y CCO
        /// </summary>
        [DllExport("EnviarCorreoAvanzado", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string EnviarCorreoAvanzado(
            [MarshalAs(UnmanagedType.LPWStr)] string destinatarios,
            [MarshalAs(UnmanagedType.LPWStr)] string nombresDestinatarios,
            [MarshalAs(UnmanagedType.LPWStr)] string cc,
            [MarshalAs(UnmanagedType.LPWStr)] string cco,
            [MarshalAs(UnmanagedType.LPWStr)] string asunto,
            [MarshalAs(UnmanagedType.LPWStr)] string mensaje,
            [MarshalAs(UnmanagedType.Bool)] bool esHtml,
            [MarshalAs(UnmanagedType.LPWStr)] string adjuntos)
        {
            try
            {
                var emailService = new EmailService();
                var resultado = emailService.EnviarCorreoCompleto(
                    destinatarios ?? "",
                    nombresDestinatarios ?? "",
                    cc ?? "",
                    cco ?? "",
                    asunto ?? "",
                    mensaje ?? "",
                    esHtml,
                    adjuntos ?? "");

                return FormatResult(resultado.Exitoso, resultado.Mensaje);
            }
            catch (Exception ex)
            {
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        // ============================================================
        //                    SERVICIO REST RUC
        // ============================================================
        //
        // FLUJO AUTOMÁTICO:
        // 1. ConfigurarCredencialesRuc() - Una vez al iniciar app
        // 2. ConsultarRuc() - El DLL maneja token automáticamente
        //
        // El token se guarda en: [Carpeta DLL]\token.json
        // Se renueva automáticamente cuando expira (cada 15 min)
        //
        // ============================================================

        private static ConsultaRUCRest _restClient = null;

        /// <summary>
        /// Configura las credenciales para consultas RUC REST.
        /// Llamar UNA VEZ al iniciar la aplicación.
        /// Las credenciales se guardan y el token se renueva automáticamente.
        /// 
        /// PowerBuilder: FUNCTION string ConfigurarCredencialesRuc(string usuario, string clave, string empresa) LIBRARY "SigreWebServiceWrapper.dll"
        /// 
        /// Retorna: {"exitoso":true} o {"exitoso":false,"mensaje":"..."}
        /// </summary>
        [DllExport("ConfigurarCredencialesRuc", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ConfigurarCredencialesRuc(
            [MarshalAs(UnmanagedType.LPWStr)] string usuario,
            [MarshalAs(UnmanagedType.LPWStr)] string clave,
            [MarshalAs(UnmanagedType.LPWStr)] string empresa)
        {
            Logger.Info("ConfigurarCredencialesRuc: usuario=" + (usuario ?? "null") + ", empresa=" + (empresa ?? "null"));
            try
            {
                if (string.IsNullOrEmpty(usuario) || string.IsNullOrEmpty(clave) || string.IsNullOrEmpty(empresa))
                {
                    return FormatResult(false, "Usuario, clave y empresa son requeridos");
                }

                // Configurar TokenManager
                TokenManager.Configurar(usuario, clave, empresa);

                // Inicializar cliente REST
                if (_restClient == null)
                {
                    _restClient = new ConsultaRUCRest();
                }

                Logger.Info("ConfigurarCredencialesRuc: Credenciales configuradas correctamente");
                return FormatResult(true, "Credenciales configuradas correctamente");
            }
            catch (Exception ex)
            {
                Logger.Error("ConfigurarCredencialesRuc exception", ex);
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Consulta RUC usando el servicio REST.
        /// El token se maneja AUTOMÁTICAMENTE:
        /// - Si no hay token, lo obtiene
        /// - Si el token expiró, lo renueva
        /// - El token se guarda en disco
        /// 
        /// REQUISITO: Llamar ConfigurarCredencialesRuc() primero (una vez al iniciar app)
        /// 
        /// PowerBuilder: FUNCTION string ConsultarRuc(string ruc, string rucOrigen, string computerName) LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("ConsultarRuc", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ConsultarRuc(
            [MarshalAs(UnmanagedType.LPWStr)] string rucConsulta,
            [MarshalAs(UnmanagedType.LPWStr)] string rucOrigen,
            [MarshalAs(UnmanagedType.LPWStr)] string computerName)
        {
            Logger.Info("ConsultarRuc: ruc=" + (rucConsulta ?? "null"));
            try
            {
                // Obtener token válido (automáticamente renueva si expiró)
                string token = TokenManager.ObtenerTokenValido();
                
                if (string.IsNullOrEmpty(token))
                {
                    Logger.Error("ConsultarRuc: No hay token válido. Llame ConfigurarCredencialesRuc primero.");
                    return FormatResult(false, "No hay token válido. Configure las credenciales con ConfigurarCredencialesRuc");
                }

                if (_restClient == null)
                {
                    _restClient = new ConsultaRUCRest();
                }

                // Establecer el token en el cliente
                _restClient.EstablecerToken(token);

                var resultado = _restClient.ConsultarRUC(
                    rucConsulta ?? "",
                    rucOrigen ?? "",
                    computerName ?? "");

                if (resultado.IsOk)
                {
                    Logger.Info("ConsultarRuc: RUC encontrado - " + resultado.RazonSocial);
                }
                else
                {
                    Logger.Warn("ConsultarRuc: " + resultado.Mensaje);
                }

                return PadronRucToJson(resultado);
            }
            catch (Exception ex)
            {
                Logger.Error("ConsultarRuc exception", ex);
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Obtiene información del estado actual del token (para debug/diagnóstico)
        /// 
        /// PowerBuilder: FUNCTION string ObtenerInfoToken() LIBRARY "SigreWebServiceWrapper.dll"
        /// 
        /// Retorna JSON:
        /// {
        ///   "existe": true/false,
        ///   "usuario": "sigre",
        ///   "empresa": "TRANSMARINA",
        ///   "expira": "2026-01-14 12:30:00",
        ///   "expirado": false,
        ///   "minutosRestantes": 12
        /// }
        /// </summary>
        [DllExport("ObtenerInfoToken", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerInfoToken()
        {
            return TokenManager.ObtenerInfoToken();
        }

        /// <summary>
        /// Fuerza renovación del token (útil si hay problemas de autenticación)
        /// 
        /// PowerBuilder: SUBROUTINE ForzarRenovacionToken() LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("ForzarRenovacionToken", CallingConvention = CallingConvention.StdCall)]
        public static void ForzarRenovacionToken()
        {
            Logger.Info("ForzarRenovacionToken: Invalidando token actual");
            TokenManager.Invalidar();
        }

        // ============================================================
        //           FUNCIONES LEGACY (para compatibilidad)
        // ============================================================

        /// <summary>
        /// [LEGACY] Obtiene un token JWT manualmente
        /// NOTA: Usar ConfigurarCredencialesRuc + ConsultarRuc es más fácil
        /// </summary>
        [DllExport("ObtenerTokenRest", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerTokenRest(
            [MarshalAs(UnmanagedType.LPWStr)] string usuario,
            [MarshalAs(UnmanagedType.LPWStr)] string clave,
            [MarshalAs(UnmanagedType.LPWStr)] string empresa)
        {
            Logger.Info("ObtenerTokenRest: usuario=" + (usuario ?? "null"));
            try
            {
                // También configuramos TokenManager para futuras consultas
                TokenManager.Configurar(usuario ?? "", clave ?? "", empresa ?? "");
                
                if (_restClient == null)
                {
                    _restClient = new ConsultaRUCRest();
                }

                string token = _restClient.ObtenerToken(usuario ?? "", clave ?? "", empresa ?? "");
                
                if (token != null && !token.StartsWith("ERROR:"))
                {
                    Logger.Info("ObtenerTokenRest: Token obtenido exitosamente");
                }
                else
                {
                    Logger.Error("ObtenerTokenRest: " + (token ?? "null"));
                }
                
                return token ?? "ERROR: Token nulo";
            }
            catch (Exception ex)
            {
                Logger.Error("ObtenerTokenRest exception", ex);
                return "ERROR: " + ex.Message;
            }
        }

        /// <summary>
        /// [LEGACY] Consulta RUC en un solo paso (obtiene token + consulta)
        /// NOTA: Usar ConfigurarCredencialesRuc + ConsultarRuc es más eficiente
        /// </summary>
        [DllExport("ConsultarRucCompleto", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ConsultarRucCompleto(
            [MarshalAs(UnmanagedType.LPWStr)] string rucConsulta,
            [MarshalAs(UnmanagedType.LPWStr)] string rucOrigen,
            [MarshalAs(UnmanagedType.LPWStr)] string usuario,
            [MarshalAs(UnmanagedType.LPWStr)] string clave,
            [MarshalAs(UnmanagedType.LPWStr)] string empresa,
            [MarshalAs(UnmanagedType.LPWStr)] string computerName)
        {
            try
            {
                // Configurar credenciales
                TokenManager.Configurar(usuario ?? "", clave ?? "", empresa ?? "");
                
                if (_restClient == null)
                {
                    _restClient = new ConsultaRUCRest();
                }

                var resultado = _restClient.ConsultarRUCCompleto(
                    rucConsulta ?? "",
                    rucOrigen ?? "",
                    usuario ?? "",
                    clave ?? "",
                    empresa ?? "",
                    computerName ?? "");

                return PadronRucToJson(resultado);
            }
            catch (Exception ex)
            {
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        // ============================================================
        //                    UTILIDADES
        // ============================================================

        /// <summary>
        /// Versión del DLL
        /// </summary>
        [DllExport("ObtenerVersion", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerVersion()
        {
            return "1.1.0";
        }

        /// <summary>
        /// Obtiene la ruta del archivo de log actual
        /// </summary>
        [DllExport("ObtenerRutaLog", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerRutaLog()
        {
            return Logger.GetLogPath();
        }

        /// <summary>
        /// Obtiene la ruta de la carpeta de logs
        /// </summary>
        [DllExport("ObtenerCarpetaLog", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerCarpetaLog()
        {
            return Logger.GetLogDir();
        }

        /// <summary>
        /// Obtiene la ruta de la carpeta de logs históricos
        /// </summary>
        [DllExport("ObtenerCarpetaLogHistorico", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerCarpetaLogHistorico()
        {
            return Logger.GetHistoricoDir();
        }

        /// <summary>
        /// Habilita o deshabilita el logging
        /// </summary>
        [DllExport("HabilitarLog", CallingConvention = CallingConvention.StdCall)]
        public static void HabilitarLog(int habilitado)
        {
            Logger.Enabled = (habilitado == 1);
        }

        /// <summary>
        /// Limpia el archivo de log actual
        /// </summary>
        [DllExport("LimpiarLog", CallingConvention = CallingConvention.StdCall)]
        public static void LimpiarLog()
        {
            Logger.Clear();
        }

        /// <summary>
        /// Limpia todos los logs históricos
        /// </summary>
        [DllExport("LimpiarLogHistorico", CallingConvention = CallingConvention.StdCall)]
        public static void LimpiarLogHistorico()
        {
            Logger.ClearHistorico();
        }

        // ============================================================
        //                    HELPERS
        // ============================================================

        private static string FormatResult(bool exitoso, string mensaje)
        {
            return string.Format("{{\"exitoso\":{0},\"mensaje\":\"{1}\"}}",
                exitoso ? "true" : "false",
                EscapeJson(mensaje ?? ""));
        }

        private static string EscapeJson(string s)
        {
            if (string.IsNullOrEmpty(s)) return "";
            return s.Replace("\\", "\\\\")
                    .Replace("\"", "\\\"")
                    .Replace("\r", "\\r")
                    .Replace("\n", "\\n")
                    .Replace("\t", "\\t");
        }

        private static string PadronRucToJson(PadronRUC p)
        {
            if (p == null)
            {
                return "{\"exitoso\":false,\"mensaje\":\"Respuesta nula\"}";
            }

            var sb = new StringBuilder();
            sb.Append("{");
            sb.AppendFormat("\"exitoso\":{0},", p.IsOk ? "true" : "false");
            sb.AppendFormat("\"mensaje\":\"{0}\",", EscapeJson(p.Mensaje));
            sb.AppendFormat("\"ruc\":\"{0}\",", EscapeJson(p.Ruc));
            sb.AppendFormat("\"razonSocial\":\"{0}\",", EscapeJson(p.RazonSocial));
            sb.AppendFormat("\"estado\":\"{0}\",", EscapeJson(p.Estado));
            sb.AppendFormat("\"condicion\":\"{0}\",", EscapeJson(p.Condicion));
            sb.AppendFormat("\"ubigeo\":\"{0}\",", EscapeJson(p.Ubigeo));
            sb.AppendFormat("\"direccionCompleta\":\"{0}\",", EscapeJson(p.ObtenerDireccionCompleta()));
            sb.AppendFormat("\"ubicacionCompleta\":\"{0}\"", EscapeJson(p.ObtenerUbicacionCompleta()));
            sb.Append("}");

            return sb.ToString();
        }
    }
}
