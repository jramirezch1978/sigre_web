using System;
using System.Runtime.InteropServices;
using System.Text;
using RGiesecke.DllExport;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Funciones exportadas para uso directo desde PowerBuilder
    /// Usar con: FUNCTION string NombreFuncion(...) LIBRARY "SigreWebServiceWrapper.dll"
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

                return FormatResult(resultado.Exitoso, resultado.Mensaje);
            }
            catch (Exception ex)
            {
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

        private static ConsultaRUCRest _restClient = null;

        /// <summary>
        /// Obtiene un token JWT
        /// PowerBuilder: FUNCTION string ObtenerTokenRest(string usuario, string clave, string empresa) LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("ObtenerTokenRest", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerTokenRest(
            [MarshalAs(UnmanagedType.LPWStr)] string usuario,
            [MarshalAs(UnmanagedType.LPWStr)] string clave,
            [MarshalAs(UnmanagedType.LPWStr)] string empresa)
        {
            try
            {
                if (_restClient == null)
                {
                    _restClient = new ConsultaRUCRest();
                }

                string token = _restClient.ObtenerToken(usuario ?? "", clave ?? "", empresa ?? "");
                return token ?? "ERROR: Token nulo";
            }
            catch (Exception ex)
            {
                return "ERROR: " + ex.Message;
            }
        }

        /// <summary>
        /// Consulta RUC usando token previamente obtenido
        /// PowerBuilder: FUNCTION string ConsultarRucRest(string ruc, string rucOrigen, string computerName) LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("ConsultarRucRest", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ConsultarRucRest(
            [MarshalAs(UnmanagedType.LPWStr)] string rucConsulta,
            [MarshalAs(UnmanagedType.LPWStr)] string rucOrigen,
            [MarshalAs(UnmanagedType.LPWStr)] string computerName)
        {
            try
            {
                if (_restClient == null)
                {
                    return "{\"exitoso\":false,\"mensaje\":\"Debe llamar primero a ObtenerTokenRest\"}";
                }

                var resultado = _restClient.ConsultarRUC(
                    rucConsulta ?? "",
                    rucOrigen ?? "",
                    computerName ?? "");

                return PadronRucToJson(resultado);
            }
            catch (Exception ex)
            {
                return FormatResult(false, "Error: " + ex.Message);
            }
        }

        /// <summary>
        /// Consulta RUC en un solo paso
        /// PowerBuilder: FUNCTION string ConsultarRucCompleto(string ruc, string rucOrigen, string usuario, string clave, string empresa, string computer) LIBRARY "SigreWebServiceWrapper.dll"
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

        /// <summary>
        /// Verifica si hay token válido
        /// PowerBuilder: FUNCTION long TieneTokenValido() LIBRARY "SigreWebServiceWrapper.dll"
        /// Retorna: 1 = válido, 0 = no válido
        /// </summary>
        [DllExport("TieneTokenValido", CallingConvention = CallingConvention.StdCall)]
        public static int TieneTokenValido()
        {
            if (_restClient == null) return 0;
            return _restClient.TieneTokenValido() ? 1 : 0;
        }

        /// <summary>
        /// Invalida el token actual
        /// PowerBuilder: SUBROUTINE InvalidarToken() LIBRARY "SigreWebServiceWrapper.dll"
        /// </summary>
        [DllExport("InvalidarToken", CallingConvention = CallingConvention.StdCall)]
        public static void InvalidarToken()
        {
            if (_restClient != null)
            {
                _restClient.InvalidarToken();
            }
        }

        /// <summary>
        /// Versión del DLL
        /// </summary>
        [DllExport("ObtenerVersion", CallingConvention = CallingConvention.StdCall)]
        [return: MarshalAs(UnmanagedType.LPWStr)]
        public static string ObtenerVersion()
        {
            return "1.0.0";
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
