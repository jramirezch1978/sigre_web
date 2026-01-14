using System;
using System.IO;
using Newtonsoft.Json;

namespace SigreWebServiceWrapper
{
    /// <summary>
    /// Gestiona el token JWT de forma automática:
    /// - Lo guarda en disco para persistencia
    /// - Lo renueva automáticamente cuando expira
    /// - PowerBuilder solo necesita llamar a ConsultarRuc sin preocuparse del token
    /// </summary>
    public class TokenManager
    {
        private static readonly object _lock = new object();
        private static TokenData _cachedToken = null;
        private static string _tokenFile = null;

        // Credenciales guardadas para renovación automática
        private static string _usuario = null;
        private static string _clave = null;
        private static string _empresa = null;

        /// <summary>
        /// Ruta del archivo donde se guarda el token
        /// </summary>
        private static string TokenFile
        {
            get
            {
                if (_tokenFile == null)
                {
                    try
                    {
                        string dllPath = typeof(TokenManager).Assembly.Location;
                        string dllDir = Path.GetDirectoryName(dllPath);
                        _tokenFile = Path.Combine(dllDir, "token.json");
                    }
                    catch
                    {
                        _tokenFile = Path.Combine(Path.GetTempPath(), "SigreWebServiceWrapper_token.json");
                    }
                }
                return _tokenFile;
            }
        }

        /// <summary>
        /// Configura las credenciales para obtener/renovar el token automáticamente
        /// </summary>
        public static void Configurar(string usuario, string clave, string empresa)
        {
            lock (_lock)
            {
                _usuario = usuario;
                _clave = clave;
                _empresa = empresa;
                Logger.Debug($"TokenManager: Credenciales configuradas para usuario={usuario}, empresa={empresa}");
            }
        }

        /// <summary>
        /// Obtiene un token válido. Si no existe o expiró, lo obtiene/renueva automáticamente.
        /// </summary>
        /// <returns>Token JWT válido o null si hay error</returns>
        public static string ObtenerTokenValido()
        {
            lock (_lock)
            {
                // 1. Intentar usar el token en caché
                if (_cachedToken != null && !_cachedToken.EstaExpirado())
                {
                    Logger.Debug("TokenManager: Usando token en caché");
                    return _cachedToken.Token;
                }

                // 2. Intentar cargar token del archivo
                if (CargarTokenDeArchivo())
                {
                    if (_cachedToken != null && !_cachedToken.EstaExpirado())
                    {
                        Logger.Debug("TokenManager: Usando token de archivo");
                        return _cachedToken.Token;
                    }
                }

                // 3. Obtener nuevo token si tenemos credenciales
                if (!string.IsNullOrEmpty(_usuario) && !string.IsNullOrEmpty(_clave))
                {
                    return RenovarToken();
                }

                Logger.Error("TokenManager: No hay token válido ni credenciales configuradas");
                return null;
            }
        }

        /// <summary>
        /// Obtiene un nuevo token y lo guarda
        /// </summary>
        private static string RenovarToken()
        {
            try
            {
                Logger.Info($"TokenManager: Obteniendo nuevo token para usuario={_usuario}");
                
                var restClient = new ConsultaRUCRest();
                string tokenResponse = restClient.ObtenerToken(_usuario, _clave, _empresa);

                if (tokenResponse != null && !tokenResponse.StartsWith("ERROR:"))
                {
                    // Guardar token con expiración (15 minutos menos 1 minuto de margen)
                    _cachedToken = new TokenData
                    {
                        Token = tokenResponse,
                        FechaExpiracion = DateTime.Now.AddMinutes(14), // 14 min para tener margen
                        Usuario = _usuario,
                        Empresa = _empresa
                    };

                    GuardarTokenEnArchivo();
                    Logger.Info("TokenManager: Nuevo token obtenido y guardado");
                    return tokenResponse;
                }
                else
                {
                    Logger.Error($"TokenManager: Error al obtener token - {tokenResponse}");
                    return null;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("TokenManager: Excepción al renovar token", ex);
                return null;
            }
        }

        /// <summary>
        /// Carga el token del archivo en disco
        /// </summary>
        private static bool CargarTokenDeArchivo()
        {
            try
            {
                if (File.Exists(TokenFile))
                {
                    string json = File.ReadAllText(TokenFile);
                    _cachedToken = JsonConvert.DeserializeObject<TokenData>(json);
                    
                    // Restaurar credenciales si estaban guardadas
                    if (_cachedToken != null)
                    {
                        if (string.IsNullOrEmpty(_usuario) && !string.IsNullOrEmpty(_cachedToken.Usuario))
                        {
                            _usuario = _cachedToken.Usuario;
                        }
                        if (string.IsNullOrEmpty(_empresa) && !string.IsNullOrEmpty(_cachedToken.Empresa))
                        {
                            _empresa = _cachedToken.Empresa;
                        }
                    }
                    
                    return true;
                }
            }
            catch (Exception ex)
            {
                Logger.Error("TokenManager: Error al cargar token de archivo", ex);
            }
            return false;
        }

        /// <summary>
        /// Guarda el token en archivo
        /// </summary>
        private static void GuardarTokenEnArchivo()
        {
            try
            {
                string json = JsonConvert.SerializeObject(_cachedToken, Formatting.Indented);
                File.WriteAllText(TokenFile, json);
            }
            catch (Exception ex)
            {
                Logger.Error("TokenManager: Error al guardar token en archivo", ex);
            }
        }

        /// <summary>
        /// Invalida el token actual (fuerza renovación en la próxima llamada)
        /// </summary>
        public static void Invalidar()
        {
            lock (_lock)
            {
                _cachedToken = null;
                try
                {
                    if (File.Exists(TokenFile))
                    {
                        File.Delete(TokenFile);
                    }
                }
                catch { }
                Logger.Info("TokenManager: Token invalidado");
            }
        }

        /// <summary>
        /// Verifica si hay un token válido disponible
        /// </summary>
        public static bool TieneTokenValido()
        {
            lock (_lock)
            {
                if (_cachedToken != null && !_cachedToken.EstaExpirado())
                {
                    return true;
                }
                
                CargarTokenDeArchivo();
                return _cachedToken != null && !_cachedToken.EstaExpirado();
            }
        }

        /// <summary>
        /// Obtiene información del token actual (para debug)
        /// </summary>
        public static string ObtenerInfoToken()
        {
            lock (_lock)
            {
                if (_cachedToken == null)
                {
                    CargarTokenDeArchivo();
                }

                if (_cachedToken == null)
                {
                    return "{\"existe\":false}";
                }

                return JsonConvert.SerializeObject(new
                {
                    existe = true,
                    usuario = _cachedToken.Usuario,
                    empresa = _cachedToken.Empresa,
                    expira = _cachedToken.FechaExpiracion.ToString("yyyy-MM-dd HH:mm:ss"),
                    expirado = _cachedToken.EstaExpirado(),
                    minutosRestantes = _cachedToken.EstaExpirado() ? 0 : 
                        (int)(_cachedToken.FechaExpiracion - DateTime.Now).TotalMinutes
                });
            }
        }
    }

    /// <summary>
    /// Datos del token guardados en disco
    /// </summary>
    internal class TokenData
    {
        public string Token { get; set; }
        public DateTime FechaExpiracion { get; set; }
        public string Usuario { get; set; }
        public string Empresa { get; set; }
        // No guardamos la clave por seguridad

        public bool EstaExpirado()
        {
            return DateTime.Now >= FechaExpiracion;
        }
    }
}
